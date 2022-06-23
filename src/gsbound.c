#define DEBUG 0
/* note: EXTREMEZ > 3 + log(r) +  Z(1-alpha) + Z(1-beta)
   per bottom of p 349 in Jennison and Turnbull */
#define EXTREMEZ 20
#define MAXR 83

#include "R.h"
#include "Rmath.h"
#include "gsDesign.h"

/* Group sequential probability computation per Jennison & Turnbull
   xnanal- # of possible analyses in the group-sequential designs
            (interims + final)
   I     - statistical information available at each analysis
   a     - lower cutoff points for z statistic at each analysis (output)
   b     - upper cutoff points for z statistic at each analysis (output)
   probhi- input vector with probability of rejecting (Z>bj) at
           jth interim analysis, j=1...nanal
   problo- input vector with probability of rejecting (Z<aj) at
           jth interim analysis, j=1...nanal
    xtol  - relative change between iterations required to stop for 'convergence'
   xr    - determinant of # of grid points for numerical integration
           r=17 will give a max of 201 points which is what they recommend
    retval- error flag returned; 0 if convergence; 1 indicates error
    printerr- 1 if error messages to be printed - other values suppress printing
*/
void gsbound(int *xnanal, double *I, double *a, double *b, double *problo, double *probhi,
             double *xtol, int *xr, int *retval, int *printerr)
{
    int i, ii, j, m1, m2, r, nanal;
    double plo, phi, dplo, dphi, btem = 0., atem = 0., atem2, btem2, rtdeltak, rtIk, rtIkm1, xlo, xhi;
    double adelta, bdelta, tol;
    /* note: should allocat zwk & wwk dynamically...*/
    double zwk[1000], wwk[1000], hwk[1000], zwk2[1000], wwk2[1000], hwk2[1000],
        *z1, *z2, *w1, *w2, *h, *h2, *tem, rt2pi;
    void h1(double, int, double *, double, double *, double *);
    void hupdate(double, double *, int, double, double *, double *,
                 int, double, double *, double *);
    int gridpts(int, double, double, double, double *, double *);
    r = xr[0];
    nanal = xnanal[0];
    tol = xtol[0];
    rt2pi = 2.506628274631;
    /* compute bounds at 1st interim analysis using inverse normal */
    if (nanal < 1 || r < 1 || r > MAXR)
    {
        retval[0] = 1;
        if (*printerr)
        {
            Rprintf("gsbound error: illegal argument");
            if (nanal < 1)
                Rprintf("; nanal=%d--must be > 0", nanal);
            if (r < 1 || r > MAXR)
                Rprintf("; r=%d--must be >0 and <84", r);
            Rprintf("\n");
        }
        return;
    }
    if (problo[0] <= 0)
        a[0] = -EXTREMEZ;
    else
        a[0] = qnorm(problo[0], 0., 1., 1, 0);
    if (probhi[0] <= 0)
        b[0] = EXTREMEZ;
    else
        b[0] = qnorm(probhi[0], 0., 1., 0, 0);
    /* set up work vectors */
    z1 = zwk;
    w1 = wwk;
    h = hwk;
    z2 = zwk2;
    w2 = wwk2;
    h2 = hwk2;
    m1 = gridpts(r, 0., a[0], b[0], z1, w1);
    h1(0., m1, w1, I[0], z1, h);
    rtIk = sqrt(I[0]);
    /* use Newton-Raphson to find subsequent interim analysis cutpoints */
    for (i = 1; i < nanal; i++)
    { /* set up constants */
        rtIkm1 = rtIk;
        rtIk = sqrt(I[i]);
        rtdeltak = sqrt(I[i] - I[i - 1]);
        if (problo[i] <= 0.)
            atem2 = -EXTREMEZ;
        else
            atem2 = qnorm(problo[i], 0., 1., 1, 0);
        if (probhi[i] <= 0.)
            btem2 = EXTREMEZ;
        else
            btem2 = qnorm(probhi[i], 0., 1., 0, 0);
        adelta = 1.;
        bdelta = 1.;
        j = 0;
        while ((adelta > tol || bdelta > tol) && j++ < EXTREMEZ)
        {
            plo = 0.;
            phi = 0.;
            dplo = 0.;
            dphi = 0.;
            atem = atem2;
            btem = btem2;
            /* compute probability of crossing boundaries & their derivatives */
            for (ii = 0; ii <= m1; ii++)
            {
                xlo = (z1[ii] * rtIkm1 - atem * rtIk) / rtdeltak;
                xhi = (z1[ii] * rtIkm1 - btem * rtIk) / rtdeltak;
                plo += h[ii] * pnorm(xlo, 0., 1., 0, 0);
                phi += h[ii] * pnorm(xhi, 0., 1., 1, 0);
                dplo += h[ii] * exp(-xlo * xlo / 2) / rt2pi * rtIk / rtdeltak;
                dphi -= h[ii] * exp(-xhi * xhi / 2) / rt2pi * rtIk / rtdeltak;
            }
            /* use 1st order Taylor's series to update boundaries */
            /* maximum allowed change is 1 */
            /* maximum value allowed is z1[m1]*rtIk to keep within grid points */
            adelta = problo[i] - plo;
            if (adelta > dplo)
                atem2 = atem + 1.;
            else if (adelta < -dplo)
                atem2 = atem - 1.;
            else
                atem2 = atem + (problo[i] - plo) / dplo;
            if (atem2 > EXTREMEZ)
                atem2 = EXTREMEZ;
            else if (atem2 < -EXTREMEZ)
                atem2 = -EXTREMEZ;
            bdelta = probhi[i] - phi;
            if (bdelta < dphi)
                btem2 = btem + 1.;
            else if (bdelta > -dphi)
                btem2 = btem - 1.;
            else
                btem2 = btem + (probhi[i] - phi) / dphi;
            if (btem2 > EXTREMEZ)
                btem2 = EXTREMEZ;
            else if (btem2 < -EXTREMEZ)
                btem2 = -EXTREMEZ;
            if (atem2 > btem2)
                atem2 = btem2;
            adelta = atem2 - atem;
            if (adelta < 0)
                adelta = -adelta;
            bdelta = btem2 - btem;
            if (bdelta < 0)
                bdelta = -bdelta;
        }
        a[i] = atem;
        b[i] = btem;
        /* if convergence did not occur, set flag for return value */
        if (adelta > tol || bdelta > tol)
        {
            if (*printerr)
            {
                Rprintf("gsbound error: No convergence for boundary for interim %d; I=%7.0lf", i + 1, I[i]);
                if (bdelta > tol)
                    Rprintf("\n last 2 upper boundary values: %lf %lf\n", btem, btem2);
                if (adelta > tol)
                    Rprintf("\n last 2 lower boundary values: %lf %lf\n", atem, atem);
            }
            retval[0] = 1;
            return;
        }
        if (i < nanal - 1)
        {
            m2 = gridpts(r, 0., a[i], b[i], z2, w2);
            hupdate(0., w2, m1, I[i - 1], z1, h, m2, I[i], z2, h2);
            m1 = m2;
            tem = z1;
            z1 = z2;
            z2 = tem;
            tem = w1;
            w1 = w2;
            w2 = tem;
            tem = h;
            h = h2;
            h2 = tem;
        }
    }
    retval[0] = 0;
    return;
}

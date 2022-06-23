/**
 * @file gsdensity.c
 * @brief A short description of the file.
 * @author Keaven Anderson <keaven_anderson@merck.com>
 */

#include "R.h"
#include "Rmath.h"
#include "gsDesign.h"

/**
 * @brief Sub-density function (integrates to < 1) between bounds at
 * interim analysis for group sequential design.
 *
 * Optional full description of the function,
 * where blank lines start new paragraphs.
 *
 * @param den TBA
 * @param xnanal TBA
 * @param ntheta TBA
 * @param xtheta TBA
 * @param I TBA
 * @param a TBA
 * @param b TBA
 * @param xz TBA
 * @param zlen TBA
 * @param xr TBA
 *
 * @return Void.
 */
void gsdensity(double *den, int *xnanal, int *ntheta, double *xtheta,
               double *I, double *a, double *b, double *xz,
               int *zlen, int *xr)
{
    int r, i, j, k, m1, m2, nanal, nz;
    double z, mu, theta;
    double *zwk, *wwk, *hwk, *zwk2, *wwk2, *hwk2;
    double *z1, *z2, *w1, *w2, *h, *h2, *tem;
    void h1(double, int, double *, double, double *, double *);
    void hupdate(double, double *, int, double, double *, double *,
                 int, double, double *, double *);
    int gridpts(int, double, double, double, double *, double *);
    r = xr[0];
    nanal = xnanal[0];
    nz = zlen[0];
    /* if density is at 1st analysis, just return normal density */
    if (nanal < 1)
        return;
    if (nanal == 1)
    {
        j = 0;
        for (k = 0; k < ntheta[0]; k++)
        {
            mu = sqrt(I[0]) * xtheta[k];
            for (i = 0; i < nz; i++)
            {
                z = xz[i] - mu;
                den[j++] = exp(-z * z / 2) / 2.506628275;
            }
        }
        return;
    }
    /* otherwise, compute density like in probrej */
    zwk = (double *)R_alloc(r * 12 - 3, sizeof(double));
    wwk = (double *)R_alloc(r * 12 - 3, sizeof(double));
    hwk = (double *)R_alloc(r * 12 - 3, sizeof(double));
    zwk2 = (double *)R_alloc(r * 12 - 3, sizeof(double));
    wwk2 = (double *)R_alloc(r * 12 - 3, sizeof(double));
    hwk2 = (double *)R_alloc(r * 12 - 3, sizeof(double));
    for (k = 0; k < ntheta[0]; k++)
    {
        theta = xtheta[k];
        mu = theta * sqrt(I[0]);
        /* compute h1 */
        z1 = zwk;
        w1 = wwk;
        h = hwk;
        m1 = gridpts(r, mu, a[0], b[0], z1, w1);
        h1(theta, m1, w1, I[0], z1, h);
        z2 = zwk2;
        w2 = wwk2;
        h2 = hwk2;
        /* update h and compute rejection probabilities at each interim */
        for (i = 1; i < nanal; i++)
        {
            mu = theta * sqrt(I[i]);
            if (i < nanal - 1)
                m2 = gridpts(r, mu, a[i], b[i], z2, w2);
            else
            {
                m2 = nz - 1;
                z2 = xz;
                h2 = den + k * nz;
                for (j = 0; j < nz; j++)
                    w2[j] = 1.;
            }
            hupdate(theta, w2, m1, I[i - 1], z1, h, m2, I[i], z2, h2);
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
}

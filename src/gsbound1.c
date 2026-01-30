#define DEBUG 0
/*
 * Historically the code used finite truncation at +/-20 for the numerical
 * integration bounds. This value is still used as a "practically infinite"
 * sentinel for the public .C() interface, but the integration grid itself now
 * treats values at (or beyond) this sentinel as infinite.
 */
#define GSBOUND_Z_MAX_ABS 20.0
#define GSBOUND1_MAX_NR_ITER 20
#define MAXR 83
#include "R.h"
#include "Rmath.h"
#include "R_ext/Arith.h"
#include "gsDesign.h"

static double gsbound1_to_infinite(double z) {
  if (z <= -GSBOUND_Z_MAX_ABS)
    return R_NegInf;
  if (z >= GSBOUND_Z_MAX_ABS)
    return R_PosInf;
  return z;
}

/**
 * @brief Compute upper group sequential Z-boundaries given fixed lower
 * boundaries.
 *
 * For a given drift parameter @p xtheta and fixed lower cutoffs @p a, finds the
 * upper cutoffs @p b that match the target upper-tail crossing probabilities
 * @p probhi. The implied lower-tail crossing probabilities are returned in
 * @p problo. This routine is written with pointer arguments to support calling
 * via R's `.C()` interface.
 *
 * @param[in] xnanal Number of analyses (`nanal = xnanal[0]`).
 * @param[in] xtheta Drift parameter (`theta = xtheta[0]`).
 * @param[in] I Statistical information at each analysis (length `nanal`).
 * @param[in] a Fixed lower Z cutoffs at each analysis (length `nanal`).
 * @param[out] b Upper Z cutoffs at each analysis (length `nanal`).
 * @param[out] problo Output vector of lower-tail crossing probabilities (length
 *   `nanal`).
 * @param[in] probhi Target upper-tail crossing probabilities (length `nanal`).
 * @param[in] xtol Relative convergence tolerance (`tol = xtol[0]`).
 * @param[in] xr Grid parameter controlling the number of integration points
 *   (`r = xr[0]`).
 * @param[out] retval Error flag (`retval[0]`): 0 on success, 1 on illegal
 *   arguments or failure to converge.
 * @param[in] printerr If non-zero (`printerr[0] != 0`), print diagnostics via
 *   `Rprintf()`.
 * @return Nothing.
 */
void gsbound1(int *xnanal, double *xtheta, double *I, double *a, double *b,
              double *problo, double *probhi, double *xtol, int *xr,
              int *retval, int *printerr) {
  int i, ii, j, m1, m2, r, nanal;
  double plo = 0., phi, dphi, btem = 0., btem2, rtdeltak, rtIk, rtIkm1, xlo,
         xhi, theta, mu, tol, bdelta;
  /* note: should allocate zwk & wwk dynamically...*/
  double zwk[1000], wwk[1000], hwk[1000], zwk2[1000], wwk2[1000], hwk2[1000],
      *z1, *z2, *w1, *w2, *h, *h2, *tem;
  void h1(double, int, double *, double, double *, double *);
  void hupdate(double, double *, int, double, double *, double *, int, double,
               double *, double *);
  int gridpts(int, double, double, double, double *, double *);
  r = xr[0];
  nanal = xnanal[0];
  theta = xtheta[0];
  tol = xtol[0];
  if (nanal < 1 || r < 1 || r > MAXR) {
    retval[0] = 1;
    if (*printerr) {
      Rprintf("gsbound1 error: illegal argument");
      if (nanal < 1)
        Rprintf("; nanal=%d--must be > 0", nanal);
      if (r < 1 || r > MAXR)
        Rprintf("; r=%d--must be >0 and <84", r);
      Rprintf("\n");
    }
    return;
  }
  rtIk = sqrt(I[0]);
  mu = rtIk * theta; /* mean of normalized statistic at 1st interim */
  problo[0] = pnorm(mu - a[0], 0., 1., 0,
                    0); /* probability of crossing lower bound at 1st interim */
  if (probhi[0] <= 0.)
    b[0] = GSBOUND_Z_MAX_ABS;
  else
    b[0] = qnorm(probhi[0], mu, 1, 0, 0); /* upper bound at 1st interim */
  if (nanal == 1) {
    retval[0] = 0;
    return;
  }
  /* set up work vectors */
  z1 = zwk;
  w1 = wwk;
  h = hwk;
  z2 = zwk2;
  w2 = wwk2;
  h2 = hwk2;
  if (DEBUG)
    Rprintf("r=%d mu=%lf a[0]=%lf b[0]=%lf\n", r, mu, a[0], b[0]);
  m1 = gridpts(r, mu, gsbound1_to_infinite(a[0]), gsbound1_to_infinite(b[0]),
               z1, w1);
  h1(theta, m1, w1, I[0], z1, h);
  /* use Newton-Raphson to find subsequent interim analysis cutpoints */
  retval[0] = 0;
  for (i = 1; i < nanal; i++) {
    rtIkm1 = rtIk;
    rtIk = sqrt(I[i]);
    mu = rtIk * theta;
    rtdeltak = sqrt(I[i] - I[i - 1]);
    if (probhi[i] <= 0.)
      btem2 = GSBOUND_Z_MAX_ABS;
    else
      btem2 = qnorm(probhi[i], mu, 1., 0, 0);
    bdelta = 1.;
    j = 0;
    while ((bdelta > tol) && j++ < GSBOUND1_MAX_NR_ITER) {
      phi = 0.;
      dphi = 0.;
      plo = 0.;
      btem = btem2;
      if (DEBUG)
        Rprintf("i=%d m1=%d\n", i, m1);
      /* compute probability of crossing boundaries & their derivatives */
      for (ii = 0; ii <= m1; ii++) {
        xhi = (z1[ii] * rtIkm1 - btem * rtIk + theta * (I[i] - I[i - 1])) /
              rtdeltak;
        phi += pnorm(xhi, 0., 1., 1, 0) * h[ii];
        xlo = (z1[ii] * rtIkm1 - a[i] * rtIk + theta * (I[i] - I[i - 1])) /
              rtdeltak;
        plo += pnorm(xlo, 0., 1., 0, 0) * h[ii];
        dphi -= h[ii] * dnorm4(xhi, 0., 1., 0) * rtIk / rtdeltak;
        if (DEBUG)
          Rprintf("m1=%d ii=%d xhi=%lf phi=%lf xlo=%lf plo=%lf dphi=%lf\n", m1,
                  ii, xhi, phi, xlo, plo, dphi);
      }
      /* use 1st order Taylor's series to update boundaries */
      /* maximum allowed change is 1 */
      /* maximum value allowed is GSBOUND_Z_MAX_ABS */
      if (DEBUG)
        Rprintf("i=%2d j=%2d plo=%lf btem=%lf phi=%lf dphi=%lf\n", i, j, plo,
                btem, phi, dphi);
      bdelta = probhi[i] - phi;
      if (bdelta < dphi)
        btem2 = btem + 1.;
      else if (bdelta > -dphi)
        btem2 = btem - 1.;
      else
        btem2 = btem + (probhi[i] - phi) / dphi;
      if (btem2 > GSBOUND_Z_MAX_ABS)
        btem2 = GSBOUND_Z_MAX_ABS;
      else if (btem2 < -GSBOUND_Z_MAX_ABS)
        btem2 = -GSBOUND_Z_MAX_ABS;
      bdelta = btem2 - btem;
      if (bdelta < 0)
        bdelta = -bdelta;
    }
    b[i] = btem;
    problo[i] = plo;
    /* if convergence did not occur, set flag for return value */
    if (bdelta > tol) {
      if (*printerr)
        Rprintf("gsbound1 error: No convergence for boundary for interim %d; "
                "I=%7.0lf; last 2 upper boundary values: %lf %lf\n",
                i + 1, I[i], btem, btem2);
      retval[0] = 1;
    }
    if (i < nanal - 1) {
      m2 = gridpts(r, mu, gsbound1_to_infinite(a[i]), gsbound1_to_infinite(b[i]),
                   z2, w2);
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
  return;
}

#define DEBUG 0
/* Newton-Raphson iteration limit and iterate clamp (see gsbound.c). */
#define GS_MAXITER 20
#define GS_ZCLAMP 20.
#define MAXR 83
#include "R.h"
#include "Rmath.h"
#include "gsDesign.h"

/**
 * @brief Compute upper group sequential Z-boundaries given fixed lower
 * boundaries.
 *
 * For a given drift parameter @p xtheta and fixed lower cutoffs @p a, finds the
 * upper cutoffs @p b that match the target upper-tail crossing probabilities
 * @p probhi by Newton-Raphson iteration (Jennison & Turnbull, 2000, Section
 * 19.4.1). The implied lower-tail crossing probabilities are returned in
 * @p problo; they do not depend on the iterate and are evaluated once per
 * analysis. An analysis with a non-positive target has no upper bound: `+Inf`
 * is returned and the iteration is skipped. Lower cutoffs may be `-Inf`.
 * Written with pointer arguments for R's `.C()` interface (call with
 * `NAOK = TRUE`).
 *
 * @param[in] xnanal Number of analyses (`nanal = xnanal[0]`).
 * @param[in] xtheta Drift parameter (`theta = xtheta[0]`).
 * @param[in] I Statistical information at each analysis (length `nanal`).
 * @param[in] a Fixed lower Z cutoffs at each analysis (length `nanal`).
 * @param[out] b Upper Z cutoffs at each analysis (length `nanal`).
 * @param[out] problo Lower-tail crossing probabilities (length `nanal`).
 * @param[in] probhi Target upper-tail crossing probabilities (length `nanal`);
 *   a value `<= 0` means no upper bound.
 * @param[in] xtol Convergence tolerance on the bound (`tol = xtol[0]`).
 * @param[in] xr Grid parameter (`r = xr[0]`).
 * @param[out] retval Error flag: 0 on success, 1 on illegal arguments or
 *   failure to converge.
 * @param[in] printerr If non-zero, print diagnostics via `Rprintf()`.
 * @return Nothing.
 */
void gsbound1(int *xnanal, double *xtheta, double *I, double *a, double *b,
              double *problo, double *probhi, double *xtol, int *xr,
              int *retval, int *printerr) {
  int i, ii, j, m1, m2, r, nanal, hi_active;
  double plo, phi, dphi, btem = 0., btem2, rtdeltak, rtIk, rtIkm1, xlo, xhi,
                             theta, mu, tol, bdelta, drift, scale;
  /* note: should allocate zwk & wwk dynamically...*/
  double zwk[1000], wwk[1000], hwk[1000], zwk2[1000], wwk2[1000], hwk2[1000],
      *z1, *z2, *w1, *w2, *h, *h2, *tem;
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
  problo[0] = GS_PNORM_UPPER(mu - a[0]); /* crossing lower bound at 1st interim */
  if (probhi[0] <= 0.)
    b[0] = R_PosInf;
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
  m1 = gridpts(r, mu, a[0], b[0], z1, w1);
  h1(theta, m1, w1, I[0], z1, h);
  /* use Newton-Raphson to find subsequent interim analysis cutpoints */
  retval[0] = 0;
  for (i = 1; i < nanal; i++) {
    rtIkm1 = rtIk;
    rtIk = sqrt(I[i]);
    mu = rtIk * theta;
    rtdeltak = sqrt(I[i] - I[i - 1]);
    drift = theta * (I[i] - I[i - 1]);
    scale = gs_inv_sqrt_2pi * rtIk / rtdeltak;
    hi_active = probhi[i] > 0.;
    btem2 = hi_active ? qnorm(probhi[i], mu, 1., 0, 0) : R_PosInf;
    btem = btem2;
    bdelta = hi_active ? 1. : 0.;
    j = 0;
    while ((bdelta > tol) && j++ < GS_MAXITER) {
      phi = 0.;
      dphi = 0.;
      btem = btem2;
      /* compute probability of crossing the upper boundary & its derivative */
      for (ii = 0; ii <= m1; ii++) {
        xhi = (z1[ii] * rtIkm1 - btem * rtIk + drift) / rtdeltak;
        phi += GS_PNORM_LOWER(xhi) * h[ii];
        dphi -= h[ii] * exp(-xhi * xhi / 2);
      }
      dphi *= scale;
      /* use 1st order Taylor's series to update boundaries */
      /* maximum allowed change is 1 */
      /* an exact hit (or a vanishing derivative) leaves the iterate unchanged */
      bdelta = probhi[i] - phi;
      if (bdelta < dphi)
        btem2 = btem + 1.;
      else if (bdelta > -dphi)
        btem2 = btem - 1.;
      else if (bdelta == 0.)
        btem2 = btem;
      else
        btem2 = btem + bdelta / dphi;
      if (btem2 > GS_ZCLAMP)
        btem2 = GS_ZCLAMP;
      else if (btem2 < -GS_ZCLAMP)
        btem2 = -GS_ZCLAMP;
      bdelta = fabs(btem2 - btem);
    }
    /* lower-tail crossing probability for the fixed lower bound */
    plo = 0.;
    for (ii = 0; ii <= m1; ii++) {
      xlo = (z1[ii] * rtIkm1 - a[i] * rtIk + drift) / rtdeltak;
      plo += GS_PNORM_UPPER(xlo) * h[ii];
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
      m2 = gridpts(r, mu, a[i], b[i], z2, w2);
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

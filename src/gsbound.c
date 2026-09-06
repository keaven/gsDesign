#define DEBUG 0
/* Maximum number of Newton-Raphson iterations per analysis, and the clamp on
   the Newton iterates. Historically one constant (EXTREMEZ = 20) served both
   purposes and also stood in for an absent bound; an absent bound is now
   represented by -Inf/+Inf. The clamp only acts when a target probability
   cannot be attained (for example when boundaries cross), where it keeps the
   iterate finite so that the calling R code can repair the design. */
#define GS_MAXITER 20
#define GS_ZCLAMP 20.
#define MAXR 83
#include "R.h"
#include "Rmath.h"
#include "gsDesign.h"

/**
 * @brief Compute group sequential Z-boundaries from target crossing
 * probabilities under the null hypothesis.
 *
 * Newton-Raphson iteration for lower and upper Z cutoffs at each analysis
 * (Jennison & Turnbull, 2000, Section 19.4.1). An analysis with a
 * non-positive target probability has no bound on that side: the cutoff is
 * returned as `-Inf` (lower) or `+Inf` (upper) and the iteration is skipped
 * for that side. Written with pointer arguments for R's `.C()` interface
 * (call with `NAOK = TRUE`).
 *
 * @param[in] xnanal Number of analyses (`nanal = xnanal[0]`).
 * @param[in] I Statistical information at each analysis (length `nanal`).
 * @param[out] a Lower Z cutoffs at each analysis (length `nanal`).
 * @param[out] b Upper Z cutoffs at each analysis (length `nanal`).
 * @param[in] problo Target lower crossing probabilities; `<= 0` means no
 *   lower bound at that analysis.
 * @param[in] probhi Target upper crossing probabilities; `<= 0` means no
 *   upper bound at that analysis.
 * @param[in] xtol Convergence tolerance on the bounds (`tol = xtol[0]`).
 * @param[in] xr Grid parameter (`r = xr[0]`).
 * @param[out] retval Error flag: 0 on success, 1 on illegal arguments or
 *   failure to converge.
 * @param[in] printerr If non-zero, print diagnostics via `Rprintf()`.
 * @param[in] method Quadrature method (`GS_QUAD_JT` or `GS_QUAD_GL`).
 * @return Nothing.
 */
void gsbound(int *xnanal, double *I, double *a, double *b, double *problo,
             double *probhi, double *xtol, int *xr, int *retval,
             int *printerr, int *method) {
  int i, ii, j, m1, m2, r, nanal, lo_active, hi_active, meth;
  double plo, phi, dplo, dphi, btem = 0., atem = 0., atem2, btem2, rtdeltak,
                               rtIk, rtIkm1, xlo, xhi, scale, sig;
  double adelta, bdelta, tol;
  /* note: should allocate zwk & wwk dynamically...*/
  double zwk[1000], wwk[1000], hwk[1000], zwk2[1000], wwk2[1000], hwk2[1000],
      *z1, *z2, *w1, *w2, *h, *h2, *tem;
  r = xr[0];
  nanal = xnanal[0];
  tol = xtol[0];
  meth = method[0];
  /* compute bounds at 1st interim analysis using inverse normal */
  if (nanal < 1 || r < 1 || r > MAXR) {
    retval[0] = 1;
    if (*printerr) {
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
    a[0] = R_NegInf;
  else
    a[0] = qnorm(problo[0], 0., 1., 1, 0);
  if (probhi[0] <= 0)
    b[0] = R_PosInf;
  else
    b[0] = qnorm(probhi[0], 0., 1., 0, 0);
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
  sig = gs_kernel_width(I, 0, nanal);
  m1 = gsgrid(meth, r, 0., a[0], b[0], sig, z1, w1);
  h1(0., m1, w1, I[0], z1, h);
  rtIk = sqrt(I[0]);
  /* use Newton-Raphson to find subsequent interim analysis cutpoints */
  for (i = 1; i < nanal; i++) { /* set up constants */
    rtIkm1 = rtIk;
    rtIk = sqrt(I[i]);
    rtdeltak = sqrt(I[i] - I[i - 1]);
    scale = gs_inv_sqrt_2pi * rtIk / rtdeltak;
    lo_active = problo[i] > 0.;
    hi_active = probhi[i] > 0.;
    atem2 = lo_active ? qnorm(problo[i], 0., 1., 1, 0) : R_NegInf;
    btem2 = hi_active ? qnorm(probhi[i], 0., 1., 0, 0) : R_PosInf;
    atem = atem2;
    btem = btem2;
    adelta = lo_active ? 1. : 0.;
    bdelta = hi_active ? 1. : 0.;
    j = 0;
    while ((adelta > tol || bdelta > tol) && j++ < GS_MAXITER) {
      plo = 0.;
      phi = 0.;
      dplo = 0.;
      dphi = 0.;
      atem = atem2;
      btem = btem2;
      /* compute probability of crossing boundaries & their derivatives */
      if (lo_active) {
        for (ii = 0; ii <= m1; ii++) {
          xlo = (z1[ii] * rtIkm1 - atem * rtIk) / rtdeltak;
          plo += h[ii] * GS_PNORM_UPPER(xlo);
          dplo += h[ii] * exp(-xlo * xlo / 2);
        }
        dplo *= scale;
      }
      if (hi_active) {
        for (ii = 0; ii <= m1; ii++) {
          xhi = (z1[ii] * rtIkm1 - btem * rtIk) / rtdeltak;
          phi += h[ii] * GS_PNORM_LOWER(xhi);
          dphi -= h[ii] * exp(-xhi * xhi / 2);
        }
        dphi *= scale;
      }
      /* use 1st order Taylor's series to update boundaries */
      /* maximum allowed change is 1 */
      /* an exact hit (or a vanishing derivative) leaves the iterate unchanged */
      if (lo_active) {
        adelta = problo[i] - plo;
        if (adelta > dplo)
          atem2 = atem + 1.;
        else if (adelta < -dplo)
          atem2 = atem - 1.;
        else if (adelta == 0.)
          atem2 = atem;
        else
          atem2 = atem + adelta / dplo;
        if (atem2 > GS_ZCLAMP)
          atem2 = GS_ZCLAMP;
        else if (atem2 < -GS_ZCLAMP)
          atem2 = -GS_ZCLAMP;
      }
      if (hi_active) {
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
      }
      if (atem2 > btem2)
        atem2 = btem2;
      adelta = lo_active ? fabs(atem2 - atem) : 0.;
      bdelta = hi_active ? fabs(btem2 - btem) : 0.;
    }
    a[i] = atem;
    b[i] = btem;
    /* if convergence did not occur, set flag for return value */
    if (adelta > tol || bdelta > tol) {
      if (*printerr) {
        Rprintf("gsbound error: No convergence for boundary for interim %d; "
                "I=%7.0lf",
                i + 1, I[i]);
        if (bdelta > tol)
          Rprintf("\n last 2 upper boundary values: %lf %lf\n", btem, btem2);
        if (adelta > tol)
          Rprintf("\n last 2 lower boundary values: %lf %lf\n", atem, atem2);
      }
      retval[0] = 1;
      return;
    }
    if (i < nanal - 1) {
      sig = gs_kernel_width(I, i, nanal);
      m2 = gsgrid(meth, r, 0., a[i], b[i], sig, z2, w2);
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

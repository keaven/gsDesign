#include "R.h"
#include "Rmath.h"
#include "gsDesign.h"

/**
 * @brief Compute group sequential boundary crossing probabilities.
 *
 * For each drift value in @p xtheta, computes the probability of crossing the
 * lower boundary @p a and the upper boundary @p b at each analysis time. The
 * implementation follows the Jennison & Turnbull numerical integration scheme
 * and is written with pointer arguments to support calling via R's `.C()`
 * interface.
 *
 * @param[in] xnanal Number of analyses (`nanal = xnanal[0]`).
 * @param[in] ntheta Number of drift values (`ntheta = ntheta[0]`).
 * @param[in] xtheta Drift values (length `ntheta`).
 * @param[in] I Statistical information at each analysis (length `nanal`).
 * @param[in] a Lower Z cutoffs at each analysis (length `nanal`).
 * @param[in] b Upper Z cutoffs at each analysis (length `nanal`).
 * @param[out] xproblo Output probabilities of crossing the lower boundary.
 *   Array length is `ntheta * nanal`, stored as contiguous blocks of length
 *   `nanal` for each drift value.
 * @param[out] xprobhi Output probabilities of crossing the upper boundary.
 *   Array length is `ntheta * nanal`, stored as contiguous blocks of length
 *   `nanal` for each drift value.
 * @param[in] xr Grid parameter controlling the number of integration points
 *   (`r = xr[0]`).
 * @return Nothing.
 */
void probrej(int *xnanal, int *ntheta, double *xtheta, double *I, double *a,
             double *b, double *xproblo, double *xprobhi, int *xr) {
  int r, i, m1, m2, nanal, k;
  double theta;
  double *problo, *probhi;
  double probneg(double, int, double, double *, double *, double, double);
  double probpos(double, int, double, double *, double *, double, double);
  /* note: should allocate zwk & wwk dynamically...*/
  double mu, zwk[1000], wwk[1000], hwk[1000], zwk2[1000], wwk2[1000],
      hwk2[1000], *z1, *z2, *w1, *w2, *h, *h2, *tem;
  void h1(double, int, double *, double, double *, double *);
  void hupdate(double, double *, int, double, double *, double *, int, double,
               double *, double *);
  int gridpts(int, double, double, double, double *, double *);
  r = xr[0];
  nanal = xnanal[0];
  for (k = 0; k < ntheta[0]; k++) {
    theta = xtheta[k];
    problo = xproblo + k * nanal;
    probhi = xprobhi + k * nanal;
    /* compute probability of rejecting at 1st interim analysis */
    if (nanal < 1)
      return;
    mu = theta * sqrt(I[0]);
    problo[0] = pnorm(mu - a[0], 0., 1., 0, 0);
    probhi[0] = pnorm(b[0] - mu, 0., 1., 0, 0);
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
    for (i = 1; i < nanal; i++) {
      probhi[i] = probpos(theta, m1, b[i], z1, h, I[i - 1], I[i]);
      problo[i] = probneg(theta, m1, a[i], z1, h, I[i - 1], I[i]);
      if (i < nanal - 1) {
        mu = theta * sqrt(I[i]);
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
  }
}

#include "R.h"
#include "Rmath.h"
#include "gsDesign.h"

/**
 * @brief Compute probability of crossing the lower boundary at the next
 * analysis (Jennison & Turnbull, 2000, equation 19.8 with `1 - e_{k-1}`).
 *
 * @param[in] theta Drift parameter.
 * @param[in] m Last valid index in @p z and @p h.
 * @param[in] ak Lower Z boundary at the next analysis (may be `-Inf`).
 * @param[in] z Grid points at the previous analysis (length `m + 1`).
 * @param[in] h Weighted densities at the previous analysis (length `m + 1`).
 * @param[in] Ikm1 Statistical information at the previous analysis.
 * @param[in] Ik Statistical information at the next analysis.
 * @return Approximate probability of crossing the lower boundary.
 */
double probneg(double theta, int m, double ak, double *z, double *h,
               double Ikm1, double Ik) {
  int i;
  double x, prob, rtIk, rtIkm1, mu, rtdeltak;
  mu = theta * (Ik - Ikm1);
  rtdeltak = sqrt(Ik - Ikm1);
  rtIk = sqrt(Ik);
  rtIkm1 = sqrt(Ikm1);
  prob = 0.;
  for (i = 0; i <= m; i++) {
    x = (z[i] * rtIkm1 + mu - ak * rtIk) / rtdeltak;
    prob += GS_PNORM_UPPER(x) * h[i];
  }
  return (prob);
}

/**
 * @brief Compute probability of crossing the upper boundary at the next
 * analysis (Jennison & Turnbull, 2000, equation 19.8).
 *
 * @param[in] theta Drift parameter.
 * @param[in] m Last valid index in @p z and @p h.
 * @param[in] bk Upper Z boundary at the next analysis (may be `Inf`).
 * @param[in] z Grid points at the previous analysis (length `m + 1`).
 * @param[in] h Weighted densities at the previous analysis (length `m + 1`).
 * @param[in] Ikm1 Statistical information at the previous analysis.
 * @param[in] Ik Statistical information at the next analysis.
 * @return Approximate probability of crossing the upper boundary.
 */
double probpos(double theta, int m, double bk, double *z, double *h,
               double Ikm1, double Ik) {
  int i;
  double x, prob, rtIk, rtIkm1, mu, rtdeltak;
  mu = theta * (Ik - Ikm1);
  rtdeltak = sqrt(Ik - Ikm1);
  rtIk = sqrt(Ik);
  rtIkm1 = sqrt(Ikm1);
  prob = 0.;
  for (i = 0; i <= m; i++) {
    x = (z[i] * rtIkm1 + mu - bk * rtIk) / rtdeltak;
    prob += GS_PNORM_LOWER(x) * h[i];
  }
  return (prob);
}

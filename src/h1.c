#include <math.h>
#include <stdio.h>

/**
 * @brief Initialize weighted density values on an integration grid.
 *
 * Computes `h[i] = wgt[i] * phi(z[i] - theta * sqrt(I))`, where `phi()` is the
 * standard normal density. This is used to initialize the integration state at
 * the first analysis.
 *
 * @param[in] theta Drift parameter.
 * @param[in] m Last valid index in @p z, @p wgt, and @p h.
 * @param[in] wgt Integration weights corresponding to @p z (length `m + 1`).
 * @param[in] I Statistical information at the analysis.
 * @param[in] z Integration grid points (length `m + 1`).
 * @param[out] h Output weighted densities (length `m + 1`).
 * @return Nothing.
 */
void h1(double theta, int m, double *wgt, double I, double *z, double *h) {
  int i;
  double x, mu;
  mu = theta * sqrt(I);
  for (i = 0; i <= m; i++) {
    x = z[i] - mu;
    h[i] = wgt[i] * exp(-x * x / 2) / 2.506628275;
  }
}

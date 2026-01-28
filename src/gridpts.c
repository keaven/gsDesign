#include <math.h>

/**
 * @brief Generate grid points around a mean value.
 *
 * This helper generates a fixed set of grid points used by the Jennison &
 * Turnbull numerical integration scheme (p. 349). The output does not apply any
 * truncation to bounds and does not compute integration weights.
 *
 * @param[in] r Controls the number of grid points generated.
 * @param[in] mu Mean (location) parameter used to center the grid.
 * @param[out] z Output array of grid points (length at least `6 * r - 1`).
 * @return Nothing.
 */
void gridpts1(int r, double mu, double *z) {
  int i, r5, r6;
  double rdbl, r2dbl;
  rdbl = r;
  r2dbl = 2 * r;
  for (i = 1; i < r; i++)
    z[i - 1] = mu - 3 - 4 * log(rdbl / i);
  r5 = 5 * r;
  r6 = 6 * r;
  for (i = r; i <= r5; i++)
    z[i - 1] = mu - 3 * (1. - (i - rdbl) / r2dbl);
  for (i = r5 + 1; i < r6; i++)
    z[i - 1] = mu + 3. + 4. * log(rdbl / (r6 - i));
}

/**
 * @brief Compute integration grid points and weights between bounds.
 *
 * Computes the Jennison & Turnbull (p. 349) integration grid between the
 * provided bounds. The output arrays interleave grid points and midpoints
 * (even indices are grid points; odd indices are midpoints). The corresponding
 * Simpson-rule weights are returned in @p w.
 *
 * @param[in] r Grid parameter controlling the number of points.
 * @param[in] mu Mean (location) parameter for the grid.
 * @param[in] a Lower truncation bound.
 * @param[in] b Upper truncation bound.
 * @param[out] z Output array of grid points and midpoints (length at least
 *   `12 * r - 3`).
 * @param[out] w Output array of Simpson integration weights corresponding to @p
 * z (length at least `12 * r - 3`).
 * @return The last valid index written to @p z and @p w (i.e., arrays are valid
 *   for indices 0..return_value, with a total of `return_value + 1` points).
 */
int gridpts(int r, double mu, double a, double b, double *z, double *w) {
  int i, r5, r6, j = 0, done = 0;
  double rdbl, r2dbl, ztem;
  rdbl = r;
  r2dbl = 2 * r;
  r6 = 6 * r;
  r5 = 5 * r;
  w[0] = 0.;
  ztem = mu - 3 - 4 * log(rdbl);
  if (ztem <= a)
    z[0] = a;
  else if (ztem >= b) {
    z[0] = b;
    w[0] = 0.;
    done = 1;
  } else
    z[0] = ztem;
  for (i = 2; i < r6 && done == 0; i++) {
    if (i < r)
      ztem = mu - 3. - 4. * log(rdbl / i);
    else if (i <= r5)
      ztem = mu + 3. * (-1 + (i - r) / r2dbl);
    else
      ztem = mu + 3. + 4. * log(rdbl / (r6 - i));
    if (ztem > a) {
      j += 2;
      z[j] = ztem;
      if (ztem >= b) {
        z[j] = b;
        done = 1;
      }
      z[j - 1] = (z[j] + z[j - 2]) / 2.;
    }
  }
  if (j > 0) {
    w[0] = (z[2] - z[0]) / 6.;
    w[j] = (z[j] - z[j - 2]) / 6.;
    w[j - 1] = 2. * (z[j] - z[j - 2]) / 3.;
  }
  for (i = 1; i < j - 1; i += 2) {
    w[i] = 2. * (z[i + 1] - z[i - 1]) / 3.;
    w[i + 1] = (z[i + 3] - z[i - 1]) / 6.;
  }
  return (j);
}

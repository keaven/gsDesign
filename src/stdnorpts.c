#include "gsDesign.h"

/**
 * @brief Compute standard normal integration points and weights between bounds.
 *
 * Wrapper around `gridpts()` with `mu = 0` to generate grid points and Simpson
 * weights for numerical integration over a standard normal distribution.
 *
 * @param[in] r Grid parameter (`r[0]`) controlling the number of points.
 * @param[in] bounds Length-2 array with lower and upper bounds: `bounds[0]` and
 *   `bounds[1]`.
 * @param[out] z Output array of grid points and midpoints (length at least
 *   `12 * r[0] - 3`).
 * @param[out] w Output array of Simpson integration weights (length at least
 *   `12 * r[0] - 3`).
 * @return Nothing.
 */
void stdnorpts(int *r, double *bounds, double *z, double *w) {
  int gridpts(int, double, double, double, double *, double *);
  gridpts(r[0], 0., bounds[0], bounds[1], z, w);
}

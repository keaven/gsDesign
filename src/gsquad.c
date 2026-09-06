/**
 * @file
 * @brief Integration grids for the group sequential recursion.
 *
 * Two quadrature schemes are available for the recursive integration of
 * Jennison & Turnbull (2000, Chapter 19):
 *
 * - `GS_QUAD_JT`: the original grid of p. 349 (points concentrated within
 *   three standard deviations of the mean, logarithmically spaced tails,
 *   Simpson's rule; `12 r - 3` points before truncation).
 * - `GS_QUAD_GL`: Gauss-Legendre quadrature on the continuation region
 *   `(a, b)` of each analysis, truncated to `mu +/- GS_GL_L` when a bound is
 *   absent. The integrands (sub-densities times normal kernels) are analytic
 *   on the continuation region, so Gauss-Legendre converges much faster than
 *   Simpson's rule. The number of nodes adapts to the width of the region
 *   relative to the width `sig = sqrt(dI / I)` of the normal kernel linking
 *   the analysis to the next one; the grid parameter `r` acts as a
 *   multiplier relative to its default of 18. The sub-density at an analysis
 *   inherits features as sharp as the kernel that produced it, and the next
 *   integrand oscillates on the scale of the kernel to the following analysis,
 *   so the relevant width is the smaller of the two (`gs_kernel_width()`).
 *
 * Gauss-Legendre nodes and weights are computed once (Newton iteration on
 * Legendre polynomials) for a fixed menu of sizes and kept in static storage;
 * no memory is allocated per call.
 */
#include <math.h>
#include "R.h"
#include "gsDesign.h"

#define GS_GL_L 8.0    /* half-width (in standard deviations) replacing an infinite bound */
#define GS_GL_C0 8.0   /* nodes = ceil((C0 + C1 * width / sig) * r / 18) */
#define GS_GL_C1 3.0
#define GS_GL_NMENU 21
static const int gs_gl_menu[GS_GL_NMENU] = {8,   12,  16,  20,  24,  32,  40,
                                            48,  64,  80,  96,  128, 160, 192,
                                            256, 320, 384, 512, 640, 768, 992};
#define GS_GL_TABLE 4792 /* sum of the menu; every rule fits the 1000-long work arrays */
static double gs_gl_x[GS_GL_TABLE];
static double gs_gl_w[GS_GL_TABLE];
static int gs_gl_offset[GS_GL_NMENU];
static int gs_gl_ready = 0;

/**
 * @brief Gauss-Legendre rule with @p n nodes on (-1, 1).
 *
 * Roots of the Legendre polynomial `P_n` are found by Newton's method from
 * the classical asymptotic starting values; weights follow from the
 * derivative. Accuracy is at the level of double precision rounding.
 *
 * @param[in] n Number of nodes (even, >= 2).
 * @param[out] x Nodes in increasing order (length `n`).
 * @param[out] w Weights (length `n`).
 */
static void gs_gl_rule(int n, double *x, double *w) {
  int i, j, it, m = (n + 1) / 2;
  double z, z1, p1, p2, p3, pp;
  for (i = 0; i < m; i++) {
    z = cos(M_PI * (i + 0.75) / (n + 0.5));
    for (it = 0; it < 100; it++) {
      p1 = 1.;
      p2 = 0.;
      for (j = 1; j <= n; j++) {
        p3 = p2;
        p2 = p1;
        p1 = ((2. * j - 1.) * z * p2 - (j - 1.) * p3) / j;
      }
      pp = n * (z * p1 - p2) / (z * z - 1.);
      z1 = z;
      z = z1 - p1 / pp;
      if (fabs(z - z1) < 1e-15)
        break;
    }
    p1 = 1.;
    p2 = 0.;
    for (j = 1; j <= n; j++) {
      p3 = p2;
      p2 = p1;
      p1 = ((2. * j - 1.) * z * p2 - (j - 1.) * p3) / j;
    }
    pp = n * (z * p1 - p2) / (z * z - 1.);
    x[i] = -z;
    x[n - 1 - i] = z;
    w[i] = w[n - 1 - i] = 2. / ((1. - z * z) * pp * pp);
  }
}

/**
 * @brief Fill the static Gauss-Legendre tables (first use only).
 */
static void gs_gl_init(void) {
  int i, off = 0;
  if (gs_gl_ready)
    return;
  for (i = 0; i < GS_GL_NMENU; i++) {
    gs_gl_offset[i] = off;
    gs_gl_rule(gs_gl_menu[i], gs_gl_x + off, gs_gl_w + off);
    off += gs_gl_menu[i];
  }
  gs_gl_ready = 1;
}

/**
 * @brief Gauss-Legendre grid on the continuation region of an analysis.
 *
 * @param[in] r Grid parameter; the node count scales with `r / 18`.
 * @param[in] mu Mean of the standardized statistic at the analysis.
 * @param[in] a Lower bound (may be `-Inf`).
 * @param[in] b Upper bound (may be `Inf`).
 * @param[in] sig Width `sqrt(dI / I)` of the kernel to the next analysis.
 * @param[out] z Nodes (length at least the largest menu size, 992).
 * @param[out] w Weights.
 * @return Last valid index (number of nodes minus one); 0 with a zero weight
 *   when the region is empty.
 */
static int glpts(int r, double mu, double a, double b, double sig, double *z,
                 double *w) {
  int i, k, n;
  double lo = a, hi = b, c, hw, nreq;
  const double *gx, *gw;
  gs_gl_init();
  if (!(lo > mu - GS_GL_L))
    lo = mu - GS_GL_L;
  if (!(hi < mu + GS_GL_L))
    hi = mu + GS_GL_L;
  if (!(hi > lo)) {
    z[0] = lo;
    w[0] = 0.;
    return 0;
  }
  nreq = (GS_GL_C0 + GS_GL_C1 * (hi - lo) / sig) * (r / 18.);
  k = GS_GL_NMENU - 1;
  for (i = 0; i < GS_GL_NMENU; i++)
    if (gs_gl_menu[i] >= nreq) {
      k = i;
      break;
    }
  n = gs_gl_menu[k];
  gx = gs_gl_x + gs_gl_offset[k];
  gw = gs_gl_w + gs_gl_offset[k];
  c = 0.5 * (hi + lo);
  hw = 0.5 * (hi - lo);
  for (i = 0; i < n; i++) {
    z[i] = c + hw * gx[i];
    w[i] = hw * gw[i];
  }
  return n - 1;
}

/**
 * @brief Kernel width governing the resolution needed at an analysis.
 *
 * Returns the smaller of `sqrt(dI / I)` for the information increment into
 * analysis @p i (which sets how sharp the sub-density is there) and for the
 * increment out of it (which sets how fast the next integrand varies).
 *
 * @param[in] I Statistical information at each analysis (length @p nanal).
 * @param[in] i Analysis index (0-based) at which the grid is built.
 * @param[in] nanal Number of analyses.
 * @return The kernel width (`Inf` if the analysis has no neighbours).
 */
double gs_kernel_width(const double *I, int i, int nanal) {
  double in = R_PosInf, out = R_PosInf;
  if (i > 0)
    in = sqrt((I[i] - I[i - 1]) / I[i - 1]);
  if (i + 1 < nanal)
    out = sqrt((I[i + 1] - I[i]) / I[i]);
  return in < out ? in : out;
}

/**
 * @brief Integration grid for one analysis under the selected method.
 *
 * @param[in] method `GS_QUAD_JT` or `GS_QUAD_GL`.
 * @param[in] r Grid parameter.
 * @param[in] mu Mean of the standardized statistic at the analysis.
 * @param[in] a Lower bound (may be `-Inf`).
 * @param[in] b Upper bound (may be `Inf`).
 * @param[in] sig Kernel width to the next analysis (used by `GS_QUAD_GL`).
 * @param[out] z Grid points.
 * @param[out] w Integration weights.
 * @return Last valid index of @p z and @p w.
 */
int gsgrid(int method, int r, double mu, double a, double b, double sig,
           double *z, double *w) {
  if (method == GS_QUAD_GL)
    return glpts(r, mu, a, b, sig, z, w);
  return gridpts(r, mu, a, b, z, w);
}

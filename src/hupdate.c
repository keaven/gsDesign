#include "gsDesign.h"
#include <math.h>

/**
 * @brief Propagate weighted densities from one analysis to the next.
 *
 * Updates the weighted density vector @p hk on a new grid @p zk at information
 * time @p Ik, given the previous grid @p zkm1 and weighted densities @p hkm1 at
 * information time @p Ikm1 (Jennison & Turnbull, 2000, equation 19.4 and the
 * recursion for `h_k` on p. 347). Per-point constants are computed once so
 * that the inner loop consists of one subtraction, one multiplication, one
 * exponential and one fused multiply-add per pair of grid points.
 *
 * @param[in] theta Drift parameter.
 * @param[in] wgt Integration weights for the new grid @p zk (length `m2 + 1`).
 * @param[in] m1 Last valid index in @p zkm1 and @p hkm1.
 * @param[in] Ikm1 Statistical information at the previous analysis.
 * @param[in] zkm1 Grid points at the previous analysis (length `m1 + 1`).
 * @param[in] hkm1 Weighted densities at the previous analysis.
 * @param[in] m2 Last valid index in @p zk and @p hk.
 * @param[in] Ik Statistical information at the new analysis.
 * @param[in] zk Grid points at the new analysis (length `m2 + 1`).
 * @param[out] hk Output weighted densities at the new analysis.
 * @return Nothing.
 */
void hupdate(double theta, double *wgt, int m1, double Ikm1, double *zkm1,
             double *hkm1, int m2, double Ik, double *zk, double *hk) {
  double deltak, rtIk, rtIkm1, rtdeltak, scale, u, x, s;
  double c[1000]; /* scaled previous grid, fixed-size work storage */
  int i, ii;
  deltak = Ik - Ikm1; /* incremental information */
  rtdeltak = sqrt(deltak);
  rtIk = sqrt(Ik);
  rtIkm1 = sqrt(Ikm1);
  scale = gs_inv_sqrt_2pi * rtIk / rtdeltak;
  for (ii = 0; ii <= m1; ii++)
    c[ii] = (zkm1[ii] * rtIkm1 + theta * deltak) / rtdeltak;
  for (i = 0; i <= m2; i++) {
    u = zk[i] * rtIk / rtdeltak;
    s = 0.;
    for (ii = 0; ii <= m1; ii++) {
      x = u - c[ii];
      s += hkm1[ii] * exp(-0.5 * x * x);
    }
    hk[i] = wgt[i] * scale * s;
  }
}

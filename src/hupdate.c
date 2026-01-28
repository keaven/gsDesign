#include <math.h>
#include <stdio.h>

/**
 * @brief Propagate weighted densities from one analysis to the next.
 *
 * Updates the weighted density vector @p hk on a new grid @p zk at information
 * time @p Ik, given the previous grid @p zkm1 and weighted densities @p hkm1 at
 * information time @p Ikm1. The update performs the normal transition integral
 * used in the Jennison & Turnbull group sequential computations.
 *
 * @param[in] theta Drift parameter.
 * @param[in] wgt Integration weights for the new grid @p zk (length `m2 + 1`).
 * @param[in] m1 Last valid index in @p zkm1 and @p hkm1.
 * @param[in] Ikm1 Statistical information at the previous analysis.
 * @param[in] zkm1 Grid points at the previous analysis (length `m1 + 1`).
 * @param[in] hkm1 Weighted densities at the previous analysis (length `m1 +
 * 1`).
 * @param[in] m2 Last valid index in @p zk and @p hk.
 * @param[in] Ik Statistical information at the new analysis.
 * @param[in] zk Grid points at the new analysis (length `m2 + 1`).
 * @param[out] hk Output weighted densities at the new analysis (length `m2 +
 * 1`).
 * @return Nothing.
 */
void hupdate(double theta, double *wgt, int m1, double Ikm1, double *zkm1,
             double *hkm1, int m2, double Ik, double *zk, double *hk) {
  double deltak, x, rtIk, rtIkm1, rtdeltak;
  int i, ii;
  deltak = Ik - Ikm1; /* incremental information */
  rtdeltak = sqrt(deltak);
  rtIk = sqrt(Ik);
  rtIkm1 = sqrt(Ikm1);
  for (i = 0; i <= m2; i++) {
    hk[i] = 0.;
    for (ii = 0; ii <= m1; ii++) {
      x = (zk[i] * rtIk - zkm1[ii] * rtIkm1 - theta * deltak) / rtdeltak;
      hk[i] += hkm1[ii] * exp(-x * x / 2) / 2.506628275 * rtIk / rtdeltak;
    }
    hk[i] *= wgt[i];
  }
}

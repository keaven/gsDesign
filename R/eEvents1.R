# Do not edit source code in gsSurv.R
# This should be modified in https://github.com/keaven/gsSurv
# eEvents1 function [sinew] ----
eEvents1 <- function(lambda = 1, eta = 0, gamma = 1, R = 1, S = NULL,
                     T = 2, Tfinal = NULL, minfup = 0, simple = TRUE) {
  if (is.null(Tfinal)) {
    Tfinal <- T
    minfupia <- minfup
  } else {
    minfupia <- max(0, minfup - (Tfinal - T))
  }

  nlambda <- length(lambda)
  if (length(eta) == 1 & nlambda > 1) {
    eta <- rep(eta, nlambda)
  }
  T1 <- cumsum(S)
  T1 <- c(T1[T1 < T], T)
  T2 <- T - cumsum(R)
  T2[T2 < minfupia] <- minfupia
  i <- 1:length(gamma)
  gamma[i > length(unique(T2))] <- 0
  T2 <- unique(c(T, T2[T2 > 0]))
  T3 <- sort(unique(c(T1, T2)))
  if (sum(R) >= T) T2 <- c(T2, 0)
  nperiod <- length(T3)
  s <- T3 - c(0, T3[1:(nperiod - 1)])

  lam <- rep(lambda[nlambda], nperiod)
  et <- rep(eta[nlambda], nperiod)
  gam <- rep(0, nperiod)

  for (i in length(T1):1)
  {
    indx <- T3 <= T1[i]
    lam[indx] <- lambda[i]
    et[indx] <- eta[i]
  }
  for (i in min(length(gamma) + 1, length(T2)):2) {
    gam[T3 > T2[i]] <- gamma[i - 1]
  }
  q <- exp(-(c(lam) + c(et)) * s)
  Q <- cumprod(q)
  indx <- 1:(nperiod - 1)
  Qm1 <- c(1, Q[indx])
  p <- c(lam) / (c(lam) + c(et)) * c(Qm1) * (1 - c(q))
  p[is.nan(p)] <- 0
  P <- cumsum(p)
  B <- c(gam) / (c(lam) + c(et)) * c(lam) * (c(s) - (1 - c(q)) / (c(lam) + c(et)))
  B[is.nan(B)] <- 0
  A <- c(0, P[indx]) * c(gam) * c(s) + c(Qm1) * c(B)
  if (!simple) {
    return(list(
      lambda = lambda, eta = eta, gamma = gamma, R = R, S = S,
      T = T, Tfinal = Tfinal, minfup = minfup, d = sum(A),
      n = sum(gam * s), q = q, Q = Q, p = p, P = P, B = B, A = A, T1 = T1,
      T2 = T2, T3 = T3, lam = lam, et = et, gam = gam
    ))
  } else {
    return(list(
      lambda = lambda, eta = eta, gamma = gamma, R = R, S = S,
      T = T, Tfinal = Tfinal, minfup = minfup, d = sum(A),
      n = sum(c(gam) * c(s))
    ))
  }
}

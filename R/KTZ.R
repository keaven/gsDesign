# KTZ function [sinew] ----
KTZ <- function(x = NULL, minfup = NULL, n1Target = NULL,
                lambdaC = log(2) / 6, etaC = 0, etaE = 0,
                gamma = 1, ratio = 1, R = 18, S = NULL, beta = .1,
                alpha = .025, sided = 1, hr0 = 1, hr = .5, simple = TRUE) {
  zalpha <- -qnorm(alpha / sided)
  Qc <- 1 / (1 + ratio)
  Qe <- 1 - Qc
  # set minimum follow-up to x if that is missing and x is given
  if (!is.null(x) && is.null(minfup)) {
    minfup <- x
    if (sum(R) == Inf) {
      stop("If minimum follow-up is sought, enrollment duration must be finite")
    }
    T <- sum(R) + minfup
    variable <- "Follow-up duration"
  } else if (!is.null(x) && !is.null(minfup)) { # otherwise, if x is given, set it to accrual duration
    T <- x + minfup
    R[length(R)] <- Inf
    variable <- "Accrual duration"
  } else { # otherwise, set follow-up time to accrual plus follow-up
    T <- sum(R) + minfup
    variable <- "Power"
  }
  # compute H0 failure rates as average of control, experimental
  if (length(ratio) == 1) {
    lambdaC0 <- (1 + hr * ratio) / (1 + hr0 * ratio) * lambdaC
    gammaC <- gamma * Qc
    gammaE <- gamma * Qe
  } else {
    lambdaC0 <- lambdaC %*% diag((1 + hr * ratio) / (1 + hr0 * ratio))
    gammaC <- gamma %*% diag(Qc)
    gammaE <- gamma %*% diag(Qe)
  }

  # do computations
  eDC <- eEvents(
    lambda = lambdaC, eta = etaC, gamma = gammaC,
    R = R, S = S, T = T, minfup = minfup
  )
  eDE <- eEvents(
    lambda = lambdaC * hr, eta = etaE, gamma = gammaE,
    R = R, S = S, T = T, minfup = minfup
  )
  # if this is all that is needed, return difference
  # from targeted number of events
  if (simple && !is.null(n1Target)) {
    return(sum(eDC$d + eDE$d) - n1Target)
  }
  eDC0 <- eEvents(
    lambda = lambdaC0, eta = etaC, gamma = gammaC,
    R = R, S = S, T = T, minfup = minfup
  )
  eDE0 <- eEvents(
    lambda = lambdaC0 * hr0, eta = etaE, gamma = gammaE,
    R = R, S = S, T = T, minfup = minfup
  )
  # compute Z-value related to power from power equation
  zb <- (log(hr0 / hr) -
    zalpha * sqrt(1 / sum(eDC0$d) + 1 / sum(eDE0$d))) /
    sqrt(1 / sum(eDC$d) + 1 / sum(eDE$d))
  # if that is all that is needed, return difference from
  # targeted value
  if (simple) {
    if (!is.null(beta)) {
      return(zb + qnorm(beta))
    } else {
      return(pnorm(-zb))
    }
  }
  # compute power
  power <- pnorm(zb)
  beta <- 1 - power
  # set accrual period durations
  if (sum(R) != T - minfup) {
    if (length(R) == 1) {
      R <- T - minfup
    } else {
      nR <- length(R)
      cR <- cumsum(R)
      cR[cR > T - minfup] <- T - minfup
      cR <- unique(cR)
      cR[length(R)] <- T - minfup
      if (length(cR) == 1) {
        R <- cR
      } else {
        R <- cR - c(0, cR[1:(length(cR) - 1)])
      }
      if (length(R) != nR) {
        gamma <- matrix(gamma[1:length(R), ], nrow = length(R))
        gdim <- dim(gamma)
      }
    }
  }
  rval <- list(
    alpha = alpha, sided = sided, beta = beta, power = power,
    lambdaC = lambdaC, etaC = etaC, etaE = etaE,
    gamma = gamma, ratio = ratio, R = R, S = S, T = T,
    minfup = minfup, hr = hr, hr0 = hr0, n = sum(eDC$n + eDE$n),
    d = sum(eDC$d + eDE$d), tol = NULL, eDC = eDC$d, eDE = eDE$d,
    eDC0 = eDC0$d, eDE0 = eDE0$d, eNC = eDC$n, eNE = eDE$n,
    variable = variable
  )
  class(rval) <- "nSurv"
  return(rval)
}

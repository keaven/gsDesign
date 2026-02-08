# LFPWE function [sinew] ----
LFPWE <- function(
  alpha = .025, sided = 1, beta = .1,
  lambdaC = log(2) / 6, hr = .5, hr0 = 1, etaC = 0, etaE = 0,
  gamma = 1, ratio = 1, R = 18, S = NULL, T = 24, minfup = NULL
) {
  # Set up parameters
  zalpha <- -stats::qnorm(alpha / sided)
  zbeta <- -stats::qnorm(beta)
  if (is.null(minfup)) minfup <- max(0, T - sum(R))
  if (length(R) == 1) {
    R <- T - minfup
  } else if (sum(R) != T - minfup) {
    cR <- cumsum(R)
    nR <- length(R)
    if (cR[length(cR)] < T - minfup) {
      cR[length(cR)] <- T - minfup
    } else {
      cR[cR > T - minfup] <- T - minfup
      cR <- unique(cR)
    }
    if (length(cR) > 1) {
      R <- cR - c(0, cR[1:(length(cR) - 1)])
    } else {
      R <- cR
    }
    if (nR != length(R)) {
      if (is.vector(gamma)) {
        gamma <- gamma[1:length(R)]
      } else {
        gamma <- gamma[1:length(R), ]
      }
    }
  }
  ngamma <- length(R)
  if (is.null(S)) {
    nlambda <- 1
  } else {
    nlambda <- length(S) + 1
  }
  Qe <- ratio / (1 + ratio)
  Qc <- 1 - Qe

  # Compute H0 failure rates as average of control, experimental
  if (length(ratio) == 1) {
    lambdaC0 <- (1 + hr * ratio) / (1 + hr0 * ratio) * lambdaC
    gammaC <- gamma * Qc
    gammaE <- gamma * Qe
  } else {
    lambdaC0 <- lambdaC %*% diag((1 + hr * ratio) / (1 + hr0 * ratio))
    gammaC <- gamma %*% diag(Qc)
    gammaE <- gamma %*% diag(Qe)
  }
  # Do computations
  eDC0 <- sum(eEvents(
    lambda = lambdaC0, eta = etaC, gamma = gammaC,
    R = R, S = S, T = T, minfup = minfup
  )$d)
  eDE0 <- sum(eEvents(
    lambda = lambdaC0 * hr0, eta = etaE, gamma = gammaE,
    R = R, S = S, T = T, minfup = minfup
  )$d)
  eDC <- eEvents(
    lambda = lambdaC, eta = etaC, gamma = gammaC,
    R = R, S = S, T = T, minfup = minfup
  )
  eDE <- eEvents(
    lambda = lambdaC * hr, eta = etaE, gamma = gammaE,
    R = R, S = S, T = T, minfup = minfup
  )

  n <- ((zalpha * sqrt(1 / eDC0 + 1 / eDE0) +
    zbeta * sqrt(1 / sum(eDC$d) + 1 / sum(eDE$d))
  ) / log(hr / hr0))^2
  mx <- sum(eDC$n + eDE$n)
  rval <- list(
    alpha = alpha, sided = sided, beta = beta, power = 1 - beta,
    lambdaC = lambdaC, etaC = etaC, etaE = etaE, gamma = n * gamma,
    ratio = ratio, R = R, S = S, T = T, minfup = minfup,
    hr = hr, hr0 = hr0, n = n * mx, d = n * sum(eDC$d + eDE$d),
    eDC = eDC$d * n, eDE = eDE$d * n, eDC0 = eDC0 * n, eDE0 = eDE0 * n,
    eNC = eDC$n * n, eNE = eDE$n * n, variable = "Accrual rate"
  )
  class(rval) <- "nSurv"
  return(rval)
}

# KTZ function [sinew] ----
KTZ <- function(
  x = NULL, minfup = NULL, n1Target = NULL,
  lambdaC = log(2) / 6, etaC = 0, etaE = 0,
  gamma = 1, ratio = 1, R = 18, S = NULL, beta = .1,
  alpha = .025, sided = 1, hr0 = 1, hr = .5, simple = TRUE
) {
  zalpha <- -stats::qnorm(alpha / sided)
  Qc <- 1 / (1 + ratio)
  Qe <- 1 - Qc
  # Set minimum follow-up to x if that is missing and x is given
  if (!is.null(x) && is.null(minfup)) {
    minfup <- x
    if (sum(R) == Inf) {
      stop("If minimum follow-up is sought, enrollment duration must be finite")
    }
    T <- sum(R) + minfup
    variable <- "Follow-up duration"
  } else if (!is.null(x) && !is.null(minfup)) { # Otherwise, if x is given, set it to accrual duration
    T <- x + minfup
    R[length(R)] <- Inf
    variable <- "Accrual duration"
  } else { # Otherwise, set follow-up time to accrual plus follow-up
    T <- sum(R) + minfup
    variable <- "Power"
  }
  # Compute H0 failure rates as average of control, experimental
  if (length(ratio) == 1) {
    lambdaC0 <- (1 + hr * ratio) / (1 + hr0 * ratio) * lambdaC
    gammaC <- gamma * Qc
    gammaE <- gamma * Qe
  } else {
    lambdaC0 <- lambdaC %*% diag((1 + hr * ratio) / (1 + hr0 * ratio))
    gammaC <- gamma %*% diag(Qc)
    gammaE <- gamma %*% diag(Qe)
  }

  # Do computations
  eDC <- eEvents(
    lambda = lambdaC, eta = etaC, gamma = gammaC,
    R = R, S = S, T = T, minfup = minfup
  )
  eDE <- eEvents(
    lambda = lambdaC * hr, eta = etaE, gamma = gammaE,
    R = R, S = S, T = T, minfup = minfup
  )
  # If this is all that is needed, return difference from
  # targeted number of events
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
  # Compute Z-value related to power from power equation
  zb <- (log(hr0 / hr) -
    zalpha * sqrt(1 / sum(eDC0$d) + 1 / sum(eDE0$d))) /
    sqrt(1 / sum(eDC$d) + 1 / sum(eDE$d))
  # If that is all that is needed, return difference from targeted value
  if (simple) {
    if (!is.null(beta)) {
      return(zb + stats::qnorm(beta))
    } else {
      return(stats::pnorm(-zb))
    }
  }
  # Compute power
  power <- stats::pnorm(zb)
  beta <- 1 - power
  # Set accrual period durations
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


# KT function [sinew] ----
KT <- function(
  alpha = .025, sided = 1, beta = .1,
  lambdaC = log(2) / 6, hr = .5, hr0 = 1, etaC = 0, etaE = 0,
  gamma = 1, ratio = 1, R = 18, S = NULL, minfup = NULL,
  n1Target = NULL, tol = .Machine$double.eps^0.25
) {
  # Set up parameters
  ngamma <- length(R)
  if (is.null(S)) {
    nlambda <- 1
  } else {
    nlambda <- length(S) + 1
  }
  Qe <- ratio / (1 + ratio)
  Qc <- 1 - Qe
  if (!is.matrix(lambdaC)) lambdaC <- matrix(lambdaC)
  ldim <- dim(lambdaC)
  nstrata <- ldim[2]
  nlambda <- ldim[1]
  etaC <- matrix(etaC, nrow = nlambda, ncol = nstrata)
  etaE <- matrix(etaE, nrow = nlambda, ncol = nstrata)
  if (!is.matrix(gamma)) gamma <- matrix(gamma)
  gdim <- dim(gamma)
  eCdim <- dim(etaC)
  eEdim <- dim(etaE)

  # Search for trial duration needed to achieve desired power
  if (is.null(minfup)) {
    if (sum(R) == Inf) {
      stop("Enrollment duration must be specified as finite")
    }
    left <- KTZ(.01,
      lambdaC = lambdaC, n1Target = n1Target,
      etaC = etaC, etaE = etaE, gamma = gamma, ratio = ratio,
      R = R, S = S, beta = beta, alpha = alpha, sided = sided,
      hr0 = hr0, hr = hr
    )
    right <- KTZ(1000,
      lambdaC = lambdaC, n1Target = n1Target,
      etaC = etaC, etaE = etaE, gamma = gamma, ratio = ratio,
      R = R, S = S, beta = beta, alpha = alpha, sided = sided,
      hr0 = hr0, hr = hr
    )
    if (left > 0) stop("Enrollment duration over-powers trial")
    if (right < 0) stop("Enrollment duration insufficient to power trial")
    y <- stats::uniroot(
      f = KTZ, interval = c(.01, 10000), lambdaC = lambdaC,
      etaC = etaC, etaE = etaE, gamma = gamma, ratio = ratio,
      R = R, S = S, beta = beta, alpha = alpha, sided = sided,
      hr0 = hr0, hr = hr, tol = tol, n1Target = n1Target
    )
    minfup <- y$root
    xx <- KTZ(
      x = y$root, lambdaC = lambdaC,
      etaC = etaC, etaE = etaE, gamma = gamma, ratio = ratio,
      R = R, S = S, minfup = NULL, beta = beta, alpha = alpha,
      sided = sided, hr0 = hr0, hr = hr, simple = F
    )
    xx$tol <- tol
    return(xx)
  } else {
    y <- stats::uniroot(
      f = KTZ, interval = minfup + c(.01, 10000), lambdaC = lambdaC,
      n1Target = n1Target,
      etaC = etaC, etaE = etaE, gamma = gamma, ratio = ratio,
      R = R, S = S, minfup = minfup, beta = beta,
      alpha = alpha, sided = sided, hr0 = hr0, hr = hr, tol = tol
    )
    xx <- KTZ(
      x = y$root, lambdaC = lambdaC,
      etaC = etaC, etaE = etaE, gamma = gamma, ratio = ratio,
      R = R, S = S, minfup = minfup, beta = beta, alpha = alpha,
      sided = sided, hr0 = hr0, hr = hr, simple = F
    )
    xx$tol <- tol
    return(xx)
  }
}

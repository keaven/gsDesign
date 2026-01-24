# KT function [sinew] ----
KT <- function(alpha = .025, sided = 1, beta = .1,
               lambdaC = log(2) / 6, hr = .5, hr0 = 1, etaC = 0, etaE = 0,
               gamma = 1, ratio = 1, R = 18, S = NULL, minfup = NULL,
               n1Target = NULL, tol = .Machine$double.eps^0.25) {
  # set up parameters
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

  # search for trial duration needed to achieve desired power
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
    if (left > 0) {
      stop(paste(
        "With minfup = NULL, trial is over-powered for any follow-up duration.",
        "Reduce accrual rates (gamma), increase beta, or adjust assumptions."
      ))
    }
    if (right < 0) {
      stop(paste(
        "With minfup = NULL, trial is under-powered for any follow-up duration.",
        "Increase accrual rates (gamma), decrease beta, or adjust assumptions."
      ))
    }
    y <- uniroot(
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
    left <- KTZ(minfup + .01,
      lambdaC = lambdaC, n1Target = n1Target,
      etaC = etaC, etaE = etaE, gamma = gamma, ratio = ratio,
      R = R, S = S, minfup = minfup, beta = beta,
      alpha = alpha, sided = sided, hr0 = hr0, hr = hr
    )
    right <- KTZ(10000,
      lambdaC = lambdaC, n1Target = n1Target,
      etaC = etaC, etaE = etaE, gamma = gamma, ratio = ratio,
      R = R, S = S, minfup = minfup, beta = beta,
      alpha = alpha, sided = sided, hr0 = hr0, hr = hr
    )
    if (is.finite(left) && is.finite(right)) {
      if (left > 0 && right > 0) {
        stop(paste(
          "With T = NULL, trial is over-powered for any accrual duration.",
          "Reduce accrual rates (gamma), increase beta, or adjust assumptions."
        ))
      }
      if (left < 0 && right < 0) {
        stop(paste(
          "With T = NULL, trial is under-powered for any accrual duration.",
          "Increase accrual rates (gamma), decrease beta, or adjust assumptions."
        ))
      }
    }
    y <- uniroot(
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

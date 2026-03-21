gsnSurv <- function(x, nEvents) {
  if (x$variable == "Accrual rate") {
    Ifct <- nEvents / x$d
    rval <- list(
      lambdaC = x$lambdaC, etaC = x$etaC, etaE = x$etaE,
      gamma = x$gamma * Ifct, ratio = x$ratio, R = x$R, S = x$S, T = x$T,
      minfup = x$minfup, hr = x$hr, hr0 = x$hr0, n = x$n * Ifct, d = nEvents,
      eDC = x$eDC * Ifct, eDE = x$eDE * Ifct, eDC0 = x$eDC0 * Ifct,
      eDE0 = x$eDE0 * Ifct, eNC = x$eNC * Ifct, eNE = x$eNE * Ifct,
      variable = x$variable
    )
  } else if (x$variable == "Accrual duration") {
    y <- KT(
      n1Target = nEvents, minfup = x$minfup, lambdaC = x$lambdaC,
      etaC = x$etaC, etaE = x$etaE,
      R = x$R, S = x$S, hr = x$hr, hr0 = x$hr0, gamma = x$gamma,
      ratio = x$ratio, tol = x$tol
    )
    rval <- list(
      lambdaC = x$lambdaC, etaC = x$etaC, etaE = x$etaE,
      gamma = x$gamma, ratio = x$ratio, R = y$R, S = x$S, T = y$T,
      minfup = y$minfup, hr = x$hr, hr0 = x$hr0,
      n = y$n, d = nEvents,
      eDC = y$eDC, eDE = y$eDE, eDC0 = y$eDC0,
      eDE0 = y$eDE0, eNC = y$eNC, eNE = y$eNE, tol = x$tol,
      variable = x$variable
    )
  } else {
    y <- KT(
      n1Target = nEvents, minfup = NULL,
      lambdaC = x$lambdaC, etaC = x$etaC,
      etaE = x$etaE, R = x$R, S = x$S, hr = x$hr, hr0 = x$hr0,
      gamma = x$gamma, ratio = x$ratio, tol = x$tol
    )
    rval <- list(
      lambdaC = x$lambdaC, etaC = x$etaC, etaE = x$etaE,
      gamma = x$gamma, ratio = x$ratio, R = x$R, S = x$S, T = y$T,
      minfup = y$minfup, hr = x$hr, hr0 = x$hr0, n = y$n,
      d = nEvents, eDC = y$eDC, eDE = y$eDE, eDC0 = y$eDC0,
      eDE0 = y$eDE0, eNC = y$eNC, eNE = y$eNE, tol = x$tol,
      variable = x$variable
    )
  }
  class(rval) <- "gsSize"
  return(rval)
}

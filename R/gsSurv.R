# gsSurv roxy [sinew] ----
#' @rdname nSurv
#' @inheritParams gsDesign
#' @export
# gsSurv function [sinew] ----
gsSurv <- function(
  k = 3, test.type = 4, alpha = 0.025, sided = 1,
  beta = 0.1, astar = 0, timing = 1, sfu = sfHSD, sfupar = -4,
  sfl = sfHSD, sflpar = -2, sfharm = sfHSD, sfharmparam = -2, r = 18,
  lambdaC = log(2) / 6, hr = .6, hr0 = 1, eta = 0, etaE = NULL,
  gamma = 1, R = 12, S = NULL, T = 18, minfup = 6, ratio = 1,
  tol = .Machine$double.eps^0.25,
  usTime = NULL, lsTime = NULL,
  testUpper = TRUE, testLower = TRUE, testHarm = TRUE,
  method = c("LachinFoulkes", "Schoenfeld", "Freedman", "BernsteinLagakos")
) { # KA: usTime and lsTime added 10/8/2017
  method <- match.arg(method)
  input_vals <- list(
    gamma = gamma,
    R = R,
    lambdaC = lambdaC,
    eta = eta,
    etaE = etaE,
    S = S
  )
  # Validate ratio is a single positive scalar
  if (!is.numeric(ratio) || length(ratio) != 1 || ratio <= 0) {
    stop("ratio must be a single positive scalar")
  }
  # If both gamma and R are provided (non-NULL) and T is NULL, set T to force solving for accrual rate
  # This matches gsDesign::gsSurv behavior which keeps R fixed and solves for gamma
  if (is.null(T) && !is.null(minfup) &&
    !is.null(R) && length(R) > 0 &&
    !is.null(gamma) && length(gamma) > 0) {
    T <- sum(R) + minfup
  }
  x <- nSurv(
    lambdaC = lambdaC, hr = hr, hr0 = hr0, eta = eta, etaE = etaE,
    gamma = gamma, R = R, S = S, T = T, minfup = minfup, ratio = ratio,
    alpha = alpha, beta = beta, sided = sided, tol = tol, method = method
  )
  y <- gsDesign(
    k = k, test.type = test.type, alpha = alpha / sided,
    beta = beta, astar = astar, n.fix = x$d, timing = timing,
    sfu = sfu, sfupar = sfupar, sfl = sfl, sflpar = sflpar,
    sfharm = sfharm, sfharmparam = sfharmparam, tol = tol,
    delta1 = log(hr), delta0 = log(hr0),
    usTime = usTime, lsTime = lsTime,
    testUpper = testUpper, testLower = testLower, testHarm = testHarm
  )

  z <- gsnSurv(x, y$n.I[k])
  eDC <- NULL
  eDE <- NULL
  eNC <- NULL
  eNE <- NULL
  T <- NULL
  for (i in 1:(k - 1)) {
    xx <- tEventsIA(z, y$timing[i], tol)
    T <- c(T, xx$T)
    eDC <- rbind(eDC, xx$eDC)
    eDE <- rbind(eDE, xx$eDE)
    eNC <- rbind(eNC, xx$eNC)
    eNE <- rbind(eNE, xx$eNE)
  }
  y$T <- c(T, z$T)
  y$eDC <- rbind(eDC, z$eDC)
  y$eDE <- rbind(eDE, z$eDE)
  y$eNC <- rbind(eNC, z$eNC)
  y$eNE <- rbind(eNE, z$eNE)
  y$hr <- hr
  y$hr0 <- hr0
  y$R <- z$R
  y$S <- z$S
  y$minfup <- z$minfup
  y$gamma <- z$gamma
  y$ratio <- ratio
  y$lambdaC <- z$lambdaC
  y$etaC <- z$etaC
  y$etaE <- z$etaE
  y$variable <- x$variable
  y$tol <- tol
  y$method <- x$method
  y$call <- match.call()
  y$inputs <- input_vals
  class(y) <- c("gsSurv", "gsDesign")

  nameR <- nameperiod(cumsum(y$R))
  stratnames <- paste("Stratum", seq_len(ncol(y$lambdaC)))
  if (is.null(y$S)) {
    nameS <- "0-Inf"
  } else {
    nameS <- nameperiod(cumsum(c(y$S, Inf)))
  }
  rownames(y$lambdaC) <- nameS
  colnames(y$lambdaC) <- stratnames
  rownames(y$etaC) <- nameS
  colnames(y$etaC) <- stratnames
  rownames(y$etaE) <- nameS
  colnames(y$etaE) <- stratnames
  rownames(y$gamma) <- nameR
  colnames(y$gamma) <- stratnames
  return(y)
}

# gsnSurv function [sinew] ----
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
      n1Target = nEvents, minfup = x$minfup, lambdaC = x$lambdaC, etaC = x$etaC,
      etaE = x$etaE, R = x$R, S = x$S, hr = x$hr, hr0 = x$hr0, gamma = x$gamma,
      ratio = x$ratio, tol = x$tol
    )
    rval <- list(
      lambdaC = x$lambdaC, etaC = x$etaC, etaE = x$etaE,
      gamma = x$gamma, ratio = x$ratio, R = y$R, S = x$S, T = y$T,
      minfup = y$minfup, hr = x$hr, hr0 = x$hr0, n = y$n, d = nEvents,
      eDC = y$eDC, eDE = y$eDE, eDC0 = y$eDC0,
      eDE0 = y$eDE0, eNC = y$eNC, eNE = y$eNE, tol = x$tol,
      variable = x$variable
    )
  } else {
    y <- KT(
      n1Target = nEvents, minfup = NULL, lambdaC = x$lambdaC, etaC = x$etaC,
      etaE = x$etaE, R = x$R, S = x$S, hr = x$hr, hr0 = x$hr0, gamma = x$gamma,
      ratio = x$ratio, tol = x$tol
    )
    rval <- list(
      lambdaC = x$lambdaC, etaC = x$etaC, etaE = x$etaE,
      gamma = x$gamma, ratio = x$ratio, R = x$R, S = x$S, T = y$T,
      minfup = y$minfup, hr = x$hr, hr0 = x$hr0, n = y$n, d = nEvents,
      eDC = y$eDC, eDE = y$eDE, eDC0 = y$eDC0,
      eDE0 = y$eDE0, eNC = y$eNC, eNE = y$eNE, tol = x$tol,
      variable = x$variable
    )
  }
  class(rval) <- "gsSize"
  return(rval)
}


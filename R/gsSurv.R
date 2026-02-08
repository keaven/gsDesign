# gsSurv roxy [sinew] ----
#' @rdname nSurv
#' @export
# gsSurv function [sinew] ----
gsSurv <- function(
  k = 3, test.type = 4, alpha = 0.025, sided = 1,
  beta = 0.1, astar = 0, timing = 1, sfu = sfHSD, sfupar = -4,
  sfl = sfHSD, sflpar = -2, r = 18,
  lambdaC = log(2) / 6, hr = .6, hr0 = 1, eta = 0, etaE = NULL,
  gamma = 1, R = 12, S = NULL, T = 18, minfup = 6, ratio = 1,
  tol = .Machine$double.eps^0.25,
  usTime = NULL, lsTime = NULL
) { # KA: last 2 arguments added 10/8/2017
  x <- nSurv(
    lambdaC = lambdaC, hr = hr, hr0 = hr0, eta = eta, etaE = etaE,
    gamma = gamma, R = R, S = S, T = T, minfup = minfup, ratio = ratio,
    alpha = alpha, beta = beta, sided = sided, tol = tol
  )
  y <- gsDesign(
    k = k, test.type = test.type, alpha = alpha / sided,
    beta = beta, astar = astar, n.fix = x$d, timing = timing,
    sfu = sfu, sfupar = sfupar, sfl = sfl, sflpar = sflpar, tol = tol,
    delta1 = log(hr), delta0 = log(hr0),
    usTime = usTime, lsTime = lsTime
  ) # KA: last 2 arguments added 10/8/2017

  z <- gsnSurv(x, y$n.I[k])
  eDC <- NULL
  eDE <- NULL
  eDC0 <- NULL
  eDE0 <- NULL
  eNC <- NULL
  eNE <- NULL
  T <- NULL
  for (i in 1:(k - 1)) {
    xx <- tEventsIA(z, y$timing[i], tol)
    T <- c(T, xx$T)
    eDC <- rbind(eDC, xx$eDC)
    eDE <- rbind(eDE, xx$eDE)
    # Following is a placeholder
    # eDC0 <- rbind(eDC0, xx$eDC0) # Added 6/15/2023
    # eDE0 <- rbind(eDE0, xx$eDE0) # Added 6/15/2023
    eNC <- rbind(eNC, xx$eNC)
    eNE <- rbind(eNE, xx$eNE)
  }
  y$T <- c(T, z$T)
  y$eDC <- rbind(eDC, z$eDC)
  y$eDE <- rbind(eDE, z$eDE)
  # Following is a placeholder
  # y$eDC0 <- rbind(eDC0, z$eDC0) # Added 6/15/2023
  # y$eDE0 <- rbind(eDE0, z$eDE0) # Added 6/15/2023
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
  class(y) <- c("gsSurv", "gsDesign")

  nameR <- nameperiod(cumsum(y$R))
  stratnames <- paste("Stratum", 1:ncol(y$lambdaC))
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

# print.gsSurv roxy [sinew] ----
#' @rdname nSurv
#' @export
# print.gsSurv function [sinew] ----
print.gsSurv <- function(x, digits = 2, ...) {
  cat("Time to event group sequential design with HR=", x$hr, "\n")
  if (x$hr0 != 1) cat("Non-inferiority design with null HR=", x$hr0, "\n")
  if (min(x$ratio == 1) == 1) {
    cat("Equal randomization:          ratio=1\n")
  } else {
    cat(
      "Randomization (Exp/Control):  ratio=",
      x$ratio, "\n"
    )
    if (length(x$ratio) > 1) cat("(randomization ratios shown by strata)\n")
  }
  print.gsDesign(x)
  if (x$test.type != 1) {
    y <- cbind(
      x$T, (x$eNC + x$eNE) %*% rep(1, ncol(x$eNE)), x$n.I,
      round(zn2hr(x$lower$bound, x$n.I, x$ratio, hr0 = x$hr0, hr1 = x$hr), 3),
      round(zn2hr(x$upper$bound, x$n.I, x$ratio, hr0 = x$hr0, hr1 = x$hr), 3)
    )
    colnames(y) <- c("T", "n", "Events", "HR futility", "HR efficacy")
  } else {
    y <- cbind(
      x$T, (x$eNC + x$eNE) %*% rep(1, ncol(x$eNE)), x$n.I,
      round(zn2hr(x$upper$bound, x$n.I, x$ratio, hr0 = x$hr0, hr1 = x$hr), 3)
    )
    colnames(y) <- c("T", "n", "Events", "HR efficacy")
  }
  rnames <- paste("IA", 1:(x$k))
  rnames[length(rnames)] <- "Final"
  rownames(y) <- rnames
  print(y)
  cat("Accrual rates:\n")
  print(round(x$gamma, digits))
  cat("Control event rates (H1):\n")
  print(round(x$lambda, digits))
  if (max(abs(x$etaC - x$etaE)) == 0) {
    cat("Censoring rates:\n")
    print(round(x$etaC, digits))
  } else {
    cat("Control censoring rates:\n")
    print(round(x$etaC, digits))
    cat("Experimental censoring rates:\n")
    print(round(x$etaE, digits))
  }
}

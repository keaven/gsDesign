# eEvents1 function [sinew] ----
eEvents1 <- function(lambda = 1, eta = 0, gamma = 1, R = 1, S = NULL,
                     T = 2, Tfinal = NULL, minfup = 0, simple = TRUE) {
  if (is.null(Tfinal)) {
    Tfinal <- T
    minfupia <- minfup
  }
  else {
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
  for (i in min(length(gamma) + 1, length(T2)):2)
    gam[T3 > T2[i]] <- gamma[i - 1]
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



# eEvents roxy [sinew] ----
#' @title Expected number of events for a time-to-event study
#'
#' @description \code{eEvents()} is used to calculate the expected number of events for a
#' population with a time-to-event endpoint.  It is based on calculations
#' demonstrated in Lachin and Foulkes (1986) and is fundamental in computations
#' for the sample size method they propose. Piecewise exponential survival and
#' dropout rates are supported as well as piecewise uniform enrollment. A
#' stratified population is allowed. Output is the expected number of events
#' observed given a trial duration and the above rate parameters.
#'
#' \code{eEvents()} produces an object of class \code{eEvents} with the number
#' of subjects and events for a set of pre-specified trial parameters, such as
#' accrual duration and follow-up period. The underlying power calculation is
#' based on Lachin and Foulkes (1986) method for proportional hazards assuming
#' a fixed underlying hazard ratio between 2 treatment groups. The method has
#' been extended here to enable designs to test non-inferiority. Piecewise
#' constant enrollment and failure rates are assumed and a stratified
#' population is allowed. See also \code{\link{nSurvival}} for other Lachin and
#' Foulkes (1986) methods assuming a constant hazard difference or exponential
#' enrollment rate.
#'
#' \code{print.eEvents()} formats the output for an object of class
#' \code{eEvents} and returns the input value.
#'
#' @param lambda scalar, vector or matrix of event hazard rates; rows represent
#' time periods while columns represent strata; a vector implies a single
#' stratum.
#' @param eta scalar, vector or matrix of dropout hazard rates; rows represent
#' time periods while columns represent strata; if entered as a scalar, rate is
#' constant across strata and time periods; if entered as a vector, rates are
#' constant across strata.
#' @param gamma a scalar, vector or matrix of rates of entry by time period
#' (rows) and strata (columns); if entered as a scalar, rate is constant
#' across strata and time periods; if entered as a vector, rates are constant
#' across strata.
#' @param R a scalar or vector of durations of time periods for recruitment
#' rates specified in rows of \code{gamma}. Length is the same as number of
#' rows in \code{gamma}. Note that the final enrollment period is extended as
#' long as needed.
#' @param S a scalar or vector of durations of piecewise constant event rates
#' specified in rows of \code{lambda}, \code{eta} and \code{etaE}; this is NULL
#' if there is a single event rate per stratum (exponential failure) or length
#' of the number of rows in \code{lambda} minus 1, otherwise.
#' @param T time of analysis; if \code{Tfinal=NULL}, this is also the study
#' duration.
#' @param Tfinal Study duration; if \code{NULL}, this will be replaced with
#' \code{T} on output.
#' @param minfup time from end of planned enrollment (\code{sum(R)} from output
#' value of \code{R}) until \code{Tfinal}.
#' @param x an object of class \code{eEvents} returned from \code{eEvents()}.
#' @param digits which controls number of digits for printing.
#' @param ... Other arguments that may be passed to the generic print function.
#' @return \code{eEvents()} and \code{print.eEvents()} return an object of
#' class \code{eEvents} which contains the following items: \item{lambda}{as
#' input; converted to a matrix on output.} \item{eta}{as input; converted to a
#' matrix on output.} \item{gamma}{as input.} \item{R}{as input.} \item{S}{as
#' input.} \item{T}{as input.} \item{Tfinal}{planned duration of study.}
#' \item{minfup}{as input.} \item{d}{expected number of events.}
#' \item{n}{expected sample size.} \item{digits}{as input.}
#' @examples
#' 
#' # 3 enrollment periods, 3 piecewise exponential failure rates
#' str(eEvents(
#'   lambda = c(.05, .02, .01), eta = .01, gamma = c(5, 10, 20),
#'   R = c(2, 1, 2), S = c(1, 1), T = 20
#' ))
#' 
#' # control group for example from Bernstein and Lagakos (1978)
#' lamC <- c(1, .8, .5)
#' n <- eEvents(
#'   lambda = matrix(c(lamC, lamC * 2 / 3), ncol = 6), eta = 0,
#'   gamma = matrix(.5, ncol = 6), R = 2, T = 4
#' )
#' 
#' @aliases print.eEvents
#' @author Keaven Anderson \email{keaven_anderson@@merck.com}
#' @seealso \link{gsDesign package overview}, \link{plot.gsDesign}, 
#' \code{\link{gsDesign}}, \code{\link{gsHR}},
#' \code{\link{nSurvival}}
#' @references Lachin JM and Foulkes MA (1986), Evaluation of Sample Size and
#' Power for Analyses of Survival with Allowance for Nonuniform Patient Entry,
#' Losses to Follow-Up, Noncompliance, and Stratification. \emph{Biometrics},
#' 42, 507-519.
#'
#' Bernstein D and Lagakos S (1978), Sample size and power determination for
#' stratified clinical trials. \emph{Journal of Statistical Computation and
#' Simulation}, 8:65-73.
#' @keywords design
#' @rdname eEvents
#' @export
# eEvents function [sinew] ----
eEvents <- function(lambda = 1, eta = 0, gamma = 1, R = 1, S = NULL, T = 2,
                    Tfinal = NULL, minfup = 0, digits = 4) {
  if (is.null(Tfinal)) {
    if (minfup >= T) {
      stop("Minimum follow-up greater than study duration.")
    }
    Tfinal <- T
    minfupia <- minfup
  }
  else {
    minfupia <- max(0, minfup - (Tfinal - T))
  }

  if (!is.matrix(lambda)) {
    lambda <- matrix(lambda, nrow = length(lambda))
  }
  if (!is.matrix(eta)) {
    eta <- matrix(eta, nrow = nrow(lambda), ncol = ncol(lambda))
  }
  if (!is.matrix(gamma)) {
    gamma <- matrix(gamma, nrow = length(R), ncol = ncol(lambda))
  }
  n <- rep(0, ncol(lambda))
  d <- n
  for (i in 1:ncol(lambda))
  {
    # KA: updated following line with as.vector statements 10/16/2017
    a <- eEvents1(
      lambda = as.vector(lambda[,i]), eta = as.vector(eta[,i]),
      gamma = as.vector(gamma[,i]), R = R, S = S, T = T,
      Tfinal = Tfinal, minfup = minfup
    )
    n[i] <- a$n
    d[i] <- a$d
  }
  T1 <- cumsum(S)
  T1 <- unique(c(0, T1[T1 < T], T))
  nper <- length(T1) - 1
  names1 <- round(T1[1:nper], digits)
  namesper <- paste("-", round(T1[2:(nper + 1)], digits), sep = "")
  namesper <- paste(names1, namesper, sep = "")
  if (nper < dim(lambda)[1]) {
    lambda <- matrix(lambda[1:nper, ], nrow = nper)
  }
  if (nper < dim(eta)[1]) {
    eta <- matrix(eta[1:nper, ], nrow = nper)
  }
  rownames(lambda) <- namesper
  rownames(eta) <- namesper
  colnames(lambda) <- paste("Stratum", 1:ncol(lambda))
  colnames(eta) <- paste("Stratum", 1:ncol(eta))
  T2 <- cumsum(R)
  T2[T - T2 < minfupia] <- T - minfupia
  T2 <- unique(c(0, T2))
  nper <- length(T2) - 1
  names1 <- round(c(T2[1:nper]), digits)
  namesper <- paste("-", round(T2[2:(nper + 1)], digits), sep = "")
  namesper <- paste(names1, namesper, sep = "")
  if (nper < length(gamma)) {
    gamma <- matrix(gamma[1:nper, ], nrow = nper)
  }
  rownames(gamma) <- namesper
  colnames(gamma) <- paste("Stratum", 1:ncol(gamma))
  x <- list(
    lambda = lambda, eta = eta, gamma = gamma, R = R,
    S = S, T = T, Tfinal = Tfinal,
    minfup = minfup, d = d, n = n, digits = digits
  )
  class(x) <- "eEvents"
  return(x)
}

# periods function [sinew] ----
periods <- function(S, T, minfup, digits) {
  periods <- cumsum(S)
  if (length(periods) == 0) {
    periods <- max(0, T - minfup)
  } else {
    maxT <- max(0, min(T - minfup, max(periods)))
    periods <- periods[periods <= maxT]
    if (max(periods) < T - minfup) {
      periods <- c(periods, T - minfup)
    }
  }
  nper <- length(periods)
  names1 <- c(0, round(periods[1:(nper - 1)], digits))
  names <- paste("-", periods, sep = "")
  names <- paste(names1, names, sep = "")
  return(list(periods, names))
}

# print.eEvents roxy [sinew] ----
#' @rdname eEvents
#' @export
# print.eEvents function [sinew] ----
print.eEvents <- function(x, digits = 4, ...) {
  if (class(x) != "eEvents") {
    stop("print.eEvents: primary argument must have class eEvents")
  }
  cat("Study duration:              Tfinal=",
    round(x$Tfinal, digits), "\n",
    sep = ""
  )
  cat("Analysis time:                    T=",
    round(x$T, digits), "\n",
    sep = ""
  )
  cat("Accrual duration:                   ",
    round(min(
      x$T - max(0, x$minfup - (x$Tfinal - x$T)),
      sum(x$R)
    ), digits), "\n",
    sep = ""
  )
  cat("Min. end-of-study follow-up: minfup=",
    round(x$minfup, digits), "\n",
    sep = ""
  )
  cat("Expected events (total):            ",
    round(sum(x$d), digits), "\n",
    sep = ""
  )
  if (length(x$d) > 1) {
    cat(
      "Expected events by stratum:       d=",
      round(x$d[1], digits)
    )
    for (i in 2:length(x$d))
      cat(paste("", round(x$d[i], digits)))
    cat("\n")
  }
  cat("Expected sample size (total):       ",
    round(sum(x$n), digits), "\n",
    sep = ""
  )
  if (length(x$n) > 1) {
    cat(
      "Sample size by stratum:           n=",
      round(x$n[1], digits)
    )
    for (i in 2:length(x$n))
      cat(paste("", round(x$n[i], digits)))
    cat("\n")
  }
  nstrata <- dim(x$lambda)[2]
  cat("Number of strata:                   ",
    nstrata, "\n",
    sep = ""
  )
  cat("Accrual rates:\n")
  print(round(x$gamma, digits))
  cat("Event rates:\n")
  print(round(x$lambda, digits))
  cat("Censoring rates:\n")
  print(round(x$eta, digits))
  return(x)
}

# nameperiod function [sinew] ----
nameperiod <- function(R, digits = 2) {
  if (length(R) == 1) return(paste("0-", round(R, digits), sep = ""))
  R0 <- c(0, R[1:(length(R) - 1)])
  return(paste(round(R0, digits), "-", round(R, digits), sep = ""))
}

# LFPWE function [sinew] ----
LFPWE <- function(alpha = .025, sided = 1, beta = .1,
                  lambdaC = log(2) / 6, hr = .5, hr0 = 1, etaC = 0, etaE = 0,
                  gamma = 1, ratio = 1, R = 18, S = NULL, T = 24, minfup = NULL) {

  # set up parameters
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

# print.nSurv roxy [sinew] ----
#' @rdname nSurv
#' @export
# print.nSurv function [sinew] ----
print.nSurv <- function(x, digits = 4, ...) {
  if (class(x) != "nSurv") {
    stop("Primary argument must have class nSurv")
  }
  x$digits <- digits
  x$sided <- 1
  cat("Fixed design, two-arm trial with time-to-event\n")
  cat("outcome (Lachin and Foulkes, 1986).\n")
  cat("Solving for: ", x$variable, "\n")
  cat("Hazard ratio                  H1/H0=",
    round(x$hr, digits),
    "/", round(x$hr0, digits), "\n",
    sep = ""
  )
  cat("Study duration:                   T=",
    round(x$T, digits), "\n",
    sep = ""
  )
  cat("Accrual duration:                   ",
    round(x$T - x$minfup, digits), "\n",
    sep = ""
  )
  cat("Min. end-of-study follow-up: minfup=",
    round(x$minfup, digits), "\n",
    sep = ""
  )
  cat("Expected events (total, H1):        ",
    round(x$d, digits), "\n",
    sep = ""
  )
  cat("Expected sample size (total):       ",
    round(x$n, digits), "\n",
    sep = ""
  )
  enrollper <- periods(x$S, x$T, x$minfup, x$digits)
  cat("Accrual rates:\n")
  print(round(x$gamma, digits))
  cat("Control event rates (H1):\n")
  print(round(x$lambda, digits))
  if (max(abs(x$etaC - x$etaE)) == 0) {
    cat("Censoring rates:\n")
    print(round(x$etaC, digits))
  }
  else {
    cat("Control censoring rates:\n")
    print(round(x$etaC, digits))
    cat("Experimental censoring rates:\n")
    print(round(x$etaE, digits))
  }
  cat("Power:                 100*(1-beta)=",
    round((1 - x$beta) * 100, digits), "%\n",
    sep = ""
  )
  cat("Type I error (", x$sided,
    "-sided):   100*alpha=",
    100 * x$alpha, "%\n",
    sep = ""
  )
  if (min(x$ratio == 1) == 1) {
    cat("Equal randomization:          ratio=1\n")
  } else {
    cat(
      "Randomization (Exp/Control):  ratio=",
      x$ratio, "\n"
    )
  }
}

# KTZ function [sinew] ----
KTZ <- function(x = NULL, minfup = NULL, n1Target = NULL,
                lambdaC = log(2) / 6, etaC = 0, etaE = 0,
                gamma = 1, ratio = 1, R = 18, S = NULL, beta = .1,
                alpha = .025, sided = 1, hr0 = 1, hr = .5, simple = TRUE) {
  zalpha <- -stats::qnorm(alpha / sided)
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
  }
  else if (!is.null(x) && !is.null(minfup)) { # otherwise, if x is given, set it to accrual duration
    T <- x + minfup
    R[length(R)] <- Inf
    variable <- "Accrual duration"
  }
  else { # otherwise, set follow-up time to accrual plus follow-up
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
      return(zb + stats::qnorm(beta))
    } else {
      return(stats::pnorm(-zb))
    }
  }
  # compute power
  power <- stats::pnorm(zb)
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



# nSurv roxy [sinew] ----
#' Advanced time-to-event sample size calculation
#'
#' \code{nSurv()} is used to calculate the sample size for a clinical trial
#' with a time-to-event endpoint and an assumption of proportional hazards.
#' This set of routines is new with version 2.7 and will continue to be
#' modified and refined to improve input error checking and output format with
#' subsequent versions. It allows both the Lachin and Foulkes (1986) method
#' (fixed trial duration) as well as the Kim and Tsiatis(1990) method (fixed
#' enrollment rates and either fixed enrollment duration or fixed minimum
#' follow-up). Piecewise exponential survival is supported as well as piecewise
#' constant enrollment and dropout rates. The methods are for a 2-arm trial
#' with treatment groups referred to as experimental and control. A stratified
#' population is allowed as in Lachin and Foulkes (1986); this method has been
#' extended to derive non-inferiority as well as superiority trials.
#' Stratification also allows power calculation for meta-analyses.
#' \code{gsSurv()} combines \code{nSurv()} with \code{gsDesign()} to derive a
#' group sequential design for a study with a time-to-event endpoint.
#'
#' \code{print()}, \code{xtable()} and \code{summary()} methods are provided to
#' operate on the returned value from \code{gsSurv()}, an object of class
#' \code{gsSurv}. \code{print()} is also extended to \code{nSurv} objects. The
#' functions \code{\link{gsBoundSummary}} (data frame for tabular output),
#' \code{\link{xprint}} (application of \code{xtable} for tabular output) and
#' \code{summary.gsSurv} (textual summary of \code{gsDesign} or \code{gsSurv}
#' object) may be preferred summary functions; see example in vignettes. See
#' also \link{gsBoundSummary} for output
#' of tabular summaries of bounds for designs produced by \code{gsSurv()}.
#'
#' Both \code{nEventsIA} and \code{tEventsIA} require a group sequential design
#' for a time-to-event endpoint of class \code{gsSurv} as input.
#' \code{nEventsIA} calculates the expected number of events under the
#' alternate hypothesis at a given interim time. \code{tEventsIA} calculates
#' the time that the expected number of events under the alternate hypothesis
#' is a given proportion of the total events planned for the final analysis.
#'
#' \code{nSurv()} produces an object of class \code{nSurv} with the number of
#' subjects and events for a set of pre-specified trial parameters, such as
#' accrual duration and follow-up period. The underlying power calculation is
#' based on Lachin and Foulkes (1986) method for proportional hazards assuming
#' a fixed underlying hazard ratio between 2 treatment groups. The method has
#' been extended here to enable designs to test non-inferiority. Piecewise
#' constant enrollment and failure rates are assumed and a stratified
#' population is allowed. See also \code{\link{nSurvival}} for other Lachin and
#' Foulkes (1986) methods assuming a constant hazard difference or exponential
#' enrollment rate.
#'
#' When study duration (\code{T}) and follow-up duration (\code{minfup}) are
#' fixed, \code{nSurv} applies exactly the Lachin and Foulkes (1986) method of
#' computing sample size under the proportional hazards assumption when For
#' this computation, enrollment rates are altered proportionately to those
#' input in \code{gamma} to achieve the power of interest.
#'
#' Given the specified enrollment rate(s) input in \code{gamma}, \code{nSurv}
#' may also be used to derive enrollment duration required for a trial to have
#' defined power if \code{T} is input as \code{NULL}; in this case, both
#' \code{R} (enrollment duration for each specified enrollment rate) and
#' \code{T} (study duration) will be computed on output.
#'
#' Alternatively and also using the fixed enrollment rate(s) in \code{gamma},
#' if minimum follow-up \code{minfup} is specified as \code{NULL}, then the
#' enrollment duration(s) specified in \code{R} are considered fixed and
#' \code{minfup} and \code{T} are computed to derive the desired power. This
#' method will fail if the specified enrollment rates and durations either
#' over-powers the trial with no additional follow-up or underpowers the trial
#' with infinite follow-up. This method produces a corresponding error message
#' in such cases.
#'
#' The input to \code{gsSurv} is a combination of the input to \code{nSurv()}
#' and \code{gsDesign()}.
#'
#' \code{nEventsIA()} is provided to compute the expected number of events at a
#' given point in time given enrollment, event and censoring rates. The routine
#' is used with a root finding routine to approximate the approximate timing of
#' an interim analysis. It is also used to extend enrollment or follow-up of a
#' fixed design to obtain a sufficient number of events to power a group
#' sequential design.
#'
#' @aliases nSurv print.nSurv print.gsSurv xtable.gsSurv
#' @param x An object of class \code{nSurv} or \code{gsSurv}.
#' \code{print.nSurv()} is used for an object of class \code{nSurv} which will
#' generally be output from \code{nSurv()}. For \code{print.gsSurv()} is used
#' for an object of class \code{gsSurv} which will generally be output from
#' \code{gsSurv()}. \code{nEventsIA} and \code{tEventsIA} operate on both the
#' \code{nSurv} and \code{gsSurv} class.
#' @param digits Number of digits past the decimal place to print
#' (\code{print.gsSurv.}); also a pass through to generic \code{xtable()} from
#' \code{xtable.gsSurv()}.
#' @param lambdaC scalar, vector or matrix of event hazard rates for the
#' control group; rows represent time periods while columns represent strata; a
#' vector implies a single stratum.
#' @param hr hazard ratio (experimental/control) under the alternate hypothesis
#' (scalar).
#' @param hr0 hazard ratio (experimental/control) under the null hypothesis
#' (scalar).
#' @param eta scalar, vector or matrix of dropout hazard rates for the control
#' group; rows represent time periods while columns represent strata; if
#' entered as a scalar, rate is constant across strata and time periods; if
#' entered as a vector, rates are constant across strata.
#' @param etaE matrix dropout hazard rates for the experimental group specified
#' in like form as \code{eta}; if NULL, this is set equal to \code{eta}.
#' @param gamma a scalar, vector or matrix of rates of entry by time period
#' (rows) and strata (columns); if entered as a scalar, rate is constant
#' across strata and time periods; if entered as a vector, rates are constant
#' across strata.
#' @param R a scalar or vector of durations of time periods for recruitment
#' rates specified in rows of \code{gamma}. Length is the same as number of
#' rows in \code{gamma}. Note that when variable enrollment duration is
#' specified (input \code{T=NULL}), the final enrollment period is extended as
#' long as needed.
#' @param S a scalar or vector of durations of piecewise constant event rates
#' specified in rows of \code{lambda}, \code{eta} and \code{etaE}; this is NULL
#' if there is a single event rate per stratum (exponential failure) or length
#' of the number of rows in \code{lambda} minus 1, otherwise.
#' @param T study duration; if \code{T} is input as \code{NULL}, this will be
#' computed on output; see details.
#' @param minfup follow-up of last patient enrolled; if \code{minfup} is input
#' as \code{NULL}, this will be computed on output; see details.
#' @param ratio randomization ratio of experimental treatment divided by
#' control; normally a scalar, but may be a vector with length equal to number
#' of strata.
#' @param sided 1 for 1-sided testing, 2 for 2-sided testing.
#' @param alpha type I error rate. Default is 0.025 since 1-sided testing is
#' default.
#' @param beta type II error rate. Default is 0.10 (90\% power); NULL if power
#' is to be computed based on other input values.
#' @param tol for cases when \code{T} or \code{minfup} values are derived
#' through root finding (\code{T} or \code{minfup} input as \code{NULL}),
#' \code{tol} provides the level of error input to the \code{uniroot()}
#' root-finding function. The default is the same as for \code{\link{uniroot}}.
#' @param k Number of analyses planned, including interim and final.
#' @param test.type \code{1=}one-sided \cr \code{2=}two-sided symmetric \cr
#' \code{3=}two-sided, asymmetric, beta-spending with binding lower bound \cr
#' \code{4=}two-sided, asymmetric, beta-spending with non-binding lower bound
#' \cr \code{5=}two-sided, asymmetric, lower bound spending under the null
#' hypothesis with binding lower bound \cr \code{6=}two-sided, asymmetric,
#' lower bound spending under the null hypothesis with non-binding lower bound.
#' \cr See details, examples and manual.
#' @param astar Normally not specified. If \code{test.type=5} or \code{6},
#' \code{astar} specifies the total probability of crossing a lower bound at
#' all analyses combined.  This will be changed to \eqn{1 - }\code{alpha} when
#' default value of 0 is used.  Since this is the expected usage, normally
#' \code{astar} is not specified by the user.
#' @param timing Sets relative timing of interim analyses in \code{gsSurv}.
#' Default of 1 produces equally spaced analyses.  Otherwise, this is a vector
#' of length \code{k} or \code{k-1}.  The values should satisfy \code{0 <
#' timing[1] < timing[2] < ... < timing[k-1] < timing[k]=1}. For
#' \code{tEventsIA}, this is a scalar strictly between 0 and 1 that indicates
#' the targeted proportion of final planned events available at an interim
#' analysis.
#' @param sfu A spending function or a character string indicating a boundary
#' type (that is, \dQuote{WT} for Wang-Tsiatis bounds, \dQuote{OF} for
#' O'Brien-Fleming bounds and \dQuote{Pocock} for Pocock bounds).  For
#' one-sided and symmetric two-sided testing is used to completely specify
#' spending (\code{test.type=1, 2}), \code{sfu}.  The default value is
#' \code{sfHSD} which is a Hwang-Shih-DeCani spending function.  See details,
#' \link{Spending_Function_Overview}, manual and examples.
#' @param sfupar Real value, default is \eqn{-4} which is an
#' O'Brien-Fleming-like conservative bound when used with the default
#' Hwang-Shih-DeCani spending function. This is a real-vector for many spending
#' functions.  The parameter \code{sfupar} specifies any parameters needed for
#' the spending function specified by \code{sfu}; this will be ignored for
#' spending functions (\code{sfLDOF}, \code{sfLDPocock}) or bound types
#' (\dQuote{OF}, \dQuote{Pocock}) that do not require parameters.
#' @param sfl Specifies the spending function for lower boundary crossing
#' probabilities when asymmetric, two-sided testing is performed
#' (\code{test.type = 3}, \code{4}, \code{5}, or \code{6}).  Unlike the upper
#' bound, only spending functions are used to specify the lower bound.  The
#' default value is \code{sfHSD} which is a Hwang-Shih-DeCani spending
#' function.  The parameter \code{sfl} is ignored for one-sided testing
#' (\code{test.type=1}) or symmetric 2-sided testing (\code{test.type=2}).  See
#' details, spending functions, manual and examples.
#' @param sflpar Real value, default is \eqn{-2}, which, with the default
#' Hwang-Shih-DeCani spending function, specifies a less conservative spending
#' rate than the default for the upper bound.
#' @param r Integer value controlling grid for numerical integration as in
#' Jennison and Turnbull (2000); default is 18, range is 1 to 80. Larger values
#' provide larger number of grid points and greater accuracy.  Normally
#' \code{r} will not be changed by the user.
#' @param usTime Default is NULL in which case upper bound spending time is 
#' determined by \code{timing}. Otherwise, this should be a vector of length 
#' code{k} with the spending time at each analysis (see Details in help for \code{gsDesign}).
#' @param lsTime Default is NULL in which case lower bound spending time is 
#' determined by \code{timing}. Otherwise, this should be a vector of length 
#' \code{k} with the spending time at each analysis (see Details in help for \code{gsDesign}).
#' @param tIA Timing of an interim analysis; should be between 0 and
#' \code{y$T}.
#' @param target The targeted proportion of events at an interim analysis. This
#' is used for root-finding will be 0 for normal use.
#' @param simple See output specification for \code{nEventsIA()}.
#' @param footnote footnote for xtable output; may be useful for describing
#' some of the design parameters.
#' @param fnwid a text string controlling the width of footnote text at the
#' bottom of the xtable output.
#' @param timename character string with plural of time units (e.g., "months")
#' @param caption passed through to generic \code{xtable()}.
#' @param label passed through to generic \code{xtable()}.
#' @param align passed through to generic \code{xtable()}.
#' @param display passed through to generic \code{xtable()}.
#' @param auto passed through to generic \code{xtable()}.
#' @param ... other arguments that may be passed to generic functions
#' underlying the methods here.
#' @return \code{nSurv()} returns an object of type \code{nSurv} with the
#' following components: \item{alpha}{As input.} \item{sided}{As input.}
#' \item{beta}{Type II error; if missing, this is computed.} \item{power}{Power
#' corresponding to input \code{beta} or computed if output \code{beta} is
#' computed.} \item{lambdaC}{As input.} \item{etaC}{As input.} \item{etaE}{As
#' input.} \item{gamma}{As input unless none of the following are \code{NULL}:
#' \code{T}, \code{minfup}, \code{beta}; otherwise, this is a constant times
#' the input value required to power the trial given the other input
#' variables.} \item{ratio}{As input.} \item{R}{As input unless \code{T} was
#' \code{NULL} on input.} \item{S}{As input.} \item{T}{As input.}
#' \item{minfup}{As input.} \item{hr}{As input.} \item{hr0}{As input.}
#' \item{n}{Total expected sample size corresponding to output accrual rates
#' and durations.} \item{d}{Total expected number of events under the alternate
#' hypothesis.} \item{tol}{As input, except when not used in computations in
#' which case this is returned as \code{NULL}.  This and the remaining output
#' below are not printed by the \code{print()} extension for the \code{nSurv}
#' class.} \item{eDC}{A vector of expected number of events by stratum in the
#' control group under the alternate hypothesis.} \item{eDE}{A vector of
#' expected number of events by stratum in the experimental group under the
#' alternate hypothesis.} \item{eDC0}{A vector of expected number of events by
#' stratum in the control group under the null hypothesis.} \item{eDE0}{A
#' vector of expected number of events by stratum in the experimental group
#' under the null hypothesis.} \item{eNC}{A vector of the expected accrual in
#' each stratum in the control group.} \item{eNE}{A vector of the expected
#' accrual in each stratum in the experimental group.} \item{variable}{A text
#' string equal to "Accrual rate" if a design was derived by varying the
#' accrual rate, "Accrual duration" if a design was derived by varying the
#' accrual duration, "Follow-up duration" if a design was derived by varying
#' follow-up duration, or "Power" if accrual rates and duration as well as
#' follow-up duration was specified and \code{beta=NULL} was input.}
#'
#' \code{gsSurv()} returns much of the above plus an object of class
#' \code{gsDesign} in a variable named \code{gs}; see \code{\link{gsDesign}}
#' for general documentation on what is returned in \code{gs}.  The value of
#' \code{gs$n.I} represents the number of endpoints required at each analysis
#' to adequately power the trial. Other items returned by \code{gsSurv()} are:
#' \item{gs}{A group sequential design (\code{gsDesign}) object.}
#' \item{lambdaC}{As input.} \item{etaC}{As input.} \item{etaE}{As input.}
#' \item{gamma}{As input unless none of the following are \code{NULL}:
#' \code{T}, \code{minfup}, \code{beta}; otherwise, this is a constant times
#' the input value required to power the trial given the other input
#' variables.} \item{ratio}{As input.} \item{R}{As input unless \code{T} was
#' \code{NULL} on input.} \item{S}{As input.} \item{T}{As input.}
#' \item{minfup}{As input.} \item{hr}{As input.} \item{hr0}{As input.}
#' \item{eNC}{Total expected sample size corresponding to output accrual rates
#' and durations.} \item{eNE}{Total expected sample size corresponding to
#' output accrual rates and durations.} \item{eDC}{Total expected number of
#' events under the alternate hypothesis.} \item{eDE}{Total expected number of
#' events under the alternate hypothesis.} \item{tol}{As input, except when not
#' used in computations in which case this is returned as \code{NULL}.  This
#' and the remaining output below are not printed by the \code{print()}
#' extension for the \code{nSurv} class.} \item{eDC}{A vector of expected
#' number of events by stratum in the control group under the alternate
#' hypothesis.} \item{eDE}{A vector of expected number of events by stratum in
#' the experimental group under the alternate hypothesis.} \item{eDC0}{A vector
#' of expected number of events by stratum in the control group under the null
#' hypothesis.} \item{eDE0}{A vector of expected number of events by stratum in
#' the experimental group under the null hypothesis.} \item{eNC}{A vector of
#' the expected accrual in each stratum in the control group.} \item{eNE}{A
#' vector of the expected accrual in each stratum in the experimental group.}
#' \item{variable}{A text string equal to "Accrual rate" if a design was
#' derived by varying the accrual rate, "Accrual duration" if a design was
#' derived by varying the accrual duration, "Follow-up duration" if a design
#' was derived by varying follow-up duration, or "Power" if accrual rates and
#' duration as well as follow-up duration was specified and \code{beta=NULL}
#' was input.}
#'
#' \code{nEventsIA()} returns the expected proportion of the final planned
#' events observed at the input analysis time minus \code{target} when
#' \code{simple=TRUE}. When \code{simple=FALSE}, \code{nEventsIA} returns a
#' list with following components: \item{T}{The input value \code{tIA}.}
#' \item{eDC}{The expected number of events in the control group at time the
#' output time \code{T}.} \item{eDE}{The expected number of events in the
#' experimental group at the output time \code{T}.} \item{eNC}{The expected
#' enrollment in the control group at the output time \code{T}.} \item{eNE}{The
#' expected enrollment in the experimental group at the output time \code{T}.}
#'
#' \code{tEventsIA()} returns
#' @author Keaven Anderson \email{keaven_anderson@@merck.com}
#' @seealso \code{\link{gsBoundSummary}}, \code{\link{xprint}},
#' \link{gsDesign package overview}, \link{plot.gsDesign},
#' \code{\link{gsDesign}}, \code{\link{gsHR}}, \code{\link{nSurvival}}
#' @references Kim KM and Tsiatis AA (1990), Study duration for clinical trials
#' with survival response and early stopping rule. \emph{Biometrics}, 46, 81-92
#'
#' Lachin JM and Foulkes MA (1986), Evaluation of Sample Size and Power for
#' Analyses of Survival with Allowance for Nonuniform Patient Entry, Losses to
#' Follow-Up, Noncompliance, and Stratification. \emph{Biometrics}, 42,
#' 507-519.
#'
#' Schoenfeld D (1981), The Asymptotic Properties of Nonparametric Tests for
#' Comparing Survival Distributions. \emph{Biometrika}, 68, 316-319.
#' @keywords design
#' @examples
#' 
#' # vary accrual rate to obtain power
#' nSurv(lambdaC = log(2) / 6, hr = .5, eta = log(2) / 40, gamma = 1, T = 36, minfup = 12)
#' 
#' # vary accrual duration to obtain power
#' nSurv(lambdaC = log(2) / 6, hr = .5, eta = log(2) / 40, gamma = 6, minfup = 12)
#' 
#' # vary follow-up duration to obtain power
#' nSurv(lambdaC = log(2) / 6, hr = .5, eta = log(2) / 40, gamma = 6, R = 25)
#' 
#' # piecewise constant enrollment rates (vary accrual duration)
#' nSurv(
#'   lambdaC = log(2) / 6, hr = .5, eta = log(2) / 40, gamma = c(1, 3, 6),
#'   R = c(3, 6, 9), minfup = 12
#' )
#' 
#' # stratified population (vary accrual duration)
#' nSurv(
#'   lambdaC = matrix(log(2) / c(6, 12), ncol = 2), hr = .5, eta = log(2) / 40,
#'   gamma = matrix(c(2, 4), ncol = 2), minfup = 12
#' )
#' 
#' # piecewise exponential failure rates (vary accrual duration)
#' nSurv(lambdaC = log(2) / c(6, 12), hr = .5, eta = log(2) / 40, S = 3, gamma = 6, minfup = 12)
#' 
#' # combine it all: 2 strata, 2 failure rate periods
#' nSurv(
#'   lambdaC = matrix(log(2) / c(6, 12, 18, 24), ncol = 2), hr = .5,
#'   eta = matrix(log(2) / c(40, 50, 45, 55), ncol = 2), S = 3,
#'   gamma = matrix(c(3, 6, 5, 7), ncol = 2), R = c(5, 10), minfup = 12
#' )
#' 
#' # example where only 1 month of follow-up is desired
#' # set failure rate to 0 after 1 month using lambdaC and S
#' nSurv(lambdaC = c(.4, 0), hr = 2 / 3, S = 1, minfup = 1)
#' 
#' # group sequential design (vary accrual rate to obtain power)
#' x <- gsSurv(
#'   k = 4, sfl = sfPower, sflpar = .5, lambdaC = log(2) / 6, hr = .5,
#'   eta = log(2) / 40, gamma = 1, T = 36, minfup = 12
#' )
#' x
#' print(xtable::xtable(x,
#'   footnote = "This is a footnote; note that it can be wide.",
#'   caption = "Caption example."
#' ))
#' # find expected number of events at time 12 in the above trial
#' nEventsIA(x = x, tIA = 10)
#' 
#' # find time at which 1/4 of events are expected
#' tEventsIA(x = x, timing = .25)
#' @export
# nSurv function [sinew] ----
nSurv <- function(lambdaC = log(2) / 6, hr = .6, hr0 = 1, eta = 0, etaE = NULL,
                  gamma = 1, R = 12, S = NULL, T = NULL, minfup = NULL, ratio = 1,
                  alpha = 0.025, beta = 0.10, sided = 1, tol = .Machine$double.eps^0.25) {
  if (is.null(etaE)) etaE <- eta
  # set up rates as matrices with row and column names
  # default is 1 stratum if lambdaC not input as matrix
  if (is.vector(lambdaC)) lambdaC <- matrix(lambdaC)
  ldim <- dim(lambdaC)
  nstrata <- ldim[2]
  nlambda <- ldim[1]
  rownames(lambdaC) <- paste("Period", 1:nlambda)
  colnames(lambdaC) <- paste("Stratum", 1:nstrata)
  etaC <- matrix(eta, nrow = nlambda, ncol = nstrata)
  etaE <- matrix(etaE, nrow = nlambda, ncol = nstrata)
  if (!is.matrix(gamma)) gamma <- matrix(gamma)
  gdim <- dim(gamma)
  eCdim <- dim(etaC)
  eEdim <- dim(etaE)

  if (is.null(minfup) || is.null(T)) {
    xx <- KT(
      lambdaC = lambdaC, hr = hr, hr0 = hr0, etaC = etaC, etaE = etaE,
      gamma = gamma, R = R, S = S, minfup = minfup, ratio = ratio,
      alpha = alpha, sided = sided, beta = beta, tol = tol
    )
  } else if (is.null(beta)) {
    xx <- KTZ(
      lambdaC = lambdaC, hr = hr, hr0 = hr0, etaC = etaC, etaE = etaE,
      gamma = gamma, R = R, S = S, minfup = minfup, ratio = ratio,
      alpha = alpha, sided = sided, beta = beta, simple = F
    )
  } else {
    xx <- LFPWE(
      lambdaC = lambdaC, hr = hr, hr0 = hr0, etaC = etaC, etaE = etaE,
      gamma = gamma, R = R, S = S, T = T, minfup = minfup, ratio = ratio,
      alpha = alpha, sided = sided, beta = beta
    )
  }

  nameR <- nameperiod(cumsum(xx$R))
  stratnames <- paste("Stratum", 1:ncol(xx$lambdaC))
  if (is.null(xx$S)) {
    nameS <- "0-Inf"
  } else {
    nameS <- nameperiod(cumsum(c(xx$S, Inf)))
  }
  rownames(xx$lambdaC) <- nameS
  colnames(xx$lambdaC) <- stratnames
  rownames(xx$etaC) <- nameS
  colnames(xx$etaC) <- stratnames
  rownames(xx$etaE) <- nameS
  colnames(xx$etaE) <- stratnames
  rownames(xx$gamma) <- nameR
  colnames(xx$gamma) <- stratnames
  return(xx)
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
  }
  else if (x$variable == "Accrual duration") {
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
  }
  else {
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

# tEventsIA roxy [sinew] ----
#' @export 
#' @rdname nSurv
#' @seealso 
#'  \code{\link[stats]{uniroot}}
#' @importFrom stats uniroot
# tEventsIA function [sinew] ----
tEventsIA <- function(x, timing = .25, tol = .Machine$double.eps^0.25) {
  T <- x$T[length(x$T)]
  z <- stats::uniroot(
    f = nEventsIA, interval = c(0.0001, T - .0001), x = x,
    target = timing, tol = tol, simple = TRUE
  )
  return(nEventsIA(tIA = z$root, x = x, simple = FALSE))
}

# nEventsIA roxy [sinew] ----
#' @export 
#' @rdname nSurv
# nEventsIA function [sinew] ----
nEventsIA <- function(tIA = 5, x = NULL, target = 0, simple = TRUE) {
  Qe <- x$ratio / (1 + x$ratio)
  eDC <- eEvents(
    lambda = x$lambdaC, eta = x$etaC,
    gamma = x$gamma * (1 - Qe), R = x$R, S = x$S, T = tIA,
    Tfinal = x$T[length(x$T)], minfup = x$minfup
  )
  eDE <- eEvents(
    lambda = x$lambdaC * x$hr, eta = x$etaC,
    gamma = x$gamma * Qe, R = x$R, S = x$S, T = tIA,
    Tfinal = x$T[length(x$T)], minfup = x$minfup
  )
  if (simple) {
    if (class(x)[1] == "gsSize") {
      d <- x$d
    } # OLD      else d <- sum(x$eDC[length(x$eDC)]+x$eDE[length(x$eDE)])
    else if (!is.matrix(x$eDC)) {
      d <- sum(x$eDC[length(x$eDC)] + x$eDE[length(x$eDE)])
    } else {
      d <- sum(x$eDC[nrow(x$eDC), ] + x$eDE[nrow(x$eDE), ])
    }
    return(sum(eDC$d + eDE$d) - target * d)
  }
  else {
    return(list(T = tIA, eDC = eDC$d, eDE = eDE$d, eNC = eDC$n, eNE = eDE$n))
  }
}

# gsSurv roxy [sinew] ----
#' @rdname nSurv
#' @export
# gsSurv function [sinew] ----
gsSurv <- function(k = 3, test.type = 4, alpha = 0.025, sided = 1,
                   beta = 0.1, astar = 0, timing = 1, sfu = sfHSD, sfupar = -4,
                   sfl = sfHSD, sflpar = -2, r = 18,
                   lambdaC = log(2) / 6, hr = .6, hr0 = 1, eta = 0, etaE = NULL,
                   gamma = 1, R = 12, S = NULL, T = NULL, minfup = NULL, ratio = 1,
                   tol = .Machine$double.eps^0.25, 
                   usTime = NULL, lsTime = NULL) # KA: last 2 arguments added 10/8/2017
  {
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
    usTime = usTime, lsTime = lsTime) # KA: last 2 arguments added 10/8/2017
  
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
      x$T, (x$eNC + x$eNE) %*% rep(1, ncol(x$eNE)),
      (x$eDC + x$eDE) %*% rep(1, ncol(x$eNE)),
      round(zn2hr(x$lower$bound, x$n.I, x$ratio, hr0 = x$hr0, hr1 = x$hr), 3),
      round(zn2hr(x$upper$bound, x$n.I, x$ratio, hr0 = x$hr0, hr1 = x$hr), 3)
    )
    colnames(y) <- c("T", "n", "Events", "HR futility", "HR efficacy")
  } else {
    y <- cbind(
      x$T, (x$eNC + x$eNE) %*% rep(1, ncol(x$eNE)),
      (x$eDC + x$eDE) %*% rep(1, ncol(x$eNE)),
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
  }
  else {
    cat("Control censoring rates:\n")
    print(round(x$etaC, digits))
    cat("Experimental censoring rates:\n")
    print(round(x$etaE, digits))
  }
}

# xtable.gsSurv roxy [sinew] ----
#' @seealso 
#'  \code{\link[stats]{Normal}}
#'  \code{\link[xtable]{xtable}}
#' @importFrom stats pnorm
#' @rdname nSurv
#' @export
# xtable.gsSurv function [sinew] ----
xtable.gsSurv <- function(x, caption = NULL, label = NULL, align = NULL, digits = NULL,
                          display = NULL, auto = FALSE, footnote = NULL, fnwid = "9cm", timename = "months", ...) {
  k <- x$k
  stat <- c(
    "Z-value", "HR", "p (1-sided)", paste("P\\{Cross\\} if HR=", x$hr0, sep = ""),
    paste("P\\{Cross\\} if HR=", x$hr, sep = "")
  )
  st <- stat
  for (i in 2:k) stat <- c(stat, st)
  an <- rep(" ", 5 * k)
  tim <- an
  enrol <- an
  fut <- an
  eff <- an
  an[5 * (0:(k - 1)) + 1] <- c(paste("IA ", as.character(1:(k - 1)), ": ",
    as.character(round(100 * x$timing[1:(k - 1)], 1)), "\\%",
    sep = ""
  ), "Final analysis")
  an[5 * (1:(k - 1)) + 1] <- paste("\\hline", an[5 * (1:(k - 1)) + 1])
  an[5 * (0:(k - 1)) + 2] <- paste("N:", ceiling(rowSums(x$eNC)) + ceiling(rowSums(x$eNE)))
  an[5 * (0:(k - 1)) + 3] <- paste("Events:", ceiling(rowSums(x$eDC + x$eDE)))
  an[5 * (0:(k - 1)) + 4] <- paste(round(x$T, 1), timename, sep = " ")
  if (x$test.type != 1) fut[5 * (0:(k - 1)) + 1] <- as.character(round(x$lower$bound, 2))
  eff[5 * (0:(k - 1)) + 1] <- as.character(round(x$upper$bound, 2))
  if (x$test.type != 1) fut[5 * (0:(k - 1)) + 2] <- as.character(round(gsHR(z = x$lower$bound, i = 1:k, x, ratio = x$ratio) * x$hr0, 2))
  eff[5 * (0:(k - 1)) + 2] <- as.character(round(gsHR(z = x$upper$bound, i = 1:k, x, ratio = x$ratio) * x$hr0, 2))
  asp <- as.character(round(stats::pnorm(-x$upper$bound), 4))
  asp[asp == "0"] <- "$< 0.0001$"
  eff[5 * (0:(k - 1)) + 3] <- asp
  asp <- as.character(round(cumsum(x$upper$prob[, 1]), 4))
  asp[asp == "0"] <- "$< 0.0001$"
  eff[5 * (0:(k - 1)) + 4] <- asp
  asp <- as.character(round(cumsum(x$upper$prob[, 2]), 4))
  asp[asp == "0"] <- "$< 0.0001$"
  eff[5 * (0:(k - 1)) + 5] <- asp
  if (x$test.type != 1) {
    bsp <- as.character(round(stats::pnorm(-x$lower$bound), 4))
    bsp[bsp == "0"] <- " $< 0.0001$"
    fut[5 * (0:(k - 1)) + 3] <- bsp
    bsp <- as.character(round(cumsum(x$lower$prob[, 1]), 4))
    bsp[bsp == "0"] <- "$< 0.0001$"
    fut[5 * (0:(k - 1)) + 4] <- bsp
    bsp <- as.character(round(cumsum(x$lower$prob[, 2]), 4))
    bsp[bsp == "0"] <- "$< 0.0001$"
    fut[5 * (0:(k - 1)) + 5] <- bsp
  }
  neff <- length(eff)
  if (!is.null(footnote)) {
    eff[neff] <-
      paste(eff[neff], "\\\\ \\hline \\multicolumn{4}{p{", fnwid, "}}{\\footnotesize", footnote, "}")
  }
  if (x$test.type != 1) {
    xxtab <- data.frame(cbind(an, stat, fut, eff))
    colnames(xxtab) <- c("Analysis", "Value", "Futility", "Efficacy")
  } else {
    xxtab <- data.frame(cbind(an, stat, eff))
    colnames(xxtab) <- c("Analysis", "Value", "Efficacy")
  }
  return(xtable::xtable(xxtab,
    caption = caption, label = label, align = align, digits = digits,
    display = display, auto = auto, ...
  ))
}

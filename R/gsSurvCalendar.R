#' Group sequential design with calendar-based timing of analyses.
#' This is like gsSurv(), but the timing of analyses is specified in calendar time units.
#' Information fraction is computed from the input rates and the calendar times.
#' Spending can be based on information fraction as in Lan and DeMets (1983) or calendar 
#' time units as in Lan and DeMets (1989).
#'
#' @rdname gsSurvCalendar
#' @param test.type
#'
#' @param alpha Type I error rate. Default is 0.025 since 1-sided testing is default.
#' @param sided 1 for 1-sided testing, 2 for 2-sided testing.
#' @param beta Type II error rate. Default is 0.10 (90\% power); NULL if power is to be computed based on other input values.
#' @param astar Normally not specified. If \code{test.type=5} or \code{6}, \code{astar} specifies the total probability of crossing a lower bound at all analyses combined. This will be changed to \code{1−alpha} when default value of \code{0} is used. Since this is the expected usage, normally \code{astar} is not specified by the user.
#' @param sfu A spending function or a character string indicating a boundary type (that is, “WT” for Wang-Tsiatis bounds, “OF” for O'Brien-Fleming bounds and “Pocock” for Pocock bounds). For one-sided and symmetric two-sided testing is used to completely specify spending (\code{test.type=1, 2}), \code{sfu}. The default value is \code{sfHSD} which is a Hwang-Shih-DeCani spending function.
#' @param sfupar Real value, default is −4 which is an O'Brien-Fleming-like conservative bound when used with the default Hwang-Shih-DeCani spending function. This is a real-vector for many spending functions. The parameter sfupar specifies any parameters needed for the spending function specified by sfu; this will be ignored for spending functions (\code{sfLDOF}, \code{sfLDPocock}) or bound types (\code{“OF”, “Pocock”}) that do not require parameters.
#' @param sfl Specifies the spending function for lower boundary crossing probabilities when asymmetric, two-sided testing is performed (\code{test.type = 3, 4, 5, or 6}). Unlike the upper bound, only spending functions are used to specify the lower bound. The default value is \code{sfHSD} which is a Hwang-Shih-DeCani spending function. The parameter \code{sfl} is ignored for one-sided testing (\code{test.type=1}) or symmetric 2-sided testing (\code{test.type=2}).
#' @param sflpar Real value, default is −2, which, with the default Hwang-Shih-DeCani spending function, specifies a less conservative spending rate than the default for the upper bound.
#' @param calendarTime Vector of increasing positive numbers with calendar times of analyses. Time 0 is start of randomization.
#' @param spending Select between calendar-based spending and information-based spending.
#' @param lambdaC scalar, vector or matrix of event hazard rates for the control group; rows represent time periods while columns represent strata; a vector implies a single stratum.
#' @param hr hazard ratio (experimental/control) under the alternate hypothesis (scalar).
#' @param hr0 hazard ratio (experimental/control) under the null hypothesis (scalar).
#' @param eta scalar, vector or matrix of dropout hazard rates for the control group; rows represent time periods while columns represent strata; if entered as a scalar, rate is constant across strata and time periods; if entered as a vector, rates are constant across strata.
#' @param etaE matrix dropout hazard rates for the experimental group specified in like form as \code{eta}; if \code{NULL}, this is set equal to \code{eta}.
#' @param gamma a scalar, vector or matrix of rates of entry by time period (rows) and strata (columns); if entered as a scalar, rate is constant across strata and time periods; if entered as a vector, rates are constant across strata.
#' @param R a scalar or vector of durations of time periods for recruitment rates specified in rows of gamma. Length is the same as number of rows in gamma. Note that when variable enrollment duration is specified (input T=NULL), the final enrollment period is extended as long as needed.
#' @param S a scalar or vector of durations of piecewise constant event rates specified in rows of lambda, eta and etaE; this is NULL if there is a single event rate per stratum (exponential failure) or length of the number of rows in lambda minus 1, otherwise.
#' @param minfup A non-negative scalar less than the maximum value in \code{calendarTime}. Enrollment will be cut off at the difference between the maximum value in \code{calendarTime} and \code{minfup}.
#' @param ratio randomization ratio of experimental treatment divided by control; normally a scalar, but may be a vector with length equal to number of strata.
#' @param r Integer value controlling grid for numerical integration as in Jennison and Turnbull (2000); default is 18, range is 1 to 80. Larger values provide larger number of grid points and greater accuracy. Normally r will not be changed by the user.
#' @param method Sample-size variance formulation; one of
#' `"LachinFoulkes"` (default), `"Schoenfeld"`, `"Freedman"`,
#' or `"BernsteinLagakos"`. Note: `"Schoenfeld"` and `"Freedman"`
#' methods only support superiority testing (`hr0 = 1`). Additionally,
#' `"Freedman"` does not support stratified populations.
#'
#' @seealso \code{\link{gsSurv}}, \code{\link{gsDesign}}, \code{\link{gsBoundSummary}}
#'
#' @references Lan KKG and DeMets DL (1983), Discrete Sequential Boundaries for Clinical
#' Trials. \emph{Biometrika}, 70, 659-663.
#'
#' Lan KKG and DeMets DL (1989), Group Sequential Procedures: Calendar vs.
#' Information Time. \emph{Statistics in Medicine}, 8, 1191-1198.
#'
#' @export
gsSurvCalendar <- function(
    test.type = 4, alpha = 0.025, sided = 1, beta = 0.1, astar = 0,
    sfu = gsDesign::sfHSD, sfupar = -4,
    sfl = gsDesign::sfHSD, sflpar = -2,
    calendarTime = c(12, 24, 36),
    spending = c("information", "calendar"),
    lambdaC = log(2) / 6, hr = .6, hr0 = 1, eta = 0, etaE = NULL,
    gamma = 1, R = 12, S = NULL, minfup = 18, ratio = 1,
    r = 18, tol = .Machine$double.eps^0.25,
    method = c("LachinFoulkes", "Schoenfeld", "Freedman", "BernsteinLagakos")
    ) {
  method <- match.arg(method)
  input_vals <- list(
    gamma = gamma,
    R = R,
    lambdaC = lambdaC,
    eta = eta,
    etaE = etaE,
    S = S
  )
  if (!is.numeric(calendarTime) || any(is.na(calendarTime)) ||
      any(!is.finite(calendarTime)) || any(diff(calendarTime) <= 0)) {
    stop("calendarTime must be an increasing vector")
  }
  # Validate ratio is a single positive scalar
  if (!is.numeric(ratio) || length(ratio) != 1 || ratio <= 0) {
    stop("ratio must be a single positive scalar")
  }
  x <- nSurv(
    lambdaC = lambdaC, hr = hr, hr0 = hr0, eta = eta, etaE = etaE,
    gamma = gamma, R = R, S = S, T = max(calendarTime),
    minfup = minfup, ratio = ratio,
    alpha = alpha, beta = beta, sided = sided, method = method # , tol = tol
  )

  # Get interim expected event counts and sample size based on
  # input gamma, eta, lambdaC, R, S, minfup

  eDC <- NULL
  eDE <- NULL
  eNC <- NULL
  eNE <- NULL
  k <- length(calendarTime)
  for (i in 1:k) {
    xx <- nEventsIA(tIA = calendarTime[i], x = x, simple = FALSE)
    eDC <- rbind(eDC, xx$eDC)
    eDE <- rbind(eDE, xx$eDE)
    eNC <- rbind(eNC, xx$eNC)
    eNE <- rbind(eNE, xx$eNE)
  }
  timing <- rowSums(eDC) + rowSums(eDE)
  timing <- timing / max(timing)
  # if calendar spending, set usTime, lsTime
  if (spending[1] == "calendar") {
    lsTime <- calendarTime / max(calendarTime)
  } else {
    lsTime <- NULL
  }
  usTime <- lsTime

  # Now inflate events to get targeted power
  y <- gsDesign::gsDesign(
    k = k, test.type = test.type, alpha = alpha / sided,
    beta = beta, astar = astar, n.fix = x$d, timing = timing,
    sfu = sfu, sfupar = sfupar, sfl = sfl, sflpar = sflpar, tol = tol,
    delta1 = log(hr), delta0 = log(hr0),
    usTime = usTime, lsTime = lsTime
  )
  y$hr <- hr
  y$hr0 <- hr0
  y$R <- x$R
  y$S <- x$S
  y$minfup <- x$minfup
  # Inflate fixed design enrollment to get targeted events
  inflate <- max(y$n.I) / x$d
  y$gamma <- x$gamma * inflate
  y$eDC <- inflate * eDC
  y$eDE <- inflate * eDE
  y$eNC <- inflate * eNC
  y$eNE <- inflate * eNE
  y$ratio <- ratio
  y$lambdaC <- x$lambdaC
  y$etaC <- x$etaC
  y$etaE <- x$etaE
  y$variable <- x$variable
  y$tol <- tol
  y$T <- calendarTime
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

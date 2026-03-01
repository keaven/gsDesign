#' Group sequential design with calendar-based timing of analyses
#'
#' This is like \code{gsSurv()}, but the timing of analyses is specified in
#' calendar time units.
#' Information fraction is computed from the input rates and the calendar times.
#' Spending can be based on information fraction as in Lan and DeMets (1983) or
#' calendar  time units as in Lan and DeMets (1989).
#'
#' @inheritParams nSurv
#' @inheritParams gsDesign
#'
#' @param calendarTime Vector of increasing positive numbers
#'   with calendar times of analyses. Time 0 is start of
#'   randomization.
#' @param spending Select between calendar-based spending and
#'   information-based spending.
#' @param R A scalar or vector of durations of time periods for
#'   recruitment rates specified in rows of \code{gamma}. Length is the
#'   same as number of rows in \code{gamma}. Note that when variable
#'   enrollment duration is specified (input \code{T = NULL}), the final
#'   enrollment period is extended as long as needed.
#' @param minfup A non-negative scalar less than the maximum value
#'   in \code{calendarTime}. Enrollment will be cut off at the
#'   difference between the maximum value in \code{calendarTime}
#'   and \code{minfup}.
#' @param tol Tolerance for error passed to the \code{\link{gsDesign}} function.
#'
#' @export
#'
#' @rdname gsSurvCalendar
#'
#' @seealso \code{\link{gsSurv}}, \code{\link{gsDesign}}, \code{\link{gsBoundSummary}}
#'
#' @references
#' Lan KKG and DeMets DL (1983), Discrete Sequential Boundaries for Clinical
#' Trials. \emph{Biometrika}, 70, 659-663.
#'
#' Lan KKG and DeMets DL (1989), Group Sequential Procedures: Calendar vs.
#' Information Time. \emph{Statistics in Medicine}, 8, 1191-1198.
#'
#' Schoenfeld D (1981), The Asymptotic Properties of Nonparametric Tests for
#' Comparing Survival Distributions. \emph{Biometrika}, 68, 316-319.
#'
#' Freedman LS (1982), Tables of the Number of Patients Required in Clinical
#' Trials Using the Logrank Test. \emph{Statistics in Medicine}, 1, 121-129.
#'
#' @examples
#' # First example: while timing is calendar-based, spending is event-based
#' x <- gsSurvCalendar() |> toInteger()
#' gsBoundSummary(x)
#'
#' # Second example: both timing and spending are calendar-based
#' # This results in less spending at interims and leaves more for final analysis
#' y <- gsSurvCalendar(spending = "calendar") |> toInteger()
#' gsBoundSummary(y)
#'
#' # Note that calendar timing for spending relates to planned timing for y
#' # rather than timing in y after toInteger() conversion
#'
#' # Values plugged into spending function for calendar time
#' y$usTime
#' # Actual calendar fraction from design after toInteger() conversion
#' y$T / max(y$T)
gsSurvCalendar <- function(
  test.type = 4, alpha = 0.025, sided = 1, beta = 0.1, astar = 0,
  sfu = gsDesign::sfHSD, sfupar = -4,
  sfl = gsDesign::sfHSD, sflpar = -2,
  sfharm = gsDesign::sfHSD, sfharmparam = -2,
  calendarTime = c(12, 24, 36),
  spending = c("information", "calendar"),
  lambdaC = log(2) / 6, hr = .6, hr0 = 1, eta = 0, etaE = NULL,
  gamma = 1, R = 12, S = NULL, minfup = 18, ratio = 1,
  r = 18, tol = .Machine$double.eps^0.25,
  testUpper = TRUE, testLower = TRUE, testHarm = TRUE,
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
  # If calendar spending, set usTime, lsTime
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
    sfu = sfu, sfupar = sfupar, sfl = sfl, sflpar = sflpar,
    sfharm = sfharm, sfharmparam = sfharmparam, tol = tol,
    delta1 = log(hr), delta0 = log(hr0),
    usTime = usTime, lsTime = lsTime,
    testUpper = testUpper, testLower = testLower, testHarm = testHarm
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

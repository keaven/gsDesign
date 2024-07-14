#' Power for time-to-event endpoint design
#'
#' @param test.type Test type. See \code{\link{gsSurv}}.
#' @param alpha Type I error rate. Default is 0.025 since 1-sided
#'   testing is default.
#' @param sided \code{1} for 1-sided testing, \code{2} for 2-sided testing.
#' @param beta Type II error rate. Default is 0.10
#'   (90\% power); this is used for futility spending for
#'   \code{test.type = 3} or \code{test.type = 4}.
#' @param astar Normally not specified. If \code{test.type = 5}
#'   or \code{test.type = 6}, \code{astar} specifies the total probability
#'   of crossing a lower bound at all analyses combined. This
#'   will be changed to \code{1 - alpha} when default value of
#'   \code{0} is used. Since this is the expected usage,
#'   normally \code{astar} is not specified by the user.
#' @param sfu A spending function or a character string
#'   indicating a boundary type (that is, \code{"WT"} for
#'   Wang-Tsiatis bounds, \code{"OF"} for O'Brien-Fleming bounds and
#'   \code{"Pocock"} for Pocock bounds). For one-sided and symmetric
#'   two-sided testing is used to completely specify spending
#'   (\code{test.type = 1}, \code{2}), \code{sfu}. The default value is
#'   \code{sfHSD} which is a Hwang-Shih-DeCani spending function.
#' @param sfupar Real value, default is \code{-4} which is an
#'   O'Brien-Fleming-like conservative bound when used with the
#'   default Hwang-Shih-DeCani spending function. This is a
#'   real-vector for many spending functions. The parameter
#'   \code{sfupar} specifies any parameters needed for the spending
#'   function specified by \code{sfu}; this will be ignored for
#'   \code{sfLDPocock}) or bound types (\code{"OF"}, \code{"Pocock"})
#'   that do not require parameters. 
#'   For \code{sfu = "sfLDOF"}, \code{sfupar} can be missing in which
#'   case the Lan-DeMets
#' @param sfl Specifies the spending function for lower
#'   boundary crossing probabilities when asymmetric,
#'   two-sided testing is performed
#'   (\code{test.type = 3}, \code{4}, \code{5}, or \code{6}).
#'   Unlike the upper bound,
#'   only spending functions are used to specify the lower bound.
#'   The default value is \code{sfHSD} which is a
#'   Hwang-Shih-DeCani spending function. The parameter
#'   \code{sfl} is ignored for one-sided testing
#'   (\code{test.type = 1}) or symmetric 2-sided testing
#'   (\code{test.type = 2}).
#' @param sflpar Real value, default is \code{-2}, which, with the
#'   default Hwang-Shih-DeCani spending function, specifies a
#'   less conservative spending rate than the default for the
#'   upper bound.
#' @param lambdaC Scalar, vector or matrix of event hazard
#'   rates for the control group; rows represent time periods while
#'   columns represent strata; a vector implies a single stratum.
#' @param hr Hazard ratio (experimental/control) for which power is
#'   to be computed (scalar).
#' @param hr0 Hazard ratio (experimental/control) under the null
#'   hypothesis (scalar).
#' @param hr1 Hazard ratio (experimental/control) under the alternate
#'   hypothesis (scalar).
#' @param eta Scalar, vector or matrix of dropout hazard rates
#'   for the control group; rows represent time periods while
#'   columns represent strata; if entered as a scalar, rate is
#'   constant across strata and time periods; if entered as a
#'   vector, rates are constant across strata.
#' @param etaE Matrix dropout hazard rates for the experimental
#'   group specified in like form as \code{eta}; if \code{NULL},
#'   this is set equal to \code{eta}.
#' @param gamma A scalar, vector or matrix of rates of entry by
#'   time period (rows) and strata (columns); if entered as a
#'   scalar, rate is constant across strata and time periods;
#'   if entered as a vector, rates are constant across strata.
#' @param R A scalar or vector of durations of time periods for
#'   recruitment rates specified in rows of \code{gamma}. Length is the
#'   same as number of rows in \code{gamma}. Note that when variable
#'   enrollment duration is specified (input \code{T = NULL}), the final
#'   enrollment period is extended as long as needed.
#' @param S A scalar or vector of durations of piecewise constant
#'   event rates specified in rows of \code{lambda}, \code{eta} and \code{etaE};
#'   this is \code{NULL} if there is a single event rate per stratum
#'   (exponential failure) or length of the number of rows in \code{lambda}
#'   minus 1, otherwise.
#' @param minfup A non-negative scalar less than the maximum value
#'   in \code{calendarTime}. Enrollment will be cut off at the
#'   difference between the maximum value in \code{calendarTime}
#'   and \code{minfup}.
#' @param ratio Randomization ratio of experimental treatment
#'   divided by control; normally a scalar, but may be a vector with
#'   length equal to number of strata.
#' @param r Integer value controlling grid for numerical
#'   integration as in Jennison and Turnbull (2000); default is 18,
#'   range is 1 to 80. Larger values provide larger number of grid
#'   points and greater accuracy. Normally \code{r} will not be changed by
#'   the user.
#' @param tol Tolerance for error passed to the \code{\link{gsDesign}} function.
#'
#' @export
#'
#' @rdname gsSurvPower
#'
#' @examples
#' # First example: while timing is calendar-based, spending is event-based
#' x <- gsSurvPower() %>% toInteger()
#' gsBoundSummary(x)
#' 
#' # Second example: both timing and spending are calendar-based
#' # This results in less spending at interims and leaves more for final analysis
#' y <- gsSurvPower(spending = "calendar") %>% toInteger()
#' gsBoundSummary(y)
#'
#' # Note that calendar timing for spending relates to planned timing for y
#' # rather than timing in y after toInteger() conversion
#'
#' # Values plugged into spending function for calendar time
#' y$usTime
#' # Actual calendar fraction from design after toInteger() conversion
#' y$T / max(y$T)
gsSurvPower <- function(k = 3, test.type = 4, alpha = 0.025, sided = 1,
                        beta = 0.1, astar = 0, timing = 1, sfu = sfHSD, sfupar = -4,
                        sfl = sfHSD, sflpar = -2, r = 18,
                        lambdaC = log(2) / 6, hr = .7, hr0 = 1, hr1 = .6, eta = 0, etaE = NULL,
                        gamma = 1, R = 12, S = NULL, T = 18, minfup = 6, ratio = 1,
                        tol = .Machine$double.eps^0.25,
                        usTime = NULL, lsTime = NULL) {
    x <- nSurv(
      lambdaC = lambdaC, hr = hr, hr0 = hr0, eta = eta, etaE = etaE,
      gamma = gamma, R = R, S = S, T = T, minfup = minfup, ratio = ratio,
      alpha = alpha, beta = NULL, sided = sided, tol = tol
    )
    y <- gsDesign(
      k = k, test.type = test.type, alpha = alpha / sided,
      beta = beta, astar = astar, n.fix = x$d, timing = timing,
      sfu = sfu, sfupar = sfupar, sfl = sfl, sflpar = sflpar, tol = tol,
      delta1 = log(hr), delta0 = log(hr0),
      usTime = usTime, lsTime = lsTime)
    
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
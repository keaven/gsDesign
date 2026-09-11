#' Median follow-up across all planned participants
#'
#' Compute the modeled population median follow-up at a calendar cutoff, or
#' solve for the earliest cutoff achieving a target median. The population
#' includes everyone in the complete planned enrollment, assigning zero
#' follow-up to participants not yet enrolled. Enrollment is not extended or
#' resized by these functions.
#'
#' @param x Optional \code{nSurv} or \code{gsSurv} design supplying defaults.
#' @param T Finite, nonnegative calendar cutoff vector. Defaults to \code{x$T};
#'   required without a design. Time is measured from trial start.
#' @param gamma Enrollment rates, using the control-arm rate convention of
#'   \code{gsSurv()}. Rows are calendar enrollment periods, columns are strata.
#'   A scalar is constant over periods and strata; a vector specifies periods.
#' @param R Positive enrollment-period durations. Enrollment stops at
#'   \code{sum(R)}. Required with \code{gamma} when not supplied by \code{x}.
#' @param eta Control dropout hazards; finite and nonnegative. Rows are
#'   participant-time hazard intervals, columns are strata. A scalar is
#'   constant over intervals and strata; a vector specifies intervals.
#'   Standalone default is zero.
#' @param etaE Experimental dropout hazards, in the same form as \code{eta}.
#'   When omitted, inherit from \code{x}, otherwise default to \code{eta}.
#'   Explicit \code{NULL} requests equality with the resolved \code{eta}.
#' @param lambdaC Control event hazards, in the same form as \code{eta}.
#'   Required from \code{x} or explicitly when \code{stopAtEvent = TRUE};
#'   otherwise not used or required.
#' @param hr Positive experimental/control event hazard ratio, required when
#'   event stopping is enabled. Experimental event hazards are
#'   \code{lambdaC * hr}. Unlike a design solve, \code{hr = 1} is permitted.
#' @param S Positive durations of event/dropout hazard intervals, excluding
#'   the final interval, which extends indefinitely. These intervals measure
#'   time since each participant enrolled, not calendar time. With \code{K}
#'   hazard rows, \code{length(S) = K - 1}. Omission inherits \code{x$S};
#'   explicit \code{NULL} requests constant hazards. Also used for dropout
#'   when events do not stop follow-up. Enrollment and hazard grids may differ.
#' @param ratio Positive experimental/control allocation ratio; scalar or one
#'   value per stratum. Standalone default is 1.
#' @param stopAtEvent Nonmissing logical scalar. If \code{FALSE} (default),
#'   follow-up stops at dropout or cutoff, ignoring events. If \code{TRUE},
#'   it stops at the first of event, dropout and cutoff.
#' @param tol Positive absolute numerical tolerance in follow-up-time units,
#'   default \code{1e-8}.
#' @param target Required named nonnegative scalar median-follow-up target.
#' @param ... Must be empty. In \code{minMedianFollowUp()}, this guard prevents
#'   old positional cutoff arguments from being silently interpreted as targets.
#'
#' @details Omitted model inputs inherit the design's stored assumptions;
#' explicit non-NULL inputs override them. The exceptions with meaningful
#' explicit NULL values are \code{S} and \code{etaE}, as documented above.
#' Incompatible dimensions are errors, not silently truncated inputs.
#'
#' Within each arm and stratum, event/dropout survival is calculated from
#' piecewise-constant hazards on participant time. For follow-up \code{u >= 0},
#' the proportion with follow-up greater than \code{u} is the planned-population
#' fraction enrolled before \code{T - u}, multiplied by the probability of
#' remaining uncensored through \code{u}, and summed over arms and strata.
#' Arm/stratum weights reflect planned enrollment and randomization.
#' This is a population quantile, not the median of individual expected times,
#' the expected finite-sample median, or a reverse Kaplan-Meier estimate.
#'
#' The lower 0.5 quantile resolves non-unique medians. In particular, the
#' median is zero until more than half the planned population has enrolled.
#' Quantile bisection retains this convention across enrollment pauses and flat
#' portions of the distribution. Without dropout or event stopping, uniform
#' enrollment over 12 months gives median \code{max(0, T - 6)}.
#'
#' The inverse uses bounded bisection: by cutoff \code{sum(R) + target}, all
#' planned participants have had the opportunity to attain the target. If the
#' median is still below target, dropout/event stopping makes that target
#' unattainable, and an informative error is returned. A zero target returns
#' zero. The achieved median is checked against \code{target} within \code{tol}.
#'
#' This replaces the former forward \code{minMedianFollowUp(x, calendarTime)}
#' calculation among participants enrolled to date. Migrate forward calls to
#' \code{medianFollowUp(x, T = ...)}; inverse calls require
#' \code{minMedianFollowUp(x, target = ...)}. This intentionally changes the
#' population definition as well as the function's role.
#'
#' @return \code{medianFollowUp()} returns a numeric median per cutoff;
#' \code{minMedianFollowUp()} returns one calendar cutoff.
#' @seealso \code{\link{gsSurv}}, \code{\link{plotMinMedianFollowUp}}
#' @examples
#' medianFollowUp(T = c(3, 6, 12, 18), gamma = 10, R = 12)
#' minMedianFollowUp(target = 6, gamma = 10, R = 12)
#' x <- gsSurv(gamma = 10, R = 12, T = 30, minfup = 18)
#' medianFollowUp(x)
#' medianFollowUp(x, stopAtEvent = TRUE)
#' minMedianFollowUp(x, target = 3, stopAtEvent = TRUE)
#' medianFollowUp(T = c(12, 18, 24), gamma = c(5, 10), R = c(6, 6),
#'   eta = c(.01, .02), etaE = c(.005, .01),
#'   lambdaC = c(.08, .04), hr = .7, S = 6, stopAtEvent = TRUE)
#' @export
medianFollowUp <- function(x = NULL, T = NULL, gamma = NULL, R = NULL,
                           eta = NULL, etaE = NULL, lambdaC = NULL,
                           hr = NULL, S = NULL, ratio = NULL,
                           stopAtEvent = FALSE, tol = 1e-8) {
  model <- .followUpModel(x, gamma, R, eta, etaE, lambdaC, hr, S, ratio,
                         stopAtEvent, tol, missing(S), missing(etaE))
  if (is.null(T) && !is.null(x)) T <- x$T
  .followUpCheckVector(T, "T", zero = TRUE)
  vapply(T, .followUpMedian, numeric(1), model = model, tol = tol)
}

#' @rdname medianFollowUp
#' @export
minMedianFollowUp <- function(x = NULL, ..., target, gamma = NULL, R = NULL,
                              eta = NULL, etaE = NULL, lambdaC = NULL,
                              hr = NULL, S = NULL, ratio = NULL,
                              stopAtEvent = FALSE, tol = 1e-8) {
  if (length(list(...)) || missing(target)) {
    stop("Supply a named target; for the former forward calculation use medianFollowUp(x, T = ...).")
  }
  .followUpCheckVector(target, "target", zero = TRUE, scalar = TRUE)
  model <- .followUpModel(x, gamma, R, eta, etaE, lambdaC, hr, S, ratio,
                         stopAtEvent, tol, missing(S), missing(etaE))
  if (target == 0) return(0)
  upper <- sum(model$R) + target
  if (!is.finite(upper)) stop("The target and enrollment duration exceed the finite numerical range.")
  median_at <- function(T) .followUpMedian(T, model, tol / 8)
  if (median_at(upper) < target) {
    stop("The requested median follow-up target is unattainable because of dropout/event stopping.")
  }
  cutoff <- .followUpBisect(function(T) median_at(T) >= target, upper, tol / 2)
  if (abs(median_at(cutoff) - target) > tol) {
    stop("Could not achieve the requested median follow-up within tol.")
  }
  cutoff
}

.followUpCheckVector <- function(value, name, zero = FALSE, scalar = FALSE) {
  if (!is.numeric(value) || !is.null(dim(value)) || !length(value) ||
      any(!is.finite(value)) || any(if (zero) value < 0 else value <= 0) ||
      (scalar && length(value) != 1L)) {
    stop(name, " must contain finite, ", if (zero) "nonnegative" else "positive",
         " numeric values", if (scalar) " (one scalar)" else "", ".")
  }
}

.followUpModel <- function(x, gamma, R, eta, etaE, lambdaC, hr, S, ratio,
                           stopAtEvent, tol, inheritS, inheritEtaE) {
  if (!is.null(x) && !inherits(x, c("nSurv", "gsSurv"))) {
    stop("x must be an nSurv or gsSurv object")
  }
  if (!is.logical(stopAtEvent) || length(stopAtEvent) != 1L || is.na(stopAtEvent)) {
    stop("stopAtEvent must be TRUE or FALSE")
  }
  .followUpCheckVector(tol, "tol", scalar = TRUE)
  pick <- function(value, name) if (is.null(value)) x[[name]] else value
  gamma <- pick(gamma, "gamma")
  R <- pick(R, "R")
  eta <- pick(eta, "etaC")
  if (is.null(eta)) eta <- if (!is.null(x$eta)) x$eta else 0
  if (inheritEtaE && !is.null(x$etaE)) etaE <- x$etaE
  if (is.null(etaE)) etaE <- eta
  if (inheritS) S <- pick(S, "S")
  ratio <- pick(ratio, "ratio")
  if (is.null(ratio)) ratio <- 1
  .followUpCheckVector(R, "R")
  if (!is.null(S)) .followUpCheckVector(S, "S")
  .followUpCheckVector(ratio, "ratio")
  if (stopAtEvent) {
    lambdaC <- pick(lambdaC, "lambdaC")
    hr <- pick(hr, "hr")
    if (is.null(lambdaC) || is.null(hr)) stop("lambdaC and hr are required when stopAtEvent = TRUE")
    .followUpCheckVector(hr, "hr", scalar = TRUE)
  } else {
    lambdaC <- 0
    hr <- 1
  }
  rates <- list(gamma = gamma, eta = eta, etaE = etaE, lambdaC = lambdaC)
  for (name in names(rates)) {
    z <- rates[[name]]
    if (!is.numeric(z) || !length(z) || any(!is.finite(z)) || any(z < 0) ||
        (!is.null(dim(z)) && length(dim(z)) != 2L)) {
      stop(name, " must contain finite, nonnegative rates in a scalar, vector or matrix.")
    }
  }
  strata <- max(length(ratio), vapply(rates, function(z) if (is.matrix(z)) ncol(z) else 1L, integer(1)))
  if (!length(ratio) %in% c(1L, strata)) stop("ratio must have one value or one per stratum")
  ratio <- rep(ratio, length.out = strata)
  expand <- function(z, rows, name) {
    if (!is.matrix(z)) z <- matrix(z)
    if (!nrow(z) %in% c(1L, rows) || !ncol(z) %in% c(1L, strata)) {
      stop(name, " has incompatible interval or stratum dimensions.")
    }
    z[rep(seq_len(nrow(z)), length.out = rows),
      rep(seq_len(ncol(z)), length.out = strata), drop = FALSE]
  }
  # Check before accrual_gamma(), which otherwise truncates extra rows in
  # some design-solving workflows. No truncation is appropriate here.
  gamma <- expand(gamma, length(R), "gamma")
  gamma <- accrual_gamma(gamma, R)
  K <- length(S) + 1L
  eta <- expand(eta, K, "eta")
  etaE <- expand(etaE, K, "etaE")
  lambdaC <- expand(lambdaC, K, "lambdaC")
  total <- sum(colSums(gamma * R) * (1 + ratio))
  if (!is.finite(total) || total <= 0) stop("The model must have positive, finite planned enrollment")
  if (!is.finite(sum(R)) || !is.finite(sum(S))) stop("Interval durations exceed the finite numerical range")
  exitC <- eta + lambdaC
  exitE <- etaE + lambdaC * hr
  if (any(!is.finite(exitC)) || any(!is.finite(exitE))) stop("Combined hazards exceed the finite numerical range")
  list(gamma = gamma / total, R = R, startR = c(0, utils::head(cumsum(R), -1L)),
       S = c(S, Inf), startS = c(0, cumsum(S)), ratio = ratio,
       exitC = exitC, exitE = exitE)
}

.followUpSurvivalDifference <- function(u, T, model) {
  enrollment_time <- pmax(0, pmin(model$R, T - u - model$startR))
  enrolled <- colSums(model$gamma * enrollment_time)
  duration <- pmax(0, pmin(model$S, u - model$startS))
  weights <- c(enrolled, enrolled * model$ratio)
  hazards <- c(colSums(model$exitC * duration), colSums(model$exitE * duration))
  # Subtract 1/2 before adding small survival tails. This preserves a positive
  # tail when exactly half the population has zero censoring hazard.
  baseline <- sum(weights[hazards == 0]) - .5
  # Finite hazards leave a strictly positive tail at every finite time, even
  # when exp(-hazard) underflows. Only the sign is needed for bisection.
  if (baseline == 0 && any(weights[hazards > 0] > 0)) return(1)
  baseline + sum(weights[hazards > 0] * exp(-hazards[hazards > 0]))
}

.followUpMedian <- function(T, model, tol) {
  if (.followUpSurvivalDifference(0, T, model) <= 0) return(0)
  .followUpBisect(function(u) .followUpSurvivalDifference(u, T, model) <= 0, T, tol)
}

# First point satisfying a monotone predicate, including flat regions.
.followUpBisect <- function(predicate, upper, tol) {
  lower <- 0
  while (upper - lower > tol) {
    mid <- lower + (upper - lower) / 2
    if (mid == lower || mid == upper) stop("tol is smaller than the available numerical precision")
    if (predicate(mid)) upper <- mid else lower <- mid
  }
  upper
}

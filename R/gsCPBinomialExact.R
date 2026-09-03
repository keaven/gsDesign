#' Exact conditional power for a group sequential binomial design
#'
#' Computes exact conditional probabilities of crossing future boundaries,
#' given the cumulative experimental-arm event count at an interim analysis.
#'
#' @param x An exact binomial spending design returned by
#'   [toBinomialExact()].
#' @param i Interim analysis at which conditioning occurs; must be less than
#'   `x$k`.
#' @param x.i Cumulative experimental-arm events observed at analysis `i`.
#' @param theta Conditional probabilities that a future event occurs in the
#'   experimental arm. If `NULL`, the observed probability and the values in
#'   `x$theta` are used.
#' @param ve Vaccine or prevention efficacy assumptions. These are converted
#'   to conditional event probabilities using `ratio`. Specify at most one of
#'   `theta` and `ve`.
#' @param ratio Experimental-to-control randomization ratio. This defaults to
#'   the ratio retained by [toBinomialExact()]. It is required when `ve` is
#'   supplied and is also used to report efficacy corresponding to `theta`.
#' @param binding Logical indicating whether future futility or harm boundaries
#'   stop the trial. With `FALSE`, conditional efficacy power ignores these
#'   future non-binding boundaries. This argument does not restrict the
#'   observed result at analysis `i`.
#'
#' @return An object of class `gsBinomialExactCP`. Components include future
#'   absolute event counts, assumed conditional event probabilities and
#'   efficacies, per-analysis efficacy and futility crossing probabilities,
#'   continuation probabilities, and total conditional power and futility.
#'
#' @details
#' Conditional on the interim count, future experimental-arm event increments
#' are independent binomial random variables. Their distribution is propagated
#' through the remaining integer boundaries. Thus the calculation is exact
#' under the same conditional-binomial assumptions used by
#' [gsBinomialExact()].
#'
#' The calculation conditions only on the statistic at analysis `i`, as
#' [gsCP()] does. It is computed regardless of whether the observed count has
#' crossed a current efficacy, futility, or harm boundary. This gives a
#' hypothetical projection if follow-up were to continue; it does not reverse
#' a stopping decision. The `binding` argument controls only whether futility
#' or harm boundaries at future analyses are enforced. Thus, the default
#' `binding = TRUE` includes future non-efficacy stopping, whereas
#' `binding = FALSE` ignores it.
#'
#' @seealso [gsCP()], [toBinomialExact()], [VEtable()]
#'
#' @export
#'
#' @examples
#' design <- gsSurv(
#'   k = 2, test.type = 4, timing = .5, ratio = 3,
#'   hr = .3, hr0 = .7
#' )
#' exact_design <- toBinomialExact(design)
#' gsCPBinomialExact(exact_design, i = 1, x.i = 20, ve = c(.5, .7))
gsCPBinomialExact <- function(
    x,
    i = 1,
    x.i,
    theta = NULL,
    ve = NULL,
    ratio = x$ratio,
    binding = TRUE) {
  if (!inherits(x, "gsBinomialExactSpending")) {
    stop("x must be an exact binomial spending design from toBinomialExact()", call. = FALSE)
  }
  if (!is.numeric(i) || length(i) != 1 || !is.finite(i) ||
      i != floor(i) || i < 1 || i >= x$k) {
    stop("i must be an integer from 1 to x$k - 1", call. = FALSE)
  }
  if (!is.numeric(x.i) || length(x.i) != 1 || !is.finite(x.i) ||
      x.i != floor(x.i) || x.i < 0 || x.i > x$n.I[i]) {
    stop("x.i must be an integer from 0 to x$n.I[i]", call. = FALSE)
  }
  if (!is.logical(binding) || length(binding) != 1 || is.na(binding)) {
    stop("binding must be TRUE or FALSE", call. = FALSE)
  }
  if (!is.null(theta) && !is.null(ve)) {
    stop("specify at most one of theta and ve", call. = FALSE)
  }
  if (!is.null(ratio) && (!is.numeric(ratio) || length(ratio) != 1 ||
      !is.finite(ratio) || ratio <= 0)) {
    stop("ratio must be a finite positive scalar", call. = FALSE)
  }
  if (!is.null(ve)) {
    if (is.null(ratio)) stop("ratio is required when ve is supplied", call. = FALSE)
    if (!is.numeric(ve) || length(ve) < 1 || any(!is.finite(ve)) || any(ve >= 1)) {
      stop("ve must contain finite values less than 1", call. = FALSE)
    }
    theta <- ratio * (1 - ve) / (1 + ratio * (1 - ve))
  } else if (is.null(theta)) {
    theta <- unique(c(x.i / x$n.I[i], x$theta))
  }
  if (!is.numeric(theta) || length(theta) < 1 || any(!is.finite(theta)) ||
      any(theta < 0) || any(theta > 1)) {
    stop("theta must contain values between 0 and 1", call. = FALSE)
  }

  efficacy_bound <- x$lower$bound
  upper_bound <- x$upper$bound
  test_efficacy <- if (is.null(x$testUpper)) {
    rep(TRUE, x$k)
  } else {
    rep(x$testUpper, length.out = x$k)
  }
  if (!isTRUE(binding)) {
    upper_bound[] <- x$n.I + 1L
  } else if (!is.null(x$testLower) || !is.null(x$testHarm)) {
    test_futility <- if (is.null(x$testLower)) {
      rep(FALSE, x$k)
    } else {
      rep(x$testLower, length.out = x$k)
    }
    test_harm <- if (is.null(x$testHarm)) {
      rep(FALSE, x$k)
    } else {
      rep(x$testHarm, length.out = x$k)
    }
    upper_bound[!(test_futility | test_harm)] <- x$n.I[!(test_futility | test_harm)] + 1L
  }
  efficacy_bound[!test_efficacy] <- -1L

  future <- (i + 1L):x$k
  probability <- lapply(theta, function(p) {
    exactBinomialConditionalPath(
      p = p,
      n.current = x$n.I[i],
      x.current = x.i,
      n.future = x$n.I[future],
      efficacy.bound = efficacy_bound[future],
      upper.bound = upper_bound[future]
    )
  })
  efficacy_probability <- do.call(cbind, lapply(probability, `[[`, "efficacy"))
  futility_probability <- do.call(cbind, lapply(probability, `[[`, "futility"))
  continuation_probability <- do.call(cbind, lapply(probability, `[[`, "continuation"))
  labels <- format(theta, digits = 7)
  rownames(efficacy_probability) <- rownames(futility_probability) <-
    rownames(continuation_probability) <- paste("Analysis", future)
  colnames(efficacy_probability) <- colnames(futility_probability) <-
    colnames(continuation_probability) <- labels

  efficacy <- if (is.null(ratio)) rep(NA_real_, length(theta)) else {
    efficacyFromEventProbability(theta, ratio)
  }
  out <- list(
    k = length(future),
    analysis = future,
    n.I = x$n.I[future],
    i = as.integer(i),
    n.I.i = x$n.I[i],
    x.i = as.integer(x.i),
    theta = theta,
    efficacy = efficacy,
    binding = binding,
    lower = list(bound = efficacy_bound[future], prob = efficacy_probability),
    upper = list(bound = upper_bound[future], prob = futility_probability),
    continuation = continuation_probability,
    conditional_power = unname(colSums(efficacy_probability)),
    conditional_futility = unname(colSums(futility_probability))
  )
  class(out) <- "gsBinomialExactCP"
  out
}

exactBinomialConditionalPath <- function(
    p, n.current, x.current, n.future, efficacy.bound, upper.bound) {
  max_n <- max(n.future)
  continuing <- numeric(max_n + 1L)
  continuing[x.current + 1L] <- 1
  efficacy <- futility <- continuation <- numeric(length(n.future))
  previous_n <- n.current

  for (j in seq_along(n.future)) {
    increment <- n.future[j] - previous_n
    next_distribution <- numeric(max_n + 1L)
    previous_counts <- which(continuing > 0) - 1L
    increment_probability <- stats::dbinom(0:increment, increment, p)
    for (count in previous_counts) {
      totals <- count + 0:increment
      next_distribution[totals + 1L] <- next_distribution[totals + 1L] +
        continuing[count + 1L] * increment_probability
    }
    counts <- 0:n.future[j]
    efficacy[j] <- sum(next_distribution[counts <= efficacy.bound[j]])
    futility[j] <- sum(next_distribution[counts >= upper.bound[j]])
    keep <- counts > efficacy.bound[j] & counts < upper.bound[j]
    continuing[] <- 0
    continuing[counts[keep] + 1L] <- next_distribution[counts[keep] + 1L]
    continuation[j] <- sum(continuing)
    previous_n <- n.future[j]
  }
  list(efficacy = efficacy, futility = futility, continuation = continuation)
}

#' Exact confidence intervals for vaccine or prevention efficacy
#'
#' Computes a fixed-look Clopper--Pearson confidence interval for vaccine or
#' prevention efficacy after conditioning on the total number of events.
#'
#' @param x Number of events in the experimental group.
#' @param n Total number of events.
#' @param ratio Experimental-to-control randomization ratio.
#' @param conf.level Confidence level.
#' @param alternative Character string specifying a two-sided interval, a
#'   lower confidence bound, or an upper confidence bound for efficacy.
#'
#' @return A one-row data frame containing the observed counts, randomization
#'   ratio, efficacy estimate, confidence limits, and confidence level.
#'
#' @details
#' Conditional on `n`, `x` is binomial with event probability `p` in the
#' experimental group. Clopper--Pearson limits for `p` are transformed using
#' `efficacy = 1 - p / (ratio * (1 - p))`. Because this transformation is
#' decreasing, the probability limits are reversed on the efficacy scale.
#' The same calculation applies to vaccine efficacy (VE) and prevention
#' efficacy (PE).
#'
#' @seealso [repeatedCIBinomialExact()], [sequentialCIBinomialExact()]
#'
#' @export
#'
#' @examples
#' ciBinomialExact(x = 16, n = 78, ratio = 3)
ciBinomialExact <- function(
    x,
    n,
    ratio = 1,
    conf.level = 0.95,
    alternative = c("two.sided", "lower", "upper")) {
  alternative <- match.arg(alternative)
  validateExactCIInputs(x = x, n = n, ratio = ratio, conf.level = conf.level)

  alpha <- 1 - conf.level
  p_hat <- x / n
  if (alternative == "two.sided") {
    p_lower <- if (x == 0) 0 else stats::qbeta(alpha / 2, x, n - x + 1)
    p_upper <- if (x == n) 1 else stats::qbeta(1 - alpha / 2, x + 1, n - x)
  } else if (alternative == "lower") {
    p_lower <- 0
    p_upper <- if (x == n) 1 else stats::qbeta(conf.level, x + 1, n - x)
  } else {
    p_lower <- if (x == 0) 0 else stats::qbeta(1 - conf.level, x, n - x + 1)
    p_upper <- 1
  }

  data.frame(
    x = as.integer(x),
    n = as.integer(n),
    ratio = ratio,
    estimate = efficacyFromEventProbability(p_hat, ratio),
    conf.low = efficacyFromEventProbability(p_upper, ratio),
    conf.high = efficacyFromEventProbability(p_lower, ratio),
    conf.level = conf.level,
    method = "Clopper-Pearson",
    stringsAsFactors = FALSE
  )
}

#' Exact repeated confidence intervals for vaccine or prevention efficacy
#'
#' Inverts exact binomial efficacy tests at each completed analysis to obtain
#' repeated confidence intervals for vaccine or prevention efficacy.
#'
#' @param gsD A `gsSurv` object with non-binding `test.type` 1, 4, 6, or 8.
#' @param n.I Increasing integer total event counts at completed analyses. If
#'   `NULL`, planned integer event counts from `toInteger(gsD)` are used.
#' @param x Integer experimental-arm event counts at the analyses in `n.I`.
#' @param conf.level Two-sided confidence level.
#' @param tol Absolute tolerance for bisection on the conditional binomial
#'   event-probability scale.
#' @param maxiter Maximum bisection iterations for each confidence limit.
#'
#' @return A data frame with one row per completed analysis containing the
#'   observed counts, efficacy estimate, repeated confidence limits, confidence
#'   level, and one-sided tail level.
#'
#' @details
#' A two-sided interval with confidence level `1 - alpha` uses the same
#' spending function, spending times, and count-path ordering in both
#' directions, with `alpha / 2` in each tail. The lower efficacy limit inverts
#' the usual lower event-count efficacy test. The upper efficacy limit inverts
#' its mirror image after exchanging experimental- and control-arm event
#' counts. This mirrored test is not the design's futility boundary.
#'
#' Non-binding futility and harm are ignored in both directions. Coverage is
#' generally conservative because the exact rejection regions are discrete.
#' Spending time remains relative to the planned final event count.
#'
#' This follows the repeated-confidence-interval construction of Jennison and
#' Turnbull (1984), using exact Bernoulli ordering as in Coe and Tamhane (1993).
#'
#' @references
#' Jennison, C. and Turnbull, B. W. (1984). Repeated confidence intervals for
#' group sequential clinical trials. *Controlled Clinical Trials*, 5, 33--45.
#'
#' Coe, P. R. and Tamhane, A. C. (1993). Small sample confidence intervals for
#' the difference, ratio and odds ratio of two success probabilities.
#' *Controlled Clinical Trials*, 14, 270--290.
#'
#' @seealso [ciBinomialExact()], [sequentialCIBinomialExact()],
#'   [repeatedPValueBinomialExact()]
#'
#' @export
#'
#' @examples
#' design <- gsSurv(
#'   k = 3, test.type = 4, timing = c(.45, .7), ratio = 3,
#'   hr = .3, hr0 = .7
#' )
#' counts <- toBinomialExact(design)$n.I
#' \donttest{
#' repeatedCIBinomialExact(design, counts, x = c(12, 23, 38))
#' }
repeatedCIBinomialExact <- function(
    gsD,
    n.I = NULL,
    x = NULL,
    conf.level = 0.95,
    tol = 1e-8,
    maxiter = 100) {
  observed <- validateExactSequentialCIInputs(
    gsD = gsD,
    n.I = n.I,
    x = x,
    conf.level = conf.level,
    tol = tol,
    maxiter = maxiter
  )
  n.I <- observed$n.I
  x <- observed$x
  ratio <- gsD$ratio
  tail_alpha <- (1 - conf.level) / 2

  cache <- new.env(parent = emptyenv())
  rejection <- function(p, direction) {
    key <- paste(direction, format(p, digits = 17), sep = ":")
    if (exists(key, envir = cache, inherits = FALSE)) {
      return(get(key, envir = cache, inherits = FALSE))
    }
    candidate <- gsD
    if (direction == "lower") {
      candidate$hr0 <- p / (ratio * (1 - p))
      candidate$ratio <- ratio
      events <- x
    } else {
      candidate$hr0 <- (1 - p) / p
      candidate$ratio <- 1
      events <- n.I - x
    }
    bound <- binomialExactLowerBound(
      gsD = candidate,
      n.I = n.I,
      alpha = tail_alpha
    )
    value <- events <= bound
    assign(key, value, envir = cache)
    value
  }

  p_lower <- vapply(seq_along(x), function(j) {
    exactCIAcceptanceEndpoint(
      accept = function(p) !rejection(p, "upper")[j],
      increasing = TRUE,
      tol = tol,
      maxiter = maxiter
    )
  }, numeric(1))
  p_upper <- vapply(seq_along(x), function(j) {
    exactCIAcceptanceEndpoint(
      accept = function(p) !rejection(p, "lower")[j],
      increasing = FALSE,
      tol = tol,
      maxiter = maxiter
    )
  }, numeric(1))

  data.frame(
    Analysis = seq_along(x),
    n.I = n.I,
    x = x,
    estimate = efficacyFromEventProbability(x / n.I, ratio),
    conf.low = efficacyFromEventProbability(p_upper, ratio),
    conf.high = efficacyFromEventProbability(p_lower, ratio),
    conf.level = conf.level,
    tail_alpha = tail_alpha,
    stringsAsFactors = FALSE
  )
}

#' Exact sequential confidence intervals for vaccine or prevention efficacy
#'
#' Forms a sequential confidence interval after each completed analysis by
#' intersecting the exact repeated confidence intervals through that analysis.
#'
#' @inheritParams repeatedCIBinomialExact
#'
#' @return A data frame with one row per completed analysis containing the
#'   observed counts, efficacy estimate, sequential confidence limits,
#'   confidence level, and one-sided tail level.
#'
#' @details
#' The interval is the inversion of [sequentialPValueBinomialExact()] applied
#' in both directions: a candidate efficacy remains in the confidence set only
#' when neither one-sided repeated test has rejected it at any completed
#' analysis. Thus the sequential interval through analysis `j` is the
#' intersection of repeated intervals 1 through `j`.
#'
#' @seealso [ciBinomialExact()], [repeatedCIBinomialExact()],
#'   [sequentialPValueBinomialExact()]
#'
#' @export
#'
#' @examples
#' design <- gsSurv(
#'   k = 3, test.type = 4, timing = c(.45, .7), ratio = 3,
#'   hr = .3, hr0 = .7
#' )
#' counts <- toBinomialExact(design)$n.I
#' \donttest{
#' sequentialCIBinomialExact(design, counts, x = c(12, 23, 38))
#' }
sequentialCIBinomialExact <- function(
    gsD,
    n.I = NULL,
    x = NULL,
    conf.level = 0.95,
    tol = 1e-8,
    maxiter = 100) {
  out <- repeatedCIBinomialExact(
    gsD = gsD,
    n.I = n.I,
    x = x,
    conf.level = conf.level,
    tol = tol,
    maxiter = maxiter
  )
  out$conf.low <- cummax(out$conf.low)
  out$conf.high <- cummin(out$conf.high)
  out
}

efficacyFromEventProbability <- function(p, ratio) {
  out <- 1 - p / (ratio * (1 - p))
  out[p == 1] <- -Inf
  out
}

validateExactCIInputs <- function(x, n, ratio, conf.level) {
  if (!is.numeric(x) || length(x) != 1 || !is.finite(x) || x != floor(x) || x < 0) {
    stop("x must be a non-negative integer", call. = FALSE)
  }
  if (!is.numeric(n) || length(n) != 1 || !is.finite(n) || n != floor(n) || n < 1) {
    stop("n must be a positive integer", call. = FALSE)
  }
  if (x > n) stop("x cannot exceed n", call. = FALSE)
  if (!is.numeric(ratio) || length(ratio) != 1 || !is.finite(ratio) || ratio <= 0) {
    stop("ratio must be a finite positive scalar", call. = FALSE)
  }
  if (!is.numeric(conf.level) || length(conf.level) != 1 ||
      !is.finite(conf.level) || conf.level <= 0 || conf.level >= 1) {
    stop("conf.level must be a scalar strictly between 0 and 1", call. = FALSE)
  }
}

validateExactSequentialCIInputs <- function(gsD, n.I, x, conf.level, tol, maxiter) {
  if (!inherits(gsD, "gsSurv")) {
    stop("gsD must be an object of class gsSurv", call. = FALSE)
  }
  if (!(gsD$test.type %in% c(1, 4, 6, 8))) {
    stop("gsD$test.type must be 1, 4, 6, or 8", call. = FALSE)
  }
  if (is.null(x) || !is.numeric(x) || length(x) < 1 ||
      any(!is.finite(x)) || any(x != floor(x)) || any(x < 0)) {
    stop("x must contain non-negative integer experimental-arm event counts", call. = FALSE)
  }
  if (is.null(n.I)) n.I <- toInteger(gsD)$n.I
  if (!is.numeric(n.I) || length(n.I) != length(x) || any(!is.finite(n.I)) ||
      any(n.I != floor(n.I)) || any(n.I <= 0) || any(diff(n.I) <= 0)) {
    stop("n.I must contain increasing positive integers with the same length as x", call. = FALSE)
  }
  if (any(x > n.I)) stop("x cannot exceed n.I", call. = FALSE)
  planned_final <- if (!is.null(gsD$maxn.IPlan) && gsD$maxn.IPlan > 0) {
    gsD$maxn.IPlan
  } else {
    max(toInteger(gsD)$n.I)
  }
  if (sum(n.I >= planned_final) > 1) {
    stop("n.I must have at most 1 value >= planned final events", call. = FALSE)
  }
  validateExactCIInputs(x = x[1], n = n.I[1], ratio = gsD$ratio, conf.level = conf.level)
  if (!is.numeric(tol) || length(tol) != 1 || !is.finite(tol) || tol <= 0) {
    stop("tol must be a positive scalar", call. = FALSE)
  }
  if (!is.numeric(maxiter) || length(maxiter) != 1 || !is.finite(maxiter) ||
      maxiter < 1 || maxiter != floor(maxiter)) {
    stop("maxiter must be a positive integer", call. = FALSE)
  }
  list(n.I = as.integer(n.I), x = as.integer(x))
}

exactCIAcceptanceEndpoint <- function(accept, increasing, tol, maxiter) {
  eps <- sqrt(.Machine$double.eps)
  lo <- eps
  hi <- 1 - eps
  accept_lo <- accept(lo)
  accept_hi <- accept(hi)

  if (increasing) {
    if (accept_lo) return(0)
    if (!accept_hi) return(1)
    for (iter in seq_len(maxiter)) {
      mid <- (lo + hi) / 2
      if (accept(mid)) hi <- mid else lo <- mid
      if (hi - lo <= tol) break
    }
    return(hi)
  }

  if (!accept_lo) return(0)
  if (accept_hi) return(1)
  for (iter in seq_len(maxiter)) {
    mid <- (lo + hi) / 2
    if (accept(mid)) lo <- mid else hi <- mid
    if (hi - lo <= tol) break
  }
  lo
}

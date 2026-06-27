#' Exact binomial repeated p-values for a group sequential design
#'
#' Computes repeated p-values for the exact binomial design implied by a
#' [gsSurv()] object. The p-value at analysis `j` is the smallest local
#' one-sided alpha level for which the observed experimental-arm event count
#' crosses the exact lower efficacy bound at that analysis. Non-binding
#' futility bounds are ignored for the Type I error calculation.
#'
#' @param gsD A `gsSurv` object with `test.type` 1 or 4.
#' @param n.I Increasing integer total event counts at completed analyses. If
#'   `NULL`, the planned exact binomial event counts from `toBinomialExact(gsD)`
#'   are used. This must have at most 1 value greater than or equal to planned
#'   final events (`gsD$maxn.IPlan` if available, otherwise `max(gsD$n.I)`).
#' @param x Integer experimental-arm event counts at the analyses in `n.I`.
#' @param interval Search interval for the p-values. As in [sequentialPValue()],
#'   values outside this interval are truncated to the nearest endpoint.
#' @param tol Relative tolerance for the monotone bisection search on the
#'   alpha scale.
#' @param maxiter Maximum number of bisection iterations for each analysis.
#' @param check Logical. If `TRUE`, checks the monotonicity of the alpha-indexed
#'   integer efficacy bounds on a coarse grid and warns if it is violated.
#'
#' @return A data frame with one row per completed analysis containing:
#' \describe{
#'   \item{`Analysis`}{Analysis index.}
#'   \item{`n.I`}{Total events at analysis.}
#'   \item{`x`}{Observed experimental-arm events.}
#'   \item{`repeated_p_value`}{Repeated p-value for the analysis.}
#'   \item{`bound_at_repeated_p_value`}{Integer efficacy bound at the repeated p-value.}
#' }
#'
#' @seealso [sequentialPValueBinomialExact()], [sequentialPValue()],
#'   [toBinomialExact()], [gsBinomialExact()]
#'
#' @examples
#' x <- gsSurv(
#'   k = 3, test.type = 4, alpha = 0.025, beta = 0.1, timing = c(0.45, 0.7),
#'   sfu = sfHSD, sfupar = -4, sfl = sfLDOF, sflpar = 0,
#'   lambdaC = 0.001, hr = 0.3, hr0 = 0.7, eta = 5e-04,
#'   gamma = 10, R = 16, T = 24, minfup = 8, ratio = 3
#' )
#' counts <- toBinomialExact(x)$n.I
#' \donttest{
#' repeatedPValueBinomialExact(gsD = x, n.I = counts, x = c(12, 23, 38))
#' }
#' @export
repeatedPValueBinomialExact <- function(
    gsD,
    n.I = NULL,
    x = NULL,
    interval = c(1e-20, 0.9999),
    tol = 1e-8,
    maxiter = 100,
    check = FALSE) {
  if (!inherits(gsD, "gsSurv")) {
    stop("gsD must be an object of class gsSurv", call. = FALSE)
  }
  if (!(gsD$test.type %in% c(1, 4))) {
    stop("gsD$test.type must be 1 or 4", call. = FALSE)
  }
  if (is.null(x)) {
    stop("x must contain observed experimental-arm event counts", call. = FALSE)
  }
  if (!is.numeric(x) || any(!is.finite(x)) || any(x != floor(x))) {
    stop("x must be a numeric vector of non-negative integers", call. = FALSE)
  }
  x <- as.integer(x)
  if (any(x < 0)) {
    stop("x must be non-negative", call. = FALSE)
  }
  if (length(x) == 0) {
    stop("x must contain at least 1 analysis", call. = FALSE)
  }

  if (is.null(n.I)) {
    n.I <- toBinomialExact(gsD)$n.I
  }
  if (!is.numeric(n.I) || any(!is.finite(n.I)) || any(n.I != floor(n.I))) {
    stop("n.I must be a numeric vector of increasing positive integers", call. = FALSE)
  }
  n.I <- as.integer(n.I)
  if (length(n.I) != length(x)) {
    stop("n.I and x must have the same length", call. = FALSE)
  }
  if (length(n.I) == 0 || any(n.I <= 0) || any(diff(n.I) <= 0)) {
    stop("n.I must be an increasing vector of positive integers", call. = FALSE)
  }
  if (any(x > n.I)) {
    stop("x cannot exceed n.I", call. = FALSE)
  }
  planned_final <- if (!is.null(gsD$maxn.IPlan)) gsD$maxn.IPlan else max(gsD$n.I)
  if (!is.numeric(planned_final) || length(planned_final) != 1 ||
      !is.finite(planned_final) || planned_final <= 0) {
    planned_final <- max(gsD$n.I)
  }
  if (sum(n.I >= planned_final) > 1) {
    stop("n.I must have at most 1 value >= planned final events", call. = FALSE)
  }
  if (!is.numeric(interval) || length(interval) != 2 ||
      any(!is.finite(interval)) || min(interval) <= 0 || max(interval) >= 1 ||
      diff(sort(interval)) <= 0) {
    stop("interval must contain 2 distinct values strictly between 0 and 1", call. = FALSE)
  }
  interval <- sort(interval)
  if (!is.numeric(tol) || length(tol) != 1 || !is.finite(tol) || tol <= 0) {
    stop("tol must be a positive scalar", call. = FALSE)
  }
  if (!is.numeric(maxiter) || length(maxiter) != 1 || !is.finite(maxiter) ||
      maxiter < 1 || maxiter != floor(maxiter)) {
    stop("maxiter must be a positive integer", call. = FALSE)
  }
  maxiter <- as.integer(maxiter)

  cache <- new.env(parent = emptyenv())
  lower_bound <- function(alpha) {
    key <- format(alpha, digits = 17)
    if (exists(key, envir = cache, inherits = FALSE)) {
      return(get(key, envir = cache, inherits = FALSE))
    }
    b <- binomialExactLowerBound(gsD = gsD, n.I = n.I, alpha = alpha)
    assign(key, b, envir = cache)
    b
  }

  if (isTRUE(check)) {
    grid <- sort(unique(c(interval, seq(interval[1], interval[2], length.out = 25))))
    bmat <- t(vapply(grid, lower_bound, numeric(length(n.I))))
    nonmonotone <- apply(bmat, 2, function(z) any(diff(z) < 0))
    if (any(nonmonotone)) {
      warning(
        "Exact binomial efficacy bounds were not monotone in alpha on the check grid ",
        "for analysis/analyses: ",
        paste(which(nonmonotone), collapse = ", "),
        call. = FALSE
      )
    }
  }

  crosses <- function(alpha) {
    x <= lower_bound(alpha)
  }

  lo <- interval[1]
  hi <- interval[2]
  crosses_lo <- crosses(lo)
  crosses_hi <- crosses(hi)

  pval <- numeric(length(x))
  for (j in seq_along(x)) {
    if (crosses_lo[j]) {
      pval[j] <- lo
      next
    }
    if (!crosses_hi[j]) {
      pval[j] <- hi
      next
    }
    left <- log(lo)
    right <- log(hi)
    for (iter in seq_len(maxiter)) {
      mid <- exp((left + right) / 2)
      if (crosses(mid)[j]) {
        right <- log(mid)
      } else {
        left <- log(mid)
      }
      if ((right - left) <= log1p(tol)) {
        break
      }
    }
    pval[j] <- exp(right)
  }

  data.frame(
    Analysis = seq_along(x),
    n.I = n.I,
    x = x,
    repeated_p_value = pval,
    bound_at_repeated_p_value = vapply(pval, lower_bound, numeric(length(n.I)))[
      cbind(seq_along(x), seq_along(x))
    ],
    stringsAsFactors = FALSE
  )
}

#' Exact lower efficacy bounds for a binomial group sequential design
#'
#' Computes the alpha-indexed exact lower-tail event-count efficacy bounds used
#' by [repeatedPValueBinomialExact()]. This helper intentionally ignores
#' non-binding futility bounds and avoids the normal-theory design checks in
#' [gsDesign()], since very small alpha values may be needed while searching
#' for exact p-values.
#'
#' @param gsD A `gsSurv` object with `test.type` 1 or 4.
#' @param n.I Increasing integer total event counts at analyses with at most
#'   1 value greater than or equal to planned final events.
#' @param alpha Local one-sided Type I error level.
#' @param fullSpendFinal Logical scalar. If `TRUE`, force spending time to 1 at
#'   the final analysis (while keeping earlier timings based on
#'   `n.I / maxn.IPlan`).
#' @param spendingTime Optional upper spending-time vector (length equal to
#'   `length(n.I)`) used directly for alpha spending. If `NULL`, spending time
#'   is derived from `n.I / maxn.IPlan`.
#'
#' @return Integer lower efficacy bounds.
#' @keywords internal
#' @noRd
binomialExactLowerBound <- function(
    gsD,
    n.I,
    alpha,
    fullSpendFinal = FALSE,
    spendingTime = NULL) {
  if (!inherits(gsD, "gsSurv")) {
    stop("gsD must be an object of class gsSurv", call. = FALSE)
  }
  if (!(gsD$test.type %in% c(1, 4))) {
    stop("gsD$test.type must be 1 or 4", call. = FALSE)
  }
  if (!is.numeric(alpha) || length(alpha) != 1 || !is.finite(alpha) ||
      alpha <= 0 || alpha >= 1) {
    stop("alpha must be a scalar strictly between 0 and 1", call. = FALSE)
  }
  if (!is.logical(fullSpendFinal) || length(fullSpendFinal) != 1 || is.na(fullSpendFinal)) {
    stop("fullSpendFinal must be TRUE or FALSE", call. = FALSE)
  }
  if (!is.null(spendingTime) &&
      (!is.numeric(spendingTime) || any(!is.finite(spendingTime)))) {
    stop("spendingTime must be a numeric vector", call. = FALSE)
  }
  if (!is.numeric(n.I) || any(!is.finite(n.I)) || any(n.I != floor(n.I))) {
    stop("n.I must be a numeric vector of increasing positive integers", call. = FALSE)
  }
  n.I <- as.integer(n.I)
  if (length(n.I) == 0 || any(n.I <= 0) || any(diff(n.I) <= 0)) {
    stop("n.I must be an increasing vector of positive integers", call. = FALSE)
  }
  k <- length(n.I)
  p0 <- gsD$hr0 * gsD$ratio / (1 + gsD$hr0 * gsD$ratio)
  maxn.IPlan <- if (!is.null(gsD$maxn.IPlan)) gsD$maxn.IPlan else max(gsD$n.I)
  if (!is.numeric(maxn.IPlan) || length(maxn.IPlan) != 1 ||
      !is.finite(maxn.IPlan) || maxn.IPlan <= 0) {
    maxn.IPlan <- max(gsD$n.I)
  }
  if (sum(n.I >= maxn.IPlan) > 1) {
    stop("n.I must have at most 1 value >= planned final events", call. = FALSE)
  }
  if (is.null(spendingTime)) {
    timing <- pmin(n.I / maxn.IPlan, 1)
  } else {
    if (length(spendingTime) != k) {
      stop("spendingTime must have the same length as n.I", call. = FALSE)
    }
    timing <- as.numeric(spendingTime)
    if (any(timing <= 0) || any(diff(timing) <= 0)) {
      stop("spendingTime must be strictly increasing and positive", call. = FALSE)
    }
  }
  if (isTRUE(fullSpendFinal)) {
    timing[k] <- 1
  }
  if (sum(timing >= 1) > 1) {
    stop("spendingTime must have at most 1 value >= 1", call. = FALSE)
  }
  alpha_spend <- gsD$upper$sf(alpha = alpha, t = timing, param = gsD$upper$param)$spend
  alpha_spend <- pmin(pmax(alpha_spend, 0), alpha)

  a <- rep(-1L, k)
  lower_prob <- function(j, aj) {
    atmp <- a[seq_len(j)]
    atmp[j] <- aj
    if (j == 1) {
      return(stats::pbinom(q = atmp[1], size = n.I[1], prob = p0))
    }
    sum(gsBinomialExact(
      k = j,
      theta = p0,
      n.I = n.I[seq_len(j)],
      a = atmp,
      b = n.I[seq_len(j)] + 1
    )$lower$prob[, 1])
  }

  for (j in seq_len(k)) {
    amin <- if (j == 1) -1L else a[j - 1]
    amax <- n.I[j] - 1L
    if (amin > amax) {
      a[j] <- amax
      next
    }
    candidates <- seq.int(amin, amax)
    probs <- vapply(candidates, function(aj) lower_prob(j, aj), numeric(1))
    valid <- candidates[probs <= alpha_spend[j] * (1 + 1e-10) + .Machine$double.xmin]
    a[j] <- if (length(valid) > 0) max(valid) else amin
  }
  a
}

#' Exact binomial sequential p-value for a group sequential design
#'
#' Computes the sequential p-value as the minimum repeated p-value over
#' completed analyses, using [repeatedPValueBinomialExact()].
#'
#' @inheritParams repeatedPValueBinomialExact
#'
#' @return A single numeric one-sided sequential p-value.
#' @seealso [repeatedPValueBinomialExact()], [sequentialPValue()]
#'
#' @examples
#' x <- gsSurv(
#'   k = 3, test.type = 4, alpha = 0.025, beta = 0.1, timing = c(0.45, 0.7),
#'   sfu = sfHSD, sfupar = -4, sfl = sfLDOF, sflpar = 0,
#'   lambdaC = 0.001, hr = 0.3, hr0 = 0.7, eta = 5e-04,
#'   gamma = 10, R = 16, T = 24, minfup = 8, ratio = 3
#' )
#' counts <- toBinomialExact(x)$n.I
#' \donttest{
#' sequentialPValueBinomialExact(gsD = x, n.I = counts, x = c(12, 23, 38))
#' }
#' @export
sequentialPValueBinomialExact <- function(
    gsD,
    n.I = NULL,
    x = NULL,
    interval = c(1e-20, 0.9999),
    tol = 1e-8,
    maxiter = 100,
    check = FALSE) {
  min(
    repeatedPValueBinomialExact(
      gsD = gsD,
      n.I = n.I,
      x = x,
      interval = interval,
      tol = tol,
      maxiter = maxiter,
      check = check
    )$repeated_p_value
  )
}

#' Summarize an exact binomial vaccine or prevention efficacy design
#'
#' Creates a vaccine or prevention efficacy summary table from an exact
#' binomial design. The table includes event-count bounds, efficacy at each bound,
#' cumulative error spending, and cumulative efficacy-crossing probabilities
#' for selected efficacy assumptions. Optional time-to-event design
#' information adds planned analysis times and expected enrollment.
#'
#' @param x An object of class \code{gsBinomialExact}, generally created by
#'   \code{\link{toBinomialExact}}.
#' @param ve Numeric vector of vaccine or prevention efficacy assumptions
#'   strictly between 0 and 1.
#' @param tteDesign Optional \code{gsSurv} object with the same number of
#'   analyses as \code{x}. When supplied, planned analysis time and expected
#'   enrollment are included.
#' @param ratio Experimental-to-control randomization ratio. By default, this
#'   is taken from \code{tteDesign} or from a design created by
#'   \code{toBinomialExact()}.
#'
#' @return A tibble with one row per analysis. The columns contain analysis
#'   number, optional timing and enrollment, total cases, exact efficacy and
#'   futility bounds, efficacy at each bound, cumulative alpha and beta
#'   spending, and cumulative efficacy-crossing probability under each value
#'   in \code{ve}.
#'
#' @details
#' Vaccine efficacy (VE), also termed prevention efficacy (PE) for non-vaccine
#' preventive interventions, is translated to the exact binomial probability
#' that an event is in the experimental group using the specified randomization
#' ratio. The argument is named `ve` because the motivating application is a
#' vaccine trial; the same calculation applies to PE.
#' Cumulative alpha is calculated while ignoring non-binding futility, as is
#' required for exact efficacy Type I error control.
#'
#' @seealso \code{\link{toBinomialExact}},
#'   \code{vignette("VaccineEfficacy")}
#'
#' @export
#'
#' @examples
#' x <- gsSurv(
#'   k = 2, test.type = 4, timing = .6, ratio = 3,
#'   hr = .3, hr0 = .7, lambdaC = .002, eta = .0001,
#'   gamma = 10, R = 8, T = 24, minfup = 16
#' )
#' exact <- toBinomialExact(x)
#' VEtable(exact, ve = c(.5, .7), tteDesign = x)
VEtable <- function(x, ve, tteDesign = NULL, ratio = NULL) {
  if (!inherits(x, "gsBinomialExact")) {
    stop("VEtable: x must have class gsBinomialExact", call. = FALSE)
  }
  if (!is.numeric(ve) || length(ve) < 1 || any(!is.finite(ve)) ||
      any(ve <= 0 | ve >= 1) || anyDuplicated(ve)) {
    stop("VEtable: ve must contain unique finite values strictly between 0 and 1", call. = FALSE)
  }

  if (!is.null(tteDesign)) {
    if (!inherits(tteDesign, "gsSurv")) {
      stop("VEtable: tteDesign must have class gsSurv", call. = FALSE)
    }
    if (tteDesign$k != x$k) {
      stop("VEtable: tteDesign and x must have the same number of analyses", call. = FALSE)
    }
  }

  if (is.null(ratio)) {
    ratio <- if (!is.null(tteDesign)) tteDesign$ratio else x$ratio
  }
  if (!is.numeric(ratio) || length(ratio) != 1 || !is.finite(ratio) || ratio <= 0) {
    stop(
      "VEtable: ratio must be a finite positive scalar or available from x or tteDesign",
      call. = FALSE
    )
  }

  prob_experimental <- ratio / (ratio + 1 / (1 - ve))
  power <- gsBinomialExact(
    k = x$k,
    theta = prob_experimental,
    n.I = x$n.I,
    a = x$lower$bound,
    b = x$upper$bound
  )$lower$prob
  power <- apply(power, 2, cumsum)
  if (length(ve) == 1) power <- matrix(power, ncol = 1)
  colnames(power) <- paste0(ve * 100, "%")

  alpha <- gsBinomialExact(
    k = x$k,
    theta = x$theta[1],
    n.I = x$n.I,
    a = x$lower$bound,
    b = x$n.I + 1
  )$lower$prob

  out <- tibble::tibble(
    Analysis = seq_len(x$k),
    Cases = x$n.I,
    Success = x$lower$bound,
    Futility = x$upper$bound,
    ve_efficacy = 1 - 1 / (ratio * (x$n.I / x$lower$bound - 1)),
    ve_futility = 1 - 1 / (ratio * (x$n.I / x$upper$bound - 1)),
    alpha = as.vector(cumsum(alpha)),
    beta = as.vector(cumsum(x$upper$prob[, 2]))
  )

  if (!is.null(tteDesign)) {
    out <- dplyr::bind_cols(
      out["Analysis"],
      tibble::tibble(
        Time = tteDesign$T,
        N = as.vector(round(tteDesign$eNC + tteDesign$eNE))
      ),
      out[-1]
    )
  }

  dplyr::bind_cols(out, tibble::as_tibble(power, .name_repair = "minimal"))
}

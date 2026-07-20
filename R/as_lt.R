#' Convert a summary table object to an lt table
#'
#' Convert a summary table object created with \code{\link{as_table}}
#' to an \code{lt_tbl} object; currently only implemented for
#' \code{\link{gsBinomialExact}}.
#'
#' @param data Object to be converted.
#' @param ... Other parameters that may be specific to the object.
#' @param title Table title.
#' @param subtitle Table subtitle.
#' @param theta_label Label for theta.
#' @param bound_label Label for bounds.
#' @param prob_decimals Number of decimal places for probability of crossing.
#' @param en_decimals Number of decimal places for expected number of
#'   observations when bound is crossed or when trial ends without crossing.
#' @param rr_decimals Number of decimal places for response rates.
#'
#' @return An \code{lt_tbl} object.
#'
#' @seealso \code{vignette("binomialSPRTExample")}
#'
#' @details
#' Currently only implemented for \code{\link{gsBinomialExact}} objects.
#' Creates a table to summarize an object.
#' For \code{\link{gsBinomialExact}}, this summarized operating characteristics
#' across a range of effect sizes.
#'
#' @name lt-methods
#'
#' @examples
#' safety_design <- binomialSPRT(
#'   p0 = .04, p1 = .1, alpha = .04, beta = .2, minn = 4, maxn = 75
#' )
#' safety_power <- gsBinomialExact(
#'   k = length(safety_design$n.I),
#'   theta = seq(.02, .16, .02),
#'   n.I = safety_design$n.I,
#'   a = safety_design$lower$bound,
#'   b = safety_design$upper$bound
#' )
#' safety_power |>
#'   as_table() |>
#'   lt::lt(
#'     theta_label = I("Underlying<br>AE rate"),
#'     prob_decimals = 3,
#'     bound_label = c("low rate", "high rate")
#'   )
#'
#' @exportS3Method lt::lt
lt.gsBinomialExactTable <- function(
    data,
    ...,
    title = "Operating Characteristics for the Truncated SPRT Design",
    subtitle = "Assumes trial evaluated sequentially after each response",
    theta_label = I("Underlying<br>response rate"),
    bound_label = c("Futility bound", "Efficacy bound"),
    prob_decimals = 2,
    en_decimals = 1,
    rr_decimals = 0) {
  lt::lt(as.data.frame(data), ...) |>
    lt::lt_spanner(label = "Probability of crossing", columns = c("Lower", "Upper")) |>
    lt::lt_label(
      theta = theta_label,
      Lower = bound_label[1],
      Upper = bound_label[2],
      en = I("Average<br>sample size")
    ) |>
    lt::lt_format(columns = c("Lower", "Upper"), decimals = prob_decimals) |>
    lt::lt_format(columns = "en", decimals = en_decimals) |>
    lt::lt_format(columns = "theta", decimals = rr_decimals, percent = TRUE) |>
    lt::lt_header(title = title, subtitle = subtitle)
}

#' Convert a summary table object to a gt object
#'
#' Convert a summary table object created with \code{\link{as_table}}
#' to a \code{gt_tbl} object; currently only implemented for
#' \code{\link{gsBinomialExact}}.
#'
#' @param x Object to be converted.
#' @param ... Other parameters that may be specific to the object.
#'
#' @return A \code{gt_tbl} object that may be extended by overloaded versions of
#'   \code{\link{as_gt}}.
#'
#' @seealso \code{vignette("binomialSPRTExample")}
#'
#' @details
#' Currently only implemented for \code{\link{gsBinomialExact}} objects.
#' Creates a table to summarize an object.
#' For \code{\link{gsBinomialExact}}, this summarized operating characteristics
#' across a range of effect sizes.
#'
#' @export
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
#' safety_power %>%
#'   as_table() %>%
#'   as_gt(
#'     theta_label = gt::html("Underlying<br>AE rate"),
#'     prob_decimals = 3,
#'     bound_label = c("low rate", "high rate")
#'   )
as_gt <- function(x, ...) UseMethod("as_gt")

#' @rdname as_gt
#'
#' @param title Table title.
#' @param subtitle Table subtitle.
#' @param theta_label Label for theta.
#' @param bound_label Label for bounds.
#' @param prob_decimals Number of decimal places for probability of crossing.
#' @param en_decimals Number of decimal places for expected number of
#'   observations when bound is crossed or when trial ends without crossing.
#' @param rr_decimals Number of decimal places for response rates.
#'
#' @importFrom gt gt tab_spanner cols_label html fmt_number fmt_percent tab_header
#'
#' @export
as_gt.gsBinomialExactTable <- function(
    x,
    ...,
    title = "Operating Characteristics for the Truncated SPRT Design",
    subtitle = "Assumes trial evaluated sequentially after each response",
    theta_label = html("Underlying<br>response rate"),
    bound_label = c("Futility bound", "Efficacy bound"),
    prob_decimals = 2,
    en_decimals = 1,
    rr_decimals = 0) {
  out_gt <- x %>%
    gt() %>%
    tab_spanner(label = "Probability of crossing", columns = c(Lower, Upper)) %>%
    cols_label(
      theta = theta_label,
      Lower = bound_label[1],
      Upper = bound_label[2],
      en = html("Average<br>sample size")
    ) %>%
    fmt_number(columns = c(Lower, Upper), decimals = prob_decimals) %>%
    fmt_number(columns = en, decimals = en_decimals) %>%
    fmt_percent(columns = theta, decimals = rr_decimals) %>%
    tab_header(title = title, subtitle = subtitle)

  out_gt
}

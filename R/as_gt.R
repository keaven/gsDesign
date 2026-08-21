#' Convert a summary table object to a gt object
#'
#' \code{as_gt()} is deprecated in favor of \code{\link[lt]{lt}()}, which
#' produces a lightweight HTML table without the heavy \pkg{gt} dependency.
#' \code{as_gt()} is kept for one release so existing code that customizes the
#' output with \pkg{gt} functions keeps working; it still returns a
#' \code{gt_tbl} object and requires \pkg{gt} to be installed. New code should
#' use \code{\link[lt]{lt}()}; see \code{\link{lt-methods}} for the available
#' arguments, which mirror those of \code{as_gt()}.
#'
#' @param x Object to be converted.
#' @param ... Other parameters that may be specific to the object.
#'
#' @return A \code{gt_tbl} object that may be extended by overloaded versions of
#'   \code{as_gt()}.
#'
#' @seealso \code{\link[lt]{lt}()}, \code{\link{lt-methods}}
#'
#' @export
as_gt <- function(x, ...) {
  .Deprecated("lt::lt", package = "gsDesign",
    msg = paste(
      "as_gt() is deprecated and will be removed in a future release;",
      "please use lt::lt() instead."
    ))
  UseMethod("as_gt")
}

# stop with an informative message when gt is not installed, since it is only
# a suggested (optional) dependency now that as_gt() is deprecated
assert_gt_installed <- function() {
  if (!requireNamespace("gt", quietly = TRUE)) stop(
    "The 'gt' package is required by the deprecated as_gt(); ",
    "install it with install.packages('gt'), or use lt::lt() instead.",
    call. = FALSE
  )
}

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
#' @export
as_gt.gsBinomialExactTable <- function(
    x,
    ...,
    title = "Operating Characteristics for the Truncated SPRT Design",
    subtitle = "Assumes trial evaluated sequentially after each response",
    theta_label = gt::html("Underlying<br>response rate"),
    bound_label = c("Futility bound", "Efficacy bound"),
    prob_decimals = 2,
    en_decimals = 1,
    rr_decimals = 0) {
  assert_gt_installed()
  out_gt <- x |>
    gt::gt() |>
    gt::tab_spanner(label = "Probability of crossing", columns = c(Lower, Upper)) |>
    gt::cols_label(
      theta = theta_label,
      Lower = bound_label[1],
      Upper = bound_label[2],
      en = gt::html("Average<br>sample size")
    ) |>
    gt::fmt_number(columns = c(Lower, Upper), decimals = prob_decimals) |>
    gt::fmt_number(columns = en, decimals = en_decimals) |>
    gt::fmt_percent(columns = theta, decimals = rr_decimals) |>
    gt::tab_header(title = title, subtitle = subtitle)

  out_gt
}

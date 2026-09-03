# Re-export the lt() generic so users can call lt() on a summary table object
# after only loading gsDesign (without also attaching lt or qualifying with
# lt::). This also makes S3 dispatch robust regardless of package load order.
# See https://github.com/yihui/lt/issues/4.

#' @importFrom lt lt
#' @export
lt::lt

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
#' if (interactive()) {
#'   safety_power |>
#'     as_table() |>
#'     lt(
#'       theta_label = I("Underlying<br>AE rate"),
#'       prob_decimals = 3,
#'       bound_label = c("low rate", "high rate")
#'     )
#' }
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

#' Format a vaccine or prevention efficacy summary table
#'
#' Applies standard labels, number formats, spanners, and explanatory
#' footnotes to a table returned by \code{\link{VEtable}}.
#'
#' @param data A \code{gsVETable} object returned by \code{\link{VEtable}}.
#' @param ... Additional arguments passed to \code{\link[lt]{lt}}.
#' @param title Table title.
#' @param subtitle Optional table subtitle.
#' @param efficacy_label Whether to label efficacy as vaccine efficacy
#'   (\code{"VE"}) or prevention efficacy (\code{"PE"}).
#' @param time_decimals Number of decimal places for analysis time.
#' @param efficacy_decimals Number of decimal places for efficacy at the
#'   boundaries and power.
#' @param spending_decimals Number of decimal places for alpha and beta
#'   spending.
#'
#' @return An \code{lt_tbl} object.
#'
#' @rdname lt-gsVETable
#' @exportS3Method lt::lt
lt.gsVETable <- function(
    data,
    ...,
    title = "Design Bounds and Operating Characteristics",
    subtitle = NULL,
    efficacy_label = c("VE", "PE"),
    time_decimals = 1,
    efficacy_decimals = 2,
    spending_decimals = 4) {
  efficacy_label <- match.arg(efficacy_label)
  efficacy_name <- if (efficacy_label == "VE") {
    "Vaccine Efficacy"
  } else {
    "Prevention Efficacy"
  }
  power_columns <- intersect(names(data), paste0(attr(data, "ve") * 100, "%"))
  alpha <- attr(data, "alpha")

  out <- lt::lt(as.data.frame(data), ...) |>
    lt::lt_spanner(
      label = "Experimental Cases at Bound",
      columns = c("Success", "Futility")
    ) |>
    lt::lt_spanner(
      label = paste("Power by", efficacy_name),
      columns = power_columns
    ) |>
    lt::lt_spanner(label = "Error Spending", columns = c("alpha", "beta")) |>
    lt::lt_spanner(
      label = paste(efficacy_name, "at Bound"),
      columns = c("ve_efficacy", "ve_futility")
    ) |>
    lt::lt_label(
      ve_efficacy = "Efficacy",
      ve_futility = "Futility"
    ) |>
    lt::lt_format(
      columns = c("ve_efficacy", "ve_futility", power_columns),
      decimals = efficacy_decimals
    ) |>
    lt::lt_format(
      columns = c("alpha", "beta"),
      decimals = spending_decimals
    ) |>
    lt::lt_footnote(
      "Cumulative spending at each analysis",
      where = "spanner", columns = "Error Spending"
    ) |>
    lt::lt_footnote(
      paste0(
        "Experimental case counts; counts between success and futility ",
        "bounds do not stop the trial"
      ),
      where = "spanner", columns = "Experimental Cases at Bound"
    ) |>
    lt::lt_footnote(
      paste("Exact", tolower(efficacy_name), "required to cross bound"),
      where = "spanner", columns = paste(efficacy_name, "at Bound")
    ) |>
    lt::lt_footnote(
      paste("Cumulative power at each analysis by underlying", tolower(efficacy_name)),
      where = "spanner", columns = paste("Power by", efficacy_name)
    ) |>
    lt::lt_footnote(
      paste0(
        "Cumulative alpha-spending for efficacy ignores non-binding futility ",
        "bound; final value < ", alpha, " due to discreteness"
      ),
      where = "column", columns = "alpha"
    ) |>
    lt::lt_header(title = title, subtitle = subtitle)

  if ("Time" %in% names(data)) {
    out <- lt::lt_format(out, columns = "Time", decimals = time_decimals)
  }
  out
}

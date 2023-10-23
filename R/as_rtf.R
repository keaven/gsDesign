#' Save a summary table object as an RTF file
#'
#' Convert and save the summary table object created with \code{\link{as_table}}
#' to an RTF file using r2rtf; currently only implemented for
#' \code{\link{gsBinomialExact}}.
#'
#' @param x Object to be saved as RTF file.
#' @param ... Other parameters that may be specific to the object.
#'
#' @return \code{as_rtf()} returns the input \code{x} invisibly.
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
#' zz <- gsBinomialExact(
#'   k = 3, theta = seq(0, 1, 0.1), n.I = c(12, 24, 36),
#'   a = c(-1, 0, 11), b = c(5, 9, 12)
#' )
#' zz %>%
#'   as_table() %>%
#'   as_rtf(
#'     file = tempfile(fileext = ".rtf"),
#'     title = "Power/Type I Error and Expected Sample Size for a Group Sequential Design"
#'   )
#'
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
#'   as_rtf(
#'     file =  "test1.rtf",
#'     theta_label = "Underlying\nAE Rate",
#'     prob_decimals = 3,
#'     bound_label = c("Low Rate", "High Rate")
#'   )
as_rtf <- function(x, ...) {
  UseMethod("as_rtf", x)
}

#' @rdname as_rtf
#'
#' @param file File path for the output.
#' @param title Table title.
#' @param theta_label Label for theta.
#' @param response_outcome Logical values indicating if the outcome is
#'   response rate (\code{TRUE}) or failure rate (\code{FALSE}).
#'   The default value is \code{TRUE}.
#' @param bound_label Label for bounds.
#'   If the outcome is response rate, then the label is "Futility bound"
#'   and "Efficacy bound".
#'   If the outcome is failure rate, then the label is "Efficacy bound"
#'   and "Futility bound".
#' @param en_label Label for expected number.
#' @param prob_decimals Number of decimal places for probability of crossing.
#' @param en_decimals Number of decimal places for expected number of
#'   observations when bound is crossed or when trial ends without crossing.
#' @param rr_decimals Number of decimal places for response rates.
#'
#' @importFrom r2rtf rtf_title rtf_colheader rtf_body rtf_encode write_rtf
#'
#' @export
as_rtf.gsBinomialExactTable <- function(
    x,
    file,
    ...,
    title = paste(
      "Operating Characteristics by Underlying Response Rate for",
      "Exact Binomial Group Sequential Design"
    ),
    theta_label = "Underlying Response Rate",
    response_outcome = TRUE,
    bound_label = if (response_outcome) c("Futility Bound", "Efficacy Bound") else c("Efficacy Bound", "Futility Bound"),
    en_label = "Expected Sample Sizes",
    prob_decimals = 2,
    en_decimals = 1,
    rr_decimals = 0) {
  x_out <- x

  x[, "Lower"] <- sprintf(paste0("%.", prob_decimals, "f"), unlist(x[, "Lower"]))
  x[, "Upper"] <- sprintf(paste0("%.", prob_decimals, "f"), unlist(x[, "Upper"]))
  x[, "theta"] <- paste0(sprintf(paste0("%.", rr_decimals, "f"), unlist(x[, "theta"] * 100)), "%")
  x[, "en"] <- sprintf(paste0("%.", en_decimals, "f"), unlist(x[, "en"]))

  x %>%
    rtf_title(title = title) %>%
    rtf_colheader(
      paste0(theta_label, " | ", "Probability of Crossing", " | ", en_label),
      col_rel_width = c(1, 2, 1)
    ) %>%
    rtf_colheader(paste0(" | ", bound_label[1], " | ", bound_label[2], " | "),
      col_rel_width = c(1, 1, 1, 1),
      border_top = c("", rep("single", 2), ""),
      border_left = c("single", "single", "", "single")
    ) %>%
    rtf_body() %>%
    rtf_encode() %>%
    write_rtf(file)

  invisible(x_out)
}
#' @rdname as_rtf
#' 
#' @importFrom r2rtf rtf_title
#' @export
as_rtf.gsBoundSummary <- function(
    x,
    file,
    ...,
    title = "Group Sequential Design for a Time-to-event Endpoint",
    footnote_p_onesided = "xxx",
    footnote_hr = "Hazard ratio required to cross bound",
    footnote_p_cross = "Cumulative power at each analysis by underlying treatment effect either at null/alternative hypothesis") {
  x_out <- x
  
  # Add c for first instance of "p (1-sided)" in Value column
  first_instance <- which(x$Value == "p (1-sided)")[1]
  x[first_instance, "Value"] <- paste0(x[first_instance, "Value"], "{^a}")
  
  # Add b for first instance of "~HR at bound" in Value column
  first_instance <- which(x$Value == "~HR at bound")[1]
  x[first_instance, "Value"] <- paste0(x[first_instance, "Value"], "{^b}")
  
  # Add c for first instance of "P(Cross) if HR=1" in Value column
  first_instance <- which(x$Value == "P(Cross) if HR=1")[1]
  x[first_instance, "Value"] <- paste0(x[first_instance, "Value"], "{^c}")
  
  # Add c for first instance of "P(Cross) if HR=0.5" in Value column
  first_instance <- which(x$Value == "P(Cross) if HR=0.5")[1]
  x[first_instance, "Value"] <- paste0(x[first_instance, "Value"], "{^c}")
  
  # Insert blank row when Analysis column is null
  idx <- which(x$Analysis == "")
  idx_1 <- c(0, idx)
  blank_row <- data.frame(matrix(ncol = ncol(x), nrow = 1))
  colnames(blank_row) <- colnames(x)
  
  x_sub <- x[1:idx[1], ]
  for(i in 1:(length(idx)-1)) {
    x_sub <- rbind(x_sub, blank_row, x[(idx[i]+1):idx[i+1], ])
  }
  
  x <- x_sub
  x %>%
    rtf_title(title = title) %>%
    rtf_colheader(
      paste0("Analysis", " | ", "Value", " | ", "Efficacy", " | ", "Futility"),
      col_rel_width = c(1, 1.5, 1, 1)
    )  %>%
    rtf_body(text_justification = c("l", rep("c", 3)),
             col_rel_width = c(1, 1.5, 1, 1)) %>%
    rtf_footnote(c(paste0("{^a}", footnote_p_onesided),
                 paste0("{^b}", footnote_hr),
                 paste0("{^c}", footnote_p_cross))) %>%
    rtf_encode() %>%
    write_rtf(file)
  
  invisible(x_out)
}

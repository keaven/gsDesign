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
#' # as_rtf for gsBinomialExact
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
#'     file = tempfile(fileext = ".rtf"),
#'     theta_label = "Underlying\nAE Rate",
#'     prob_decimals = 3,
#'     bound_label = c("Low Rate", "High Rate")
#'   )
#' # as_rtf for gsBoundSummary
#' xgs <- gsSurv(lambdaC = .2, hr = .5, eta = .1, T = 2, minfup = 1.5)
#' gsBoundSummary(xgs, timename = "Year", tdigits = 1) %>% as_rtf(file = tempfile(fileext = ".rtf"))
#'
#' ss <- nSurvival(
#'   lambda1 = .2, lambda2 = .1, eta = .1, Ts = 2, Tr = .5,
#'   sided = 1, alpha = .025, ratio = 2
#' )
#' xs <- gsDesign(nFixSurv = ss$n, n.fix = ss$nEvents, delta1 = log(ss$lambda2 / ss$lambda1))
#' gsBoundSummary(xs, logdelta = TRUE, ratio = ss$ratio) %>% as_rtf(file = tempfile(fileext = ".rtf"))
#' 
#' xs <- gsDesign(nFixSurv = ss$n, n.fix = ss$nEvents, delta1 = log(ss$lambda2 / ss$lambda1))
#' gsBoundSummary(xs, logdelta = TRUE, ratio = ss$ratio) %>% 
#'   as_rtf(file = tempfile(fileext = ".rtf"),
#'   footnote_specify = "Z",
#'   footnote_text = "Z-Score")
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
#' @param title Title of the report.
#' @param footnote_p_onesided Footnote for one-side p-value. 
#' @param footnote_appx_effect_at_bound Footnote for approximate effect treatment at bound.
#' @param footnote_p_cross_hr1 Footnote for cumulative type I error.
#' @param footnote_p_cross_h0 Footnote for cumulative power under the alternate hypothesis.
#' @param footnote_specify Vector of string to put footnote super script.
#' @param footnote_text Vector of string of footnote text.
#' @importFrom r2rtf rtf_title rtf_footnote
#' @export
as_rtf.gsBoundSummary <- function(
    x,
    file,
    ...,
    title = "Boundary Characteristics for Group Sequential Design",
    footnote_p_onesided = "one-side p-value for experimental better than control",
    footnote_appx_effect_at_bound = NULL,
    footnote_p_cross_hr1 = "Cumulative type I error assuming binding futility bound",
    footnote_p_cross_h0 = "Cumulative power under the alternate hypothesis",
    footnote_specify = NULL,
    footnote_text = NULL) {
  x_out <- x
  
  if (is.null(footnote_appx_effect_at_bound)) {
    footnote_appx_effect_at_bound <- ifelse(!is.null(which(x$Value == "~HR at bound")),
                                            "Hazard ratio required to cross bound",
                                            "Approximate treatment effect at bound"
    )
  }

  letter_order <- 1
  footnote <- c()
  
  # Check footnote location is specified
  if(is.null(footnote_specify) & !is.null(footnote_text)){
    stop("Footnote location is not defined!")
  } 
  # Check footnote text is defined
  if(!is.null(footnote_specify) & is.null(footnote_text)){
    stop("Footnote text is not defined!")
  } 
  # Check length of footnote location and text is matched
  if(length(footnote_specify) != length(footnote_text)){
    stop("Length of footnote_specify and footnote_text is not matched!")
  } 
  
  
  # Add a for first instance of "p (1-sided)" in Value column
  if(!is.null(which(x$Value == "p (1-sided)")[1])) {
    first_instance <- which(x$Value == "p (1-sided)")[1]
    x[first_instance, "Value"] <- paste0(x[first_instance, "Value"], "{^", letters[letter_order], "}")
    footnote <- c(footnote, paste0("{^", letters[letter_order], "}", footnote_p_onesided))
    letter_order <- letter_order + 1
  }
  
  # Add b for first instance of "~HR at bound" in Value column
  if(!is.null(which(x$Value == "~HR at bound")[1])) {
    first_instance <- which(x$Value == "~HR at bound")[1]
    x[first_instance, "Value"] <- paste0(x[first_instance, "Value"], "{^", letters[letter_order], "}")
    footnote <- c(footnote, paste0("{^", letters[letter_order], "}", footnote_appx_effect_at_bound))
    letter_order <- letter_order + 1
  }

  # Add c for first instance of "P(Cross) if HR=1" in Value column
  if(!is.null(which(x$Value == "P(Cross) if HR=1")[1])) {
    first_instance <- which(x$Value == "P(Cross) if HR=1")[1]
    x[first_instance, "Value"] <- paste0(x[first_instance, "Value"], "{^", letters[letter_order], "}")
    footnote <- c(footnote, paste0("{^", letters[letter_order], "}", footnote_p_cross_hr1))
    letter_order <- letter_order + 1
  }

  # Add d for first instance of "P(Cross) if HR=0.5" in Value column
  if(!is.null(which(x$Value == "P(Cross) if HR=0.5")[1])) {
    first_instance <- which(x$Value == "P(Cross) if HR=0.5")[1]
    x[first_instance, "Value"] <- paste0(x[first_instance, "Value"], "{^", letters[letter_order], "}")
    footnote <- c(footnote, paste0("{^", letters[letter_order], "}", footnote_p_cross_hr0.5))
    letter_order <- letter_order + 1
  }
  
  if(!is.null(footnote_specify) & !is.null(footnote_text)){
    for(k in 1:length(footnote_specify)) {
      if(length(which(x == footnote_specify[k], arr.ind = TRUE)) == 0){
        stop("Footnote location not found!")
      }
      first_instance <- which(x == footnote_specify[k], arr.ind = TRUE)[1,]
      x[first_instance[1], first_instance[2]] <- paste0(x[first_instance[1], first_instance[2]] , "{^", letters[letter_order], "}")
      footnote <- c(footnote, paste0("{^", letters[letter_order], "}", footnote_text[k]))
      letter_order <- letter_order + 1
    }
  }
  
  # Insert blank row when Analysis column is null
  idx <- which(x$Value == "Z")
  blank_row <- data.frame(matrix(ncol = ncol(x), nrow = 1))
  colnames(blank_row) <- colnames(x)

  x_sub <- x[1:(idx[2] - 1), ]
  for (i in 2:length(idx)) {
    row_end <- ifelse(i == length(idx), length(x$Value), (idx[i + 1] - 1))
    x_sub <- rbind(x_sub, blank_row, x[idx[i]:row_end, ])
  }

  x <- x_sub
  x %>%
    rtf_title(title = title) %>%
    rtf_colheader(
      paste0("Analysis", " | ", "Value", " | ", "Efficacy", " | ", "Futility"),
      col_rel_width = c(1, 1.5, 1, 1)
    ) %>%
    rtf_body(
      text_justification = c("l", rep("c", 3)),
      col_rel_width = c(1, 1.5, 1, 1)
    ) %>%
    rtf_footnote(footnote) %>%
    rtf_encode() %>%
    write_rtf(file)

  invisible(x_out)
}

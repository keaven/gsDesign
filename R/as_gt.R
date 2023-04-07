#' Print a summary table using gt
#'
#' Create print a table created with as_table() to summarize an object and print it using gt(); currently only implemented for gsBinomialExact. 
#' 
#' @param x   Object to be printed using gt().
#' @param ... Other parameters that may be specific the object. 
#' 
#' @return A gt() object that may be extended by overloaded versions of \code{as_gt()}.
#'  
#' @seealso vignette("binomialSPRTexample")
#' 
#' @details 
#' Currently only implemented for gsBinomialExact objects. Creates a table to summarize an object.
#' For gsBinomialExact, this summarized operating characteristics across a range of effect sizes.
#' 
#' @importFrom tibble as_tibble
#' @importFrom tidyr pivot_longer 
#' @importFrom dplyr group_by summarize left_join mutate
#' 
#' @rdname as_gt
#' 
#' @export
#' 
#' @examples
#' safety_design <- binomialSPRT(p0 = .04, p1 = .1, alpha = .04, beta = .2, minn = 4, maxn = 75)
#' safety_power <- gsBinomialExact(k = length(safety_design$n.I), 
#'                                 theta = seq(.02, .16, .02), 
#'                                 n.I = safety_design$n.I, 
#'                                 a = safety_design$lower$bound, 
#'                                 b = safety_design$upper$bound)
#' safety_power %>% 
#'   as_table() %>% 
#'   as_gt(
#'     theta_label = html("Underlying<br>AE rate"),
#'     prob_decimals = 3,
#'     bound_label = c("low rate", "high rate")
#'   )

as_gt <- function(x, ...) UseMethod("as_gt")
as_gt.gsBinomialExactTable <- 
  function(x,
           title = "Operating Characteristics for the Truncated SPRT Design",
           subtitle = "Assumes trial evaluated sequentially after each response",
           theta_label = html("Underlying<br>response rate"),
           bound_label = c("Futility bound", "Efficacy bound"),
           prob_decimals = 2,
           en_decimals = 1,
           rr_decimals = 0){
    out_gt <- x %>% gt() %>%
      tab_spanner(label = "Probability of crossing", columns = c(Lower, Upper)) %>%
      cols_label(theta = theta_label,
                 Lower = bound_label[1],
                 Upper = bound_label[2],
                 en = html("Average<br>sample size")
      ) %>%
      fmt_number(columns = c(Lower, Upper), decimals = prob_decimals) %>%
      fmt_number(columns = en, decimals = en_decimals) %>%
      fmt_percent(columns = theta, decimals = rr_decimals) %>%
      tab_header(title=title, subtitle = subtitle)
    return(out_gt)
  }

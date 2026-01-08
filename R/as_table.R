#' Create a summary table
#'
#' Create a tibble to summarize an object; currently only implemented for
#' \code{\link{gsBinomialExact}}.
#'
#' @param x Object to be summarized.
#' @param ... Other parameters that may be specific to the object.
#'
#' @return A tibble which may have an extended class to enable further output processing.
#'
#' @seealso \code{vignette("binomialSPRTExample")}
#'
#' @details
#' Currently only implemented for \code{\link{gsBinomialExact}} objects.
#' Creates a table to summarize an object.
#' For \code{\link{gsBinomialExact}}, this summarized operating characteristics
#' across a range of effect sizes.
#'
#' @importFrom tibble as_tibble
#' @importFrom tidyr pivot_longer
#' @importFrom dplyr group_by summarize left_join mutate
#'
#' @export
#'
#' @examples
#' b <- binomialSPRT(p0 = .1, p1 = .35, alpha = .08, beta = .2, minn = 10, maxn = 25)
#' b_power <- gsBinomialExact(
#'   k = length(b$n.I), theta = seq(.1, .45, .05), n.I = b$n.I,
#'   a = b$lower$bound, b = b$upper$bound
#' )
#' b_power |>
#'   as_table() |>
#'   as_gt()
as_table <- function(x, ...) UseMethod("as_table")

#' @rdname as_table
#' @export
as_table.gsBinomialExact <- function(x, ...) {
  sum_lower <- t(x$lower$prob)
  theta <- as.double(names(t(x$lower$prob)[, 1]))
  sum_lower <- sum_lower |>
    as_tibble() |>
    mutate(theta = theta) |>
    pivot_longer(cols = !theta, names_to = "Analysis", values_to = "Probability") |>
    group_by(theta) |>
    summarize(Lower = sum(Probability))

  sum_upper <- t(x$upper$prob)
  sum_upper <- sum_upper |>
    as_tibble() |>
    mutate(theta = theta) |>
    pivot_longer(cols = !theta, names_to = "Analysis", values_to = "Probability") |>
    group_by(theta) |>
    summarize(Upper = sum(Probability))

  tab <- left_join(sum_lower, sum_upper, by = "theta")
  tab$en <- x$en
  class(tab) <- c(class(tab), "gsBinomialExactTable")
  return(tab)
}

#' Plot median follow-up across all planned participants
#'
#' Plot the forward calculation from \code{medianFollowUp()}, optionally
#' marking a design's analysis times. Dropout and event-stopping conventions,
#' input overrides and the planned-population definition are shared with that
#' function. The historical plot name is retained.
#'
#' @inheritParams medianFollowUp
#' @param calendarTime Nonnegative calendar cutoffs. With \code{x}, NULL
#'   creates a grid from trial start to its final analysis; without \code{x},
#'   supply this vector explicitly. Passed as \code{T} to the calculation.
#' @param showAnalysisTimes Whether to mark the analysis times in \code{x}.
#' @param timename Nonempty time-unit label. Month(s) and year(s) use axis
#'   breaks every 6 months and 0.5 years, respectively.
#' @return A \code{ggplot} object.
#' @seealso \code{\link{medianFollowUp}}
#' @examples
#' x <- gsSurv(gamma = 10, R = 12, T = 30, minfup = 18)
#' plotMinMedianFollowUp(x)
#' plotMinMedianFollowUp(x, stopAtEvent = TRUE)
#' @export
plotMinMedianFollowUp <- function(x = NULL, calendarTime = NULL,
  showAnalysisTimes = TRUE, timename = "Months", gamma = NULL, R = NULL,
  eta = NULL, etaE = NULL, lambdaC = NULL, hr = NULL, S = NULL,
  ratio = NULL, stopAtEvent = FALSE, tol = 1e-8) {
  model <- .followUpModel(x, gamma, R, eta, etaE, lambdaC, hr, S, ratio,
                         stopAtEvent, tol, missing(S), missing(etaE))
  if (!is.character(timename) || length(timename) != 1L || is.na(timename) ||
      !nzchar(trimws(timename))) stop("timename must be a nonempty character scalar")
  if (!is.logical(showAnalysisTimes) || length(showAnalysisTimes) != 1L ||
      is.na(showAnalysisTimes)) stop("showAnalysisTimes must be TRUE or FALSE")
  timename <- trimws(timename)
  if (is.null(calendarTime) && !is.null(x)) {
    calendarTime <- sort(unique(c(seq(0, max(x$T), length.out = 201L), x$T,
                                  cumsum(model$R))))
    calendarTime <- calendarTime[calendarTime <= max(x$T)]
  }
  .followUpCheckVector(calendarTime, "calendarTime", zero = TRUE)
  # Share the normalized model and forward calculation with medianFollowUp().
  values <- function(t) vapply(t, .followUpMedian, numeric(1), model = model, tol = tol)
  plot_data <- data.frame(calendarTime = calendarTime,
                          minimumMedianFollowUp = values(calendarTime))
  p <- ggplot2::ggplot(plot_data,
    ggplot2::aes(x = .data$calendarTime, y = .data$minimumMedianFollowUp)) +
    ggplot2::geom_line(linewidth = .8) +
    ggplot2::labs(x = paste0("Calendar time (", timename, ")"),
                  y = paste0("Median follow-up (", timename, ")")) + ggplot2::theme_bw()
  interval <- switch(tolower(timename), month = 6, months = 6, year = .5, years = .5, NULL)
  if (!is.null(interval)) p <- p + ggplot2::scale_x_continuous(breaks = seq(0, max(calendarTime), by = interval))
  if (showAnalysisTimes && !is.null(x)) {
    at <- x$T[x$T >= min(calendarTime) & x$T <= max(calendarTime)]
    p <- p + ggplot2::geom_point(data = data.frame(calendarTime = at,
      minimumMedianFollowUp = values(at)), size = 2)
  }
  p
}

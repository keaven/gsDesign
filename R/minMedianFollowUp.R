# minMedianFollowUp roxy [sinew] ----
#' Minimum median follow-up for a survival design
#'
#' Computes minimum median follow-up at one or more calendar times under the
#' enrollment assumptions in an \code{nSurv} or \code{gsSurv} object. Minimum
#' median follow-up is defined as the time elapsed since enrollment reached
#' one-half of the enrollment accumulated by the requested calendar time.
#' After enrollment is complete, this is one-half of final planned enrollment.
#'
#' Enrollment is integrated over the piecewise-constant rates in
#' \code{x$gamma} and durations in \code{x$R}, summing rates across strata.
#' Thus, at each requested calendar time, the median enrollment time is the
#' first time at which expected cumulative enrollment reached one-half of the
#' enrollment accumulated by then. Before any enrollment has occurred, the
#' result is \code{NA_real_}.
#'
#' The computation represents potential follow-up for all subjects randomized
#' by the requested calendar time. Conceptually, each subject contributes the
#' time from enrollment to that calendar time, regardless of whether the
#' subject would have experienced the event of interest, discontinued, or
#' dropped out. Event and dropout assumptions such as \code{x$lambdaC},
#' \code{x$etaC}, and \code{x$etaE} therefore do not enter the calculation.
#' This is not observed follow-up among subjects who remain under observation.
#'
#' This definition is continuous at the time enrollment completes when the
#' enrollment rate immediately before completion is positive. The value may
#' have kinks when an enrollment rate changes. A zero-enrollment period can
#' produce a discontinuity because no subjects have enrollment times within
#' that interval.
#'
#' @param x An \code{nSurv} or \code{gsSurv} object.
#' @param calendarTime Nonnegative calendar time(s) from the start of
#'   enrollment. For \code{minMedianFollowUp()}, the default is the planned
#'   analysis time(s) in \code{x$T}. For \code{plotMinMedianFollowUp()},
#'   \code{NULL} creates a grid from trial start through the final planned
#'   analysis time.
#' @param showAnalysisTimes Logical scalar indicating whether analysis times
#'   should be marked with points. For an \code{nSurv} object, this marks the
#'   final study time.
#' @param timename Nonempty character string indicating the time unit. Month
#'   and year labels (singular or plural, case-insensitive) use x-axis breaks
#'   every 6 months and 0.5 years, respectively. Other units use the default
#'   \code{ggplot2} breaks.
#'
#' @return \code{minMedianFollowUp()} returns a numeric vector with one value
#'   for each value of \code{calendarTime}.
#'   \code{plotMinMedianFollowUp()} returns a \code{ggplot} object.
#'
#' @examples
#' x <- gsSurv(gamma = 10, R = 12, T = 30, minfup = 18)
#'
#' # Minimum median follow-up at each planned analysis
#' minMedianFollowUp(x)
#'
#' # Minimum median follow-up at 12, 18, and 24 months
#' minMedianFollowUp(x, calendarTime = c(12, 18, 24))
#'
#' # Plot its evolution through the planned analyses
#' plotMinMedianFollowUp(x)
#'
#' # The same functions work for a fixed survival design
#' x_fixed <- nSurv(gamma = 10, R = 12, T = 30, minfup = 18)
#' minMedianFollowUp(x_fixed)
#' plotMinMedianFollowUp(x_fixed)
#'
#' @export
minMedianFollowUp <- function(x, calendarTime = x$T) {
  if (!inherits(x, c("nSurv", "gsSurv"))) {
    stop("x must be an nSurv or gsSurv object")
  }
  if (!is.numeric(calendarTime) || length(calendarTime) < 1L ||
    anyNA(calendarTime) || any(!is.finite(calendarTime)) ||
    any(calendarTime < 0)) {
    stop("calendarTime must contain finite, nonnegative numeric values")
  }

  gamma <- accrual_gamma(x$gamma, x$R)
  enrollment_rate <- rowSums(gamma)
  enrollment_by_period <- enrollment_rate * x$R
  total_enrollment <- sum(enrollment_by_period)
  if (!is.finite(total_enrollment) || total_enrollment <= 0) {
    stop("x must specify positive, finite planned enrollment")
  }

  cumulative_enrollment <- cumsum(enrollment_by_period)
  period_start <- c(0, utils::head(cumsum(x$R), -1L))

  vapply(calendarTime, function(current_time) {
    accrued_duration <- pmax(
      0,
      pmin(x$R, current_time - period_start)
    )
    enrollment_to_date <- sum(enrollment_rate * accrued_duration)
    if (enrollment_to_date <= 0) {
      return(NA_real_)
    }

    target <- enrollment_to_date / 2
    median_period <- which(cumulative_enrollment >= target)[1]
    enrollment_before <- if (median_period == 1L) {
      0
    } else {
      cumulative_enrollment[median_period - 1L]
    }
    median_enrollment_time <- period_start[median_period] +
      (target - enrollment_before) / enrollment_rate[median_period]

    current_time - median_enrollment_time
  }, numeric(1))
}

# plotMinMedianFollowUp function [sinew] ----
#' @rdname minMedianFollowUp
#' @export
plotMinMedianFollowUp <- function(
  x,
  calendarTime = NULL,
  showAnalysisTimes = TRUE,
  timename = "Months"
) {
  if (!inherits(x, c("nSurv", "gsSurv"))) {
    stop("x must be an nSurv or gsSurv object")
  }
  if (!is.character(timename) || length(timename) != 1L ||
    is.na(timename) || !nzchar(trimws(timename))) {
    stop("timename must be a nonempty character scalar")
  }
  timename <- trimws(timename)
  if (!is.logical(showAnalysisTimes) || length(showAnalysisTimes) != 1L ||
    is.na(showAnalysisTimes)) {
    stop("showAnalysisTimes must be TRUE or FALSE")
  }

  if (is.null(calendarTime)) {
    final_time <- max(x$T)
    calendarTime <- sort(unique(c(
      seq(0, final_time, length.out = 201L),
      x$T,
      cumsum(x$R)
    )))
    calendarTime <- calendarTime[calendarTime <= final_time]
  }

  plot_data <- data.frame(
    calendarTime = calendarTime,
    minimumMedianFollowUp = minMedianFollowUp(x, calendarTime)
  )
  plot_data <- plot_data[!is.na(plot_data$minimumMedianFollowUp), , drop = FALSE]
  break_interval <- switch(
    tolower(timename),
    month = 6,
    months = 6,
    year = 0.5,
    years = 0.5,
    NULL
  )

  p <- ggplot2::ggplot(
    plot_data,
    ggplot2::aes(
      x = .data$calendarTime,
      y = .data$minimumMedianFollowUp
    )
  ) +
    ggplot2::geom_line(linewidth = 0.8) +
    ggplot2::labs(
      x = paste0("Calendar time (", timename, ")"),
      y = paste0("Minimum median follow-up (", timename, ")")
    ) +
    ggplot2::theme_bw()

  if (!is.null(break_interval)) {
    p <- p + ggplot2::scale_x_continuous(
      breaks = seq(0, max(calendarTime), by = break_interval)
    )
  }

  if (showAnalysisTimes) {
    analysis_time <- x$T[
      x$T >= min(calendarTime) & x$T <= max(calendarTime)
    ]
    analysis_data <- data.frame(
      calendarTime = analysis_time,
      minimumMedianFollowUp = minMedianFollowUp(x, analysis_time)
    )
    analysis_data <- analysis_data[
      !is.na(analysis_data$minimumMedianFollowUp),
      ,
      drop = FALSE
    ]
    p <- p + ggplot2::geom_point(
      data = analysis_data,
      mapping = ggplot2::aes(
        x = .data$calendarTime,
        y = .data$minimumMedianFollowUp
      ),
      inherit.aes = FALSE,
      size = 2
    )
  }

  p
}

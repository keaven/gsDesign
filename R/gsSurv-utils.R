# periods function [sinew] ----
periods <- function(S, T, minfup, digits) {
  periods <- cumsum(S)
  if (length(periods) == 0) {
    periods <- max(0, T - minfup)
  } else {
    maxT <- max(0, min(T - minfup, max(periods)))
    periods <- periods[periods <= maxT]
    if (max(periods) < T - minfup) {
      periods <- c(periods, T - minfup)
    }
  }
  nper <- length(periods)
  names1 <- c(0, round(periods[1:(nper - 1)], digits))
  names <- paste("-", periods, sep = "")
  names <- paste(names1, names, sep = "")
  return(list(periods, names))
}

# nameperiod function [sinew] ----
nameperiod <- function(R, digits = 2) {
  if (length(R) == 1) {
    return(paste("0-", round(R, digits), sep = ""))
  }
  R0 <- c(0, R[1:(length(R) - 1)])
  return(paste(round(R0, digits), "-", round(R, digits), sep = ""))
}

# validate_survival_timing_inputs function [sinew] ----
validate_survival_timing_inputs <- function(R, T, minfup, call = "nSurv") {
  if (is.null(R)) {
    stop(call, ": R must be specified and cannot be NULL", call. = FALSE)
  }
  if (!is.numeric(R) || any(is.na(R)) || any(!is.finite(R)) || any(R <= 0)) {
    stop(call, ": R must be a numeric vector of positive finite values", call. = FALSE)
  }
  if (!is.null(T) &&
    (!is.numeric(T) || length(T) != 1 || is.na(T) || !is.finite(T) || T <= 0)) {
    stop(
      call, ": T must be NULL or a single positive finite numeric value",
      call. = FALSE
    )
  }
  if (!is.null(minfup) &&
    (!is.numeric(minfup) || length(minfup) != 1 ||
      is.na(minfup) || !is.finite(minfup) || minfup < 0)) {
    stop(
      call, ": minfup must be NULL or a single non-negative finite numeric value",
      call. = FALSE
    )
  }
  if (!is.null(T) && !is.null(minfup)) {
    accrual_duration <- T - minfup
    if (accrual_duration <= 0) {
      stop(call, ": T must be greater than minfup", call. = FALSE)
    }
    tolerance <- sqrt(.Machine$double.eps) * max(1, abs(accrual_duration))
    if (length(R) > 1 && sum(R) - accrual_duration > tolerance) {
      stop(
        call, ": enrollment duration from R (", signif(sum(R), 12),
        ") exceeds T - minfup (", signif(accrual_duration, 12),
        "); shorten R/gamma or increase T relative to minfup",
        call. = FALSE
      )
    }
  }
  invisible(TRUE)
}

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

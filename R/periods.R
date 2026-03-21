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

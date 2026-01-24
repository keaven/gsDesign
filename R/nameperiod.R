# nameperiod function [sinew] ----
nameperiod <- function(R, digits = 2) {
  if (length(R) == 1) {
    return(paste("0-", round(R, digits), sep = ""))
  }
  R0 <- c(0, R[1:(length(R) - 1)])
  return(paste(round(R0, digits), "-", round(R, digits), sep = ""))
}

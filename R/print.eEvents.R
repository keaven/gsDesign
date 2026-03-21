# print.eEvents roxy [sinew] ----
#' @rdname eEvents
#' @export
# print.eEvents function [sinew] ----
print.eEvents <- function(x, digits = 4, ...) {
  if (!inherits(x, "eEvents")) {
    stop("print.eEvents: primary argument must have class eEvents")
  }
  cat("Study duration:              Tfinal=",
    round(x$Tfinal, digits), "\n",
    sep = ""
  )
  cat("Analysis time:                    T=",
    round(x$T, digits), "\n",
    sep = ""
  )
  cat("Accrual duration:                   ",
    round(min(
      x$T - max(0, x$minfup - (x$Tfinal - x$T)),
      sum(x$R)
    ), digits), "\n",
    sep = ""
  )
  cat("Min. end-of-study follow-up: minfup=",
    round(x$minfup, digits), "\n",
    sep = ""
  )
  cat("Expected events (total):            ",
    round(sum(x$d), digits), "\n",
    sep = ""
  )
  if (length(x$d) > 1) {
    cat(
      "Expected events by stratum:       d=",
      round(x$d[1], digits)
    )
    for (i in 2:length(x$d)) {
      cat(paste("", round(x$d[i], digits)))
    }
    cat("\n")
  }
  cat("Expected sample size (total):       ",
    round(sum(x$n), digits), "\n",
    sep = ""
  )
  if (length(x$n) > 1) {
    cat(
      "Sample size by stratum:           n=",
      round(x$n[1], digits)
    )
    for (i in 2:length(x$n)) {
      cat(paste("", round(x$n[i], digits)))
    }
    cat("\n")
  }
  nstrata <- dim(x$lambda)[2]
  cat("Number of strata:                   ",
    nstrata, "\n",
    sep = ""
  )
  cat("Accrual rates:\n")
  print(round(x$gamma, digits))
  cat("Event rates:\n")
  print(round(x$lambda, digits))
  cat("Censoring rates:\n")
  print(round(x$eta, digits))
  return(x)
}

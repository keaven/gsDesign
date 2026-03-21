# nEventsIA roxy [sinew] ----
#' @export
#' @rdname nSurv
# nEventsIA function [sinew] ----
nEventsIA <- function(tIA = 5, x = NULL, target = 0,
                      simple = TRUE) {
  Qe <- x$ratio / (1 + x$ratio)
  eDC <- eEvents(
    lambda = x$lambdaC, eta = x$etaC,
    gamma = x$gamma * (1 - Qe), R = x$R, S = x$S, T = tIA,
    Tfinal = x$T[length(x$T)], minfup = x$minfup
  )
  eDE <- eEvents(
    lambda = x$lambdaC * x$hr, eta = x$etaC,
    gamma = x$gamma * Qe, R = x$R, S = x$S, T = tIA,
    Tfinal = x$T[length(x$T)], minfup = x$minfup
  )
  if (simple) {
    if (class(x)[1] == "gsSize") {
      d <- x$d
    } else if (!is.matrix(x$eDC)) {
      d <- sum(x$eDC[length(x$eDC)] + x$eDE[length(x$eDE)])
    } else {
      d <- sum(x$eDC[nrow(x$eDC), ] + x$eDE[nrow(x$eDE), ])
    }
    return(sum(eDC$d + eDE$d) - target * d)
  } else {
    return(list(
      T = tIA, eDC = eDC$d, eDE = eDE$d,
      eNC = eDC$n, eNE = eDE$n
    ))
  }
}

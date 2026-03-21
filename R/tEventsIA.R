# tEventsIA roxy [sinew] ----
#' @export
#' @rdname nSurv
#' @seealso
#'  \code{\link[stats]{uniroot}}
#' @importFrom stats uniroot
# tEventsIA function [sinew] ----
tEventsIA <- function(x, timing = .25,
                      tol = .Machine$double.eps^0.25) {
  T <- x$T[length(x$T)]
  z <- uniroot(
    f = nEventsIA, interval = c(0.0001, T - .0001), x = x,
    target = timing, tol = tol, simple = TRUE
  )
  return(nEventsIA(tIA = z$root, x = x, simple = FALSE))
}

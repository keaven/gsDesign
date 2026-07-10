#' Deprecated: use lt() instead
#'
#' \code{as_gt()} is deprecated; use \code{\link[lt]{lt}()} instead.
#'
#' @param x Object to be converted.
#' @param ... Additional arguments passed to \code{\link[lt]{lt}()}.
#'
#' @return An \code{lt_tbl} object.
#'
#' @seealso \code{\link{lt-methods}}
#'
#' @export
as_gt <- function(x, ...) {
  .Deprecated("lt", package = "lt",
    msg = "as_gt() is deprecated; please use lt::lt() instead.")
  lt::lt(x, ...)
}

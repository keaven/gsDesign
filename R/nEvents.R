# nEvents function [sinew] ----
#' @title FUNCTION_TITLE
#' @description FUNCTION_DESCRIPTION
#' @param hr PARAM_DESCRIPTION, Default: 0.6
#' @param alpha PARAM_DESCRIPTION, Default: 0.025
#' @param beta PARAM_DESCRIPTION, Default: 0.1
#' @param ratio PARAM_DESCRIPTION, Default: 1
#' @param sided PARAM_DESCRIPTION, Default: 1
#' @param hr0 PARAM_DESCRIPTION, Default: 1
#' @param n PARAM_DESCRIPTION, Default: 0
#' @param tbl PARAM_DESCRIPTION, Default: FALSE
#' @return OUTPUT_DESCRIPTION
#' @details DETAILS
#' @examples 
#' \dontrun{
#' if(interactive()){
#'  #EXAMPLE1
#'  }
#' }
#' @seealso 
#'  \code{\link[stats]{Normal}}
#' @rdname nEvents
#' @export 
#' @author Keaven Anderson, PhD
#' @importFrom stats qnorm pnorm
nEvents <- function(hr = .6, alpha = .025, beta = .1, ratio = 1, sided = 1, hr0 = 1, n = 0, tbl = FALSE) {
  if (sided != 1 && sided != 2) stop("sided must be 1 or 2")
  c <- sqrt(ratio) / (1 + ratio)
  delta <- -c * (log(hr) - log(hr0))
  if (n[1] == 0) {
    n <- (stats::qnorm(1 - alpha / sided) + stats::qnorm(1 - beta))^2 / delta^2
    if (tbl) {
      n <- data.frame(cbind(
        hr = hr, n = ceiling(n), alpha = alpha,
        sided = sided, beta = beta,
        Power = 1 - beta, delta = delta, ratio = ratio,
        hr0 = hr0, se = 1 / c / sqrt(ceiling(n))
      ))
    }
    return(n)
  }
  else {
    pwr <- stats::pnorm(-(stats::qnorm(1 - alpha / sided) - sqrt(n) * delta))
    if (tbl) {
      pwr <- data.frame(cbind(
        hr = hr, n = n, alpha = alpha,
        sided = sided, beta = 1 - pwr,
        Power = pwr, delta = delta, ratio = ratio,
        hr0 = hr0, se = sqrt(1 / n) / c
      ))
    }
    return(pwr)
  }
}

#' @title FUNCTION_TITLE
#' @description FUNCTION_DESCRIPTION
#' @param z PARAM_DESCRIPTION
#' @param n PARAM_DESCRIPTION
#' @param ratio PARAM_DESCRIPTION, Default: 1
#' @param hr0 PARAM_DESCRIPTION, Default: 1
#' @param hr1 PARAM_DESCRIPTION, Default: 0.7
#' @return OUTPUT_DESCRIPTION
#' @details DETAILS
#' @examples 
#' \dontrun{
#' if(interactive()){
#'  #EXAMPLE1
#'  }
#' }
#' @rdname zn2hr
#' @export 
#' @author Keaven Anderson, PhD
zn2hr <- function(z, n, ratio = 1, hr0 = 1, hr1 = .7) {
  c <- 1 / (1 + ratio)
  psi <- c * (1 - c)
  exp(z * sign(hr1 - hr0) / sqrt(n * psi)) * hr0
}

# hrn2z function [sinew] ----
#' @title FUNCTION_TITLE
#' @description FUNCTION_DESCRIPTION
#' @param hr PARAM_DESCRIPTION
#' @param n PARAM_DESCRIPTION
#' @param ratio PARAM_DESCRIPTION, Default: 1
#' @param hr0 PARAM_DESCRIPTION, Default: 1
#' @param hr1 PARAM_DESCRIPTION, Default: 0.7
#' @return OUTPUT_DESCRIPTION
#' @details DETAILS
#' @examples 
#' \dontrun{
#' if(interactive()){
#'  #EXAMPLE1
#'  }
#' }
#' @rdname hrn2z
#' @export 
#' @author Keaven Anderson, PhD
hrn2z <- function(hr, n, ratio = 1, hr0 = 1, hr1 = .7) {
  c <- 1 / (1 + ratio)
  psi <- c * (1 - c)
  log(hr / hr0) * sqrt(n * psi) * sign(hr0 - hr1)
}

# hrz2n function [sinew] ----
#' @title FUNCTION_TITLE
#' @description FUNCTION_DESCRIPTION
#' @param hr PARAM_DESCRIPTION
#' @param z PARAM_DESCRIPTION
#' @param ratio PARAM_DESCRIPTION, Default: 1
#' @param hr0 PARAM_DESCRIPTION, Default: 1
#' @return OUTPUT_DESCRIPTION
#' @details DETAILS
#' @examples 
#' \dontrun{
#' if(interactive()){
#'  #EXAMPLE1
#'  }
#' }
#' @rdname hrz2n
#' @export 
#' @author Keaven Anderson, PhD
hrz2n <- function(hr, z, ratio = 1, hr0 = 1) {
  c <- 1 / (1 + ratio)
  psi <- c * (1 - c)
  (z / log(hr / hr0))^2 / psi
}

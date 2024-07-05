#' @title Xi and Gallo conditional error spending functions
#' 
#' @description Error spending functions based on Xi and Gallo (2018).
#' The intention of these spending functions is to provide bounds where the conditional error
#' at an efficacy bound is approximately equal to the conditional error rate for crossing the final analysis bound.
#' This is explained in greater detail in the vignette `r vignette("Conditional Error Spending Functions")`.
#' 
#' Three spending functions are defined: \code{sfXG1}, \code{sfXG2}, and \code{sfXG3}.
#' Method 1 is defined for \eqn{\gamma \in [0.5, 1)} as
#' 
#' \deqn{f(Z_K\ge u_K|Z_k=u_k) = 2 - 2\times \Phi\left(\frac{z_{\alpha/2} - z_\gamma\sqrt{1-t}}{\sqrt t} \right).}
#' 
#' This method provides the bet
#' 
#' Method 2 is defined for \eqn{\gamma \in [1 - \Phi(z_{\alpha/2}/2), 1)} as
#' \deqn{f_\gamma(t; \alpha)=2-2\Phi \left(
#' \Phi^{-1}(1-\alpha/2)/ t^{1/2} \right).}{% f(t;
#' alpha)=2-2*Phi(Phi^(-1)(1-alpha/2)/t^(1/2)).}
#' 
#' \alpha_\gamma(t)= 2 - 2\times \Phi\left(\frac{z_{\alpha/2} - z_\gamma(1-t)}{\sqrt t} \right)
#' 
#' 
#' Method 3 is defined as for \eqn{\gamma \in (\alpha/2, 1)} as
#' 
#' \deqn{f(t; \alpha)= 2 - 2\times \Phi\left(\frac{z_{\alpha/2} - z_\gamma(1-\sqrt t)}{\sqrt t} \right).}
#' 
#' 
#' @param alpha Real value \eqn{> 0} and no more than 1. Normally,
#' \code{alpha=0.025} for one-sided Type I error specification or
#' \code{alpha=0.1} for Type II error specification. However, this could be set
#' to 1 if for descriptive purposes you wish to see the proportion of spending
#' as a function of the proportion of sample size/information.
#' @param t A vector of points with increasing values from 0 to 1, inclusive.
#' Values of the proportion of sample size/information for which the spending
#' function will be computed.
#' @param param This is the gamma parameter in the Xi and Gallo spending function paper, distinct for each function.
#' @return An object of type \code{spendfn}. See spending functions for further
#' details.
#' 
#' @details 
#' Xi and Gallo use an additive boundary for group sequential designs with connection to conditional error.
#' 
#' @examples
#' @author Keaven Anderson \email{keaven_anderson@@merck.}
#' @seealso \link{Spending_Function_Overview}, \code{\link{gsDesign}},
#' 
#' \link{gsDesign package overview}
#' @references Jennison C and Turnbull BW (2000), \emph{Group Sequential
#' Methods with Applications to Clinical Trials}. Boca Raton: Chapman and Hall.
#'
#' Xi D and Gallo P (2019), An additive boundary for group sequential designs with connection to conditional error.
#' \emph{Statistics in Medicine}; 38, 4656-4669 
#' @keywords design, spending function
#' @rdname sfXG1
#' @aliases sfXG sfXG2 sfXG3
#' @export
#' 
sfXG1 <- function(alpha, t, param) {
  # Check for scalar parameter in [0.5, 1)
  checkScalar(param, "numeric", c(.5, 1), c(TRUE, FALSE))
  
  # For values of t > 1, compute value as if t = 1
  t <- pmin(t, 1)
  
  # Compute spending
  y <- 2 - 2 * pnorm((qnorm(1 - alpha / 2) -
                        qnorm(1 - param) * sqrt(1 - t)) / sqrt(t))
  
  # Assemble return value and return
  x <- list(name = "Xi-Gallo, method 1", param = param, 
            parname = "gamma", sf = sfXG1, 
            spend = y,
            bound = NULL,
            prob = NULL)
  class(x) <- "spendfn"
  x
}

sfXG2 <- function(alpha, t, param) {
  # Check for scalar parameter in appropriate range
  checkScalar(param, "numeric", c(1 - pnorm(qnorm(1 - alpha / 2)), 1), c(TRUE, FALSE))
  
  # For values of t > 1, compute value as if t = 1
  t <- pmin(t, 1)
  
  # Compute spending
  y <- 2 - 2 * pnorm((qnorm(1 - alpha / 2) -
                        qnorm(1 - param) * (1 - t)) / sqrt(t))
  
  # Assemble return value and return
  x <- list(name = "Xi-Gallo, method 2", param = param, 
            parname = "gamma", sf = sfXG2, 
            spend = y,
            bound = NULL,
            prob = NULL)
  class(x) <- "spendfn"
  x
}

sfXG3 <- function(alpha, t, param) {
  # Check for scalar parameter in appropriate range
  checkScalar(param, "numeric", c(alpha / 2, 1), c(FALSE, FALSE))
  
  # For values of t > 1, compute value as if t = 1
  t <- pmin(t, 1)
  
  # Compute spending
  y <- 2 - 2 * pnorm((qnorm(1 - alpha / 2) -
                        qnorm(1 - param) * (1 - sqrt(t))) / sqrt(t))
  
  # Assemble return value and return
  x <- list(name = "Xi-Gallo, method 1", param = param, 
            parname = "gamma", sf = sfXG3, 
            spend = y,
            bound = NULL,
            prob = NULL)
  class(x) <- "spendfn"
  x
}
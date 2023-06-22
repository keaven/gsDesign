#' Translate group sequential design to integer events (survival designs) or sample size (other designs)
#' 
#' @param x an object of class \code{gsDesign}
#' @param roundUpFinal final value in returned \code{n.I} rounded up if TRUE; otherwise, just rounded
#' 
#' 
#' @return An object of class \code{gsDesign} with integer vector for \code{n.I}
#' @export
#'
#' @examples
#' The following code derives the group sequential design using the method of Lachin and Foulkes.
#' 
#' x <- gsSurv(
#'   k = 3,                 # 3 analyses
#'   test.type = 4,         # Non-binding futility bound 1 (no futility bound) and 4 are allowable
#'   alpha = .025,          # 1-sided Type I error
#'   beta = .1,             # Type II error (1 - power)
#'   timing = c(0.45, 0.7), # Proportion of final planned events at interims
#'   sfu = sfHSD,          # Efficacy spending function
#'   sfupar = -4,           # Parameter for efficacy spending function
#'   sfl = sfLDOF,          # Futility spending function; not needed for test.type = 1
#'   sflpar = 0,            # Parameter for futility spending function
#'   lambdaC = .001,        # Exponential failure rate
#'   hr = 0.3,              # Assumed proportional hazard ratio (1 - vaccine efficacy = 1 - VE)
#'   hr0 = 0.7,             # Null hypothesis VE
#'   eta = 5e-04,           # Exponential dropout rate
#'   gamma = 10,            # Piecewise exponential enrollment rates
#'   R = 16,                # Time period durations for enrollment rates in gamma
#'   T = 24,                # Planned trial duration
#'   minfup = 8,            # Planned minimum follow-up
#'   ratio = 3              # Randomization ratio (experimental:contro)
#' )
#' # Convert bounds to exact binomial bounds
#' toInteger(x)toInteger <- function(x, roundUpFinal = TRUE){
  if (max(class(x) != "gsDesign") stop("toInteger must have class gsDesign as input")
      counts <- round(x$n.I) # Round counts
      if(roundUpFinal) counts[k] <- ceiling(x$n.I[k]) # Round up for final count
      timing <- counts / max(counts)
      xx <- gsDesign(
        k = k, test.type = x$test.type, n.I = counts, maxn.IPlan = counts[k],
        alpha = x$alpha, beta = x$beta,
        delta = x$delta, delta1 = x$delta1, delta0 = x$delta0,
        sfu = x$upper$sf, sfupar = x$upper$param, sfl = x$lower$sf, sflpar = x$lower$param
      )
      # For non-inferiority and super-superiority trials
      if (class(x)[1] == "gsSurv") xx$hr0 <- x$hr0
      return(xx)
}

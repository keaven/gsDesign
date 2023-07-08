#' Translate group sequential design to integer events (survival designs) or sample size (other designs)
#' 
#' @param x an object of class \code{gsDesign}
#' @param ratio integer indicating randomization ratio; see details
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
#'   sfu = sfHSD,           # Efficacy spending function
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
#' toInteger(x, ratio = 3)

#' @details Note that if ratio is 0, rounding is done to the

toInteger <- function(x, ratio = 0, roundUpFinal = TRUE){
  if (max(class(x) == "gsDesign") != 1) stop("toInteger must have class gsDesign as input")
  # Default is to just round counts
  counts <- round(x$n.I) # Round counts
  if(roundUpFinal) counts[x$k] <- ceiling(x$n.I[x$k])
  if (!is.numeric(ratio) || ratio != round(ratio) || ratio < 0 ) stop("toInteger input ratio must be a non-negative integer")
  # for non-survival designs re-round sample size based on randomization ratio
  if (max(class(x) == "gsSurv") != 1){
    if(roundUpFinal){counts[x$k] <- ceiling(x$n.I[x$k] / (ratio + 1)) * (ratio + 1) # Round up for final count
    }else counts[x$k] <- round(x$n.I[x$k] / (ratio + 1)) * (ratio + 1)
  }
  # update bounds and counts from original design
  xi <- gsDesign(
    k = x$k, test.type = x$test.type, n.I = counts, maxn.IPlan = counts[x$k],
    alpha = x$alpha, beta = x$beta, astar = x$astar,
    delta = x$delta, delta1 = x$delta1, delta0 = x$delta0, endpoint = x$endpoint,
    sfu = x$upper$sf, sfupar = x$upper$param, sfl = x$lower$sf, sflpar = x$lower$param
  )
  if ("gsSurv" %in% class(x) || x$nFixSurv > 0) {
    xi$hr0 <- x$hr0 # H0 hazard ratio
    xi$hr <- x$hr # H1 hazard ratio
    # Update sample size to integer
    if (roundUpFinal){N <- ceiling(as.numeric(x$eNC[x$k]))
    }else{N <- round(as.numeric(x$eNC[x$k]))} 
    N <- N * (x$ratio + 1)
    # update enrollment rates to achieve new sample size in same time    
    inflateN <- N / as.numeric(x$eNC[x$k] + x$eNE[x$k])
    xx <- nSurv(
      lambdaC = x$lambdaC, hr = x$hr, hr0 = x$hr0, eta = x$etaC, etaE = x$etaE,
      gamma = x$gamma * inflateN, R = x$R, S = x$S, T = x$T, minfup = x$minfup, ratio = x$ratio,
      alpha = x$alpha, beta = NULL, sided = 1, tol = x$tol
    )
    xx$tol <- x$tol
    z <- gsDesign:::gsnSurv(xx, xi$n.I[xi$k])
    eDC <- NULL
    eDE <- NULL
    eDC0 <- NULL
    eDE0 <- NULL
    eNC <- NULL
    eNE <- NULL
    T <- NULL
    for (i in 1:(x$k - 1)) {
      xx <- tEventsIA(z, xi$timing[i], tol = x$tol)
      T <- c(T, xx$T)
      eDC <- rbind(eDC, xx$eDC)
      eDE <- rbind(eDE, xx$eDE)
      eDC0 <- rbind(eDC0, xx$eDC0) # Added 6/15/2023
      eDE0 <- rbind(eDE0, xx$eDE0) # Added 6/15/2023
      eNC <- rbind(eNC, xx$eNC)
      eNE <- rbind(eNE, xx$eNE)
    }
    xi$T <- c(T, z$T)
    xi$eDC <- rbind(eDC, z$eDC)
    xi$eDE <- rbind(eDE, z$eDE)
    xi$eDC0 <- rbind(eDC0, z$eDC0) # Added 6/15/2023
    xi$eDE0 <- rbind(eDE0, z$eDE0) # Added 6/15/2023
    xi$eNC <- rbind(eNC, z$eNC)
    xi$eNE <- rbind(eNE, z$eNE)
    xi$hr <- x$hr
    xi$hr0 <- x$hr0
    xi$R <- z$R
    xi$S <- z$S
    xi$minfup <- z$minfup
    xi$gamma <- z$gamma
    xi$ratio <- ratio
    xi$lambdaC <- z$lambdaC
    xi$etaC <- z$etaC
    xi$etaE <- z$etaE
    xi$variable <- x$variable
    xi$tol <- x$tol
    class(xi) <- c("gsSurv", "gsDesign")
    
    nameR <- gsDesign:::nameperiod(cumsum(xi$R))
    stratnames <- paste("Stratum", 1:ncol(xi$lambdaC))
    if (is.null(xi$S)) {
      nameS <- "0-Inf"
    } else {
      nameS <- gsDesign:::nameperiod(cumsum(c(xi$S, Inf)))
    }
    rownames(xi$lambdaC) <- nameS
    colnames(xi$lambdaC) <- stratnames
    rownames(xi$etaC) <- nameS
    colnames(xi$etaC) <- stratnames
    rownames(xi$etaE) <- nameS
    colnames(xi$etaE) <- stratnames
    rownames(xi$gamma) <- nameR
    colnames(xi$gamma) <- stratnames
  }
  return(xi)
}

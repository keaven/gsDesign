#' Translate group sequential design to integer events (survival designs)
#' or sample size (other designs)
#'
#' @param x An object of class \code{gsDesign} or \code{gsSurv}.
#' @param ratio Usually corresponds to experimental:control sample size ratio.
#'   If an integer is provided, rounding is done to a multiple of
#'   \code{ratio + 1}. See details.
#'   If input is non integer, rounding is done to the nearest integer or
#'   nearest larger integer depending on \code{roundUpFinal}.
#' @param roundUpFinal Sample size is rounded up to a value of \code{ratio + 1}
#'   with the default \code{roundUpFinal = TRUE} if \code{ratio} is a
#'   non-negative integer.
#'   If \code{roundUpFinal = FALSE} and \code{ratio} is a non-negative integer,
#'   sample size is rounded to the nearest multiple of \code{ratio + 1}.
#'   For event counts, \code{roundUpFinal = TRUE} rounds final event count up;
#'   otherwise, just rounded if \code{roundUpFinal = FALSE}.
#'   See details.
#'
#' @return Output is an object of the same class as input \code{x}; i.e.,
#'   \code{gsDesign} with integer vector for \code{n.I} or \code{gsSurv}
#'   with integer vector \code{n.I} and integer total sample size. See details.
#'
#' @details
#' It is useful to explicitly provide the argument \code{ratio} when a
#' \code{gsDesign} object is input since \code{gsDesign} does not have a
#' \code{ratio} in return.
#' \code{ratio = 0, roundUpFinal = TRUE} will just round up the sample size
#' (also event count).
#' Rounding of event count targets is not impacted by \code{ratio}.
#' Since \code{x <- gsSurv(ratio = M)} returns a value for \code{ratio},
#' \code{toInteger(x)} will round to a multiple of \code{M + 1} if \code{M}
#' is a non-negative integer; otherwise, just rounding will occur.
#' The most common example would be if there is 1:1 randomization (2:1) and
#' the user wishes an even (multiple of 3) sample size, then \code{toInteger()}
#' will operate as expected.
#' To just round without concern for randomization ratio, set \code{ratio = 0}.
#' If \code{toInteger(x, ratio = 3)}, rounding for final sample size is done
#' to a multiple of 3 + 1 = 4; this could represent a 3:1 or 1:3
#' randomization ratio.
#' For 3:2 randomization, \code{ratio = 4} would ensure rounding sample size
#' to a multiple of 5.
#'
#' @export
#'
#' @examples
#' # The following code derives the group sequential design using the method
#' # of Lachin and Foulkes
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
#'   ratio = 3              # Randomization ratio (experimental:control)
#' )
#' # Convert sample size to multiple of ratio + 1 = 4, round event counts.
#' # Default is to round up both event count and sample size for final analysis
#' toInteger(x)
toInteger <- function(x, ratio = x$ratio, roundUpFinal = TRUE) {
  if (!inherits(x, "gsDesign")) stop("must have class gsDesign as input")
  if (!(isInteger(ratio) && ratio >= 0)){
    message("toInteger: rounding done to nearest integer since ratio was not specified as postive integer .")
    ratio <- 0
  }
  counts <- round(x$n.I) # Round counts (event counts for survival; otherwise sample size)
  # For time-to-event endpoint, just round final event count up
  if (inherits(x, "gsSurv")) {
    if (abs(counts[x$k] - x$n.I[x$k]) <= .01){
      counts[x$k] <- round(x$n.I[x$k])
    } else if (roundUpFinal) counts[x$k] <- ceiling(x$n.I[x$k])
  } else {
    # Check if control size is close to integer multiple of ratio + 1
    if (abs(x$n.I[x$k] - round(x$n.I[x$k] / (ratio + 1)) * (ratio + 1)) <= .01) {
      counts[x$k] <- round(x$n.I[x$k] / (ratio + 1)) * (ratio + 1)
    # For non-survival designs round sample size based on randomization ratio
    }else if (roundUpFinal) {
      counts[x$k] <- ceiling(x$n.I[x$k] / (ratio + 1)) * (ratio + 1) # Round up for final count
    } else {
      counts[x$k] <- round(x$n.I[x$k] / (ratio + 1)) * (ratio + 1)
    }
  }
  # update bounds and counts from original design
  xi <- gsDesign(
    k = x$k, test.type = x$test.type, n.I = counts, maxn.IPlan = counts[x$k],
    alpha = x$alpha, beta = x$beta, astar = x$astar,
    delta = x$delta, delta1 = x$delta1, delta0 = x$delta0, endpoint = x$endpoint,
    sfu = x$upper$sf, sfupar = x$upper$param, sfl = x$lower$sf, sflpar = x$lower$param,
    lsTime = x$lsTime, usTime = x$usTime
  )
  if (max(abs(xi$n.I - counts)) > .01) warning("toInteger: check n.I input versus output")
  xi$n.I <- counts # ensure these are integers as they became real in gsDesign call
  # Non-binding futility designs have x$test.type either 4 or 6
  if (x$test.type %in% c(4, 6)) {
    xi$falseposnb <- as.vector(gsprob(0, xi$n.I, rep(-20, xi$k), xi$upper$bound, r = xi$r)$probhi)
  }
  if (inherits(x, "gsSurv") || x$nFixSurv > 0) {
    xi$hr0 <- x$hr0 # H0 hazard ratio
    xi$hr <- x$hr # H1 hazard ratio

    N <- rowSums(x$eNC + x$eNE)[x$k] # get input total sample size
    N_continuous <- N
    # Update sample size to integer
    N <- N / (ratio + 1)
    if (roundUpFinal) {
      N <- ceiling(N) * (ratio + 1)
    } else {
      N <- round(N, 0) * (ratio + 1)
    }
    # Update enrollment rates to achieve new sample size in same time
    inflateN <- N / N_continuous
    # Following is adapted from gsSurv() to construct gsSurv object
    xx <- nSurv(
      lambdaC = x$lambdaC, hr = x$hr, hr0 = x$hr0, eta = x$etaC, etaE = x$etaE,
      gamma = x$gamma * inflateN, R = x$R, S = x$S, T = x$T, minfup = x$minfup, ratio = x$ratio,
      alpha = x$alpha, beta = NULL, sided = 1, tol = x$tol
    )
    xx$tol <- x$tol
    z <- gsnSurv(xx, xi$n.I[xi$k])
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
    xi$ratio <- x$ratio
    xi$lambdaC <- z$lambdaC
    xi$etaC <- z$etaC
    xi$etaE <- z$etaE
    xi$variable <- x$variable
    xi$tol <- x$tol
    class(xi) <- c("gsSurv", "gsDesign")
    nameR <- nameperiod(cumsum(xi$R))
    stratnames <- paste("Stratum", seq_len(ncol(xi$lambdaC)))
    if (is.null(xi$S)) {
      nameS <- "0-Inf"
    } else {
      nameS <- nameperiod(cumsum(c(xi$S, Inf)))
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

is.wholenumber <- function(x, tol = .Machine$double.eps^0.5) abs(x - round(x)) < tol

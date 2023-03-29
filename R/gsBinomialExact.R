utils::globalVariables(c("N", "EN", "Bound", "rr", "Percent", "Outcome"))

# gsBinomialExact roxy [sinew] ----
#' @title One-Sample Binomial Routines
#' @description
#' \code{gsBinomialExact} computes power/Type I error and expected sample size
#' for a group sequential design in a single-arm trial with a binary outcome.
#' This can also be used to compare event rates in two-arm studies. The print
#' function has been extended using \code{print.gsBinomialExact} to print
#' \code{gsBinomialExact} objects. Similarly, a plot function has
#' been extended using \code{plot.gsBinomialExact} to plot
#' \code{gsBinomialExact} objects.
#'
#' \code{binomialSPRT} computes a truncated binomial sequential probability
#' ratio test (SPRT) which is a specific instance of an exact binomial group
#' sequential design for a single arm trial with a binary outcome.
#'
#' \code{gsBinomialPP} computes a truncated binomial (group) sequential design
#' based on predictive probability.
#'
#' \code{nBinomial1Sample} uses exact binomial calculations to compute power
#' and sample size for single arm binomial experiments.
#'
#' \code{gsBinomialExact} is based on the book "Group Sequential Methods with
#' Applications to Clinical Trials," Christopher Jennison and Bruce W.
#' Turnbull, Chapter 12, Section 12.1.2 Exact Calculations for Binary Data.
#' This computation is often used as an approximation for the distribution of
#' the number of events in one treatment group out of all events when the
#' probability of an event is small and sample size is large.
#'
#' An object of class \code{gsBinomialExact} is returned. On output, the values
#' of \code{theta} input to \code{gsBinomialExact} will be the parameter values
#' for which the boundary crossing probabilities and expected sample sizes are
#' computed.
#'
#' Note that a[1] equal to -1 lower bound at n.I[1] means 0 successes continues
#' at interim 1; a[2]==0 at interim 2 means 0 successes stops trial for
#' futility at 2nd analysis.  For final analysis, set a[k] equal to b[k]-1 to
#' incorporate all possibilities into non-positive trial; see example.
#'
#' The sequential probability ratio test (SPRT) is a sequential testing scheme
#' allowing testing after each observation. This likelihood ratio is used to
#' determine upper and lower cutoffs which are linear and parallel in the
#' number of responses as a function of sample size.  \code{binomialSPRT}
#' produces a variation the the SPRT that tests only within a range of sample
#' sizes. While the linear SPRT bounds are continuous, actual bounds are the
#' integer number of response at or beyond each linear bound for each sample
#' size where testing is performed. Because of the truncation and
#' discretization of the bounds, power and Type I error achieve will be lower
#' than the nominal levels specified by \code{alpha} and \code{beta} which can
#' be altered to produce desired values that are achieved by the planned sample
#' size. See also example that shows computation of Type I error when futility
#' bound is considered non-binding.
#'
#' Note that if the objective of a design is to demonstrate that a rate (e.g.,
#' failure rate) is lower than a certain level, two approaches can be taken.
#' First, 1 minus the failure rate is the success rate and this can be used for
#' planning. Second, the role of \code{beta} becomes to express Type I error
#' and \code{alpha} is used to express Type II error.
#'
#' Plots produced include boundary plots, expected sample size, response rate
#' at the boundary and power.
#'
#' \code{gsBinomial1Sample} uses exact binomial computations based on the base
#' R functions \code{qbinom()} and \code{pbinom()}. The tabular output may be
#' convenient for plotting. Note that input variables are largely not checked,
#' so the user is largely responsible for results; it is a good idea to do a
#' run with \code{outtype=3} to check that you have done things appropriately.
#' If \code{n} is not ordered (a bad idea) or not sequential (maybe OK), be
#' aware of possible consequences.
#' 
#' \code{nBinomial1Sample} is based on code from Marc Schwartz \email{marc_schwartz@@me.com}. 
#' The possible sample size vector \code{n} needs to be selected in such a fashion
#' that it covers the possible range of values that include the true minimum. 
#' NOTE: the one-sided evaluation of significance is more conservative than using the 2-sided exact test in \code{binom.test}.
#'
#' @param k Number of analyses planned, including interim and final.
#' @param theta Vector of possible underling binomial probabilities for a
#' single binomial sample.
#' @param n.I Sample size at analyses (increasing positive integers); vector of
#' length k.
#' @param a Number of "successes" required to cross lower bound cutoffs to
#' reject \code{p1} in favor of \code{p0} at each analysis; vector of length k;
#' -1 means no lower bound.
#' @param b Number of "successes" required to cross upper bound cutoffs for
#' rejecting \code{p0} in favor of \code{p1} at each analysis; vector of length
#' k.
#' @param p0 Lower of the two response (event) rates hypothesized.
#' @param p1 Higher of the two response (event) rates hypothesized.
#' @param alpha Nominal probability of rejecting response (event) rate
#' \code{p0} when it is true.
#' @param beta Nominal probability of rejecting response (event) rate \code{p1}
#' when it is true. If NULL, Type II error will be computed for all input values 
#' of \code{n} and output will be in a data frame.
#' @param minn Minimum sample size at which sequential testing begins.
#' @param maxn Maximum sample size.
#' @param x Item of class \code{gsBinomialExact} or \code{binomialSPRT} for
#' \code{print.gsBinomialExact}. Item of class \code{gsBinomialExact} for
#' \code{plot.gsBinomialExact}. Item of class \code{binomialSPRT} for item of
#' class \code{plot.binomialSPRT}.
#' @param plottype 1 produces a plot with counts of response at bounds (for
#' \code{binomialSPRT}, also produces linear SPRT bounds); 2 produces a plot
#' with power to reject null and alternate response rates as well as the
#' probability of not crossing a bound by the maximum sample size; 3 produces a
#' plot with the response rate at the boundary as a function of sample size
#' when the boundary is crossed; 6 produces a plot of the expected sample size
#' by the underlying event rate (this assumes there is no enrollment beyond the
#' sample size where the boundary is crossed).
#' @param n sample sizes to be considered for \code{nBinomial1Sample}. These
#' should be ordered from smallest to largest and be > 0.
#' @param outtype Operative when \code{beta != NULL}. \code{1} means routine
#' will return a single integer sample size while for \code{output=2}a data frame 
#' is returned (see Value); note that this not operative is \code{beta} is \code{NULL} 
#' in which case a data table is returned with Type II error and power for each input 
#' value of \code{n}.
#' @param conservative operative when \code{outtype=1} or \code{2} and
#' \code{beta != NULL}. Default \code{FALSE} selects minimum sample size for
#' which power is at least \code{1-beta}. When \code{conservative=TRUE}, the
#' minimum sample sample size for which power is at least \code{1-beta} and
#' there is no larger sample size in the input \code{n} where power is less
#' than \code{1-beta}.
#' @param \dots arguments passed through to \code{ggplot}.
#' @return \code{gsBinomialExact()} returns a list of class
#' \code{gsBinomialExact} and \code{gsProbability} (see example); when
#' displaying one of these objects, the default function to print is
#' \code{print.gsProbability()}.  The object returned from
#' \code{gsBinomialExact()} contains the following elements: \item{k}{As
#' input.} \item{theta}{As input.} \item{n.I}{As input.} \item{lower}{A list
#' containing two elements: \code{bound} is as input in \code{a} and
#' \code{prob} is a matrix of boundary crossing probabilities. Element
#' \code{i,j} contains the boundary crossing probability at analysis \code{i}
#' for the \code{j}-th element of \code{theta} input. All boundary crossing is
#' assumed to be binding for this computation; that is, the trial must stop if
#' a boundary is crossed.} \item{upper}{A list of the same form as \code{lower}
#' containing the upper bound and upper boundary crossing probabilities.}
#' \item{en}{A vector of the same length as \code{theta} containing expected
#' sample sizes for the trial design corresponding to each value in the vector
#' \code{theta}.}
#'
#' \code{binomialSPRT} produces an object of class \code{binomialSPRT} that is
#' an extension of the \code{gsBinomialExact} class. The values returned in
#' addition to those returned by \code{gsBinomialExact} are: \item{intercept}{A
#' vector of length 2 with the intercepts for the two SPRT bounds.}
#' \item{slope}{A scalar with the common slope of the SPRT bounds.}
#' \item{alpha}{As input. Note that this will exceed the actual Type I error
#' achieved by the design returned.} \item{beta}{As input. Note that this will
#' exceed the actual Type II error achieved by the design returned.}
#' \item{p0}{As input.} \item{p1}{As input.}
#'
#' \code{nBinomial1Sample} produces a data frame with power for each input value in \code{n} 
#' if \code{beta=NULL}. Otherwise, a sample size achieving the desired power is returned unless 
#' the minimum power for the values input in \code{n} is greater than or equal to the target or 
#' the maximum yields power less than the target, in which case an error message is shown. 
#' The input variable \code{outtype} has no effect if \code{beta=NULL}. 
#' Otherwise, \code{outtype=1} results in return of an integer sample size and \code{outtype=2} 
#' results in a data frame with one record which includes the desired sample size.
#' When a data frame is returned, the variables include: \item{p0}{Input null
#' hypothesis event (or response) rate.} \item{p1}{Input alternative hypothesis
#' (or response) rate; must be \code{> p0}.} \item{alpha}{Input Type I error.}
#' \item{beta}{Input Type II error except when input is \code{NULL} in which
#' case realized Type II error is computed.} \item{n}{sample size.} \item{b}{cutoff given \code{n} to control
#' Type I error; value is \code{NULL} if no such value exists.} \item{alphaR}{Type I error achieved for each 
#' output value of \code{n}; less than or equal to the input value \code{alpha}.} \item{Power}{Power achieved 
#' for each output value of \code{n}.}
#' 
#' @examples
#' library(ggplot2)
#' 
#' zz <- gsBinomialExact(
#'   k = 3, theta = seq(0, 1, 0.1), n.I = c(12, 24, 36),
#'   a = c(-1, 0, 11), b = c(5, 9, 12)
#' )
#' 
#' # let's see what class this is
#' class(zz)
#' 
#' # because of "gsProbability" class above, following is equivalent to
#' # \code{print.gsProbability(zz)}
#' zz
#' 
#' # also plot (see also plots below for \code{binomialSPRT})
#' # add lines using geom_line()
#' plot(zz) + 
#' ggplot2::geom_line()
#' 
#' # now for SPRT examples
#' x <- binomialSPRT(p0 = .05, p1 = .25, alpha = .1, beta = .2)
#' # boundary plot
#' plot(x)
#' # power plot
#' plot(x, plottype = 2)
#' # Response (event) rate at boundary
#' plot(x, plottype = 3)
#' # Expected sample size at boundary crossing or end of trial
#' plot(x, plottype = 6)
#' 
#' # sample size for single arm exact binomial
#' 
#' # plot of table of power by sample size
#' # note that outtype need no be specified if beta is NULL
#' nb1 <- nBinomial1Sample(p0 = 0.05, p1=0.2,alpha = 0.025, beta=NULL, n = 25:40)
#' nb1
#' library(scales)
#' ggplot2::ggplot(nb1, ggplot2::aes(x = n, y = Power)) + 
#' ggplot2::geom_line() + 
#' ggplot2::geom_point() + 
#' ggplot2::scale_y_continuous(labels = percent)
#' 
#' # simple call with same parameters to get minimum sample size yielding desired power
#' nBinomial1Sample(p0 = 0.05, p1 = 0.2, alpha = 0.025, beta = .2, n = 25:40)
#' 
#' # change to 'conservative' if you want all larger sample
#' # sizes to also provide adequate power
#' nBinomial1Sample(p0 = 0.05, p1 = 0.2, alpha = 0.025, beta = .2, n = 25:40, conservative = TRUE)
#' 
#' # print out more information for the selected derived sample size
#' nBinomial1Sample(p0 = 0.05, p1 = 0.2, alpha = 0.025, beta = .2, n = 25:40, conservative = TRUE,
#'  outtype = 2)
#' 
#' # what happens if input sample sizes not sufficient?
#' \dontrun{ 
#'   nBinomial1Sample(p0 = 0.05, p1 = 0.2, alpha = 0.025, beta = .2, n = 25:30)
#' }
#' @note The gsDesign technical manual is available at
#'   <https://keaven.github.io/gsd-tech-manual/>.
#' @author Jon Hartzel, Yevgen Tymofyeyev and Keaven Anderson \email{keaven_anderson@@merck.com}
#' @seealso \code{\link{gsProbability}}
#' @references Jennison C and Turnbull BW (2000), \emph{Group Sequential
#' Methods with Applications to Clinical Trials}. Boca Raton: Chapman and Hall.
#'
#' Code for nBinomial1Sample was based on code developed by
#' \email{marc_schwartz@@me.com}.
#' @keywords design
#' @export
#' @aliases print.gsBinomialExact
#' @rdname gsBinomialExact
# gsBinomialExact function [sinew] ----
gsBinomialExact <- function(k = 2, theta = c(.1, .2), n.I = c(50, 100), a = c(3, 7), b = c(20, 30)) {
  checkScalar(k, "integer", c(2, Inf), inclusion = c(TRUE, FALSE))
  checkVector(theta, "numeric", interval = 0:1, inclusion = c(TRUE, TRUE))
  checkVector(n.I, "integer", interval = c(1, Inf), inclusion = c(TRUE, FALSE))
  checkVector(a, "integer", interval = c(-Inf, Inf), inclusion = c(FALSE, FALSE))
  checkVector(b, "integer", interval = c(1, Inf), inclusion = c(FALSE, FALSE))
  ntheta <- as.integer(length(theta))
  theta <- as.double(theta)
  if (k != length(n.I) || k != length(a) || k != length(b)) {
    stop("Lengths of n.I, a, and b must equal k on input")
  }
  m <- c(n.I[1], diff(n.I))
  if (min(m) < 1) stop("n.I must must contain an increasing sequence of positive integers")
  if (min(n.I - a) < 0) stop("Input a-vector must be less than n.I")
  if (min(b - a) <= 0) stop("Input b-vector must be strictly greater than a")
  if (min(diff(a)) < 0) stop("a must contain a non-decreasing sequence of integers")
  if (min(diff(b)) < 0) stop("b must contain a non-decreasing sequence of integers")
  if (min(diff(n.I - b)) < 0) stop("n.I - b must be non-decreasing")

  plo <- matrix(nrow = k, ncol = ntheta)
  rownames(plo) <- paste(rep("Analysis ", k), 1:k)
  colnames(plo) <- theta
  phi <- plo
  en <- numeric(ntheta)

  for (h in 1:length(theta))
  {
    p <- theta[h]

    ### c.mat is the recursive function defined in (12.5)
    ### plo and phi are the probabilities of crossing the lower and upper boundaries defined in (12.6)
    c.mat <- matrix(0, ncol = k, nrow = n.I[k] + 1)
    for (i in 1:k)
    {
      if (i == 1) {
        c.mat[, 1] <- stats::dbinom(0:n.I[k], m[1], p)
      }
      else {
        no.stop <- (a[i - 1] + 1):(b[i - 1] - 1)
        no.stop.mat <- matrix(no.stop, byrow = T, nrow = n.I[k] + 1, ncol = length(no.stop))
        succ.mat <- matrix(0:n.I[k], byrow = F, ncol = length(no.stop), nrow = n.I[k] + 1)
        bin.mat <- matrix(stats::dbinom(succ.mat - no.stop.mat, m[i], p), byrow = F, ncol = length(no.stop), nrow = n.I[k] + 1)
        c.mat[, i] <- bin.mat %*% c.mat[no.stop + 1, (i - 1)]
      }
      plo[i, h] <- sum(c.mat[(0:n.I[k]) <= a[i], i])
      phi[i, h] <- sum(c.mat[(0:n.I[k]) >= b[i], i])
    }
  }

  powr <- rep(1, k) %*% phi
  futile <- rep(1, k) %*% plo
  en <- as.vector(n.I %*% (plo + phi) + n.I[k] * (t(rep(1, ntheta)) - powr - futile))

  x <- list(
    k = k, theta = theta, n.I = n.I,
    lower = list(bound = a, prob = plo),
    upper = list(bound = b, prob = phi), en = en
  )

  class(x) <- c("gsBinomialExact", "gsProbability")
  return(x)
}

# see http://theriac.org/DeskReference/viewDocument.php?id=65&SectionsList=3

# binomialSPRT roxy [sinew] ----
#' @rdname gsBinomialExact
#' @export
# binomialSPRT function [sinew] ----
binomialSPRT <- function(p0 = .05, p1 = .25, alpha = .1, beta = .15, minn = 10, maxn = 35) {
  lnA <- log((1 - beta) / alpha)
  lnB <- log(beta / (1 - alpha))
  a <- log((1 - p1) / (1 - p0))
  b <- log(p1 / p0) - a
  slope <- -a / b
  intercept <- c(lnA, lnB) / b
  upper <- ceiling(slope * (minn:maxn) + intercept[1])
  lower <- floor(slope * (minn:maxn) + intercept[2])
  lower[lower < -1] <- -1
  indx <- (minn:maxn >= upper) | (lower >= 0)
  # compute exact boundary crossing probabilities
  y <- gsBinomialExact(
    k = sum(indx), n.I = (minn:maxn)[indx],
    theta = c(p0, p1), a = lower[indx], b = upper[indx]
  )
  y$intercept <- intercept
  y$slope <- slope
  y$alpha <- alpha
  y$beta <- beta
  y$p0 <- p0
  y$p1 <- p1
  class(y) <- c("binomialSPRT", "gsBinomialExact", "gsProbability")
  return(y)
}

# plot.gsBinomialExact roxy [sinew] ----
#' @rdname gsBinomialExact
#' @export
#' @importFrom ggplot2 ggplot aes geom_line ylab geom_point xlab
#' @importFrom rlang !! sym
# plot.gsBinomialExact function [sinew] ----
plot.gsBinomialExact <- function(x, plottype = 1, ...) {
  if (plottype == 6) {
    theta <- (max(x$theta) - min(x$theta)) * (0:50) / 50 + min(x$theta)
    y <- gsBinomialExact(k = x$k, theta = theta, n.I = x$n.I, a = x$lower$bound, b = x$upper$bound)
    xx <- data.frame(p = theta, EN = y$en)
    p <- ggplot2::ggplot(data = xx, ggplot2::aes(x = p, y = !!rlang::sym('EN'))) + ggplot2::geom_line() + ggplot2::ylab("Expected sample size")
  } else if (plottype == 3) {
    xx <- data.frame(N = x$n.I, p = x$upper$bound / x$n.I, Bound = "Upper")
    xx <- rbind(xx, data.frame(N = x$n.I, p = x$lower$bound / x$n.I, Bound = "Lower"))
    p <- ggplot2::ggplot(data = xx, ggplot2::aes(x = !!rlang::sym('N'), y = p, group = !!rlang::sym('Bound'))) +
      ggplot2::geom_point() +
      ggplot2::ylab("Rate at bound")
  } else if (plottype == 2) {
    theta <- (max(x$theta) - min(x$theta)) * (0:50) / 50 + min(x$theta)
    # compute exact boundary crossing probabilities
    y <- gsBinomialExact(
      k = x$k, n.I = x$n.I,
      theta = theta, a = x$lower$bound, b = x$upper$bound
    )
    # compute probability of crossing upper bound for each theta
    Power <- data.frame(
      rr = theta,
      Percent = 100 * as.vector(matrix(1, ncol = length(y$n.I), nrow = 1) %*%
        y$upper$prob),
      Outcome = "Reject H0"
    )
    # compute probability of crossing lower bound
    futility <- data.frame(
      rr = theta,
      Percent = 100 * as.vector(matrix(1, ncol = length(y$n.I), nrow = 1) %*%
        y$lower$prob),
      Outcome = "Reject H1"
    )
    # probability of no boundary crossing
    indeterminate <- data.frame(
      rr = theta, Percent = 100 - Power$Percent - futility$Percent,
      Outcome = "Indeterminate"
    )
    # combine and plot
    outcome <- rbind(Power, futility, indeterminate)
    p <- ggplot2::ggplot(data = outcome, ggplot2::aes(x = !!rlang::sym('rr'), y = !!rlang::sym('Percent'), lty = !!rlang::sym('Outcome'))) +
      ggplot2::geom_line() +
      ggplot2::xlab("Underlying response rate")
  } else {
    xx <- data.frame(N = x$n.I, x = x$upper$bound, Bound = "Upper")
    xx <- rbind(xx, data.frame(N = x$n.I, x = x$lower$bound, Bound = "Lower"))
    p <- ggplot2::ggplot(data = xx, ggplot2::aes(x = !!rlang::sym('N'), y = x, group = !!rlang::sym('Bound'))) +
      ggplot2::geom_point() +
      ggplot2::ylab("Number of responses")
  }
  return(p)
}


#' @importFrom ggplot2 geom_abline
#' @rdname gsBinomialExact
plot.binomialSPRT <- function(x, plottype = 1, ...) {
  p <- plot.gsBinomialExact(x, plottype = plottype, ...)
  if (plottype == 1) {
    p <- p + ggplot2::geom_abline(
      intercept = x$intercept[1],
      slope = x$slope
    ) +
      ggplot2::geom_abline(
        intercept = x$intercept[2],
        slope = x$slope
      )
  }
  return(p)
}

# @title predictive probability bound
# binomialPP roxy [sinew] ----
#' @importFrom stats pbeta
# binomialPP function [sinew] ----
binomialPP <- function(a = .2, b = .8, theta = c(.2, .4), p1 = .4, PP = c(.025, .95), nIA) {
  # initiate bounds outside of range of possibility
  upper <- nIA + 1
  lower <- rep(-1, length(nIA))
  j <- 1
  # set bounds for each analysis sample size specified
  for (i in nIA) {
    q <- 0:i
    # compute posterior probability for value > p1
    # for each possible outcome at analysis i
    post <- stats::pbeta(p1, a + q, b + i - q, lower.tail = F)
    # set upper bound where posterior probability is > PP[2]
    # that response rate is > p1
    upper[j] <- sum(post < PP[2])
    # set lower bound were posterior probability is <= PP[1]
    # that response rate is < p1
    lower[j] <- sum(post <= PP[1])
    j <- j + 1
  }
  # compute boundary crossing probabilities under
  # response rates input in theta
  y <- gsBinomialExact(
    k = length(nIA), n.I = nIA,
    theta = theta, a = lower, b = upper
  )
  # add beta prior parameters to return value
  y$abeta <- a
  y$bbeta <- b
  # add input predictive probability bounds to return value
  y$PP <- PP
  # define class for output
  class(y) <- c("binomialPP", "gsBinomialExact", "gsProbability")
  return(y)
}

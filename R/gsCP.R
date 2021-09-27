# gsCP roxy [sinew] ----
#' @title Conditional and Predictive Power, Overall and Conditional Probability of Success
#' @description  \code{gsCP()} computes conditional boundary crossing probabilities at future
#' planned analyses for a given group sequential design assuming an interim
#' z-statistic at a specified interim analysis. While \code{gsCP()} is designed
#' toward computing conditional power for a variety of underlying parameter
#' values, \code{\link{condPower}} is built to compute conditional power for a
#' variety of interim test statistic values which is useful for sample size
#' adaptation (see \code{\link{ssrCP}}). \code{gsPP()} averages conditional
#' power across a posterior distribution to compute predictive power.
#' \code{gsPI()} computes Bayesian prediction intervals for future analyses
#' corresponding to results produced by \code{gsPP()}.  \code{gsPosterior()}
#' computes the posterior density for the group sequential design parameter of
#' interest given a prior density and an interim outcome that is exact or in an
#' interval. \code{gsPOS()} computes the probability of success for a trial
#' using a prior distribution to average power over a set of \code{theta}
#' values of interest. \code{gsCPOS()} assumes no boundary has been crossed
#' before and including an interim analysis of interest, and computes the
#' probability of success based on this event. Note that \code{gsCP()} and
#' \code{gsPP()} take only the interim test statistic into account in computing
#' conditional probabilities, while \code{gsCPOS()} conditions on not crossing
#' any bound through a specified interim analysis.
#'
#' See Conditional power section of manual for further clarification. See also
#' Muller and Schaffer (2001) for background theory.
#'
#' For \code{gsPP()}, \code{gsPI()}, \code{gsPOS()} and \code{gsCPOS()}, the
#' prior distribution for the standardized parameter \code{theta} () for a
#' group sequential design specified through a gsDesign object is specified
#' through the arguments \code{theta} and \code{wgts}. This can be a discrete
#' or a continuous probability density function. For a discrete function,
#' generally all weights would be 1. For a continuous density, the \code{wgts}
#' would contain integration grid weights, such as those provided by
#' \link{normalGrid}.
#'
#' For \code{gsPosterior}, a prior distribution in \code{prior} must be
#' composed of the vectors \code{z} \code{density}.  The vector \code{z}
#' contains points where the prior is evaluated and \code{density} the
#' corresponding density or, for a discrete distribution, the probabilities of
#' each point in \code{z}. Densities may be supplied as from
#' \code{normalGrid()} where grid weights for numerical integration are
#' supplied in \code{gridwgts}. If \code{gridwgts} are not supplied, they are
#' defaulted to 1 (equal weighting). To ensure a proper prior distribution, you
#' must have \code{sum(gridwgts * density)} equal to 1; this is NOT checked,
#' however.
#' @param x An object of type \code{gsDesign} or \code{gsProbability}
#' @param theta a vector with \eqn{\theta}{theta} value(s) at which conditional
#' power is to be computed; for \code{gsCP()} if \code{NULL}, an estimated
#' value of \eqn{\theta}{theta} based on the interim test statistic
#' (\code{zi/sqrt(x$n.I[i])}) as well as at \code{x$theta} is computed. For
#' \code{gsPosterior}, this may be a scalar or an interval; for \code{gsPP} and
#' \code{gsCP}, this must be a scalar.
#' @param wgts Weights to be used with grid points in \code{theta}. Length can
#' be one if weights are equal, otherwise should be the same length as
#' \code{theta}. Values should be positive, but do not need to sum to 1.
#' @param i analysis at which interim z-value is given; must be from 1 to
#' \code{x$k-1}
#' @param prior provides a prior distribution in the form produced by
#' \code{\link{normalGrid}}
#' @param zi interim z-value at analysis i (scalar)
#' @param j specific analysis for which prediction is being made; must be
#' \code{>i} and no more than \code{x$k}
#' @param r Integer value controlling grid for numerical integration as in
#' Jennison and Turnbull (2000); default is 18, range is 1 to 80.  Larger
#' values provide larger number of grid points and greater accuracy.  Normally
#' \code{r} will not be changed by the user.
#' @param total The default of \code{total=TRUE} produces the combined
#' probability for all planned analyses after the interim analysis specified in
#' \code{i}. Otherwise, information on each analysis is provided separately.
#' @param level The level to be used for Bayes credible intervals (which
#' approach confidence intervals for vague priors). The default
#' \code{level=.95} corresponds to a 95\% credible interval. \code{level=0}
#' provides a point estimate rather than an interval.
#' @return \code{gsCP()} returns an object of the class \code{gsProbability}.
#' Based on the input design and the interim test statistic, the output
#' gsDesign object has bounds for test statistics computed based on solely on
#' observations after interim \code{i}.  Boundary crossing probabilities are
#' computed for the input \eqn{\theta}{theta} values. See manual and examples.
#'
#' \code{gsPP()} if total==TRUE, returns a real value indicating the predictive
#' power of the trial conditional on the interim test statistic \code{zi} at
#' analysis \code{i}; otherwise returns vector with predictive power for each
#' future planned analysis.
#'
#' \code{gsPI()} returns an interval (or point estimate if \code{level=0})
#' indicating 100\code{level}\% credible interval for the z-statistic at
#' analysis \code{j} conditional on the z-statistic at analysis \code{i<j}.
#' The interval does not consider intervending interim analyses. The
#' probability estimate is based on the predictive distribution used for
#' \code{gsPP()} and requires a prior distribution for the group sequential
#' parameter \code{theta} specified in \code{theta} and \code{wgts}.
#'
#' \code{gsPosterior()} returns a posterior distribution containing the the
#' vector \code{z} input in \code{prior$z}, the posterior density in
#' \code{density}, grid weights for integrating the posterior density as input
#' in \code{prior$gridwgts} or defaulted to a vector of ones, and the product
#' of the output values in \code{density} and \code{gridwgts} in \code{wgts}.
#'
#' \code{gsPOS()} returns a real value indicating the probability of a positive
#' study weighted by the prior distribution input for \code{theta}.
#'
#' \code{gsCPOS()} returns a real value indicating the probability of a
#' positive study weighted by the posterior distribution derived from the
#' interim test statistic and the prior distribution input for \code{theta}
#' conditional on an interim test statistic.
#' @examples
#' library(ggplot2)
#' # set up a group sequential design
#' x <- gsDesign(k = 5)
#' x
#' 
#' # set up a prior distribution for the treatment effect
#' # that is normal with mean .75*x$delta and standard deviation x$delta/2
#' mu0 <- .75 * x$delta
#' sigma0 <- x$delta / 2
#' prior <- normalGrid(mu = mu0, sigma = sigma0)
#' 
#' # compute POS for the design given the above prior distribution for theta
#' gsPOS(x = x, theta = prior$z, wgts = prior$wgts)
#' 
#' # assume POS should only count cases in prior where theta >= x$delta/2
#' gsPOS(x = x, theta = prior$z, wgts = prior$wgts * (prior$z >= x$delta / 2))
#' 
#' # assuming a z-value at lower bound at analysis 2, what are conditional
#' # boundary crossing probabilities for future analyses
#' # assuming theta values from x as well as a value based on the interim
#' # observed z
#' CP <- gsCP(x, i = 2, zi = x$lower$bound[2])
#' CP
#' 
#' # summing values for crossing future upper bounds gives overall
#' # conditional power for each theta value
#' CP$theta
#' t(CP$upper$prob) %*% c(1, 1, 1)
#' 
#' # compute predictive probability based on above assumptions
#' gsPP(x, i = 2, zi = x$lower$bound[2], theta = prior$z, wgts = prior$wgts)
#' 
#' # if it is known that boundary not crossed at interim 2, use
#' # gsCPOS to compute conditional POS based on this
#' gsCPOS(x = x, i = 2, theta = prior$z, wgts = prior$wgts)
#' 
#' # 2-stage example to compare results to direct computation
#' x <- gsDesign(k = 2)
#' z1 <- 0.5
#' n1 <- x$n.I[1]
#' n2 <- x$n.I[2] - x$n.I[1]
#' thetahat <- z1 / sqrt(n1)
#' theta <- c(thetahat, 0, x$delta)
#' 
#' # conditional power direct computation - comparison w gsCP
#' pnorm((n2 * theta + z1 * sqrt(n1) - x$upper$bound[2] * sqrt(n1 + n2)) / sqrt(n2))
#' 
#' gsCP(x = x, zi = z1, i = 1)$upper$prob
#' 
#' # predictive power direct computation - comparison w gsPP
#' # use same prior as above
#' mu0 <- .75 * x$delta * sqrt(x$n.I[2])
#' sigma2 <- (.5 * x$delta)^2 * x$n.I[2]
#' prior <- normalGrid(mu = .75 * x$delta, sigma = x$delta / 2)
#' gsPP(x = x, zi = z1, i = 1, theta = prior$z, wgts = prior$wgts)
#' t <- .5
#' z1 <- .5
#' b <- z1 * sqrt(t)
#' # direct from Proschan, Lan and Wittes eqn 3.10
#' # adjusted drift at n.I[2]
#' pnorm(((b - x$upper$bound[2]) * (1 + t * sigma2) +
#'   (1 - t) * (mu0 + b * sigma2)) /
#'   sqrt((1 - t) * (1 + sigma2) * (1 + t * sigma2)))
#' 
#' # plot prior then posterior distribution for unblinded analysis with i=1, zi=1
#' xp <- gsPosterior(x = x, i = 1, zi = 1, prior = prior)
#' plot(x = xp$z, y = xp$density, type = "l", col = 2, xlab = expression(theta), ylab = "Density")
#' points(x = x$z, y = x$density, col = 1)
#' 
#' # add posterior plot assuming only knowlede that interim bound has
#' # not been crossed at interim 1
#' xpb <- gsPosterior(x = x, i = 1, zi = 1, prior = prior)
#' lines(x = xpb$z, y = xpb$density, col = 4)
#' 
#' # prediction interval based in interim 1 results
#' # start with point estimate, followed by 90% prediction interval
#' gsPI(x = x, i = 1, zi = z1, j = 2, theta = prior$z, wgts = prior$wgts, level = 0)
#' gsPI(x = x, i = 1, zi = z1, j = 2, theta = prior$z, wgts = prior$wgts, level = .9)
#' @note The manual is not linked to this help file, but is available in
#' library/gsdesign/doc/gsDesignManual.pdf in the directory where R is
#' installed.
#' @author Keaven Anderson \email{keaven\_anderson@@merck.}
#' @seealso \code{\link{normalGrid}}, \code{\link{gsDesign}},
#' \code{\link{gsProbability}}, \code{\link{gsBoundCP}}, \code{\link{ssrCP}},
#' \code{\link{condPower}}
#' @references Jennison C and Turnbull BW (2000), \emph{Group Sequential
#' Methods with Applications to Clinical Trials}. Boca Raton: Chapman and Hall.
#'
#' Proschan, Michael A., Lan, KK Gordon and Wittes, Janet Turk (2006),
#' \emph{Statistical Monitoring of Clinical Trials}. NY: Springer.
#'
#' Muller, Hans-Helge and Schaffer, Helmut (2001), Adaptive group sequential
#' designs for clinical trials: combining the advantages of adaptive and
#' classical group sequential approaches. \emph{Biometrics};57:886-891.
#' @keywords design
#' @export
#' @rdname gsCP
# gsCP function [sinew] ----
gsCP <- function(x, theta = NULL, i = 1, zi = 0, r = 18) {
  # conditional power for remaining trial is returned (including each interim)
  # as a gsProbability object
  # Inputs: interim theta value and which interim is considered

  if (!(methods::is(x, "gsProbability") || methods::is(x, "gsDesign"))) {
    stop("gsCP must be called with class of x either gsProbability or gsDesign")
  }

  if (i < 1 || i >= x$k) {
    stop("gsCP must be called with i from 1 to x$k-1")
  }

  test.type <- ifelse(methods::is(x, "gsProbability"), 3, x$test.type)

  if (!(is.numeric(zi) &  length(zi) == 1)) stop("zi must be single, real value")

  if (is.null(theta)) theta <- c(zi/sqrt(x$n.I[i]), 0, x$delta)

  knew <- x$k - i
  Inew <- x$n.I[(i + 1):x$k] - x$n.I[i]

  # update KA, 20160213
  if (is.null(x$timing)) x$timing <- x$n.I/x$n.I[x$k]
  bnew <- (x$upper$bound[(i+1):x$k]*sqrt(x$timing[(i+1):x$k]) - zi*sqrt(x$timing[i]))/
    sqrt(x$timing[(i+1):x$k]-x$timing[i])
  # while equivalent, above code is simpler expression of what is in write-up    
  #    bnew <- (x$upper$bound[(i+1):x$k] - zi * sqrt(x$n.I[i] / x$n.I[(i+1):x$k]))/ 
  #            sqrt(Inew/x$n.I[(i+1):x$k])
  # end update
  
  if (test.type > 1) {
    # update KA, 20160213
    anew <- (x$lower$bound[(i+1):x$k]*sqrt(x$timing[(i+1):x$k]) - zi*sqrt(x$timing[i]))/
      sqrt(x$timing[(i+1):x$k]-x$timing[i])
    # while equivalent, above code is simpler expression of what is in write-up    
    #      anew <- (x$lower$bound[(i+1):x$k]-zi*sqrt(x$n.I[i]/x$n.I[(i+1):x$k]))/
    #            sqrt(Inew/x$n.I[(i+1):x$k])        
    # end update
  }
  else {
    anew <- rep(-20, knew)
  }

  gsProbability(k = knew, theta = theta, n.I = Inew, a = anew, b = bnew, r = r, overrun = 0)
}

# gsPP roxy [sinew] ----
#' @export
#' @rdname gsCP
# gsPP function [sinew] ----
gsPP <- function(x, i = 1, zi = 0, theta = c(0, 3), wgts = c(.5, .5), r = 18, total = TRUE) {
  if (!(methods::is(x, "gsProbability") || methods::is(x, "gsDesign"))) {
    stop("gsPP: class(x) must be gsProbability or gsDesign")
  }
  test.type <- ifelse(methods::is(x, "gsProbability"), 3, x$test.type)
  checkScalar(i, "integer", c(1, x$k - 1))
  checkScalar(zi, "numeric", c(-Inf, Inf), c(FALSE, FALSE))
  checkVector(wgts, "numeric", c(0, Inf), c(TRUE, FALSE))
  checkVector(theta, "numeric", c(-Inf, Inf), c(FALSE, FALSE))
  checkLengths(theta, wgts)
  checkScalar(r, "integer", c(1, 80))
  if (!(is.numeric(zi) &  length(zi) == 1)) stop("zi must be single, real value")
  cp <- gsCP(x = x, i = i, theta = theta, zi = zi, r = r)
  gsDen <- stats::dnorm(zi, mean = sqrt(x$n.I[i]) * theta) * wgts
  pp <- cp$upper$prob %*% gsDen / sum(gsDen)
  if (total) {
    return(sum(pp))
  } else {
    return(pp)
  }
}

# gsPI roxy [sinew] ----
#' @export
#' @rdname gsCP
# gsPI function [sinew] ----
gsPI <- function(x, i = 1, zi = 0, j = 2, level = .95, theta = c(0, 3), wgts = c(.5, .5)) {
  if (!(methods::is(x, "gsProbability") || methods::is(x, "gsDesign"))) {
    stop("gsPI: class(x) must be gsProbability or gsDesign")
  }
  checkScalar(i, "integer", c(1, x$k - 1))
  checkScalar(j, "integer", c(i + 1, x$k))
  checkScalar(zi, "numeric", c(-Inf, Inf), c(FALSE, FALSE))
  checkVector(wgts, "numeric", c(0, Inf), c(TRUE, FALSE))
  checkVector(theta, "numeric", c(-Inf, Inf), c(FALSE, FALSE))
  checkLengths(theta, wgts)
  post <- stats::dnorm(zi, mean = sqrt(x$n.I[i]) * theta) * wgts
  post <- post / sum(post)
  lower <- stats::uniroot(
    f = postfn, interval = c(-20, 20), PP = 1 - (1 - level) / 2,
    d = x, i = i, zi = zi, j = j, theta = theta, wgts = post
  )$root
  if (level == 0) return(lower)
  upper <- stats::uniroot(
    f = postfn, interval = c(-20, 20), PP = (1 - level) / 2,
    d = x, i = i, zi = zi, j = j, theta = theta, wgts = post
  )$root
  c(lower, upper)
}



# gsBoundCP roxy [sinew] ----
#' @title Conditional Power at Interim Boundaries
#' @description  \code{gsBoundCP()} computes the total probability of crossing future upper
#' bounds given an interim test statistic at an interim bound. For each interim
#' boundary, assumes an interim test statistic at the boundary and computes the
#' probability of crossing any of the later upper boundaries.
#'
#' See Conditional power section of manual for further clarification. See also
#' Muller and Schaffer (2001) for background theory.
#'
#' @param x An object of type \code{gsDesign} or \code{gsProbability}
#' @param theta if \code{"thetahat"} and \code{class(x)!="gsDesign"},
#' conditional power computations for each boundary value are computed using
#' estimated treatment effect assuming a test statistic at that boundary
#' (\code{zi/sqrt(x$n.I[i])} at analysis \code{i}, interim test statistic
#' \code{zi} and interim sample size/statistical information of
#' \code{x$n.I[i]}). Otherwise, conditional power is computed assuming the
#' input scalar value \code{theta}.
#' @param r Integer value controlling grid for numerical integration as in
#' Jennison and Turnbull (2000); default is 18, range is 1 to 80.  Larger
#' values provide larger number of grid points and greater accuracy.  Normally
#' \code{r} will not be changed by the user.
#' @return A list containing two vectors, \code{CPlo} and \code{CPhi}.
#' \item{CPlo}{A vector of length \code{x$k-1} with conditional powers of
#' crossing upper bounds given interim test statistics at each lower bound}
#' \item{CPhi}{A vector of length \code{x$k-1} with conditional powers of
#' crossing upper bounds given interim test statistics at each upper bound.}
#' @examples
#' 
#' # set up a group sequential design
#' x <- gsDesign(k = 5)
#' x
#' 
#' # compute conditional power based on interim treatment effects
#' gsBoundCP(x)
#' 
#' # compute conditional power based on original x$delta
#' gsBoundCP(x, theta = x$delta)
#' @note The manual is not linked to this help file, but is available in
#' library/gsdesign/doc/gsDesignManual.pdf in the directory where R is
#' installed.
#' @author Keaven Anderson \email{keaven\_anderson@@merck.}
#' @seealso \code{\link{gsDesign}}, \code{\link{gsProbability}},
#' \code{\link{gsCP}}
#' @references Jennison C and Turnbull BW (2000), \emph{Group Sequential
#' Methods with Applications to Clinical Trials}. Boca Raton: Chapman and Hall.
#'
#' Muller, Hans-Helge and Schaffer, Helmut (2001), Adaptive group sequential
#' designs for clinical trials: combining the advantages of adaptive and
#' classical group sequential approaches. \emph{Biometrics};57:886-891.
#' @keywords design
#' @export
#' @rdname gsBoundCP
# gsBoundCP function [sinew] ----
gsBoundCP <- function(x, theta = "thetahat", r = 18) {
  if (!(methods::is(x, "gsProbability") || methods::is(x, "gsDesign"))) {
    stop("gsPI: class(x) must be gsProbability or gsDesign")
  }
  checkScalar(r, "integer", c(1, 70))
  if (!is.character(theta)) {
    checkVector(theta, "numeric", c(-Inf, Inf), c(FALSE, FALSE))
  }

  len <- x$k - 1
  test.type <- ifelse(methods::is(x, "gsProbability"), 3, x$test.type)

  if (theta != "thetahat") {
    thetahi <- rep(theta, len)
    if (test.type > 1) thetalow <- thetahi
  } else {
    if (test.type > 1) thetalow <- x$lower$bound[1:len] / sqrt(x$n.I[1:len])
    thetahi <- x$upper$bound[1:len] / sqrt(x$n.I[1:len])
  }
  CPhi <- rep(0, len)

  if (test.type > 1) CPlo <- CPhi

  for (i in 1:len)
  {
    if (test.type > 1) {
      xlow <- gsCP(x, thetalow[i], i, x$lower$bound[i])
      CPlo[i] <- sum(xlow$upper$prob)
    }
    xhi <- gsCP(x, thetahi[i], i, x$upper$bound[i])
    CPhi[i] <- sum(xhi$upper$prob)
  }

  if (test.type > 1) cbind(CPlo, CPhi) else CPhi
}

# gsPosterior roxy [sinew] ----
#' @rdname gsCP
#' @export
#' @importFrom methods is
# gsPosterior function [sinew] ----
gsPosterior <- function(x = gsDesign(), i = 1, zi = NULL, prior = normalGrid(), r = 18) {
  if (is.null(prior$gridwgts)) prior$gridwgts <- rep(1, length(prior$z))
  checkLengths(prior$z, prior$density, prior$gridwgts)
  checkVector(prior$gridwgts, "numeric", c(0, Inf), c(TRUE, FALSE))
  checkVector(prior$density, "numeric", c(0, Inf), c(TRUE, FALSE))
  checkVector(prior$z, "numeric", c(-Inf, Inf), c(FALSE, FALSE))
  if (!(methods::is(x, "gsProbability") || methods::is(x, "gsDesign"))) {
    stop("gsPosterior: x must have class gsDesign or gsProbability")
  }
  test.type <- ifelse(methods::is(x, "gsProbability"), 3, x$test.type)
  checkScalar(i, "integer", c(1, x$k - 1))
  if (is.null(zi)) {
    zi <- c(x$lower$bound[i], x$upper$bound[i])
  } else {
    checkVector(zi, "numeric", c(-Inf, Inf), c(FALSE, FALSE))
  }
  if (length(zi) > 2) stop("gsPosterior: length of zi must be 1 or 2")
  if (length(zi) > 1) {
    if (zi[2] <= zi[1]) {
      stop("gsPosterior: when length of zi is 2, must have zi[2] > zi[1]")
    }
    xa <- x
    if (zi[1] != x$lower$bound[i] || zi[2] != x$upper$bound[i]) {
      xa$lower$bound[i] <- zi[1]
      xa$upper$bound[i] <- zi[2]
    }
    xa <- gsProbability(d = xa, theta = prior$z, r = r)
    prob <- xa$lower$prob + xa$upper$prob
    for (j in 1:ncol(prob)) prob[, j] <- 1 - cumsum(prob[, j])
    marg <- sum(prob[i, ] * prior$gridwgts * prior$density)
    posterior <- prob[i, ] * prior$density
  }
  else {
    y <- gsZ(x, theta = prior$z, i = i, zi = zi)
    marg <- sum(as.vector(y$density) * prior$gridwgts * prior$density)
    posterior <- as.vector(y$density) * prior$density
  }
  posterior <- posterior / marg
  return(list(
    z = prior$z, density = posterior,
    gridwgts = prior$gridwgts, wgts = prior$gridwgts * posterior
  ))
}


# gsZ roxy [sinew] ----
#' @importFrom stats dnorm
# gsZ function [sinew] ----
gsZ <- function(x, theta, i, zi) {
  mu <- sqrt(x$n.I[i]) * theta
  xx <- matrix(0, nrow = length(zi), ncol = length(theta))
  for (j in 1:length(theta)) xx[, j] <- stats::dnorm(zi - mu[j])
  list(zi = zi, theta = theta, density = xx)
}

# postfn roxy [sinew] ----
#' @importFrom stats pnorm
# postfn function [sinew] ----
postfn <- function(x, PP, d, i, zi, j, theta, wgts) {
  newmean <- (d$timing[j] - d$timing[i]) * theta * sqrt(d$n.I[d$k])
  newsd <- sqrt(d$timing[j] - d$timing[i])
  pprob <- stats::pnorm(x * sqrt(d$timing[j]) - zi * sqrt(d$timing[i]),
    mean = newmean,
    sd = newsd, lower.tail = FALSE
  )
  sum(pprob * wgts) - PP
}

# gsPOS roxy [sinew] ----
#' @export
#' @rdname gsCP
# gsPOS function [sinew] ----
gsPOS <- function(x, theta, wgts) {
  if (!methods::is(x, c("gsProbability", "gsDesign"))) {
    stop("x must have class gsProbability or gsDesign")
  }
  checkVector(theta, "numeric")
  checkVector(wgts, "numeric")
  checkLengths(theta, wgts)
  x <- gsProbability(theta = theta, d = x)
  one <- rep(1, x$k)
  as.double(one %*% x$upper$prob %*% wgts)
}

# gsCPOS roxy [sinew] ----
#' @export
#' @rdname gsCP
# gsCPOS function [sinew] ----
gsCPOS <- function(i, x, theta, wgts) {
  if (!methods::is(x, c("gsProbability", "gsDesign"))) {
    stop("x must have class gsProbability or gsDesign")
  }
  checkScalar(i, "integer", c(1, x$k), c(TRUE, FALSE))
  checkVector(theta, "numeric")
  checkVector(wgts, "numeric")
  checkLengths(theta, wgts)
  x <- gsProbability(theta = theta, d = x)
  v <- c(rep(1, i), rep(0, (x$k - i)))
  pAi <- 1 - as.double(v %*% (x$upper$prob + x$lower$prob) %*% wgts)
  v <- 1 - v
  pAiB <- as.double(v %*% x$upper$prob %*% wgts)
  pAiB / pAi
}

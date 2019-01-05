# varBinomial roxy [sinew] ----
#' 3.2: Testing, Confidence Intervals, Sample Size and Power for Comparing Two
#' Binomial Rates
#'
#' Support is provided for sample size estimation, power, testing, confidence
#' intervals and simulation for fixed sample size trials (that is, not group
#' sequential or adaptive) with two arms and binary outcomes.  Both superiority
#' and non-inferiority trials are considered. While all routines default to
#' comparisons of risk-difference, options to base computations on risk-ratio
#' and odds-ratio are also included.
#'
#' \code{nBinomial()} computes sample size or power using the method of
#' Farrington and Manning (1990) for a trial to test the difference between two
#' binomial event rates.  The routine can be used for a test of superiority or
#' non-inferiority. For a design that tests for superiority \code{nBinomial()}
#' is consistent with the method of Fleiss, Tytun, and Ury (but without the
#' continuity correction) to test for differences between event rates. This
#' routine is consistent with the Hmisc package routines \code{bsamsize} and
#' \code{bpower} for superiority designs. Vector arguments allow computing
#' sample sizes for multiple scenarios for comparative purposes.
#'
#' \code{testBinomial()} computes a Z- or Chi-square-statistic that compares
#' two binomial event rates using the method of Miettinen and Nurminen (1980).
#' This can be used for superiority or non-inferiority testing. Vector
#' arguments allow easy incorporation into simulation routines for fixed, group
#' sequential and adaptive designs.
#'
#' \code{ciBinomial()} computes confidence intervals for 1) the difference
#' between two rates, 2) the risk-ratio for two rates or 3) the odds-ratio for
#' two rates. This procedure provides inference that is consistent with
#' \code{testBinomial()} in that the confidence intervals are produced by
#' inverting the testing procedures in \code{testBinomial()}. The Type I error
#' \code{alpha} input to \code{ciBinomial} is always interpreted as 2-sided.
#'
#' \code{simBinomial()} performs simulations to estimate the power for a
#' Miettinen and Nurminen (1985) test comparing two binomial rates for
#' superiority or non-inferiority.  As noted in documentation for
#' \code{bpower.sim()} in the HMisc package, by using \code{testBinomial()} you
#' can see that the formulas without any continuity correction are quite
#' accurate.  In fact, Type I error for a continuity-corrected test is
#' significantly lower (Gordon and Watson, 1996) than the nominal rate.  Thus,
#' as a default no continuity corrections are performed.
#'
#' \code{varBinomial} computes blinded estimates of the variance of the
#' estimate of 1) event rate differences, 2) logarithm of the risk ratio, or 3)
#' logarithm of the odds ratio. This is intended for blinded sample size
#' re-estimation for comparative trials with a binary outcome.
#'
#' Testing is 2-sided when a Chi-square statistic is used and 1-sided when a
#' Z-statistic is used. Thus, these 2 options will produce substantially
#' different results, in general. For non-inferiority, 1-sided testing is
#' appropriate.
#'
#' You may wish to round sample sizes up using \code{ceiling()}.
#'
#' Farrington and Manning (1990) begin with event rates \code{p1} and \code{p2}
#' under the alternative hypothesis and a difference between these rates under
#' the null hypothesis, \code{delta0}. From these values, actual rates under
#' the null hypothesis are computed, which are labeled \code{p10} and
#' \code{p20} when \code{outtype=3}. The rates \code{p1} and \code{p2} are used
#' to compute a variance for a Z-test comparing rates under the alternative
#' hypothesis, while \code{p10} and \code{p20} are used under the null
#' hypothesis. This computational method is also used to estimate variances in
#' \code{varBinomial()} based on the overall event rate observed and the input
#' treatment difference specified in \code{delta0}.
#'
#' Sample size with \code{scale="Difference"} produces an error if
#' \code{p1-p2=delta0}.  Normally, the alternative hypothesis under
#' consideration would be \code{p1-p2-delta0}$>0$. However, the alternative can
#' have \code{p1-p2-delta0}$<0$.
#'
#' @aliases testBinomial ciBinomial nBinomial simBinomial varBinomial
#' @param p1 event rate in group 1 under the alternative hypothesis
#' @param p2 event rate in group 2 under the alternative hypothesis
#' @param alpha type I error; see \code{sided} below to distinguish between 1-
#' and 2-sided tests
#' @param beta type II error
#' @param delta0 A value of 0 (the default) always represents no difference
#' between treatment groups under the null hypothesis. \code{delta0} is
#' interpreted differently depending on the value of the parameter
#' \code{scale}.  If \code{scale="Difference"} (the default), \code{delta0} is
#' the difference in event rates under the null hypothesis (p10 - p20). If
#' \code{scale="RR"}, \code{delta0} is the logarithm of the relative risk of
#' event rates (p10 / p20) under the null hypothesis. If \code{scale="LNOR"},
#' \code{delta0} is the difference in natural logarithm of the odds-ratio under
#' the null hypothesis \code{log(p10 / (1 - p10)) - log(p20 / (1 - p20))}.
#' @param ratio sample size ratio for group 2 divided by group 1
#' @param sided 2 for 2-sided test, 1 for 1-sided test
#' @param outtype \code{nBinomial} only; 1 (default) returns total sample size;
#' 2 returns a data frame with sample size for each group (\code{n1, n2}; if
#' \code{n} is not input as \code{NULL}, power is returned in \code{Power}; 3
#' returns a data frame with total sample size (\code{n}), sample size in each
#' group (\code{n1, n2}), Type I error (\code{alpha}), 1 or 2 (\code{sided}, as
#' input), Type II error (\code{beta}), power (\code{Power}), null and
#' alternate hypothesis standard deviations (\code{sigma0, sigma1}), input
#' event rates (\code{p1, p2}), null hypothesis difference in treatment group
#' meands (\code{delta0}) and null hypothesis event rates (\code{p10, p20}).
#' @param n If power is to be computed in \code{nBinomial()}, input total trial
#' sample size in \code{n}; this may be a vector. This is also the sample size
#' in \code{varBinomial}, in which case the argument must be a scalar.
#' @param x Number of \dQuote{successes} in the combined control and
#' experimental groups.
#' @param x1 Number of \dQuote{successes} in the control group
#' @param x2 Number of \dQuote{successes} in the experimental group
#' @param n1 Number of observations in the control group
#' @param n2 Number of observations in the experimental group
#' @param chisq An indicator of whether or not a chi-square (as opposed to Z)
#' statistic is to be computed. If \code{delta0=0} (default), the difference in
#' event rates divided by its standard error under the null hypothesis is used.
#' Otherwise, a Miettinen and Nurminen chi-square statistic for a 2 x 2 table
#' is used.
#' @param adj With \code{adj=1}, the standard variance with a continuity
#' correction is used for a Miettinen and Nurminen test statistic This includes
#' a factor of \eqn{n / (n - 1)} where \eqn{n} is the total sample size. If
#' \code{adj} is not 1, this factor is not applied. The default is \code{adj=0}
#' since nominal Type I error is generally conservative with \code{adj=1}
#' (Gordon and Watson, 1996).
#' @param scale \dQuote{Difference}, \dQuote{RR}, \dQuote{OR}; see the
#' \code{scale} parameter documentation above and Details.  This is a scalar
#' argument.
#' @param nsim The number of simulations to be performed in
#' \code{simBinomial()}
#' @param tol Default should probably be used; this is used to deal with a
#' rounding issue in interim calculations
#' @return \code{testBinomial()} and \code{simBinomial()} each return a vector
#' of either Chi-square or Z test statistics.  These may be compared to an
#' appropriate cutoff point (e.g., \code{qnorm(.975)} for normal or
#' \code{qchisq(.95,1)} for chi-square).
#'
#' \code{ciBinomial()} returns a data frame with 1 row with a confidence
#' interval; variable names are \code{lower} and \code{upper}.
#'
#' \code{varBinomial()} returns a vector of (blinded) variance estimates of the
#' difference of event rates (\code{scale="Difference"}), logarithm of the
#' odds-ratio (\code{scale="OR"}) or logarithm of the risk-ratio
#' (\code{scale="RR"}).
#'
#' With the default \code{outtype=1}, \code{nBinomial()} returns a vector of
#' total sample sizes is returned.  With \code{outtype=2}, \code{nBinomial()}
#' returns a data frame containing two vectors \code{n1} and \code{n2}
#' containing sample sizes for groups 1 and 2, respectively; if \code{n} is
#' input, this option also returns the power in a third vector, \code{Power}.
#' With \code{outtype=3}, \code{nBinomial()} returns a data frame with the
#' following columns: \item{n}{A vector with total samples size required for
#' each event rate comparison specified} \item{n1}{A vector of sample sizes for
#' group 1 for each event rate comparison specified} \item{n2}{A vector of
#' sample sizes for group 2 for each event rate comparison specified}
#' \item{alpha}{As input} \item{sided}{As input} \item{beta}{As input; if
#' \code{n} is input, this is computed} \item{Power}{If \code{n=NULL} on input,
#' this is \code{1-beta}; otherwise, the power is computed for each sample size
#' input} \item{sigma0}{A vector containing the standard deviation of the
#' treatment effect difference under the null hypothesis times \code{sqrt(n)}
#' when \code{scale="Difference"} or \code{scale="OR"}; when \code{scale="RR"},
#' this is the standard deviation time \code{sqrt(n)} for the numerator of the
#' Farrington-Manning test statistic \code{x1-exp(delta0)*x2}.} \item{sigma1}{A
#' vector containing the values as \code{sigma0}, in this case estimated under
#' the alternative hypothesis.} \item{p1}{As input} \item{p2}{As input}
#' \item{p10}{group 1 event rate used for null hypothesis} \item{p20}{group 2
#' event rate used for null hypothesis}
#' @author Keaven Anderson \email{keaven\_anderson@@merck.com}
#' @references Farrington, CP and Manning, G (1990), Test statistics and sample
#' size formulae for comparative binomial trials with null hypothesis of
#' non-zero risk difference or non-unity relative risk. \emph{Statistics in
#' Medicine}; 9: 1447-1454.
#'
#' Fleiss, JL, Tytun, A and Ury (1980), A simple approximation for calculating
#' sample sizes for comparing independent proportions.
#' \emph{Biometrics};36:343-346.
#'
#' Gordon, I and Watson R (1985), The myth of continuity-corrected sample size
#' formulae. \emph{Biometrics}; 52: 71-76.
#'
#' Miettinen, O and Nurminen, M (1985), Comparative analysis of two rates.
#' \emph{Statistics in Medicine}; 4 : 213-226.
#' @keywords design
#' @examples
#' 
#' # Compute z-test test statistic comparing 39/500 to 13/500
#' # use continuity correction in variance
#' x <- testBinomial(x1 = 39, x2 = 13, n1 = 500, n2 = 500, adj = 1)
#' x
#' pnorm(x, lower.tail = FALSE)
#' 
#' # Compute with unadjusted variance
#' x0 <- testBinomial(x1 = 39, x2 = 23, n1 = 500, n2 = 500)
#' x0
#' pnorm(x0, lower.tail = FALSE)
#' 
#' # Perform 50k simulations to test validity of the above
#' # asymptotic p-values
#' # (you may want to perform more to reduce standard error of estimate)
#' sum(as.double(x0) <=
#'   simBinomial(p1 = .078, p2 = .078, n1 = 500, n2 = 500, nsim = 10000)) / 10000
#' sum(as.double(x0) <=
#'   simBinomial(p1 = .052, p2 = .052, n1 = 500, n2 = 500, nsim = 10000)) / 10000
#' 
#' # Perform a non-inferiority test to see if p2=400 / 500 is within 5% of
#' # p1=410 / 500 use a z-statistic with unadjusted variance
#' x <- testBinomial(x1 = 410, x2 = 400, n1 = 500, n2 = 500, delta0 = -.05)
#' x
#' pnorm(x, lower.tail = FALSE)
#' 
#' # since chi-square tests equivalence (a 2-sided test) rather than
#' # non-inferiority (a 1-sided test),
#' # the result is quite different
#' pchisq(testBinomial(
#'   x1 = 410, x2 = 400, n1 = 500, n2 = 500, delta0 = -.05,
#'   chisq = 1, adj = 1
#' ), 1, lower.tail = FALSE)
#' 
#' # now simulate the z-statistic witthout continuity corrected variance
#' sum(qnorm(.975) <=
#'   simBinomial(p1 = .8, p2 = .8, n1 = 500, n2 = 500, nsim = 100000)) / 100000
#' 
#' # compute a sample size to show non-inferiority
#' # with 5% margin, 90% power
#' nBinomial(p1 = .2, p2 = .2, delta0 = .05, alpha = .025, sided = 1, beta = .1)
#' 
#' # assuming a slight advantage in the experimental group lowers
#' # sample size requirement
#' nBinomial(p1 = .2, p2 = .19, delta0 = .05, alpha = .025, sided = 1, beta = .1)
#' 
#' # compute a sample size for comparing 15% vs 10% event rates
#' # with 1 to 2 randomization
#' nBinomial(p1 = .15, p2 = .1, beta = .2, ratio = 2, alpha = .05)
#' 
#' # now look at total sample size using 1-1 randomization
#' n <- nBinomial(p1 = .15, p2 = .1, beta = .2, alpha = .05)
#' n
#' # check if inputing sample size returns the desired power
#' nBinomial(p1 = .15, p2 = .1, beta = .2, alpha = .05, n = n)
#' 
#' # re-do with alternate output types
#' nBinomial(p1 = .15, p2 = .1, beta = .2, alpha = .05, outtype = 2)
#' nBinomial(p1 = .15, p2 = .1, beta = .2, alpha = .05, outtype = 3)
#' 
#' 
#' # look at power plot under different control event rate and
#' # relative risk reductions
#' p1 <- seq(.075, .2, .000625)
#' p2 <- p1 * 2 / 3
#' y1 <- nBinomial(p1, p2, beta = .2, outtype = 1, alpha = .025, sided = 1)
#' p2 <- p1 * .75
#' y2 <- nBinomial(p1, p2, beta = .2, outtype = 1, alpha = .025, sided = 1)
#' p2 <- p1 * .6
#' y3 <- nBinomial(p1, p2, beta = .2, outtype = 1, alpha = .025, sided = 1)
#' p2 <- p1 * .5
#' y4 <- nBinomial(p1, p2, beta = .2, outtype = 1, alpha = .025, sided = 1)
#' plot(p1, y1,
#'   type = "l", ylab = "Sample size",
#'   xlab = "Control group event rate", ylim = c(0, 6000), lwd = 2
#' )
#' title(main = "Binomial sample size computation for 80 pct power")
#' lines(p1, y2, lty = 2, lwd = 2)
#' lines(p1, y3, lty = 3, lwd = 2)
#' lines(p1, y4, lty = 4, lwd = 2)
#' legend(
#'   x = c(.15, .2), y = c(4500, 6000), lty = c(2, 1, 3, 4), lwd = 2,
#'   legend = c(
#'     "25 pct reduction", "33 pct reduction",
#'     "40 pct reduction", "50 pct reduction"
#'   )
#' )
#' 
#' # compute blinded estimate of treatment effect difference
#' x1 <- rbinom(n = 1, size = 100, p = .2)
#' x2 <- rbinom(n = 1, size = 200, p = .1)
#' # blinded estimate of risk difference variance
#' varBinomial(x = x1 + x2, n = 300, ratio = 2, delta0 = 0)
#' # blnded estimate of log-risk-ratio
#' varBinomial(x = x1 + x2, n = 300, ratio = 2, delta0 = 0, scale = "RR")
#' # blinded estimate of log-odds-ratio
#' varBinomial(x = x1 + x2, n = 300, ratio = 2, delta0 = 0, scale = "OR")
#' # varBinomial function [sinew] ----
varBinomial <- function(x, n, delta0 = 0, ratio = 1, scale = "Difference") { # check input arguments
  checkVector(x, "integer", c(1, Inf))
  checkScalar(n, "integer", c(1, Inf))
  checkScalar(ratio, "numeric", c(0, Inf), c(FALSE, FALSE))
  scale <- match.arg(tolower(scale), c("difference", "rr", "or"))
  # risk difference test - from Miettinen and Nurminen eqn (9)
  p <- x / n
  phi <- array(0, max(length(delta0), length(x), length(ratio), length(n)))
  if (scale == "difference") {
    checkScalar(delta0, "numeric", c(-1, 1), c(FALSE, FALSE))
    p1 <- p + ratio * delta0 / (ratio + 1)
    p2 <- p1 - delta0
    a <- 1 + ratio
    b <- -(a + p1 + ratio * p2 - delta0 * (ratio + 2))
    c <- delta0^2 - delta0 * (2 * p1 + a) + p1 + ratio * p2
    d <- p1 * delta0 * (1 - delta0)
    v <- (b / (3 * a))^3 - b * c / 6 / a^2 + d / 2 / a
    u <- sign(v) * sqrt((b / 3 / a)^2 - c / 3 / a)
    w <- (pi + acos(v / u^3)) / 3
    p10 <- 2 * u * cos(w) - b / 3 / a
    p20 <- p10 + delta0
    phi <- (p10 * (1 - p10) + p20 * (1 - p20) / ratio) * (ratio + 1)
    phi[delta0 == 0] <- p * (1 - p) / ratio * (1 + ratio)^2
  }
  else if (scale == "rr") # log(p2/p1)
  {
    checkScalar(delta0, "numeric", c(-Inf, Inf), c(FALSE, FALSE))
    RR <- exp(delta0)
    if (delta0 == 0) {
      phi <- (1 - p) / p / ratio * (1 + ratio)^2
    } else {
      p1 <- p * (ratio + 1) / (ratio * RR + 1)
      p2 <- RR * p1
      a <- (1 + ratio) * RR
      b <- -(RR * ratio + p2 * ratio + 1 + p1 * RR)
      c <- ratio * p2 + p1
      p10 <- (-b - sqrt(b^2 - 4 * a * c)) / 2 / a
      p20 <- RR * p10
      phi <- (ratio + 1) * ((1 - p10) / p10 + (1 - p20) / ratio / p20)
    }
  }
  # log-odds ratio - based on asymptotic distribution of log-odds
  # see vignette
  else {
    checkScalar(delta0, "numeric", c(-Inf, Inf), c(FALSE, FALSE))
    OR <- exp(delta0)
    a <- OR - 1
    c <- -p * (ratio + 1)
    b <- 1 + ratio * OR + (OR - 1) * c
    p10 <- (-b + sqrt(b^2 - 4 * a * c)) / 2 / a
    p20 <- OR * p10 / (1 + p10 * (OR - 1))
    phi <- (ratio + 1) * (1 / p10 / (1 - p10) + 1 / p20 / (1 - p20) / ratio)
    phi[delta0 == 0] <- 1 / p / (1 - p) * (1 + 1 / ratio) * (1 + ratio)
  }
  return(phi / n)
}

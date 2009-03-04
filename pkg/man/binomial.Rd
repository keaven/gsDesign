\name{nBinomial}
\alias{testBinomial}
\alias{ciBinomial}
\alias{nBinomial}
\alias{simBinomial}
\title{3.2: Testing, Confidence Intervals and Sample Size for Comparing Two Binomial Rates}
\description{Support is provided for sample size estimation, testing confidence intervals and simulation for fixed sample size trials 
(that is, not group sequential or adaptive) with two arms and binary outcomes. 
Both superiority and non-inferiority trials are considered.
While all routines default to comparisons of risk-difference, 
computations based on risk-ratio and odds-ratio are also provided. 

\code{nBinomial()} computes sample size using the method of Farrington and 
Manning (1990) to derive sample size required to power a trial to test the difference between two binomial event rates. 
The routine can be used for a test of superiority or non-inferiority.
For a design that tests for superiority \code{nBinomial()} is consistent with the method of Fleiss, Tytun, and Ury 
(but without the continuity correction) to test for differences between event rates.
This routine is consistent with the Hmisc package routine \code{bsamsize} for superiority designs.
Vector arguments allow computing sample sizes for multiple scenarios for comparative purposes.

\code{testBinomial()} computes a Z- or Chi-square-statistic that compares two binomial event rates using 
the method of Miettinen and Nurminen (1980). This can be used for superiority or non-inferiority testing.
Vector arguments allow easy incorporation into simulation routines for fixed, group sequential and adaptive designs.

\code{ciBinomial()} computes confidence intervals for 1) the difference between two rates, 2) the risk-ratio for two rates 
or the odds-ratio for two rates. This procedure provides inference that is consistent with \code{testBinomial()} in that 
the confidence intervals are produced by inverting the testing procedures in \code{testBinomial()}.

\code{simBinomial()} performs simulations to estimate the power for a Miettinin and Nurminen (1980) test
comparing two binomial rates for superiority or non-inferiority. 
As noted in documentation for \code{bpower.sim()}, by using \code{testBinomial()} you can see that the formulas 
without any continuity correction are quite accurate. 
In fact, Type I error for a continuity-corrected test is significantly lower (Gordon and Watson, 1996)
than the nominal rate. 
Thus, as a default no continuity corrections are performed.
}

\usage{
nBinomial(p1, p2, alpha=.025, beta=0.1, delta0=0, ratio=1, sided=1, outtype=1,
          scale="Difference") 
testBinomial(x1, x2, n1, n2, delta0=0, chisq=0, adj=0,
             scale="Difference", tol=.1e-10)
ciBinomial(x1, x2, n1, n2, alpha=.05, adj=0, scale="Difference")
simBinomial(p1, p2, n1, n2, delta0=0, nsim=10000, chisq=0, adj=0,
            scale="Difference")
}
\arguments{
For \code{simBinomial()} and \code{ciBinomial()} all arguments must have length 1.
For \code{testBinomial()}, \code{x2, x2, n1, n2, delta0, chisq,} and \code{adj} may be vectors.
For \code{nBinomial()}, \code{p1, p2, beta, delta0} and \code{ratio} may be vectors.
When one or more arguments for \code{nBinomial()} or \code{testBinomial()} is a vector, 
the routines return a vector of sample sizes and powers, respectively.
Where vector arguments are allowed, there may be a mix of scalar and vector arguments. 
All arguments specified using vectors must have the same length.  

\item{p1}{event rate in group 1 under the alternative hypothesis}  
\item{p2}{event rate in group 2 under the alternative hypothesis}  
\item{alpha}{type I error; see \code{sided} below to distinguish between 1- and 2-sided tests}
\item{beta}{type II error}
\item{delta0}{A value of 0 (the default) always represents no difference between treatment groups under the null hypothesis.
\code{delta0} is interpreted differently depending on the value of the parameter \code{scale}. 
If \code{scale="Difference"} (the default), 
\code{delta0} is the difference in event rates under the null hypothesis (p10 - p20).
If \code{scale="RR"}, 
\code{delta0} is the logarithm of the relative risk of event rates (p10 / p20) under the null hypothesis.
If \code{scale="LNOR"}, 
\code{delta0} is the difference in natural logarithm of the odds-ratio under the null hypothesis
\code{log(p10 / (1 - p10)) - log(p20 / (1 - p20))}.
}
\item{ratio}{sample size ratio for group 2 divided by group 1}
\item{sided}{2 for 2-sided test, 1 for 1-sided test}
\item{outtype}{1 (default) returns total sample size; 2 returns sample size for each group (\code{n1, n2});
3 and \code{delta0=0} returns a list with total sample size (\code{n}), sample size in each group (\code{n1, n2}),
null and alternate hypothesis variance (\code{sigma0, sigma1}), input event rates (\code{p1, p2}) and null hypothesis event
rates (\code{p10, p20}). 
}
\item{x1}{Number of \dQuote{successes} in the control group}
\item{x2}{Number of \dQuote{successes} in the experimental group}
\item{n1}{Number of observations in the control group}
\item{n2}{Number of observations in the experimental group}
\item{chisq}{An indicator of whether or not a chi-square (as opposed to Z) statistic is to be computed.
If 0 (default), the difference in event rates divided by its standard error under the null hypothesis is used. 
Otherwise, a Miettinen and Nurminen chi-square statistic for a 2 x 2 table is used.}
\item{adj}{With \code{adj=1}, the standard variance with a continuity correction is used for a Miettinen and Nurminen test statistic 
This includes a factor of \eqn{n / (n - 1)} where \eqn{n} is the total sample size. If \code{adj} is not 1, 
this factor is not applied. The default is \code{adj=0} since nominal Type I error is generally conservative with \code{adj=1}
(Gordon and Watson, 1996).}
\item{scale}{\dQuote{Difference}, \dQuote{RR}, \dQuote{OR}; see the \code{scale} parameter documentation above and Details. 
This is a scalar argument.}
\item{nsim}{The number of simulations to be performed in \code{simBinomial()}}
\item{tol}{Default should probably be used; this is used to deal with a rounding issue in interim calculations}
}

\references{
Farrington, CP and Manning, G (1990), Test statistics and sample size formulae for comparative binomial trials with null hypothesis
of non-zero risk difference or non-unity relative risk. \emph{Statistics in Medicine};9:1447-1454.

Fleiss, JL, Tytun, A and Ury (1980), A simple approximation for calculating sample sizes for comparing independent proportions.
\emph{Biometrics};36:343-346.

Gordon, I and Watson R (1985), The myth of continuity-corrected sample size formulae. \emph{Biometrics};52:71-76.

Miettinin, O and Nurminen, M (1980), Comparative analysis of two rates. \emph{Statistics in Medicine};4:213-226.
}

\details{
Testing is 2-sided when a Chi-square statistic is used and 1-sided when a Z-statistic is used.
Thus, these 2 options will produce substantially different results, in general.
For non-inferiority, 1-sided testing is appropriate.

You may wish to round sample sizes up using \code{ceiling()}.

Farrington and Manning (1990) begin with event rates \code{p1} and \code{p2} under the alternative hypothesis
and a difference between these rates under the null hypothesis, \code{delta0}.
From these values, actual rates under the null hypothesis are computed, which are labeled \code{p10} and \code{p20}
when \code{outtype=3}.
The rates \code{p1} and \code{p2} are used to compute a variance for a Z-test comparing rates under the alternative hypothesis,
which \code{p10} and \code{p20} are used under the null hypothesis.

Sample size with \code{scale="Difference"} produces an error if \code{p1-p2=delta0}. 
Normally, the alternative hypothesis under consideration would be \code{p1-p2-delta0}$>0$.
However, the alternative can have \code{p1-p2-delta0}$<0$.
}

\value{
  \code{testBinomial()} and \code{simBinomial()} each return a vector of either Chi-square or Z test statistics. 
  These may be compared to an appropriate cutoff point (e.g., \code{qnorm(.975)} or \code{qchisq(.95,1)}).
 
  With the default \code{outtype=2}, \code{nBinomial()} returns a list containing two vectors \code{n1} and \code{n2} containing
  sample sizes for groups 1 and 2, respectively.
  With \code{outtype=1}, a vector of total sample sizes is returned.
  With \code{outtype=3}, \code{nBinomial()} returns a list as follows:
  \item{n}{A vector with total samples size required for each event rate comparison specified}
  \item{n1}{A vector of sample sizes for group 1 for each event rate comparison specified}
  \item{n2}{A vector of sample sizes for group 2 for each event rate comparison specified}
  \item{sigma0}{A vector containing the variance of the treatment effect difference under the null hypothesis}
  \item{sigma1}{A vector containing the variance of the treatment effect difference under the alternative hypothesis}
  \item{p1}{As input}
  \item{p2}{As input}
  \item{pbar}{Returned only for superiority testing (\code{\delta0=0}), the weighted average of \code{p1} and \code{p2} using weights
  \code{n1} and \code{n2}}

  When \code{delta0=0}, instead of \code{pbar}, the following 2 vectors are returned (see details):
  \item{p10}{group 1 treatment effect used for null hypothesis}
  \item{p20}{group 2 treatment effect used for null hypothesis}

}

\author{Keaven Anderson \email{keaven\_anderson@merck.com}}

\examples{
# Compute z-test test statistic comparing 39/500 to 13/500
# use continuity correction in variance
x <- testBinomial(x1=39, x2=13, n1=500, n2=500, adj=1)
x
pnorm(x, lower.tail=FALSE)

# Compute with unadjusted variance
x0 <- testBinomial(x1=39, x2=23, n1=500, n2=500)
x0
pnorm(x0, lower.tail=FALSE)

# Perform 500k simulations to test validity of the above asymptotic p-values 
sum(as.real(x0) <= simBinomial(p1=.078, p2=.078, n1=500, n2=500, nsim=500000)) / 500000
sum(as.real(x0) <= simBinomial(p1=.052, p2=.052, n1=500, n2=500, nsim=500000)) / 500000

# Perform a non-inferiority test to see if p2=400 / 500 is within 5% of 
# p1=410 / 500 use a z-statistic with unadjusted variance
x <- testBinomial(x1=410, x2=400, n1=500, n2=500, delta0= -.05)
x
pnorm(x, lower.tail=FALSE)

# since chi-square tests equivalence (a 2-sided test) rather than non-inferiority (a 1-sided test), 
# the result is quite different
pchisq(testBinomial(x1=410, x2=400, n1=500, n2=500, delta0= -.05, chisq=1, 
                    adj=1), 1, lower.tail=FALSE)

# now simulate the z-statistic witthout continuity corrected variance
sum(qnorm(.975) <= simBinomial(p1=.8, p2=.8, n1=500, n2=500, nsim=1000000)) / 1000000

# compute a sample size to show non-inferiority with 5% margin, 90% power
nBinomial(p1=.2, p2=.2, delta0=.05, alpha=.025, sided=1, beta=.1)

# assuming a slight advantage in the experimental group lowers sample size requirement
nBinomial(p1=.2, p2=.19, delta0=.05, alpha=.025, sided=1, beta=.1)

# compute a sample size for comparing 15\% vs 10\% event rates with 1 to 2 randomization
nBinomial(p1=.15, p2=.1, beta=.2, ratio=2, alpha=.05)

# now look at total sample size using 1-1 randomization
nBinomial(p1=.15, p2=.1, beta=.2, alpha=.05)

# look at power plot under different control event rate and
# relative risk reductions
p1 <- seq(.075, .2, .000625)
p2 <- p1 * 2 / 3
y1 <- nBinomial(p1, p2, beta=.2, outtype=1, alpha=.025, sided=1)
p2 <- p1 * .75
y2 <- nBinomial(p1, p2, beta=.2, outtype=1, alpha=.025, sided=1)
p2 <- p1 * .6
y3 <- nBinomial(p1, p2, beta=.2, outtype=1, alpha=.025, sided=1)
p2 <- p1 * .5
y4 <- nBinomial(p1, p2, beta=.2, outtype=1, alpha=.025, sided=1)
plot(p1, y1, type="l", ylab="Sample size", xlab="Control group event rate",
     ylim=c(0, 6000), lwd=2)
title(main="Binomial sample size computation for 80 pct power")
lines(p1, y2, lty=2, lwd=2)
lines(p1, y3, lty=3, lwd=2)
lines(p1, y4, lty=4, lwd=2)
legend(x=c(.15, .2),y=c(4500, 6000),lty=c(2, 1, 3, 4), lwd=2,
       legend=c("25 pct reduction", "33 pct reduction", "40 pct reduction",
                "50 pct reduction"))
}

\keyword{design}

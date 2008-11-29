\name{FarrMannSS}
\alias{FarrMannSS}
\alias{MandNtest}
\alias{MandNsim}
\alias{Sample Size for Two-Sample Binomial Test}
\title{3.2: Two-sample binomial sample size}
\description{\code{FarrMannSS()} computes sample size using the method of Farrington and Manning (1990) to derive sample size
required to power a trial to test the difference 
in event rates between two binomial event rates. The routine can be used for a test of superiority or non-inferiority.
For a design that tests for superiority \code{FarrMannSS()} is consistent with the method of Fleiss, Tytun, and Ury 
(but without the continuity correction) to test for no difference between event rates.
This routine is consistent with the Hmisc package routine bsamsize for superiority designs.

\code{MandNtest()} computes a Z- or Chi-square-statistic that compares two binomial event rates using 
the method of Miettinen and Nurminen (1980). This can be used for superiority or non-inferiority testing.

\code{MandNsim()} performs simulations to estimate the power for a Miettinin and Nurminen (1980) test
comparing two binomial rates for superiority or non-inferiority. 
As noted in documentation for \code{bpower.sim()}, by using \code{MandNsim()} you can see that the formulas 
without any continuity correction are quite accurate. 
In fact, a continuity-corrected test is significantly lower (Gordon and Watson, 1996). 
Thus, no continuity corrections are implemented here.
}

\usage{
FarrMannSS(p1, p2, fraction = 0.5, alpha = 0.05, power = 0.8, beta=0, 
           delta0=0, ratio=0, sided=2, outtype=2) 
MandNtest(x1,x2,n1,n2,delta0=0,testtype="Chisq",adj=1)
MandNsim(p1, p2, n1, n2, alpha = 0.05, delta0=0, nsim = 10000, 
           testtype="Chisq", adj=1)
}
\arguments{

\item{p1}{event rate in group 1}  
\item{p2}{event rate in group 2}  
\item{fraction}{fraction of observations in group 1}  
\item{alpha}{type I error; see \code{sided} below to distinguish between 1- and 2-sided tests}
\item{power}{the desired probability of detecting a difference}  
\item{beta}{type II error; used instead of \code{power} when non-zero}
\item{delta0}{The absolute difference in event rates that is considered unacceptable.}
\item{ratio}{sample size ratio for group 2 divided by group 1; used instead of \code{fraction} when non-zero}
\item{sided}{2 for 2-sided test, 1 for 1-sided test}
\item{outtype}{2 (default) returns sample size for each group (\code{n1, n2}); otherwise returns \code{n1+n2}}
\item{x1}{Number of "successes" in the control group}
\item{x2}{Number of "successes" in the experimental group}
\item{n1}{Number of observations in the control group}
\item{n2}{Number of observations in the experimental group}
\item{testtype}{If "Chisq" (default), a Miettinen and Nurminen chi-square statistic for a 2x2 table (no continuity correction) is used. 
Otherwise, the difference in event rates divided by its standard error under the null hypothesis is used.}
\item{adj}{With \code{adj=1}, the standard variance for a Miettinen and Nurminen test statistic is used. 
This includes a factor of n/(n-1) where n is the total sample size. If \code{adj} is not 1, 
this factor is not applied. See details.}
\item{nsim}{The number of simulations to be performed in \code{MandNSim()}}
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

For \code{MandNsim()} all arguments must be of length 1.
In general, arguments for \code{FarrMannSS()} and \code{MandNtest()} may be scalars or vectors, 
in which case they return a vector of sample sizes and powers, respectively. 
There can be a mix of scalar and vector arguments. 
All arguments specified using vectors must have the same length.  
You may wish to round sample sizes up using \code{ceiling()}.

Farrington and Manning (1990) begin with event rates \code{p1} and \code{p2} under the alternative hypothesis
and a difference between these rates under the null hypothesis, \code{delta0}.
From these values, actual rates under the null hypothesis are computed, which are labeled \code{p10} and \code{p20}
when \code{outtype=3}.
The rates \code{p1} and \code{p2} are used to compute a variance for a Z-test comparing rates under the alternative hypothesis,
which \code{p10} and \code{p20} are used under the null hypothesis.  
}

\value{
  \code{MandNtest} and \code{MandNsim} each return a vector of either Chi-square or Z test statistics. 
  These may be compared to an appropriate cutoff point (e.g., \code{qnorm(.975)} or \code{qchisq(.95,1)}).
 
  With the default \code{outtype=2}, \code{FarrMannSS()} returns a list containing two vectors \code{n1} and \code{n2} containing
  sample sizes for groups 1 and 2, respectively.
  With \code{outtype=1}, a vector of total sample sizes is returned.
  With \code{outtype=3}, \code{FarrMannSS()} returns a list as follows:
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
# Compute chi-square test statistic comparing 39/500 to 13/500
x<-MandNtest(x1=39,x2=23,n1=500,n2=500)
x
pchisq(x,1,lower.tail=FALSE)

# Compute with unadjusted variance
x0<-MandNtest(x1=39,x2=23,n1=500,n2=500,adj=0)
x0
pchisq(x0,1,lower.tail=FALSE)

# Perform 5 mhundred thousand simulations to evaluate how valid the above asymptotic p-values are 
sum(x<=MandNsim(p1=.078,p2=.078,n1=500,n2=500,nsim=500000))/500000
sum(x<=MandNsim(p1=.052,p2=.052,n1=500,n2=500,nsim=500000))/500000

# Perform a non-inferiority test to see if p2=400/500 is within 5% of p1=410/500
# use a z-statistic with unadjusted variance
x<-MandNtest(x1=410,x2=400,n1=500,n2=500,delta0=-.05,testtype="Z",adj=0)
x
pnorm(x,lower.tail=FALSE)

# since chi-square tests equivalence (a 2-sided test) rather than non-inferiority (a 1-sided test), 
# the result is quite different
pchisq(MandNtest(x1=410,x2=400,n1=500,n2=500,delta0=-.05),1,lower.tail=FALSE)

# now simulate the z-statistic
sum(x<=MandNsim(p1=.8,p2=.8,n1=500,n2=500,nsim=1000000,testtype="Z",adj=0))/1000000

# compute a sample size to show non-inferiority with 5% margin, 90% power
FarrMannSS(p1=.2,p2=.2,delta0=.05,alpha=.025,sided=1,beta=.1)

# assuming a slight advantage in the experimental group lowers sample size requirement
FarrMannSS(p1=.2,p2=.19,delta0=.05,alpha=.025,sided=1,beta=.1)

# compute a sample size for comparing 15% vs 10% event rates with 1 to 2 randomization
FarrMannSS(p1=.15,p2=.1,beta=.2,ratio=2,alpha=.05)

# now look at total sample size using 1-1 randomization
FarrMannSS(p1=.15,p2=.1,beta=.2,alpha=.05)

# look at power plot under different control event rate and
# relative risk reductions
p1<-seq(.075,.2,.000625)
p2<-p1*2/3
y1<-FarrMannSS(p1,p2,beta=.2,outtype=1,alpha=.025,sided=1)
p2<-p1*.75
y2<-FarrMannSS(p1,p2,beta=.2,outtype=1,alpha=.025,sided=1)
p2<-p1*.6
y3<-FarrMannSS(p1,p2,beta=.2,outtype=1,alpha=.025,sided=1)
p2<-p1*.5
y4<-FarrMannSS(p1,p2,beta=.2,outtype=1,alpha=.025,sided=1)
plot(p1,y1,type="l",ylab="Sample size",xlab="Control group event rate",ylim=c(0,6000),lwd=2)
title(main="Binomial sample size computation for 80 pct power")
lines(p1,y2,lty=2,lwd=2)
lines(p1,y3,lty=3,lwd=2)
lines(p1,y4,lty=4,lwd=2)
legend(x=c(.15,.2),y=c(4500,6000),lty=c(2,1,3,4),lwd=2,legend=c("25 pct reduction","33 pct reduction","40 pct reduction","50 pct reduction"))

}

\keyword{design}

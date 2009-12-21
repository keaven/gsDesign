\name{nSurvival}
\alias{nSurvival}
\alias{Survival sample size}
\title{3.4: Time-to-event sample size calculation (Lachin-Foulkes)}
\description{\code{nSurvival()} is used to calculate the sample size for a clinical trial with a time-to-event endpoint. The Lachin and Foulkes (1986) method is used.
}

\usage{
nSurvival(lambda1=1/12, lambda2=1/24, Ts=24, Tr=12, eta = 0, ratio = 1,
      alpha = 0.025, beta = 0.10, sided = 1, approx = FALSE,
      type = c("rr", "rd"), entry = c("unif", "expo"), gamma = NA)
}
\arguments{
  \item{lambda1, lambda2}{event hazard rate for placebo and treatment
    group respectively.}
  \item{eta}{equal dropout hazard rate for both groups.}
  \item{ratio}{randomization ratio between placebo and treatment
    group. Default is balanced design, i.e., randomization ratio is 1.}
  \item{Ts}{maximum study duration.}
  \item{Tr}{accrual (recruitment) duration.}
  \item{alpha}{type I error rate. Default is 0.05 since 2-sided testing is default.}
  \item{beta}{type II error rate. Default is 0.10 (90\% power).}
  \item{sided}{one or two-sided test? Default is two-sided test.}
  \item{approx}{logical. If \code{TRUE}, the approximation sample size
    formula for risk difference is used.}
  \item{type}{type of sample size calculation: risk ratio (\dQuote{rr}) or risk
    difference (\dQuote{rd}).}
  \item{entry}{patient entry type: uniform entry (\code{"unif"}) or exponential
    entry (\code{"expo"}).}
  \item{gamma}{rate parameter for exponential entry. \code{NA} if entry type is
    \code{"unif"} (uniform). A non-zero value is supplied if entry type is
    \code{"expo"} (exponential).} 
}

\details{
  \code{nSurvival} produces the number of subjects and events for a set of
  pre-specified trial parameters, such as accrual duration and follow-up
  period. The calculation is based on Lachin and Foulkes method and can
  be used for risk ratio or risk difference. The function also consider
  non-uniform entry as well as uniform entry. 

  If the logical approx is \code{TRUE}, the variance under alternative
  hypothesis is used to replace the variance under null hypothesis.
The 
  For non-uniform entry. a non-zero value of gamma for exponential entry
  must be supplied. For positive gamma, the entry distribution is
  convex, whereas for negative gamma, the entry distribution is concave.
}

\value{
  \code{nSurvival} produces a list with the following component returned:
  \item{type}{As input.}
  \item{entry}{As input.}
  \item{n}{Sample size required.}
  \item{nEvents}{Number of events required.}
  \item{lambda1}{As input.}
  \item{lambda2}{As input.}
  \item{eta}{As input.}
  \item{ratio}{As input.}
  \item{gamma}{As input.}
  \item{alpha}{As input.}
  \item{beta}{As input.}
  \item{sided}{As input.}
  \item{Ts}{As input.}
  \item{Tr}{As input.}
}

\author{Shanhong Guan \email{shanhong\_guan@merck.com}}
\references{
  
  Lachin JM and Foulkes MA (1986),
  Evaluation of Sample Size and Power for Analyses of Survival
  with Allowance for Nonuniform Patient Entry, Losses to Follow-Up,
  Noncompliance, and Stratification. \emph{Biometrics}, 42, 507-519.
}

\examples{

# consider a trial with 
# 2 year maximum follow-up
# 6 month uniform enrollment
# Treatment/placebo hazards = 0.1/0.2 per 1 person-year
# drop out hazard 0.1 per 1 person-year
# alpha = 0.05 (two-sided)
# power = 0.9 (default beta=.1)

ss <- nSurvival(lambda1=.2 , lambda2=.1, eta = .1, Ts = 2, Tr = .5,
                sided=1, alpha=.025)
ss

#  symmetric, 2-sided design with O'Brien-Fleming-like boundaries
#  sample size is computed based on a fixed design requiring n=100
	x<-gsDesign(k = 5, test.type = 2)
	x
# boundary plot
	plot(x)
# power plot
	plot(x, plottype = 2)
# total sample size
   ceiling(x$n.I[x$k] / 2 * ss$n) * 2
# number of events at analyses
   ceiling(ss$nEvents * x$n.I)
}

\keyword{design}

\name{nSurvival}
\alias{nSurvival}
\alias{Survival sample size}
\title{3.3: Time-to-event sample size calculation (Lachin-Foulkes)}
\description{\code{nSurvival()} is used to calculate the sample size for a clinical trial with time-to-event endpoint. The Lachin and Faulkes (1986) method is used.
}

\usage{
nSurvival(lambda.0, lambda.1, eta = 0, rand.ratio = 1, Ts, Tr,
      alpha = 0.05, beta = 0.10, sided = 2, approx = FALSE, type = c("rr", "rd"),
      entry = c("unif", "expo"), gamma = NA)
}
\arguments{
  \item{lambda.0, lambda.1}{event hazard rate for placebo and treatment
    group respectively.}
  \item{eta}{equal dropout hazard rate for both groups.}
  \item{rand.ratio}{randomization ratio between placebo and treatment
    group. Default is balanced design, i.e., randomization ratio is 1.}
  \item{Ts}{maximum study duration.}
  \item{Tr}{accrual duration.}
  \item{alpha}{type I error rate. Default is 0.025 for one-sided.}
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
  period. The calculation is based on Lachin and Faulkes method and can
  be used for risk ratio or risk difference. The function also consider
  non-uniform entry as well as uniform entry. 

  If the logical approx is \code{TRUE}, the variance under alternative
  hypothesis is used to replace the variance under null hypothesis.

  For non-uniform entry. a non-zero value of gamma for exponential entry
  must be supplied. For positive gamma, the entry distribution is
  convex, whereas for negative gamma, the entry distribution is concave.
}

\value{
  \code{nSurvival} produces a list with the following component returned:
  \item{Method}{As input.}
  \item{Entry}{As input.}
  \item{Sample.size}{Number of subjects.}
  \item{Num.events}{Number of events.}
  \item{Hazard.p, Hazard.t}{hazard rate for placebo and treatment group. As input.}
%  \item{Hazard.t}{hazard rate for treatment group. As input.}
  \item{Dropout}{as input.}
  \item{Frac.p, Frac.t}{randomization proportion for placebo and
    treatment. As input.}
  \item{Gamma}{as input.}
  \item{Alpha}{as input.}
  \item{Beta}{as input.}
  \item{Sided}{as input.}
  \item{Study.dura}{Study duration.}
  \item{Accrual}{Accrual period.}
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
# alpha = 0.025 (one-sided)
# power = 0.9

h0 <- 0.2        
h1 <- 0.1        
eta <- 0.1       
rand.ratio <- 1
tm1 <- 2         
tm2 <- 0.5       
gamma <- NA      
alpha <- 0.05    
beta <- 0.1      

ss <- nSurvival(h0, h1, eta = eta, rand.ratio = rand.ratio,
             Ts = tm1, Tr = tm2,
             alpha = alpha, beta = beta, sided = 1,
             type = "rd", entry = "unif", gamma = gamma)

#  symmetric, 2-sided design with O'Brien-Fleming-like boundaries
#  lower bound is non-binding (ignored in Type I error computation)
#  sample size is computed based on a fixed design requiring n=100
	x<-gsDesign(k = 5, test.type = 2, n.fix = ss$Sample.size)
	x
	plot(x)
	plot(x, plottype = 2)
}

\keyword{design}

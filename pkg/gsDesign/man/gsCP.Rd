\name{gsCP}
\alias{gsCP}
\alias{gsPP}
\alias{gsPOS}
\alias{gsCPOS}
\title{2.4: Conditional and Predictive Power, Overall and Conditional Probability of Success}
\description{
\code{gsCP()} computes conditional boundary crossing probabilities at future planned analyses for a given group sequential design assuming an interim z-statistic at a specified interim analysis.
\code{gsPP()} averages conditional power across a prior distribution to compute predictive power.
\code{gsPOS()} computes the probability of success for a trial using a prior distribution to average power over a set of \code{theta} values of interest.
\code{gsCPOS()} assumes no boundary has been crossed before and including an interim analysis of interest, and computes the probability of success based on this event.
Note that \code{gsCP()} and \code{gsPP()} take only the interim test statistic into account in computing conditional probabilities, while \code{gsCPOS()} conditions on not crossing any bound through a specified interim analysis.
}

\usage{
gsCP(x, theta=NULL, i=1, zi=0, r=18)
gsPP(x, i=1, zi=0, theta=c(0,3), wgts=c(.5,.5), r=18, total=TRUE)
gsPOS(x, theta, wgts)
gsCPOS(i, x, theta, wgts)
}
\arguments{
	\item{x}{An object of type \code{gsDesign} or \code{gsProbability}}
	\item{theta}{a vector with \eqn{\theta}{theta} value(s) at which conditional power is to be computed; for \code{gsCP()} if \code{NULL}, an estimated value of \eqn{\theta}{theta} based on the interim test statistic (\code{zi/sqrt(x$n.I[i])}) as well as at \code{x$theta} is computed.}
	\item{wgts}{Weights to be used with grid points in \code{theta}. Length can be one if weights are equal, otherwise should be the same length as \code{theta}. Values should be positive, but do not need to sum to 1.}
	\item{i}{analysis at which interim z-value is given; must be from 1 to \code{x$k-1}}
	\item{zi}{interim z-value at analysis i (scalar)}
	\item{r}{Integer value controlling grid for numerical integration as in Jennison and Turnbull (2000);
	default is 18, range is 1 to 80. 
	Larger values provide larger number of grid points and greater accuracy.
	Normally \code{r} will not be changed by the user.}
	\item{total}{Needs documentation.}
}
\value{
\code{gsCP()} returns an object of the class \code{gsProbability}. 
Based on the input design and the interim test statistic, the output gsDesign object has bounds for test statistics computed based on solely on observations after interim \code{i}. 
Boundary crossing probabilities are computed for the input \eqn{\theta}{theta} values.
See manual and examples.

\code{gsPP()} if total==TRUE, returns a real value indicating the predictive power of the trial conditional on the interim test statistic \code{zi} at analysis \code{i}; otherwise returns vector with predictive power for each future planned analysis.

\code{gsPOS()} returns a real value indicating the probability of a positive study weighted by the prior distribution input for \code{theta}.

\code{gsCPOS()} returns a real value indicating the probability of a positive study weighted by the prior distribution input for \code{theta} conditional on an interim test statistic \code{zi} in the continuation region at analysis \code{i}.
}


\details{
See Conditional power section of manual for further clarification. See also Muller and Schaffer (2001) for background theory.
}
\note{The manual is not linked to this help file, but is available in library/gsdesign/doc/gsDesignManual.pdf in the directory where R is installed.}

\author{Keaven Anderson \email{keaven\_anderson@merck.}}
\references{
Jennison C and Turnbull BW (2000), \emph{Group Sequential Methods with Applications to Clinical Trials}.
Boca Raton: Chapman and Hall.

Muller, Hans-Helge and Schaffer, Helmut (2001), Adaptive group sequential designs for clinical trials:
combining the advantages of adaptive and classical group sequential approaches. \emph{Biometrics};57:886-891. 
}

\examples{
# set up a group sequential design
x <- gsDesign(k=5)
x

# set up a prior distribution for the treatment effect
# that is normal with mean .75*x$delta and standard deviation x$delta/2
prior <- normalGrid(mu=.75*x$delta, sigma=x$delta/2)
names(prior)

# compute POS for the design given the above prior distribution for theta
gsPOS(x=x, theta=prior$z, wgts=prior$wgts)

# assume POS should only count cases in prior where theta >= x$delta/2
gsPOS(x=x, theta=prior$z, wgts=prior$wgts*(prior$z>=x$delta/2))

# assuming a z-value at lower bound at analysis 2, what are conditional 
# boundary crossing probabilities for future analyses
# assuming theta values from x as well as a value based on the interim
# observed z
CP <- gsCP(x, i=2, zi=x$lower$bound[2])
CP

# summing values for crossing future upper bounds gives overall
# conditional power for each theta value
CP$theta
t(CP$upper$prob) %*% c(1,1,1)

# compute predictive probability based on above assumptions
gsPP(x, i=2, zi=x$lower$bound[2], theta=prior$z, wgts=prior$wgts)

# if it is known that boundary not crossed at interim 2, use
# gsCPOS to compute conditional POS based on this
gsCPOS(x=x, i=2, theta=prior$z, wgts=prior$wgts)
}

# 2-stage example to compare results to direct computation
x<-gsDesign(k=2)
z1<- 0.5
n1<-x$n.I[1]
n2<-x$n.I[2]-x$n.I[1]
thetahat<-z1/sqrt(n1)
theta<-c(thetahat, 0 , x$delta)

# conditional power direct computation
pnorm((n2*theta+z1*sqrt(n1)-z*sqrt(n1+n2))/sqrt(n2))
gsCP(x=x, zi=z1, i=1)$upper$prob



\seealso{\code{\link{gsDesign}}, \code{\link{gsProbability}}, \code{\link{gsBoundCP}}}
\keyword{design}

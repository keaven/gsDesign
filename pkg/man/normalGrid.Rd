\name{normalGrid}
\alias{normalGrid}
\title{3.1: Normal Density Grid}
\description{normalGrid() is intended to be used for computation of the expected value of 
 a function of a normal random variable.
 The function produces grid points and weights to be used for numerical integration.
}

\usage{
normalGrid(r=18,bounds=c(0,0),mu=0,sigma=1)
}

\arguments{
	\item{r}{Control for grid points as in Jennison and Turnbull (2000), Chapter 19; default is 18. Range: 1 to 80.
	This might be changed by the user (e.g., \code{r=6} which produces 65 gridpoints compare to 185 points when \code{r=18})
	when speed is more important than precision.}
	\item{bounds}{Range of integration. Real-valued vector of length 2. Default value of 0, 0 produces a range 
	of + or - 6 standard deviations (6*sigma) from the mean (=mu).}
	\item{mu}{Mean of the desired normal distribution.}
	\item{sigma}{Standard deviation of the desired normal distribution.}
}
\value{
	\item{z}{Grid points for numerical integration.}
	\item{wgts}{Weights to be used with grid points in \code{z}.}
	\item{errcode}{returned as 0 if no error detected in call, > 0 otherwise.}
	\item{errmsg}{A text string corresponding to \code{errcode}; for no error, this is "No errors detected"} 
}
\seealso{\code{\link{gsProbability}}, \code{\link{gsDesign}}, \link{Group Sequential Plots}.}
\note{The manual is not linked to this help file, but is available in library/gsdesign/doc/manual.pdf
in the directory where R is installed.}

\author{Keaven Anderson \email{keaven\_anderson@merck.com}}
\references{
Jennison C and Turnbull BW (2000), \emph{Group Sequential Methods with Applications to Clinical Trials}.
Boca Raton: Chapman and Hall.
} 

\examples{
##  standard normal distribution
	x<-normalGrid(r=3)
	plot(x$z,x$wgts)
##  verify that numerical integration replicates sigma
##  get grid points and weights
	x<-normalGrid(mu=2,sigma=3)
## compute squared deviation from mean for grid points
	dev<-(x$z-2)^2
## multiply squared deviations by integration weights and sum 
	sigma2<-sum(dev*x$wgts)
## square root of sigma2 should be sigma (3)
	sqrt(sigma2)
## do it again with larger r to increase accuracy
	x<-normalGrid(r=22,mu=2,sigma=3)
	sqrt(sum((x$z-2)^2*x$wgts))
## find expected sample size for default design with
## n.fix=1000
x<-gsDesign(n.fix=1000)
x
y<-normalGrid(r=3,mu=x$theta[2],sigma=x$theta[2]/1.5)
z<-gsProbability(k=3,theta=y$z,n.I=x$n.I,a=x$lower$bound,b=x$upper$bound)
z<-gsProbability(d=x,theta=y$z)
cat("Expected sample size averaged over normal prior distribution for theta with mu=",
   x$theta[2],"sigma=",x$theta[2]/1.5,":",round(sum(z$en*y$wgt),1),"\n")
plot(y$z,z$en,xlab="theta",ylab="E{N}",
   main="Expected sample size for different theta values")
}
\keyword{design}

\name{gsbound}
\alias{gsbound}
\alias{gsbound1}

\title{Boundary derivation}
\description{\code{gsbound()} and \code{gsbound1()} are lower-level functions used to find boundaries for a group sequential design.
They are not recommended (especially \code{gsbound1()} for casual users.
These functions do not adjust sample size as \code{gsDesign()} does to ensure appropriate power for a design.
The function \code{gsbound1()} requires special attention to detail and knowledge of behavior when a design corresponding to the input
parameters does not exist.

\code{gsbound()} computes upper and lower bounds given boundary crossing probabilities assuming a mean of 0, the usual null hypothesis.
\code{gsbound1()} computes the upper bound given a lower boundary, upper boundary crossing probabilities and an arbitrary mean 
(\code{theta}).}
\usage{
gsbound(I, trueneg, falsepos, tol=0.000001, r=18)
gsbound1(theta, I, a, probhi, tol=0.000001, r=18, printerr=0)
}
\arguments{
Note that all vector arguments should have the same length which will be denoted here as \code{k}.
	\item{theta}{Scalar containing mean (drift) per unit of statistical information.}
	\item{I}{Vector containing statistical information planned at each analysis.}
	\item{a}{Vector containing lower bound that is fixed for use in \code{gsbound1}.}
	\item{trueneg}{Vector of desired probabilities for crossing upper bound assuming mean of 0.}
	\item{falsepos}{Vector of desired probabilities for crossing lower bound assuming mean of 0.}
	\item{probhi}{Vector of desired probabilities for crossing upper bound assuming mean of theta.}
	\item{tol}{Tolerance for error (scalar; default is 0.000001). Normally this will not be changed by the user.
	This does not translate directly to number of digits of accuracy, so use extra decimal places.}
	\item{r}{Single integer value controlling grid for numerical integration as in Jennison and Turnbull (2000); 
	default is 18, range is 1 to 80. 
	Larger values provide larger number of grid points and greater accuracy.
	Normally \code{r} will not be changed by the user.}
	\item{printerr}{If this scalar argument set to 1, this will print messages from underlying C program.
	Mainly intended to print notify user when an output solution does not match input specifications.
	This is not intended to stop execution as this often occurs when deriving a design in \code{gsDesign}
	that uses beta-spending.}
}
\value{
  list(k=xx[[1]],theta=0.,I=xx[[2]],a=xx[[3]],b=xx[[4]],rates=rates,tol=xx[[7]],
        r=xx[[8]],error=xx[[9]])
    y<-list(k=xx[[1]],theta=xx[[2]],I=xx[[3]],a=xx[[4]],b=xx[[5]],
            problo=xx[[6]],probhi=xx[[7]],tol=xx[[8]],r=xx[[9]],error=xx[[10]])
Both routines return a list. Common items returned by the two routines are: 
\item{k}{The length of vectors input; a scalar.}
\item{theta}{As input in \code{gsbound1()}; 0 for \code{gsbound()}.}
\item{I}{As input.}
\item{a}{}
\item{b}{}
\item{tol}{As input.}
\item{r}{As input.}
\item{error}{Error code. 0 if no error; > 0 otherwise.}

\code{gsbound()} also returns the following items:
\item{rates}{a list containing two items:}
\item{falsepos}{vector of upper boundary crossing probabilities as input.}
\item{trueneg}{vector of lower boundary crossing probabilities as input.}

\code{gsbound1()} also returns the following items:
\item{problo}{vector of lower boundary crossing probabilities; computed using input lower bound
and derived upper bound.}
\item{probhi}{vector of upper boundary crossing probabilities as input.}
}

\details{Forthcoming...}

\seealso{\link{gsDesign-package}, \code{\link{gsDesign}}, \code{\link{gsProbability}}}
\note{The manual is not linked to this help file, but is available in library/gsdesign/doc/gsDesignManual.pdf
in the directory where R is installed.}

\author{Keaven Anderson \email{keaven\_anderson@merck.com}, Jennifer Sun, John Zhang}
\references{
Jennison C and Turnbull BW (2000), \emph{Group Sequential Methods with Applications to Clinical Trials}.
Boca Raton: Chapman and Hall.
}

\examples{
##  set boundaries so that probability is .01 of first crossing each upper boundary
##  and .02 of crossing each lower boundary under null hypothesis
	x<-gsbound(I=c(1,2,3)/3,trueneg=array(.02,3),falsepos=array(.01,3))
	x

##  use gsbound1 to set up boundary for a 1-sided test
	x<-gsbound1(theta= 0,I=c(1,2,3)/3,a=array(-20,3),probhi=c(.001,.009,.015))
	x$b

## check boundary crossing probabilities with gsProbability 
	y<-gsProbability(k=3,theta=0,n.I=x$I,a=x$a,b=x$b)$upper$prob

##  Note that gsbound1 only computes upper bound 
##  To get a lower bound under a parameter value theta:
##      use minus the upper bound as a lower bound
##      replace theta with -theta
##      set probhi as desired lower boundary crossing probabilities 
##  Here we let set lower boundary crossing at 0.05 at each analysis assuming theta=2.2 
	
	y<-gsbound1(theta= -2.2,I=c(1,2,3)/3,a= -x$b,probhi=array(.05,3))
	y$b

##  Now use gsProbability to look at design
##  Note that lower boundary crossing probabilities are as specified for theta=2.2,
##  but for theta=0 the upper boundary crossing probabilities are smaller
##  than originally specified above after first interim analysis
	 gsProbability(k=length(x$b),theta=c(0,2.2),n.I=x$I,b=x$b,a= -y$b)
}
\keyword{design}

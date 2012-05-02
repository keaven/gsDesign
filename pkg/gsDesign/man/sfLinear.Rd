\name{sfLinear}
\alias{sfLinear}

\title{4.6: Piecewise Linear Spending Function}
\description{The function \code{sfLinear()} allows specification of a piecewise linear spending function.
This provides complete flexibility in setting spending at desired timepoints in a group sequential design.
Normally this function will be passed to \code{gsDesign()} in the parameter 
\code{sfu} for the upper bound or
\code{sfl} for the lower bound to specify a spending function family for a design.
When passed to \code{gsDesign()}, the value of \code{param} would be passed to \code{sfLinear} through the \code{gsDesign()} arguments \code{sfupar} for the upper bound and \code{sflpar} for the lower bound.
}

\usage{
sfLinear(alpha, t, param)
}
\arguments{
	\item{alpha}{Real value \eqn{> 0} and no more than 1. Normally, 
\code{alpha=0.025} for one-sided Type I error specification
	or \code{alpha=0.1} for Type II error specification. However, this could be set to 1 if for descriptive purposes you wish to see the proportion of spending as a function of the proportion of sample size or information.}
	\item{t}{A vector of points with increasing values from 0 to 1, inclusive. Values of the proportion of 
	sample size or information for which the spending function will be computed.}
	\item{param}{A vector with a positive, even length. Values must range from 0 to 1, inclusive.
Letting \code{m <- length(param/2)}, the first \code{m} points in param specify increasing values strictly between 0 and 1,
where the interim timing (proportion of final total statistical information) where spending is to be specified is given. 
The last \code{m} points in param specify non-decreasing values from 0 to 1, inclusive, 
with the cumulative proportion of spending at the timepoints in the first part of the vector.}
}
\value{An object of type \code{spendfn}. 
The cumulative spending returned in \code{sfLinear$spend} is 0 for \code{t=0} and \code{alpha} for \code{t>=1}. 
For \code{t} between specified points, linear interpolation is used to determine \code{sfLinear$spend}. 
See \code{\link{Spending function overview}} for further details.}

\seealso{\link{Spending function overview}, \code{\link{gsDesign}}, \link{gsDesign package overview}}
\note{The manual is not linked to this help file, but is available in library/gsdesign/doc/gsDesignManual.pdf
in the directory where R is installed.}

\author{Keaven Anderson \email{keaven\_anderson@merck.}}
\references{
Jennison C and Turnbull BW (2000), \emph{Group Sequential Methods with Applications to Clinical Trials}.
Boca Raton: Chapman and Hall.
}

\examples{
# set up alpha spending and beta spending to be piecewise linear
sfupar <- c(.2, .4, .05, .2)
sflpar <- c(.3, .5, .65, .5, .75, .9)
x <- gsDesign(sfu=sfLinear, sfl=sfLinear, sfupar=sfupar, sflpar=sflpar)
plot(x, plottype="sf")
x

# now do an example where there is no lower-spending at interim 1
# and no upper spending at interim 2
sflpar<-c(1/3,2/3,0,.25)
sfupar<-c(1/3,2/3,.1,.1)
x <- gsDesign(sfu=sfLinear, sfl=sfLinear, sfupar=sfupar, sflpar=sflpar)
plot(x, plottype="sf")
x
}
\keyword{design}

\name{sfPoints}
\alias{sfPoints}
\title{4.5: Pointwise Spending Function}
\description{
The function \code{sfPoints} implements a spending function with values specified for an arbitrary set of specified points.
Normally \code{sfPoints} will be passed to \code{gsDesign} in the parameter \code{sfu} for the upper bound or
\code{sfl} for the lower bound to specify a spending function family for a design.
In this case, the user does not need to know the calling sequence, just the points they wish to specify.
If using \code{sfPoints()} in a design, it is recommended to specify how to interpolate between the specified points (e.g,, linear interpolation); also consider fitting smooth spending functions; see 
\link{Spending function overview}.
}

\usage{
sfPoints(alpha, t, param)
}

\arguments{
	\item{alpha}{Real value \eqn{> 0} and no more than 1. Normally, \code{alpha=0.025} for one-sided Type I error specification
	or \code{alpha=0.1} for Type II error specification. However, this could be set to 1 if for descriptive purposes
	you wish to see the proportion of spending as a function of the proportion of sample size/information.}
	\item{t}{A vector of points with increasing values from 0 to 1, inclusive. The last point should be 1.
	Values of the proportion of sample size/information for which the spending function will be computed.}
	\item{param}{A vector of the same length as \code{t} specifying the cumulative proportion of spending
	to corresponding to each point in \code{t}.}
}
\value{An object of type \code{spendfn}. See spending functions for further details.}

\seealso{\link{Spending function overview}, \code{\link{gsDesign}}, \link{gsDesign package overview}, \link{sfLogistic}}
\note{The manual is not linked to this help file, but is available in library/gsdesign/doc/gsDesignManual.pdf
in the directory where R is installed.}

\author{Keaven Anderson \email{keaven\_anderson@merck.}}
\references{
Jennison C and Turnbull BW (2000), \emph{Group Sequential Methods with Applications to Clinical Trials}.
Boca Raton: Chapman and Hall.
}

\examples{
# example to specify spending on a pointwise basis
x <- gsDesign(k=6, sfu=sfPoints, sfupar=c(.01, .05, .1, .25, .5, 1), test.type=2)
x

# get proportion of upper spending under null hypothesis at each analysis
y <- x$upper$prob[, 1] / .025

# change to cumulative proportion of spending
for(i in 2:length(y)) 
    y[i] <- y[i - 1] + y[i]

# this should correspond to input sfupar
round(y, 6)

# plot these cumulative spending points
plot(1:6/6, y, main="Pointwise spending function example", 
    xlab="Proportion of final sample size", 
    ylab="Cumulative proportion of spending", 
    type="p")

# following lines produce error when compiling package on some systems
# approximate this with a t-distribution spending function by fitting 3 points
tx <- 0:100/100
lines(tx, sfTDist(1, tx, c(c(1, 3, 5)/6, .01, .1, .5))$spend)
text(x=.6, y=.9, labels="Pointwise Spending Approximated by")
text(x=.6, y=.83, "t-Distribution Spending with 3-point interpolation")
}
\keyword{design}

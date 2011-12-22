\name{sfTruncated}
\alias{sfTruncated}

\title{4.7a: Truncated spending functions}
\description{The function \code{sfTruncated()} applies any other spending function over a restricted range.
This allows eliminating spending for early interim analyses when you desire not to stop for the bound being specified.
The truncation can come late in the trial.
if you desire to stop a trial any time after, say, 90 percent of information is available 
and an analysis is performed.
}

\usage{
sfTruncated(alpha, t, param)
}
\arguments{
	\item{alpha}{Real value \eqn{> 0} and no more than 1. Normally, 
\code{alpha=0.025} for one-sided Type I error specification
	or \code{alpha=0.1} for Type II error specification. However, this could be set to 1 if for descriptive purposes
	you wish to see the proportion of spending as a function of the proportion of sample size or information.}
	\item{t}{A vector of points with increasing values from 0 to 1, inclusive. Values of the proportion of 
	sample size or information for which the spending function will be computed.}
	\item{param}{a list containing the elements sf (a spendfn object such as sfHSD), trange (the range over which the 
        spending function increases from 0 to 1; 0 <= trange[1]<trange[2] <=1), and param (null for a spending function with no parameters or a scalar or vector of parameters needed to fully specify the spending function in sf).}
}

\value{An object of type \code{spendfn}. See \code{\link{Spending function overview}} for further details.}
\details{
\code{sfTruncated} compresses spending into a sub-range of [0,1].
The parameter \code{param$trange} specifies the range over which spending is to occur.
Within this range, spending is spent according to the spending function specified in
\code{param$sf} along with the corresponding spending function parameter(s) in 
\code{param$param}.
See example using \code{sfLinear} that spends uniformly over specified range.
}

\seealso{\link{Spending function overview}, \code{\link{gsDesign}}, \link{gsDesign package overview}}
\note{The manual is not linked to this help file, but is available in library/gsdesign/doc/gsDesignManual.pdf
in the directory where R is installed.}

\author{Keaven Anderson \email{keaven\_anderson@merck.}}
\references{
Jennison C and Turnbull BW (2000), \emph{Group Sequential Methods with Applications to Clinical Trials}.
Boca Raton: Chapman and Hall.
}

\examples{

# Eliminate spending forany interim at or before 20 percent of information.
# Complete spending at first interim at or after 80 percent of information.
s<-sfLinear(alpha=.05,t=(0:100)/100,param=c(.5,.5))
plot((0:100)/100,s$spend,type="l",main="Accelerating spending with sfTruncated",
xlab="Proportion of information",ylab="Spending")
s<-sfTruncated(alpha=.05,t=(0:100)/100,param=list(sf=sfLinear,trange=c(.2,.8),param=c(.5,.5)))
lines(col=2,(0:100)/100,s$spend)
text("Accelerated (red) spending over interval (.2,.8)",x=.03,y=.045,pos=4)

# now apply this in gsDesign
# note how sfupar is set up to do as above

# 1st version produces an error next to last interim must be before final spend
# x<-gsDesign(k=5, sfu=sfTruncated, sfupar=list(sf=sfLinear, param=c(.5,.5), 
# trange=c(.2,.8)))

# now final spend occurs at > next to last interim
x<-gsDesign(k=5, sfu=sfTruncated, sfupar=list(sf=sfLinear, param=c(.5,.5), trange=c(.2,.95)))
x

# The above means if final analysis is done a little early, all spending can occur
# Suppose we skip 4th interim due to fast enrollment and set calendar date
# based on estimated full information, but come up with only 97 pct of plan
xA <- gsDesign(k=x$k-1,n.I=c(x$n.I[1:3],.97*x$n.I[5]),test.type=x$test.type, 
               maxn.IPlan=x$n.I[x$k],sfu=sfTruncated,
               sfupar=list(sf=sfLinear,  param=c(.5,.5), trange=c(.2,.95)))
xA
}
\keyword{design}

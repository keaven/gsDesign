\name{plot.gsDesign}
\alias{plot.gsDesign}
\alias{plot.gsProbability}
\alias{Group Sequential Plots}
\title{2.3: Plots for group sequential designs}
\description{The \code{plot()} function has been extended to work with objects in the gsDesign
and gsProbability classes (\emph{i.e.}, objects returned by the functions \code{gsDesign} and
\code{gsProbability}, respectively). 
For objects of type \code{gsDesign}, seven types of plots are provided: z-values at boundaries (default), power, 
estimated treatment effects at boundaries, 
conditional power at boundaries, spending functions, expected sample size, and B-values at boundaries.
For objects of type \code{gsProbability} plots are available for z-values at boundaries, power (default), conditional power,
expected sample size and B-values at boundaries.
}

\usage{
plot.gsProbability(x,plottype=2,...)
plot.gsDesign(x,plottype=1,...)
}

\arguments{
	\item{x}{Object of class \code{gsDesign} for \code{plot.gsDesign()} or \code{gsProbability} for

 \code{plot.gsProbability()}.}
	\item{plottype}{1=boundary plot (default for \code{gsDesign}), 
	2=power plot (default for \code{gsProbability}), 
	3=estimated treatment effect at boundaries, 
	4=conditional power at boundaries, 
	5=spending function plot 
	(only available if \code{class(x)=="gsDesign"}), 
	6=expected sample size plot, and 
	7=B-values at boundaries. 
	Character values for \code{plottype} may also be entered: 1<==>"Z", 2<==>"power", 3<==>"thetahat",
	4<==>"CP", 5<==>"sf", 6<==>"ASN" or "N" or "n", 7<==>"B" or "B-val" or "B-value".}
	\item{...}{This allows many optional arguments that are standard when calling \code{plot}.
	Other arguments include: 
	1) \code{theta} which is used for \code{plottype=2, 4, 6}; normally defaults will be adequate; see details. 
	2) \code{ses=TRUE} which applies only when \code{plottype=3} and \code{class(x)=="gsDesign"}; indicates that estimated standardized effect size
	at the boundary (\eqn{hat(theta)/delta)}) is to be plotted rather than the actual estimate (\eqn{hat(theta)} if \code{ses==FALSE}).
	3) \code{xval="Default"} which is only effective when \code{plottype=2, 6}. Appropriately scaled (reparameterized) values 
	for x-axis for power and expected sample size graphs; see details.}
	}

\value{An object of \code{class(x)}; in many cases this is the input value of \code{x}, while in others \code{x$theta} is replaced 
and corresponding characteristics computed; see details.}

\details{
The intent is that many standard \code{plot()} parameters will function as expected in most cases, although exceptions to this rule exist.
In particular, \code{main, xlab, ylab, lty, col, lwd, type, pch, cex} have been tested and work for most values of \code{plottype}; one
exception is that \code{type="l"} cannot be overridden when \code{plottype=2}. Default values for labels depend on \code{plottype} and 
the class of \code{x}.


Note that there is some special behavior for values plotted and returned 
for power and expected sample size plots (\code{plottype=2,6}) for a \code{gsDesign} object.
A call to \code{x<-gsDesign)()} produces power for only two \eqn{theta} values: 0 and \eqn{delta}. 
The call \code{plot(x,plottype=2,theta=theta)} (or \code{plot(x,plottype=6,theta=theta}) for a \code{gsDesign} object 
produces power (expected sample size) curves and returned a \code{gsDesign} object with \eqn{theta} values determined as follows. 
If \code{psi} is not specified, input values of \code{theta} are used (default is \code{theta=seq(0,2,.05)*x$delta}) 
and the default \code{xval=seq(0,2,.05)} so that standardized effect sizes are plotted on the x-axis.
If \code{psi} is specified, then values are plotted for \code{theta=theta/psi}; that is, input values of \code{theta} are re-scaled; 
default x-values for plotting are on the .
Rather than plotting the x-axis
as \eqn{theta} values, values of \eqn{theta / delta} are plotted in this case.  
See examples below.

Estimated treatment effects at boundaries are computed multiplying the Z-values at the boundaries by
the square root of n.I at that analysis. 

Spending functions are plotted for a continuous set of values from 0 to 1. 
This option should not be used if a boundary is used or a pointwise spending function is used
(\code{sfu} or \code{sfl="WT", "OF", "Pocock"} or \code{sfPoints}). 

Conditional power is computed using the function \code{gsBoundCP()}. 
The default input for this routine is \code{theta="thetahat"} which will compute the conditional power
at each bound using the estimated treatment effect at that bound. 
Otherwise, conditional power is computed assuming \code{theta=x$delta}, 
the original effect size for which the trial was planned.

Average sample number/expected sample size is computed using n.I at each analysis times 
the probability of crossing a boundary at that analysis.
If no boundary is crossed at any analysis, this is counted as stopping at the final analysis.

B-values are Z-values multiplied by \code{sqrt(t)=sqrt(x$n.I/n$n.I[x$k])}. 
Thus, the expected value of a B-value at an analysis is the true value of 
\eqn{theta} multiplied by the proportion of total planned observations at that time.
See Proschan, Lan and Wittes (2006).
}
\seealso{\link{gsDesign-package}, \code{\link{gsDesign}}, \code{\link{gsProbability}}}
\note{The manual is not linked to this help file, but is available in library/gsdesign/doc/manual.pdf
in the directory where R is installed.}

\author{Keaven Anderson \email{keaven\_anderson@merck.com}}
\references{
Jennison C and Turnbull BW (2000), \emph{Group Sequential Methods with Applications to Clinical Trials}.
Boca Raton: Chapman and Hall.

Proschan, MA, Lan, KKG, Wittes, JT (2006), \emph{Statistical Monitoring of Clinical Trials. A Unified Approach}. 
New York: Springer.
}

\examples{
##  symmetric, 2-sided design with O'Brien-Fleming-like boundaries
##  lower bound is non-binding (ignored in Type I error computation)
##  sample size is computed based on a fixed design requiring n=100
	x<-gsDesign(k=5,test.type=2,n.fix=100)
	x
## the following translate to calls to plot.gsDesign since x was returned by gsDesign
## run these commands one at a time
	plot(x)
	plot(x,plottype=2)
	plot(x,plottype=3)
	plot(x,plottype=4)
	plot(x,plottype=5)
	plot(x,plottype=6)
	plot(x,plottype=7)

##  choose different parameter values for power plot
##  start with design in x from above
	y<-gsProbability(k=5,theta=seq(0,.5,.025),x$n.I,x$lower$bound,x$upper$bound)
## the following translates to a call to plot.gsProbability since y has that type
	plot(y)

}
\keyword{design}


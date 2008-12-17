\name{gsProbability}
\alias{gsProbability}
\alias{print.gsProbability}
\title{2.2: Boundary Crossing Probabilities}
\description{Computes power/Type I error and expected sample size for a group sequential design
across a selected set of parameter values for a given set of analyses and boundaries.
The print function has been extended using \code{print.gsProbability} to print \code{gsProbability} objects; see examples.
}

\usage{
gsProbability(k=0, theta, n.I, a, b, r=18, d=NULL)
}
\details{Depending on the calling sequence, an object of class \code{gsProbability} or class \code{gsDesign} is returned.
If it is of class \code{gsDesign} then the members of the object will be the same as described in \code{\link{gsDesign}}.
If \code{d} is input as \code{NULL} (the default), all other arguments (other than \code{r}) must be specified 
and an object of class \code{gsProbability} is returned.
If \code{d} is passed as an object of class \code{gsProbability} or \code{gsDesign} the only other argument required is \code{theta};
the object returned has the same class as the input \code{d}.
On output, the values of \code{theta} input to \code{gsProbability} will be the parameter values for which the
design is characterized.
}

\arguments{
	\item{k}{Number of analyses planned, including interim and final.}
	
	\item{theta}{Vector of standardized effect sizes for which boundary crossing probabilities are to be computed.}
	\item{n.I}{Sample size or relative sample size at analyses; vector of length k. See \code{\link{gsDesign}} and manual.}
	\item{a}{Lower bound cutoffs (z-values) for futility or harm at each analysis, vector of length k.}
	\item{b}{Upper bound cutoffs (z-values) for futility at each analysis; vector of length k.}
	\item{r}{Control for grid as in Jennison and Turnbull (2000); default is 18, range is 1 to 80.
	Normally this will not be changed by the user.}
   \item{d}{If not \code{NULL}, this should be an object of type \code{gsDesign} returned by a call to \code{gsDesign()}. 
	When this is specified, the values of \code{k}, \code{n.I}, \code{a}, \code{b}, and \code{r} will be obtained from \code{d} and
	only \code{theta} needs to be specified by the user.}
}
\value{
	\item{k}{As input.}
	\item{theta}{As input.}
	\item{n.I}{As input.}
	\item{lower}{A list containing two elements: \code{bound} is as input in \code{a} and \code{prob} is a matrix of boundary 
	crossing probabilities. Element \code{i,j} contains the boundary crossing probability at analysis \code{i} for the \code{j}-th
	element of \code{theta} input. All boundary crossing is assumed to be binding for this computation; 
	that is, the trial must stop if a boundary is crossed.}
	\item{upper}{An list of the same form as \code{lower} containing the upper bound and upper boundary crossing probabilities.}
	\item{en}{A vector of the same length as \code{theta} containing expected sample sizes for the trial design
	corresponding to each value in the vector \code{theta}.}
	\item{r}{As input.}
}
\seealso{\link{Group Sequential Plots}, \code{\link{gsDesign}}, \link{gsDesign-package}}
\note{The manual is not linked to this help file, but is available in library/gsdesign/doc/manual.pdf
in the directory where R is installed.}
\author{Keaven Anderson \email{keaven\_anderson@merck.com}, Jennifer Sun, John Zhang}
\references{
Jennison C and Turnbull BW (2000), \emph{Group Sequential Methods with Applications to Clinical Trials}.
Boca Raton: Chapman and Hall.
} 

\examples{
# making a gsDesign object first may be easiest...
x <- gsDesign()

# take a look at it
x

# default plot for gsDesign object shows boundaries
plot(x)

# plottype=2 shows boundary crossing probabilities
plot(x, plottype=2)

# now add boundary crossing probabilities and 
# expected sample size for more theta values
y <- gsProbability(d=x, theta=x$delta*seq(0, 2, .25))
class(y)

# note that "y" below is equivalent to print(y) and print.gsProbability(y)
y

# the plot does not change from before since this is a gsDesign object
# note that theta/delta is on x axis
plot(y, plottype=2)

# now let's see what happens with a gsProbability object
z <- gsProbability(k=3, a=x$lower$bound, b=x$upper$bound, n.I=x$n.I, 
    theta=x$delta*seq(0, 2, .25))

# with the above form,  the results is a gsProbability object
class(z)
z

# default plottype is now 2
# this is the same range for theta,  but plot now has theta on x axis
plot(z)
}
\keyword{design}



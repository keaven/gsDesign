\name{gsCP}
\alias{gsCP}
\title{2.4: Conditional Power Computation}
\description{
\code{gsCP()} takes a given group sequential design, assumes an interim z-statistic 
at a specified interim analysis and computes boundary crossing probabilities at future planned analyses.
}

\usage{
gsCP(x, theta=NULL, i=1, zi=0, r=18)
}
\arguments{
	\item{x}{An object of type gsDesign or gsProbability}
	\item{theta}{theta value(s) at which conditional power is to be computed; if NULL, 
	an estimated value of theta based on the interim test statistic (\code{zi/sqrt(x$n.I[i])}) as well as at \code{x$theta}
	is computed.}
	\item{i}{analysis at which interim z-value is given}
	\item{zi}{interim z-value at analysis i}
	\item{r}{Integer value controlling grid for numerical integration as in Jennison and Turnbull (2000); 
	default is 18, range is 1 to 80. 
	Larger values provide larger number of grid points and greater accuracy.
	Normally \code{r} will not be changed by the user.}
}
\value{
An object of the class \code{gsProbability}.
Based on the input design and the interim test statistic, the output object has bounds for test statistics
computed based on observations after interim i that are equivalent to the original design crossing boundaries conditional
on the interim test statistic value input. 
Boundary crossing probabilities are computed for the input theta values.
}


\details{
See Statistical Methods section of manual for further clarification. See also Muller and Schaffer (2001) for background theory.
}
\note{The manual is not linked to this help file, but is available in library/gsdesign/doc/manual.pdf
in the directory where R is installed.}

\author{Keaven Anderson \email{keaven\_anderson@merck.com}, Jennifer Sun, John Zhang}
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

# assuming a z-value of .5 at analysis 2, what are conditional 
# boundary crossing probabilities for future analyses
# assuming theta values from x as well as a value based on the interim
# observed z
CP <- gsCP(x, i=2, zi=.5)
CP

# summing values for crossing future upper bounds gives overall
# conditional power for each theta value
CP$theta
CP$upper$prob %*% c(1,1,1)
}
\seealso{\code{\link{gsDesign}}, \code{\link{gsProbability}}, \code{\link{gsBoundCP}}}
\keyword{design}

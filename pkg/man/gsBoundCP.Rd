\name{gsBoundCP}
\alias{gsBoundCP}
\title{2.5: Conditional Power at Interim Boundaries}
\description{
\code{
gsBoundCP()} computes the total probability of crossing future upper bounds
given an interim test statistic at an interim bound.
For each interim boundary
assumes an interim test statistic at the boundary and
computes the probability of crossing any of the later upper boundaries.
}

\email{keaven\_anderson@merck.com}

\usage{gsBoundCP(x,theta="thetahat",r=18)}
\arguments{
	\item{x}{An object of type gsDesign or gsProbability}
	\item{theta}{if \code{"thetahat"} and \code{class(x)!="gsDesign"}), conditional power computations for
	each boundary value are computed using estimated treatment effect assuming a test statistic at that boundary
	(\code{zi/sqrt(x$n.I[i]} at analysis \code{i}, interim test statistic \code{zi} and interim 
	sample size/statistical information of \code{x$n.I[i]}). Otherwise, conditional power is computed
	assuming the input scalar value \code{theta}.
	}
	\item{r}{Integer value controlling grid for numerical integration as in Jennison and Turnbull (2000); 
	default is 18, range is 1 to 80. 
	Larger values provide larger number of grid points and greater accuracy.
	Normally \code{r} will not be changed by the user.}
}
\value{
A list containing two vectors, \code{CPlo} and \code{CPhi}.
\item{CPlo}{A vector of length \code{x$k-1} with conditional powers of crossing upper bounds
given interim test statistics at each lower bound}
\code{CPhi}{A vector of length \code{x$k-1} with conditional powers of crossing upper bounds
given interim test statistics at each upper bound.}
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
## set up a group sequential design
x<-gsDesign(k=5)
x

## compute conditional power based on interim treatment effects
gsBoundCP(x)

## compute conditional power based on original x$delta
gsBoundCP(x,theta=x$delta)
}
\seealso{\code{\link{gsDesign}}, \code{\link{gsProbability}}, \code{\link{gsCP}}}
\keyword{conditional power}

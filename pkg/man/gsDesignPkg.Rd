\name{gsDesign}
\alias{gsDesign Package}
\docType{package}
\title{1.0: Group Sequential Design Package}
\description{The gsDesign package provides routines to derive and evaluate the properties of group sequential designs.
The function gsDesign() derives a design with desired boundary crossing probabilities (Type I error and power).
Built-in and user-specified spending functions can be used to define the boundaries.
For symmetric and 1-sided testing, boundaries may also be defined using Wang-Tsiatis bounds,
which include O'Brien-Fleming and Pocock bounds.
The function \code{gsProbability()} evaluates boundary crossing probabilities for a given design and 
set of parameter values.
The functions are provided to be called from the command line to make them and their returned values
available to calling programs.}

\email{keaven\_anderson@merck.com}

\seealso{\code{\link{gsDesign}}, \code{\link{gsProbability}}, \link{Group Sequential Plots},
\link{Spending Functions}, \link{Wang-Tsiatis Bounds}.
}
\note{The manual is not linked to this help file, but is available in library/gsdesign/doc/manual.pdf
in the directory where R is installed.}

\author{Keaven Anderson \email{keaven\_anderson@merck.com}, Jennifer Sun, John Zhang}
\references{
Jennison C and Turnbull BW (2000), \emph{Group Sequential Methods with Applications to Clinical Trials}.
Boca Raton: Chapman and Hall.
} 

\keyword{design}

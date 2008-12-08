\name{Wang-Tsiatis Bounds}
\alias{O'Brien-Fleming Bounds}
\alias{Wang-Tsiatis Bounds}
\alias{Pocock Bounds}
\docType{package}
\title{5.0: Wang-Tsiatis Bounds}
\description{\code{gsDesign} offers the option of using Wang-Tsiatis bounds as an alternative to 
the spending function approach to group sequential design.
Wang-Tsiatis bounds include both Pocock and O'Brien-Fleming designs.
Wang-Tsiatis bounds are currently only available for 1-sided and symmetric 2-sided designs.
Wang-Tsiatis bounds are typically used with equally spaced timing between analyses, but
the option is available to use them with unequal spacing.
}
\details{
Wang-Tsiatis bounds are defined as follows.
Assume \eqn{k} analyses and let \eqn{Z_i} represent the upper bound and \eqn{t_i} the proportion of the
total planned sample size for the \eqn{i}-th analysis, 
\eqn{i=1,2,\ldots,k}.
Let \eqn{\Delta} be a real-value. 
Typically \eqn{\Delta} will range from 0 (O'Brien-Fleming design) to 0.5 (Pocock design).
The upper boundary is defined by 
\deqn{ct_i^{\Delta-0.5}}
for \eqn{i= 1,2,\ldots,k} where \eqn{c} depends on the other parameters.
The parameter \eqn{\Delta} is supplied to \code{gsDesign()} in the parameter \code{sfupar}.
For O'Brien-Fleming and Pocock designs there is also a calling sequence that does not require a parameter.
See examples.}

\seealso{\code{\link{Spending Functions}, \link{gsDesign}}, \code{\link{gsProbability}}}
\note{The manual is not linked to this help file, but is available in library/gsdesign/doc/manual.pdf
in the directory where R is installed.}

\author{Keaven Anderson \email{keaven\_anderson@merck.com}, Jennifer Sun, John Zhang}
\references{
Jennison C and Turnbull BW (2000), \emph{Group Sequential Methods with Applications to Clinical Trials}.
Boca Raton: Chapman and Hall.
} 
\examples{
# Pocock design
gsDesign(test.type=2, sfu="Pocock")

# alternate call to get Pocock design specified using Wang-Tsiatis option and Delta=0.5
gsDesign(test.type=2, sfu="WT", sfupar=0.5)

# this is how this might work with a spending function approach
# Hwang-Shih-DeCani spending function with gamma=1 is often used to approximate Pocock design
gsDesign(test.type=2, sfu=sfHSD, sfupar=1)

# unequal spacing works,  but may not be desirable 
gsDesign(test.type=2, sfu="Pocock", timing=c(.1, .2))

# spending function approximation to Pocock with unequal spacing 
# is quite different from this
gsDesign(test.type=2, sfu=sfHSD, sfupar=1, timing=c(.1, .2))

# One-sided O'Brien-Fleming design
gsDesign(test.type=1, sfu="OF")

# alternate call to get O'Brien-Fleming design specified using Wang-Tsiatis option and Delta=0
gsDesign(test.type=1, sfu="WT", sfupar=0)
}

\keyword{design}

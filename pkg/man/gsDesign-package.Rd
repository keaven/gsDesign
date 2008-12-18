\name{gsDesign-package}
\alias{gsDesign-package}
\docType{package}
\title{1.0 Group Sequential Design}
\description{
gsDesign is a package that derives group sequential designs.
The package allows particular flexibility for designs with alpha- and beta-spending.
Many plots are available for describing design properties.
}
\details{
\tabular{ll}{
\tabular{ll}{
Package: \tab gsDesign\cr
Version: \tab 1.3\cr
License: \tab GPL (version 2 or later)\cr
}

Index:
\preformatted{
gsDesign                2.1: Design Derivation
gsProbability           2.2: Boundary Crossing Probabilities
plot.gsDesign           2.3: Plots for group sequential designs
gsCP                    2.4: Conditional Power Computation
gsBoundCP               2.5: Conditional Power at Interim Boundaries
normalGrid              3.1: Normal Density Grid
MandNtest               3.2: Two-sample binomial sample size
Survival sample size    3.3: Time-to-event sample size calculation
                        (Lachin-Foulkes)
Spending Functions      4.0: Spending functions
sfHSD                   4.1: Hwang-Shih-DeCani Spending Function
sfPower                 4.2: Kim-DeMets (power) Spending Function
sfExponential           4.3: Exponential Spending Function
sfLDPocock              4.4: Lan-DeMets Spending Functions
sfPoints                4.5: Pointwise Spending Function
sfLogistic              4.6: 2-parameter Spending Function Families
sfTDist                 4.7: t-distribution Spending Function
Wang-Tsiatis Bounds     5.0: Wang-Tsiatis Bounds
}
The gsDesign package supports group sequential clinical trial design. 
While there is a strong focus on designs using \eqn{\alpha}{alpha}- and \eqn{\beta}{beta}-spending functions, Wang-Tsiatis designs, 
including O'Brien-Fleming and Pocock designs, are also available.
The ability to design with non-binding futility rules 
controls Type I error in a manner acceptable to regulatory authorities when futility bounds are employed. 

The routines are designed to provide simple access to commonly used designs
using default arguments. 
Standard, published spending functions are supported as well as the ability to write custom spending functions. 
A \code{gsDesign} class is defined and returned by the \code{gsDesign()} function. 
A plot function for this class provides a wide variety of plots: boundaries, power, estimated treatment effect at boundaries, 
conditional power at boundaries, spending function plots, expected sample size plot, and B-values at boundaries.
Using function calls to access the package routines provides a powerful capability to derive designs or output 
formatting that could not be anticipated through a gui interface. 
This enables the user to easily create designs with features they desire, 
such as designs with minimum expected sample size.

Thus, the intent of the gsDesign package is to easily create, fully characterize and even 
optimize routine group sequential trial designs as well as provide a tool to evaluate innovative designs.
}
\author{
Keaven Anderson

Maintainer: Keaven Anderson \code{<keaven_anderson@merck.com>}
}
\references{
Jennison C and Turnbull BW (2000), \emph{Group Sequential Methods with Applications to Clinical Trials}.
Boca Raton: Chapman and Hall.

Proschan, MA, Lan, KKG, Wittes, JT (2006), \emph{Statistical Monitoring of Clinical Trials. A Unified Approach}. 
New York: Springer.
}
\keyword{design}
\seealso{\code{\link{gsDesign}}, \code{\link{gsProbability}}
}
\examples{
# assume a fixed design (no interim) trial with the same endpoint requires 200 subjects
# for 90\% power at alpha=.025, one-sided
x <- gsDesign(n.fix=200)
plot(x)
}

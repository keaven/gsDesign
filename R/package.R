#' 1.0 Group Sequential Design
#' 
#' gsDesign is a package for deriving and describing group sequential designs.
#' The package allows particular flexibility for designs with alpha- and
#' beta-spending. Many plots are available for describing design properties.
#' 
#' \tabular{ll}{ Package: \tab gsDesign\cr Version: \tab 2\cr License: \tab GPL
#' (version 2 or later)\cr }
#' 
#' Index: \preformatted{ gsDesign 2.1: Design Derivation gsProbability 2.2:
#' Boundary Crossing Probabilities plot.gsDesign 2.3: Plots for group
#' sequential designs gsCP 2.4: Conditional Power Computation gsBoundCP 2.5:
#' Conditional Power at Interim Boundaries gsbound 2.6: Boundary derivation -
#' low level normalGrid 3.1: Normal Density Grid binomial 3.2: Testing,
#' Confidence Intervals and Sample Size for Comparing Two Binomial Rates
#' Survival sample size 3.3: Time-to-event sample size calculation
#' (Lachin-Foulkes) Spending function overview 4.0: Spending functions sfHSD
#' 4.1: Hwang-Shih-DeCani Spending Function sfPower 4.2: Kim-DeMets (power)
#' Spending Function sfExponential 4.3: Exponential Spending Function
#' sfLDPocock 4.4: Lan-DeMets Spending function overview sfPoints 4.5:
#' Pointwise Spending Function sfLogistic 4.6: 2-parameter Spending Function
#' Families sfTDist 4.7: t-distribution Spending Function Wang-Tsiatis Bounds
#' 5.0: Wang-Tsiatis Bounds checkScalar 6.0: Utility functions to verify
#' variable properties } The gsDesign package supports group sequential
#' clinical trial design.  While there is a strong focus on designs using
#' \eqn{\alpha}{alpha}- and \eqn{\beta}{beta}-spending functions, Wang-Tsiatis
#' designs, including O'Brien-Fleming and Pocock designs, are also available.
#' The ability to design with non-binding futility rules allows control of Type
#' I error in a manner acceptable to regulatory authorities when futility
#' bounds are employed.
#' 
#' The routines are designed to provide simple access to commonly used designs
#' using default arguments.  Standard, published spending functions are
#' supported as well as the ability to write custom spending functions.  A
#' \code{gsDesign} class is defined and returned by the \code{gsDesign()}
#' function.  A plot function for this class provides a wide variety of plots:
#' boundaries, power, estimated treatment effect at boundaries, conditional
#' power at boundaries, spending function plots, expected sample size plot, and
#' B-values at boundaries. Using function calls to access the package routines
#' provides a powerful capability to derive designs or output formatting that
#' could not be anticipated through a gui interface.  This enables the user to
#' easily create designs with features they desire, such as designs with
#' minimum expected sample size.
#' 
#' Thus, the intent of the gsDesign package is to easily create, fully
#' characterize and even optimize routine group sequential trial designs as
#' well as provide a tool to evaluate innovative designs.
#' 
#' @name gsDesign package overview
#' @docType package
#' @author Keaven Anderson
#' 
#' Maintainer: Keaven Anderson \code{<keaven_anderson@@merck.com>}
#' @seealso \code{\link{gsDesign}}, \code{\link{gsProbability}}
#' @references Jennison C and Turnbull BW (2000), \emph{Group Sequential
#' Methods with Applications to Clinical Trials}. Boca Raton: Chapman and Hall.
#' 
#' Proschan, MA, Lan, KKG, Wittes, JT (2006), \emph{Statistical Monitoring of
#' Clinical Trials. A Unified Approach}.  New York: Springer.
#' @keywords design
#' @examples
#' 
#' # assume a fixed design (no interim) trial with the same endpoint
#' # requires 200 subjects for 90% power at alpha=.025, one-sided
#' x <- gsDesign(n.fix=200)
#' plot(x)
#' 
NULL





#' 4.0: Spending function overview
#' 
#' Spending functions are used to set boundaries for group sequential designs.
#' Using the spending function approach to design offers a natural way to
#' provide interim testing boundaries when unplanned interim analyses are added
#' or when the timing of an interim analysis changes. Many standard and
#' investigational spending functions are provided in the gsDesign package.
#' These offer a great deal of flexibility in setting up stopping boundaries
#' for a design.
#' 
#' The \code{summary()} function for \code{spendfn} objects provides a brief
#' textual summary of a spending function or boundary used for a design.
#' 
#' Spending functions have three arguments as noted above and return an object
#' of type \code{spendfn}. Normally a spending function will be passed to
#' \code{gsDesign()} in the parameter \code{sfu} for the upper bound and
#' \code{sfl} for the lower bound to specify a spending function family for a
#' design. In this case, the user does not need to know the calling sequence -
#' only how to specify the parameter(s) for the spending function. The calling
#' sequence is useful when the user wishes to plot a spending function as
#' demonstrated below in examples. In addition to using supplied spending
#' functions, a user can write code for a spending function. See examples.
#' 
#' @param alpha Real value \eqn{> 0} and no more than 1. Defaults in calls to
#' \code{gsDesign()} are \code{alpha=0.025} for one-sided Type I error
#' specification and \code{alpha=0.1} for Type II error specification.
#' However, this could be set to 1 if, for descriptive purposes, you wish to
#' see the proportion of spending as a function of the proportion of sample
#' size/information.
#' @param t A vector of points with increasing values from 0 to 1, inclusive.
#' Values of the proportion of sample size/information for which the spending
#' function will be computed.
#' @param param A single real value or a vector of real values specifying the
#' spending function parameter(s); this must be appropriately matched to the
#' spending function specified.
#' @param object A spendfn object to be summarized.
#' @param ... Not currently used.
#' @return \code{spendingFunction} and spending functions in general produce an
#' object of type \code{spendfn}. \item{name}{A character string with the name
#' of the spending function.} \item{param}{any parameters used for the spending
#' function.} \item{parname}{a character string or strings with the name(s) of
#' the parameter(s) in \code{param}.} \item{sf}{the spending function
#' specified.} \item{spend}{a vector of cumulative spending values
#' corresponding to the input values in \code{t}.} \item{bound}{this is null
#' when returned from the spending function, but is set in \code{gsDesign()} if
#' the spending function is called from there.  Contains z-values for bounds of
#' a design.} \item{prob}{this is null when returned from the spending
#' function, but is set in \code{gsDesign()} if the spending function is called
#' from there.  Contains probabilities of boundary crossing at \code{i}-th
#' analysis for \code{j}-th theta value input to \code{gsDesign()} in
#' \code{prob[i,j]}.}
#' @note The manual is not linked to this help file, but is available in
#' library/gsdesign/doc/gsDesignManual.pdf in the directory where R is
#' installed.
#' @author Keaven Anderson \email{keaven\_anderson@@merck.}
#' @seealso \code{\link{gsDesign}}, \code{\link{sfHSD}}, \code{\link{sfPower}},
#' \code{\link{sfLogistic}}, \code{\link{sfExponential}},
#' \code{\link{sfTruncated}}, \link{Wang-Tsiatis Bounds}, \link{gsDesign package overview}
#' 
#' @references Jennison C and Turnbull BW (2000), \emph{Group Sequential
#' Methods with Applications to Clinical Trials}. Boca Raton: Chapman and Hall.
#' @keywords design
#' @examples
#' 
#' # Example 1: simple example showing what mose users need to know
#' 
#' # design a 4-analysis trial using a Hwang-Shih-DeCani spending function 
#' # for both lower and upper bounds 
#' x <- gsDesign(k=4, sfu=sfHSD, sfupar=-2, sfl=sfHSD, sflpar=1)
#' 
#' # print the design
#' x
#' # summarize the spending functions
#' summary(x$upper)
#' summary(x$lower)
#' 
#' # plot the alpha- and beta-spending functions
#' plot(x, plottype=5)
#' 
#' # what happens to summary if we used a boundary function design
#' x <- gsDesign(test.type=2,sfu="OF")
#' y <- gsDesign(test.type=1,sfu="WT",sfupar=.25)
#' summary(x$upper)
#' summary(y$upper)
#' 
#' # Example 2: advanced example: writing a new spending function  
#' # Most users may ignore this!
#' 
#' # implementation of 2-parameter version of
#' # beta distribution spending function
#' # assumes t and alpha are appropriately specified (does not check!) 
#' sfbdist <- function(alpha,  t,  param)
#' {  
#'    # check inputs
#'    checkVector(param, "numeric", c(0, Inf), c(FALSE, TRUE))
#'    if (length(param) !=2) stop(
#'    "b-dist example spending function parameter must be of length 2")
#' 
#'    # set spending using cumulative beta distribution and return
#'    x <- list(name="B-dist example", param=param, parname=c("a", "b"), 
#'              sf=sfbdist, spend=alpha * 
#'            pbeta(t, param[1], param[2]), bound=NULL, prob=NULL)  
#'            
#'    class(x) <- "spendfn"
#'    
#'    x
#' }
#' 
#' # now try it out!
#' # plot some example beta (lower bound) spending functions using 
#' # the beta distribution spending function 
#' t <- 0:100/100
#' plot(t, sfbdist(1, t, c(2, 1))$spend, type="l", 
#'     xlab="Proportion of information", 
#'     ylab="Cumulative proportion of total spending", 
#'     main="Beta distribution Spending Function Example")
#' lines(t, sfbdist(1, t, c(6, 4))$spend, lty=2)
#' lines(t, sfbdist(1, t, c(.5, .5))$spend, lty=3)
#' lines(t, sfbdist(1, t, c(.6, 2))$spend, lty=4)
#' legend(x=c(.65, 1), y=1 * c(0, .25), lty=1:4, 
#'     legend=c("a=2, b=1","a=6, b=4","a=0.5, b=0.5","a=0.6, b=2"))
#' 
#' @name Spending_Function_Overview
#' @aliases spendingFunction summary.spendfn
NULL

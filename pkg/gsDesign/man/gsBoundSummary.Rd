\name{gsBoundSummary}
\alias{gsBoundSummary}
\alias{xtable.gsDesign}
\alias{gsBValue}
\alias{gsDelta}
\alias{gsHR}
\alias{gsCPz}

\title{2.8: Bound Summary and Z-transformations}

\description{Z-value test statistic transformations are commonly used as supplementary descriptions of bounds.
\code{gsBoundSummary()} summarizes a bound for a group sequential design with by computing several of these design characteristics. \code{xtable.gsDesign} produces Latex output of boundary summary information; intended for use with \code{Sweave()}.

Individual transformation of z-value test statistics for interim and final analyses are obtained from
\code{gsBValue()}, \code{gsDelta()}, \code{gsHR()} and \code{gsCPz()} for B-values, approximate treatment effect (see details), approximate hazard ratio and conditional power, respectively.
}

\usage{
    gsBValue <- function(z, i, x, ylab="B-value", ...)
    gsDelta(z, i, x, ylab=NULL, ...)
    gsHR(z, i, x, ratio=1, ylab="Estimated hazard ratio", ...)
    gsCPz(z, i, x, theta=NULL, ylab=NULL, ...)
    gsBoundSummary(x, upper=TRUE, ratio=1)
    xtable.gsDesign(x, caption=NULL, label=NULL, align=NULL, digits=c(0,0,3,4,4,4,3,3,3,3),
                             display=NULL, upper=TRUE, rnames=NULL, cnames=NULL, ratio=1,
                             sanitize.text.function=function(x){x}, 
                             sanitize.rownames.function=function(x){x},...)
}

\arguments{
	\item{x}{A \code{gsDesign} object}
	\item{upper}{If TRUE, upper bound is summarized. If FALSE, lower bound is summarized}
	\item{z}{A vector of z-statistics}
	\item{i}{A vector containing the analysis for each element in \code{z}; each element must be in 1 to \code{x$k}, inclusive}
	\item{theta}{A scalar value used for conditional power calculations; see \code{gsDesign}; if NULL, conditional power is computed at the estimated interim treatment effect based on \code{z}}
	\item{ylab}{Used when functions are passed to \code{plot.gsDesign} to establish default y-axis labels}
	\item{ratio}{Used only for time-to-event studies; randomization ratio for experimental versus control group}
	\item{digits}{An integer vector containing the digits to be displayed for each row}
	\item{rnames}{Allows user to override default row names for output matrix}
	\item{cnames}{Allows user to override default column names for output matrix}
	\item{...}{This allows many optional arguments that are standard when calling \code{xtable} and \code{plot}}
	\item{caption}{See dcoumentation for \code{xtable}}
	\item{label}{See dcoumentation for \code{xtable}}
	\item{align}{See dcoumentation for \code{xtable}}
	\item{display}{See dcoumentation for \code{xtable}}
   \item{sanitize.text.function}{Should be able to use default; see documentation for \code{xtable}}, 
   \item{sanitize.rownames.function}{Should be able to use default; see documentation for 
\code{xtable} and \code{print}}
}

\value{
\code{gsBValue()}, \code{gsDelta()}, \code{gsHR()} and \code{gsCPz()} each returns a vector containing the B-values, approximate treatment effect (see details), approximate hazard ratio and conditional power, respectively, for each value specified by the interim test statistics in \code{z} at interim analyses specified in \code{i}.

\code{gsBoundSummary} returns an matrix. The rows correspond to the analyses planned in \code{x}. 
For each interim, the columns provide 1) timing (\%), 2) sample size ("N"), events ("Events") or sample size inflation relative to a fixed design ("r"), 3) Z, 4) nominal p-value (upper tail for upper bound, lower tail for lower bound), 5) cumulative boundary crossing probability (spend) under the null hypothesis, 6) cumulative spend under the alternate hypothesis, 7) conditional power at the bound assuming the alternate hypothesis treatment effect, 8) conditional power at the bound assuming the interim trend, 9) treatment effect at the boundary (hazard ratio for time-to-event endpoint studies), 10) B-value.
}

\details{See examples and manual}

\seealso{\link{gsDesign}, \link{Plots for group sequential designs}, \code{\link{gsProbability}}}

\note{The manual is not linked to this help file, but is available in library/gsdesign/doc/gsDesignManual.pdf
in the directory where R is installed.}

\author{Keaven Anderson \email{keaven\_anderson@merck.}}
\references{
Jennison C and Turnbull BW (2000), \emph{Group Sequential Methods with Applications to Clinical Trials}.
Boca Raton: Chapman and Hall.
}

\examples{
# derive group sequential bound
x <- gsDesign(n.fix=100)

# upper bound summary
gsBoundSummary(x)

# lower bound summary
gsBoundSummary(x, upper=FALSE)

# print upper bound summary in latex format
xtable(x)

# print lower bound summary in latex format
xtable(x, upper=FALSE)

# now derive a design with a time-to-event endpoint
# note that by specifying endpoint="Survival", hazard ratio replaces treatment effect
ns <- nSurvival()
xs <- gsDesign(n.fix=ns$nEvents, nFixSurv=ns$n, endpoint="Survival")
gsBoundSummary(xs)
# generate some of the above summary statistics for the upper bound
z <- xs$upper$bound
# B-values
gsBValue(z=z, i=1:3, x=xs)
# hazard ratio
gsHR(z=z, i=1:3, x=xs)
# conditional power at observed treatment effect
gsCPz(z=z[1:2], i=1:2, x=xs)
# conditional pwoer at H1 treatment effect
gsCPz(z=z[1:2], i=1:2, x=xs, theta=xs$delta)

# now look at a binomial endpoint; specify H0 treatment difference as p1-p2=.05
# now treatment effect at bound (say, thetahat) is transformed to 
# xp$delta0 + xp$delta1*(thetahat-xp$delta0)/xp$delta  
np <- nBinomial(p1=.15, p2=.10)
xp <- gsDesign(n.fix=np, endpoint="Binomial", delta1=.05)
gsBoundSummary(xp)
# estimate treatment effect at lower bound
# by setting delta0=0 (default) and delta1 above in gsDesign
# treatment effect at bounds is scaled to these differences
# in this case, this is the difference in event rates
gsDelta(z=xp$lower$bound, i=1:3, xp)
}

\name{sfLogistic}
\alias{sfLogistic}
\alias{sfNormal}
\alias{sfExtremeValue}
\alias{sfExtremeValue2}
\alias{sfCauchy}
\alias{sfBetaDist}

\title{4.6: Two-parameter Spending Function Families}
\description{The functions \code{sfLogistic()}, \code{sfNormal()}, \code{sfExtremeValue()}, \code{sfExtremeValue2()}, \code{sfCauchy()}, 
and \code{sfBetaDist()} are all 2-parameter spending function families.
These provide increased flexibility in some situations where the flexibility of a one-parameter spending function 
family is not sufficient.
These functions all allow fitting of two points on a cumulative spending function curve; in this case, four parameters
are specified indicating an x and a y coordinate for each of 2 points.
Normally each of these functions will be passed to \code{gsDesign()} in the parameter 
\code{sfu} for the upper bound or
\code{sfl} for the lower bound to specify a spending function family for a design.
In this case, the user does not need to know the calling sequence.
The calling sequence is useful, however, when the user wishes to plot a spending function as demonstrated in the examples; note, however, that an automatic \eqn{\alpha}{alpha}- and \eqn{\beta}{beta}-spending function plot is also available.
}

\usage{
sfLogistic(alpha, t, param)
sfNormal(alpha, t, param)
sfExtremeValue(alpha, t, param)
sfExtremeValue2(alpha, t, param)
sfCauchy(alpha, t, param)
sfBetaDist(alpha, t, param)
}
\arguments{
	\item{alpha}{Real value \eqn{> 0} and no more than 1. Normally, 
\code{alpha=0.025} for one-sided Type I error specification
	or \code{alpha=0.1} for Type II error specification. However, this could be set to 1 if for descriptive purposes
	you wish to see the proportion of spending as a function of the proportion of sample size or information.}
	\item{t}{A vector of points with increasing values from 0 to 1, inclusive. Values of the proportion of 
	sample size or information for which the spending function will be computed.}
	\item{param}{In the two-parameter specification, \code{sfBetaDist()} requires 2 positive values, while
	\code{sfLogistic()}, \code{sfNormal()}, \code{sfExtremeValue()}, \code{sfExtremeValue2()} and \code{sfCauchy()} require the first parameter 
	to be any real value and the second to be a positive value. 
	The four parameter specification is \code{c(t1,t2,u1,u2)}
	where the objective is that \code{sf(t1)=alpha*u1} and \code{sf(t2)=alpha*u2}.
	In this parameterization, all four values must be between 0 and 1 and \code{t1 < t2}, \code{u1 < u2}.}
}
\value{An object of type \code{spendfn}. See \code{\link{Spending function overview}} for further details.}
\details{
\code{sfBetaDist(alpha,t,param)} is simply \code{alpha} times the incomplete beta cumulative distribution 
function with parameters
\eqn{a} and \eqn{b} passed in \code{param} evaluated at values passed in \code{t}. 

The other spending functions take the form
\deqn{f(t;\alpha,a,b)=\alpha F(a+bF^{-1}(t))}{f(t;alpha,a,b)=alpha F(a+bF^{-1}(t))}
where \eqn{F()} is a cumulative distribution function with values \eqn{> 0} on the real line (logistic for \code{sfLogistic()}, 
normal for \code{sfNormal()}, extreme value for \code{sfExtremeValue()} and Cauchy for \code{sfCauchy()}) and
\eqn{F^{-1}()} is its inverse.

For the logistic spending function this simplifies to
\deqn{f(t;\alpha,a,b)\alpha (1-(1+e^a(t/(1-t))^b)^{-1}).}

For the extreme value distribution with \deqn{F(x)=\exp(-\exp(-x))} this simplifies to 
\deqn{f(t;\alpha,a,b)=\alpha \exp(-e^a (-\ln t)^b).} 
Since the extreme value distribution is not symmetric, there is also a version
where the standard distribution is flipped about 0. This is reflected in \code{sfExtremeValue2()} where
\deqn{F(x)=1-\exp(-\exp(x)).}
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
# design a 4-analysis trial using a Kim-DeMets spending function 
# for both lower and upper bounds 
x<-gsDesign(k=4, sfu=sfPower, sfupar=3, sfl=sfPower, sflpar=1.5)

# print the design
x

# plot the alpha- and beta-spending functions
plot(x, plottype=5)

# start by showing how to fit two points with sfLogistic
# plot the spending function using many points to obtain a smooth curve
# note that curve fits the points x=.1,  y=.01 and x=.4,  y=.1 
# specified in the 3rd parameter of sfLogistic
t <- 0:100/100
plot(t,  sfLogistic(1, t, c(.1, .4, .01, .1))$spend, 
    xlab="Proportion of final sample size", 
    ylab="Cumulative Type I error spending", 
    main="Logistic Spending Function Examples", 
    type="l", cex.main=.9)
lines(t, sfLogistic(1, t, c(.01, .1, .1, .4))$spend, lty=2)

# now just give a=0 and b=1 as 3rd parameters for sfLogistic 
lines(t, sfLogistic(1, t, c(0, 1))$spend, lty=3)

# try a couple with unconventional shapes again using the xy form in the 3rd parameter
lines(t, sfLogistic(1, t, c(.4, .6, .1, .7))$spend, lty=4)
lines(t, sfLogistic(1, t, c(.1, .7, .4, .6))$spend, lty=5)
legend(x=c(.0, .475), y=c(.76, 1.03), lty=1:5, 
legend=c("Fit (.1, 01) and (.4, .1)", "Fit (.01, .1) and (.1, .4)", 
    "a=0,  b=1", "Fit (.4, .1) and (.6, .7)", "Fit (.1, .4) and (.7, .6)"))

# set up a function to plot comparsons of all 2-parameter spending functions
plotsf <- function(alpha, t, param)
{   
    plot(t, sfCauchy(alpha, t, param)$spend, xlab="Proportion of enrollment", 
    ylab="Cumulative spending", type="l", lty=2)
    lines(t, sfExtremeValue(alpha, t, param)$spend, lty=5)
    lines(t, sfLogistic(alpha, t, param)$spend, lty=1)
    lines(t, sfNormal(alpha, t, param)$spend, lty=3)
    lines(t, sfExtremeValue2(alpha, t, param)$spend, lty=6, col=2)
    lines(t, sfBetaDist(alpha, t, param)$spend, lty=7, col=3)
    legend(x=c(.05, .475), y=.025*c(.55, .9), lty=c(1, 2, 3, 5, 6, 7), 
             col=c(1, 1, 1, 1, 2, 3), 
        legend=c("Logistic", "Cauchy", "Normal", "Extreme value", 
        "Extreme value 2", "Beta distribution"))
}
# do comparison for a design with conservative early spending
# note that Cauchy spending function is quite different from the others
param <- c(.25, .5, .05, .1)
plotsf(.025, t, param)
}
\keyword{design}

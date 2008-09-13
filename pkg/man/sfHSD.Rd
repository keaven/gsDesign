\name{sfHSD}
\alias{sfHSD}
\title{4.1: Hwang-Shih-DeCani Spending Function}
\description{The function \code{sfHSD} implements a Hwang-Shih-DeCani spending function.
This is the default spending function for \code{gsDesign()}.
Normally it will be passed to \code{gsDesign} in the parameter \code{sfu} for the upper bound or
\code{sfl} for the lower bound to specify a spending function family for a design.
In this case, the user does not need to know the calling sequence.
The calling sequence is useful, however, when the user wishes to plot a spending function as demonstrated below
in examples.
}

\usage{sfHSD(alpha,t,param)}
\arguments{
	\item{alpha}{Real value > 0 and no more than 1. Normally, alpha=0.025 for one-sided Type I error specification
	or 0.1 for Type II error specification. However, this could be set to 1 if for descriptive purposes
	you wish to see the proportion of spending as a function of the proportion of sample size/information.}
	\item{t}{A vector of points with increasing values from 0 to 1, inclusive. Values of the proportion of 
	sample size/information for which the spending function will be computed.}
	\item{param}{A single real value specifying the gamma parameter for which Hwang-Shih-DeCani spending
	is to be computed}
}
\value{An object of type \code{spendfn}. See \link{Spending Functions} for further details.}
\details{
A Hwang-Shih-DeCani spending function takes the form
\deqn{
\alpha(1-e^{-\gamma t})/(1-e^{-\gamma})} where \eqn{\gamma} is the value passed in \code{param}.
A value of \eqn{\gamma=-4} is used to approximate an O'Brien-Fleming design (see \link{sfexp} for a better fit), 
while a value of \eqn{gamma=1} approximates a Pocock design well.
}
\seealso{\link{Spending Functions}, \code{\link{gsDesign}}, \link{gsDesign-package}}
\note{The manual is not linked to this help file, but is available in library/gsdesign/doc/manual.pdf
in the directory where R is installed.}

\author{Keaven Anderson \email{keaven\_anderson@merck.com}}
\references{
Jennison C and Turnbull BW (2000), \emph{Group Sequential Methods with Applications to Clinical Trials}.
Boca Raton: Chapman and Hall.
}

\examples{
# design a 4-analysis trial using a Hwang-Shih-DeCani spending function 
# for both lower and upper bounds 
x<-gsDesign(k=4,sfu=sfHSD,sfupar=-2,sfl=sfHSD,sflpar=1)
# print the design
x
# since sfHSD is the default for both sfu and sfl, this could have been written as
x<-gsDesign(k=4,sfupar=-2,sflpar=1)
# print again
x

# plot the spending function using many points to obtain a smooth curve
# show default values of gamma to see how the spending function changes
# also show gamma=1 which is supposed to approximate a Pocock design
plot(0:100/100, sfHSD(0.025,0:100/100,-4)$spend,xlab="Proportion of final sample size",
ylab="Cumulative Type I error spending",
main="Hwang-Shih-DeCani Spending Function Example",type="l")
lines(0:100/100,sfHSD(0.025,0:100/100,-2)$spend,lty=2)
lines(0:100/100,sfHSD(0.025,0:100/100,1)$spend,lty=3)
legend(x=c(.0,.375),y=.025*c(.8,1),lty=1:3,
legend=c("gamma= -4","gamma= -2","gamma= 1"))
}
\keyword{design}


\name{ssrCP}
\alias{ssrCP}
\title{Sample size re-estimation based on conditional power}
\description{
\code{ssrCP()} is used with 2-stage designs to update sample size at an interim analysis based on conditional power.
Either the estimated treatment effect at the interim analysis or any chosen effect size can be used for sample size re-estimation.
If not done carefully, these designs can be very inefficient. It is probably a good idea to compare any design to a simpler group sequential design; see, for example, Jennison and Turnbull, Statistics in Medicine, 2003.
Method assumes a small Type I error is included with the interim analysis and that the design is an adaptation from a 2-stage group sequential design (Lehmacher and Wassmer, Biometrics, 1999).}
\usage{
ssrCP(z, theta = NULL, maxinc = 2, overrun = 0, beta = 0.1, 
      cpadj = c(0.5, 1 - beta), 
      x = gsDesign(k = 2, timing = 0.5, beta = beta))
}
\arguments{
  \item{z}{Scalar or vector with interim standardized Z-value(s). Input of multiple values makes it easy to plot the revised sample size as a function of the interim test statistic.}
  \item{theta}{If \code{NULL} (default), conditional power calculation will be based on estimated interim treatment effect. Otherwise, \code{theta} is the standardized effect size used for conditional power calculation. Using the alternate hypothesis treatment effect can be more efficient than the estimated effect size; see Liu and Chi, Biometrics, 2001.
There is a large literature for designs with conditional power; two commonly discussed methods allowing use of sufficient statistics for testing rather than combination tests have been proposed by Chen, DeMets and Lan, 2004, and Mehta and Pocock, 200x
}
  \item{maxinc}{Maximum-fold increase in sample size from planned sample size.}
  \item{overrun}{Number of patients enrolled but not analyzed at interim analysis.}
  \item{beta}{Targeted Type II error (1 - targeted conditional power)}
  \item{cpadj}{Interval of conditional power values for which sample size is to be increased.}
  \item{x}{2-stage group sequential design generated using \code{gsDesign().}}
}
\details{See references and examples.}
\value{The initial version of \code{ssrCP()} returns a vector of sample sizes corresponding to the interim test statistics supplied in \code{z}.}
\references{
Chen, YHJ, DeMets, DL and Lan, KKG. Increasing the sample size when the unblinded interim result is promising, Statistics in Medicine,
23:1023-1038, 2004.

Jennison, C and Turnbull, BW.  Mid-course sample size modification in clinical trials based on the observed treatment effect. Statistics in Medicine, 22:971-993", 2003.

Lehmacher, W and Wassmer, G. Adaptive sample size calculations in group sequential trials, Biometrics, 55:1286-1290, 1999.

Liu, Q and Chi, GY.,  On sample size and inference for two-stage adaptive designs, Biometrics, 57:172-177, 2001.

Mehta, C and Pocock, S. Adaptive increase in sample size when interim results are promising: A practical guide with examples, Statistics in Medicine, 30:3267-3284, 2011.
}
\seealso{\code{\link{gsDesign}}}

\author{Keaven Anderson \email{keaven\_anderson@merck.}}

\examples{
# timing of interim analysis
timing <- .5
# upper spending function 
sfu <- sfHSD
# upper spending function paramater
sfupar <- -12
# maximum sample size inflation
maxinflation <- 2
# assumed enrollment overrrun at IA
overrun <- 25
# interim z-values for plotting
z <- seq(0,4,.025)
# Type I error (1-sided)
alpha <- .025
# Type II error for design
beta <- .1
# Fixed design sample size
n.fix <- 100
# conditional power interval where sample 
# size is to be adjusted
cpadj <- c(.3,.9)
# targeted Type II error when adapting sample size
betastar <- beta

# generate a 2-stage group sequential design with 
# desired planned sample size (first 2 lines set planned sample size to that from above; normally)
x<-gsDesign(k=2,n.fix=n.fix,timing=timing,sfu=sfu,sfupar=sfupar,
            alpha=alpha,beta=beta)
nalt <- maxinflation*(x$n.I[2])
par(mar=c(7, 4, 4, 4)+.1)
plot(z,ssrCP(x=x,z=z,overrun=overrun,beta=betastar,cpadj=cpadj),
     type="l",xlim=c(0,3.5),axes=FALSE,xlab="",ylab="")
lines(z,80+240*dnorm(z,mean=0),col=2)
lines(z,80+240*dnorm(z,mean=sqrt(x$n.I[1])*x$theta[2]),col=3)
lines(z,80+240*dnorm(z,mean=sqrt(x$n.I[1])*x$theta[2]/2),col=4)
lines(z,80+240*dnorm(z,mean=sqrt(x$n.I[1])*x$theta[2]*.75),col=5)
axis(side=2, at=75+25*(0:5), labels=as.character(75+25*(0:5))) 
mtext(side=2,"Sample size",line=2)
axis(side=4, at=80+240*seq(0,.4,.1), labels=as.character(seq(0,.4,.1))) 
mtext(side=4,expression(paste("Density for ",z[1])),line=2)
lines(x=c(-3.5,3.5),y=c(nalt,nalt),lty=2)
w <- x$timing[1]
theta <- seq(.5,3.5,.5) / sqrt(x$n.I[1])
CP <- pnorm(theta*sqrt(x$n.I[2]*(1-w))-(x$upper$bound[2]-
        seq(.5,3.5,.5)*sqrt(w))/sqrt(1-w))
axis(side=1,line=3,at=seq(.5,3.5,.5),labels=as.character(round(CP,2)))
mtext(side=1,"CP",line=3.5,at=.25)
axis(side=1,line=1,at=seq(0,3.5,.5),labels=as.character(seq(0,3.5,.5)))
mtext(side=1,expression(z[1]),line=.75,at=-.15)
axis(side=1,line=5,at=seq(.5,3.5,.5),labels=as.character(round(theta/x$theta[2],2)))
mtext(side=1,expression(hat(theta)/theta[1]),line=5.5,at=.25)
}
\keyword{design}

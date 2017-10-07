\name{sfLDOF}
\alias{sfLDOF}
\alias{sfLDPocock}
\title{4.4: Lan-DeMets Spending function overview}
\description{
Lan and DeMets (1983) first published the method of using spending functions to set boundaries for group sequential trials.
In this publication they proposed two specific spending functions:
one to approximate an O'Brien-Fleming design and the other to approximate a Pocock design.
The spending function to approximate O'Brien-Fleming has been generalized as proposed by Liu, et al (20) 
}

\usage{
sfLDOF(alpha, t, param=1)
sfLDPocock(alpha, t, param)
}
\arguments{
	\item{alpha}{Real value \eqn{> 0} and no more than 1. Normally, 
\code{alpha=0.025} for one-sided Type I error specification
	or \code{alpha=0.1} for Type II error specification. However, this could be set to 1 if for descriptive purposes
	you wish to see the proportion of spending as a function of the proportion of sample size/information.}
	\item{t}{A vector of points with increasing values from 0 to 1, inclusive. Values of the proportion of 
	sample size/information for which the spending function will be computed.}
	\item{param}{This parameter is not used for \code{sfLDPocock}, not required for \code{sfLDOF} and need not be specified. 
	For \code{sfLDPocock} it is here so that the calling sequence conforms 
	the to the standard for spending functions used with \code{gsDesign()}.
	For \code{sfLDOF} it will default to 1 (Lan-DeMets function to approximate O'Brien-Fleming) if \code{NULL} or if outside of the range \code{[.005,2]}.
	otherwise, it will be use to set rho from Liu et al (2012).}
}
\value{An object of type \code{spendfn}. See spending functions for further details.}
\details{
With \code{param=1=rho}, the Lan-DeMets (1983) spending function to approximate an
O'Brien-Fleming bound is implemented in the function (\code{sfLDOF()}):
\deqn{f(t; \alpha)=2-2\Phi\left(\Phi^{-1}(1-\alpha/2)/ t^{\rho/2}\right).}{%
f(t; alpha)=2-2*Phi(Phi^(-1)(1-alpha/2)/t^(rho/2)\right)}
For \code{rho} otherwise in \code{[.005,2]}, this is the generalized version of Liu et al (2012).
For \code{param} outside of \code{[.005,2]}, \code{rho} is set to 1. 
The Lan-DeMets (1983) spending function to approximate a Pocock design is implemented in the function \code{sfLDPocock()}:
\deqn{f(t;\alpha)=ln(1+(e-1)t).}{f(t;alpha)=ln(1+(e-1)t).}
As shown in examples below, other spending functions can be used to get as good or better approximations to Pocock and
O'Brien-Fleming bounds. In particular, O'Brien-Fleming bounds can be closely approximated using \code{\link{sfExponential}}.
}
\seealso{\link{Spending function overview}, \code{\link{gsDesign}}, \link{gsDesign package overview}}
\note{The manual is not linked to this help file, but is available in library/gsdesign/doc/gsDesignManual.pdf
in the directory where R is installed.}

\author{Keaven Anderson \email{keaven\_anderson@merck.}}
\references{
Jennison C and Turnbull BW (2000), \emph{Group Sequential Methods with Applications to Clinical Trials}.
Boca Raton: Chapman and Hall.

Lan, KKG and DeMets, DL (1983), Discrete sequential boundaries for clinical trials. \emph{Biometrika};70: 659-663.

Liu, Q, Lim, P, Nuamah, I, and Li, Y (2012), On adaptive error spending approach for group sequential trials with random information levels. \emph{Journal of biopharmaceutical statistics}; 22(4), 687-699.
}

\examples{
# 2-sided,  symmetric 6-analysis trial Pocock
# spending function approximation 
gsDesign(k=6, sfu=sfLDPocock, test.type=2)$upper$bound

# show actual Pocock design
gsDesign(k=6, sfu="Pocock", test.type=2)$upper$bound

# approximate Pocock again using a standard
# Hwang-Shih-DeCani approximation
gsDesign(k=6, sfu=sfHSD, sfupar=1, test.type=2)$upper$bound

# use 'best' Hwang-Shih-DeCani approximation for Pocock,  k=6;
# see manual for details
gsDesign(k=6, sfu=sfHSD, sfupar=1.3354376, test.type=2)$upper$bound

# 2-sided, symmetric 6-analysis trial
# O'Brien-Fleming spending function approximation 
gsDesign(k=6, sfu=sfLDOF, test.type=2)$upper$bound

# show actual O'Brien-Fleming bound
gsDesign(k=6, sfu="OF", test.type=2)$upper$bound

# approximate again using a standard Hwang-Shih-DeCani 
# approximation to O'Brien-Fleming
x<-gsDesign(k=6, test.type=2)
x$upper$bound
x$upper$param

# use 'best' exponential approximation for k=6; see manual for details
gsDesign(k=6, sfu=sfExponential, sfupar=0.7849295,
         test.type=2)$upper$bound
         
# plot spending functions for generalized Lan-DeMets approximation of
# O'Brien-Fleming (from Liu et al, 2012)
ti <-(0:100)/100
rho <- c(.05,.5,1,1.5,2,2.5,3:6,8,10,12.5,15,20,30,200)/10
df <- NULL
for(r in rho){
  df <- rbind(df,data.frame(t=ti,rho=r,alpha=.025,spend=sfLDOF(alpha=.025,t=ti,param=r)$spend))
}
ggplot(df,aes(x=t,y=spend,col=as.factor(rho)))+geom_line()+guides(col=guide_legend(expression(rho)))+
  ggtitle("Generalized Lan-DeMets O'Brien-Fleming Spending Function")

}
\keyword{design}

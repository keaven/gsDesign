## ----setup, include = FALSE----------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----enrollment, message=FALSE, echo=FALSE, results="hide"---------------
# code here applies to both fixed and group sequential design sections below.
library(gsDesign)
# enrollment period durations; the last of these will be extended if T=NULL below
R <- c(1,2,3,4)
# relative enrollment rates during above periods
gamma<-c(1,1.5,2.5,4)
# study duration
# T can be set to NULL if you want to 
# fix enrollment and vary study duration
T <- 36 
# follow-up duration of last patient enrolled
minfup <- 12
# randomization ratio, experimental/control
ratio <- 1
# median control time-to-event
median <- 12
# exponential dropout rate per unit of time
eta <- .001
# hypothesized experimental/control hazard ratio
hr <- .75
# null hazard ratio (1 for superiority, >1 for non-inferiority)
hr0 <- 1
# Type I error (1-sided)
alpha <-.025
# Type II error (1-power)
beta<-.2
x <- nSurv(R=R,gamma=gamma,eta=eta,minfup=minfup,
           T=T,lambdaC=log(2)/median,
           hr=hr,hr0=hr0,beta=beta,alpha=alpha)
# time units
timename <- "months"
timename1 <- "month"
# endpoint name
ep <-"overall survival" 
# make a string with enrollment rates (assumes gamma is a single value or vector)
nR <- length(x$R)
if (nR==1){enrolrates <- paste("constant at a rate of ",round(gamma,1),"per",timename1,".")
} else{
enrolrates <- paste(c("piecewise constant at rates of ",
 paste(round(as.vector(x$gamma),1)," for ",timename," ",cumsum(c(0,x$R[1:(nR-1)])),
       "-",cumsum(x$R),collapse=", "),sep=""),collapse="")
}


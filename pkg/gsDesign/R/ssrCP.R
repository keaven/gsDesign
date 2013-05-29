ssrCP <- function(z, theta=NULL, maxinc=2, overrun=0, beta = 0.1, cpadj=c(.5,1-beta), x=gsDesign(k=2, timing=.5, beta=beta)){
  if (class(x)!="gsDesign") stop("x must be passed as an object of class gsDesign")
  if (2 != x$k) stop("input group sequential design must have 2 stages (k=2)")
  w <- x$timing[1]
  if (is.null(theta)) theta <- z / sqrt(x$n.I[1])
  CP <- pnorm(theta*sqrt(x$n.I[2]*(1-w))-(x$upper$bound[2]-z*sqrt(w))/sqrt(1-w))
  n2 <- array(x$n.I[1]+overrun,length(z))
  indx <- ((z>x$lower$bound[1])&(z<x$upper$bound[1]))
  indx2 <- indx & ((CP < cpadj[1])|(CP>cpadj[2]))
  n2[indx2] <- x$n.I[2]
  indx <- indx & !indx2
  n2[indx] <- (((x$upper$bound[2] - z[indx] * sqrt(w)) / sqrt(1 - w) - qnorm(beta))/theta[indx])^2 + x$n.I[1]
  n2[n2>maxinc*x$n.I[2]]<-maxinc*x$n.I[2]
  return(n2)
}
# Type I error if sufficient statistic used instead of
# combination test

#unadjTypeIErr <- function(maxinc=2, beta = 0.1, cpadj=c(.5,1-beta), 
#                          x=gsDesign(k=2, timing=.5, beta=beta)){
#  z <- normalGrid() # grid for interim z
#  B <- sqrt(x$timing[1])*z # interim B-value
#  thetahat <- z/sqrt(n.I[1]) # interim standardized effect size
#  cp <-
  # stage 2 sample size
#  n2 <- ssrCP(z=z,maxinc=maxinc,beta=beta,cpadj=cpadj,x=x)
  # Type I error for non-promising zone
  # assuming non-binding futility
  
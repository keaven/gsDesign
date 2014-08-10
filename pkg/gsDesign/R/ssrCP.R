# conditional power function
"condPower" <- function(z1, n2, z2=z2NC, theta=NULL, 
                x=gsDesign(k=2, timing=.5, beta=beta),
                ...){
  if (is.null(theta)) theta <- z1 / sqrt(x$n.I[1])
  return(as.numeric(pnorm(sqrt(n2)*theta-
                            z2(z1=z1,x=x,n2=n2))))
}



"condPowerDiff" <- function(z1, target, n2, z2=z2NC,
                            theta=NULL,
                            x=gsDesign(k=2,timing=.5)){
  if (is.null(theta)) theta <- z1 / sqrt(x$n.I[1])
  return(as.numeric(pnorm(sqrt(n2)*theta-
                            z2(z1=z1,x=x,n2=n2))-target))
}



"n2sizediff" <- function(z1, target, beta=.1, z2=z2NC, 
                         theta=NULL, 
                         x=gsDesign(k=2, timing=.5, beta=beta)){
  if (is.null(theta)) theta <- z1 / sqrt(x$n.I[1])
  return(as.numeric(((z2(z1=z1,x=x,n2=target-x$n.I[1]) - 
                        qnorm(beta))/theta)^2 + x$n.I[1] - 
                      target))
}

ssrCP <- function(z1, theta=NULL, maxinc=2, overrun=0, 
                  beta = x$beta, cpadj=c(.5,1-beta), 
                  x=gsDesign(k=2, timing=.5),
                  z2=z2NC,...){
  if (class(x)!="gsDesign")
    stop("x must be passed as an object of class gsDesign")
  if (2 != x$k) 
    stop("input group sequential design must have 2 stages (k=2)")
  if (overrun <0 | overrun + x$n.I[1]>x$n.I[2])
    stop(paste("overrun  must be >= 0 and",
               " <= 2nd stage sample size (",
          round(x$n.I[2]-x$n.I[1],2),")",sep=""))
  checkVector(x=z1,interval=c(-Inf,Inf), 
              inclusion=c(FALSE,FALSE))
  checkScalar(maxinc,interval=c(1,Inf), 
              inclusion=c(FALSE,TRUE))
  checkVector(cpadj,interval=c(0,1), 
              inclusion=c(FALSE,FALSE),length=2)
  if (cpadj[2]<=cpadj[1]) 
    stop(paste("cpadj must be an increasing pair", 
               "of numbers between 0 and 1"))
  n2 <- array(x$n.I[1]+overrun,length(z1))
  temtheta <- theta
  if (is.null(theta))theta <- z1 / sqrt(x$n.I[1])
  # compute conditional power for group sequential design
  # for given z1
  CP <- condPower(z1, n2=x$n.I[2]-x$n.I[1], z2=z2, 
                  theta=theta, x=x, ...)
  # continuation range
  indx <- ((z1 > x$lower$bound[1]) & 
           (z1 < x$upper$bound[1]))
  # where final sample size will not be adapted
  indx2 <- indx & ((CP < cpadj[1]) | (CP>cpadj[2]))
  # in continuation region with no adaptation, use planned final n
  n2[indx2] <- x$n.I[2]
  # now set where you will adapt
  indx2 <- indx & !indx2
  # update sample size based on combination function  
  # assuming original stage 2 sample size
  z2i <- z2(z1=z1[indx2], x=x, n2=x$n.I[2]-x$n.I[1],...)
  if (length(theta)==1){
    n2i <- ((z2i - qnorm(beta)) / theta)^2 + x$n.I[1]
  }else{
    n2i <- ((z2i - qnorm(beta)) / theta[indx2])^2 + x$n.I[1]
  }
  n2i[n2i/x$n.I[2] > maxinc] <- x$n.I[2]*maxinc
  # if conditional error depends on stage 2 sample size,
  # do fixed point iteration to get conditional error
  # and stage 2 sample size to correspond
  if (class(z2i)[1] == "n2dependent"){
    for(i in 1:6){
      z2i <- z2(z1=z1[indx2], x=x, n2=n2i-x$n.I[1], ...)
      if (length(theta)==1){
        n2i <- ((z2i - qnorm(beta))/theta)^2 + x$n.I[1]
      }else{
        n2i <- ((z2i - qnorm(beta))/theta[indx2])^2 + 
          x$n.I[1]
      }
      n2i[n2i/x$n.I[2] > maxinc] <- x$n.I[2]*maxinc
    }
  }
  n2[indx2] <- n2i
  if (length(theta)==1) theta <- array(theta,length(n2))
  rval <- list(x=x, z2fn=z2, theta=temtheta, maxinc=maxinc, 
               overrun=overrun, beta=beta, cpadj=cpadj, 
               dat=data.frame(z1=z1, 
                        z2=z2(z1=z1, x=x, n2=x$n.I[2], ...), 
                        n2=n2, CP=CP, theta=theta,
                        delta=x$delta0+theta*(x$delta1-x$delta0)))
  class(rval) <- "ssrCP"
  return(rval)
}



plot.ssrCP <- function(x, z1ticks=NULL, mar=c(7, 4, 4, 4)+.1, ylab="Adapted sample size", xlaboffset=-.2, lty=1, col=1,...){
  par(mar=mar)
  plot(x$dat$z1, x$dat$n2,type="l", axes=FALSE, xlab="", ylab="", lty=lty, col=col,...)
  xlim <- par("usr")[1:2] # get x-axis range
  axis(side=2, ...)
  mtext(side=2, ylab, line=2,...)
  w <- x$x$timing[1]
  if (is.null(z1ticks)) z1ticks <- seq(ceiling(2*xlim[1])/2, floor(2*xlim[2])/2, by=.5)
  theta <- z1ticks / sqrt(x$x$n.I[1])
  CP <- pnorm(theta*sqrt(x$x$n.I[2]*(1-w))-(x$upper$bound[2]-z1ticks*sqrt(w))/sqrt(1-w))
  CP <- condPower(z1=z1ticks,x=x$x,cpadj=x$cpadj,n2=x$x$n.I[2]-x$x$n.I[1])
  axis(side=1,line=3,at=z1ticks,labels=as.character(round(CP,2)), ...)
  mtext(side=1,"CP",line=3.5,at=xlim[1]+xlaboffset,...)
  axis(side=1,line=1,at=z1ticks, labels=as.character(z1ticks),...)
  mtext(side=1,expression(z[1]),line=.75,at=xlim[1]+xlaboffset,...)
  axis(side=1,line=5,at=z1ticks, labels=as.character(round(theta/x$x$delta,2)),...)
  mtext(side=1,expression(hat(theta)/theta[1]),line=5.5,at=xlim[1]+xlaboffset,...)
}



# normal combination test cutoff for z2
"z2NC" <- function(z1,x,...){
  z2 <- (x$upper$bound[2] - z1*sqrt(x$timing[1])) / 
    sqrt(1-x$timing[1])
  class(z2) <- c("n2independent","numeric")
  return(z2)
}
# sufficient statistic cutoff for z2
"z2Z" <- function(z1,x,n2=x$n.I[2]-x$n.I[1],...){
  N2 <- x$n.I[1] + n2
  z2 <- (x$upper$bound[2]-z1*sqrt(x$n.I[1]/N2)) / 
    sqrt(n2/N2)
  class(z2) <- c("n2dependent","numeric")
  return(z2)
}
# Fisher's combination text
"z2Fisher" <- function(z1,x,...){
  z2 <- z1
  indx <- pchisq(-2*log(pnorm(-z1)), 4, lower.tail=F) <= 
    pnorm(-x$upper$bound[2])
  z2[indx] <- -Inf
  z2[!indx] <- qnorm(exp(-qchisq(pnorm(-x$upper$bound[2]), 
                                 df=4, lower.tail=FALSE) /
                           2-log(pnorm(-z1[!indx]))), 
                     lower.tail=FALSE)
  class(z2) <- c("n2independent","numeric")
  return(z2)
}
"Power.ssrCP" <- function(x, theta=NULL, delta=NULL, r=18){
  if (class(x) != "ssrCP") 
    stop("Power.ssrCP must be called with x of class ssrCP")
  if (is.null(theta) & is.null(delta)){
    theta <- (0:80)/40*x$x$delta
    delta <- (x$x$delta1-x$x$delta0)/x$x$delta*theta + x$x$delta0
  }else if(!is.null(theta)){delta <- (x$x$delta1-x$x$delta0)/x$x$delta*theta + x$x$delta0
  }else theta <- (delta-x$x$delta0)/(x$x$delta1-x$x$delta0)*x$x$delta
  en <- theta
  Power <- en
  mu <- sqrt(x$x$n.I[1])*theta
  # probability of stopping at 1st interim
  Power <- pnorm(x$x$upper$bound[1]-mu,lower.tail=FALSE)
  en <- (x$x$n.I[1]+x$overrun)*(Power + 
                                  pnorm(x$x$lower$bound[1]-mu))
  # get minimum and maximum conditional power at bounds
  cpmin <- condPower(z1=x$x$lower$bound[1], 
                     n2=x$x$n.I[2] - x$x$n.I[1], 
                     z2=x$z2fn, theta=x$theta, 
                     x=x$x, beta=x$beta)
  cpmax <- condPower(z1=x$x$upper$bound[1], 
                     n2=x$x$n.I[2] - x$x$n.I[1], 
                     z2=x$z2fn, theta=x$theta, 
                     x=x$x, beta=x$beta)
  # if max conditional power <= lower cp for which adjustment 
  # is done or min conditional power >= upper cp for which 
  # adjustment is done, no adjustment required
  if (cpmax <= x$cpadj[1] || cpmin >=x$cpadj[2]){
    en <- en + x$x$n.I[2] * (pnorm(x$x$upper$bound[1]-mu) - 
                               pnorm(x$x$lower$bound[1]-mu))
    a <- x$x$lower$bound[1]
    b <- x$x$upper$bound[2]
    n2 <- x$x$n.I[2]-x$x$n.I[1]
    grid <- normalGrid(mu=(a+b)/2,bounds=c(a,b),r=r)
    for(i in 1:length(theta)) Power[i] <- Power[i] +
      sum(dnorm(grid$z-sqrt(x$x$n.I[1])*theta[i]) * grid$gridwgts*
            pnorm(x$z2fn(grid$z, x=x$x, n2=n2)-theta[i]*sqrt(n2), 
                  lower.tail=FALSE))
    return(data.frame(theta=theta,delta=delta,Power=Power,en=en))
  }
  # check if minimum conditional power met at interim lower bound,
  # if not, compute probability of no SSR and accumulate
  if (cpmin<x$cpadj[1]){
    changepoint <- uniroot(condPowerDiff, 
                           interval=c(x$x$lower$bound[1], 
                                      x$x$upper$bound[1]), 
                           target=x$cpadj[1],
                           n2=x$x$n.I[2]-x$x$n.I[1], 
                           z2=x$z2fn, theta=x$theta, 
                           x=x$x)$root
    en <- en + x$x$n.I[2]*(pnorm(changepoint-mu) - 
                             pnorm(x$x$lower$bound[1]-mu))
    a <- x$x$lower$bound[1]
    b <- changepoint
    n2 <- x$x$n.I[2]-x$x$n.I[1]
    grid <- normalGrid(mu=(a+b)/2,
                       bounds=c(a,b),r=r)
    for(i in 1:length(theta)) Power[i] <- Power[i] +
      sum(dnorm(grid$z-sqrt(x$x$n.I[1]) * theta[i])*grid$gridwgts*
            pnorm(x$z2fn(grid$z, x=x$x, n2=n2)-theta[i]*
                    sqrt(n2), lower.tail=FALSE))
  }else changepoint <- x$x$lower$bound[1]
  # check if max cp exceeded at interim upper bound
  # if it is, compute probability of no final sample 
  # size increase just below upper bound
  if (cpmax >x$cpadj[2]){
    changepoint2 <- uniroot(condPowerDiff, 
                            interval=c(changepoint, x$x$upper$bound[1]), 
                            target=x$cpadj[2], n2=x$x$n.I[2]-x$x$n.I[1], 
                            z2=x$z2fn, theta=x$theta, x=x$x)$root
    en <- en + x$x$n.I[2]*(pnorm(x$x$upper$bound[1]-mu)-
                             pnorm(changepoint2-mu))
    a <- changepoint2
    b <- x$x$upper$bound[1]
    n2 <- x$x$n.I[2]-x$x$n.I[1]
    grid <- normalGrid(mu=(a+b)/2,bounds=c(a,b),r=r)
    for(i in 1:length(theta)) Power[i] <-  Power[i] +
      sum(dnorm(grid$z-sqrt(x$x$n.I[1])*theta[i]) * grid$gridwgts*
            pnorm(x$z2fn(grid$z, x=x$x, n2=n2)-theta[i]*sqrt(n2), 
                  lower.tail=FALSE))
  }else changepoint2 <- x$upper$bound[1]
  # next look if max sample size based on CP is greater than 
  # allowed if it is, compute en for interval at max sample size
  if (n2sizediff(z1=changepoint, target=x$maxinc*x$x$n.I[2], 
                 beta=x$beta, z2=x$z2fn, theta=x$theta, x=x$x)>0){
    # find point at which sample size based on cp 
    # is same as max allowed
    changepoint3 <- uniroot(condPowerDiff, 
                            interval=c(changepoint,15), 
                            target=1-x$beta, x=x$x, 
                            n2=x$maxinc*x$x$n.I[2]-x$x$n.I[1],
                            z2=x$z2fn, theta=x$theta)$root
  
    if (changepoint3 >= changepoint2){
      en <- en + x$maxinc*x$x$n.I[2]*(pnorm(changepoint2-mu)-
                                        pnorm(changepoint-mu))
      a <- changepoint
      b <- changepoint2
      n2 <- x$maxinc*x$x$n.I[2]-x$x$n.I[1]
      grid <- normalGrid(mu=(a+b)/2,bounds=c(a,b),r=r)
      for(i in 1:length(theta)) Power[i] <-  Power[i] +
        sum(dnorm(grid$z-sqrt(x$x$n.I[1])*theta[i]) * 
              grid$gridwgts *
              pnorm(x$z2fn(grid$z, x=x$x, n2=n2)-
                      theta[i] * sqrt(n2), lower.tail=FALSE))
      return(data.frame(theta=theta, delta=delta, 
                        Power=Power, en=en))
    }
    en <- en + x$maxinc*x$x$n.I[2]*(pnorm(changepoint3-mu) - 
                                      pnorm(changepoint-mu))
    a <- changepoint
    b <- changepoint3
    n2 <- x$maxinc*x$x$n.I[2]-x$x$n.I[1]
    grid <- normalGrid(mu=(a+b)/2,bounds=c(a,b),r=r)
    for(i in 1:length(theta)) Power[i] <-  Power[i] +
      sum(dnorm(grid$z-sqrt(x$x$n.I[1])*theta[i]) * 
            grid$gridwgts *
            pnorm(x$z2fn(grid$z, x=x$x, n2=n2) - 
                    theta[i] * sqrt(n2), lower.tail=FALSE))
  }else changepoint3 <- changepoint # changed from x$x$lower$bound[1], 20131201, K Anderson
  # finally, integrate en over area where conditional power is in  
  # range where we wish to increase to desired conditional power
  grid <- normalGrid(mu=(changepoint3+changepoint2)/2, 
                     bounds=c(changepoint3, changepoint2), r=r)    
  y <- ssrCP(z1=grid$z, theta=x$theta, maxinc=x$maxinc*2, 
             beta=x$beta, x=x$x, cpadj=c(.05,.9999), 
             z2=x$z2fn)$dat
  for(i in 1:length(theta)){
    grid$density <- dnorm(y$z1-sqrt(x$x$n.I[1])*theta[i])
    Power[i] <- Power[i] + 
      sum(grid$density * grid$gridwgts * 
            pnorm(y$z2 - theta[i]*sqrt(y$n2-x$x$n.I[1]), 
                  lower.tail=FALSE))
    en[i] <- en[i] + sum(grid$density*grid$gridwgts*y$n2)
  }
  return(data.frame(theta=theta,delta=delta,Power=Power,en=en))
}

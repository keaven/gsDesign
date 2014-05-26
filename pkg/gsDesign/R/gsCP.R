##################################################################################
#  Conditional power computation functionality for the gsDesign package
#
#  Exported Functions:
#                   
#    gsCP
#    gsBoundCP
#    gsPP
#    gsPosterior
#    gsPI
#
#  Hidden Functions:
#
#    (none)
#
#  Author(s): Keaven Anderson, PhD.
# 
#  Reviewer(s): REvolution Computing 19DEC2008 v.2.0 - William Constantine, Kellie Wills 
#
#  R Version: 2.7.2
#
#  Updated: added gsPosterior, 8May2011, K. Anderson
##################################################################################

###
# Exported Functions
###

"gsCP" <- function(x, theta=NULL, i=1, zi=0, r=18)
{    
    # conditional power for remaining trial is returned (including each interim)
    # as a gsProbability object
    # Inputs: interim theta value and which interim is considered
    
    if (!(is(x, "gsProbability") || is(x, "gsDesign")))
    {    
        stop("gsCP must be called with class of x either gsProbability or gsDesign")
    }
    
    if (i < 1 || i >= x$k)
    {    
        stop("gsCP must be called with i from 1 to x$k-1")
    }
    
    test.type <- ifelse(is(x, "gsProbability"), 3, x$test.type)
    
    if (zi > x$upper$bound[i])
    {    
        stop("gsCP must have x$lower$bound[i] <= zi <= x$upper$bound[i]")
    }
    else if (test.type > 1 && zi < x$lower$bound[i])
    {
        stop("gsCP must have x$lower$bound[i]<=zi<=x$upper$bound[i]")            
    }
  
    if (is.null(theta))
    {
        theta <- c(zi/sqrt(x$n.I[i]), 0, x$delta)
    }
    
    knew <- x$k-i
    Inew <- x$n.I[(i+1):x$k]-x$n.I[i]
    bnew <- (x$upper$bound[(i+1):x$k] - zi * sqrt(x$n.I[i] / x$n.I[(i+1):x$k]))/ 
            sqrt(Inew/x$n.I[(i+1):x$k])
    if (test.type > 1){
        anew <- (x$lower$bound[(i+1):x$k]-zi*sqrt(x$n.I[i]/x$n.I[(i+1):x$k]))/
                sqrt(Inew/x$n.I[(i+1):x$k])        
    }
    else
    {
        anew <- array(-20, knew)
    }
    
    gsProbability(k=knew, theta=theta, n.I=Inew, a=anew, b=bnew, r=r, overrun=0)
}

gsPP <- function(x, i=1, zi=0, theta=c(0,3), wgts=c(.5,.5), r=18, total=TRUE)
{   if (!(is(x, "gsProbability") || is(x, "gsDesign")))
    {   stop("gsPP: class(x) must be gsProbability or gsDesign")
    }
    test.type <- ifelse(is(x, "gsProbability"), 3, x$test.type)
    checkScalar(i, "integer", c(1, x$k-1))
    checkScalar(zi, "numeric", c(-Inf,Inf), c(FALSE, FALSE))
    checkVector(wgts, "numeric", c(0, Inf), c(TRUE, FALSE))
    checkVector(theta, "numeric", c(-Inf,Inf), c(FALSE, FALSE))
    checkLengths(theta, wgts)
    checkScalar(r, "integer", c(1, 80))
    cp <- gsCP(x = x, i = i, theta = theta, zi = zi, r = r)
    gsDen <- dnorm(zi, mean=sqrt(x$n.I[i])*theta) * wgts
    pp <- cp$upper$prob %*% gsDen / sum(gsDen)
    if (total) return(sum(pp))
    else return(pp)
}

gsPI<-function(x, i=1, zi=0, j=2, level=.95, theta=c(0,3), wgts=c(.5,.5)){
   if (!(is(x, "gsProbability") || is(x, "gsDesign")))
   {  stop("gsPI: class(x) must be gsProbability or gsDesign")
   }
   checkScalar(i, "integer", c(1, x$k-1))
   checkScalar(j, "integer", c(i+1, x$k))
   checkScalar(zi, "numeric", c(-Inf,Inf), c(FALSE,FALSE))
   checkVector(wgts, "numeric", c(0, Inf), c(TRUE, FALSE))
   checkVector(theta, "numeric", c(-Inf,Inf), c(FALSE, FALSE))
   checkLengths(theta, wgts)
   post <- dnorm(zi,mean=sqrt(x$n.I[i])*theta) * wgts
   post <- post/sum(post)
   lower <- uniroot(f=postfn, interval=c(-20,20), PP=1-(1-level)/2, 
                    d=x, i=i, zi=zi, j=j, theta=theta, wgts=post)$root
   if (level==0) return(lower)
   upper <- uniroot(f=postfn, interval=c(-20,20), PP=(1-level)/2,
                    d=x, i=i, zi=zi, j=j, theta=theta, wgts=post)$root
   c(lower,upper)
}

"gsBoundCP" <- function(x, theta="thetahat", r=18)
{   if (!(is(x, "gsProbability") || is(x, "gsDesign")))
    {  stop("gsPI: class(x) must be gsProbability or gsDesign")
    }
    checkScalar(r, "integer", c(1, 70))
    if (!is.character(theta))
        checkVector(theta, "numeric", c(-Inf,Inf), c(FALSE, FALSE))

    len <- x$k-1
    test.type <- ifelse(is(x, "gsProbability"), 3, x$test.type)
    
    if (theta != "thetahat")
    {    
        thetahi <- array(theta, len)
        if (test.type > 1) thetalow <- thetahi
    }else
    {    
        if (test.type>1) thetalow <- x$lower$bound[1:len]/sqrt(x$n.I[1:len])
        thetahi <- x$upper$bound[1:len]/sqrt(x$n.I[1:len])
    }
    CPhi <- array(0, len)
    
    if (test.type > 1) CPlo <- CPhi
    
    for(i in 1:len)
    {    
        if (test.type > 1)
        {    
            xlow <- gsCP(x, thetalow[i], i, x$lower$bound[i])
            CPlo[i] <- sum(xlow$upper$prob)
        }
        xhi <- gsCP(x, thetahi[i], i, x$upper$bound[i])
        CPhi[i] <- sum(xhi$upper$prob)
    }
    
    if (test.type > 1) cbind(CPlo, CPhi) else CPhi
}
gsPosterior <- function(x=gsDesign(), i=1, zi=NULL, prior=normalGrid(),
                        r=18)
{   if (is.null(prior$gridwgts)) prior$gridwgts <- array(1,length(prior$z))
    checkLengths(prior$z, prior$density, prior$gridwgts)
    checkVector(prior$gridwgts, "numeric", c(0, Inf), c(TRUE, FALSE))
    checkVector(prior$density, "numeric", c(0, Inf), c(TRUE, FALSE))
    checkVector(prior$z, "numeric", c(-Inf,Inf), c(FALSE, FALSE))
    if (!(is(x, "gsProbability") || is(x, "gsDesign")))
      stop("gsPosterior: x must have class gsDesign or gsProbability")
    test.type <- ifelse(is(x, "gsProbability"), 3, x$test.type)
    checkScalar(i, "integer", c(1, x$k-1))
    if (is.null(zi)) zi <- c(x$lower$bound[i],x$upper$bound[i])
    else checkVector(zi, "numeric", c(-Inf,Inf), c(FALSE,FALSE))
    if (length(zi) > 2) stop("gsPosterior: length of zi must be 1 or 2")
    if (length(zi) > 1) 
    {   if (zi[2] <= zi[1])
            stop("gsPosterior: when length of zi is 2, must have zi[2] > zi[1]")
        xa <- x
        if (zi[1] != x$lower$bound[i] || zi[2] != x$upper$bound[i])
        {    xa$lower$bound[i] <- zi[1]
             xa$upper$bound[i] <- zi[2]
        }
        xa <- gsProbability(d=xa, theta=prior$z, r=r)
        prob <- xa$lower$prob + xa$upper$prob
        for (j in 1:ncol(prob)) prob[,j] <- 1 - cumsum(prob[,j])
        marg <- sum(prob[i,] * prior$gridwgts * prior$density)
        posterior <- prob[i,] * prior$density
    }
    else
    {   y <- gsZ(x, theta=prior$z, i=i, zi=zi)
        marg <- sum(as.vector(y$density) * prior$gridwgts * prior$density)
        posterior <- as.vector(y$density) * prior$density
    }
    posterior <- posterior / marg
    return(list(z=prior$z, density=posterior, 
                gridwgts=prior$gridwgts, wgts=prior$gridwgts*posterior))
}

###
# Hidden Functions
###
gsZ <- function(x, theta, i, zi){
    mu <- sqrt(x$n.I[i]) * theta
    xx <- matrix(0,nrow=length(zi),ncol=length(theta))
    for (j in 1:length(theta)) xx[,j] <- dnorm(zi - mu[j])
    list(zi=zi, theta=theta, density=xx)
}
postfn <- function(x, PP, d, i, zi, j, theta, wgts)
{   newmean <- (d$timing[j]-d$timing[i]) * theta * sqrt(d$n.I[d$k])
    newsd <- sqrt(d$timing[j]-d$timing[i])
    pprob <- pnorm(x*sqrt(d$timing[j])-zi*sqrt(d$timing[i]), mean=newmean, 
                   sd=newsd, lower.tail=FALSE)
    sum(pprob * wgts) - PP
}

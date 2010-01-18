##################################################################################
#  Conditional power computation functionality for the gsDesign package
#
#  Exported Functions:
#                   
#    gsCP
#    gsPP
#    gsBoundCP
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
    
    gsProbability(k=knew, theta=theta, n.I=Inew, a=anew, b=bnew, r=r)
}

gsPP <- function(x, i=1, zi=0, theta=c(0,3), wgts=c(.5,.5), r=18, total=TRUE)
{   if (!(is(x, "gsProbability") || is(x, "gsDesign")))
    {    
        stop("gsPP must be called with class of x either gsProbability or gsDesign")
    }
    test.type <- ifelse(is(x, "gsProbability"), 3, x$test.type)
    checkScalar(i, "integer", c(1, x$k-1))
    checkScalar(zi, "numeric", c(ifelse(test.type==1, -20, x$lower$bound[i]), x$upper$bound[i]), c(TRUE,TRUE))
    checkVector(wgts, "numeric", c(-Inf, Inf), c(FALSE, FALSE))
    checkVector(theta, "numeric", c(-Inf,Inf), c(FALSE, FALSE))
    checkLengths(theta, wgts)
    checkScalar(r, "integer", c(1, 80))

    cp <- gsCP(x = x, i = i, theta = theta, zi = zi, r = r)
    gsDen <- gsDensity(x, theta=theta, i=i, zi=zi, r=r)
	 pp <- cp$upper$prob %*% t(gsDen$density * wgts) / sum(gsDen$density * wgts)
    if (total) return(sum(pp))
    else return(pp)
}

"gsBoundCP" <- function(x, theta="thetahat", r=18)
{    
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

###
# Hidden Functions
###

"gsCP" <- function(x, theta=NULL, i=1, zi=0, r=18)
{    
    # conditional power for remaining trial is returned (including each interim)
    # as a gsProbability object
    # Inputs: interim theta value and which interim is considered
    
    if (!(is(x, "gsProbability") || is(x, "gsDesign")))
    {    
        gsReturnError(x, 1, "gsCP must be called with class of x either gsProbability or gsDesign")
    }
    
    if (i < 1 || i >= x$k)
    {    
        gsReturnError(x, 2, "gsCP must be called with i from 1 to x$k-1")
    }
    
    test.type <- ifelse(is(x, "gsProbability"), 3, x$test.type)
    
    if (zi > x$upper$bound[i])
    {    
        gsReturnError(x, 3, "gsCP must have x$lower$bound[i] <= zi <= x$upper$bound[i]")
    }
    else if (test.type > 1 && zi < x$lower$bound[i])
    {
        gsReturnError(x, 3, "gsCP must have x$lower$bound[i]<=zi<=x$upper$bound[i]")            
    }
  
    if (!is.real(theta) || is.na(theta))
    {
        theta <- c(zi/sqrt(x$n.I[i]), x$theta)
    }
    
    knew <- x$k-i
    Inew <- x$n.I[(i+1):x$k]-x$n.I[i]
    bnew <- (x$upper$bound[(i+1):x$k]-zi*sqrt(x$n.I[i]/x$n.I[(i+1):x$k]))/sqrt(Inew/x$n.I[(i+1):x$k])
    if (test.type > 1){
        anew <- (x$lower$bound[(i+1):x$k]-zi*sqrt(x$n.I[i]/x$n.I[(i+1):x$k]))/sqrt(Inew/x$n.I[(i+1):x$k])        
    }
    else
    {
        anew <- array(-20, knew)
    }
    
    gsProbability(k=knew, theta=theta, n.I=Inew, a=anew, b=bnew, r=r)
}

"gsBoundCP" <- function(x, theta="thetahat", r=18)
{    
    len <- x$k-1
    test.type <- ifelse(is(x, "gsProbability"), 3, x$test.type)
    
    
    if (!is(x, "gsDesign")  || theta != "thetahat")
    {    
        thetahi <- array(theta, len)
        
        if (test.type > 1)
        {
            thetalow <- theta
        }
    }
    else
    {    
        if (test.type>1)
        {
            thetalow <- x$lower$bound[1:len]/sqrt(x$n.I[1:len])
        }
        
        thetahi <- x$upper$bound[1:len]/sqrt(x$n.I[1:len])
    }
    CPhi <- array(0, len)
    
    if (test.type > 1)
    {
        CPlo <- CPhi
    }
    
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

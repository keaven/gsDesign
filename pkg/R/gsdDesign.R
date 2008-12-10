##################################################################################
#  File gsDesign.R
#  Part of the R package gsDesign
#
#  Functions:
#  
#    gsDesign:          calculate boundaries and total information required 
#                       for a group sequential design
#    gsProbability:     calculate boundary crossing probabilities for a group
#                       sequential design
#
#  Author(s):         Keaven Anderson, PhD. timing/ Jennifer Sun, MS.
#
#  Date Completed:    1JAN2007 
#
#  Date Updated:      13SEP2008
#
#  R Version:         2.7.2
#
##################################################################################

"gsDesign"<-function(k=3, test.type=4, alpha=0.025, beta=0.1, astar=0,  
        delta=0, n.fix=1, timing=1, sfu=sfHSD, sfupar=-4,
        sfl=sfHSD, sflpar=-2, tol=0.000001, r=18, n.I=0, maxn.IPlan=0) 
{
    # Derive a group sequential design and return in a gsDesign structure
    
    # set up class variable x for gsDesign being requested
    x <- list(k=k, test.type=test.type, alpha=alpha, beta=beta, astar=astar,
            delta=delta, n.fix=n.fix, timing=timing, tol=tol, r=r, n.I=n.I, maxn.IPlan=maxn.IPlan)
    
    class(x) <- "gsDesign"
    
    # check parameters other than spending functions
    x <- gsDErrorCheck(x)
    
    if (x$errcode > 0) 
    {
        return(x)
    }

    # set up spending for upper bound
    if (is.character(sfu))
    {  
        upper <- list(sf = sfu, name = sfu, parname = "Delta", param = sfupar,
                errcode = 0, errmsg = "No errors detected")
        
        class(upper) <- "spendfn"
        
        if (!is.element(upper$name,c("OF", "Pocock" , "WT")))           
        {
            upper <- gsReturnError(upper, errcode=8, 
                    errmsg="Character specification of upper spending may only be WT, OF or Pocock")
        }
        
        if (is.element(upper$name, c("OF", "Pocock")))
        {    
            upper$param <- NULL
        }
    }
    else if (!is.function(sfu))
    {   
        upper <- list(errcode = 8, errmsg = "Upper spending function mis-specified")
        class(upper) <- "spendfn"
    }
    else
    {   
        upper <- sfu(x$alpha, x$timing, sfupar)
        upper$sf <- sfu
    }
    
    x$upper <- upper

    if (x$upper$errcode > 0)
    {
        return(gsReturnError(x, errcode=8, errmsg=upper$errmsg))
    }
    
    # set up spending for lower bound
    if (x$test.type == 1) 
    {
        x$lower <- NULL
    }
    else if (x$test.type == 2) 
    {
        x$lower <- x$upper
    }
    else
    {   
        if (!is.function(sfl))
        {     
            x$lower <- list(errcode=9,
                    errmsg="Lower spending function must be a built-in or user-defined function that returns object with class spendfn")
            class(x$lower) <- "spendfn"
        }
        else if (is.element(test.type, 3:4)) 
        {
            x$lower <- sfl(x$beta,x$timing,sflpar)
        }
        else if (is.element(test.type, 5:6)) 
        {   
            if (x$astar == 0) 
            {
                x$astar <- 1 - x$alpha
            }
            x$lower <- sfl(x$astar, x$timing, sflpar)
        }
        
        x$lower$sf <- sfl
        
        if (x$lower$errcode > 0) 
        { 
            return(gsReturnError(x, errcode=8, errmsg=x$lower$errmsg))
        }
    }
    
    # call appropriate calculation routine according to test.type
    switch(x$test.type,
            gsDType1(x),
            gsDType2and5(x),
            gsDType3(x),
            gsDType4(x),
            gsDType2and5(x),
            gsDType6(x))
}

"gsDType1" <- function(x, ss=1)
{    
    # gsDType1: calculate bound assuming one-sided rule (only upper bound)
    
    # set lower bound
    a <- array(-20, x$k)

    # get Wang-Tsiatis bound, if desired
    if (is.element(x$upper$name, c("WT", "Pocock", "OF")))
    {    
        Delta <- switch(x$upper$name, WT = x$upper$param, Pocock = 0.5, 0) 
   
        cparam <- WT(Delta, x$alpha, a, x$timing, x$tol, x$r)
        x$upper$bound <- cparam * x$timing^(Delta - 0.5)
        
        x$upper$spend <- as.vector(gsprob(0., x$timing, a, x$upper$bound, x$r)$probhi)
        falsepos <- x$upper$spend
    }

    # otherwise, get bound using specified spending
    else
    {    
        # set false positive rates
        falsepos <- x$upper$spend
        falsepos <- falsepos - c(0, falsepos[1:x$k-1])
        x$upper$spend <- falsepos
    
        # compute upper bound and store in x
        x$upper$bound <- gsbound1(0, x$timing, a, falsepos, x$tol, x$r)$b
    }

    # set information to get desired power (only if sample size is being computed)
    if (max(x$n.I) == 0)
    {
       x$n.I <- uniroot(gsbetadiff, lower=x$n.fix, upper=10*x$n.fix, theta=x$delta, beta=x$beta,
                        time=x$timing, a=a, b=x$upper$bound, tol=x$tol, r=x$r)$root * x$timing
    }
    
    # add boundary crossing probabilities for theta to x
    x$theta <- c(0,x$delta)
    y <- gsprob(x$theta,x$n.I,a,x$upper$bound,r=x$r)
    x$upper$prob <- y$probhi
    x$en <- as.vector(y$en)

    # return error if boundary crossing probabilities do not meet desired tolerance
    if (max(abs(falsepos - y$probhi[,1])) > x$tol)
    {
        return(gsReturnError(x,errcode=101,errmsg="False positive rates not achieved"))        
    }

    x
}

"gsDType2and5" <- function(x)
{    
    # gsDType2and5: calculate bound assuming two-sided rule, binding, all alpha spending    
    
    if (is.element(x$upper$name, c("WT","Pocock","OF")))
    {    
        if (x$test.type == 5)
        {
            return(gsReturnError(x,errcode=8,errmsg="Wang-Tsiatis, Pocock and O'Brien-Fleming bounds not available for asymmetric testing"))            
        }

        Delta <- switch(x$upper$name, WT = x$upper$param, Pocock = 0.5, 0) 
        
        cparam <- WT(Delta, x$alpha, 1, x$timing, x$tol, x$r)
        x$upper$bound <- cparam * x$timing^(Delta - 0.5)
        
        x$upper$spend <- as.vector(gsprob(0., x$timing, -x$upper$bound, x$upper$bound, x$r)$probhi)
        x$lower <- x$upper
        x$lower$bound<- -x$lower$bound
        
        # set information to get desired power
        if (max(x$n.I) == 0)
        {    
            x$n.I <- uniroot(gsbetadiff, lower=x$n.fix, upper=10*x$n.fix, theta=x$delta, beta=x$beta,
                             time=x$timing, a=x$lower$bound, b=x$upper$bound, tol=x$tol, r=x$r)$root * x$timing
        }
        
        falsepos <- x$upper$spend
        trueneg <- x$lower$spend
    }
    else
    {    
        falsepos <- x$upper$spend
        falsepos <- falsepos - c(0,falsepos[1:x$k-1])
        x$upper$spend <- falsepos
        if (x$test.type == 5)
        {    trueneg <- x$lower$spend
            trueneg <- trueneg - c(0,trueneg[1:x$k-1])
            errno <- 0
        }
        else 
        {    trueneg <- falsepos
            errno <- 0
        }
        
        x$lower$spend <- trueneg
        
        # argument for "symmetric" to gsI should be 1 unless test.type==5 and astar=1-alpha
        sym <- ifelse(x$test.type == 2 || x$astar < 1 - x$alpha, 1, 0)
        
        # set information to get desired power (only if sample size is being computed)
        if (max(x$n.I) == 0)
        {    
            x2 <- gsI(I=x$timing, theta=x$delta, beta=x$beta, trueneg=trueneg, 
                      falsepos=falsepos, symmetric=sym)
            
            x$n.I <- x2$I
        }
        else
        {
            x2 <- gsbound(I=x$n.I, trueneg=trueneg, falsepos=falsepos, tol=x$tol, r=x$r)
        }
        
        x$upper$bound <- x2$b
        x$lower$bound <- x2$a
    }
    
    x$theta <- c(0, x$delta)
    y <- gsprob(x$theta, x$n.I, x$lower$bound, x$upper$bound, r=x$r)
    x$upper$prob <- y$probhi
    x$lower$prob <- y$problo
    x$en <- as.vector(y$en)

    # return error if boundary crossing probabilities to not meet desired tolerance
    if (max(abs(falsepos - x$upper$prob[,1])) > x$tol)
    {
        return(gsReturnError(x,errcode=errno,errmsg="False positive rates not achieved"))        
    }

    if (max(abs(trueneg - x$lower$prob[,1])) > x$tol)
    {
        return(gsReturnError(x,errcode=errno,errmsg="False negative rates not achieved"))        
    }

    x
}

"gsDType3" <- function(x)
{
    # Check added by K. Wills 12/4/2008
    if (is.element(x$upper$name, c("WT","Pocock","OF")))
    {    
        return(gsReturnError(x,errcode=8,errmsg="Wang-Tsiatis, Pocock and O'Brien-Fleming bounds not available for asymmetric testing"))            
    }
    
    # gsDType3: calculate bound assuming binding stopping rule and beta spending
    # this routine should get a thorough check for error handling!!!    
    if (max(x$n.I) == 0) gsDType3ss(x) else gsDType3a(x)
}

"gsDType3ss" <- function(x)
{    
    # compute starting bounds under H0 
    k <- x$k
    falsepos <- x$upper$spend
    falsepos <- falsepos-c(0,falsepos[1:x$k-1])
    x$upper$spend <- falsepos
    trueneg <- array((1-x$alpha)/x$k,x$k)
    x1 <- gsbound(x$timing,trueneg,falsepos,x$tol,x$r)

    # get I(max) and lower bound
    I0 <- x$n.fix
    falseneg <- x$lower$spend
    falseneg <- falseneg-c(0, falseneg[1:x$k-1])
    x$lower$spend <- falseneg
      x2 <- gsI1(theta=x$delta, I=x$timing, beta=falseneg, b=x1$b, Ilow=I0/3, Ihigh=10*I0, x$tol, x$r)
    
      #check alpha
      x3 <- gsprob(0, x2$I, x2$a, x2$b)
      gspowr <- x3$powr
      I <- x2$I
      flag <- abs(gspowr - x$alpha)
 
    # iterate until Type I error is correct
    jj <- 0
    while (flag > x$tol && jj < 100)
      {    
        # if alpha <> power, go back to set upper bound, lower bound and I(max) 
          x4 <- gsbound1(0, I, c(x2$a[1:k-1],-20), falsepos)
          x2 <- gsI1(theta=x$delta, I=x$timing, beta=falseneg, b=x4$b, Ilow=I0/3,Ihigh=10*I0,x$tol,x$r)
          x3 <- gsprob(0,x2$I,x2$a,x2$b)
          gspowr <- x3$powr
          I <- x2$I
          flag <- abs(gspowr-x$alpha)
        jj <- jj + 1
      }

    # add bounds and information to x
    x$upper$bound <- x2$b
    x$lower$bound <- x2$a
    x$n.I <- x2$I

    # add boundary crossing probabilities for theta to x
    x$theta <- c(0, x$delta)
    x4 <- gsprob(x$theta, x2$I, x2$a, x2$b)
    x$upper$prob <- x4$probhi
    x$lower$prob <- x4$problo
    x$en <- as.vector(x4$en)

    # return error if boundary crossing probabilities do not meet desired tolerance
    if (max(abs(falsepos - x3$probhi)) > x$tol)
    {
        return(gsReturnError(x, errcode=103, errmsg="False positive rates not achieved"))        
    }

    if (max(abs(falseneg - x2$problo)) > x$tol)
    {
        return(gsReturnError(x, errcode=103.1, errmsg="False negative rates not achieved"))        
    }

    x
}

"gsDType3a" <- function(x)
{    
    aspend <- x$upper$spend
    bspend <- x$lower$spend
    
    # try to match spending
    x <- gsDType3b(x)
    if (x$test.type==4){
        return(x)
    } 
    
    # if alpha spent, finish
    if (sum(x$upper$prob[,1]) > x$alpha - x$tol)
    {
        return(x)
    }
    
    # if beta spent prior to final analysis, reduce x$k
    pwr <- 1 - x$beta
    pwrtot <- 0
    for (i in 1:x$k)
    {    
        pwrtot <- pwrtot + x$upper$prob[i,2]
        if (pwrtot > pwr-x$tol) 
        {
            break
        }
    }
    x$k <- i
    x$n.I <- x$n.I[1:i]
    x$timing <- x$timing[1:i]
    x$upper$spend <- c(aspend[1:i-1], x$alpha)
    x$lower$spend <- c(bspend[1:i-1], x$beta)
    
    gsDType3b(x)
}

"gsDType3b" <- function(x)
{    
    # set I0, desired false positive and false negative rates
    I0 <- x$n.fix
    falseneg <- x$lower$spend
    falseneg <- falseneg - c(0, falseneg[1:x$k-1])
    x$lower$spend <- falseneg
    falsepos <- x$upper$spend
    falsepos <- falsepos - c(0,falsepos[1:x$k-1])
    x$upper$spend <- falsepos

    # compute initial upper bound under H0 
    trueneg <- array((1 - x$alpha) / x$k, x$k)
    x1 <- gsbound(x$timing, trueneg, falsepos, x$tol, x$r)
    
    # x$k==1 is a special case
    if (x$k == 1)
    {    
        x$upper$bound <- x1$b
        x$lower$bound <- x1$b
    }
    else
    {
        # get initial lower bound
          x2 <- gsbound1(theta = -x$delta, I = x$n.I, a = -x1$b, probhi = falseneg, tol = x$tol, r = x$r)
        x2$b[x2$k] <- -x1$b[x1$k]
          x2 <- gsprob(x$delta, x$n.I, -x2$b, x1$b, r=x$r)

          # set up x3 for loop and set flag so loop runs 1st time
          x3 <- gsprob(0, x2$I, x2$a, x2$b, r=x$r)
          flag <- x$tol + 1
    
        # iterate until convergence
        while (flag > x$tol)
        {    
            aold <- x2$a
            bold <- x2$b
            alphaold <- x3$powr
            a <- c(x2$a[1:(x2$k-1)], -20)
            x4 <- gsbound1(0, x$n.I, a, falsepos)
            x2 <- gsbound1(theta=-x$delta, I=x$n.I, a=-x4$b, probhi=falseneg, tol=x$tol, r=x$r)
            x2$a[x2$k] <-  x2$b[x2$k]
            x2 <- gsprob(x$delta, x$n.I, -x2$b, x4$b, r=x$r)
            x3 <- gsprob(0, x2$I, x2$a, x2$b)
            flag <- max(abs(c(x2$a - aold, x2$b - bold, alphaold - x3$powr)))
        }

        # add bounds and information to x
        x$upper$bound <- x2$b
        x$lower$bound <- x2$a
    }
    
    # add boundary crossing probabilities for theta to x
    x$theta <- c(0,x$delta)
    x4 <- gsprob(x$theta,x$n.I,x$lower$bound,x$upper$bound)
    x$upper$prob <- x4$probhi
    x$lower$prob <- x4$problo
    x$en <- as.vector(x4$en)
    
    x
}

# asymmetric, non-binding, beta spending

"gsDType4" <- function(x)
{
    # Check added by K. Wills 12/4/2008
    if (is.element(x$upper$name, c("WT","Pocock","OF")))
    {    
        return(gsReturnError(x,errcode=8,errmsg="Wang-Tsiatis, Pocock and O'Brien-Fleming bounds not available for asymmetric testing"))            
    }
    
    if (max(x$n.I) == 0) gsDType4ss(x) else gsDType4a(x)
}

"gsDType4a" <- function(x)
{    
    # set I0, desired false positive and false negative rates
    I0 <- x$n.fix
    falseneg <- x$lower$spend
    falseneg <- falseneg - c(0, falseneg[1:x$k-1])
    x$lower$spend <- falseneg
    falsepos <- x$upper$spend
    falsepos <- falsepos - c(0,falsepos[1:x$k-1])
    x$upper$spend <- falsepos

    # compute upper bound under H0 
    x1 <- gsbound1(theta = 0, I = x$timing, a = array(-20, x$k), probhi = falsepos, tol = x$tol, r = x$r)

    # get lower bound
      x2 <- gsbound1(theta = -x$delta, I = x$n.I, a = -x1$b, probhi = falseneg, tol = x$tol, r = x$r)
    if (-x2$b[x2$k] > x1$b[x1$k] - x$tol)
    {
        x2$b[x2$k] <- -x1$b[x1$k]
    }

    # add bounds and information to x
    x$upper$bound <- x1$b
    x$lower$bound <- -x2$b

    # add boundary crossing probabilities for theta to x
    x$theta <- c(0, x$delta)
    x4 <- gsprob(x$theta, x$n.I, -x2$b, x1$b)
    x$upper$prob <- x4$probhi
    x$lower$prob <- x4$problo
    x$en <- as.vector(x4$en)

    x
}

"gsDType4ss" <- function(x)
{    
    # compute starting bounds under H0 
    falsepos <- x$upper$spend
    falsepos <- falsepos-c(0,falsepos[1:x$k-1])
    x$upper$spend <- falsepos
    x0 <- gsbound1(0., x$timing, array(-20, x$k), falsepos, x$tol, x$r)

    # get beta spending (falseneg)
    falseneg <- x$lower$spend
    falseneg <- falseneg-c(0,falseneg[1:x$k-1])
    x$lower$spend <- falseneg

    # find information and boundaries needed 
    I0 <- x$n.fix
    xx <- gsI1(theta = x$delta, I = x$timing, beta = falseneg, b = x0$b, Ilow = I0/3, Ihigh = 10*I0, x$tol, x$r)
    x$lower$bound <- xx$a
    x$upper$bound <- xx$b
    x$n.I <- xx$I

    # compute additional error rates needed and add to x
    x$theta <- c(0, x$delta)
    x$falseposnb <- as.vector(gsprob(0, xx$I, array(-20, x$k), x0$b, r=x$r)$probhi)
    x3 <- gsprob(x$theta, xx$I, xx$a, x0$b, r=x$r)
    x$upper$prob <- x3$probhi
    x$lower$prob <- x3$problo
    x$en <- as.vector(x3$en)

    # return error if boundary crossing probabilities do not meet desired tolerance
    if (max(abs(falsepos-x$falseposnb)) > x$tol)
    {
        return(gsReturnError(x,errcode=104,errmsg="False positive rates not achieved"))        
    }

    if (max(abs(falseneg-x$lower$prob[,2])) > x$tol)
    {
        return(gsReturnError(x,errcode=104.1,errmsg="False negative rates not achieved"))        
    }

    x
}

# asymmetric, non-binding, lower spending under H0

"gsDType6" <- function(x)
{
    # Check added by K. Wills 12/4/2008
    if (is.element(x$upper$name, c("WT","Pocock","OF")))
    {    
        return(gsReturnError(x,errcode=8,errmsg="Wang-Tsiatis, Pocock and O'Brien-Fleming bounds not available for asymmetric testing"))            
    }
    
    # compute upper bounds with non-binding assumption 
    falsepos <- x$upper$spend
    falsepos <- falsepos-c(0, falsepos[1:x$k-1])
    x$upper$spend <- falsepos
    x0 <- gsbound1(0., x$timing, array(-20, x$k), falsepos, x$tol, x$r)
    x$upper$bound <- x0$b
    
    if (x$astar == 1 - x$alpha)
    {   
        # get lower spending (trueneg) and lower bounds using binding
        flag <- 1
        tn <- x$lower$spend
        tn <- tn - c(0, tn[1:x$k-1])
        trueneg <- tn
        
        i <- 0
        
        while (flag > x$tol && i < 10)
        {      
            xx <- gsbound1(0, x$timing, -x$upper$bound, trueneg, x$tol, x$r)
            alpha <- sum(xx$problo)
            trueneg <- (1 - alpha) * tn / x$astar
            xx2 <- gsprob(0, x$timing, c(-xx$b[1:x$k-1], x$upper$bound[x$k]), x$upper$bound, r=x$r)
            flag <- max(abs(as.vector(xx2$problo) - trueneg))
            i <- i + 1
        }
        
        x$lower$spend <- trueneg
        x$lower$bound <- xx2$a
      }
      else
      {   
          trueneg <- x$lower$spend
          trueneg <- trueneg - c(0, trueneg[1:x$k-1])
          x$lower$spend <- trueneg
          xx <- gsbound1(0, x$timing, -x$upper$bound, x$lower$spend, x$tol, x$r)
          x$lower$bound <- -xx$b
      }
    # find information needed 
    if (max(x$n.I) == 0)
    {    
        x$n.I <- uniroot(gsbetadiff, lower=x$n.fix, upper=10 * x$n.fix, theta=x$delta, beta=x$beta, time=x$timing,
               a=x$lower$bound, b=x$upper$bound, tol=x$tol, r=x$r)$root * x$timing
    }
    
    # compute error rates needed and add to x
    x$theta <- c(0,x$delta)
    x$falseposnb <- as.vector(gsprob(0, x$n.I, array(-20, x$k), x$upper$bound,r =x$r)$probhi)
    x3 <- gsprob(x$theta, x$n.I, x$lower$bound, x$upper$bound, r=x$r)
    x$upper$prob <- x3$probhi
    x$lower$prob <- x3$problo
    x$en <- as.vector(x3$en)

    # return error if boundary crossing probabilities do not meet desired tolerance
    if (max(abs(falsepos-x$falseposnb)) > x$tol)
    {
        return(gsReturnError(x,errcode=106,errmsg="False positive rates not achieved"))        
    }

    if (max(abs(trueneg[1:x$k-1] - x$lower$prob[1:x$k-1,1])) > x$tol){
        return(gsReturnError(x,errcode=106.1,errmsg="True negative rates not achieved"))        
    }

    x
}

"gsbound" <- function(I, trueneg, falsepos, tol=0.000001, r=18)
{    
    # gsbound: assuming theta=0, derive lower and upper crossing boundaries given 
    #          timing of interims, false positive rates and true negative rates
    
    # check input arguments
    checkVector(I, "numeric", c(0, Inf), c(FALSE, TRUE))
    checkVector(trueneg, "numeric", c(0,1), c(FALSE, FALSE))
    checkVector(falsepos, "numeric", c(0,1), c(FALSE, FALSE))
    checkScalar(tol, "numeric", c(0, Inf), c(FALSE, TRUE))
    checkScalar(r, "integer", c(1, 80))
    checkLengths(trueneg, falsepos, I)    
    
    k <- as.integer(length(I))
    storage.mode(I) <- "double"
    storage.mode(trueneg) <- "double"
    storage.mode(falsepos) <- "double"
    storage.mode(tol) <- "double"
    a <- falsepos
    b <- falsepos
    retval <- as.integer(0)
    xx <- .C("gsbound", k, I, a, b, trueneg, falsepos, tol, as.integer(r), retval)
    rates <- list(falsepos=xx[[6]], trueneg=xx[[5]])
    
    list(k=xx[[1]],theta=0.,I=xx[[2]],a=xx[[3]],b=xx[[4]],rates=rates,tol=xx[[7]],
            r=xx[[8]],error=xx[[9]])
}

"gsbetadiff" <- function(Imax, theta, beta, time, a, b, tol=0.000001, r=18)
{    
    # compute difference between actual and desired Type II error     
    I <- time * Imax
    x <- gsprob(theta, I, a, b, r)

    beta - 1 + sum(x$probhi)
}


"gsI" <- function(I, theta, beta, trueneg, falsepos, symmetric, tol=0.000001, r=18)
{   
    # gsI: find gs design with falsepos and trueneg
  
    k <- length(I)
    tx <- I/I[k]
    x <- gsbound(I, trueneg, falsepos, tol, r)
    alpha <- sum(falsepos)
    I0 <- (qnorm(alpha)+qnorm(beta))/theta
    I0 <- I0*I0
    x$I <- uniroot(gsbetadiff, lower=I0, upper=10*I0, theta=theta, beta=beta, time=tx, 
                 a=x$a, b=x$b, tol=tol, r=r)$root*tx 
         
    if (symmetric==0)
    {
        x$a[x$k] <- x$b[x$k]
    }
    
    y <- gsprob(theta, x$I, x$a, x$b, r=r)
    rates <- list(falsepos=x$rates$falsepos, trueneg=x$rates$trueneg, 
                  falseneg=as.vector(y$problo), truepos=as.vector(y$probhi))
          
    list(k=x$k, theta0=0, theta1=theta, I=x$I, a=x$a, b=x$b, alpha=alpha, beta=beta, 
        rates=rates, futilitybnd="Binding", tol=x$tol, r=x$r, error=x$error)
}

"gsbound1" <- function(theta, I, a, probhi, tol=0.000001, r=18, printerr=0)
{   
    # gsbound1: derive upper bound to match specified upper bound crossing probability given
    #           a value of theta, a fixed lower bound and information at each analysis   
 
    # check input arguments
    checkScalar(theta, "numeric")
    checkVector(I, "numeric", c(0, Inf), c(FALSE, TRUE))
    checkVector(a, "numeric")
    checkVector(probhi, "numeric", c(0,1), c(FALSE, FALSE))
    checkScalar(tol, "numeric", c(0, Inf), c(FALSE, TRUE))
    checkScalar(r, "integer", c(1, 80))
    checkScalar(printerr, "integer")
    checkLengths(a, probhi, I)
    
    # coerce type
    k <- as.integer(length(I))
    storage.mode(theta) <- "double"
    storage.mode(I) <- "double"
    storage.mode(a) <- "double"
    storage.mode(probhi) <- "double"
    storage.mode(tol) <- "double"
    problo <- a
    b <- a
    retval <- as.integer(0)
    xx <- .C("gsbound1", k, theta, I, a, b, problo, probhi, tol, as.integer(r), retval, 
          as.integer(printerr))
    y <- list(k=xx[[1]], theta=xx[[2]], I=xx[[3]], a=xx[[4]], b=xx[[5]], 
            problo=xx[[6]], probhi=xx[[7]], tol=xx[[8]], r=xx[[9]], error=xx[[10]])
    if (y$error==0 && min(y$b-y$a) < 0)
    {   
        indx <- (y$b - y$a < 0)
        y$b[indx] <- y$a[indx]
        z <- gsprob(theta=theta, I=I, a=a, b=y$b, r=r)
        y$probhi <- z$probhi
        y$problo <- z$problo
    }
    
    y
}

"gsbetadiff1" <- function(Imax, theta, tx, problo, b, tol=0.000001, r=18)
{   
    # gsbetadiff1: compute difference between desired and actual upper boundary
    #              crossing probability    
    I <- tx * Imax
    x <- gsbound1(theta=-theta, I=I, a=-b, probhi=problo, tol=tol, r=r)
    x <- gsprob(theta, I, -x$b, b, r=r)
    
    sum(problo) - 1 + x$powr
}

"gsI1" <- function(theta, I, beta, b, Ilow, Ihigh, tol=0.000001, r=18)
{
    # gsI1: get lower bound and maximum information (Imax)    
    k <- length(I)
    tx <- I / I[k]
    xr <- uniroot(gsbetadiff1, lower=Ilow, upper=Ihigh, theta=theta, tx=tx, 
            problo=beta, b=b, tol=tol, r=r)
    x <- gsbound1(-theta, xr$root*tx, -b, probhi=beta, tol=tol, r=r)
    error <- x$error
    x$b[k] <- -b[k]
    x <- gsprob(theta, xr$root*tx, -x$b, b, r=r)
    x$error <- error
    
    x
}

"gsprob" <- function(theta, I, a, b, r=18)
{     
    # gsprob: use call to C routine to compute upper and lower boundary crossing probabilities
    # given theta,  interim sample sizes (information: I),  lower bound (a) and upper bound (b)    
    nanal <- as.integer(length(I))
    ntheta <- as.integer(length(theta))
    phi <- as.double(c(1:(nanal*ntheta)))
    plo <- as.double(c(1:(nanal*ntheta)))
    xx <- .C("probrej", nanal, ntheta, as.double(theta), as.double(I), 
            as.double(a), as.double(b), plo, phi, as.integer(r))
    
    plo <- matrix(xx[[7]], nanal, ntheta)
    phi <- matrix(xx[[8]], nanal, ntheta)
    powr <- array(1, nanal)%*%phi
    futile <- array(1, nanal)%*%plo
    en <- I %*% (plo+phi) + I[nanal] * (t(array(1, ntheta)) - powr - futile)
    list(k=xx[[1]], theta=xx[[3]], I=xx[[4]], a=xx[[5]], b=xx[[6]], problo=plo, 
            probhi=phi, powr=powr, en=en, r=r)
}

"gsDProb" <- function(theta, d)
{    
    k <- d$k
    n.I <- d$n.I
    
    a <- if (d$test.type != 1) d$lower$bound else array(-20, k)    
    b <- d$upper$bound
    r <- d$r
    ntheta <- as.integer(length(theta))
    theta <- as.real(theta)
    
    if (!is.real(theta))
    {    
        errcode <- 2
        errmsg <- "theta must be real-valued"
    }
    
    phi <- as.double(c(1:(k*ntheta)))
    plo <- as.double(c(1:(k*ntheta)))
    xx <- .C("probrej", k, ntheta, as.double(theta), as.double(n.I), 
            as.double(a), as.double(b), plo, phi, r)
    plo <- matrix(xx[[7]], k, ntheta)
    phi <- matrix(xx[[8]], k, ntheta)
    powr <- as.vector(array(1, k) %*% phi)
    futile <- array(1, k) %*% plo
    en <- as.vector(n.I %*% (plo + phi) + n.I[k] * (t(array(1, ntheta)) - powr - futile))
    d$en <- en
    d$theta <- theta
    d$upper$prob <- phi
    
    if (d$test.type!=1)
    {
        d$lower$prob <- plo
    }
        
    d
}

"gsProbability" <- function(k=0, theta, n.I, a, b, r=18, d=NULL)
{
    # compute boundary crossing probabilities and return in a gsProbability structure
    
    # check input arguments
    checkScalar(k, "integer", c(0,30))
    checkVector(theta, "numeric")
    
    if (k == 0)
    {   
        if (!is(d,"gsDesign"))
        {
            stop("d should be an object of class gsDesign")
        }
        return(gsDProb(theta=theta, d=d))
    }
    
    # check remaingin input arguments
    checkScalar(r, "integer", c(1,80))
    checkLengths(n.I, a, b)
    if (k != length(a))
    {
        stop("Lengths of n.I, a, and b must all equal k")
    }

    ntheta <- as.integer(length(theta))
    phi <- as.double(c(1:(k * ntheta)))
    plo <- as.double(c(1:(k * ntheta)))
    xx <- .C("probrej", k, ntheta, as.double(theta), as.double(n.I), 
            as.double(a), as.double(b), plo, phi, r)
    plo <- matrix(xx[[7]], k, ntheta)
    phi <- matrix(xx[[8]], k, ntheta)
    powr <- as.vector(array(1, k) %*% phi)
    futile <- array(1, k) %*% plo
    en <- as.vector(n.I %*% (plo + phi) + n.I[k] * (t(array(1, ntheta)) - powr - futile))
    x <- list(k=xx[[1]], theta=xx[[3]], n.I=xx[[4]], lower=list(bound=xx[[5]], prob=plo), 
                    upper=list(bound=xx[[6]], prob=phi), en=en, r=r, errcode=0, errmsg="No error")
    
    class(x) <- "gsProbability"
    
    x
}

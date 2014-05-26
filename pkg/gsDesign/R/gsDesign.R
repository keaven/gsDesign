##################################################################################
#  Binomial functionality for the gsDesign package
#
#  Exported Functions:
#                   
#    gsBound
#    gsBound1
#    gsDesign
#    gsProbability
#    gsDensity
#    gsPOS
#    gsCPOS
#
#  Hidden Functions:
#
#    gsDType1
#    gsDType2and5
#    gsDType3
#    gsDType3ss
#    gsDType3a
#    gsDType3b
#    gsDType4
#    gsDType4a
#    gsDType4ss
#    gsDType6
#    gsbetadiff
#    gsI
#    gsbetadiff1
#    gsI1
#    gsprob
#    gsDProb
#    gsDErrorCheck
#
#  Author(s): Keaven Anderson, PhD. / Jennifer Sun, MS.
# 
#  Reviewer(s): REvolution Computing 19DEC2008 v.2.0 - William Constantine, Kellie Wills 
#
#  R Version: 2.7.2
#
##################################################################################

###
# Exported Functions
###

"gsBound" <- function(I, trueneg, falsepos, tol=0.000001, r=18)
{    
    # gsBound: assuming theta=0, derive lower and upper crossing boundaries given 
    #          timing of interims, false positive rates and true negative rates
    
    # check input arguments
    checkVector(I, "numeric", c(0, Inf), c(FALSE, TRUE))
    checkVector(trueneg, "numeric", c(0,1), c(TRUE, FALSE))
    checkVector(falsepos, "numeric", c(0,1), c(TRUE, FALSE))
    checkScalar(tol, "numeric", c(0, Inf), c(FALSE, TRUE))
    checkScalar(r, "integer", c(1, 80))
    checkLengths(trueneg, falsepos, I)    
    
    k <- as.integer(length(I))
    if (trueneg[k]<=0.) stop("Final futility spend must be > 0")
    if (falsepos[k]<=0.) stop("Final efficacy spend must be > 0")
    r <- as.integer(r)
    storage.mode(I) <- "double"
    storage.mode(trueneg) <- "double"
    storage.mode(falsepos) <- "double"
    storage.mode(tol) <- "double"
    a <- falsepos
    b <- falsepos
    retval <- as.integer(0)
    xx <- .C("gsbound", k, I, a, b, trueneg, falsepos, tol, r, retval)
    rates <- list(falsepos=xx[[6]], trueneg=xx[[5]])
    
    list(k=xx[[1]],theta=0.,I=xx[[2]],a=xx[[3]],b=xx[[4]],rates=rates,tol=xx[[7]],
            r=xx[[8]],error=xx[[9]])
}

"gsBound1" <- function(theta, I, a, probhi, tol=0.000001, r=18, printerr=0)
{   
    # gsBound1: derive upper bound to match specified upper bound crossing probability given
    #           a value of theta, a fixed lower bound and information at each analysis   
    
    # check input arguments
    checkScalar(theta, "numeric")
    checkVector(I, "numeric", c(0, Inf), c(FALSE, TRUE))
    checkVector(a, "numeric")
    checkVector(probhi, "numeric", c(0,1), c(TRUE, FALSE))
    checkScalar(tol, "numeric", c(0, Inf), c(FALSE, TRUE))
    checkScalar(r, "integer", c(1, 80))
    checkScalar(printerr, "integer")
    checkLengths(a, probhi, I)
    
    # coerce type
    k <- as.integer(length(I))
    if (probhi[k]<=0.) stop("Final spend must be > 0")
    r <- as.integer(r)
    printerr <- as.integer(printerr)
    
    storage.mode(theta) <- "double"
    storage.mode(I) <- "double"
    storage.mode(a) <- "double"
    storage.mode(probhi) <- "double"
    storage.mode(tol) <- "double"
    problo <- a
    b <- a
    retval <- as.integer(0)
    
    xx <- .C("gsbound1", k, theta, I, a, b, problo, probhi, tol, r, retval, printerr)
    
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

"gsDesign"<-function(k=3, test.type=4, alpha=0.025, beta=0.1, astar=0,  
        delta=0, n.fix=1, timing=1, sfu=sfHSD, sfupar=-4,
        sfl=sfHSD, sflpar=-2, tol=0.000001, r=18, n.I=0, maxn.IPlan=0, 
        nFixSurv=0, endpoint=NULL, delta1=1, delta0=0, overrun=0) 
{
    # Derive a group sequential design and return in a gsDesign structure
    
    # set up class variable x for gsDesign being requested
    x <- list(k=k, test.type=test.type, alpha=alpha, beta=beta, astar=astar,
            delta=delta, n.fix=n.fix, timing=timing, tol=tol, r=r, n.I=n.I, maxn.IPlan=maxn.IPlan,
            nFixSurv=nFixSurv, nSurv=0, endpoint=endpoint, delta1=delta1, delta0=delta0, overrun=overrun)
    
    class(x) <- "gsDesign"
    
    # check parameters other than spending functions
    x <- gsDErrorCheck(x)

    # set up spending for upper bound
    if (is.character(sfu))
    {  
        upper <- list(sf = sfu, name = sfu, parname = "Delta", param = sfupar)
        
        class(upper) <- "spendfn"
        
        if (!is.element(upper$name,c("OF", "Pocock" , "WT")))           
        {
            stop("Character specification of upper spending may only be WT, OF or Pocock")
        }
        
        if (is.element(upper$name, c("OF", "Pocock")))
        {    
            upper$param <- NULL
        }
    }
    else if (!is.function(sfu))
    {   
        stop("Upper spending function mis-specified")
    }
    else
    {   
        upper <- sfu(x$alpha, x$timing, sfupar)
        upper$sf <- sfu
    }
    
    x$upper <- upper
    
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
            stop("Lower spending function must return object with class spendfn")
        }
        else if (is.element(test.type, 3:4)) 
        {
            x$lower <- sfl(x$beta, x$timing, sflpar)
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
    }
    
    # call appropriate calculation routine according to test.type
    x <- switch(x$test.type,
            gsDType1(x),
            gsDType2and5(x),
            gsDType3(x),
            gsDType4(x),
            gsDType2and5(x),
            gsDType6(x))
    if (x$nFixSurv > 0) x$nSurv <- ceiling(x$nFixSurv * x$n.I[x$k] / n.fix / 2) * 2
    x
}

"gsProbability" <- function(k=0, theta, n.I, a, b, r=18, d=NULL, overrun=0)
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
    
    # check remaining input arguments
    checkVector(x=overrun,isType="numeric",interval=c(0,Inf),inclusion=c(TRUE,FALSE))
    if(length(overrun)!= 1 && length(overrun)!= k-1) stop(paste("overrun length should be 1 or ",as.character(k-1)))
    checkScalar(r, "integer", c(1,80))
    checkLengths(n.I, a, b)
    if (k != length(a))
    {
        stop("Lengths of n.I, a, and b must all equal k")
    }
    
    # cast integer scalars
    ntheta <- as.integer(length(theta))
    k <- as.integer(k)
    r <- as.integer(r)
    
    phi <- as.double(c(1:(k * ntheta)))
    plo <- as.double(c(1:(k * ntheta)))
    xx <- .C("probrej", k, ntheta, as.double(theta), as.double(n.I), 
            as.double(a), as.double(b), plo, phi, r)
    plo <- matrix(xx[[7]], k, ntheta)
    phi <- matrix(xx[[8]], k, ntheta)
    powr <- as.vector(array(1, k) %*% phi)
    futile <- array(1, k) %*% plo
    if(k==1){nOver <- n.I[k]}else{
      nOver <- c(n.I[1:(k-1)]+overrun,n.I[k])
    }
    nOver[nOver>n.I[k]] <- n.I[k]
    en <- as.vector(nOver %*% (plo + phi) + n.I[k] * (t(array(1, ntheta)) - powr - futile))
    x <- list(k=xx[[1]], theta=xx[[3]], n.I=xx[[4]], lower=list(bound=xx[[5]], prob=plo), 
            upper=list(bound=xx[[6]], prob=phi), en=en, r=r, overrun=overrun)
    
    class(x) <- "gsProbability"
    
    x
}

"gsPOS" <- function(x, theta, wgts)
{
    if (!is(x,c("gsProbability","gsDesign")))
      stop("x must have class gsProbability or gsDesign")
    checkVector(theta, "numeric")
    checkVector(wgts, "numeric")
    checkLengths(theta, wgts)    
    x <- gsProbability(theta = theta, d=x)
    one <- array(1, x$k)
    as.double(one %*% x$upper$prob %*% wgts)
}

"gsCPOS" <- function(i, x, theta, wgts)
{
    if (!is(x,c("gsProbability","gsDesign")))
      stop("x must have class gsProbability or gsDesign")
    checkScalar(i, "integer", c(1, x$k), c(TRUE, FALSE))
    checkVector(theta, "numeric")
    checkVector(wgts, "numeric")
    checkLengths(theta, wgts)    
    x <- gsProbability(theta = theta, d=x)
    v <- c(array(1, i), array(0, (x$k - i)))
    pAi <- 1 - as.double(v %*% (x$upper$prob + x$lower$prob) %*% wgts)
    v <- 1 - v
    pAiB <- as.double(v %*% x$upper$prob %*% wgts)
    pAiB / pAi
}

"gsDensity" <- function(x, theta=0, i=1, zi=0, r=18)
{   if (class(x) != "gsDesign" && class(x) != "gsProbability")
        stop("x must have class gsDesign or gsProbability.")
    checkVector(theta, "numeric")
    checkScalar(i, "integer", c(0,x$k), c(FALSE, TRUE))
    checkVector(zi, "numeric")
    checkScalar(r, "integer", c(1, 80)) 
    den <- array(0, length(theta) * length(zi))
    xx <- .C("gsdensity", den, as.integer(i), length(theta), 
              as.double(theta), as.double(x$n.I), 
              as.double(x$lower$bound), as.double(x$upper$bound),
              as.double(zi), length(zi), as.integer(r))
    list(zi=zi, theta=theta, density=matrix(xx[[1]], nrow=length(zi), ncol=length(theta)))
}


###
# Hidden Functions
###

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
        x$upper$bound <- gsBound1(0, x$timing, a, falsepos, x$tol, x$r)$b
    }

    # set information to get desired power (only if sample size is being computed)
    if (max(x$n.I) == 0)
    {
       x$n.I <- uniroot(gsbetadiff, lower=x$n.fix, upper=10*x$n.fix, theta=x$delta, beta=x$beta,
                        time=x$timing, a=a, b=x$upper$bound, tol=x$tol, r=x$r)$root * x$timing
    }
    
    # add boundary crossing probabilities for theta to x
    x$theta <- c(0,x$delta)
    y <- gsprob(x$theta, x$n.I, a, x$upper$bound, r=x$r, overrun=x$overrun)
    x$upper$prob <- y$probhi
    x$en <- as.vector(y$en)

    # return error if boundary crossing probabilities do not meet desired tolerance
    if (max(abs(falsepos - y$probhi[,1])) > x$tol)
    {
        stop("False positive rates not achieved")   
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
            stop("Wang-Tsiatis, Pocock and O'Brien-Fleming bounds not available for asymmetric testing")          
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
        {   trueneg <- x$lower$spend
            trueneg <- trueneg - c(0,trueneg[1:x$k-1])
            errno <- 0
        }
        else 
        {   trueneg <- falsepos
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
            x2 <- gsBound(I=x$n.I, trueneg=trueneg, falsepos=falsepos, tol=x$tol, r=x$r)
        }
        
        x$upper$bound <- x2$b
        x$lower$bound <- x2$a
    }
    
    x$theta <- c(0, x$delta)
    y <- gsprob(x$theta, x$n.I, x$lower$bound, x$upper$bound, r=x$r, overrun=x$overrun)
    x$upper$prob <- y$probhi
    x$lower$prob <- y$problo
    x$en <- as.vector(y$en)

    # return error if boundary crossing probabilities to not meet desired tolerance
    if (max(abs(falsepos - x$upper$prob[,1])) > x$tol)
    {
        stop("False positive rates not achieved")        
    }

    if (max(abs(trueneg - x$lower$prob[,1])) > x$tol)
    {
        stop("False negative rates not achieved")
    }

    x
}

"gsDType3" <- function(x)
{
    # Check added by K. Wills 12/4/2008
    if (is.element(x$upper$name, c("WT","Pocock","OF")))
    {    
        stop("Wang-Tsiatis, Pocock and O'Brien-Fleming bounds not available for asymmetric testing")  
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
    falsepos <- falsepos-c(0, falsepos[1:x$k-1])
    x$upper$spend <- falsepos
    trueneg <- array((1 - x$alpha) / x$k, x$k)
    x1 <- gsBound(x$timing, trueneg, falsepos, x$tol, x$r)

    # get I(max) and lower bound
    I0 <- x$n.fix
    falseneg <- x$lower$spend
    falseneg <- falseneg-c(0, falseneg[1:x$k-1])
    x$lower$spend <- falseneg
    Ilow <- x$n.fix / 3
    Ihigh <- 1.2 * x$n.fix
    while (0 > gsbetadiff1(Imax=Ihigh, theta=x$delta, tx=x$timing, 
                         problo=falseneg, b=x1$b, tol=x$tol, r=x$r))
    {   if (Ihigh > 5 * x$n.fix)
            stop("Unable to derive sample size")
        Ilow <- Ihigh
        Ihigh <- Ihigh * 1.2
    }
    x2 <- gsI1(theta=x$delta, I=x$timing, beta=falseneg, b=x1$b, Ilow=Ilow,
               Ihigh=Ihigh, x$tol, x$r)
    
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
        x4 <- gsBound1(0, I, c(x2$a[1:k-1],-20), falsepos)
        Ilow <- x$n.fix / 3
        Ihigh <- 1.2 * x$n.fix
        while (0 > gsbetadiff1(Imax=Ihigh, theta=x$delta, tx=x$timing, 
                         problo=falseneg, b=x4$b, tol=x$tol, r=x$r))
        {   if (Ihigh > 5 * x$n.fix)
                stop("Unable to derive sample size")
            Ilow <- Ihigh
            Ihigh <- Ihigh * 1.2
        }
        x2 <- gsI1(theta=x$delta, I=x$timing, beta=falseneg, b=x4$b, 
                   Ilow=Ilow,Ihigh=Ihigh,x$tol,x$r)
        x3 <- gsprob(0,x2$I,x2$a,x2$b)
        gspowr <- x3$powr
        I <- x2$I
        flag <- max(abs(c(gspowr-x$alpha,falsepos - x3$probhi))) # bug fix here, 20140221, KA
        jj <- jj + 1
    }

    # add bounds and information to x
    x$upper$bound <- x2$b
    x$lower$bound <- x2$a
    x$n.I <- x2$I

    # add boundary crossing probabilities for theta to x
    x$theta <- c(0, x$delta)
    x4 <- gsprob(x$theta, x2$I, x2$a, x2$b, overrun=x$overrun)
    x$upper$prob <- x4$probhi
    x$lower$prob <- x4$problo
    x$en <- as.vector(x4$en)

    # return error if boundary crossing probabilities 
    # do not meet desired tolerance
    if (max(abs(falsepos - x3$probhi)) > x$tol)
    {
        stop("False positive rates not achieved")       
    }

    if (max(abs(falseneg - x2$problo)) > x$tol)
    {
        stop("False negative rates not achieved")       
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
    x1 <- gsBound(x$timing, trueneg, falsepos, x$tol, x$r)
    
    # x$k==1 is a special case
    if (x$k == 1)
    {    
        x$upper$bound <- x1$b
        x$lower$bound <- x1$b
    }
    else
    {
        # get initial lower bound
          x2 <- gsBound1(theta = -x$delta, I = x$n.I, a = -x1$b, probhi = falseneg, tol = x$tol, r = x$r)
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
            x4 <- gsBound1(0, x$n.I, a, falsepos)
            x2 <- gsBound1(theta=-x$delta, I=x$n.I, a=-x4$b, probhi=falseneg, tol=x$tol, r=x$r)
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
    x4 <- gsprob(x$theta,x$n.I,x$lower$bound,x$upper$bound,overrun=x$overrun)
    x$upper$prob <- x4$probhi
    x$lower$prob <- x4$problo
    x$en <- as.vector(x4$en)
    
    x
}

"gsDType4" <- function(x)
{
    # Check added by K. Wills 12/4/2008
    if (is.element(x$upper$name, c("WT","Pocock","OF")))
    {    
        stop("Wang-Tsiatis, Pocock and O'Brien-Fleming bounds not available for asymmetric testing")       
    }
    
    if (length(x$n.I) < x$k) gsDType4ss(x) 
    else gsDType4a(x)
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
    x1 <- gsBound1(theta = 0, I = x$n.I, a = array(-20, x$k), probhi = falsepos, tol = x$tol, r = x$r)

    # get lower bound
    x2 <- gsBound1(theta = -x$delta, I = x$n.I, a = -x1$b, probhi = falseneg, tol = x$tol, r = x$r)
    if (-x2$b[x2$k] > x1$b[x1$k] - x$tol)
    {
        x2$b[x2$k] <- -x1$b[x1$k]
    }

    # add bounds and information to x
    x$upper$bound <- x1$b
    x$lower$bound <- -x2$b

    # add boundary crossing probabilities for theta to x
    x$theta <- c(0, x$delta)
    x4 <- gsprob(x$theta, x$n.I, -x2$b, x1$b, overrun=x$overrun)
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
    x0 <- gsBound1(0., x$timing, array(-20, x$k), falsepos, x$tol, x$r)

    # get beta spending (falseneg)
    falseneg <- x$lower$spend
    falseneg <- falseneg-c(0,falseneg[1:x$k-1])
    x$lower$spend <- falseneg

    # find information and boundaries needed 
    I0 <- x$n.fix
    Ilow <- .98 * I0
    Ihigh <- 1.2 * I0
    while (0 > gsbetadiff1(Imax=Ihigh, theta=x$delta, tx=x$timing, 
                         problo=falseneg, b=x0$b, tol=x$tol, r=x$r))
    {   if (Ihigh > 5 * I0)
            stop("Unable to derive sample size")
        Ilow <- Ihigh
        Ihigh <- Ihigh * 1.2
    }
    xx <- gsI1(theta = x$delta, I = x$timing, beta = falseneg, b = x0$b, Ilow = Ilow, Ihigh = Ihigh, x$tol, x$r)
    x$lower$bound <- xx$a
    x$upper$bound <- xx$b
    x$n.I <- xx$I

    # compute additional error rates needed and add to x
    x$theta <- c(0, x$delta)
    x$falseposnb <- as.vector(gsprob(0, xx$I, array(-20, x$k), x0$b, r=x$r)$probhi)
    x3 <- gsprob(x$theta, xx$I, xx$a, x0$b, r=x$r, overrun=x$overrun)
    x$upper$prob <- x3$probhi
    x$lower$prob <- x3$problo
    x$en <- as.vector(x3$en)

    # return error if boundary crossing probabilities do not meet desired tolerance
    if (max(abs(falsepos-x$falseposnb)) > x$tol)
    {
        stop("False positive rates not achieved")
    }

    if (max(abs(falseneg-x$lower$prob[,2])) > x$tol)
    {
        stop("False negative rates not achieved")      
    }

    x
}

"gsDType6" <- function(x)
{
    # Check added by K. Wills 12/4/2008
    if (is.element(x$upper$name, c("WT","Pocock","OF")))
    {    
        stop("Wang-Tsiatis, Pocock and O'Brien-Fleming bounds not available for asymmetric testing")          
    }
    
    if (length(x$n.I) == x$k) x$timing <- x$n.I / x$maxn.IPlan

    # compute upper bounds with non-binding assumption 
    falsepos <- x$upper$spend
    falsepos <- falsepos-c(0, falsepos[1:x$k-1])
    x$upper$spend <- falsepos
    x0 <- gsBound1(0., x$timing, array(-20, x$k), falsepos, x$tol, x$r)
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
            xx <- gsBound1(0, x$timing, -x$upper$bound, trueneg, x$tol, x$r)
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
          xx <- gsBound1(0, x$timing, -x$upper$bound, x$lower$spend, x$tol, x$r)
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
    x3 <- gsprob(x$theta, x$n.I, x$lower$bound, x$upper$bound, r=x$r, overrun=x$overrun)
    x$upper$prob <- x3$probhi
    x$lower$prob <- x3$problo
    x$en <- as.vector(x3$en)

    # return error if boundary crossing probabilities do not meet desired tolerance
    if (max(abs(falsepos-x$falseposnb)) > x$tol)
    {
        stop("False positive rates not achieved")       
    }

    if (max(abs(trueneg[1:x$k-1] - x$lower$prob[1:x$k-1,1])) > x$tol)
    {
        stop("True negative rates not achieved")    
    }

    x
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
    x <- gsBound(I, trueneg, falsepos, tol, r)
    alpha <- sum(falsepos)
    I0 <- ((qnorm(alpha)+qnorm(beta))/theta)^2
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

"gsbetadiff1" <- function(Imax, theta, tx, problo, b, tol=0.000001, r=18)
{   
    # gsbetadiff1: compute difference between desired and actual upper boundary
    #              crossing probability    
    I <- tx * Imax
    x <- gsBound1(theta=-theta, I=I, a=-b, probhi=problo, tol=tol, r=r)
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
    x <- gsBound1(-theta, xr$root*tx, -b, probhi=beta, tol=tol, r=r)
    error <- x$error
    x$b[k] <- -b[k]
    x <- gsprob(theta, xr$root*tx, -x$b, b, r=r)
    x$error <- error
    
    x
}

"gsprob" <- function(theta, I, a, b, r=18, overrun=0)
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
    IOver <- c(I[1:(nanal-1)]+overrun,I[nanal])
    IOver[IOver>I[nanal]]<-I[nanal]
    en <- as.vector(IOver %*% (plo+phi) + I[nanal] * (t(array(1, ntheta)) - powr - futile))
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
    theta <- as.double(theta)
    
    phi <- as.double(c(1:(k*ntheta)))
    plo <- as.double(c(1:(k*ntheta)))
    xx <- .C("probrej", k, ntheta, as.double(theta), as.double(n.I), 
            as.double(a), as.double(b), plo, phi, r)
    plo <- matrix(xx[[7]], k, ntheta)
    phi <- matrix(xx[[8]], k, ntheta)
    powr <- as.vector(array(1, k) %*% phi)
    futile <- array(1, k) %*% plo
    if (k==1){IOver <- n.I}else{
      IOver <- c(n.I[1:(k-1)]+d$overrun,n.I[k])
    }
    IOver[IOver>n.I[k]]<-n.I[k]
    en <- as.vector(IOver %*% (plo+phi) + n.I[k] * (t(array(1, ntheta)) - powr - futile))

    d$en <- en
    d$theta <- theta
    d$upper$prob <- phi
    
    if (d$test.type!=1)
    {
        d$lower$prob <- plo
    }
        
    d
}

"gsDErrorCheck" <- function(x)
{
    # check input arguments for type, range, and length
    
    # check input value of k, test.type, alpha, beta, astar
    checkScalar(x$k, "integer", c(1,Inf))
    checkScalar(x$test.type, "integer", c(1,6))
    checkScalar(x$alpha, "numeric", 0:1, c(FALSE, FALSE))
    if (x$test.type == 2 && x$alpha > 0.5)
    {
        checkScalar(x$alpha, "numeric", c(0,0.5), c(FALSE, TRUE))
    }
    checkScalar(x$beta, "numeric", c(0, 1-x$alpha), c(FALSE,FALSE))
    if (x$test.type > 4)
    {   
        checkScalar(x$astar, "numeric", c(0, 1-x$alpha))
        if (x$astar == 0) 
        {
            x$astar <- 1 - x$alpha
        }
    }
    
    # check delta, n.fix
    checkScalar(x$delta, "numeric", c(0,Inf))
    if (x$delta == 0)
    {
        checkScalar(x$n.fix, "numeric", c(0,Inf), c(FALSE,TRUE))
        x$delta <- abs(qnorm(x$alpha) + qnorm(x$beta)) / sqrt(x$n.fix)
    }
    else
    {
        x$n.fix <- ((qnorm(x$alpha) + qnorm(x$beta)) / x$delta)^2
    }
    
    # check n.I, maxn.IPlan
    checkVector(x$n.I, "numeric")
    checkScalar(x$maxn.IPlan, "numeric", c(0,Inf))
    if (max(abs(x$n.I)) > 0)
    {
        checkRange(length(x$n.I), c(2,Inf))
        if (!(all(sort(x$n.I) == x$n.I) && all(x$n.I > 0)))
        {
            stop("n.I must be an increasing, positive sequence")
        }
        
        if (x$maxn.IPlan <= 0) 
        {
            x$maxn.IPlan<-max(x$n.I)
        }
        else if (x$test.type < 3 && is.character(x$sfu))
        {
            stop("maxn.IPlan can only be > 0 if spending functions are used for boundaries")
        }

        x$timing <- x$n.I / x$maxn.IPlan
        
        if (x$n.I[x$k-1] >= x$maxn.IPlan)
        {
            stop("Only 1 n >= Planned Final n")        
        }
    }
    else if (x$maxn.IPlan > 0)
    {   
        if (length(x$n.I) == 1)
        {
            stop("If maxn.IPlan is specified, n.I must be specified")
        }
    }    
    
    # check input for timing of interim analyses
    # if timing not specified, make it equal spacing
    # this only needs to be done if x$n.I==0; KA added 2013/11/02
    if (max(x$n.I)==0){
      if (length(x$timing) < 1 || (length(x$timing) == 1 && (x$k > 2 || (x$k == 2 && (x$timing[1] <= 0 || x$timing[1] >= 1)))))
      {
          x$timing <- seq(x$k) / x$k
      }
      # if timing specified, make sure it is done correctly
      else if (length(x$timing) == x$k - 1 || length(x$timing) == x$k) 
      {   
  # put back requirement that final analysis timing must be 1, if specified; KA 2013/11/02
          if (length(x$timing) == x$k - 1)
          {
              x$timing <- c(x$timing, 1)
          }
          else if (x$timing[x$k]!=1)
          {
            stop("if analysis timing for final analysis is input, it must be 1")           
          }

          if (min(x$timing - c(0,x$timing[1:(x$k-1)])) <= 0)
          {
            stop("input timing of interim analyses must be increasing strictly between 0 and 1")           
          }
      }
      else
      {
          stop("value input for timing must be length 1, k-1 or k")
      }
    }
    # check input values for tol, r
    checkScalar(x$tol, "numeric", c(0, 0.1), c(FALSE, TRUE))
    checkScalar(x$r, "integer", c(1,80))
    
    # now that the checks have completed, coerce integer types
    # this is necessary because certain plot types will NOT work 
    # otherwise.
    x$k <- as.integer(x$k)
    x$test.type <- as.integer(x$test.type)
    x$r <- as.integer(x$r)
    
    # check overrun vector
    checkVector(x$overrun,interval=c(0,Inf),inclusion=c(TRUE,FALSE))
    if(length(x$overrun)!= 1 && length(x$overrun)!= x$k-1) stop(paste("overrun length should be 1 or ",as.character(x$k-1)))
  
    x
}

##################################################################################
#  Spending functions for the gsDesign package
#
#  Exported Functions:
#                   
#    sfBetaDist
#    sfCauchy
#    sfExponential
#    sfExtremeValue
#    sfExtremeValue2
#    sfHSD
#    sfLDOF
#    sfLDPocock
#    sfLogistic
#    sfNormal
#    sfPoints
#    sfPower
#    sfTDist
#    spendingFunction
#
#  Hidden Functions:
#
#    Tdistdiff
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

"sfBetaDist" <- function(alpha, t, param)
{  
    x <- list(name="Beta distribution", param=param, parname=c("a","b"), sf=sfBetaDist, spend=NULL,
            bound=NULL, prob=NULL)  
    
    class(x) <- "spendfn"
    
    len <- length(param)
    
    if (len == 2)
    {   
        checkVector(param, "numeric", c(0, Inf), c(FALSE, TRUE))
    }    
    else if (len == 4)
    {   
        checkVector(param, "numeric", c(0, 1), c(FALSE, FALSE))
        
        tem <- nlminb(c(1, 1), diffbetadist, lower=c(0, 0), xval=param[1:2], uval=param[3:4])
        
        if (tem$convergence != 0)
        { 
            stop("Solution to 4-parameter specification of Beta distribution spending function not found.")
        }
        
        x$param <- tem$par
    }
    else
    {
        stop("Beta distribution spending function parameter must be of length 2 or 4")        
    }
    
    t[t > 1] <- 1
    
    x$spend <- alpha * pbeta(t, x$param[1], x$param[2])
    
    x
}

"sfCauchy" <- function(alpha, t, param)
{  
    x <- list(name="Cauchy", param=param, parname=c("a", "b"), sf=sfCauchy, spend=NULL, 
            bound=NULL, prob=NULL)
    
    class(x) <- "spendfn"
    
    checkVector(param, "numeric")
    len <- length(param)
    
    if (len == 2)    
    {        
        if (param[2] <= 0.) 
        {
            stop("Second Cauchy spending parameter param[2] must be real value > 0")
        }
        
        a <- param[1]
        b <- param[2]
    }
    else if (len == 4) 
    {   
        t0 <- param[1:2]
        p0 <- param[3:4]
        
        if (t0[2] <= t0[1] || p0[2] <= p0[1]) 
        {
            stop("4-parameter specification of Cauchy function incorrect")
        }
        
        xv <- qcauchy(t0)
        y <- qcauchy(p0)
        b <- (y[2] - y[1]) / (xv[2] - xv[1])
        a <- y[2] - b * xv[2]
        x$param <- c(a, b)
    }
    else
    {
        stop("Cauchy spending function parameter must be of length 2 or 4")
    }
    
    t[t > 1] <- 1
    xv <- qcauchy(1 * (!is.element(t, 1)) * t)
    y <- pcauchy(a + b * xv)
    x$spend <- alpha * (1 * (!is.element(t, 1)) * y + 1 * is.element(t, 1))
    
    x
}

"sfExponential" <- function(alpha, t, param)
{  
    # K. Wills 12/11/08: restrict param range
    # checkScalar(param, "numeric", c(0, 10), c(FALSE, TRUE))
    checkScalar(param, "numeric", c(0, 1.5), c(FALSE, TRUE))
    
    t[t > 1] <- 1
    
    x <- list(name="Exponential", param=param, parname="nu", sf=sfExponential, 
            spend=alpha ^ (t ^ (-param)), bound=NULL, prob=NULL)  
    
    class(x) <- "spendfn"
    
    x
}

"sfExtremeValue" <- function(alpha, t, param)
{  
    x <- list(name="Extreme value", param=param, parname=c("a", "b"), sf=sfExtremeValue, spend=NULL, 
            bound=NULL, prob=NULL)
    
    class(x) <- "spendfn"
    
    checkVector(param, "numeric")
    len <- length(param)
    
    if (len == 2)
    {    
        if (param[2] <= 0.) 
        {
            stop("Second extreme value spending parameter param[2] must be real value > 0")
        }
        
        a <- param[1]
        b <- param[2]
    }
    else if (len == 4)
    {   
        t0 <- param[1:2]
        p0 <- param[3:4]
        
        if (t0[2] <= t0[1] || p0[2] <= p0[1]) 
        {
            stop("4-parameter specification of extreme value function incorrect")
        }
        
        xv <-  -log(-log(t0))
        y <-  -log(-log(p0))
        b <- (y[2] - y[1]) / (xv[2] - xv[1])
        a <- y[2] - b * xv[2]
        x$param <- c(a, b)
    }
    else
    {
        stop("Extreme value spending function parameter must be of length 2 or 4")
    }
    
    t[t > 1] <- 1
    xv <-  -log(-log((!is.element(t, 1)) * t))
    y <- exp(-exp(-a-b * xv))
    x$spend <- alpha * (1 * (!is.element(t, 1)) * y + 1 * is.element(t, 1))
    
    x
}

"sfExtremeValue2" <- function(alpha, t, param)
{  
    x <- list(name="Extreme value 2", param=param, parname=c("a", "b"), sf=sfExtremeValue2, spend=NULL, 
            bound=NULL, prob=NULL)
    
    class(x) <- "spendfn"
    
    checkVector(param, "numeric")
    len <- length(param)
    
    if (len == 2)
    {    
        if (param[2] <= 0.)
        {
            stop("Second extreme value (2) spending parameter param[2] must be real value > 0")
        }
        
        a <- param[1]
        b <- param[2]
    }
    else if (len == 4)
    {   
        t0 <- param[1:2]
        p0 <- param[3:4]
        
        if (t0[2] <= t0[1] || p0[2] <= p0[1]) 
        {
            stop("4-parameter specification of extreme value (2) function incorrect")
        }
        
        xv <- log(-log(1 - t0))
        y <- log(-log(1 - p0))
        b <- (y[2] - y[1]) / (xv[2] - xv[1])
        a <- y[2] - b * xv[2]
        x$param <- c(a, b)
    }
    else
    {
        stop("Extreme value (2) spending function parameter must be of length 2 or 4")
    }
    
    t[t > 1] <- 1
    xv <- log(-log(1 - 1 * (!is.element(t, 1)) * t))
    y <- 1 - exp(-exp(a + b * xv))
    x$spend <- alpha * (1 * (!is.element(t, 1)) * y + 1 * is.element(t, 1))
    
    x
}

"sfHSD" <- function(alpha, t, param)
{
    checkScalar(param, "numeric", c(-40, 40))
    
    t[t > 1] <- 1
    
    x <- list(name="Hwang-Shih-DeCani", param=param, parname="gamma", sf=sfHSD, 
            spend=if (param == 0) t * alpha else alpha * (1. - exp(-t * param)) / (1 - exp(-param)),
            bound=NULL, prob=NULL)  
    
    class(x) <- "spendfn"
    
    x
}

"sfLDOF" <- function(alpha, t, param)
{    
    z <- - qnorm(alpha / 2)
    
    t[t > 1] <- 1
    x <- list(name="Lan-DeMets O'brien-Fleming approximation", param=NULL, parname="none", sf=sfLDOF, 
            spend=2 * (1 - pnorm(z / sqrt(t))), bound=NULL, prob=NULL)  
    
    class(x) <- "spendfn"
    
    x
}

"sfLDPocock" <- function(alpha, t, param)
{  
    t[t > 1] <- 1
    
    x <- list(name="Lan-DeMets Pocock approximation", param=NULL, parname="none", sf=sfLDPocock, 
            spend=alpha * log(1 + (exp(1) - 1) * t), bound=NULL, prob=NULL)  
    
    class(x) <- "spendfn"
    
    x
}

"sfLogistic" <- function(alpha, t, param)
{  
    checkVector(param, "numeric")
    len <- length(param)
    
    if (len == 2)
    {
        if (!is.numeric(param[1])) 
        {
            stop("Numeric first logistic spending parameter not given")
        }
        if (param[2] <= 0.) 
        {
            stop("Second logistic spending parameter param[2] must be real value > 0")
        }
        
        a <- param[1]
        b <- param[2]
    }
    else if (len == 4)
    {   
        checkRange(param, inclusion=c(FALSE, FALSE))
        t0 <- param[1:2]
        p0 <- param[3:4]
        
        if (t0[2] <= t0[1] || p0[2] <= p0[1]) 
        {
            stop("4-parameter specification of logistic function incorrect")
        }
        
        xv <- log(t0 / (1 - t0))
        y <- log(p0 / (1 - p0))
        b <- (y[2] - y[1]) / (xv[2] - xv[1])
        a <- y[2] - b * xv[2]
        param <- c(a, b)
    }
    else
    {
        stop("Logistic spending function parameter must be of length 2 or 4")
    }
    
    xv <- log(t / (1 - 1 * (!is.element(t, 1)) * t))
    y <- exp(a + b * xv)
    y <- y / (1 + y)
    t[t > 1] <- 1
    
    x <- list(name="Logistic", param=param, parname=c("a", "b"), sf=sfLogistic, 
            spend=alpha * (1 * (!is.element(t, 1)) * y + 1 * is.element(t, 1)), 
            bound=NULL, prob=NULL)
    
    class(x) <- "spendfn"
    
    x
}

"sfNormal" <- function(alpha, t, param)
{  
    x <- list(name="Normal", param=param, parname=c("a", "b"), sf=sfNormal, spend=NULL, 
            bound=NULL, prob=NULL)
    
    class(x) <- "spendfn"
    
    checkVector(param, "numeric")
    len <- length(param)
    
    if (len == 2)    
    {    
        if (param[2] <= 0.) 
        {
            stop("Second Normal spending parameter param[2] must be real value > 0")
        }
        
        a <- param[1]
        b <- param[2]
    }
    else if (len == 4) 
    {   
        t0 <- param[1:2]
        p0 <- param[3:4]
        
        if (t0[2] <= t0[1] || p0[2] <= p0[1]) 
        {
            stop("4-parameter specification of Normal function incorrect")
        }
        
        xv <- qnorm(t0)
        y <- qnorm(p0)
        b <- (y[2] - y[1]) / (xv[2] - xv[1])
        a <- y[2] - b * xv[2]
        x$param <- c(a, b)
    }
    else
    {
        stop("Normal spending function parameter must be of length 2 or 4")
    }
    
    t[t > 1] <- 1
    xv <- qnorm(1 * (!is.element(t, 1)) * t)
    y <- pnorm(a + b * xv)
    x$spend <- alpha * (1 * (!is.element(t, 1)) * y + 1 * is.element(t, 1))
    
    x
}

"sfPoints" <- function(alpha, t, param)
{  
    x <- list(name="User-specified", param=param, parname="Points", sf=sfPoints, spend=NULL, 
            bound=NULL, prob=NULL)
    
    class(x) <- "spendfn"
    
    k <- length(t)
    j <- length(param)
    
    if (j == k - 1)
    { 
        x$param <- c(param, 1)
        j <- k
    }
    
    if (j != k)
    { 
        stop("Cumulative user-specified proportion of spending must be specified for each interim analysis")
    }
    
    if (!is.numeric(param))
    { 
        stop("Numeric user-specified spending levels not given")
    }    
    
    incspend <- x$param - c(0, x$param[1:k-1])
    
    if (min(incspend) <=  0.)
    { 
        stop("Cumulative user-specified spending levels must increase with each analysis")
    }
    
    if (max(x$param) > 1.)
    { 
        stop("Cumulative user-specified spending must be > 0 and <= 1")
    }
    
    x$spend <- alpha * x$param
    
    x
}

"sfPower" <- function(alpha, t, param)
{
    # K. Wills 12/11/08: restrict param range
    # checkScalar(param, "numeric", c(0, Inf), c(FALSE, TRUE))
    checkScalar(param, "numeric", c(0, 15), c(FALSE, TRUE))
    
    t[t > 1] <- 1
    
    x <- list(name="Kim-DeMets (power)", param=param, parname="rho", sf=sfPower, 
            spend=alpha * t ^ param, bound=NULL, prob=NULL)  
    
    class(x) <- "spendfn"
    
    x
}

"sfTDist" <- function(alpha, t, param)
{  
    x <- list(name="t-distribution", param=param, parname=c("a", "b", "df"), sf=sfTDist, spend=NULL, 
            bound=NULL, prob=NULL)
    
    class(x) <- "spendfn"
    
    checkVector(param, "numeric")
    len <- length(param)
    
    if (len == 3)    
    {    
        if (param[3] < 1.) 
        {
            stop("Final t-distribution spending parameter must be real value at least 1")
        }
        
        a <- param[1]   
        b <- param[2]
        df <- param[3]
    }
    else if (len == 5) 
    {   
        t0 <- param[1:2]
        p0 <- param[3:4]
        df <- param[5]
        
        if (param[5] < 1.) 
        {
            stop("Final t-distribution spending parameter must be real value at least 1")
        }
        
        if (t0[2] <= t0[1] || p0[2] <= p0[1]) 
        {
            stop("5-parameter specification of t-distribution spending function incorrect")
        }
        
        xv <- qt(t0, df)
        y <- qt(p0, df)
        b <- (y[2] - y[1]) / (xv[2] - xv[1])
        a <- y[2] - b * xv[2]
    }
    else if (len == 6) 
    {   
        t0 <- param[1:3]
        p0 <- param[4:6]
        
        if (t0[2] <= t0[1] || p0[2] <= p0[1]) 
        {
            stop("6-parameter specification of t-distribution spending function incorrect")
        }
        
        # check Cauchy and normal which must err in opposite directions for a solution to exist
        unorm <- sfNormal(alpha, t0[3], param=c(t0[1:2], p0[1:2]))$spend / alpha - p0[3]
        ucauchy <- sfCauchy(alpha, t0[3], param=c(t0[1:2], p0[1:2]))$spend / alpha - p0[3]
        
        if (unorm * ucauchy >= 0.) 
        {
            stop("6-parameter specification of t-distribution spending function did not produce a solution")
        }
        
        sol <- uniroot(Tdistdiff, interval=c(1, 200), t0=t0, p0=p0)
        df <- sol$root
        xv <- qt(t0, df)
        y <- qt(p0, df)
        b <- (y[2] - y[1]) / (xv[2] - xv[1])
        a <- y[2] - b * xv[2]
    }
    else
    {
        stop("t-distribution spending function parameter must be of length 3, 5 or 6")
    }
    
    x$param <- c(a, b, df)
    t[t > 1] <- 1
    xv <- qt(1 * (!is.element(t, 1)) * t, df)
    y <- pt(a + b * xv, df)
    x$spend <- alpha * (1 * (!is.element(t, 1)) * y + 1 * is.element(t, 1))
    
    x
}

"diffbetadist" <- function(aval, xval, uval)
{   
    if (min(aval) <= 0.)
    {
        return(1000)
    }
    
    diff <- uval - pbeta(xval, aval[1], aval[2])
    
    sum(diff ^ 2)
}

"spendingFunction" <- function(alpha, t, param)
{      
    t[t > 1] <- 1
    
    x <- list(name="Linear", param=param, parname="none", sf=spendingFunction, spend=alpha * t, 
            bound=NULL, prob=NULL)
    
    class(x) <- "spendfn"
    
    x
}

###
# Hidden Functions
###

"Tdistdiff" <- function(x, t0, p0)
{  
    xv <- qt(t0, x)
    y <- qt(p0, x)
    b <- (y[2] - y[1]) / (xv[2] - xv[1])
    a <- y[2] - b * xv[2]
   
    a + b * xv[3] - y[3]
}



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
#    sfLinear
#    sfStep
#    sfLogistic
#    sfNormal
#    sfPoints
#    sfPower
#    sfTDist
#    sfTruncated
#    sfTrimmed
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
    
    checkScalar(alpha, "numeric", c(0, Inf), c(FALSE, FALSE))
    checkVector(t, "numeric", c(0, Inf), c(TRUE, FALSE))
    t[t>1] <- 1

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
    
    checkScalar(alpha, "numeric", c(0, Inf), c(FALSE, FALSE))
    class(x) <- "spendfn"
    
    checkVector(t, "numeric", c(0, Inf), c(TRUE, FALSE))
    t[t>1] <- 1

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
    checkScalar(alpha, "numeric", c(0, Inf), c(FALSE, FALSE))
    # K. Wills 12/11/08: restrict param range
    # checkScalar(param, "numeric", c(0, 10), c(FALSE, TRUE))
    checkScalar(param, "numeric", c(0, 1.5), c(FALSE, TRUE))
    
    checkVector(t, "numeric", c(0, Inf), c(TRUE, FALSE))
    t[t>1] <- 1
    
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
    
    checkScalar(alpha, "numeric", c(0, Inf), c(FALSE, FALSE))
    checkVector(t, "numeric", c(0, Inf), c(TRUE, FALSE))
    t[t>1] <- 1

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
    
    checkScalar(alpha, "numeric", c(0, Inf), c(FALSE, FALSE))
    checkVector(t, "numeric", c(0, Inf), c(TRUE, FALSE))
    t[t>1] <- 1

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
    checkScalar(alpha, "numeric", c(0, Inf), c(FALSE, FALSE))
    checkScalar(param, "numeric", c(-40, 40))
    
    checkVector(t, "numeric", c(0, Inf), c(TRUE, FALSE))
    t[t>1] <- 1
    
    x <- list(name="Hwang-Shih-DeCani", param=param, parname="gamma", sf=sfHSD, 
            spend=if (param == 0) t * alpha else alpha * (1. - exp(-t * param)) / (1 - exp(-param)),
            bound=NULL, prob=NULL)  
    
    class(x) <- "spendfn"
    
    x
}

"sfLDOF" <- function(alpha, t, param)
{    
    checkScalar(alpha, "numeric", c(0, Inf), c(FALSE, FALSE))
    checkVector(t, "numeric", c(0, Inf), c(TRUE, FALSE))
    t[t>1] <- 1

    z <- - qnorm(alpha / 2)
    
    x <- list(name="Lan-DeMets O'brien-Fleming approximation", param=NULL, parname="none", sf=sfLDOF, 
            spend=2 * (1 - pnorm(z / sqrt(t))), bound=NULL, prob=NULL)  
    
    class(x) <- "spendfn"
    
    x
}

"sfLDPocock" <- function(alpha, t, param)
{  
    checkScalar(alpha, "numeric", c(0, Inf), c(FALSE, FALSE))
    checkVector(t, "numeric", c(0, Inf), c(TRUE, FALSE))
    t[t>1] <- 1

    
    x <- list(name="Lan-DeMets Pocock approximation", param=NULL, parname="none", sf=sfLDPocock, 
            spend=alpha * log(1 + (exp(1) - 1) * t), bound=NULL, prob=NULL)  
    
    class(x) <- "spendfn"
    
    x
}

"sfLogistic" <- function(alpha, t, param)
{  
    checkScalar(alpha, "numeric", c(0, Inf), c(FALSE, FALSE))
    checkVector(t, "numeric", c(0, Inf), c(TRUE, FALSE))
    t[t>1] <- 1
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
    
    checkScalar(alpha, "numeric", c(0, Inf), c(FALSE, FALSE))
    checkVector(t, "numeric", c(0, Inf), c(TRUE, FALSE))
    t[t>1] <- 1
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
"sfLinear" <- function(alpha, t, param)
{  
    x <- list(name="Piecewise linear", param=param, parname="line points", sf=sfLinear, spend=NULL, 
            bound=NULL, prob=NULL)
    
    class(x) <- "spendfn"
    checkScalar(alpha, "numeric", c(0, Inf), c(FALSE, FALSE))
    checkVector(t, "numeric", c(0, Inf), c(TRUE, FALSE))
    t[t>1] <- 1
    
    if (!is.numeric(param))
    { 
        stop("sfLinear parameter param must be numeric")
    }    

    j <- length(param)
    if (floor(j / 2) * 2 != j)
    {
       stop("sfLinear parameter param must have even length")
    }
    k <- j/2

    if (max(param) > 1 || min(param) < 0)
    {
       stop("Timepoints and cumulative proportion of spending must be >= 0 and <= 1 in sfLinear")
    }
    if (k > 1)
    {   inctime <- x$param[1:k] - c(0, x$param[1:(k-1)])
        incspend <- x$param[(k+1):j]-c(0, x$param[(k+1):(j-1)])
        if ((j > 2) && (min(inctime) <= 0))
        {
           stop("Timepoints must be strictly increasing in sfLinear")
        }
        if ((j > 2) && (min(incspend) < 0))
        {
           stop("Spending must be non-decreasing in sfLinear")
        }

    }
    s <- t
    s[t<=0]<-0
    s[t>=1]<-1
    ind <- (0 < t) & (t <= param[1])
    s[ind] <- param[k + 1] * t[ind] / param[1]
    ind <- (1 > t) & (t >= param[k])
    s[ind] <- param[j] + (t[ind] - param[k]) / (1 - param[k]) * (1  - param[j])
    if (k > 1)
    {   for (i in 2:k)        
        {   ind <- (param[i - 1] < t) & (t <= param[i])
            s[ind] <- param[k + i - 1] + (t[ind] - param[i - 1]) /
                    (param[i] - param[i-1]) *
                    (param[k + i] - param[k + i - 1])
        }
    }    
    x$spend <- alpha * s
    x
}

"sfStep" <- function(alpha, t, param)
{  
  x <- list(name="Step ", param=param, parname="line points", sf=sfStep, spend=NULL, 
            bound=NULL, prob=NULL)
  
  class(x) <- "spendfn"
  checkScalar(alpha, "numeric", c(0, Inf), c(FALSE, FALSE))
  checkVector(t, "numeric", c(0, Inf), c(TRUE, FALSE))
  t[t>1] <- 1
  
  if (!is.numeric(param))
  { 
    stop("sfStep parameter param must be numeric")
  }    
  
  j <- length(param)
  if (floor(j / 2) * 2 != j)
  {
    stop("sfStep parameter param must have even length")
  }
  k <- j/2
  
  if (max(param) > 1 || min(param) < 0)
  {
    stop("Timepoints and cumulative proportion of spending must be >= 0 and <= 1 in sfStep")
  }
  if (k > 1)
  {   inctime <- x$param[1:k] - c(0, x$param[1:(k-1)])
      incspend <- x$param[(k+1):j]-c(0, x$param[(k+1):(j-1)])
      if ((j > 2) && (min(inctime) <= 0))
      {
        stop("Timepoints must be strictly increasing in sfStep")
      }
      if ((j > 2) && (min(incspend) < 0))
      {
        stop("Spending must be non-decreasing in sfStep")
      }
      
  }
  s <- t
  s[t<=param[1]|t<0]<-0
  s[t>=1] <- 1
  ind <- (0 < t) & (t <= param[1])
  s[ind] <- param[k + 1]
  ind <- (1 > t) & (t >= param[k])
  s[ind] <- param[j]
  if (k > 1)
  {   for (i in 2:k)        
      {   ind <- (param[i - 1] < t) & (t <= param[i])
          s[ind] <- param[k + i - 1] 
      }
  }
  x$spend <- alpha * s
  x
}

"sfPoints" <- function(alpha, t, param)
{  
    x <- list(name="User-specified", param=param, parname="Points", sf=sfPoints, spend=NULL, 
            bound=NULL, prob=NULL)
    
    class(x) <- "spendfn"
    
    checkScalar(alpha, "numeric", c(0, Inf), c(FALSE, FALSE))
    checkVector(t, "numeric", c(0, Inf), c(TRUE, FALSE))
    t[t>1] <- 1

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
    
    if (min(incspend) <  0.)
    { 
        stop("Cumulative user-specified spending levels must be non-decreasing with each analysis")
    }
    
    if (max(x$param) > 1.)
    { 
        stop("Cumulative user-specified spending must be >= 0 and <= 1")
    }
    
    x$spend <- alpha * x$param
    
    x
}

"sfPower" <- function(alpha, t, param)
{
    # K. Wills 12/11/08: restrict param range
    # checkScalar(param, "numeric", c(0, Inf), c(FALSE, TRUE))
    checkScalar(param, "numeric", c(0, 15), c(FALSE, TRUE))
    
    checkScalar(alpha, "numeric", c(0, Inf), c(FALSE, FALSE))
    checkVector(t, "numeric", c(0, Inf), c(TRUE, FALSE))
    t[t>1] <- 1
    
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
    
    checkScalar(alpha, "numeric", c(0, Inf), c(FALSE, FALSE))
    checkVector(t, "numeric", c(0, Inf), c(TRUE, FALSE))
    t[t>1] <- 1
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

"sfTruncated" <- function(alpha, t, param){
   checkScalar(alpha, "numeric", c(0, Inf), c(FALSE, FALSE))
   checkVector(t, "numeric", c(0, Inf), c(TRUE, FALSE))
   if (!is.list(param)) stop("param must be a list. See help(sfTruncated)")
   if (!max(names(param)=="trange")) stop("param must include trange, sf, param. See help(sfTruncated)")
   if (!max(names(param)=="sf")) stop("param must include trange, sf, param. See help(sfTruncated)")
   if (!max(names(param)=="param")) stop("param must include trange, sf, param. See help(sfTruncated)")
   if (!is.vector(param$trange)) stop("param$trange must be a vector of length 2 with 0 <= param$trange[1] <param$trange[2]<=1. See help(sfTruncated)") 
   if (length(param$trange)!=2) stop("param$trange parameter must be a vector of length 2 with 0 <= param$trange[1] <param$trange[2]<=1. See help(sfTruncated)")
   if (param$trange[1]>=1. | param$trange[2]<=param$trange[1] | param$trange[2]<=0)
       stop("param$trange must be a vector of length 2 with 0 <= param$trange[1] < param$trange[2]<=1. See help(sfTruncated)")
   if (class(param$sf) != "function") stop("param$sf must be a spending function") 
   if (!is.numeric(param$param)) stop("param$param must be numeric")
   spend<-as.vector(array(0,length(t)))
   spend[t>=param$trange[2]]<-alpha
   indx <- param$trange[1]<t & t<param$trange[2]
   if(max(indx)){
     s <- param$sf(alpha=alpha,t=(t[indx]-param$trange[1])/(param$trange[2]-param$trange[1]),param$param)
     spend[indx] <- s$spend
   }
   # the following line is awkward, but necessary to get the input spending function name in some cases
   param2 <- param$sf(alpha=alpha,t=.5,param=param$param)
   param$name <- param2$name
   param$parname <- param2$parname
   x<-list(name="Truncated", param=param, parname="range", 
           sf=sfTruncated, spend=spend, bound=NULL, prob=NULL)
   class(x) <- "spendfn"
   x
}

"sfTrimmed" <- function(alpha, t, param){
  checkScalar(alpha, "numeric", c(0, Inf), c(FALSE, FALSE))
  checkVector(t, "numeric", c(0, Inf), c(TRUE, FALSE))
  if (!is.list(param)) stop("param must be a list. See help(sfTrimmed)")
  if (!max(names(param)=="trange")) stop("param must include trange, sf, param. See help(sfTrimmed)")
  if (!max(names(param)=="sf")) stop("param must include trange, sf, param. See help(sfTrimmed)")
  if (!max(names(param)=="param")) stop("param must include trange, sf, param. See help(sfTrimmed)")
  if (!is.vector(param$trange)) stop("param$trange must be a vector of length 2 with 0 <= param$trange[1] <param$trange[2]<=1. See help(sfTrimmed)") 
  if (length(param$trange)!=2) stop("param$trange parameter must be a vector of length 2 with 0 <= param$trange[1] <param$trange[2]<=1. See help(sfTrimmed)")
  if (param$trange[1]>=1. | param$trange[2]<=param$trange[1] | param$trange[2]<=0)
    stop("param$trange must be a vector of length 2 with 0 <= param$trange[1] < param$trange[2]<=1. See help(sfTrimmed)")
  if (class(param$sf) != "function") stop("param$sf must be a spending function") 
  if (!is.numeric(param$param)) stop("param$param must be numeric")
  spend<-as.vector(array(0,length(t)))
  spend[t>=param$trange[2]]<-alpha
  indx <- param$trange[1]<t & t<param$trange[2]
  if (max(indx)){
    s <- param$sf(alpha=alpha,t=t[indx],param$param)
    spend[indx] <- s$spend
  }
  # the following line is awkward, but necessary to get the input spending function name in some cases
  param2 <- param$sf(alpha=alpha,t=.5,param=param$param)
  param$name <- param2$name
  param$parname <- param2$parname
  x<-list(name="Trimmed", param=param, parname="range", 
          sf=sfTrimmed, spend=spend, bound=NULL, prob=NULL)
  class(x) <- "spendfn"
  x
}

"sfGapped" <- function(alpha, t, param){
  checkScalar(alpha, "numeric", c(0, Inf), c(FALSE, FALSE))
  checkVector(t, "numeric", c(0, Inf), c(TRUE, FALSE))
  if (!is.list(param)) stop("param must be a list. See help(sfTrimmed)")
  if (!max(names(param)=="trange")) stop("param must include trange, sf, param. See help(sfGapped)")
  if (!max(names(param)=="sf")) stop("param must include trange, sf, param. See help(sfGapped)")
  if (!max(names(param)=="param")) stop("param must include trange, sf, param. See help(sfGapped)")
  if (!is.vector(param$trange)) stop("param$trange must be a vector of length 2 with 0 < param$trange[1] < param$trange[2]<=1. See help(sfGapped)") 
  if (length(param$trange)!=2) stop("param$trange parameter must be a vector of length 2 with 0 < param$trange[1] <param$trange[2]<=1. See help(sfGapped)")
  if (param$trange[1]>=1. | param$trange[2]<=param$trange[1] | param$trange[2]<=0 |param$trange[1]<=0)
    stop("param$trange must be a vector of length 2 with 0 < param$trange[1] < param$trange[2]<=1. See help(sfTrimmed)")
  if (class(param$sf) != "function") stop("param$sf must be a spending function") 
  if (!is.numeric(param$param)) stop("param$param must be numeric")
  spend<-as.vector(array(0,length(t)))
  spend[t>=param$trange[2]]<-alpha
  indx <- param$trange[1]>t
  if (max(indx)){
    s <- param$sf(alpha=alpha,t=t[indx],param$param)
    spend[indx] <- s$spend
  }
  indx <- (param$trange[1]<=t & param$trange[2]>t)
  if (max(indx)){
     spend[indx] <- param$sf(alpha=alpha,t=param$trange[1],param$param)$spend
  }
  # the following line is awkward, but necessary to get the input spending function name in some cases
  param2 <- param$sf(alpha=alpha,t=.5,param=param$param)
  param$name <- param2$name
  param$parname <- param2$parname
  x<-list(name="Gapped", param=param, parname="range", 
          sf=sfGapped, spend=spend, bound=NULL, prob=NULL)
  class(x) <- "spendfn"
  x
}


"spendingFunction" <- function(alpha, t, param)
{      
    checkScalar(alpha, "numeric", c(0, Inf), c(FALSE, FALSE))
    checkVector(t, "numeric", c(0, Inf), c(TRUE, FALSE))
    t[t>1] <- 1
    
    x <- list(name="Linear", param=param, parname="none", sf=spendingFunction, spend=alpha * t, 
            bound=NULL, prob=NULL)
    
    class(x) <- "spendfn"
    
    x
}

###
# Hidden Functions
###

"diffbetadist" <- function(aval, xval, uval)
{   
    if (min(aval) <= 0.)
    {
        return(1000)
    }
    
    diff <- uval - pbeta(xval, aval[1], aval[2])
    
    sum(diff ^ 2)
}

"Tdistdiff" <- function(x, t0, p0)
{  
    xv <- qt(t0, x)
    y <- qt(p0, x)
    b <- (y[2] - y[1]) / (xv[2] - xv[1])
    a <- y[2] - b * xv[2]
   
    a + b * xv[3] - y[3]
}



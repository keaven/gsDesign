
# This script contains independently programmed functions for validating some of 
# the functions of the gsDesign package.
#-------------------------------------------------------------------------------
# gsPP : averages conditional power across a posterior distribution to compute
#       predictive power.
#-------------------------------------------------------------------------------
# validation code Author : Apurva Bhingare
# x:     design object size.
# i:     look position
# zi:    interim test statistic at ith look
# theta: a vector with theta value(s) at which conditional power is to be computed
# wgts:  Weights to be used with grid points in theta.
# r:     Integer value controlling grid for numerical integration
# total: The default of total=TRUE produces the combined probability for all
#        planned analyses after the interim analysis specified in i
#-------------------------------------------------------------------------------

validate_gsPP <- function(x, i, zi, theta, wgts, r, total = total) {
  k0 <- x$k - i
  I0 <- x$n.I[(i + 1):x$k] - x$n.I[i]

  if (x$test.type == 1) {
    a0 <- rep(-3, k0)
  } else {
    a0 <- (x$lower$bound[(i + 1):x$k] - zi * sqrt(x$n.I[i] / x$n.I[(i + 1):x$k])) / 
          sqrt(I0 / x$n.I[(i + 1):x$k])
  }

  b0 <- (x$upper$bound[(i + 1):x$k] - zi * sqrt(x$n.I[i] / x$n.I[(i + 1):x$k])) /
         sqrt(I0 / x$n.I[(i + 1):x$k])

  cp <- gsProbability(k = k0, theta = theta, n.I = I0, a = a0, b = b0,
                      r = r, overrun = 0)

  gsDen <- dnorm(zi, mean = sqrt(x$n.I[i]) * theta) * wgts

  pp <- cp$upper$prob %*% gsDen / sum(gsDen)

  if (total == TRUE) {
    total.pp <- sum(pp)
    return(total.pp)
  }
  else {
    total.pp <- pp
    return(total.pp)
  }
}
#-------------------------------------------------------------------------------
## gsZ: its computes density for interim test statistic value.
#-------------------------------------------------------------------------------
# x:     design object.size.
# theta: a vector with theta value(s) at which conditional power is to be computed
# i:     look position.
# zi:    interim test statistic at ith look
#-------------------------------------------------------------------------------
validate_gsZ <- function(x, theta, i, zi) {
  nIi <- x$n.I[i]
  mu <- theta * sqrt(nIi)
  fz <- matrix(0, nrow = length(zi), ncol = length(mu))

  for (nc in 1:length(mu)) {
    for (nr in 1:length(zi)) {
      fz[nr, nc] <- dnorm(zi[nr], mu[nc])
    }
  }
  return(fz)
}
#-------------------------------------------------------------------------------
# gsPI: computes Bayesian prediction intervals for future analyses corresponding
#      to results produced by gsPP()
#-------------------------------------------------------------------------------
# x: design object size.
# i: look position
# j: specific analysis for which prediction is being made; must be >i and no more than x$k
# zi: interim test statistic at ith look
#-------------------------------------------------------------------------------
validate_gsPI <- function(x, i, j, k, zi, alpha, mu, sigma1sq) {
  n <- x$n.I
  ti <- x$timing
  postmean <- (mu / sigma1sq + zi[i] * sqrt(n[i])) / (1 / sigma1sq + n[i])
  postvar <- 1 / (1 / sigma1sq + n[i])

  b <- zi[i] * sqrt(ti[i])
  pimean <- b + postmean * (ti[j] - ti[i]) * sqrt(x$n.I[k])
  pivar <- (postvar * (x$n.I[j] - x$n.I[i]) + 1) * (ti[j] - ti[i])
  bpi <- pimean + qnorm(c(alpha / 2, 1 - (alpha / 2))) * sqrt(pivar)
  zpi <- bpi / sqrt(ti[j])
  return(zpi) 
}

#-------------------------------------------------------------------------------
# gsBoundCP: (function description)
#-------------------------------------------------------------------------------
# x: design object size.
#-------------------------------------------------------------------------------
validate_gsBoundCP <- function(x) {
  i0 <- x$k - 1
  theta <- x$delta
  thetahat_hi <- thetahat_hi <- rep(0, i0)
  CP_lo <- CP_hi <- rep(0, i0)

  if (x$test.type == 1) {
    thetahat_hi <- thetahat_low <- if (theta != "thetahat") {
      rep(theta, i0)
    } else {
      x$upper$bound[1:i0] / sqrt(x$n.I[1:i0])
    }
  } else {
    thetahat_hi <- if (theta != "thetahat") {
      rep(theta, i0)
    } else {
      x$upper$bound[1:i0] / sqrt(x$n.I[1:i0])
    }

    thetahat_low <- if (theta != "thetahat") {
      rep(theta, i0)
    } else {
      x$lower$bound[1:i0] / sqrt(x$n.I[1:i0])
    }
  }

  for (i in 1:i0) {
    if (x$test.type > 1) {
      xhi <- gsCP(x, thetahat_hi[i], i, x$upper$bound[i])
      CP_hi[i] <- sum(xhi$upper$prob)

      xlo <- gsCP(x, thetahat_low[i], i, x$lower$bound[i])
      CP_lo[i] <- sum(xhi$lower$prob)

      Bounds <- data.frame(CP_lo, CP_hi)
    } else {
      xhi <- gsCP(x, thetahat_hi[i], i, x$upper$bound[i])
      CP_hi[i] <- sum(xhi$upper$prob)
      Bounds <- CP_hi
    }
  }
  return(Bounds)
}

#-------------------------------------------------------------------------------
# gsCPOS:  gsCPOS() assumes no boundary has been crossed before and including an
#        interim analysis of interest, and computes the probability of success based on this event
#-------------------------------------------------------------------------------
# x:     design object size.
# theta: a vector with theta value(s) at which conditional power is to be computed
# wgts:  Weights to be used with grid points in theta
# i0:    look position
#-------------------------------------------------------------------------------

validate_gsCPOS <- function(x, theta, wgts, i0 = i) {
  one <- rep(0, x$k)
  one[1:i0] <- rep(1, i0)
  zero <- 1 - one

  y <- gsProbability(theta = theta, d = x)

  pAi <- 1 - one %*% (y$upper$prob + y$lower$prob) %*% wgts
  pABi <- zero %*% (y$upper$prob) %*% wgts

  CPOS <- pABi / pAi
  return(CPOS)
}

#-------------------------------------------------------------------------------
# gsPosterior: gsPosterior() computes the posterior density for the group sequential
#             design parameter of interest given a prior density and an interim
#             outcome that is exact or in an interval
#-------------------------------------------------------------------------------
# x:     design object size.
# theta: a vector with theta value(s) at which conditional power is to be computed;
# i:    look position
# zi:   interim test statistic at ith look
#-------------------------------------------------------------------------------

validate_gsPosterior <- function(x, theta, density, gridwgts, wgts, i, zi) {
  if (!is.null(gridwgts)) {
    nIi <- x$n.I[i]
    mu <- theta * sqrt(nIi)
    fz <- matrix(0, nrow = length(zi), ncol = length(mu))


    for (nc in 1:length(mu)) {
      for (nr in 1:length(zi)) {
        fz[nr, nc] <- dnorm(zi[nr], mu[nc])
      }
    }

    p <- (fz * density)
    marg <- sum(fz * density * gridwgts)
    posterior <- p / marg
  } else {
    gridwgts <- rep(1, length(theta))
    nIi <- x$n.I[i] ## ss at the ith look
    mu <- theta * sqrt(nIi) ## theta is standardized delta
    fz <- matrix(0, nrow = length(zi), ncol = length(mu))


    for (nc in 1:length(mu)) {
      for (nr in 1:length(zi)) {
        fz[nr, nc] <- dnorm(zi[nr], mu[nc])
      }
    }

    p <- (fz * density * gridwgts)
    marg <- sum(fz * density * gridwgts)
    posterior <- p / marg
  }

  return(posterior)
}
#-------------------------------------------------------------------------------
# sfPoints: The function sfPoints implements a spending function with values
#           specified for an arbitrary set of specified points.
#-------------------------------------------------------------------------------
# Independent code Author : Apurva Bhingare
# alpha: Type I error (or Type II error) specification takes values between 0 and 1.
# t :    A vector of time points (information fraction) with increasing
#        values from >0 and <=1.
# param: A real vector of the same length as t specifying the cumulative proportion (between 0 and 1)
#        of spending to corresponding to each point in t
#-------------------------------------------------------------------------------
validate_sfPoints <- function(alpha, t, param) {
  t[t > 1] <- 1
  k <- length(t)
  j <- length(param)

  if (j == k - 1) {
    param <- c(param, 1)
    j <- k
  }

  spend <- alpha * param
  return(spend)
}

#-------------------------------------------------------------------------------
#### sfLinear : The function sfLinear() allows specification of a piecewise
#               linear spending function.
#-------------------------------------------------------------------------------
# Independent code Author : Apurva Bhingare
# alpha: Type I error (or Type II error) specification takes values between 0 and 1.
# t :    A vector of points with increasing values from 0 to 1, inclusive.
# param: A vector with a positive, even length. Values must range from 0 to 1, inclusive.
#-------------------------------------------------------------------------------
validate_sfLinear <- function(alpha, t, param) {
  j <- length(param)
  k <- j / 2

  s <- t
  s[t <= 0] <- 0
  s[t >= 1] <- 1

  index <- (0 < t) & (t <= param[1])
  s[index] <- param[k + 1] * t[index] / param[1]

  index <- (1 > t) & (t >= param[k])
  s[index] <- param[j] + (t[index] - param[k]) / (1 - param[k]) * (1 - param[j])


  if (k > 1) {
    for (i in 2:k)
    {
      index <- (param[i - 1] < t) & (t <= param[i])
      s[index] <- param[k + i - 1] + (t[index] - param[i - 1]) /
        (param[i] - param[i - 1]) *
        (param[k + i] - param[k + i - 1])
    }
  }
  spend <- alpha * s
  return(spend)
}

#-------------------------------------------------------------------------------
#### sfStep : The function sfStep() specifies a step function spending function
#-------------------------------------------------------------------------------
# Independent code Author : Apurva Bhingare (modified by K Anderson, 5/26/2022)
# alpha: Type I error (or Type II error) specification takes values between 0 and 1.
# t :    A vector of time points (information fraction) with increasing
#        values from >0 and <=1.
# param: A vector with a positive, even length. Values must range from 0 to 1, inclusive.
#-------------------------------------------------------------------------------
validate_sfStep <- function(alpha, t, param) {
  j <- length(param)

  k <- j / 2

  s <- t

  s[t < param[1]] <- 0
  s[t >= param[k]] <- param[j]
  
  if (k > 1){
    for (i in 1:(k-1)) s[(param[i] <= t) & (t < param[i + 1])] <- param[k + i]
  }
  s[t >= 1] <- 1
  
  spend <- alpha * s
  return(spend)
}

#--------------------------------------------------------------------------------
## sfTDist : The function sfTDist() provides perhaps the maximum flexibility
#           among spending functions provided in the gsDesign package.
#-------------------------------------------------------------------------------
# Independent code Author : Apurva Bhingare
# alpha: Type I error (or Type II error) specification takes values between 0 and 1.
# t :    A vector of time points (information fraction) with increasing
#        values from >0 and <=1.
# param: A parameter vector of length 3 (5) for specifying t-ditribution, where third (fifth)
#        parameter gives the df
#-------------------------------------------------------------------------------
# Test sfTDist for param of length 3.
validate_sfTDist <- function(alpha, t, param) {
  if (length(param) == 3) {
    t[t > 1] <- 1

    a <- param[1]
    b <- param[2]
    df <- param[3]

    x <- qt(t, df)
    y <- pt(a + b * x, df)
    spend <- alpha * y
  } else {
    if (length(param) == 5) {
      t[t > 1] <- 1
      t0 <- param[1:2]
      p0 <- param[3:4]
      df <- param[5]

      x <- qt(t0, df)
      y <- qt(p0, df)
      b <- (y[2] - y[1]) / (x[2] - x[1])
      a <- y[2] - b * x[2]

      x <- qt(t, df)
      y <- pt(a + b * x, df)
      spend <- alpha * y
    }
    else {
      stop("Check parameter specification")
    }
  }

  return(spend)
}

#-------------------------------------------------------------------------------
## sfTruncated : The functions sfTruncated() and sfTrimmed apply any other
#               spending function over a restricted range. This allows eliminating spending for
#               early interim analyses when you desire not to stop for the bound being specified;
#-------------------------------------------------------------------------------
# Independent code Author : Apurva Bhingare
# alpha: Type I error (or Type II error) specification takes values between 0 and 1.
# tx :    A vector of time points (information fraction) with increasing
#        values from >0 and <=1.
# param: a list containing the elements sf (a spendfn object such as sfHSD),
#-------------------------------------------------------------------------------
validate_sfTruncated <- function(alpha, tx, param.list) {
  trange <- param.list$trange
  param <- param.list$param
  sf <- param.list$sf

  spend <- as.vector(rep(0, length(tx)))
  spend[tx >= trange[2]] <- alpha
  indx <- trange[1] < tx & tx < trange[2]
  ttmp <- (tx[indx] - trange[1]) / (trange[2] - trange[1])

  if (max(indx)) {
    stmp1 <- sf(alpha = alpha, t = ttmp, param)
    spend[indx] <- stmp1$spend
  }

  spend.truncated <- spend
  return(spend.truncated)
}

#-------------------------------------------------------------------------------
# sfTrimmed : sfTrimmed simply computes the value of the input spending function
#            and parameters in the sub-range of [0,1]
#-------------------------------------------------------------------------------
# Independent code Author : Apurva Bhingare
# alpha: Type I error (or Type II error) specification takes values between 0 and 1.
# tx :   A vector of time points (information fraction) with increasing
#        values from >0 and <=1.
# param: a list containing the elements sf (a spendfn object such as sfHSD),
#-------------------------------------------------------------------------------
validate_sfTrimmed <- function(alpha, tx, param.list) {
  trange <- param.list$trange
  param <- param.list$param
  sf <- param.list$sf

  spend <- as.vector(rep(0, length(tx)))
  spend[tx >= trange[2]] <- alpha
  indx <- trange[1] < tx & tx < trange[2]

  if (max(indx)) {
    stmp2 <- sf(alpha = alpha, t = tx[indx], param)
    spend[indx] <- stmp2$spend
  }

  spend.trimmed <- spend
  return(spend.trimmed)
}

#-------------------------------------------------------------------------------
## sfGapped : sfGapped() allows elimination of analyses after some time point in the trial
#-------------------------------------------------------------------------------
# Independent code Author : Apurva Bhingare
# alpha: Type I error (or Type II error) specification takes values between 0 and 1.
# tx :   A vector of time points (information fraction) with increasing
#        values from >0 and <=1.
# param: a list containing the elements sf (a spendfn object such as sfHSD),
#-------------------------------------------------------------------------------
validate_sfGapped <- function(alpha, tx, param.list) {
  trange <- param.list$trange
  param <- param.list$param
  sf <- param.list$sf

  spend <- as.vector(rep(0, length(tx)))
  spend[tx >= trange[2]] <- alpha

  indx <- trange[1] > tx

  if (max(indx)) {
    s <- sf(alpha = alpha, t = tx[indx], param)
    spend[indx] <- s$spend
  }
  indx <- (trange[1] <= tx & trange[2] > tx)
  if (max(indx)) {
    spend[indx] <- sf(alpha = alpha, t = trange[1], param)$spend
  }
  spend.gapped <- spend
  return(spend.gapped)
}

#-------------------------------------------------------------------------------
## spendingFunction: spendingFunction functions in general produce an object of type spendfn.
#-------------------------------------------------------------------------------
# alpha: Type I error (or Type II error) specification takes values between 0 and 1.
# tx :   A vector of time points (information fraction) with increasing
#        values from >0 and <=1.
# param: A single real value or a vector of real values specifying the spending function parameter(s).
#-------------------------------------------------------------------------------
validate_spendingFunction <- function(alpha, tx, param) {
  spend <- alpha * tx
  return(spend)
}

#-------------------------------------------------------------------------------
############
#sfLogistic
############
# Independent code Author : Apurva Bhingare
# alpha: Type I error (or Type II error) specification takes values between 0 and 1.
# t :    A vector of time points (information fraction) with increasing
#        values from >0 and <=1.
# param: A vector with a positive, even length. Values must range from 0 to 1, inclusive.
#-------------------------------------------------------------------------------
validate_sfLogistic <- function(alpha, t, param)
{
  if (length(param) == 2 )
  {
    a<-param[1]
    b<-param[2]
    
    xv<-qlogis(t)
    sp<-alpha*plogis(a+b*xv)
    
  }
  else
  { 
    if (length(param) == 4){
      t0<-param[1:2]
      p0<-param[3:4]
      
      xv<-qlogis(t0)
      y<-qlogis(p0)
      
      b<-(y[2]-y[1])/(xv[2]-xv[1])
      a<-y[2]-b*xv[2]
      
      xv<-qlogis(t)
      sp<-alpha*plogis(a+b*xv)
    }
    else
    {
      stop("Check parameter specification")
    }
  }
  return(sp)
}

#-------------------------------------------------------------------------------
###########
#sfCauchy
###########
# Independent code Author : Apurva Bhingare
# alpha: Type I error (or Type II error) specification takes values between 0 and 1.
# t :    A vector of time points (information fraction) with increasing
#        values from >0 and <=1.
# param: A vector with a positive, even length. Values must range from 0 to 1, inclusive.
#-------------------------------------------------------------------------------
validate_sfCauchy <- function(alpha, t, param) {
  if (length(param) == 2) {
    a <- param[1]
    b <- param[2]
    
    xv <- qcauchy(t)
    sp <- alpha * pcauchy(a + b * xv)
  }
  else {
    if (length(param) == 4) {
      t0 <- param[1:2]
      p0 <- param[3:4]
      
      xv <- qcauchy(t0)
      y <- qcauchy(p0)
      
      b <- (y[2] - y[1]) / (xv[2] - xv[1])
      a <- y[2] - b * xv[2]
      
      xv <- qcauchy(t)
      sp <- alpha * pcauchy(a + b * xv)
    }
    else {
      stop("Check parameter specification")
    }
  }
  return(sp)
}

#-------------------------------------------------------------------------------
###############
#sfExtremeValue
###############
# Independent code Author : Apurva Bhingare
# alpha: Type I error (or Type II error) specification takes values between 0 and 1.
# t :    A vector of time points (information fraction) with increasing
#        values from >0 and <=1.
# param: A vector with a positive, even length. Values must range from 0 to 1, inclusive.
#-------------------------------------------------------------------------------
validate_sfExtremeValue <- function(alpha, t, param)
{
  if(length(param) == 2){
    a<-param[1]
    b<-param[2]
    
    x<- -log(-log(t))
    sp<-alpha*exp(-exp(-(a+b*x)))
  }
  else {
    if(length(param) == 4){
      
      t0<-param[1:2]
      p0<-param[3:4]
      
      x<- -log(-log(t0))
      y<- -log(-log(p0))
      
      b<-(y[2]-y[1])/(x[2]-x[1])
      a<-y[2]-b*x[2]
      
      x<- -log(-log(t))
      sp<-alpha*exp(-exp(-(a+b*x)))
    }
    else{
      stop("Check parameter specification")
    }
  }
  return(sp)
}

#-------------------------------------------------------------------------------
#################
#sfExtremeValue2
#################
# Independent code Author : Apurva Bhingare
# alpha: Type I error (or Type II error) specification takes values between 0 and 1.
# t :    A vector of time points (information fraction) with increasing
#        values from >0 and <=1.
# param: A vector with a positive, even length. Values must range from 0 to 1, inclusive.
#-------------------------------------------------------------------------------
validate_sfExtremeValue2 <- function(alpha, t, param)
{
  if(length(param) == 2){
    a<-param[1]
    b<-param[2]
    
    xv<- log(-log(1-t))
    sp<-alpha*(1-exp(-exp((a+b*xv))))
  }
  else {
    if(length(param) == 4){
      t0<-param[1:2]
      p0<-param[3:4]
      
      xv<- log(-log(1-t0))
      y<- log(-log(1-p0))
      
      b<-(y[2]-y[1])/(xv[2]-xv[1])
      a<-y[2]-b*xv[2]
      
      xv<- log(-log(1-t))
      sp<-alpha*(1-exp(-exp((a+b*xv))))
    }
    else{
      stop("Check parameter specification")
    }
  }
  return(sp)
}

#-------------------------------------------------------------------------------
###########
#sfBetaDist
###########
# Independent code Author : Apurva Bhingare
# alpha: Type I error (or Type II error) specification takes values between 0 and 1.
# t :    A vector of time points (information fraction) with increasing
#        values from >0 and <=1.
# param: A vector with a positive, even length. Values must range from 0 to 1, inclusive.
#-------------------------------------------------------------------------------
validate_sfBetaDist <- function(alpha, t, param){
  t[t > 1] <- 1
  sp <- alpha * stats::pbeta(t, param[1], param[2])
  return(sp)
}

#-------------------------------------------------------------------------------
#################
#sfNormal
#################
# Independent code Author : Apurva Bhingare
# alpha: Type I error (or Type II error) specification takes values between 0 and 1.
# t :    A vector of time points (information fraction) with increasing
#        values from >0 and <=1.
# param: A vector with a positive, even length. Values must range from 0 to 1, inclusive.
#-------------------------------------------------------------------------------
validate_sfNormal <- function(alpha, t, param)
{
  if(length(param) == 2){
    a<-param[1]
    b<-param[2]
    
    xv <- qnorm(1 * (!is.element(t, 1)) * t)
    y <- pnorm(a + b * xv)
    sp <- alpha * (1 * (!is.element(t, 1)) * y + 1 * is.element(t, 1))
  }
  else {
    if(length(param) == 4){
      t0<-param[1:2]
      p0<-param[3:4]
      
      xv<-qnorm(t0)
      y<-qnorm(p0)
      
      b<-(y[2]-y[1])/(xv[2]-xv[1])
      a<-y[2]-b*xv[2]
      
      xv <- qnorm(1 * (!is.element(t, 1)) * t)
      y <- pnorm(a + b * xv)
      sp <- alpha * (1 * (!is.element(t, 1)) * y + 1 * is.element(t, 1))
    }
    else{
      stop("Check parameter specification")
    }
  }
  return(sp)
}

#-------------------------------------------------------------------------------
#varBinomial
#-----------
# ratio: sample size ratio for group 2 divided by group 1
# x: Number of "successes" in the combined control and experimental groups
# n: Number of observations in the combined control and experimental groups
# delta:
# (1) scale="RR", delta0 is the logarithm of the relative risk of event rates (p10 / p20) 
# (2) scale="OR", delta0 is the difference in natural logarithm of the odds-ratio 



validate_varBinom_rr<-function(x, n, delta , ratio, scale = "rr"){
  
  a <- ratio+1
  RR <- exp(delta)
  p <- x/n
  
  if(delta==0){
    
    v <- (((1 - p) / p) * a^2/(a-1))/n
    
  }else{
    
    p1 <- p * a / (ratio * RR + 1)
    p2 <- RR * p1
    
    
    t1 <- a * RR
    t2 <- -(RR * ratio + p2 * ratio + 1 + p1 * RR)
    t3  <- ratio * p2 + p1
    
    p10 <- ((-t2 - sqrt(t2^2 - 4 * t1 * t3)) / 2)/t1
    p20 <- RR * p10
    
    v <- (a * ((1 - p10) / p10 + (1 - p20) / ratio / p20))/n
    
  }
  return(v)
  
}

validate_varBinom_or<-function(x, n, delta , ratio, scale = "OR"){
  
  v <- rep(0, max(length(delta), length(x), length(ratio), length(n)))
  
  p <- x/n
  OR <- exp(delta)
  
  a <- (ratio + 1)
  b<- OR - 1
  c <- -p * a
  d <- 1 + (a-1) * (b+1) + (b) * c
  
  p10 <- (-d + sqrt(d^2 - 4 * b * c)) / 2 / b
  p20 <- (b+1) * p10 / (1 + p10 * b)
  
  v <- (a* (1 / p10 / (1 - p10) + 1 / p20 / (1 - p20) / (a-1)))/n
  v[delta == 0] <- (1 / p / (1 - p) * (1 + 1 / (a-1)) * a)/n
  
  return(v)
}


validate_varBinom_Diff<-function(x, n, delta , ratio){
  
  a <- ratio+1
  p <- x/n
  
  if(delta==0){
    
    x0 <- n*p/a
    x1 <- x0*(a-1)
    
    n0 <- n/(1+ratio)
    n1 <- n-n0
    
    R1<-x1/n1
    R0<-x0/n0
    
    v <- (R1*(1-R1)/n1 + R0*(1-R0)/n0)
  }
  
  return(v)
}
#-------------------------------------------------------------------------------
##eEvents
#--------
## These independently coded functions have been implemented from the
## Lachin and Foulkes (1986) paper


## compute expected value of status (event/censor)
expect_status <- function(lambda, drprate, maxstudy, accdur) {
  rtsum <- lambda + drprate
  t1 <- lambda / rtsum
  t2n <- exp(-rtsum * (maxstudy - accdur)) - exp(-rtsum * maxstudy)
  t2d <- rtsum * accdur
  t2 <- 1 - (t2n / t2d)
  op <- t1 * t2
  return(op)
}

## compute # of events per arm
## Inputs: lambda - the hazard rate on a single arm
##         drprate - dropout rate
##         maxstudy - max. study duration
##         accdur - accrual duration (in the same units as maxstudy)
##         totalSS - total sample size
##         rndprop - randomisation proportion
##
## Output: events - the expected number of events
expect_ev_arm <- function(lambda, drprate, maxstudy, accdur,
                          totalSS, rndprop) {
  expst <- expect_status(lambda, drprate, maxstudy, accdur)
  events <- totalSS * rndprop * expst
  return(events)
}
#------------------------------------------------------------------------
#gsNormalGrid
#-------------
#' Grid points for group sequential design numerical integration
#'
#' Points and weights for Simpson's rule numerical integration from
#' p 349 - 350 of Jennison and Turnbull book.
#' This is not used for arbitrary integration, but for the canonical form of Jennison and Turnbull.
#' mu is computed elsewhere as drift parameter times sqrt of information.
#' Since this is a lower-level routine, no checking of input is done; calling routines should
#' ensure that input is correct.
#' Lower limit of integration can be \code{-Inf} and upper limit of integration can be \code{Inf}
#'
#' @details
#' Jennison and Turnbull (p 350) claim accuracy of \code{10E-6} with \code{r=16}.
#' The numerical integration grid spreads out at the tail to enable accurate tail probability calcuations.
#'
#'
#' @param r Integer, at least 2; default of 18 recommended by Jennison and Turnbull
#' @param mu Mean of normal distribution (scalar) under consideration
#' @param a lower limit of integration (scalar)
#' @param b upper limit of integration (scalar \code{> a})
#'
#' @return A \code{tibble} with grid points in \code{z} and numerical integration weights in \code{w}
#' @export
#'
#' @examples
#' library(dplyr)
#' # approximate variance of standard normal (i.e., 1)
#' gridpts() %>% summarize(var = sum(z^2 * w * dnorm(z)))
#'
#' # approximate probability above .95 quantile (i.e., .05)
#' gridpts(a = qnorm(.95), b = Inf) %>% summarize(p05 = sum(w * dnorm(z)))
gridpts <- function(r = 18, mu = 0, a = -Inf, b = Inf){
  # Define odd numbered grid points for real line
  x <- c(mu - 3 - 4 * log(r / (1:(r - 1))),
         mu - 3 + 3 * (0:(4 * r)) / 2 / r,
         mu + 3 + 4 * log(r / (r - 1):1)
  )
  # Trim points outside of [a, b] and include those points
  if (min(x) < a) x <- c(a, x[x > a])
  if (max(x) > b) x <- c(x[x < b], b)
  
  # Define even numbered grid points between the odd ones
  m <- length(x)
  y <- (x[2:m] + x[1:(m-1)]) / 2
  
  # Compute weights for odd numbered grid points
  i <- 2:(m-1)
  wodd <- c(x[2] - x[1],
            (x[i + 1] - x[i - 1]),
            x[m] - x[m - 1]) / 6
  
  weven <- 4 * (x[2:m] - x[1:(m-1)]) / 6
  
  # Now combine odd- and even-numbered grid points with their
  # corresponding weights
  z <- rep(0, 2*m - 1)
  z[2 * (1:m) - 1] <- x
  z[2 * (1:(m-1))] <- y
  w <- z
  w[2 * (1:m) - 1] <- wodd
  w[2 * (1:(m-1))] <- weven
  
  return(tibble::tibble(z=z, w=w))
}
#-------------------------------------------------------------------------------

## This script contains independently programmed functions for validating some of the functions of the gsDesign package.

#########################################################################################
# This Function validates z2Z.
# Independent Code Author: Apurva
# Independent Code Date: 11/11/2020
#########################################################################################

## x - Base case Design
## z10 - Stage 1 statistics
## n20 - stage incremental sample size

validate_z2z <- function(x, z10, n20) {
  n10 <- (x$n.I[1])
  w1 <- sqrt(n10 / (n10 + n20))
  w2 <- sqrt(n20 / (n10 + n20))
  z20 <- x$upper$bound[2]
  z2incr <- (z20 - w1 * z10) / w2
  return(z2incr)
}





#########################################################################################
# This function validates z2NC.
# Independent Code Author: Apurva
# Independent Code Date: 11/11/2020
#########################################################################################

## x - Base case Design
## z10 - Stage 1 statistics
## info.frac - information fraction


validate_z2NC <- function(x, z10, info.frac) {
  z20 <- x$upper$bound[2]
  z2incr <- (z20 - sqrt(info.frac[1]) * z10) / sqrt(1 - info.frac[1])
  return(z2incr)
}




#########################################################################################
# This function validates z2Fisher.
# Independent Code Author:Apurva
# Independent Code Date:11/11/2020
#########################################################################################
#########################################################################################
## Using the relation
## P(-2 log (p1p(2)) >= ChiSq_a4)=alpha
## where,
## p1= p.value at stage 1
## p(2)= incremental p.value at stage 2
## ChiSq_a4= Upper alpha quantile of chi-square distribution with df=4
#########################################################################################
## x - Base case Design
## z1 - Stage 1 statistics

validate_z2Fisher <- function(x, z1) {
  alpha <- 1 - pnorm(x$upper$bound[2])
  qalpha <- qchisq(alpha, df = 4, lower.tail = FALSE)
  y <- exp(-0.5 * qalpha - log(pnorm(-z1)))
  zzfsr <- qnorm(y, lower.tail = FALSE)
  return(zzfsr)
}




#########################################################################################
# This Function validates comp_bdry
# Reference: Sequential Analysis, Abraham Wald, 1947
# Independent Code Author: Imran
# Independent Code Date: 11/11/2020
#########################################################################################
## alpha - type 1 error
## beta - type 2 error
## p0 - proportion under null hypothesis
## p1 - proportion under alternate hypothesis
## n- Sample size

validate_comp_bdry <- function(alpha, beta, p0, p1, n) {
  A <- (1 - beta) / alpha
  B <- beta / (1 - alpha)

  tmpratio <- (1 - p1) / (1 - p0)
  bndry_den <- log((p1 / p0) * (1 / tmpratio))
  LB <- (log(B) - (n * log(tmpratio))) / bndry_den
  UB <- (log(A) - (n * log(tmpratio))) / bndry_den
  boundaries <- list("LB" = LB, "UB" = UB)

  return(boundaries)
}


#########################################################################################
## Reference: Sequential Analysis, Abraham Wald, 1947
# This Function validates binomialSPRT.
# Independent Code Author: Imran
# Independent Code Date: 11/11/2020
#########################################################################################
## alpha - type 1 error
## beta - type 2 error
## p0 - proportion under null hypothesis
## p1 - proportion under alternate hypothesis
## nmin - minimum sample size for doing ratio test
## nmax - maximum sample size for doing ratio test


Validate_comp_sprt_bnd <- function(alpha, beta, p0, p1, nmin, nmax) {
  lbnd <- c()
  ubnd <- c()

  for (i in nmin:nmax)
  {
    x <- validate_comp_bdry(alpha, beta, p0, p1, i)
    lbnd <- c(lbnd, x$LB)
    ubnd <- c(ubnd, x$UB)
  }

  df <- data.frame(
    n = nmin:nmax, lbnd = lbnd, ubnd = ubnd,
    lbrnd = floor(lbnd), ubrnd = ceiling(ubnd)
  )
  slope <- as.numeric(coef(lm(ubnd ~ n, data = df))["n"]) ## the slope for the boundary lines
  lintercept <- as.numeric(coef(lm(lbnd ~ n, data = df))["(Intercept)"]) ## y-intercept of lower boundary
  uintercept <- as.numeric(coef(lm(ubnd ~ n, data = df))["(Intercept)"]) ## y-intercept of upper boundary

  result <- list("bounds" = df, "slope" = slope, "lowint" = lintercept, "upint" = uintercept)
  return(result)
}

#-------------------------------------------------------------------------------
#save_gg_plot() : Function to save plots created with ggplot2 package and saved
#                 with ggsave() function.
#
# plot	: Plot to save, defaults to last plot displayed.
# path	:  Path of the directory to save plot to: path and filename are 
#        combined to create the fully qualified file name.
# width : the width of the device (in inches).
# height: the height of the device (in inches).
# dpi	  : Plot resolution.

# Plot size in units ("in", "cm", or "mm")
#-------------------------------------------------------------------------------
save_gg_plot <- function(code, width = 4, height = 4) {
  path <- tempfile(fileext = ".png")
  ggplot2::ggsave(path, plot = code, width = width, height = height, dpi = 72, units = "in")
  path
}

#-------------------------------------------------------------------------------
# save_gr_plot(): Function to save plots created with graphics package and saved
#                 with png() function.
# width: the width of the device (in pixels).
# height: the height of the device (in pixels).
#-------------------------------------------------------------------------------
save_gr_plot <- function(code, width = 400, height = 400) {
  path <- tempfile(fileext = ".png")
  png(path, width = width, height = height)
  oldpar <- par(no.readonly = TRUE)
  on.exit(par(oldpar))
  code
  invisible(dev.off())
  path
}
#-------------------------------------------------------------------------------
#ssrCP : ssrCP() adapts 2-stage group sequential designs to 2-stage sample size
# re-estimation designs based on interim analysis conditional power.

# x  : design object 
# beta : type 2 error
# delta : to be used for true effect size delta
#-------------------------------------------
validate_ssrCP <- function(x, z1){
  
  beta <- x$beta
  delta <-z1/ sqrt(x$n.I[1])
  
  n1 <- x$n.I[1]
  n2 <- x$n.I[2]
  SE <- delta/z1
  
  
  res1 <- (n1 *SE^2)/ delta^2
  res2 <- (x$upper$bound[2] * sqrt(n2) - z1 * sqrt(n1)) / 
    (sqrt(n2 - n1)) - (qnorm(beta))
  
  final_res <- n1 + (res1 * res2 * res2)
  CP <- condPower(z1 = z1, n2 = n1, z2 = z2NC, theta = NULL, x = x)
  expected_out <- list(final_res, CP)
  return(expected_out)
}
#------------------------------------------------------------------------------
"sfPower" <- function(alpha, t, param)
{  
    x <- list(name="Kim-DeMets (power)", param=param, parname="rho", sf=sfPower, spend=NULL,
            bound=NULL, prob=NULL, errcode=0, errmsg="No error")  
    class(x) <- "spendfn"

	if (length(param) != 1) 
	{
	    return(gsReturnError(x, errcode=.1, errmsg="KD spending function parameter must be a single real value"))
    }
	
    if (!is.numeric(param)) 
	{
	    return(gsReturnError(x, errcode=.11, errmsg="KD spending function parameter not given"))
	}

	if (param <= 0.) 
	{
	    return(gsReturnError(x, errcode=.12, errmsg="KD spending function parameter input <= 0; must be > 0"))
    }

	t[t > 1] <- 1
    x$spend <- alpha * t ^ param

	return(x)
}

"sfHSD" <- function(alpha, t, param)
{  
    x<-list(name="Hwang-Shih-DeCani", param=param, parname="gamma", sf=sfHSD, spend=NULL,
            bound=NULL, prob=NULL, errcode=0, errmsg="No error")  
    class(x) <- "spendfn"

	if (length(param) != 1) 
	{
	    return(gsReturnError(x, errcode=.1, errmsg="HSD spending function parameter must be a single real value"))
	}
	
    if (!is.numeric(param)) 
	{
        return(gsReturnError(x, errcode=.11, errmsg="HSD spending function parameter not given"))
	}
   
	if (abs(param) > 40) 
	{
	    return(gsReturnError(x, errcode=.12, errmsg="HSD spending function parameter must be <= 40 in absolute value"))
	}
   
	t[t > 1] <- 1
   
	if (param == 0) 
	{
	    x$spend<-t * alpha
    }
    else 
	{
	    x$spend <- alpha * (1. - exp(-t * param)) / (1 - exp(-param))
	}
   
	return(x)
}

"sfExponential" <- function(alpha, t, param)
{  
	x <- list(name="Exponential", param=param, parname="nu", sf=sfExponential, spend=NULL, 
           bound=NULL, prob=NULL, errcode=0, errmsg="No error")  
    class(x) <- "spendfn"
   
	if (length(param) != 1) 
	{
	    return(gsReturnError(x, errcode=.1, errmsg="Exponential spending function parameter must be a single real value"))
	}
   
    if (!is.numeric(param)) 
	{
	    return(gsReturnError(x, errcode=.11, errmsg="Exponential spending function parameter not given"))
    }
   
    if (param <= 0. || param > 10) 
	{
	    return(gsReturnError(x,errcode=.12,errmsg="Exponential spending function parameter must be > 0 and <= 10"))
    }
   
	t[t > 1] <- 1
    x$spend <- alpha ^ (t ^ (-param))
   
	return(x)
}

"sfBetaDist" <- function(alpha, t, param)
{  
	x<-list(name="Beta distribution", param=param, parname=c("a","b"), sf=sfBetaDist, spend=NULL,
            bound=NULL, prob=NULL, errcode=0, errmsg="No error")  
    class(x) <- "spendfn"
	
	if (length(param) != 2 && length(param) != 4) 
	{
	    return(gsReturnError(x, errcode=.3, "Beta distribution spending function parameter must be of length 2 or 4"))
	}
	
	if (!is.numeric(param)) 
	{
	    return(gsReturnError(x,errcode=.1, errmsg="Beta distribution spending function parameter must be numeric"))
	}
	
    if (length(param) == 2)
    {   
	    if (param[1] <= 0.) 
		{
		    return(gsReturnError(x, errcode=.12, errmsg="1st Beta distribution spending function parameter must be > 0."))
		}
		if (param[2] <= 0.) 
		{
		    return(gsReturnError(x, errcode=.13, errmsg="2nd Beta distribution spending function parameter must be > 0."))
		}
    }	
    else
    {   
	    if (min(param) <= 0. || max(param) >= 1.)
		{
		    return(gsReturnError(x, errcode=.14, errmsg="4-parameter specification of Beta distribution spending function must have all values >0 and < 1."))
	    }
			
		tem <- nlminb(c(1, 1), diffbetadist, lower=c(0, 0), xval=param[1:2], uval=param[3:4])

		if (tem$convergence != 0)
	    { 
		    return(gsReturnError(x,errcode=.15,errmsg="Solution to 4-parameter specification of Beta distribution spending function not found."))
		}
       
		x$param <- tem$par
    }
	
	t[t > 1] <- 1
    x$spend <- alpha * pbeta(t, x$param[1], x$param[2])

	return(x)
}

"diffbetadist" <- function(aval, xval, uval)
{   
    if (min(aval) <= 0.) return(1000)
    diff <- uval - pbeta(xval, aval[1], aval[2])
    return(sum(diff ^ 2))
}

"sfLDOF" <- function(alpha, t, param)
{  
    x<-list(name="Lan-DeMets O'brien-Fleming approximation", param=NULL, parname="none", sf=sfLDOF, spend=NULL,
            bound=NULL, prob=NULL, errcode=0, errmsg="No error")  
    class(x) <- "spendfn"
   
	z <- -qnorm(alpha / 2)
	t[t > 1] <- 1
    x$spend <- 2 * (1 - pnorm(z / sqrt(t)))
   
	return(x)
}

"sfLDPocock" <- function(alpha, t, param)
{  
    x <- list(name="Lan-DeMets Pocock approximation", param=NULL, parname="none", sf=sfLDPocock, spend=NULL,
            bound=NULL, prob=NULL, errcode=0, errmsg="No error")  
    class(x) <- "spendfn"
   
	e <- exp(1)
	t[t > 1] <- 1
    x$spend <- alpha * log(1 + (e-1) * t)
   
	return(x)
}

"sfPoints" <- function(alpha, t, param)
{  
	x <- list(name="User-specified", param=param, parname="Points", sf=sfPoints, spend=NULL, 
           bound=NULL, prob=NULL, errcode=0, errmsg="No error")
    class(x) <- "spendfn"
   
	k <- length(t)
    j <- length(param)
	
	if (j==k-1)
	{ 
		x$param <- c(param, 1)
		j <- k
	}
	
	if (j != k)
	{ 
		return(gsReturnError(x, errcode=.1, errmsg="Cumulative user-specified proportion of spending must be specified for each interim analysis"))
	}
   
    if (!is.numeric(param))
	{ 
		return(gsReturnError(x, errcode=.11, errmsg="Numeric user-specified spending levels not given"))
	}    
    
# ??? see GSD-29
	incspend <- x$param - c(0, x$param[1:k-1])
	
	if (min(incspend) <=  0.)
	{ 
		return(gsReturnError(x, errcode=.12, errmsg="Cumulative user-specified spending levels must increase with each analysis"))
	}

	if (min(incspend) <=  0.)
	{ 
		return(gsReturnError(x, errcode=.12, errmsg="Cumulative user-specified spending levels must increase with each analysis"))
	}
	
	if (max(x$param) > 1.)
	{ 
		return(gsReturnError(x, errcode=.12, errmsg="Cumulative user-specified spending must be > 0 and <= 1"))
	}
   
	x$spend <- alpha * x$param
   
	return(x)
}

"sfLogistic" <- function(alpha, t, param)
{  
    x <- list(name="Logistic", param=param, parname=c("a", "b"), sf=sfLogistic, spend=NULL, 
           bound=NULL, prob=NULL, errcode=0, errmsg="No error")
    class(x) <- "spendfn"
	
	if (length(param) != 2 && length(param) != 4)
	{ 
		return(gsReturnError(x, errcode=.3, "Logistic spending function parameter must be of length 2 or 4"))
	}
   
	if (!is.numeric(param))
	{ 
		return(gsReturnError(x, errcode=.11, errmsg="Numeric logistic spending function parameters not given"))
	}
    else if (length(param) == 2)
	{
	    if (!is.numeric(param[1])) 
		{
		    return(gsReturnError(x, errcode=.31, errmsg="Numeric first logistic spending parameter not given"))
		}
		if (param[2] <= 0.) 
		{
		    return(gsReturnError(x, errcode=.32, errmsg="Second logistic spending parameter param[2] must be real value > 0"))
		}
	
	    a <- param[1]
	    b <- param[2]
   }
   else
   {   
	   t0 <- param[1:2]
       p0 <- param[3:4]
	   
	   if (t0[2] <= t0[1] || p0[2] <= p0[1]) 
	   {
		   return(gsReturnError(x, errcode=.33, errmsg="4-parameter specification of logistic function incorrect"))
	   }
        
       xv <- log(t0 / (1 - t0))
       y <- log(p0 / (1 - p0))
       b <- (y[2] - y[1]) / (xv[2] - xv[1])
       a <- y[2] - b * xv[2]
	   x$param <- c(a, b)
    }
   
    xv <- log(t / (1 - 1 * (!is.element(t, 1)) * t))
	y <- exp(a + b * xv)
	y <- y / (1 + y)
	t[t > 1] <- 1
	x$spend <- alpha * (1 * (!is.element(t, 1)) * y + 1 * is.element(t, 1))
   
	return(x)
}

"sfExtremeValue" <- function(alpha, t, param)
{  
	x <- list(name="Extreme value", param=param, parname=c("a", "b"), sf=sfExtremeValue, spend=NULL, 
           bound=NULL, prob=NULL, errcode=0, errmsg="No error")
    class(x) <- "spendfn"
   
	if (length(param) != 2 && length(param) != 4) 
	{
		return(gsReturnError(x, errcode=.3, "Extreme value spending function parameter must be of length 2 or 4"))
	}
	
	if (!is.numeric(param)) 
	{
		return(gsReturnError(x, errcode=.11, errmsg="Numeric extreme value spending function parameters not given"))
	}
	else if (length(param) == 2)
	{	
	    if (!is.numeric(param[1])) 
		{
			return(gsReturnError(x, errcode=.31, errmsg="Numeric first extreme value spending parameter not given"))
		}
		
		if (param[2] <= 0.) 
		{
			return(gsReturnError(x, errcode=.32, errmsg="Second extreme value spending parameter param[2] must be real value > 0"))
		}
	
		a <- param[1]
		b <- param[2]
   }
   else
   {   
	   t0 <- param[1:2]
       p0 <- param[3:4]
	   
	   if (t0[2] <= t0[1] || p0[2] <= p0[1]) 
	   {
            return(gsReturnError(x, errcode=.33, errmsg="4-parameter specification of extreme value function incorrect"))
	   }
         
       xv <-  -log(-log(t0))
       y <-  -log(-log(p0))
       b <- (y[2] - y[1]) / (xv[2] - xv[1])
       a <- y[2] - b * xv[2]
	   x$param <- c(a, b)
    }
	
	t[t > 1] <- 1
	xv <-  -log(-log((!is.element(t, 1)) * t))
	y <- exp(-exp(-a-b * xv))
	x$spend <- alpha * (1 * (!is.element(t, 1)) * y + 1 * is.element(t, 1))
	
	return(x)
}

"sfExtremeValue2" <- function(alpha, t, param)
{  
	x <- list(name="Extreme value 2", param=param, parname=c("a", "b"), sf=sfExtremeValue2, spend=NULL, 
           bound=NULL, prob=NULL, errcode=0, errmsg="No error")
    class(x) <- "spendfn"
	
	if (length(param) != 2 && length(param) != 4) 
	{
		return(gsReturnError(x, errcode=.3, "Extreme value (2) spending function parameter must be of length 2 or 4"))
	}
	
	if (!is.numeric(param)) 
	{
		return(gsReturnError(x, errcode=.11, errmsg="Numeric extreme value (2) spending function parameters not given"))
	}
    else if (length(param) == 2)
	{	
	    if (!is.numeric(param[1])) return(gsReturnError(x, errcode=.31, errmsg="Numeric first extreme value (s) spending parameter not given"))
		if (param[2] <= 0.) return(gsReturnError(x, errcode=.32, errmsg="Second extreme value (2) spending parameter param[2] must be real value > 0"))
		a <- param[1]
		b <- param[2]
	}
	else
	{   
	    t0 <- param[1:2]
		p0 <- param[3:4]
		
		if (t0[2] <= t0[1] || p0[2] <= p0[1]) 
		{
			return(gsReturnError(x, errcode=.33, errmsg="4-parameter specification of extreme value (2) function incorrect"))
		}
       
		xv <- log(-log(1 - t0))
		y <- log(-log(1 - p0))
		b <- (y[2] - y[1]) / (xv[2] - xv[1])
		a <- y[2] - b * xv[2]
		x$param <- c(a, b)
	}
	
	t[t > 1] <- 1
	xv <- log(-log(1 - 1 * (!is.element(t, 1)) * t))
	y <- 1 - exp(-exp(a + b * xv))
	x$spend <- alpha * (1 * (!is.element(t, 1)) * y + 1 * is.element(t, 1))
	
	return(x)
}

"sfCauchy" <- function(alpha, t, param)
{  
	x <- list(name="Cauchy", param=param, parname=c("a", "b"), sf=sfCauchy, spend=NULL, 
           bound=NULL, prob=NULL, errcode=0, errmsg="No error")
    class(x) <- "spendfn"
	
	if (length(param) != 2 && length(param) != 4) 
	{
	    return(gsReturnError(x, errcode=.3, "Cauchy spending function parameter must be of length 2 or 4"))
	}
   
	if (!is.numeric(param)) 
	{
	    return(gsReturnError(x, errcode=.11, errmsg="Numeric Cauchy spending function parameters not given"))
	}
	else if (length(param) == 2)
	{	
		if (!is.numeric(param[1])) 
		{
		    return(gsReturnError(x, errcode=.31, errmsg="Numeric first Cauchy spending parameter not given"))
		}
	
		if (param[2] <= 0.) 
		{
			return(gsReturnError(x, errcode=.32, errmsg="Second Cauchy spending parameter param[2] must be real value > 0"))
		}
	
		a <- param[1]
		b <- param[2]
    }
    else
	{   
		t0 <- param[1:2]
		p0 <- param[3:4]
		
		if (t0[2] <= t0[1] || p0[2] <= p0[1]) 
		{
		    return(gsReturnError(x, errcode=.33, errmsg="4-parameter specification of Cauchy function incorrect"))
		}
       
		xv <- qcauchy(t0)
		y <- qcauchy(p0)
		b <- (y[2] - y[1]) / (xv[2] - xv[1])
		a <- y[2] - b * xv[2]
		x$param <- c(a, b)
	}
	
	t[t > 1] <- 1
	xv <- qcauchy(1 * (!is.element(t, 1)) * t)
	y <- pcauchy(a + b * xv)
	x$spend <- alpha * (1 * (!is.element(t, 1)) * y + 1 * is.element(t, 1))
   
	return(x)
}

"sfNormal" <- function(alpha, t, param)
{  
	x <- list(name="Normal", param=param, parname=c("a", "b"), sf=sfNormal, spend=NULL, 
           bound=NULL, prob=NULL, errcode=0, errmsg="No error")
    class(x) <- "spendfn"
	
	if (length(param) != 2 && length(param) != 4) 
	{
	    return(gsReturnError(x, errcode=.3, "Normal spending function parameter must be of length 2 or 4"))
	}
	
	if (!is.numeric(param)) 
	{
	    return(gsReturnError(x, errcode=.11, errmsg="Numeric Normal spending function parameters not given"))
	}
	else if (length(param) == 2)
	{	
	    if (!is.numeric(param[1])) 
		{
			return(gsReturnError(x, errcode=.31, errmsg="Numeric first Normal spending parameter not given"))
		}
		
		if (param[2] <= 0.) 
		{
			return(gsReturnError(x, errcode=.32, errmsg="Second Normal spending parameter param[2] must be real value > 0"))
		}
	
		a <- param[1]
		b <- param[2]
	}
	else
	{   
		t0 <- param[1:2]
		p0 <- param[3:4]
		
		if (t0[2] <= t0[1] || p0[2] <= p0[1]) 
		{
			return(gsReturnError(x, errcode=.33, errmsg="4-parameter specification of Normal function incorrect"))
		}
        
		xv <- qnorm(t0)
		y <- qnorm(p0)
		b <- (y[2] - y[1]) / (xv[2] - xv[1])
		a <- y[2] - b * xv[2]
		x$param <- c(a, b)
	}
	
	t[t > 1] <- 1
	xv <- qnorm(1 * (!is.element(t, 1)) * t)
	y <- pnorm(a + b * xv)
	x$spend <- alpha * (1 * (!is.element(t, 1)) * y + 1 * is.element(t, 1))
   
	return(x)
}

"sfTDist" <- function(alpha, t, param)
{  
    x <- list(name="t-distribution", param=param, parname=c("a", "b", "df"), sf=sfTDist, spend=NULL, 
           bound=NULL, prob=NULL, errcode=0, errmsg="No error")
    class(x) <- "spendfn"
	
	if (length(param) != 3 && length(param) != 5 && length(param) != 6) 
	{
		return(gsReturnError(x, errcode=.3, "t-distribution spending function parameter must be of length 3 or 5"))
	}
	
	if (!is.numeric(param)) 
	{
		return(gsReturnError(x, errcode=.11, errmsg="Numeric t-distribution spending function parameters not given"))
	}
	else if (length(param) == 3)
	{	
	    if (!is.numeric(param[1])) 
		{
		    return(gsReturnError(x, errcode=.31, errmsg="Numeric first t-distribution spending parameter not given"))
		}
		
		if (param[2] <= 0.) 
		{
			return(gsReturnError(x, errcode=.32, errmsg="Second t-distribution spending parameter param[2] must be real value > 0"))
		}
	
		if (param[3] < 1.) 
		{
			return(gsReturnError(x, errcode=.32, errmsg="Final t-distribution spending parameter must be real value at least 1"))
		}
	
		a <- param[1]
	
		b <- param[2]
	
		df <- param[3]
	}
	else if (length(param) == 5)
	{   
	    t0 <- param[1:2]
		p0 <- param[3:4]
		df <- param[5]
 	 
		if (param[5] < 1.) 
		{
			return(gsReturnError(x, errcode=.32, errmsg="Final t-distribution spending parameter must be real value at least 1"))
		}
		
		if (t0[2] <= t0[1] || p0[2] <= p0[1]) 
		{
			return(gsReturnError(x, errcode=.33, errmsg="5-parameter specification of t-distribution spending function incorrect"))
		}
       
		xv <- qt(t0, df)
		y <- qt(p0, df)
		b <- (y[2] - y[1]) / (xv[2] - xv[1])
		a <- y[2] - b * xv[2]
	}
	else
	{   
		t0 <- param[1:3]
		p0 <- param[4:6]
	   
		if (t0[2] <= t0[1] || p0[2] <= p0[1]) 
		{
			return(gsReturnError(x, errcode=.33, errmsg="6-parameter specification of t-distribution spending function incorrect"))
		}
        
        # check Cauchy and normal which must err in opposite directions for a solution to exist
		unorm <- sfNormal(alpha, t0[3], param=c(t0[1:2], p0[1:2]))$spend / alpha - p0[3]
		ucauchy <- sfCauchy(alpha, t0[3], param=c(t0[1:2], p0[1:2]))$spend / alpha - p0[3]
		
		if (unorm * ucauchy >= 0.) 
		{
			return(gsReturnError(x, errcode=.34, errmsg="6-parameter specification of t-distribution spending function did not produce a solution"))
		}
       
		sol <- uniroot(Tdistdiff, interval=c(1, 200), t0=t0, p0=p0)
		df <- sol$root
		xv <- qt(t0, df)
		y <- qt(p0, df)
		b <- (y[2] - y[1]) / (xv[2] - xv[1])
		a <- y[2] - b * xv[2]
	}
   
	x$param <- c(a, b, df)
	t[t > 1] <- 1
	xv <- qt(1 * (!is.element(t, 1)) * t, df)
	y <- pt(a + b * xv, df)
	x$spend <- alpha * (1 * (!is.element(t, 1)) * y + 1 * is.element(t, 1))
   
	return(x)
}

"Tdistdiff" <- function(x, t0, p0)
{  
	xv <- qt(t0, x)
	y <- qt(p0, x)
	b <- (y[2] - y[1]) / (xv[2] - xv[1])
	a <- y[2] - b * xv[2]
   
	return(a + b * xv[3] - y[3])
}

"spendingFunction" <- function(alpha, t, param)
{  
	x <- list(name="Linear", param=param, parname="none", sf=spendingFunction, spend=NULL, 
           bound=NULL, prob=NULL, errcode=0, errmsg="No error")  
    class(x) <- "spendfn"
	
	t[t > 1] <- 1
	x$spend <- alpha * t
   
	return(x)
}


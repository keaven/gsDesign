"gsReturnError" <- function(x, errcode, errmsg)
{	
    x$errcode <- errcode
	x$errmsg <- errmsg
	
    if (errcode > 0){
        stop("Error code ", errcode, " : ", errmsg)
    }
    
    x
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
            return(gsReturnError(x, errcode=11.3, errmsg="n.I must be an increasing, positive sequence"))
        }
        
        if (x$maxn.IPlan <= 0) 
        {
            x$maxn.IPlan<-max(x$n.I)
        }
        else if (x$test.type < 3 && is.character(x$sfu))
        {
            return(gsReturnError(x,errcode=11.31,
                            errmsg="maxn.IPlan can only be > 0 if spending functions are used for boundaries"))
        }
        
        x$timing <- x$n.I[1:(x$k-1)] / x$maxn.IPlan
        
        if (x$n.I[x$k-1] >= x$maxn.IPlan)
        {
            return(gsReturnError(x, errcode=12, errmsg="maxn.IPlan must be > n.I[k-1]"))            
        }
    }
    else if (x$maxn.IPlan > 0)
    {   
        if (length(x$n.I) == 1)
        {
            return(gsReturnError(x, errcode=11.4, errmsg="If maxn.IPlan is specified, n.I must be specified"))
        }
    }    

    # check input for timing of interim analyses
    # if timing not specified, make it equal spacing
    if (length(x$timing) < 1 || (length(x$timing) == 1 && (x$k > 2 || (x$k == 2 && (x$timing[1] <= 0 || x$timing[1] >= 1)))))
    {
        x$timing <- seq(x$k) / x$k
    }
    # if timing specified, make sure it is done correctly
    else if (length(x$timing) == x$k - 1 || length(x$timing) == x$k) 
    {   
        if (length(x$timing) == x$k - 1)
        {
            x$timing <- c(x$timing, 1)
        }
        else if (x$timing[x$k]!=1)
        {
            return(gsReturnError(x, errcode=8, errmsg="if analysis timing for final analysis is input, it must be 1"))            
        }

        if (min(x$timing - c(0,x$timing[1:x$k-1])) <= 0)
        {
            return(gsReturnError(x, errcode=8.1, errmsg="input timing of interim analyses must be increasing strictly between 0 and 1"))            
        }
    }
    else
    {
        return(gsReturnError(x, errcode=8.2, errmsg="value input for timing must be length 1, k-1 or k"))
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
    
    #if you get here, no error found
    return(gsReturnError(x, errcode=0, errmsg="No errors detected"))
}

"gsCheckSpend" <- function(x)
{   
    if (class(x) != "spend")
    {   
        x <- gsReturnError(x, errcode=1, errmsg="Spending function must return a value of class 'spend'")
        return(x)
    }
    
    x
}

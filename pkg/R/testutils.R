# Input variable test functions for gsDesign package
# 
# Author: bill@revolution-computing.com
###############################################################################

"isInteger" <- function(x) all(is.numeric(x)) && all(round(x,0) == x)

"checkScalar" <- function(x, isType = "numeric", ...) 
{        
    # check inputs
    if (!is.character(isType))
    {
        stop("isType must be an object of class character")
    }
    
    # create error message    
    parent <- as.character(sys.call(-1)[[1]])
    varstr <- paste(if (length(parent) > 0) paste("In function", parent, ": variable") else "", deparse(substitute(x))) 
    err <- paste(varstr, "must be scalar of class", isType) 
    
    # check scalar type
    if (isType == "integer")
    {            
        if (!isInteger(x) || length(x) > 1)
        {
          stop(err)
        }
    }
    else {
        if (!eval(parse(text = paste("is.", isType, "(x)", sep = ""))) || length(x) > 1)
        {
          stop(err)
        }
    }
    
    # check if input is on specified interval    
    if (length(list(...)) > 0)
    {
        checkRange(x, ..., varname=varstr)
    }
    
    invisible(NULL)
}

"checkVector" <- function(x, isType = "numeric", ..., length=NULL) 
{
    # check inputs
    checkScalar(isType, "character")
    if (!is.null(length))
    {
        checkScalar(length,"integer")
    }
    
    # define local functions
    "isVectorAtomic" <- function(x) 
        return(is.atomic(x) & any(c(NROW(x), NCOL(x)) == 1))
    
    # create error message
    parent <- as.character(sys.call(-1)[[1]])
    varstr <- paste(if (length(parent) > 0) paste("In function", parent, ": variable") else "", deparse(substitute(x))) 
    err <- paste(varstr, "must be vector of class", isType) 
    
    # check vector type
    if (isType == "integer")
    {
       if (!isVectorAtomic(x) || !isInteger(x))
       {
         stop(err)
       }
    }
    else if (!isVectorAtomic(x) || !eval(parse(text = paste("is.", isType, "(x)", sep = ""))))
    {
        stop(err)
    }

    # check vector length
    if (!is.null(length) && (length(x) != length))
    {
        stop(paste(varstr, "is a vector of length", length(x), "but should be of length", length))
    }
    
    # check if input is on specified interval
    if (length(list(...)) > 0)
    {
        checkRange(x, ..., varname=varstr)
    }
    
    invisible(NULL)
}

"checkRange" <- function(x, interval = 0:1, inclusion = c(TRUE, TRUE), varname = deparse(substitute(x)), 
        tol=0) 
{
    # check inputs
    checkVector(interval, "numeric")
    if (length(interval) != 2)
    {
        stop("Interval input must contain two elements")
    }
    
    interval <- sort(interval)
    checkVector(inclusion, "logical")
    inclusion <- if (length(inclusion) == 1) rep(inclusion, 2) else inclusion[1:2]
    
    xrange <- range(x)
    left   <- ifelse(inclusion[1], xrange[1] >= interval[1] - tol, xrange[1] > interval[1] - tol)
    right  <- ifelse(inclusion[2], xrange[2] <= interval[2] + tol, xrange[2] < interval[2] + tol)
    
    if (!(left && right))
    {
        stop(paste(varname, " not on interval ", if (inclusion[1]) "[" else "(", interval[1], ", ", 
                        interval[2], if (inclusion[2]) "]" else ")", sep=""))
    }
        
    invisible(NULL)
}

"checkLengths" <- function(..., allowSingle=FALSE)
{
    parent <- as.character(sys.call(-1)[[1]])
    err <- paste(if (length(parent) > 0) paste("In function", parent, ":") else "", 
                 "lengths of inputs are not all equal") 
    
    lens <- unlist(lapply(list(...),length))
    
    if (allowSingle)
    {
        lens <- lens[lens > 1]
    }
    
    if (length(lens) > 0 && length(unique(lens)) != 1)
    {
        stop(err)        
    }

    invisible(NULL)  
} 

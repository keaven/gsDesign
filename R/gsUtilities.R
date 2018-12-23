###
# Exported Functions
###

# checkLengths function [sinew] ---- 
checkLengths <- function(..., allowSingle=FALSE){    
    lens <- unlist(lapply(list(...),length))
    
    if (allowSingle)
    {
        lens <- lens[lens > 1]
    }
    
    if (length(lens) > 0 && length(unique(lens)) != 1)
    {
         parent <- as.character(sys.call(-1)[[1]])
         stop(if (length(parent) > 0) paste("In function", parent, ":") else "", 
             "lengths of inputs are not all equal")
    }
    
    invisible(NULL)  
}

# checkRange function [sinew] ---- 
checkRange <- function(x, interval = 0:1, inclusion = c(TRUE, TRUE), varname = deparse(substitute(x)), tol=0) {
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
                        interval[2], if (inclusion[2]) "]" else ")", sep=""), call.=TRUE)
    }
    
    invisible(NULL)
}



# checkScalar roxy [sinew] ---- 
#' 6.0 Utility functions to verify variable properties
#' 
#' Utility functions to verify an objects's properties including whether it is
#' a scalar or vector, the class, the length, and (if numeric) whether the
#' range of values is on a specified interval. Additionally, the
#' \code{checkLengths} function can be used to ensure that all the supplied
#' inputs have equal lengths.
#' 
#' \code{isInteger} is similar to \code{\link{is.integer}} except that
#' \code{isInteger(1)} returns \code{TRUE} whereas \code{is.integer(1)} returns
#' \code{FALSE}.
#' 
#' \code{checkScalar} is used to verify that the input object is a scalar as
#' well as the other properties specified above.
#' 
#' \code{checkVector} is used to verify that the input object is an atomic
#' vector as well as the other properties as defined above.
#' 
#' \code{checkRange} is used to check whether the numeric input object's values
#' reside on the specified interval.  If any of the values are outside the
#' specified interval, a \code{FALSE} is returned.
#' 
#' \code{checkLength} is used to check whether all of the supplied inputs have
#' equal lengths.
#' 
#' @aliases checkScalar checkVector checkRange checkLengths isInteger
#' @param x any object.
#' @param isType character string defining the class that the input object is
#' expected to be.
#' @param length integer specifying the expected length of the object in the
#' case it is a vector. If \code{length=NULL}, the default, then no length
#' check is performed.
#' @param interval two-element numeric vector defining the interval over which
#' the input object is expected to be contained.  Use the \code{inclusion}
#' argument to define the boundary behavior.
#' @param inclusion two-element logical vector defining the boundary behavior
#' of the specified interval. A \code{TRUE} value denotes inclusion of the
#' corresponding boundary. For example, if \code{interval=c(3,6)} and
#' \code{inclusion=c(FALSE,TRUE)}, then all the values of the input object are
#' verified to be on the interval (3,6].
#' @param varname character string defining the name of the input variable as
#' sent into the function by the caller.  This is used primarily as a mechanism
#' to specify the name of the variable being tested when \code{checkRange} is
#' being called within a function.
#' @param tol numeric scalar defining the tolerance to use in testing the
#' intervals of the
#' 
#' \code{\link{checkRange}} function.
#' @param \dots For the \code{\link{checkScalar}} and \code{\link{checkVector}}
#' functions, this input represents additional arguments sent directly to the
#' \code{\link{checkRange}} function. For the
#' 
#' \code{\link{checkLengths}} function, this input represents the arguments to
#' check for equal lengths.
#' @param allowSingle logical flag. If \code{TRUE}, arguments that are vectors
#' comprised of a single element are not included in the comparative length
#' test in the \code{\link{checkLengths}} function. Partial matching on the
#' name of this argument is not performed so you must specify 'allowSingle' in
#' its entirety in the call.
#' @keywords programming
#' @examples
#' 
#' # check whether input is an integer
#' isInteger(1)
#' isInteger(1:5)
#' try(isInteger("abc")) # expect error
#' 
#' # check whether input is an integer scalar
#' checkScalar(3, "integer")
#' 
#' # check whether input is an integer scalar that resides 
#' # on the interval on [3, 6]. Then test for interval (3, 6].
#' checkScalar(3, "integer", c(3,6))
#' try(checkScalar(3, "integer", c(3,6), c(FALSE, TRUE))) # expect error
#' 
#' # check whether the input is an atomic vector of class numeric,
#' # of length 3, and whose value all reside on the interval [1, 10)
#' x <- c(3, pi, exp(1))
#' checkVector(x, "numeric", c(1, 10), c(TRUE, FALSE), length=3)
#' 
#' # do the same but change the expected length; expect error
#' try(checkVector(x, "numeric", c(1, 10), c(TRUE, FALSE), length=2))
#' 
#' # create faux function to check input variable
#' foo <- function(moo) checkVector(moo, "character")
#' foo(letters)
#' try(foo(1:5)) # expect error with function and argument name in message
#' 
#' # check for equal lengths of various inputs
#' checkLengths(1:2, 2:3, 3:4)
#' try(checkLengths(1,2,3,4:5)) # expect error
#' 
#' # check for equal length inputs but ignore single element vectors
#' checkLengths(1,2,3,4:5,7:8, allowSingle=TRUE)
#' 
#' 
# checkScalar function [sinew] ----
checkScalar <- function(x, isType = "numeric", ...) {
    # check inputs
    if (!is.character(isType))
    {
        stop("isType must be an object of class character")
    }
    
    # check scalar type
    if (isType == "integer")
    {            
        bad <- (!isInteger(x) || length(x) > 1)
    }
    else {
        bad <- (!methods::is(c(x), isType) || length(x) > 1)
    }
    if (bad)
    {
        # create error message    
        parent <- as.character(sys.call(-1)[[1]])
        varstr <- paste(if (length(parent) > 0) paste("In function", parent, ": variable") else "", deparse(substitute(x)))
        stop(varstr, " must be scalar of class ", isType)
    }
    
    # check if input is on specified interval    
    if (length(list(...)) > 0)
    {
        checkRange(x, ..., varname=deparse(substitute(x)))
    }
    
    invisible(NULL)
}

# checkVector function [sinew] ---- 
checkVector <- function(x, isType = "numeric", ..., length=NULL) {
    # check inputs
    checkScalar(isType, "character")
    if (!is.null(length))
    {
        checkScalar(length,"integer")
    }
    
    # define local functions
    "isVectorAtomic" <- function(x) 
        return(is.atomic(x) & any(c(NROW(x), NCOL(x)) == 1))
        
    # check vector type
    bad <- if (isType == "integer")
    {
        !isVectorAtomic(x) || !isInteger(x)
    }
    else
    {
        !isVectorAtomic(x) || !methods::is(c(x), isType)  # wrap "x" in c() to strip dimension(s)
    }
    if (bad)
    {
        # create error message
        parent <- as.character(sys.call(-1)[[1]])
        varstr <- paste(if (length(parent) > 0) paste("In function", parent, ": variable") else "", deparse(substitute(x))) 
        stop(paste(varstr, " must be vector of class ", isType))
    }
    # check vector length
    if (!is.null(length) && (length(x) != length))
    {
        stop(paste(varstr, " is a vector of length ", length(x), " but should be of length", length))
    }
    
    # check if input is on specified interval
    if (length(list(...)) > 0)
    {
        checkRange(x, ..., varname=deparse(substitute(x)))
    }
    
    invisible(NULL)
}

# isInteger function [sinew] ---- 
isInteger <- function(x) all(is.numeric(x)) && all(round(x,0) == x)

###
# Hidden Functions
###

checkMD5 <- function (package="gsDesign", dir) {
    if (missing(dir)) 
        dir <- find.package(package, quiet = TRUE)
    if (!length(dir)) 
        return(NA)
    md5file <- file.path(dir, "MD5")
    if (!file.exists(md5file)) 
        return(NA)
    
    ignore <- c("MD5", "DESCRIPTION", "Meta/package.rds", "R/gsDesign.rdb", "R/gsDesign.rdx", 
            "libs/i386/gsDesign.so", "libs/ppc/gsDesign.so")    
    
    inlines <- readLines(md5file)
    xx <- sub("^([0-9a-fA-F]*)(.*)", "\\1", inlines)
    nmxx <- names(xx) <- sub("^[0-9a-fA-F]* [ |*](.*)", "\\1", inlines)
    
    nmxx <- nmxx[!(nmxx %in% ignore)]
    
    dot <- getwd()
    setwd(dir)
    x <- tools::md5sum(dir(dir, recursive = TRUE))
    setwd(dot)
    
    x <- x[!(names(x) %in% ignore)]
    nmx <- names(x)
    res <- TRUE
    not.here <- !(nmxx %in% nmx)
    if (any(not.here)) {
        res <- FALSE
        cat("files", paste(nmxx[not.here], collapse = ", "), 
                "are missing\n", sep = " ")
    }
    nmxx <- nmxx[!not.here]
    diff <- xx[nmxx] != x[nmxx]
    if (any(diff)) {
        res <- FALSE
        cat("files", paste(nmxx[diff], collapse = ", "), "have the wrong MD5 checksums\n", 
                sep = " ")
    }
    return(res)
}

# checkMatrix function [sinew] ---- 
checkMatrix <- function(x, isType = "numeric", ..., nrows=NULL, ncols=NULL) {
  # check inputs
  checkScalar(isType, "character")
  if (!is.null(nrows))
  {
    checkScalar(nrows,"integer")
  }
  if (!is.null(ncols))
  {
    checkScalar(ncols,"integer")
  }
  
  # define local functions
  "isMatrixAtomic" <- function(x) 
    return(is.atomic(x) & all(c(NROW(x), NCOL(x)) > 0))
  
  # check matrix type
  bad <- if (isType == "integer")
  {
    !isMatrixAtomic(x) || !isInteger(x)
  }
  else
  {
    !isMatrixAtomic(x) || !methods::is(c(x), isType)  # wrap "x" in c() to strip dimension(s)
  }
  if (bad)
  {
    # create error message
    parent <- as.character(sys.call(-1)[[1]])
    varstr <- paste(if (length(parent) > 0) paste("In function", parent, ": variable") else "", deparse(substitute(x))) 
    stop(paste(varstr, " must be matrix of class ", isType))
  }
  # check matrix dimensions
  if (!is.null(nrows) && (NROW(x) != nrows))
  {
    stop(paste(varstr, "is a matrix with", NROW(x), "rows, but should have", nrows, "rows"))
  }
  if (!is.null(ncols) && (NCOL(x) != ncols))
  {
    stop(paste(varstr, "is a matrix with", NCOL(x), "columns, but should have", ncols, "columns"))
  }
  
  # check if input is on specified interval
  if (length(list(...)) > 0)
  {
    checkRange(x, ..., varname=deparse(substitute(x)))
  }
  
  invisible(NULL)
}

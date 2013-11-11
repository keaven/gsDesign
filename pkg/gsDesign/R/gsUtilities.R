##################################################################################
#  Validation functionality for the gsDesign package
#
#  Exported Functions:
#                   
#    checkLengths
#    checkRange
#    checkScalar
#    checkVector
#    isInteger
#
#  Hidden Functions:
#
#    checkMD5
#
#  Author(s): William Constantine, Ph.D.
# 
#  Reviewer(s): REvolution Computing 19DEC2008 v.2.0 - William Constantine, Kellie Wills 
#  Updated: Keaven Anderson, 16JUN2013 to fix error messages
#  R Version: 3.0
#
##################################################################################

###
# Exported Functions
###

"checkLengths" <- function(..., allowSingle=FALSE)
{    
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
                        interval[2], if (inclusion[2]) "]" else ")", sep=""), call.=TRUE)
    }
    
    invisible(NULL)
}

"checkScalar" <- function(x, isType = "numeric", ...) 
{
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
        bad <- (!is(c(x), isType) || length(x) > 1)
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
        
    # check vector type
    bad <- if (isType == "integer")
    {
        !isVectorAtomic(x) || !isInteger(x)
    }
    else
    {
        !isVectorAtomic(x) || !is(c(x), isType)  # wrap "x" in c() to strip dimension(s)
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

"isInteger" <- function(x) all(is.numeric(x)) && all(round(x,0) == x)

###
# Hidden Functions
###

"checkMD5" <- function (package="gsDesign", dir) 
{
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
"checkMatrix" <- function(x, isType = "numeric", ..., nrows=NULL, ncols=NULL) 
{
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
    !isMatrixAtomic(x) || !is(c(x), isType)  # wrap "x" in c() to strip dimension(s)
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

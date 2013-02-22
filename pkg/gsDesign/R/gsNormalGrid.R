##################################################################################
#  Normal density grid functionality for the gsDesign package
#
#  Exported Functions:
#                   
#    normalGrid
#
#  Hidden Functions:
#
#    (none)
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

"normalGrid" <- function(r=18, bounds=c(0, 0), mu=0, sigma=1)
{    
    checkScalar(r,"integer", c(1, 80))
    checkVector(bounds,"numeric")
    checkScalar(mu, "numeric")
    checkScalar(sigma, "numeric", c(0, Inf), c(FALSE, TRUE))
    
    if (length(bounds) != 2)
    {
        stop("bounds variable in normalGrid must be numeric and have length 2")
    }
    
    # produce grid points and weights for numerical integration of normal density    
    storage.mode(r) <- "integer"
    
    z <- as.double(c(1:(12 * r - 3)))
    w <- z

    if (bounds[1] == 0. && bounds[2] == 0.)
    {    
        bounds[1] <- mu - 6 * sigma
        bounds[2] <- mu + 6 * sigma
    }
    else if (bounds[2] <= bounds[1])
    {
        return(list(z=NULL, wgts=NULL))        
    }

    b <- as.double((bounds-mu) / sigma)
    xx <- .C("stdnorpts", r, b, z, w)
    len <- sum(xx[[3]] <= b[2])
    z <- xx[[3]][1:len] * sigma + mu
    w <- xx[[4]][1:len] * sigma
    d <- dnorm(z, mean=mu, sd=sigma)
    list(z=z, density=d, gridwgts=w, wgts=d*w) 
}

invCDF  <- function(q, x, discrete=FALSE, upper=FALSE, tol=.000001)
{   checkLengths(x$z, x$density, x$gridwgts, x$wgts)
    len <- length(x$z)
    checkVector(x$z[2:len]-x$z[1:(len-1)],"numeric",c(0,Inf), c(TRUE, FALSE))
    checkVector(x$density,"numeric",c(0,Inf),c(FALSE,FALSE))
    checkVector(x$gridwgts,"numeric",c(0,Inf),c(FALSE,FALSE))
    checkVector(x$wgts, "numeric", c(0,1), c(FALSE, TRUE))
    if (!upper) CDF <- cumsum(x$wgts)
    else CDF <- cumsum(x$wgts[len:1])
    if (CDF[len] > 1.0000001 || CDF[len]<.9999999)
        stop("Input distribution did not integrate to 1")
    if (q <= 0 || q > 1) stop("q outside of range (0,1]")
    CDFq <- CDF[CDF <= q]
    i <- length(CDFq)
    if (i==0) 
    {   if (!upper) return(x$z[1])
        return(x$z[len])
    }
    if (discrete && !upper) return(x$z[i])
    if (discrete) return(x$z[len-i])
    if (abs(q - CDF[i])<tol)
    {   if (!upper) return(x$z[i])
        return(x$z[len-i])
    }
    # if not discrete and inverse is between grid points in x$z, 
    # use trapezoidal rule to approximate inverse
    F1 <- CDF[i]; F2 <- CDF[i+1]
    if (!upper){ z1 <- x$z[i]; z2 <- x$z[i+1]}
    else { z1 <- x$z[len-i]; z2 <- x$z[len+1-i]}
    return((q-F1)/(F2-F1)*(z2-z1)+z1)
}

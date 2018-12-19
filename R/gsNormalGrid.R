###
# Exported Functions
###



#' 3.1: Normal Density Grid
#' 
#' normalGrid() is intended to be used for computation of the expected value of
#' a function of a normal random variable.  The function produces grid points
#' and weights to be used for numerical integration.
#' 
#' This is a utility function to provide a normal density function and a grid
#' to integrate over as described by Jennison and Turnbull (2000), Chapter 19.
#' While integration can be performed over the real line or over any portion of
#' it, the numerical integration does not extend beyond 6 standard deviations
#' from the mean. The grid used for integration uses equally spaced points over
#' the middle of the distribution function, and spreads points further apart in
#' the tails. The values returned in \code{gridwgts} may be used to integrate
#' any function over the given grid, although the user should take care that
#' the function integrated is not large in the tails of the grid where points
#' are spread further apart.
#' 
#' @param r Control for grid points as in Jennison and Turnbull (2000), Chapter
#' 19; default is 18. Range: 1 to 80.  This might be changed by the user (e.g.,
#' \code{r=6} which produces 65 gridpoints compare to 185 points when
#' \code{r=18}) when speed is more important than precision.
#' @param bounds Range of integration. Real-valued vector of length 2. Default
#' value of 0, 0 produces a range of + or - 6 standard deviations (6*sigma)
#' from the mean (=mu).
#' @param mu Mean of the desired normal distribution.
#' @param sigma Standard deviation of the desired normal distribution.
#' @return \item{z}{Grid points for numerical integration.} \item{density}{The
#' standard normal density function evaluated at the values in \code{z}; see
#' examples.} \item{gridwgts}{Simpson's rule weights for numerical integration
#' on the grid in \code{z}; see examples.} \item{wgts}{Weights to be used with
#' the grid in \code{z} for integrating the normal density function; see
#' examples. This is equal to \code{density * gridwgts}.}
#' @note The manual is not linked to this help file, but is available in
#' library/gsdesign/doc/gsDesignManual.pdf in the directory where R is
#' installed.
#' @author Keaven Anderson \email{keaven\_anderson@@merck.com}
#' @references Jennison C and Turnbull BW (2000), \emph{Group Sequential
#' Methods with Applications to Clinical Trials}. Boca Raton: Chapman and Hall.
#' @keywords design
#' @examples
#' 
#' #  standard normal distribution
#' x <- normalGrid(r=3)
#' plot(x$z, x$wgts)
#' 
#' #  verify that numerical integration replicates sigma
#' #  get grid points and weights
#' x <- normalGrid(mu=2, sigma=3)
#' 
#' # compute squared deviation from mean for grid points
#' dev <- (x$z-2)^2
#' 
#' # multiply squared deviations by integration weights and sum 
#' sigma2 <- sum(dev * x$wgts)
#' 
#' # square root of sigma2 should be sigma (3)
#' sqrt(sigma2)
#' 
#' # do it again with larger r to increase accuracy
#' x <- normalGrid(r=22, mu=2, sigma=3)
#' sqrt(sum((x$z - 2)^2 * x$wgts))
#' 
#' # this can also be done by combining gridwgts and density
#' sqrt(sum((x$z - 2)^2 * x$gridwgts * x$density))
#' 
#' # integrate normal density and compare to built-in function
#' # to compute probability of being within 1 standard deviation
#' # of the mean
#' pnorm(1)-pnorm(-1)
#' x <- normalGrid(bounds=c(-1, 1))
#' sum(x$wgts)
#' sum(x$gridwgts * x$density)
#' 
#' # find expected sample size for default design with
#' # n.fix=1000
#' x <- gsDesign(n.fix=1000)
#' x
#' 
#' # set a prior distribution for theta
#' y <- normalGrid(r=3, mu=x$theta[2], sigma=x$theta[2] / 1.5)
#' z <- gsProbability(k=3, theta=y$z, n.I=x$n.I, a=x$lower$bound,
#'                    b=x$upper$bound)
#' z <- gsProbability(d=x, theta=y$z)
#' cat("Expected sample size averaged over normal\n prior distribution for theta with \n mu=", 
#'    x$theta[2], "sigma=", x$theta[2]/1.5, ":",
#'    round(sum(z$en*y$wgt), 1), "\n")
#' plot(y$z, z$en, xlab="theta", ylab="E{N}", 
#'    main="Expected sample size for different theta values")
#' lines(y$z, z$en)
#' 
normalGrid <- function(r=18, bounds=c(0, 0), mu=0, sigma=1){    
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
    d <- stats::dnorm(z, mean=mu, sd=sigma)
    list(z=z, density=d, gridwgts=w, wgts=d*w) 
}

invCDF     <- function(q, x, discrete=FALSE, upper=FALSE, tol=.000001){   checkLengths(x$z, x$density, x$gridwgts, x$wgts)
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

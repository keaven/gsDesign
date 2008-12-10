"normalGrid" <- function(r=18, bounds=c(0, 0), mu=0, sigma=1)
{    
    checkScalar(r,"integer", c(1, 80))
    checkVector(bounds,"numeric")
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
    w <- xx[[4]][1:len] * sigma * dnorm(z, mean=mu, sd=sigma)
    
    list(z=z, wgts=w)
}

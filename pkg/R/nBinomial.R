"nBinomial"<-function(p1, p2, alpha=0.025, beta=0.1, delta0=0, ratio=1, 
                      sided=1, outtype=1, scale="Difference")
{   
    # check input arguments
    checkVector(p1, "numeric", c(0, 1), c(FALSE, FALSE))
    checkVector(p2, "numeric", c(0, 1), c(FALSE, FALSE))    
    checkScalar(sided, "integer", c(1, 2))    
    checkScalar(alpha, "numeric", c(0, 1 / sided), c(FALSE, FALSE))
    checkScalar(beta, "numeric", c(0, 1 - alpha / sided), c(FALSE, FALSE))
    checkScalar(delta0, "numeric")
    checkScalar(ratio, "numeric", c(0, Inf), c(FALSE, TRUE))
    checkScalar(outtype, "integer", c(1, 3))
    checkScalar(scale, "character")
    scale <- match.arg(tolower(scale), c("difference", "rr", "or"))
    if (p1 >= p2 + delta0)
    {
      #  stop("The condition p1 < p2 + delta0 not met")
    }
    
    # get z-values needed 
    z.beta  <- qnorm(1 - beta)    
    
    if (sided != 2)
    {
        sided <- 1
    }
        
    z.alpha <- qnorm(1 - alpha / sided)

    # sample size for risk difference - Farrington and Manning
    if (scale == "difference")
    {   
        if (delta0 == 0)
        {   
            p <- (p1 + ratio * p2) / (1 + ratio)
            sigma0 <- sqrt(p * (1 - p) / ratio) * (1 + ratio)
        }
        else
        {   
            a <- 1 + ratio
            b <- -(a + p1 + ratio * p2 - delta0 * (ratio + 2))
            c <- delta0 ^ 2 - delta0 * (2 * p1 + a) + p1 + ratio * p2
            d <- p1 * delta0 * (1 - delta0)
            v <- (b / (3 * a)) ^ 3 - b * c / 6 / a ^ 2 + d / 2 / a
            u <- sign(v) * sqrt((b / 3 / a) ^ 2 - c / 3 / a)
            w <- (pi + acos(v /u ^ 3)) / 3
            p10 <- 2 * u * cos(w) - b / 3 / a
            p20 <- p10 + delta0
            sigma0 <- sqrt((p10 * (1 - p10) + p20 * (1 - p20) / ratio) 
                            * (ratio + 1))
        }
        
        sigma1 <- sqrt((p1 * (1 - p1) + p2 * (1 - p2) / ratio) * (ratio + 1))
        n <- ((z.alpha * sigma0 + z.beta * sigma1) / (p2 - p1 - delta0)) ^ 2
        
        if (outtype == 2)
        {
            return(list(n1=n / (ratio + 1),  n2=ratio * n / (ratio + 1)))
        }
        else if (outtype == 3) 
        {   
            if( delta0 != 0)
            {
                return(list(n=n, n1=n / (ratio + 1), n2=ratio * n / (ratio + 1),
                                sigma0=sigma0, sigma1=sigma1, p1=p1 ,p2=p2, 
                                delta0=delta0, p10=p10, p20=p20))
            }
            else
            {        return(list(n=n, n1=n / (ratio + 1), n2=ratio * n / (ratio + 1),
                                sigma0=sigma0, sigma1=sigma1, p1=p1, p2=p2, pbar=p))
            }
        }
        else
        {
            return(n=n)
        }
    }

    # sample size for risk ratio - Farrington and Manning
    else if (scale == "rr")
    {   
        RR <- delta0 + 1
        
        if (delta0 == 0)
        {   
            p <- (p1 + ratio * p2) / (1 + ratio)
            sigma0 <- sqrt(p * (1 - p) / ratio) * (1 + ratio)
        }
        else
        {   
            a <- (1 + ratio) * RR
            b <- -(RR * ratio + p2 * ratio + 1 + p1 * RR)
            c <- ratio * p2 + p1
            p10 <- (-b - sqrt(b ^ 2 - 4 * a * c)) / 2 / a
            p20 <- RR * p10
            sigma0 <- sqrt((ratio + 1) * 
                            (p10 * (1 - p10) * RR ^ 2 + p20 * (1 - p20) / ratio))
        }
        sigma1 <- sqrt((ratio + 1) * 
                        (p1 * (1 - p1) * RR ^ 2 + p2 * (1 - p2) / ratio))
        n <- ((z.alpha * sigma0 + z.beta * sigma1) / (p2 - p1 * RR)) ^ 2
        
        if (outtype == 2)
        {
            return(list(n1=n / (ratio + 1), 
                            n2=ratio * n / (ratio + 1)))
        }
        else if (outtype == 3) 
        {   
            if( delta0 != 0) 
            {
                return(list(n=n, n1=n / (ratio + 1),n2=ratio * n / (ratio + 1),
                                sigma0=sigma0, sigma1=sigma1, p1=p1, p2=p2, 
                                delta0=delta0,p10=p10,p20=p20))
            }
            else
            {
                return(list(n=n, n1=n / (ratio + 1), n2=ratio * n / (ratio + 1), 
                                sigma0=sigma0, sigma1=sigma1, p1=p1, p2=p2, pbar=p))
            }
        }
        else
        {
            return(n=n)
        }
    }

    # sample size for log-odds-ratio - based on Miettinen and Nurminen max
    # likelihood estimate and asymptotic variance from, e.g., Lachin (2000)
    else
    {   
        if (delta0 == 0)
        {    
            OR <- 1
            p <- (p1 + ratio * p2) / (1 + ratio)
            sigma0 <- sqrt(1 / p / (1 - p) * (1 + 1 / ratio) * (1 + ratio))
        }
        else
        {   
            OR <- exp(delta0)
            a <- OR - 1
            b <- 1 + ratio * OR + (1 - OR) * (ratio * p2 + p1)
            c <- -(ratio * p2 + p1)
            p10 <- (-b + sqrt(b ^ 2 - 4 * a * c)) / 2 / a
            p20 <- OR * p10 / (1 + p10 * (OR - 1))
            sigma0 <- sqrt((ratio + 1) * 
                            (1 / p10 / (1 - p10) + 1 / p20 / (1 - p20) / ratio))
        }
        
        sigma1 <- sqrt((ratio + 1) * 
                        (1 / p1 / (1 - p1) + 1 / p2 / (1 - p2) / ratio))
        
        n <- ((z.alpha * sigma0 + z.beta * sigma1) / 
                    log(OR / p2 * (1 - p2) * p1 / (1 - p1))) ^ 2
        
        if (outtype == 2)
        {
            return(list(n1=n / (ratio + 1),n2=ratio * n / (ratio + 1)))
        }
        else if (outtype == 3) 
        {   
            if ( delta0 != 0)
            {
                return(list(n=n, n1=n / (ratio+1), n2=ratio * n / (ratio + 1),
                                sigma0=sigma0, sigma1=sigma1, p1=p1, p2=p2, 
                                delta0=delta0, p10=p10, p20=p20))
            }
            else 
            {
                return(list(n=n, n1=n / (ratio + 1), n2=ratio * n / (ratio + 1),
                                sigma0=sigma0, sigma1=sigma1, p1=p1, p2=p2, pbar=p))
            }
        }
        else
        {
            return(n=n)
        }
    }
}

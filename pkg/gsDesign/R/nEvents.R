"nEvents" <- function(hr = .6, alpha = .025, beta = .1, ratio = 1, sided = 1, hr0 =  1, n = 0, tbl = FALSE)
{   c <- sqrt(ratio) / (1 + ratio)
    delta <- -c * (log(hr) - log(hr0))
    if (n[1] == 0)
    {   n <- (qnorm(1-alpha)+qnorm(1-beta))^2/delta^2
        if (tbl) n <- cbind(hr, n = ceiling(n), alpha=alpha, beta=beta, Power=1-beta, delta=delta, 
                            ratio=ratio, se=sqrt(1/c/ceiling(n)))
        return(n)
    }
    else
    {   pwr <- pnorm(-(qnorm(1-alpha)-sqrt(n) * delta))
        if (tbl) pwr <- cbind(hr, n=n, alpha=alpha, beta=1-pwr, Power=pwr, delta=delta,
                 ratio=ratio, se=sqrt(1/(c*n)))
        return(pwr)
    }
}

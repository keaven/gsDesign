"nEvents" <- function(hr = .6, alpha = .025, beta = .1, ratio = 1, delta0=1, n = 0, tbl = FALSE)
{   c <- 1 / (1 + ratio)
    delta <- -c * (log(hr) - log(delta0))
    if (n == 0)
    {   n <- (qnorm(1-alpha)+qnorm(1-beta))^2/delta^2
        if (tbl) n <- cbind(hr, n = ceiling(n), alpha=alpha, Power=1-beta, delta=delta, ratio=ratio)
        return(n)
    }
    else
    {   pwr <- pnorm(-(qnorm(1-alpha)-sqrt(n) * delta))
        if (tbl) pwr <- cbind(hr, n=n, alpha=alpha, Power=pwr, delta=delta, ratio=ratio)
        return(pwr)
    }
}

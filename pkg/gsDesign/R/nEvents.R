"nEvents" <- function(hr = .6, alpha = .025, beta = .1, ratio = 1, sided = 1, hr0 =  1, n = 0, tbl = FALSE)
{   if (sided != 1 && sided != 2) stop("sided must be 1 or 2")
    c <- sqrt(ratio) / (1 + ratio)
    delta <- -c * (log(hr) - log(hr0))
    if (n[1] == 0)
    {   n <- (qnorm(1-alpha/sided)+qnorm(1-beta))^2/delta^2
        if (tbl) n <- data.frame(cbind(hr = hr, n = ceiling(n), alpha = alpha,
									 sided=sided, beta = beta, 
                            Power = 1-beta, delta = delta, ratio = ratio, 
                            hr0 = hr0, se = 1/c/sqrt(ceiling(n))))
        return(n)
    }
    else
    {   pwr <- pnorm(-(qnorm(1-alpha/sided)-sqrt(n) * delta))
        if (tbl) pwr <- data.frame(cbind(hr = hr, n = n, alpha = alpha,
									 sided=sided, beta = 1-pwr,
                            Power = pwr, delta = delta, ratio = ratio,
                            hr0 = hr0, se = sqrt(1/n)/c))
        return(pwr)
    }
}
"zn2hr" <- function (z, n , ratio = 1, hr0=1, hr1=.7) 
{   c <- 1/(1 + ratio)
    psi <- c * (1 - c)
    exp(z * sign(hr1-hr0)/sqrt(n * psi)) * hr0
}
"hrn2z" <- function(hr, n, ratio=1, hr0=1, hr1=.7)
{   c <- 1/(1 + ratio)
    psi <- c * (1 - c)
    log(hr/hr0) * sqrt(n * psi) * sign(hr0-hr1)
}
"hrz2n" <- function(hr, z, ratio=1, hr0=1)
{   c <- 1 / (1 + ratio)
    psi <- c * (1 - c)
    (z / log(hr/hr0))^2 / psi
}

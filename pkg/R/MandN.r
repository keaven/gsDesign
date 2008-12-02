"simBinomial"<-function(p1, p2, n1, n2, delta0=0, nsim=10000, chisq=0, adj=0, 
                        scale="Difference")
{
    x1 <- rbinom(p=p1, size=n1, n=nsim)
    x2 <- rbinom(p=p2, size=n2, n=nsim)
    return(testBinomial(x1=x1, x2=x2, n1=n1, n2=n2, delta0=delta0, adj=adj,
           chisq=chisq, scale=scale))
}
"ciBinomial"<-function(x1, x2, n1, n2, alpha=.05, adj=0, scale="Difference")
{
    if (scale == "Difference")
    {    delta <- x1 / n1 - x2 / n2
         if (delta == -1) lower <- -1
         else if (testBinomial(delta0=-.9999, x1=x1, x2=x2, n1=n1, n2=n2, adj=adj)
                     < qnorm(alpha / 2)) lower <- -1
         else lower <- uniroot(bpdiff, interval=c(-.9999, delta), x1=x1, x2=x2,
                               n1=n1, n2=n2, adj=adj, alpha=alpha)$root
         if (delta == 1) upper <- 1
         else if (testBinomial(delta0=.9999, x1=x1, x2=x2, n1=n1, n2=n2, adj=adj)
                     > -qnorm(alpha/2)) upper<-1
         else upper <- uniroot(bpdiff, interval=c(delta,.9999), lower.tail=TRUE,
                               x1=x1, x2=x2, n1=n1, n2=n2, adj=adj,
                               alpha=alpha)$root
         return(list(lower=lower,upper=upper))
    }
#   else if (scale=="RR")
#   {   if (x1 + x2 == 0) return(list(lower=NA, upper=NA))
#       if (x2 == 0) upper <- NA
#       else if (testBinomial(delta0=1000, x1=x1, x2=x2, n1=n1, n2=n2, adj=adj)
#
#   }
    else
    {
        return("Difference scale is currently the only option implemented")
    }
}
"bpdiff"<-function(delta, x1, x2, n1, n2, alpha=.05, adj=0, scale="Difference",
                   lower.tail=FALSE)
{
    return(pnorm(testBinomial(x1, x2, n1, n2, delta0=delta, adj=adj, scale=scale),
                              lower.tail=lower.tail) - alpha / 2 )
}

"testBinomial"<-function(x1, x2, n1, n2, delta0=0, chisq=0, adj=0,
                       scale="Difference",tol=.1e-10)
{
    ntot <- n1 + n2
    xtot <- x1 + x2
    # risk difference test - from Miettinen and Nurminen eqn (9)
    if (scale == "Difference")
    {   L2 <- (n2 + 2 * n1) * delta0 - ntot - xtot
        L1 <- (n1 * delta0 - ntot - 2 * x1) * delta0 + xtot
        L0 <- x1 * delta0 * (1 - delta0)
        p  <- sqrt((L2 / (3 * ntot)) ^ 2 - L1 / (3 * ntot))
        q  <- (L2 / (3 * ntot)) ^ 3 - L1 * L2 / 6 / ntot ^ 2 + L0 / 2 / ntot
        a  <- q / p ^ 3
        a[a > 1] <- 1
        a  <- (pi + acos(a)) / 3
        R0 <- 2 * p * cos(a) - L2 / 3 / ntot
        R1 <- R0 + delta0
        V  <- (R1 * (1 - R1) / n2 + R0 * (1 - R0) / n1)
        # V=0 only if no or all events and delta0=0
        # in which case test statistic will be 0 
        V[V <= tol] <- 1
        # compute z-statistic
        z <- x1 / n1 - x2 / n2 - delta0
    }
    # relative risk test - from Miettinen and Nurminen eqn (10)
    else if (scale=="RR")
    {   delta0 <- delta0 + 1 # value of 0 input represents equal rates
        A  <- delta0 * ntot
        B  <- -(n2 * delta0 + x2 + n1 + x1 * delta0)
        C  <- xtot
        R0 <- ( - B - sqrt(B ^ 2 - 4 * A * C)) / 2 / A
        R1 <- R0 * delta0
        V  <- R1 * (1 - R1) / n2 + delta0 ^ 2 * R0 * (1 - R0) / n1
        # V=0 only if no events or (all events and delta0=1)
        # in which case test statistic will be 0
        V[V <= 0 || is.na(V)] <- 1
        z <- x2 / n2 - x1 / n1 * delta0
    }
    # odds-ratio and log-odds-ratio
    else
    {   delta0 <- exp(delta0) # change from log odds-ratio to odds-ratio
        A <- n1 * (delta0 - 1)
        B < -n2 * delta0 + n1 - xtot * (delta0 - 1)
        C <- -xtot
        R0 <- ( - B + sqrt(B ^ 2 - 4 * A * C)) / 2 / A
        R1 <- R0 * delta0 / (1 + R0 * (delta0 - 1))
        # next 2 lines deal with length(delta0)>length(xtot) or length(ntot)
        xtem <- (delta0 == delta0) * xtot
        ntem<-(delta0==delta0)*ntot
        R0[delta0 == 1] <- xtem[delta0 == 1] / ntem[delta0 == 1]
        R1[delta0 == 1] <- R0[delta0 == 1]
        # odds-ratio test - from Miettinen and Nurminen eqn (13)
        if (scale == "OR")
        {   V <- 1 / (1 / n2 / R1 / (1-R1) + 1 / n1 / R0 / (1 - R0))
            V[xtot == 0 || xtot == ntot] <- 1
            z <- x2 * (x2 / n2 - R1)
        }
        # log-odds ratio - based on asymptotic distribution of log-odds
        # see vignette
        else
        {   V <- 1 / n2 / R1 / (1-R1) + 1 / n1 / R0 / (1-R0)
            V[xtot == 0 || xtot == ntot] <- 1
            z <- log(x2 / (n2 - x2) / x1 * (n1 - x1)) - delta0
            z[xtot == 0 || xtot == ntot] <- 0
            z[xtot > 0 && xtot < ntot] <- z[xtot > 0 && xtot < ntot]
    }   }
    # do continuity correction, where required
    one <- array(TRUE, max(length(V), length(adj)))
    adj <- (adj==1) & one
    V[adj] <- V[adj] * ntot / (ntot - 1)
    # square z where required to get chi-square
    one <- array(TRUE, max(length(z), length(chisq)))
    chisq <- chisq & one
    if (length(z) == 1) z <- z * one
    z[chisq] <- z[chisq] ^ 2 / V[chisq]
    z[ ! chisq] <- z[ ! chisq] / sqrt(V[ ! chisq])
    return(z)
}

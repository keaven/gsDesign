"WTdiff" <- function(c, alpha, a, b, timing, r)
{	
    # Wang-Tsiatis boundary alpha comparison
    # for a timing vector, scalar a, and vector b, 
    # compute upper crossing probability using upper bound of c*b
    # a is used to control one- or 2-sided bound
    
    if (length(a) == 1)
    {
        a <- -c * b
    }
	x <- gsprob(0., timing, a, c * b, r)
	
    alpha - sum(x$probhi)
}

"WT" <- function(d, alpha, a, timing, tol, r)
{	
    # Wang-Tsiatis boundary
    # find constant for a Wang-Tsiatis bound to get appropriate alpha
    # for 2-sided, a=1 (set in gsDType2and5); otherwise, a set in gsDType1
    b <- timing^(d - 0.5)
	i <- 0
	
    while (WTdiff(2^i, alpha, a, b, timing, r) >= 0.)
    {
        i <- i - 1
    }
	
    c0 <- 2^i
	i <- 2
    
	while (WTdiff(i, alpha, a, b, timing, r) <= 0.)
    {
        i <- i + 1
    }
    
	c1 <- i
	
    uniroot(WTdiff, lower=c0, upper=c1, alpha=alpha, a=a, b=b, timing=timing, tol=tol, r=r)$root
}


##################################################################################
#  Wang-Tsiatis functionality for the gsDesign package
#
#  Exported Functions:
#                   
#    (none)
#
#  Hidden Functions:
#
#    WT
#    WTdiff
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

###
# Hidden Functions
###

"WT" <- function(d, alpha, a, timing, tol=0.000001, r=18)
{   
    # Wang-Tsiatis boundary
    # find constant for a Wang-Tsiatis bound to get appropriate alpha
    # for 2-sided,  a=1 (set in gsDType2and5); otherwise,  a set in gsDType1
    
    b <- timing^(d - .5)
    
    if (length(a) == 1)
    {
        c0 <- 0
    }
    else
    {   
        i <- 0
        
        while (WTdiff(i, alpha, a, b, timing, r) >= 0.)
        {
            i <- i-1
        }
        
        c0 <- i
    }
    
    i <- 2
    
    while(WTdiff(i, alpha, a, b, timing, r) <= 0.)
    {
        i <- i + 1
    }
    
    c1 <- i
    
    uniroot(WTdiff, lower=c0, upper=c1, alpha=alpha, a=a, b=b, timing=timing, tol=tol, r=r)$root
}

"WTdiff" <- function(c, alpha, a, b, timing, r)
{   
    # Wang-Tsiatis boundary alpha comparison
    # for a timing vector,  scalar a,  and vector b,  
    # compute upper crossing probability using upper bound of c*b
    # a is used to control one- or 2-sided bound    
    
    if (length(a) == 1)
    {
        a <- -c * b
    }
    
    x <- gsProbability(k=length(b), theta=0., n.I=timing, a=a, b=c * b, r=r)
    
    alpha - sum(x$upper$prob)
}


# check numerical results for testBinomial

"test.testBinomial.numerics" <- function()
{       
    checkEqualsNumeric(target=c(1.959962, -1.959865), 
            current=testBinomial(x1=0, x2=0, n1=10, n2=20, adj=1, 
                    scale="difference", delta=c(-.1658, .2843608)),
            msg="Error in testBinomial example 1 (M&N example 4)",
            tolerance=.0005)
    
    checkEqualsNumeric(target=c(1.96, -1.96), 
            current=testBinomial(x1=10, x2=20, n1=10, n2=20, adj=1, 
                    scale="rr", delta=log(c(.715615, 1.198703))),
            msg="Error in testBinomial example 2 (M&N example 6)",
            tolerance=.0005)
    
    checkEqualsNumeric(target=c(1.964856, -1.963414), 
            current=testBinomial(x1=53, x2=40, n1=100, n2=100,  
                    scale="LNOR", delta=c(-0.03152, 1.104)),
            msg="Error in testBinomial example 3 (p 27, Lachin)",
            tolerance=.0005)
    
    checkEqualsNumeric(target=c(1.965205, -1.96461), 
            current=testBinomial(x1=53, x2=40, n1=100, n2=100,  
                    scale="OR", delta=c(-0.03463, 1.085673)),
            msg="Error in testBinomial example 4 (p 27, Lachin)",
            tolerance=.0005)
}

# checks for -Inf and Inf results for ciBinomial with scale="OR"

"test.ciBinomial.ORscale.Infinity" <- function()
{      
    checkEquals(target=-Inf,
            current=ciBinomial(scale="OR", x1=0, x2=4, n1=100, n2=100)$lower,
            msg="ciBinomial infinity check #1 failed")
    checkEquals(target=Inf,
            current=ciBinomial(scale="OR", x1=4, x2=0, n1=100, n2=100)$upper,
            msg="ciBinomial infinity check #2 failed")
    checkEquals(target=Inf,
            current=ciBinomial(scale="OR", x1=100, x2=96, n1=100, n2=100)$upper,
            msg="ciBinomial infinity check #3 failed")
    checkEquals(target=-Inf,
            current=ciBinomial(scale="OR", x1=96, x2=100, n1=100, n2=100)$lower,
            msg="ciBinomial infinity check #4 failed")
# changed targe to data.frame; KA 2013/11/02
    checkEquals(target=data.frame(lower=-Inf, upper=Inf),
            current=ciBinomial(scale="OR", x1=0, x2=0, n1=100, n2=100),
            msg="ciBinomial infinity check #5 failed")
# changed targe to data.frame; KA 2013/11/02
    checkEquals(target=data.frame(lower=-Inf, upper=Inf),
            current=ciBinomial(scale="OR", x1=100, x2=100, n1=100, n2=100),
            msg="ciBinomial infinity check #6 failed")
}

# checks for Inf results for ciBinomial with scale="RR"

"test.ciBinomial.RRscale.Infinity" <- function()
{
    checkEquals(target=Inf,
            current=ciBinomial(scale="RR", x1=4, x2=0, n1=100, n2=100)$upper,
            msg="ciBinomial infinity check #7 failed")
    
    checkEquals(target=Inf,
            current=ciBinomial(scale="RR", x1=0, x2=0, n1=100, n2=100)$upper,
            msg="ciBinomial infinity check #8 failed")
}

# Other checks for ciBinomial

"test.ciBinomial.misc" <- function()
{
    checkEqualsNumeric(tolerance=.0001, target=c(-.1658, .2843608),
            current=as.numeric(ciBinomial(x1=0, x2=0, n1=10, n2=20, adj=1, 
                            scale="difference")),
            msg="ciBinomial numeric check #1 failed (M&N example 4")
    
# the following is from www.statsdirect.com/help/miscellaneous/rr.htm
    checkEqualsNumeric(tolerance=.0005, target=c(.0344, .0868),
            current=as.numeric(ciBinomial(x1=72, x2=20, n1=756, n2=573, adj=1,
                            scale="difference")),
            msg="ciBinomial numeric check #2 failed")
    
    checkEqualsNumeric(tolerance=.0001, target=c(.7156205, 1.198696),
            current=as.numeric(ciBinomial(x1=10, x2=20, n1=10, n2=20, adj=1, 
                            scale="rr")),
            msg="ciBinomial numeric check #3 failed (M&N example 6")
}

# nBinomial checks  

"test.nBinomial.misc" <- function()
{  
    checkEqualsNumeric(tolerance=.01, target=159.6876,
            current=nBinomial(p1=.4, p2=.05, alpha=.05, beta=.2, delta0=.2,
                    scale="difference"),
            msg="nBinomial check #1 failed (F&M, bottom p 1451)")
    
    checkEqualsNumeric(tolerance=.01, target=c(62.88,41.92),
            current=as.numeric(nBinomial(p1=.1, p2=.1, alpha=.05, delta0=-.2, 
                            ratio=2 / 3, scale="difference", outtype=2)),
            msg="nBinomial check #2 failed (F&M, Table 1)")
    
    checkEqualsNumeric(tolerance=.01, target=c(173.2214, 259.8322),
            current=as.numeric(nBinomial(p1=.25, p2=.05, delta0=.1, alpha=.05,
                            ratio=3/2, scale="difference", outtype=2)),
            msg="nBinomial check #3 failed (F&M, Table 1)")
    
    checkEqualsNumeric(tolerance=.01, target=c(133.9289, 200.8933),
            current=as.numeric(nBinomial(p1=.25, p2=.05, delta0=log(2), alpha=.05, 
                            ratio=3 / 2, scale="rr", outtype=2)),
            msg="nBinomial check #4 failed (F&M, Table 1)")
    
    checkEqualsNumeric(tolerance=.01, target=1355.84,
            current=nBinomial(p1=.15, p2=.1, beta=.2, scale="or"),
            msg="nBinomial check #5 failed (OR scale)")
    
    checkEqualsNumeric(tolerance=.01, target=c(900.57, 1350.85),
            current=as.numeric(nBinomial(p1=.15, p2=.1, beta=.2, delta0=log(1.1), 
                            ratio=3 / 2, scale="or", outtype=2)),
            msg="nBinomial check #6 failed (OR scale)")
}

# checks for simBinomial

"test.simBinomial.misc" <- function()
{  
    checkEqualsNumeric(tolerance=.01, target=.813,
            current=sum(-qnorm(.05) < simBinomial(p1=.4, p2=.05, delta0=.2,
                            n1=80, n2=80, nsim=100000))/100000,
            msg="simBinomial check #1 failed (F&M bottom p 1451)")
    
    checkEqualsNumeric(tolerance=.01, target=.916,
            current=sum(-qnorm(.05) < simBinomial(p1=.1, p2=.1, delta0=-.2,
                            n1=63, n2=42, nsim=100000))/100000,
            msg="simBinomial check #2 failed (F&M Table 1)")
    
    checkEqualsNumeric(tolerance=.01, target=.906,
            current=sum(-qnorm(.05) < simBinomial(p1=.25, p2=.05, delta0=.1,
                            n1=173, n2=260, nsim=100000))/100000,
            msg="simBinomial check #3 failed (F&M Table 1)")
    
    checkEqualsNumeric(tolerance=.01, target=.79875,
            current=sum(-qnorm(.025) < simBinomial(p1=.15, p2=.1, delta0=log(1.1),
                            n1=901, n2=1351, scale="lnor", nsim=100000))/100000,
            msg="simBinomial check #4 failed")
    
    checkEqualsNumeric(tolerance=.01, target=.8056,
            current=sum(-qnorm(.025) < simBinomial(p1=.15, p2=.1, delta0=log(1.1),
                            n1=901, n2=1351, scale="or", nsim=100000))/100000,
            msg="simBinomial check #5 failed")
    
    checkEqualsNumeric(tolerance=.01, target=.9078,
            current=sum(-qnorm(.05) < simBinomial(p1=.25, p2=.05, delta0=log(2),
                            n1=134, n2=201, scale="rr", nsim=100000))/100000,
            msg="simBinomial check #6 failed (F&M Table 1)")
}


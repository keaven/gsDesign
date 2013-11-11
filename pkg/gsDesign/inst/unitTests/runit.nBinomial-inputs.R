# nBinomial test functions

"test.nBinomial.p1" <- function()
{
	 checkException(nBinomial(p1="abc", p2=0.1), msg="Checking for incorrect variable type", silent=TRUE) 
	 checkException(nBinomial(p1=0, p2=0.1), msg="Checking for out-of-range variable value", silent=TRUE) 
	 checkException(nBinomial(p1=1, p2=0.1), msg="Checking for out-of-range variable value", silent=TRUE) 
}

"test.nBinomial.p2" <- function()
{
	 checkException(nBinomial(p2="abc", p1=0.1), msg="Checking for incorrect variable type", silent=TRUE) 
	 checkException(nBinomial(p2=0, p1=0.1), msg="Checking for out-of-range variable value", silent=TRUE) 
	 checkException(nBinomial(p2=1, p1=0.1), msg="Checking for out-of-range variable value", silent=TRUE) 
}

"test.nBinomial.alpha" <- function()
{
	 checkException(nBinomial(alpha="abc", p1=0.1, p2=0.2), msg="Checking for incorrect variable type", silent=TRUE) 
	 checkException(nBinomial(alpha=1, p1=0.1, p2=0.2, sided=1), msg="Checking for out-of-range variable value", silent=TRUE) 
	 checkException(nBinomial(alpha=0.5, p1=0.1, p2=0.2, sided=2), msg="Checking for out-of-range variable value", silent=TRUE) 
	 checkException(nBinomial(alpha=0, p1=0.1, p2=0.2, sided=2), msg="Checking for out-of-range variable value", silent=TRUE) 
	 checkException(nBinomial(alpha=rep(0.1,2), p1=0.1, p2=0.2), msg="Checking for incorrect variable length", silent=TRUE) 
}

"test.nBinomial.beta" <- function()
{
	 checkException(nBinomial(beta="abc", p1=0.1, p2=0.2), msg="Checking for incorrect variable type", silent=TRUE) 
	 checkException(nBinomial(beta=0.7, p1=0.1, p2=0.2, sided=1, alpha=0.3), msg="Checking for out-of-range variable value", silent=TRUE) 
	 checkException(nBinomial(beta=0, p1=0.1, p2=0.2), msg="Checking for out-of-range variable value", silent=TRUE) 
	 checkException(nBinomial(beta=rep(0.1,2), p1=0.1, p2=rep(0.2, 3)), msg="Checking for incorrect variable length", silent=TRUE) 
}

"test.nBinomial.delta0" <- function()
{
	 checkException(nBinomial(delta0="abc", p1=0.1, p2=0.2), msg="Checking for incorrect variable type", silent=TRUE) 
	 checkException(nBinomial(delta0=0, p1=0.1, p2=0.1), msg="Checking for out-of-range variable value", silent=TRUE) 
	 checkException(nBinomial(delta0=0.1, p1=0.2, p2=0.1), msg="Checking for out-of-range variable value", silent=TRUE) 
}

"test.nBinomial.ratio" <- function()
{
	 checkException(nBinomial(ratio="abc", p1=0.1, p2=0.2), msg="Checking for incorrect variable type", silent=TRUE) 
	 checkException(nBinomial(ratio=0, p1=0.1, p2=0.2), msg="Checking for out-of-range variable value", silent=TRUE) 
	 checkException(nBinomial(ratio=rep(0.5,2), p1=0.1, p2=rep(0.2, 3)), msg="Checking for incorrect variable length", silent=TRUE) 
}

"test.nBinomial.sided" <- function()
{
	 checkException(nBinomial(sided="abc", p1=0.1, p2=0.2), msg="Checking for incorrect variable type", silent=TRUE) 
	 checkException(nBinomial(sided=0, p1=0.1, p2=0.2), msg="Checking for out-of-range variable value", silent=TRUE) 
	 checkException(nBinomial(sided=3, p1=0.1, p2=0.2), msg="Checking for out-of-range variable value", silent=TRUE) 
	 checkException(nBinomial(sided=rep(1,2), p1=0.1, p2=0.2), msg="Checking for incorrect variable length", silent=TRUE) 
}

"test.nBinomial.outtype" <- function()
{
	 checkException(nBinomial(outtype="abc", p1=0.1, p2=0.2), msg="Checking for incorrect variable type", silent=TRUE) 
	 checkException(nBinomial(outtype=0, p1=0.1, p2=0.2), msg="Checking for out-of-range variable value", silent=TRUE) 
	 checkException(nBinomial(outtype=4, p1=0.1, p2=0.2), msg="Checking for out-of-range variable value", silent=TRUE) 
	 checkException(nBinomial(outtype=rep(1,2), p1=0.1, p2=0.2), msg="Checking for incorrect variable length", silent=TRUE) 
}

"test.nBinomial.scale" <- function()
{
	 checkException(nBinomial(scale=1, p1=0.1, p2=0.2), msg="Checking for incorrect variable type", silent=TRUE) 
	 checkException(nBinomial(scale="abc", p1=0.1, p2=0.2), msg="Checking for out-of-range variable value", silent=TRUE) 
	 checkException(nBinomial(scale=rep("RR",2), p1=0.1, p2=0.2), msg="Checking for incorrect variable length", silent=TRUE) 
}


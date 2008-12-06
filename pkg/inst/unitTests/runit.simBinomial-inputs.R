# simBinomial test functions

"test.simBinomial.p1" <- function()
{
	 checkException(simBinomial(p1="abc", p2=0.1, n1=1, n2=1, msg="Checking for incorrect variable type", silent=TRUE)) 
	 checkException(simBinomial(p1=0, p2=0.1, n1=1, n2=1, msg="Checking for out-of-range variable value", silent=TRUE)) 
	 checkException(simBinomial(p1=1, p2=0.1, n1=1, n2=1, msg="Checking for out-of-range variable value", silent=TRUE)) 
	 checkException(simBinomial(p1=rep(1,2), p2=0.1, n1=1, n2=1, msg="Checking for incorrect variable length", silent=TRUE)) 
}

"test.simBinomial.p2" <- function()
{
	 checkException(simBinomial(p2="abc", p1=0.1, n1=1, n2=1, msg="Checking for incorrect variable type", silent=TRUE)) 
	 checkException(simBinomial(p2=0, p1=0.1, n1=1, n2=1, msg="Checking for out-of-range variable value", silent=TRUE)) 
	 checkException(simBinomial(p2=1, p1=0.1, n1=1, n2=1, msg="Checking for out-of-range variable value", silent=TRUE)) 
	 checkException(simBinomial(p2=rep(1,2), p1=0.1, n1=1, n2=1, msg="Checking for incorrect variable length", silent=TRUE)) 
	 checkException(simBinomial(p2=0.1, p1=0.1, n1=1, n2=1, msg="Checking for out-of-range variable value", silent=TRUE)) 
}

"test.simBinomial.n1" <- function()
{
	 checkException(simBinomial(n1="abc", p1=0.1, p2=0.2, n2=1, msg="Checking for incorrect variable type", silent=TRUE)) 
	 checkException(simBinomial(n1=rep(1,2), p1=0.1, p2=0.2, n2=1, msg="Checking for incorrect variable length", silent=TRUE)) 
}

"test.simBinomial.n2" <- function()
{
	 checkException(simBinomial(n2="abc", p1=0.1, p2=0.2, n1=1, msg="Checking for incorrect variable type", silent=TRUE)) 
	 checkException(simBinomial(n2=rep(1,2), p1=0.1, p2=0.2, n1=1, msg="Checking for incorrect variable length", silent=TRUE)) 
}

"test.simBinomial.delta0" <- function()
{
	 checkException(simBinomial(delta0="abc", p1=0.1, p2=0.2, n1=1, n2=1, msg="Checking for incorrect variable type", silent=TRUE)) 
	 checkException(simBinomial(delta0=rep(0.1,2), p1=0.1, p2=0.2, n1=1, n2=1, msg="Checking for incorrect variable length", silent=TRUE)) 
}

"test.simBinomial.nsim" <- function()
{
	 checkException(simBinomial(nsim="abc", p1=0.1, p2=0.2, n1=1, n2=1, msg="Checking for incorrect variable type", silent=TRUE)) 
	 checkException(simBinomial(nsim=0, p1=0.1, p2=0.2, n1=1, n2=1, msg="Checking for out-of-range variable value", silent=TRUE)) 
}

"test.simBinomial.scale" <- function()
{
	 checkException(simBinomial(scale=1, p1=0.1, p2=0.2, n1=1, n2=1, msg="Checking for incorrect variable type", silent=TRUE)) 
	 checkException(simBinomial(scale="abc", p1=0.1, p2=0.2, n1=1, n2=1, msg="Checking for out-of-range variable value", silent=TRUE)) 
	 checkException(simBinomial(scale=rep("RR",2), p1=0.1, p2=0.2, n1=1, n2=1, msg="Checking for incorrect variable length", silent=TRUE)) 
}


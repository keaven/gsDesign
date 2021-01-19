# gsProbability test functions

"test.gsProbability.k" <- function()
{
	 checkException(gsProbability(k="abc"), msg="Checking for incorrect variable type", silent=TRUE) 
	 checkException(gsProbability(k=-1), msg="Checking for out-of-range variable value", silent=TRUE) 
	 checkException(gsProbability(k=1, d=gsDesign()), msg="Checking for out-of-range variable value", silent=TRUE) 
	 checkException(gsProbability(k=31), msg="Checking for out-of-range variable value", silent=TRUE) 
	 checkException(gsProbability(k=seq(2)), msg="Checking for incorrect variable length", silent=TRUE) 
}

"test.gsProbability.theta" <- function()
{
	 checkException(gsProbability(theta="abc"), msg="Checking for incorrect variable type", silent=TRUE) 
}

"test.gsProbability.n.I" <- function()
{
	 checkException(gsProbability(n.I="abc"), msg="Checking for incorrect variable type", silent=TRUE) 
	 checkException(gsProbability(n.I=0), msg="Checking for out-of-range variable value", silent=TRUE) 
	 checkException(gsProbability(n.I=c(2, 1)), msg="Checking for out-of-order input sequence", silent=TRUE) 
	 checkException(gsProbability(n.I=c(1, 2), k=3), msg="Checking for incorrect variable length", silent=TRUE) 
}

"test.gsProbability.a" <- function()
{
	 checkException(gsProbability(a="abc"), msg="Checking for incorrect variable type", silent=TRUE) 
	 checkException(gsProbability(a=c(1, 2), k=3), msg="Checking for incorrect variable length", silent=TRUE) 
}

"test.gsProbability.b" <- function()
{
	 checkException(gsProbability(b="abc"), msg="Checking for incorrect variable type", silent=TRUE) 
	 checkException(gsProbability(b=c(1, 2), k=3), msg="Checking for incorrect variable length", silent=TRUE) 
}

"test.gsProbability.r" <- function()
{
	 checkException(gsProbability(r="abc"), msg="Checking for incorrect variable type", silent=TRUE) 
	 checkException(gsProbability(r=0), msg="Checking for out-of-range variable value", silent=TRUE) 
	 checkException(gsProbability(r=81), msg="Checking for out-of-range variable value", silent=TRUE) 
	 checkException(gsProbability(r=rep(1,2)), msg="Checking for incorrect variable length", silent=TRUE) 
}


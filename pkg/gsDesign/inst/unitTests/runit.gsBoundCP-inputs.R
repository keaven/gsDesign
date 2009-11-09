# gsBoundCP test functions

"test.gsBoundCP.x" <- function()
{
	 checkException(gsBoundCP(x="abc"), msg="Checking for incorrect variable type", silent=TRUE) 
}

"test.gsBoundCP.theta" <- function()
{
	 checkException(gsBoundCP(theta="abc"), msg="Checking for incorrect variable type", silent=TRUE) 
	 checkException(gsBoundCP(theta=rep(1,2)), msg="Checking for incorrect variable length", silent=TRUE) 
}

"test.gsBoundCP.r" <- function()
{
	 checkException(gsBoundCP(r="abc"), msg="Checking for incorrect variable type", silent=TRUE) 
	 checkException(gsBoundCP(r=0), msg="Checking for out-of-range variable value", silent=TRUE) 
	 checkException(gsBoundCP(r=81), msg="Checking for out-of-range variable value", silent=TRUE) 
	 checkException(gsBoundCP(r=rep(1,2)), msg="Checking for incorrect variable length", silent=TRUE) 
}


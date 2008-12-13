# gsCP test functions

"test.gsCP.x" <- function()
{
	 checkException(gsCP(x="abc"), msg="Checking for incorrect variable type", silent=TRUE) 
}

"test.gsCP.r" <- function()
{
	 checkException(gsCP(r="abc"), msg="Checking for incorrect variable type", silent=TRUE) 
	 checkException(gsCP(r=0), msg="Checking for out-of-range variable value", silent=TRUE) 
	 checkException(gsCP(r=81), msg="Checking for out-of-range variable value", silent=TRUE) 
	 checkException(gsCP(r=rep(1,2)), msg="Checking for incorrect variable length", silent=TRUE) 
}


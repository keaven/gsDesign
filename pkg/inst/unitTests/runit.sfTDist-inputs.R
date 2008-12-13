# sfTDist test functions

"test.sfTDist.param " <- function()
{
	 checkException(sfTDist(param ="abc"), msg="Checking for incorrect variable type", silent=TRUE) 
}

"test.sfTDist.param" <- function()
{
	 checkException(sfTDist(param=rep(1,4)), msg="Checking for incorrect variable length", silent=TRUE) 
	 checkException(sfTDist(param=c(1, 0, 1)), msg="Checking for out-of-range variable value", silent=TRUE) 
	 checkException(sfTDist(param=c(1, 1, 0.5)), msg="Checking for out-of-range variable value", silent=TRUE) 
	 checkException(sfTDist(param=1,1:3/4,c(.25,.5,.75,.1,.2,.3)), msg="Checking for out-of-range variable value", silent=TRUE) 
}


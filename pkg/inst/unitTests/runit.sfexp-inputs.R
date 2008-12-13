# sfexp test functions

"test.sfexp.param" <- function()
{
	 checkException(sfexp(param="abc"), msg="Checking for incorrect variable type", silent=TRUE) 
	 checkException(sfexp(param=rep(1,2)), msg="Checking for incorrect variable length", silent=TRUE) 
	 checkException(sfexp(param=0), msg="Checking for out-of-range variable value", silent=TRUE) 
	 checkException(sfexp(param=11), msg="Checking for out-of-range variable value", silent=TRUE) 
}


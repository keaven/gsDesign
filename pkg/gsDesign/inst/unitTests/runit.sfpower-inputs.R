# sfpower test functions

"test.sfpower.param" <- function()
{
	 checkException(sfpower(param="abc"), msg="Checking for incorrect variable type", silent=TRUE) 
	 checkException(sfpower(param=rep(1,2)), msg="Checking for incorrect variable length", silent=TRUE) 
	 checkException(sfpower(param=-1), msg="Checking for out-of-range variable value", silent=TRUE) 
}


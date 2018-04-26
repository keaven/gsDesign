# sfHSD test functions

"test.sfHSD.param" <- function()
{
	 checkException(sfHSD(param="abc"), msg="Checking for incorrect variable type", silent=TRUE) 
	 checkException(sfHSD(param=rep(1,2)), msg="Checking for incorrect variable length", silent=TRUE) 
	 checkException(sfHSD(param=-41), msg="Checking for out-of-range variable value", silent=TRUE) 
	 checkException(sfHSD(param=41), msg="Checking for out-of-range variable value", silent=TRUE) 
}


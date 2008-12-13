# sflogistic test functions

"test.sflogistic.param " <- function()
{
	 checkException(sflogistic(param ="abc"), msg="Checking for incorrect variable type", silent=TRUE) 
	 checkException(sflogistic(param =c(1, 0)), msg="Checking for out-of-range variable value", silent=TRUE) 
}

"test.sflogistic.param" <- function()
{
	 checkException(sflogistic(param=rep(1,3)), msg="Checking for incorrect variable length", silent=TRUE) 
	 checkException(sflogistic(param=c(.1, .6, .2, .05), k=5, timing=c(.1, .25, .4, .6)), msg="Checking for out-of-order input sequence", silent=TRUE) 
}


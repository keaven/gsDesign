# normalGrid test functions

"test.normalGrid.r" <- function()
{
	 checkException(normalGrid(r="abc"), msg="Checking for incorrect variable type", silent=TRUE) 
	 checkException(normalGrid(r=0), msg="Checking for out-of-range variable value", silent=TRUE) 
	 checkException(normalGrid(r=81), msg="Checking for out-of-range variable value", silent=TRUE) 
	 checkException(normalGrid(r=rep(1,2)), msg="Checking for incorrect variable length", silent=TRUE) 
}

"test.normalGrid.bounds" <- function()
{
	 checkException(normalGrid(bounds="abc"), msg="Checking for incorrect variable type", silent=TRUE) 
	 checkException(normalGrid(bounds=0), msg="Checking for out-of-range variable value", silent=TRUE) 
	 checkException(normalGrid(bounds=c(2)), msg="Checking for incorrect variable length", silent=TRUE) 
}

"test.normalGrid.mu" <- function()
{
	 checkException(normalGrid(mu="abc"), msg="Checking for incorrect variable type", silent=TRUE) 
	 checkException(normalGrid(mu=rep(1,2)), msg="Checking for incorrect variable length", silent=TRUE) 
}

"test.normalGrid.sigma" <- function()
{
	 checkException(normalGrid(sigma="abc"), msg="Checking for incorrect variable type", silent=TRUE) 
	 checkException(normalGrid(sigma=0), msg="Checking for out-of-range variable value", silent=TRUE) 
	 checkException(normalGrid(sigma=rep(1,2)), msg="Checking for incorrect variable length", silent=TRUE) 
}


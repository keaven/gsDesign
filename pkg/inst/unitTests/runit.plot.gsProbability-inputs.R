# plot.gsProbability test functions

"test.plot.gsProbability.plottype" <- function()
{
	 checkException(plot.gsProbability(plottype="abc"), msg="Checking for incorrect variable type", silent=TRUE) 
	 checkException(plot.gsProbability(plottype=0), msg="Checking for out-of-range variable value", silent=TRUE) 
	 checkException(plot.gsProbability(plottype=8), msg="Checking for out-of-range variable value", silent=TRUE) 
	 checkException(plot.gsProbability(plottype=rep(2,2)), msg="Checking for incorrect variable length", silent=TRUE) 
}


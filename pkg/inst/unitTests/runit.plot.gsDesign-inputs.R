# plot.gsDesign test functions

"test.plot.gsDesign.plottype" <- function()
{
	 checkException(plot.gsDesign(plottype="abc"), msg="Checking for incorrect variable type", silent=TRUE) 
	 checkException(plot.gsDesign(plottype=0), msg="Checking for out-of-range variable value", silent=TRUE) 
	 checkException(plot.gsDesign(plottype=8), msg="Checking for out-of-range variable value", silent=TRUE) 
	 checkException(plot.gsDesign(plottype=rep(2,2)), msg="Checking for incorrect variable length", silent=TRUE) 
}


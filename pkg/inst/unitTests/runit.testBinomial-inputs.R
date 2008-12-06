# testBinomial test functions

"test.testBinomial.x1" <- function()
{
	 checkException(testBinomial(x1="abc", x2=2, n1=2, n2=2, msg="Checking for incorrect variable type", silent=TRUE)) 
	 checkException(testBinomial(x1=1, x2=2, n1=2, n2=2, msg="Checking for out-of-range variable value", silent=TRUE)) 
	 checkException(testBinomial(x1=rep(2,2), x2=2, n1=2, n2=2, msg="Checking for incorrect variable length", silent=TRUE)) 
}

"test.testBinomial.x2" <- function()
{
	 checkException(testBinomial(x2="abc", x1=2, n1=2, n2=2, msg="Checking for incorrect variable type", silent=TRUE)) 
	 checkException(testBinomial(x2=1, x1=2, n1=2, n2=2, msg="Checking for out-of-range variable value", silent=TRUE)) 
	 checkException(testBinomial(x2=rep(2,2), x1=2, n1=2, n2=2, msg="Checking for incorrect variable length", silent=TRUE)) 
}

"test.testBinomial.n1" <- function()
{
	 checkException(testBinomial(n1="abc", x1=2, x2=2, n2=2, msg="Checking for incorrect variable type", silent=TRUE)) 
	 checkException(testBinomial(n1=rep(2,2), x1=2, x2=2, n2=2, msg="Checking for incorrect variable length", silent=TRUE)) 
}

"test.testBinomial.n2" <- function()
{
	 checkException(testBinomial(n2="abc", x1=2, x2=2, n1=2, msg="Checking for incorrect variable type", silent=TRUE)) 
	 checkException(testBinomial(n2=rep(2,2), x1=2, x2=2, n1=2, msg="Checking for incorrect variable length", silent=TRUE)) 
}

"test.testBinomial.delta0" <- function()
{
	 checkException(testBinomial(delta0="abc", x1=2, x2=2, n1=2, n2=2, msg="Checking for incorrect variable type", silent=TRUE)) 
	 checkException(testBinomial(delta0=rep(0.1,2), x1=2, x2=2, n1=2, n2=2, msg="Checking for incorrect variable length", silent=TRUE)) 
}

"test.testBinomial.scale" <- function()
{
	 checkException(testBinomial(scale=1, x1=2, x2=2, n1=2, n2=2, msg="Checking for incorrect variable type", silent=TRUE)) 
	 checkException(testBinomial(scale="abc", x1=2, x2=2, n1=2, n2=2, msg="Checking for out-of-range variable value", silent=TRUE)) 
	 checkException(testBinomial(scale=rep("RR",2), x1=2, x2=2, n1=2, n2=2, msg="Checking for incorrect variable length", silent=TRUE)) 
}

"test.testBinomial.tol" <- function()
{
	 checkException(testBinomial(tol="abc", x1=2, x2=2, n1=2, n2=2, msg="Checking for incorrect variable type", silent=TRUE)) 
	 checkException(testBinomial(tol=c(-1), x1=2, x2=2, n1=2, n2=2, msg="Checking for out-of-range variable value", silent=TRUE)) 
}


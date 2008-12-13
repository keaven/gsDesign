# ciBinomial test functions

"test.ciBinomial.x1" <- function()
{
	 checkException(ciBinomial(x1="abc", x2=2, n1=2, n2=2), msg="Checking for incorrect variable type", silent=TRUE) 
	 checkException(ciBinomial(x1=3, x2=2, n1=2, n2=2), msg="Checking for out-of-range variable value", silent=TRUE) 
	 checkException(ciBinomial(x1=c(-1), x2=2, n1=2, n2=2), msg="Checking for out-of-range variable value", silent=TRUE) 
	 checkException(ciBinomial(x1=rep(2,2), x2=2, n1=2, n2=2), msg="Checking for incorrect variable length", silent=TRUE) 
}

"test.ciBinomial.x2" <- function()
{
	 checkException(ciBinomial(x2="abc", x1=2, n1=2, n2=2), msg="Checking for incorrect variable type", silent=TRUE) 
	 checkException(ciBinomial(x2=3, x1=2, n1=2, n2=2), msg="Checking for out-of-range variable value", silent=TRUE) 
	 checkException(ciBinomial(x2=c(-1), x1=2, n1=2, n2=2), msg="Checking for out-of-range variable value", silent=TRUE) 
	 checkException(ciBinomial(x2=rep(2,2), x1=2, n1=2, n2=2), msg="Checking for incorrect variable length", silent=TRUE) 
}

"test.ciBinomial.n1" <- function()
{
	 checkException(ciBinomial(n1="abc", x1=2, x2=2, n2=2), msg="Checking for incorrect variable type", silent=TRUE) 
	 checkException(ciBinomial(n1=0, x1=0, x2=2, n2=2), msg="Checking for out-of-range variable value", silent=TRUE) 
	 checkException(ciBinomial(n1=rep(2,2), x1=2, x2=2, n2=2), msg="Checking for incorrect variable length", silent=TRUE) 
}

"test.ciBinomial.n2" <- function()
{
	 checkException(ciBinomial(n2="abc", x1=2, x2=2, n1=2), msg="Checking for incorrect variable type", silent=TRUE) 
	 checkException(ciBinomial(n2=0, x1=2, x2=0, n1=2), msg="Checking for out-of-range variable value", silent=TRUE) 
	 checkException(ciBinomial(n2=rep(2,2), x1=2, x2=2, n1=2), msg="Checking for incorrect variable length", silent=TRUE) 
}

"test.ciBinomial.alpha" <- function()
{
	 checkException(ciBinomial(alpha="abc", x1=2, x2=2, n1=2, n2=2), msg="Checking for incorrect variable type", silent=TRUE) 
	 checkException(ciBinomial(alpha=1, x1=2, x2=2, n1=2, n2=2), msg="Checking for out-of-range variable value", silent=TRUE) 
	 checkException(ciBinomial(alpha=0, x1=2, x2=2, n1=2, n2=2), msg="Checking for out-of-range variable value", silent=TRUE) 
	 checkException(ciBinomial(alpha=rep(0.1,2), x1=2, x2=2, n1=2, n2=2), msg="Checking for incorrect variable length", silent=TRUE) 
}

"test.ciBinomial.adj" <- function()
{
	 checkException(ciBinomial(adj="abc", x1=2, x2=2, n1=2, n2=2), msg="Checking for incorrect variable type", silent=TRUE) 
	 checkException(ciBinomial(adj=c(-1), x1=2, x2=2, n1=2, n2=2), msg="Checking for out-of-range variable value", silent=TRUE) 
	 checkException(ciBinomial(adj=2, x1=2, x2=2, n1=2, n2=2), msg="Checking for out-of-range variable value", silent=TRUE) 
	 checkException(ciBinomial(adj=rep(1,2), x1=2, x2=2, n1=2, n2=2), msg="Checking for incorrect variable length", silent=TRUE) 
}

"test.ciBinomial.scale" <- function()
{
	 checkException(ciBinomial(scale=1, x1=2, x2=2, n1=2, n2=2), msg="Checking for incorrect variable type", silent=TRUE) 
	 checkException(ciBinomial(scale="abc", x1=2, x2=2, n1=2, n2=2), msg="Checking for out-of-range variable value", silent=TRUE) 
	 checkException(ciBinomial(scale=rep("Difference",2), x1=2, x2=2, n1=2, n2=2), msg="Checking for incorrect variable length", silent=TRUE) 
}

"test.ciBinomial.tol" <- function()
{
	 checkException(ciBinomial(tol="abc", x1=2, x2=2, n1=2, n2=2), msg="Checking for incorrect variable type", silent=TRUE) 
	 checkException(ciBinomial(tol=0, x1=2, x2=2, n1=2, n2=2), msg="Checking for out-of-range variable value", silent=TRUE) 
}


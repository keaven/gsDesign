# gsbound1 test functions

"test.gsbound1.theta" <- function()
{
	 checkException(gsbound1(theta="abc", I=1, a=0, probhi=0.5), msg="Checking for incorrect variable type", silent=TRUE) 
	 checkException(gsbound1(theta=rep(1, 2), I=1, a=0, probhi=0.5), msg="Checking for incorrect variable length", silent=TRUE) 
}

"test.gsbound1.I" <- function()
{
	 checkException(gsbound1(I="abc", theta=1, a=0, probhi=0.5), msg="Checking for incorrect variable type", silent=TRUE) 
	 checkException(gsbound1(I=0, theta=1, a=0, probhi=0.5), msg="Checking for out-of-range variable value", silent=TRUE) 
	 checkException(gsbound1(I=rep(1, 2), theta=1, a=0, probhi=0.5), msg="Checking for incorrect variable length", silent=TRUE) 
}

"test.gsbound1.a" <- function()
{
	 checkException(gsbound1(a="abc", theta=1, I=1, probhi=0.5), msg="Checking for incorrect variable type", silent=TRUE) 
	 checkException(gsbound1(a=rep(0.5, 2), theta=1, I=1, probhi=0.5), msg="Checking for incorrect variable length", silent=TRUE) 
}

"test.gsbound1.probhi" <- function()
{
	 checkException(gsbound1(probhi="abc", I=1, a=0, theta=1), msg="Checking for incorrect variable type", silent=TRUE) 
	 checkException(gsbound1(probhi=0, I=1, a=0, theta=1), msg="Checking for out-of-range variable value", silent=TRUE) 
	 checkException(gsbound1(probhi=1, I=1, a=0, theta=1), msg="Checking for out-of-range variable value", silent=TRUE) 
	 checkException(gsbound1(probhi=rep(0.5, 2), I=1, a=0, theta=1), msg="Checking for incorrect variable length", silent=TRUE) 
}

"test.gsbound1.tol" <- function()
{
	 checkException(gsbound1(tol="abc", I=1, a=0, probhi=0.5, theta=1), msg="Checking for incorrect variable type", silent=TRUE) 
	 checkException(gsbound1(tol=0, I=1, a=0, probhi=0.5, theta=1), msg="Checking for out-of-range variable value", silent=TRUE) 
}

"test.gsbound1.r" <- function()
{
	 checkException(gsbound1(r="abc", I=1, a=0, probhi=0.5, theta=1), msg="Checking for incorrect variable type", silent=TRUE) 
	 checkException(gsbound1(r=0, I=1, a=0, probhi=0.5, theta=1), msg="Checking for out-of-range variable value", silent=TRUE) 
	 checkException(gsbound1(r=81, I=1, a=0, probhi=0.5, theta=1), msg="Checking for out-of-range variable value", silent=TRUE) 
	 checkException(gsbound1(r=rep(1,2), I=1, a=0, probhi=0.5, theta=1), msg="Checking for incorrect variable length", silent=TRUE) 
}


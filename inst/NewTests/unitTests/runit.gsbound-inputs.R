# gsbound test functions

"test.gsbound.I" <- function()
{
	 checkException(gsbound(I="abc", trueneg=0.5, falsepos=0.5), msg="Checking for incorrect variable type", silent=TRUE) 
	 checkException(gsbound(I=0, trueneg=0.5, falsepos=0.5), msg="Checking for out-of-range variable value", silent=TRUE) 
	 checkException(gsbound(I=rep(1, 2), trueneg=0.5, falsepos=0.5), msg="Checking for incorrect variable length", silent=TRUE) 
}

"test.gsbound.trueneg" <- function()
{
	 checkException(gsbound(trueneg="abc", I=1, falsepos=0.5), msg="Checking for incorrect variable type", silent=TRUE) 
	 checkException(gsbound(trueneg=0, I=1, falsepos=0.5), msg="Checking for out-of-range variable value", silent=TRUE) 
	 checkException(gsbound(trueneg=1, I=1, falsepos=0.5), msg="Checking for out-of-range variable value", silent=TRUE) 
	 checkException(gsbound(trueneg=rep(0.5, 2), I=1, falsepos=0.5), msg="Checking for incorrect variable length", silent=TRUE) 
}

"test.gsbound.falsepos" <- function()
{
	 checkException(gsbound(falsepos="abc", I=1, trueneg=0.5), msg="Checking for incorrect variable type", silent=TRUE) 
	 checkException(gsbound(falsepos=0, I=1, trueneg=0.5), msg="Checking for out-of-range variable value", silent=TRUE) 
	 checkException(gsbound(falsepos=1, I=1, trueneg=0.5), msg="Checking for out-of-range variable value", silent=TRUE) 
	 checkException(gsbound(falsepos=rep(0.5, 2), I=1, trueneg=0.5), msg="Checking for incorrect variable length", silent=TRUE) 
}

"test.gsbound.tol" <- function()
{
	 checkException(gsbound(tol="abc", I=1, trueneg=0.5, falsepos=0.5), msg="Checking for incorrect variable type", silent=TRUE) 
	 checkException(gsbound(tol=0, I=1, trueneg=0.5, falsepos=0.5), msg="Checking for out-of-range variable value", silent=TRUE) 
}

"test.gsbound.r" <- function()
{
	 checkException(gsbound(r="abc", I=1, trueneg=0.5, falsepos=0.5), msg="Checking for incorrect variable type", silent=TRUE) 
	 checkException(gsbound(r=0, I=1, trueneg=0.5, falsepos=0.5), msg="Checking for out-of-range variable value", silent=TRUE) 
	 checkException(gsbound(r=81, I=1, trueneg=0.5, falsepos=0.5), msg="Checking for out-of-range variable value", silent=TRUE) 
	 checkException(gsbound(r=rep(1,2), I=1, trueneg=0.5, falsepos=0.5), msg="Checking for incorrect variable length", silent=TRUE) 
}


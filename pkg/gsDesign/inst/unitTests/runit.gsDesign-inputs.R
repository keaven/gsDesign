# gsDesign test functions

"test.gsDesign.k" <- function()
{
	 checkException(gsDesign(k="abc"), msg="Checking for incorrect variable type", silent=TRUE) 
	 checkException(gsDesign(k=1.2), msg="Checking for incorrect variable type", silent=TRUE) 
	 checkException(gsDesign(k=0), msg="Checking for out-of-range variable value", silent=TRUE) 
	 checkException(gsDesign(k=24, test.type=4), msg="Checking for out-of-range variable value", silent=TRUE) 
	 checkException(gsDesign(k=seq(2)), msg="Checking for incorrect variable length", silent=TRUE) 
	 checkException(gsDesign(k=3, sfu=sfpoints, sfupar=c(.05, .1,  .15,  .2, 1)), msg="Checking for incorrect variable length", silent=TRUE) 
}

"test.gsDesign.test.type" <- function()
{
	 checkException(gsDesign(test.type="abc"), msg="Checking for incorrect variable type", silent=TRUE) 
	 checkException(gsDesign(test.type=1.2), msg="Checking for incorrect variable type", silent=TRUE) 
	 checkException(gsDesign(test.type=0), msg="Checking for out-of-range variable value", silent=TRUE) 
	 checkException(gsDesign(test.type=7), msg="Checking for out-of-range variable value", silent=TRUE) 
	 checkException(gsDesign(test.type=seq(2)), msg="Checking for incorrect variable length", silent=TRUE) 
	 checkException(gsDesign(test.type=3, sfu="WT"), msg="Checking for out-of-range variable value", silent=TRUE) 
	 checkException(gsDesign(test.type=4, sfu="WT"), msg="Checking for out-of-range variable value", silent=TRUE) 
	 checkException(gsDesign(test.type=5, sfu="WT"), msg="Checking for out-of-range variable value", silent=TRUE) 
	 checkException(gsDesign(test.type=6, sfu="WT"), msg="Checking for out-of-range variable value", silent=TRUE) 
}

"test.gsDesign.alpha" <- function()
{
	 checkException(gsDesign(alpha="abc", test.type=1), msg="Checking for incorrect variable type", silent=TRUE) 
	 checkException(gsDesign(alpha=0, test.type=1), msg="Checking for out-of-range variable value", silent=TRUE) 
	 checkException(gsDesign(alpha=1, test.type=1), msg="Checking for out-of-range variable value", silent=TRUE) 
	 checkException(gsDesign(alpha=0.51, test.type=2), msg="Checking for out-of-range variable value", silent=TRUE) 
	 checkException(gsDesign(alpha=rep(0.5, 2), test.type=1), msg="Checking for incorrect variable length", silent=TRUE) 
}

"test.gsDesign.beta" <- function()
{
	 checkException(gsDesign(beta="abc", test.type=3), msg="Checking for incorrect variable type", silent=TRUE) 
	 checkException(gsDesign(beta=0.5, alpha=0.5, test.type=3), msg="Checking for out-of-range variable value", silent=TRUE) 
	 checkException(gsDesign(beta=1, alpha=0, test.type=3), msg="Checking for out-of-range variable value", silent=TRUE) 
	 checkException(gsDesign(beta=0, test.type=3), msg="Checking for out-of-range variable value", silent=TRUE) 
	 checkException(gsDesign(beta=rep(0.1, 2), alpha=0.5, test.type=3), msg="Checking for incorrect variable length", silent=TRUE) 
}

"test.gsDesign.astar" <- function()
{
	 checkException(gsDesign(astar="abc", test.type=5), msg="Checking for incorrect variable type", silent=TRUE) 
	 checkException(gsDesign(astar=0.51, alpha=0.5, test.type=5), msg="Checking for out-of-range variable value", silent=TRUE) 
	 checkException(gsDesign(astar=1, alpha=0, test.type=5), msg="Checking for out-of-range variable value", silent=TRUE) 
	 checkException(gsDesign(astar=-1, test.type=6), msg="Checking for out-of-range variable value", silent=TRUE) 
	 checkException(gsDesign(astar=rep(0.1, 2), alpha=0.5, test.type=5), msg="Checking for incorrect variable length", silent=TRUE) 
}

"test.gsDesign.delta" <- function()
{
	 checkException(gsDesign(delta="abc"), msg="Checking for incorrect variable type", silent=TRUE) 
	 checkException(gsDesign(delta=-1), msg="Checking for out-of-range variable value", silent=TRUE) 
	 checkException(gsDesign(delta=rep(0.1, 2)), msg="Checking for incorrect variable length", silent=TRUE) 
}

"test.gsDesign.n.fix" <- function()
{
	 checkException(gsDesign(n.fix="abc", delta=0), msg="Checking for incorrect variable type", silent=TRUE) 
	 checkException(gsDesign(n.fix=-1, delta=0), msg="Checking for out-of-range variable value", silent=TRUE) 
	 checkException(gsDesign(n.fix=rep(2, 2), delta=0), msg="Checking for incorrect variable length", silent=TRUE) 
}

"test.gsDesign.timing" <- function()
{
	 checkException(gsDesign(timing="abc", k=1), msg="Checking for incorrect variable type", silent=TRUE) 
	 checkException(gsDesign(timing=-1, k=1), msg="Checking for out-of-range variable value", silent=TRUE) 
	 checkException(gsDesign(timing=2, k=1), msg="Checking for out-of-range variable value", silent=TRUE) 
   checkException(gsDesign(timing=c(.1,1.1), k=2), msg="Checking for out-of-range variable value", silent=TRUE) 
	 checkException(gsDesign(timing=c(0.5, 0.1), k=2), msg="NA", silent=TRUE) 
	 checkException(gsDesign(timing=c(0.1, 0.5, 1), k=2), msg="Checking for incorrect variable length", silent=TRUE) 
}

"test.gsDesign.sfu" <- function()
{
	 checkException(gsDesign(sfu="abc"), msg="Checking for incorrect variable type", silent=TRUE) 
	 checkException(gsDesign(sfu=rep(sfHSD, 2)), msg="Checking for incorrect variable length", silent=TRUE) 
}

"test.gsDesign.sfupar" <- function()
{
	 checkException(gsDesign(sfupar="abc"), msg="Checking for incorrect variable type", silent=TRUE) 
	 checkException(gsDesign(sfupar=rep(-4,2)), msg="Checking for incorrect variable length", silent=TRUE) 
}

"test.gsDesign.sfl" <- function()
{
	 checkException(gsDesign(sfl="abc"), msg="Checking for incorrect variable type", silent=TRUE) 
	 checkException(gsDesign(sfl=rep(sfHSD, 2)), msg="Checking for incorrect variable length", silent=TRUE) 
}

"test.gsDesign.sflpar" <- function()
{
	 checkException(gsDesign(sflpar="abc"), msg="Checking for incorrect variable type", silent=TRUE) 
	 checkException(gsDesign(sflpar=rep(-2,2)), msg="Checking for incorrect variable length", silent=TRUE) 
}

"test.gsDesign.tol" <- function()
{
	 checkException(gsDesign(tol="abc"), msg="Checking for incorrect variable type", silent=TRUE) 
	 checkException(gsDesign(tol=0), msg="Checking for out-of-range variable value", silent=TRUE) 
	 checkException(gsDesign(tol=0.10000001), msg="Checking for out-of-range variable value", silent=TRUE) 
	 checkException(gsDesign(tol=rep(0.1, 2)), msg="Checking for incorrect variable length", silent=TRUE) 
}

"test.gsDesign.r" <- function()
{
	 checkException(gsDesign(r="abc"), msg="Checking for incorrect variable type", silent=TRUE) 
	 checkException(gsDesign(r=0), msg="Checking for out-of-range variable value", silent=TRUE) 
	 checkException(gsDesign(r=81), msg="Checking for out-of-range variable value", silent=TRUE) 
	 checkException(gsDesign(r=rep(1,2)), msg="Checking for incorrect variable length", silent=TRUE) 
}

"test.gsDesign.n.I" <- function()
{
	 checkException(gsDesign(n.I="abc"), msg="Checking for incorrect variable type", silent=TRUE) 
}

"test.gsDesign.maxn.I" <- function()
{
	 checkException(gsDesign(maxn.I="abc"), msg="Checking for incorrect variable type", silent=TRUE) 
}


### Utility functions for gsDesign stress test functions

"alpha.beta.range.util" <- function(alpha, beta, type, sf)
{	
    no.err <- TRUE
	
	for (a in alpha)
	{
	    for (b in beta)
		{
		    if (b < 1 - a)
			{
			    res <- try(gsDesign(test.type=type, alpha=a, beta=b, sfu=sf))
			    
			    if (is(res, "try-error"))
			    {
				    no.err <- FALSE
			    }
		    }
		}		
	}
	
	no.err
}

"param.range.util" <- function(param, type, sf)
{	
	no.err <- TRUE
	
	for (p in param)
	{
		res <- try(gsDesign(test.type=type, sfu=sf, sfupar=p))
		
		if (is(res, "try-error"))
		{
			no.err <- FALSE
		}
	}
	
	no.err
}


### gsDesign stress test functions

"test.stress.sfLDPocock.type1" <- function()
{	
	a = seq(from=0.05, to=0.95, by=0.05)
	b = seq(from=0.05, to=0.95, by=0.05)
	
    no.errors <- alpha.beta.range.util(alpha=a, beta=b, type=1, sf=sfLDPocock)
	
	checkTrue(no.errors, "Type 1 LDPocock stress test")
}




"test.stress.sfExp.type1" <- function()
{	
	nu = seq(from=0.1, to=1.5, by=0.1)
	
	no.errors <- param.range.util(param=nu, type=1, sf=sfExponential)
	
	checkTrue(no.errors, "Type 1 sfExponential stress test")
}





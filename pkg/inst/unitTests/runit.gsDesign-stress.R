### Utility functions for gsDesign stress tests

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

a1 = seq(from=0.05, to=0.95, by=0.05)
a2 = seq(from=0.05, to=0.45, by=0.05)
b = seq(from=0.05, to=0.95, by=0.05)

# nu: sfExponential parameter
nu = seq(from=0.1, to=1.5, by=0.1)
# rho: sfPower parameter
rho = seq(from=1, to=15, by=1)
# gamma: sfHSD parameter
gamma = seq(from=-5, to=5, by=1)

##################################

### gsDesign stress test functions

"test.stress.sfLDPocock.type1" <- function()
{		
    no.errors <- alpha.beta.range.util(alpha=a1, beta=b, type=1, sf=sfLDPocock)
	
	checkTrue(no.errors, "Type 1 LDPocock stress test")
}

"test.stress.sfLDPocock.type2" <- function()
{	
    no.errors <- alpha.beta.range.util(alpha=a2, beta=b, type=2, sf=sfLDPocock)
	
	checkTrue(no.errors, "Type 2 LDPocock stress test")
}

"test.stress.sfLDPocock.type3" <- function()
{	
    no.errors <- alpha.beta.range.util(alpha=a1, beta=b, type=3, sf=sfLDPocock)
	
	checkTrue(no.errors, "Type 3 LDPocock stress test")
}

"test.stress.sfLDPocock.type4" <- function()
{	
    no.errors <- alpha.beta.range.util(alpha=a1, beta=b, type=4, sf=sfLDPocock)
	
	checkTrue(no.errors, "Type 4 LDPocock stress test")
}

"test.stress.sfLDPocock.type5" <- function()
{	
    no.errors <- alpha.beta.range.util(alpha=a1, beta=b, type=5, sf=sfLDPocock)
	
	checkTrue(no.errors, "Type 5 LDPocock stress test")
}

"test.stress.sfLDPocock.type6" <- function()
{	
    no.errors <- alpha.beta.range.util(alpha=a1, beta=b, type=6, sf=sfLDPocock)
	
	checkTrue(no.errors, "Type 6 LDPocock stress test")
}

"test.stress.sfLDOF.type1" <- function()
{		
    no.errors <- alpha.beta.range.util(alpha=a1, beta=b, type=1, sf=sfLDOF)
	
	checkTrue(no.errors, "Type 1 LDOF stress test")
}

"test.stress.sfLDOF.type2" <- function()
{	
    no.errors <- alpha.beta.range.util(alpha=a2, beta=b, type=2, sf=sfLDOF)
	
	checkTrue(no.errors, "Type 2 LDOF stress test")
}

"test.stress.sfLDOF.type3" <- function()
{	
    no.errors <- alpha.beta.range.util(alpha=a1, beta=b, type=3, sf=sfLDOF)
	
	checkTrue(no.errors, "Type 3 LDOF stress test")
}

"test.stress.sfLDOF.type4" <- function()
{	
    no.errors <- alpha.beta.range.util(alpha=a1, beta=b, type=4, sf=sfLDOF)
	
	checkTrue(no.errors, "Type 4 LDOF stress test")
}

"test.stress.sfLDOF.type5" <- function()
{	
    no.errors <- alpha.beta.range.util(alpha=a1, beta=b, type=5, sf=sfLDOF)
	
	checkTrue(no.errors, "Type 5 LDOF stress test")
}

"test.stress.sfLDOF.type6" <- function()
{	
    no.errors <- alpha.beta.range.util(alpha=a1, beta=b, type=6, sf=sfLDOF)
	
	checkTrue(no.errors, "Type 6 LDOF stress test")
}

"test.stress.sfExp.type1" <- function()
{
	no.errors <- param.range.util(param=nu, type=1, sf=sfExponential)
	
	checkTrue(no.errors, "Type 1 sfExponential stress test")
}

"test.stress.sfExp.type2" <- function()
{
	no.errors <- param.range.util(param=nu, type=2, sf=sfExponential)
	
	checkTrue(no.errors, "Type 2 sfExponential stress test")
}

"test.stress.sfExp.type3" <- function()
{
	no.errors <- param.range.util(param=nu, type=3, sf=sfExponential)
	
	checkTrue(no.errors, "Type 3 sfExponential stress test")
}

"test.stress.sfExp.type4" <- function()
{
	no.errors <- param.range.util(param=nu, type=4, sf=sfExponential)
	
	checkTrue(no.errors, "Type 4 sfExponential stress test")
}

"test.stress.sfExp.type5" <- function()
{
	no.errors <- param.range.util(param=nu, type=5, sf=sfExponential)
	
	checkTrue(no.errors, "Type 5 sfExponential stress test")
}

"test.stress.sfExp.type6" <- function()
{
	no.errors <- param.range.util(param=nu, type=6, sf=sfExponential)
	
	checkTrue(no.errors, "Type 6 sfExponential stress test")
}

"test.stress.sfPower.type1" <- function()
{
	no.errors <- param.range.util(param=rho, type=1, sf=sfPower)
	
	checkTrue(no.errors, "Type 1 sfPower stress test")
}

"test.stress.sfPower.type2" <- function()
{
	no.errors <- param.range.util(param=rho, type=2, sf=sfPower)
	
	checkTrue(no.errors, "Type 2 sfPower stress test")
}

"test.stress.sfPower.type3" <- function()
{
	no.errors <- param.range.util(param=rho, type=3, sf=sfPower)
	
	checkTrue(no.errors, "Type 3 sfPower stress test")
}

"test.stress.sfPower.type4" <- function()
{
	no.errors <- param.range.util(param=rho, type=4, sf=sfPower)
	
	checkTrue(no.errors, "Type 4 sfPower stress test")
}

"test.stress.sfPower.type5" <- function()
{
	no.errors <- param.range.util(param=rho, type=5, sf=sfPower)
	
	checkTrue(no.errors, "Type 5 sfPower stress test")
}

"test.stress.sfPower.type6" <- function()
{
	no.errors <- param.range.util(param=rho, type=6, sf=sfPower)
	
	checkTrue(no.errors, "Type 6 sfPower stress test")
}

"test.stress.sfHSD.type1" <- function()
{
	no.errors <- param.range.util(param=gamma, type=1, sf=sfPower)
	
	checkTrue(no.errors, "Type 1 sfPower stress test")
}

"test.stress.sfHSD.type2" <- function()
{
	no.errors <- param.range.util(param=gamma, type=2, sf=sfPower)
	
	checkTrue(no.errors, "Type 2 sfPower stress test")
}

"test.stress.sfHSD.type3" <- function()
{
	no.errors <- param.range.util(param=gamma, type=3, sf=sfPower)
	
	checkTrue(no.errors, "Type 3 sfPower stress test")
}

"test.stress.sfHSD.type4" <- function()
{
	no.errors <- param.range.util(param=gamma, type=4, sf=sfPower)
	
	checkTrue(no.errors, "Type 4 sfPower stress test")
}

"test.stress.sfHSD.type5" <- function()
{
	no.errors <- param.range.util(param=gamma, type=5, sf=sfPower)
	
	checkTrue(no.errors, "Type 5 sfPower stress test")
}

"test.stress.sfHSD.type6" <- function()
{
	no.errors <- param.range.util(param=gamma, type=6, sf=sfPower)
	
	checkTrue(no.errors, "Type 6 sfPower stress test")
}

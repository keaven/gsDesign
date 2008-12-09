### gsDesign stress test functions

# NOT FINISHED
#"stress.Pocock.type1" <- function()
#{	
#	no.errors <- TRUE
#	
#	for (a in seq(from=0.05, to=0.95, by=0.05))
#	{
#		
#		for (b in seq(from=0.05, to=1-a-0.01, by=0.05))
#		{
#			res <- try(gsDesign(test.type=1, alpha=a, beta=b, sfu=sfLDPocock))
#			
#			if (is(res, "try-error"))
#			{
#				no.errors <- FALSE
#			}
#		}
#		
#	}
#	
#	checkTrue(no.errors, "Type 1 LDPocock stress test")
#}




"stress.sfExp.type1" <- function()
{	
	no.errors <- TRUE
	
	for (nu in seq(from=0.1, to=1.5, by=0.1))
	{
		res <- try(gsDesign(test.type=1, sfu=sfExponential, sfupar=nu))
			
		if (is(res, "try-error"))
		{
			no.errors <- FALSE
		}
	}
	
	checkTrue(no.errors, "Type 1 sfExponential stress test")
}





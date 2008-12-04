### --- Test setup ---
 
if (FALSE){
  library("RUnit")
  library("gsDesign")
}

silent <- TRUE

Ttest <- "Checking for incorrect variable type"
Ltest <- "Checking for incorrect variable length"
Rtest <- "Checking for out-of-range variable value"
Otest <- "Checking for out-of-order input sequence"

### --- Test functions ---

test.k <- function()
{
    checkException(gsDesign(k="abc"), msg=Ttest, silent=silent)
    checkException(gsDesign(k=1.2), msg=Ttest, silent=silent)
    checkException(gsDesign(k=0), msg=Rtest, silent=silent)
    #checkException(gsDesign(k=24, test.type=3), msg=Rtest, silent=silent)
    checkException(gsDesign(k=1:2), msg=Otest, silent=silent)
}


## kpMatch - checks for appropriate error
## when length of sfPoints param p does not match k 
## for all test types

# Run with expected results by KW 11/26

kpMatch <- function()
{   
    for (tt in 1:6)
    {
        
        checkException(gsDesign(test.type=tt, k=3, sfu=sfPoints, sfupar=c(.05, .1,  .15,  .2, 1)), 
                       msg=paste("kpMatch tt= ", tt))
        
    }
}

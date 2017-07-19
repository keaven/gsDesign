### --- Test setup ---
 
if(FALSE) {
  ## Not really needed, but can be handy when writing tests
  library("RUnit")
  library("gsDesign")
} 
 
### --- Test functions ---

## bRangeErr - checks for appropriate error
## when b is out of range

# Run with expected results by KW 11/26

bRangeErr <- function()
{
    
    checkException(sfLogistic(alpha=0.025, t=1, param=c(1, 0)), msg="bRangeErr")
            
}


## pOrderErr - checks for appropriate error
## when 4-parameter specification out of order

# Run with expected results by KW 11/26

pOrderErr <- function()
{
    
    checkException(sfLogistic(alpha=0.025, t=1, param=c(.1, .6, .2, .05)), msg="pOrderErr")
    
}

### --- Test setup ---
 
if(FALSE) {
  ## Not really needed, but can be handy when writing tests
  library("RUnit")
  library("gsDesign")
} 
 
### --- Test functions ---

## asym2sideErr - checks for appropriate errors
## when test.type %in% 3:6 
## and spending fn is "WT", "Pocock", or "OF" 

asym2sideErr <- function()
{   
    for (tt in 3:6)
    {
        for (sf in c("WT", "Pocock", "OF"))
        {
            checkException(gsDesign(test.type=tt, sfu=sf), 
                msg=paste("asym2sideErr tt= ", tt, "sfn = ", sf))
            }
        }
}


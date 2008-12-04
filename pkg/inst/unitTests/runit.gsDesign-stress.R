### --- Test setup ---
 
if(FALSE) {
  ## Not really needed, but can be handy when writing tests
  library("RUnit")
  library("gsDesign")
} 

tt = 1
aSeq = seq(from=0.01, to=0.99, by=0.02)
 
### --- Test functions ---

## Stress test for HSD spending function:
## Valid 2D gamma x alpha range

## KW 11/26 uniroot errors
## Not sure how to handle the expected case of no errors?

stressHSD <- function()
{
    gamma <- seq(from=-40, to=40, by=5)
    
    for (type in tt) 
    {
        for (g in gamma)
        {
            for (a in aSeq)
            {
                try(gsDesign(test.type=type, alpha=a, sfu=sfHSD, sfupar=g))
            }
        }
    }
}




# Version 3.2.1 July, 2021

- Have the issues why your package was archived been fixed?
  + Yes, the issue was due to deprecated `gt` package function; this has been fixed.
  + Removed docs folder per automated review
  + The other NOTE seems to be about the archived status and/or spell check of reference requested by CRAN reviewer in DESCRIPTION file; note that Jennison and Turnbull where checked as possibly incorrect, but they are correct.

  
- Also following up on additional comments from CRAN reviewer
    - Updated DESCRIPTION file to add references describing the methods.
    - Updated `plot.binomialSPRT.Rd` file to remove `dontrun` and `if(interactive())`. 
    - Added `\value` for all exported methods. Including `checkScalar.Rd` and `xtable.Rd`. 
    - Removed commented line in `gsBinomialExact.Rd`, `gsProbability.Rd` examples 
    - Used `on.exit()` to avoid changing user's options following suggestions including `gsqplot.R`, `ssrCP.R`, `gsUtilities.R`.

# Test environments

All are on github.com/keaven/gsDesign actions:

- Windows (latest)
- MacOS (latest)
- MacOS latest (devel)
- Ubuntu-16.04 (release)

# R CMD check results

0 errors | 0 warnings | 0 notes

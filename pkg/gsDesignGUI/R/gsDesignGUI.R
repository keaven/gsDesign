"gsDesignGUI" <- function(x)
{
   # x is a named list of mapped Qt objects
   z <- gsDesign(k=x$eptIntervalsSpin)

   # form output to send back to Qt
   gsDesignToQt(z, x)
}


"gsDesignToQt" <- function(x, designList, plotPath=file.path(tempdir(), "gsDesignPlot.png"))
{
  if (!is(x, "gsDesign"))
  {
    stop("x must be an object of class \"gDesign\"")
  }
  
  # capture textual output
  outText <- paste(capture.output(print(x)), collapse="\n")
  
  # capture graphical output
  png(file=plotPath, bg="transparent")
  types <- c("Boundaries", "Power", "Treatment Effect", "Conditional Power", "Spending Function","Expected Sample Size","B-Values")
  plot(x, plottype=match(designList$opTypeCombo, types))
  dev.off()
  
  list(text=outText, plot=plotPath)
}
  
    



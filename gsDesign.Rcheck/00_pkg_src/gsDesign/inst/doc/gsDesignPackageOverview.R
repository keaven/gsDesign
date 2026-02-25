## ----include=FALSE--------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  dev = "svg",
  fig.ext = "svg",
  fig.width = 7.2916667,
  fig.asp = 0.618,
  fig.align = "center",
  out.width = "80%"
)

## -------------------------------------------------------
library(gsDesign)

x <- gsDesign(n.fix = 200)
plot(x)
gsBoundSummary(x)


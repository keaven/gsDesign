## ----include=FALSE--------------------------------------
knitr::opts_chunk$set(
  collapse = FALSE,
  comment = "#>",
  dev = "svg",
  fig.ext = "svg",
  fig.width = 7.2916667,
  fig.asp = 0.618,
  fig.align = "center",
  out.width = "80%"
)

options(width = 58)

## ----message=FALSE, warning=FALSE-----------------------
library(gsDesign)

## -------------------------------------------------------
delta1 <- 3 # Treatment effect, alternate hypothesis
delta0 <- 0 # Treatment effect, null hypothesis
ratio <- 1 # Randomization ratio (experimental / control)
sd <- 7.5 # Standard deviation for change in HAM-D score
alpha <- 0.1 # 1-sided Type I error
beta <- 0.17 # Targeted Type II error (1 - targeted power)
k <- 2 # Number of planned analyses
test.type <- 4 # Asymmetric bound design with non-binding futility bound
timing <- .5 # information fraction at interim analyses
sfu <- sfLDOF # O'Brien-Fleming spending function for alpha-spending
sfupar <- 0 # Parameter for upper spending function
sfl <- sfLDOF # O'Brien-Fleming spending function for beta-spending
sflpar <- 0 # Parameter for lower spending function
delta <- 0
endpoint <- "normal"

## -------------------------------------------------------
# Derive normal fixed design sample size
n <- nNormal(
  delta1 = delta1,
  delta0 = delta0,
  ratio = ratio,
  sd = sd,
  alpha = alpha,
  beta = beta
)

## -------------------------------------------------------
# Derive group sequential design based on parameters above
x <- gsDesign(
  k = k,
  test.type = test.type,
  alpha = alpha,
  beta = beta,
  timing = timing,
  sfu = sfu,
  sfupar = sfupar,
  sfl = sfl,
  sflpar = sflpar,
  delta = delta, # Not used since n.fix is provided
  delta1 = delta1,
  delta0 = delta0,
  endpoint = "normal",
  n.fix = n
)
# Convert sample size at each analysis to integer values
x <- toInteger(x)

## -------------------------------------------------------
# Updated alpha is unchanged
alphau <- 0.1
# Updated sample size at each analysis
n.I <- c(59, 134)
# Updated number of analyses
ku <- length(n.I)
# Information fraction is used for spending
usTime <- n.I / x$n.I[x$k]
lsTime <- usTime

## -------------------------------------------------------
# Update design based on actual interim sample size and planned final sample size
xu <- gsDesign(
  k = ku,
  test.type = test.type,
  alpha = alphau,
  beta = x$beta,
  sfu = sfu,
  sfupar = sfupar,
  sfl = sfl,
  sflpar = sflpar,
  n.I = n.I,
  maxn.IPlan = x$n.I[x$k],
  delta = x$delta,
  delta1 = x$delta1,
  delta0 = x$delta0,
  endpoint = endpoint,
  n.fix = n,
  usTime = usTime,
  lsTime = lsTime
)

## -------------------------------------------------------
# Summarize bounds
gsBoundSummary(xu, Nname = "N", digits = 4, ddigits = 2, tdigits = 1)


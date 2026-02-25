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

options(width = 58)

## ----echo=FALSE, message=FALSE, warning=FALSE-----------
library(gsDesign)
library(tidyr)
library(knitr)
library(tibble)

## -------------------------------------------------------
design <- gsSurv(hr = 0.7, lambdaC = log(2) / 12, minfup = 24, T = 36) |> toInteger()
design |> gsBoundSummary()

## ----results = 'asis'-----------------------------------
cat(design |> summary())

## -------------------------------------------------------
update <- gsDesign(
  k = design$k,
  test.type = design$test.type,
  alpha = design$alpha,
  beta = design$beta,
  sfu = design$upper$sf,
  sfupar = design$upper$param,
  sfl = design$lower$sf,
  sflpar = design$lower$param,
  n.I = c(117, design$n.I[2:3]),
  maxn.IPlan = design$n.I[design$k],
  delta = design$delta,
  delta1 = design$delta1,
  delta0 = design$delta0
)
gsBoundSummary(
  update,
  deltaname = "HR",
  logdelta = TRUE,
  Nname = "Events",
  digits = 4,
  ddigits = 2,
  tdigits = 1,
  exclude = c(
    "B-value", "CP", "CP H1", "PP",
    paste0("P(Cross) if HR=", round(c(design$hr0, design$hr), digits = 2))
  )
)

## -------------------------------------------------------
# Nominal 1-sided p-value
p <- 0.04

## -------------------------------------------------------
zn2hr(-qnorm(p), n = update$n.I[1])

## -------------------------------------------------------
cp <- gsCP(x = update, i = 1, zi = -qnorm(p))
# 3 treatment effects as outlined above
# design$ratio is the experimental:control randomization ratio
exp(-cp$theta * sqrt((1 + design$ratio)^2 / design$ratio))

## -------------------------------------------------------
cp$upper$prob

## -------------------------------------------------------
hr <- seq(.6, 1.1, .01)

## -------------------------------------------------------
# Translate hazard ratio to standardized effect size
theta <- -log(hr) * sqrt(design$ratio / (1 + design$ratio)^2)
cp <- gsCP(x = update, i = 1, zi = -qnorm(p), theta = theta)

## -------------------------------------------------------
plot(cp, xval = hr, xlab = "Future HR", ylab = "Conditional Power/Error", 
     main="Conditional probability of crossing future bound", offset = 1)

## -------------------------------------------------------
# set up a flat prior distribution for the treatment effect
# that is normal with mean .5 of the design standardized effect and
# a large standard deviation. 
mu0 <- .5 * design$delta 
sigma0 <- design$delta * 2
prior <- normalGrid(mu = mu0, sigma = sigma0)
gsPP(x = update, i = 1, zi = -qnorm(p), theta = prior$z, wgts = prior$wgts)


## ---- include = FALSE-----------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----setup, echo=FALSE, message=FALSE, warning=FALSE----
library(gsDesign)
library(tidyr)
library(knitr)

## -------------------------------------------------------
r <- 2
sigma <- sqrt((1+r)*(1.6^2 + 1.25^2/r)) 
theta <- 0.8/sigma
((qnorm(.9)+qnorm(.975))/theta)^2

## -------------------------------------------------------
nNormal(delta1=0.8, sd = 1.6, sd2 = 1.25, alpha = 0.025, n = 200, ratio = 2)

## -------------------------------------------------------
pwr <- pnorm(qnorm(.975) - sqrt(200) * theta, lower.tail = FALSE)
pwr

## -------------------------------------------------------
n <- 100:200
pwrn <- nNormal(delta1 = 0.8, sd = 1.6, sd2 = 1.25, alpha = 0.025, n = n, ratio = 2)
plot(n, pwrn, type="l")

## -------------------------------------------------------
delta1 <- seq(.5,1,.025)
pwrdelta1 <- nNormal(delta1 = delta1, sd = 1.6, sd2 = 1.25, alpha = 0.025, n = 200, ratio = 2)
plot(delta1, pwrdelta1, type="l")

## -------------------------------------------------------
nsim <- 1000000
delta <- 0.8
sd1 <- 1.6
sd2 <- 1.25
n1 <- 67
n2 <- 133
deltahat <- rnorm(n=nsim, mean=delta, sd=sd1/sqrt(n1)) - rnorm(n=nsim, mean=0, sd=sd2/sqrt(n2))
s <- sqrt(sd1^2 * rchisq(n=nsim, df=n1 - 1)/(n1-1)/n1 +
           sd2^2 * rchisq(n=nsim, df=n2 - 1)/(n2-1)/n2)
z <- deltahat / s
mean(z >= qnorm(.975))

## -------------------------------------------------------
sqrt(pwr*(1-pwr)/nsim)

## -------------------------------------------------------
d <- 
gsDesign(k=2,
         n.fix = nNormal(delta1=0.8, sd = 1.6, sd2 = 1.25, alpha = 0.025, beta = .1, ratio = 2),
         delta1 = 0.8)
d %>%  gsBoundSummary(deltaname = "Mean difference") %>% 
  kable(row.names = FALSE)

## ----results='asis'-------------------------------------
cat(summary(d))

## -------------------------------------------------------
gsDesign(k=2,
         delta = theta,
         delta1 = 0.8) %>%
  gsBoundSummary(deltaname = "Mean difference") %>% 
  kable(row.names=FALSE)


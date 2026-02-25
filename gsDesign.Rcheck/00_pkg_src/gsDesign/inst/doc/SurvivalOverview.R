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
n <- 100
hr <- .7
delta <- log(hr)
alpha <- .025
r <- 1
pnorm(qnorm(alpha) - sqrt(n * r) / (1 + r) * delta)

## -------------------------------------------------------
nEvents(n = n, alpha = alpha, hr = hr, r = r)

## -------------------------------------------------------
beta <- 0.1
(1 + r)^2 / r / log(hr)^2 * ((qnorm(1 - alpha) + qnorm(1 - beta)))^2

## -------------------------------------------------------
nEvents(hr = hr, alpha = alpha, beta = beta, r = 1, tbl = TRUE) |>
  kable()

## -------------------------------------------------------
theta <- delta * sqrt(r) / (1 + r)
theta

## -------------------------------------------------------
(1 + r) / sqrt(331 * r)

## -------------------------------------------------------
Schoenfeld <- gsDesign(
  k = 2,
  n.fix = nEvents(hr = hr, alpha = alpha, beta = beta, r = 1),
  delta1 = log(hr)
) |> toInteger()
Schoenfeld |>
  gsBoundSummary(deltaname = "HR", logdelta = TRUE, Nname = "Events") |>
  kable(row.names = FALSE)

## ----eval=FALSE-----------------------------------------
# Schoenfeld <- gsDesign(k = 2, delta = -theta, delta1 = log(hr)) |> toInteger()

## -------------------------------------------------------
Schoenfeld$n.I

## -------------------------------------------------------
gsDesign(k = 2, delta = -log(hr))$n.I

## -------------------------------------------------------
Schoenfeld$n.I

## -------------------------------------------------------
gsHR(
  z = Schoenfeld$upper$bound, # Z-values at bound
  i = 1:2, # Analysis number
  x = Schoenfeld, # Group sequential design from above
  ratio = r # Experimental/control randomization ratio
)

## -------------------------------------------------------
r <- 1

## -------------------------------------------------------
hr <- .73 # Observed hr
events <- 125 # Events in analysis

z <- log(hr) * sqrt(events * r) / (1 + r)
c(z, pnorm(z)) # Z- and p-value

## -------------------------------------------------------
hrn2z(hr = hr, n = events, ratio = r)

## -------------------------------------------------------
z <- qnorm(.025)
events <- 120
exp(z * (1 + r) / sqrt(r * events))

## -------------------------------------------------------
zn2hr(z = -z, n = events, ratio = r)

## -------------------------------------------------------
r <- 2
hr <- .8
z <- qnorm(.025)
events <- (z * (1 + r) / log(hr))^2 / r
events

## -------------------------------------------------------
hrz2n(hr = hr, z = z, ratio = r)

## -------------------------------------------------------
r <- 1 # Experimental/control randomization ratio
alpha <- 0.025 # 1-sided Type I error
beta <- 0.1 # Type II error (1 - power)
hr <- 0.7 # Hazard ratio (experimental / control)
controlMedian <- 8
dropoutRate <- 0.001 # Exponential dropout rate per time unit
enrollDuration <- 12
minfup <- 16 # Minimum follow-up
Nlf <- nSurv(
  lambdaC = log(2) / controlMedian,
  hr = hr,
  eta = dropoutRate,
  T = enrollDuration + minfup, # Trial duration
  minfup = minfup,
  ratio = r,
  alpha = alpha,
  beta = beta
)
cat(paste("Sample size: ", ceiling(Nlf$n), "Events: ", ceiling(Nlf$d), "\n"))

## -------------------------------------------------------
lambda1 <- log(2) / controlMedian
nSurvival(
  lambda1 = lambda1,
  lambda2 = lambda1 * hr,
  Ts = enrollDuration + minfup,
  Tr = enrollDuration,
  eta = dropoutRate,
  ratio = r,
  alpha = alpha,
  beta = beta
)

## -------------------------------------------------------
k <- 2 # Total number of analyses
lfgs <- gsSurv(
  k = 2,
  lambdaC = log(2) / controlMedian,
  hr = hr,
  eta = dropoutRate,
  T = enrollDuration + minfup, # Trial duration
  minfup = minfup,
  ratio = r,
  alpha = alpha,
  beta = beta
) |> toInteger()
lfgs |>
  gsBoundSummary() |>
  kable(row.names = FALSE)

## -------------------------------------------------------
events <- lfgs$n.I
z <- lfgs$upper$bound
zn2hr(z = z, n = events) # Schoenfeld approximation to HR

## ----fig.asp=1------------------------------------------
plot(lfgs, pl = "hr", dgt = 2, base = TRUE)

## -------------------------------------------------------
tibble::tibble(
  Analysis = 1:2,
  `Control events` = lfgs$eDC,
  `Experimental events` = lfgs$eDE
) |>
  kable()

## ----fig.asp=1------------------------------------------
Month <- seq(0.025, enrollDuration + minfup, .025)
plot(
  c(0, Month),
  c(0, sapply(Month, function(x) {
    nEventsIA(tIA = x, x = lfgs)
  })),
  type = "l", xlab = "Month", ylab = "Expected events",
  main = "Expected event accrual over time"
)

## -------------------------------------------------------
b <- tEventsIA(x = lfgs, timing = 0.25)
cat(paste(
  " Time: ", round(b$T, 1),
  "\n Expected enrollment:", round(b$eNC + b$eNE, 1),
  "\n Expected control events:", round(b$eDC, 1),
  "\n Expected experimental events:", round(b$eDE, 1), "\n"
))


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

## ----warning=FALSE, message=FALSE-----------------------
library(gsDesign)

## -------------------------------------------------------
b <- binomialSPRT(p0 = .1, p1 = .35, alpha = .08, beta = .2, minn = 10, maxn = 25)
plot(b)

## ----warning=FALSE, message=FALSE-----------------------
library(ggplot2)

## -------------------------------------------------------
p <- plot(b, plottype = 2)
p + scale_y_continuous(breaks = seq(0, 90, 10))

## -------------------------------------------------------
# Compute boundary crossing probabilities for selected response rates
b_power <- gsBinomialExact(
  k = length(b$n.I), theta = seq(.1, .45, .05), n.I = b$n.I,
  a = b$lower$bound, b = b$upper$bound
)

## -------------------------------------------------------
b_power |>
  as_table() |>
  as_gt()

## -------------------------------------------------------
safety_design <- binomialSPRT(p0 = .04, p1 = .1, alpha = .04, beta = .2, minn = 4, maxn = 75)
plot(safety_design)

## -------------------------------------------------------
plot(safety_design, plottype = 2)

## -------------------------------------------------------
safety_power <- gsBinomialExact(
  k = length(safety_design$n.I),
  theta = seq(.02, .16, .02),
  n.I = safety_design$n.I,
  a = safety_design$lower$bound,
  b = safety_design$upper$bound
)
safety_power |>
  as_table() |>
  as_gt(
    theta_label = gt::html("Underlying<br>AE rate"),
    prob_decimals = 3,
    bound_label = c("low rate", "high rate")
  )


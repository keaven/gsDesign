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
library(gt)

## -------------------------------------------------------
pi1 <- .7
ratio <- 3
p1 <- ratio / (ratio + 1 / (1 - pi1))
p1

## -------------------------------------------------------
1 - 1 / (ratio * (1 / p1 - 1))

## -------------------------------------------------------
pi0 <- .3
p0 <- ratio / (ratio + 1 / (1 - pi0))
p0

## -------------------------------------------------------
ve <- c(.5, .6, .65, .7, .75, .8)
prob_experimental <- ratio / (ratio + 1 / (1 - ve))
tibble::tibble(VE = ve, "P(Experimental)" = prob_experimental) |>
  gt() |>
  tab_options(data_row.padding = px(1)) |>
  fmt_number(columns = 2, decimals = 3)

## -------------------------------------------------------
alpha <- 0.025 # Type I error
beta <- 0.1 # Type II error (1 - power)
k <- 3 # number of analyses in group sequential design
timing <- c(.45, .7) # Relative timing of interim analyses compared to final
sfu <- sfHSD # Efficacy bound spending function (Hwang-Shih-DeCani)
sfupar <- -3 # Parameter for efficacy spending function
sfl <- sfHSD # Futility bound spending function (Hwang-Shih-DeCani)
sflpar <- -3 # Futility bound spending function parameter
timename <- "Month" # Time unit
failRate <- .002 # Exponential failure rate
dropoutRate <- .0001 # Exponential dropout rate
enrollDuration <- 8 # Enrollment duration
trialDuration <- 24 # Planned trial duration
VE1 <- .7 # Alternate hypothesis vaccine efficacy
VE0 <- .3 # Null hypothesis vaccine efficacy
ratio <- 3 # Experimental/Control enrollment ratio
test.type <- 4 # 1 for one-sided, 4 for non-binding futility

## -------------------------------------------------------
# Derive Group Sequential Design
# This determines final sample size
x <- gsSurv(
  k = k, test.type = test.type, alpha = alpha, beta = beta, timing = timing,
  sfu = sfu, sfupar = sfupar, sfl = sfl, sflpar = sflpar,
  lambdaC = failRate, eta = dropoutRate,
  # Translate vaccine efficacy to HR
  hr = 1 - VE1, hr0 = 1 - VE0,
  R = enrollDuration, T = trialDuration,
  minfup = trialDuration - enrollDuration, ratio = ratio
)

## -------------------------------------------------------
xx <- toInteger(x)
gsBoundSummary(xx,
  tdigits = 1, logdelta = TRUE, deltaname = "HR", Nname = "Events",
  exclude = c("B-value", "CP", "CP H1", "PP")
) |>
  gt() |>
  tab_header(
    title = "Initial group sequential approximation",
    subtitle = "Integer event counts at analyses"
  ) |>
  tab_options(data_row.padding = px(1))

## ----results='asis'-------------------------------------
cat(summary(xx, timeunit = "months"))

## -------------------------------------------------------
xb <- toBinomialExact(x)

## ----echo = FALSE---------------------------------------
# Function to print summary table for VE design
veTable <- function(xbDesign, tteDesign, ve) {
  # Analysis, N, Time, Total Cases, Success(Cases, VE, VE lower CI, Spend), Futility (Cases, VE, Spend), Type I Error, Power table
  ratio <- tteDesign$ratio
  prob_experimental <- ratio / (ratio + 1 / (1 - ve))
  power_table <- gsBinomialExact(
    k = xbDesign$k, theta = prob_experimental,
    n.I = xbDesign$n.I, a = xbDesign$lower$bound,
    b = xbDesign$upper$bound
  )$lower$prob
  # Cumulative sum within rows
  power_table <- apply(power_table, 2, cumsum)
  colnames(power_table) <- paste(ve * 100, "%", sep = "")
  out_tab <- tibble::tibble(
    Analysis = 1:tteDesign$k,
    Time = tteDesign$T,
    N = as.vector(round(tteDesign$eNC + tteDesign$eNE)),
    Cases = xbDesign$n.I,
    Success = xb$lower$bound,
    Futility = xb$upper$bound,
    ve_efficacy = 1 - 1 / (ratio * (xbDesign$n.I / xbDesign$lower$bound - 1)), # Efficacy bound
    ve_futility = 1 - 1 / (ratio * (xbDesign$n.I / xbDesign$upper$bound - 1)), # Futility bound
    alpha = as.vector(cumsum(
      gsBinomialExact(
        k = k, theta = xbDesign$theta[1], n.I = xbDesign$n.I,
        a = xbDesign$lower$bound, b = xbDesign$n.I + 1
      )$lower$prob
    )),
    beta = as.vector(cumsum(xbDesign$upper$prob[, 2]))
  )
  out_tab <- cbind(out_tab, power_table)
}

## ----echo=FALSE-----------------------------------------
veTable(xb, x, ve) |>
  gt() |>
  fmt_number(columns = 2, decimals = 1) |>
  fmt_number(columns = c(7:8, 11:16), decimals = 2) |>
  fmt_number(columns = 9:10, decimals = 4) |>
  tab_spanner(label = "Experimental Cases at Bound", columns = 5:6, id = "cases") |>
  tab_spanner(label = "Power by Vaccine Efficacy", columns = 11:16, id = "power") |>
  tab_spanner(label = "Error Spending", columns = 9:10, id = "spend") |>
  tab_spanner(label = "Vaccine Efficacy at Bound", columns = 7:8, id = "vebound") |>
  cols_label(
    ve_efficacy = "Efficacy",
    ve_futility = "Futility"
  ) |>
  tab_footnote(
    footnote = "Cumulative spending at each analysis",
    locations = cells_column_spanners(spanners = "spend")
  ) |>
  tab_footnote(
    footnote = "Experimental case counts to cross between success and futility counts do not stop trial",
    locations = cells_column_spanners(spanners = "cases")
  ) |>
  tab_footnote(
    footnote = "Exact vaccine efficacy required to cross bound",
    locations = cells_column_spanners(spanners = "vebound")
  ) |>
  tab_footnote(
    footnote = "Cumulative power at each analysis by underlying vaccine efficacy",
    locations = cells_column_spanners(spanners = "power")
  ) |>
  tab_footnote(
    footnote = "alpha-spending for efficacy ignores non-binding futility bound",
    location = cells_column_labels(columns = alpha)
  ) |>
  tab_header("Design Bounds and Operating Characteristics")

## -------------------------------------------------------
efficacyNominalPValue <- pnorm(-xx$upper$bound)
efficacyNominalPValue

## -------------------------------------------------------
qbinom(p = efficacyNominalPValue, size = xx$n.I, prob = p0) - 1

## -------------------------------------------------------
xb$lower$bound

## -------------------------------------------------------
xb$init_approx$a
xb$init_approx$b

## -------------------------------------------------------
xb$upper$bound

## -------------------------------------------------------
# Exact design cumulative alpha-spending at efficacy bounds
# (non-binding)
nb <- gsBinomialExact(k = xb$k, theta = xb$theta, n.I = xb$n.I, b= xb$n.I + 1, a = xb$lower$bound)
cumsum(nb$lower$prob[,1])
# Targeted alpha-spending
xx$upper$sf(alpha, t = xx$timing, xx$upper$param)$spend

## -------------------------------------------------------
# Check that increasing any bound goes above cumulative spend
excess_alpha_spend <- matrix(0, nrow = nb$k, ncol=nb$k)
for(i in 1:xb$k){
  a <- xb$lower$bound
  a[i] <- a[i] + 1
  excess_alpha_spend[i,] <-
    cumsum(gsBinomialExact(k = xb$k, theta = xb$theta, n.I = xb$n.I, b= xb$n.I + 1, a = a)$lower$prob[,1])
}
excess_alpha_spend

## -------------------------------------------------------
# Cumulative beta-spending for exact design
cumsum(xb$upper$prob[,2])

## -------------------------------------------------------
# Targeted beta-spending
xx$lower$sf(beta, t = xx$timing, xx$lower$param)$spend

## -------------------------------------------------------
# Check that increasing any bound goes above cumulative spend
excess_beta_spend <- matrix(0, nrow = nb$k - 1, ncol=nb$k)
for(i in 1:(xb$k - 1)){
  b <- xb$upper$bound
  b[i] <- b[i] - 1
  excess_beta_spend[i,] <-
    cumsum(as.numeric(gsBinomialExact(k = xb$k, theta = xb$theta, n.I = xb$n.I, b = b, a = xb$lower$bound)$upper$prob[,2]))
}
excess_beta_spend

## -------------------------------------------------------
ebUpdate <- toBinomialExact(xx, observedEvents = c(20, 78))

## ----echo = FALSE---------------------------------------
  ve <- c(.65, .75, .85)
  # Analysis, Total Cases, Success(Cases, VE, VE lower CI, Spend), Futility (Cases, VE, Spend), Type I Error, Power table
  ratio <- xx$ratio
  prob_experimental <- ratio / (ratio + 1 / (1 - ve))
  power_table <- gsBinomialExact(
    k = ebUpdate$k, theta = prob_experimental,
    n.I = ebUpdate$n.I, a = ebUpdate$lower$bound,
    b = ebUpdate$upper$bound
  )$lower$prob
  # Cumulative sum within rows
  power_table <- apply(power_table, 2, cumsum)
  colnames(power_table) <- paste(ve * 100, "%", sep = "")
  out_tab <- tibble::tibble(
    Analysis = 1:ebUpdate$k,
    Cases = ebUpdate$n.I,
    Success = ebUpdate$lower$bound,
    Futility = ebUpdate$upper$bound,
    ve_efficacy = 1 - 1 / (ratio * (ebUpdate$n.I / ebUpdate$lower$bound - 1)), # Efficacy bound
    ve_futility = 1 - 1 / (ratio * (ebUpdate$n.I / ebUpdate$upper$bound - 1)), # Futility bound
    alpha = as.vector(cumsum(
      gsBinomialExact(
        k = ebUpdate$k, theta = ebUpdate$theta[1], n.I = ebUpdate$n.I,
        a = ebUpdate$lower$bound, b = ebUpdate$n.I + 1
      )$lower$prob
    )),
    beta = as.vector(cumsum(ebUpdate$upper$prob[, 2]))
  )
  out_tab <- cbind(out_tab, power_table)
  out_tab |> gt() |>
  fmt_number(columns = c(5:6, 9:11), decimals = 2) |>
  fmt_number(columns = 7:8, decimals = 4) |>
  tab_spanner(label = "Cases at Bound", columns = 3:4, id = "cases") |>
  tab_spanner(label = "Power by VE", columns = 9:11, id = "power") |>
  tab_spanner(label = "Error Spending", columns = 7:8, id = "spend") |>
  tab_spanner(label = "VE at Bound", columns = 5:6, id = "vebound") |>
  cols_label(
    ve_efficacy = "Efficacy",
    ve_futility = "Futility"
  ) |>
  tab_footnote(
    footnote = "Cumulative spending at each analysis",
    locations = cells_column_spanners(spanners = "spend")
  ) |>
  tab_footnote(
    footnote = "Experimental case counts; counts between success and futility bounds do not stop trial",
    locations = cells_column_spanners(spanners = "cases")
  ) |>
  tab_footnote(
    footnote = "Exact vaccine efficacy required to cross bound",
    locations = cells_column_spanners(spanners = "vebound")
  ) |>
  tab_footnote(
    footnote = "Cumulative power at each analysis by underlying vaccine efficacy",
    locations = cells_column_spanners(spanners = "power")
  ) |>
  tab_footnote(
    footnote = "Efficacy spending ignores non-binding futility bound",
    location = cells_column_labels(columns = alpha)
  ) |>
  tab_header(title = "Updated Bounds for Actual Analyses from SPUTNIK trial")


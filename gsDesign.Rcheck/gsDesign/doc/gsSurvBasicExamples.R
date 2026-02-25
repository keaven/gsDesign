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

## -------------------------------------------------------
# Median control time-to-event
median <- 12
# Exponential dropout rate per unit of time
eta <- .001
# Hypothesized experimental/control hazard ratio
# (alternate hypothesis)
hr <- .75
# Null hazard ratio (1 for superiority, >1 for non-inferiority)
hr0 <- 1
# Type I error (1-sided)
alpha <- .025
# Type II error (1-power)
beta <- .1

## ----message=FALSE--------------------------------------
# Study duration
T <- 36
# Follow-up duration of last patient enrolled
minfup <- 12
# Enrollment period durations
R <- c(1, 2, 3, 4)
# Relative enrollment rates during above periods
gamma <- c(1, 1.5, 2.5, 4)
# Randomization ratio, experimental/control
ratio <- 1

## ----warning=FALSE, message=FALSE-----------------------
library(gsDesign)

x <- nSurv(
  R = R,
  gamma = gamma,
  eta = eta,
  minfup = minfup,
  T = T,
  lambdaC = log(2) / median,
  hr = hr,
  hr0 = hr0,
  beta = beta,
  alpha = alpha
)

## -------------------------------------------------------
x

## ----eval=FALSE-----------------------------------------
# # THIS CODE IS EXAMPLE ONLY; NOT EXECUTED HERE
# nSurv(
#   R = R,
#   gamma = gamma,
#   eta = eta,
#   minfup = minfup,
#   T = NULL, # This was changed
#   lambdaC = log(2) / median,
#   hr = hr,
#   hr0 = hr0,
#   beta = beta,
#   alpha = alpha
# )

## -------------------------------------------------------
# Number of analyses (interim + final)
k <- 3
# Timing of interim analyses (k-1 increasing numbers >0 and <1).
# Proportion of final events at each interim.
timing <- c(.25, .75)
# Efficacy bound spending function.
# We use Lan-DeMets spending function approximating O'Brien-Fleming bound.
# No parameter required for this spending function.
sfu <- sfLDOF
sfupar <- NULL
# Futility bound spending function
sfl <- sfHSD
# Futility bound spending parameter specification
sflpar <- -7

## -------------------------------------------------------
# Type II error = 1 - Power
beta <- .15

## -------------------------------------------------------
# Generate design
x <- gsSurv(
  k = k, timing = timing, R = R, gamma = gamma, eta = eta,
  minfup = minfup, T = T, lambdaC = log(2) / median,
  hr = hr, hr0 = hr0, beta = beta, alpha = alpha,
  sfu = sfu, sfupar = sfupar, sfl = sfl, sflpar = sflpar
)

## ----results="asis"-------------------------------------
cat(summary(x))

## ----warning=FALSE--------------------------------------
library(gt)
library(tibble)

tibble(
  Period = paste("Month", rownames(x$gamma)),
  Rate = as.numeric(x$gamma)
) |>
  gt() |>
  tab_header(title = "Enrollment rate requirements")

## -------------------------------------------------------
# Footnote text for table
footnote1 <- "P{Cross} is the probability of crossing the given bound (efficacy or futility) at or before the given analysis under the assumed hazard ratio (HR)."
footnote2 <- " Design assumes futility bound is discretionary (non-binding); upper boundary crossing probabilities shown here assume trial stops at first boundary crossed and thus total less than the design Type I error."
footnoteHR <- "HR presented is not a requirement, but an estimate of approximately what HR would be required to cross each bound."
footnoteM <- "Month is approximated given enrollment and event rate assumptions under alternate hypothesis."

# Spending function footnotes
footnoteUS <- "Efficacy bound set using Lan-DeMets spending function approximating an O'Brien-Fleming bound."
footnoteLS <- paste(
  "Futility bound set using ", x$lower$name, " beta-spending function with ",
  x$lower$parname, "=", x$lower$param, ".",
  sep = ""
)

# Caption text for table
caption <- paste(
  "Overall survival trial design with HR=", hr, ", ",
  100 * (1 - beta), "% power and ",
  100 * alpha, "% Type I error",
  sep = ""
)

## ----echo=TRUE, message=FALSE---------------------------
gsBoundSummary(x) |>
  gt() |>
  tab_header(title = "Time-to-event group sequential design") |>
  cols_align("left") |>
  tab_footnote(footnoteUS, locations = cells_column_labels(columns = 3)) |>
  tab_footnote(footnoteLS, locations = cells_column_labels(columns = 4)) |>
  tab_footnote(footnoteHR, locations = cells_body(columns = 2, rows = c(3, 8, 13))) |>
  tab_footnote(footnoteM, locations = cells_body(columns = 1, rows = c(4, 9, 14))) |>
  tab_footnote(footnote1, locations = cells_body(columns = 2, rows = c(4, 5, 9, 10, 14, 15))) |>
  tab_footnote(footnote2, locations = cells_body(columns = 2, rows = c(4, 9, 14)))

## ----warning=FALSE, message=FALSE-----------------------
library(ggplot2)
library(scales)

plot(x, plottype = "power", cex = .8, xlab = "HR") +
  scale_y_continuous(labels = scales::percent)

## -------------------------------------------------------
# Number of events (final is still planned number)
n.I <- c(115, 364, ceiling(x$n.I[x$k]))

## -------------------------------------------------------
xu <- gsDesign(
  alpha = x$alpha, beta = x$beta, test.type = x$test.type,
  maxn.IPlan = x$n.I[x$k], n.I = n.I,
  sfu = sfu, sfupar = sfupar, sfl = sfl, sflpar = sflpar,
  delta = x$delta, delta1 = x$delta1, delta0 = x$delta0
)

## -------------------------------------------------------
gsBoundSummary(
  xu,
  deltaname = "HR",
  logdelta = TRUE,
  Nname = "Events",
  exclude = c(
    "Spending", "B-value", "CP", "CP H1",
    "PP", "P(Cross) if HR=1", "P(Cross) if HR=0.75"
  )
) |>
  gt() |>
  cols_align("left") |>
  tab_header(
    title = "Time-to-event group sequential bound guidance",
    subtitle = "Bounds updated based on event counts through IA2"
  ) |>
  tab_footnote(
    "Nominal p-value required to establish statistical significance.",
    locations = cells_body(columns = 3, rows = c(2, 5, 8))
  ) |>
  tab_footnote(
    "Interim futility guidance based on observed HR is non-binding.",
    locations = cells_body(columns = 4, rows = c(3, 6))
  ) |>
  tab_footnote(
    "HR bounds are approximations; decisions on crossing are based solely on p-values.",
    locations = cells_body(column = 2, rows = c(3, 6, 9))
  )

## -------------------------------------------------------
Z <- c(0.25, 2)

## -------------------------------------------------------
gsCP(
  x = xu, # Updated design
  i = 2, # Interim analysis 2
  zi = Z[2] # Observed Z-value for testing
)$upper$prob

## -------------------------------------------------------
prior <- normalGrid(
  mu = x$delta / 2,
  sigma = sqrt(20 / max(x$n.I))
)
cat(paste(
  " Prior mean:", round(x$delta / 2, 3),
  "\n Prior standard deviation", round(sqrt(20 / x$n.fix), 3), "\n"
))

## -------------------------------------------------------
gsPP(
  x = xu, # Updated design
  i = 2, # Interim analysis 2
  zi = Z[2], # Observed Z-value for testing
  theta = prior$z, # Grid points for above prior
  wgts = prior$wgts # Weights for averaging over grid
)

## ----fig.asp=1------------------------------------------
maxx <- 450 # Max for x-axis specified by user
ylim <- c(-1, 3) # User-specified y-axis limits
analysis <- 2 # Current analysis specified by user
# Following code should require no further changes
plot(
  xu,
  plottype = "B", base = TRUE, xlim = c(0, maxx), ylim = ylim, main = "B-value projection",
  lty = 1, col = 1:2, xlab = "Events"
)
N <- c(0, xu$n.I[1:analysis])
B <- c(0, Z * sqrt(xu$timing[1:analysis]))
points(x = N, y = B, col = 4)
lines(x = N, y = B, col = 4)
slope <- B[analysis + 1] / N[analysis + 1]
Nvals <- c(N[analysis + 1], max(xu$n.I))
lines(
  x = Nvals,
  y = B[analysis + 1] + c(0, slope * (Nvals[2] - Nvals[1])),
  col = 4,
  lty = 2
)


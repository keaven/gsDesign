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

## ----message = FALSE, warning = FALSE-------------------
library(gsDesign)
library(ggplot2)
library(tidyr)
library(gt)
library(dplyr)

## -------------------------------------------------------
nBinomial(p1 = 0.2, p2 = 0.1, ratio = 2, alpha = 0.025, beta = 0.15) |> ceiling()
nBinomial(p1 = 0.1, p2 = 0.2, ratio = 0.5, alpha = 0.025, beta = 0.15) |> ceiling()

## -------------------------------------------------------
scale <- c("Difference", "RR", "OR")
tibble(scale, "Sample size" = c(
  nBinomial(p1 = 0.2, p2 = 0.1, ratio = 0.5, alpha = 0.025, beta = 0.15, scale = scale[1]) |> ceiling(),
  nBinomial(p1 = 0.2, p2 = 0.1, ratio = 0.5, alpha = 0.025, beta = 0.15, scale = scale[2]) |> ceiling(),
  nBinomial(p1 = 0.2, p2 = 0.1, ratio = 0.5, alpha = 0.025, beta = 0.15, scale = scale[3]) |> ceiling()
)) |>
  gt() |>
  tab_header("Sample size by scale for a superiority design",
    subtitle = "alpha = 0.025, beta = 0.15, pE = 0.2, pC = 0.1"
  )

## -------------------------------------------------------
testBinomial(x1 = 20, n1 = 30, x2 = 10, n2 = 30)
testBinomial(x1 = 20, n1 = 30, x2 = 10, n2 = 30, scale = "RR")
testBinomial(x1 = 20, n1 = 30, x2 = 10, n2 = 30, scale = "OR")

## -------------------------------------------------------
testBinomial(x1 = 10, n1 = 30, x2 = 20, n2 = 30)

## -------------------------------------------------------
testBinomial(x1 = 10, n1 = 30, x2 = 20, n2 = 30) |> pnorm(lower.tail = TRUE)
testBinomial(x1 = 10, n1 = 30, x2 = 20, n2 = 30, adj = 1) |> pnorm(lower.tail = TRUE)
testBinomial(x1 = 10, n1 = 30, x2 = 20, n2 = 30, chisq = 1) |>
  pchisq(df = 1, lower.tail = FALSE) / 2

## -------------------------------------------------------
p1 <- 20 / 30
p2 <- 10 / 30
rd <- p1 - p2
rr <- p1 / p2
orr <- (p1 * (1 - p2)) / (p2 * (1 - p1))

rbind(
  ciBinomial(x1 = 20, n1 = 30, x2 = 10, n2 = 30),
  ciBinomial(x1 = 20, n1 = 30, x2 = 10, n2 = 30, scale = "RR"),
  ciBinomial(x1 = 20, n1 = 30, x2 = 10, n2 = 30, scale = "OR")
) |>
  mutate(
    scale = c("Risk difference", "Risk-ratio", "Odds-ratio"),
    Effect = c(rd, rr, orr)
  ) |>
  gt() |>
  tab_header("Confidence intervals for a binomial effect size",
    subtitle = "x1 = 20, n1 = 30, x2 = 10, n2 = 30"
  ) |>
  fmt_number(columns = c(lower, upper, Effect), n_sigfig = 3)

## -------------------------------------------------------
ciBinomial(x1 = 10, n1 = 30, x2 = 20, n2 = 30)

## -------------------------------------------------------
tibble(
  Design = c("Superiority", "Non-inferiority", "Super-superiority"),
  `p1 (pE)` = c(0.2, 0.2, 0.2),
  `p2 (pC)` = c(0.1, 0.1, 0.1),
  `delta0` = c(0, -0.02, 0.02),
  `Sample size` = c(
    ceiling(nBinomial(p1 = 0.2, p2 = 0.1, alpha = 0.025, beta = 0.15, ratio = 0.5)),
    ceiling(nBinomial(p1 = 0.2, p2 = 0.1, alpha = 0.025, beta = 0.15, ratio = 0.5, delta0 = -0.02)),
    ceiling(nBinomial(p1 = 0.2, p2 = 0.1, alpha = 0.025, beta = 0.15, ratio = 0.5, delta0 = 0.02))
  )
) |>
  gt() |>
  tab_header("Sample size for binomial two arm trial design",
    subtitle = "alpha = 0.025, beta = 0.15"
  ) |>
  fmt_number(columns = c(`p1 (pE)`, `p2 (pC)`), decimals = 2) |>
  cols_label(
    Design = "Design",
    `p1 (pE)` = "Experimental group rate",
    `p2 (pC)` = "Control group rate",
    delta0 = "Null hypothesis value of rate difference (delta0)",
    `Sample size` = "Sample size"
  ) |>
  tab_footnote("Randomization ratio is 2:1 (Experimental:Control) with assumed control failure rate p1 = 0.2 and experimental rate 0.1.")

## -------------------------------------------------------
testBinomial(x1 = 18, n1 = 30, x2 = 10, n2 = 30, delta0 = 0) # superiority
testBinomial(x1 = 18, n1 = 30, x2 = 10, n2 = 30, delta0 = -0.02) # non-inferiority
testBinomial(x1 = 18, n1 = 30, x2 = 10, n2 = 30, delta0 = 0.02) # super-superiority
ciBinomial(x1 = 18, n1 = 30, x2 = 10, n2 = 30) # CI

## -------------------------------------------------------
simBinomial(p1 = 0.2, p2 = 0.1, n1 = 30, n2 = 30, nsim = 10)

## -------------------------------------------------------
z <- simBinomial(p1 = 0.15, p2 = 0.15, n1 = 30, n2 = 30, nsim = 1000000)
mean(z > qnorm(0.975)) # Type I error rate

## -------------------------------------------------------
zcut <- quantile(z, 0.975)
tibble("Z cutoff" = zcut, "p cutoff" = pnorm(zcut, lower.tail = FALSE)) |>
  gt() |>
  fmt_number(columns = c("Z cutoff", "p cutoff"), n_sigfig = 3) |>
  tab_header("Exact cutoff for Type I error rate",
    subtitle = "Based on 1 million simulations"
  ) |>
  tab_footnote("The Z cutoff is the quantile of the simulated Z-values at 0.975 using p1 = p2 = 0.15.")

## -------------------------------------------------------
z <- simBinomial(p1 = 0.2, p2 = 0.1, n1 = 30, n2 = 30, nsim = 1000000)
cat("Power with asymptotic cutoff ", mean(z > qnorm(0.975)))
cat("\nPower with exact cutoff", mean(z > zcut))

## -------------------------------------------------------
ptab <- tibble(
  Scale = c("Risk-difference", "Odds-ratio"),
  n = c(525, 489),
  Power = c(
    mean(simBinomial(p1 = 0.2, p2 = 0.1, n1 = 525 / 3, n2 = 525 * 2 / 3, nsim = 100000) > qnorm(0.975)),
    mean(simBinomial(p1 = 0.2, p2 = 0.1, n1 = 489 / 3, n2 = 489 * 2 / 3, nsim = 100000) > qnorm(0.975))
  )
)
ptab |>
  gt() |>
  tab_header("Simulation power for sample size based on risk-difference and odds-ratio",
    subtitle = "pE = 0.2, pC = 0.1, alpha = 0.025, beta = 0.15"
  ) |>
  fmt_number(columns = c(n, Power), n_sigfig = 3) |>
  cols_label(Scale = "Scale", n = "Sample size", Power = "Power") |>
  tab_footnote("Power based on 100,000 simulated trials and nominal alpha = 0.025 test; 2 x simulation error = 0.002") |>
  tab_footnote("Power based on Z-test for risk-difference with no continuity correction.", location = cells_column_labels("Power"))

## -------------------------------------------------------
binomialPowerTable(
  pC = seq(0.1, 0.2, 0.02), delta = 0, delta0 = 0, n = 70, failureEndpoint = TRUE,
  ratio = 1, alpha = 0.025, simulation = TRUE, nsim = 1e6, adj = 0
) |>
  rename("Type I error" = "Power") |>
  gt() |>
  fmt_number(columns = "Type I error", n_sigfig = 3) |>
  tab_header("Type I error is not controlled with nominal p = 0.025 cutoff")

## -------------------------------------------------------
binomialPowerTable(
  pC = seq(0.1, 0.2, 0.02), delta = 0, delta0 = 0, n = 70, failureEndpoint = TRUE,
  ratio = 1, alpha = 0.023, simulation = TRUE, nsim = 1e6, adj = 0
) |>
  rename("Type I error" = "Power") |>
  gt() |>
  fmt_number(columns = "Type I error", n_sigfig = 3) |>
  tab_header("Type I error is controlled at 0.025 with nominal p = 0.023 cutoff")

## -------------------------------------------------------
power_table_asymptotic <- binomialPowerTable(
  pC = seq(0.1, 0.2, 0.025),
  delta = seq(0.15, 0.25, 0.02),
  n = 70,
  ratio = 1,
  alpha = 0.023
)

## -------------------------------------------------------
power_table_simulation <- binomialPowerTable(
  pC = seq(0.1, 0.2, 0.025),
  delta = seq(0.15, 0.25, 0.02),
  n = 70,
  ratio = 1,
  alpha = 0.023,
  simulation = TRUE,
  nsim = 1000000
)

## -------------------------------------------------------
rbind(
  power_table_asymptotic |> mutate(Method = "Asymptotic"),
  power_table_simulation |> mutate(Method = "Simulation")
) |>
  ggplot(aes(x = delta, y = Power, color = factor(pC), lty = Method)) +
  geom_line() +
  labs(x = "Treatment effect (delta)", y = "Power", color = "Control rate") +
  scale_color_brewer(palette = "Set1") +
  theme_minimal() +
  theme(legend.position = "bottom") +
  # Grid points on the x-axis at 0.05 intervals
  scale_x_continuous(breaks = seq(0.15, 0.25, by = 0.05)) +
  # Put y-axis scale on percent scale
  scale_y_continuous(
    labels = scales::percent_format(accuracy = 1),
    breaks = seq(0.2, 0.8, by = 0.2)
  ) +
  coord_cartesian(ylim = c(0.2, 0.8)) +
  ggtitle("Power for Binomial Two Arm Trial Design with n = 70")

## -------------------------------------------------------
# Transform table with values from Power to a wide format with
# Put "Control group rate" (pC) in rows and Treatment effect (delta) in columns
# Put a spanner label over columns after first column with label "Treatment effect (delta)"
power_table_simulation |>
  select(-pE) |>
  tidyr::pivot_wider(
    names_from = delta,
    values_from = Power
  ) |>
  dplyr::rename(`Control group rate` = pC) |>
  gt::gt() |>
  gt::tab_spanner(
    label = "Treatment effect (delta)",
    columns = 2:7
  ) |>
  gt::fmt_percent(decimals = 1) |>
  gt::tab_header("Power by Control Group Rate and Treatment Effect")


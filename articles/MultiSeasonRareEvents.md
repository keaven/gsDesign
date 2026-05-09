# Multi-season studies for rare events

``` r

library(gsDesign)
library(gt)
library(tibble)
```

## Introduction

This vignette demonstrates a practical design workflow for rare seasonal
events. The motivating use case is a vaccine efficacy trial with annual
high-risk seasons. The same ideas can be adapted to infectious disease
studies where simple superiority or non-inferiority may be considered.

We focus on exact binomial monitoring with spending functions:

- analyses after each season with spending times `1/3, 2/3, 1`,
- efficacy spending based on `sfHSD` with `gamma = 1` (Pocock-like),
- exact binomial p-values from
  [`repeatedPValueBinomialExact()`](https://keaven.github.io/gsDesign/reference/repeatedPValueBinomialExact.md)
  and
  [`sequentialPValueBinomialExact()`](https://keaven.github.io/gsDesign/reference/sequentialPValueBinomialExact.md).

We include both a fixed group sequential design and a blinded
information-adaptive option that can increase future enrollment if
events accrue slowly. Conceptually, enrollment is concentrated in early
fall (for example, September and October), and each analysis uses a data
cut at the end of the corresponding high-risk season (for example, May
1).

## Assumptions and parameterization

We use a super-superiority example:

- null vaccine efficacy (VE) = 30% (`HR0 = 0.7`),
- alternative VE = 80% (`HR = 0.2`),
- one-sided `alpha = 0.025`, `beta = 0.1`,
- randomization ratio = 3:1 (experimental:control),
- control seasonal event rate = 0.3% over 6 months,
- dropout modeled as exponential with 10% dropout over each 6-month
  season.

``` r

alpha <- 0.025
beta <- 0.1
ratio <- 3

ve0 <- 0.30
ve1 <- 0.80
hr0 <- 1 - ve0
hr1 <- 1 - ve1

seasonal_event_rate_control <- 0.003
season_length_years <- 0.5
dropout_6mo <- 0.10

timing <- c(1 / 3, 2 / 3, 1)
```

For the exact binomial approximation, the probability that an event is
in the experimental group is

``` r

p_event_experimental <- function(ve, ratio = 3) {
  ratio / (ratio + 1 / (1 - ve))
}

p0 <- p_event_experimental(ve0, ratio)
p1 <- p_event_experimental(ve1, ratio)
c(p0 = p0, p1 = p1)
#>        p0        p1 
#> 0.6774194 0.3750000
```

## Initial group sequential setup

To define spending-function monitoring, we first construct a
time-to-event `gsSurv` object and then convert to integer event looks
and exact binomial bounds. Here we use three looks with timing fractions
`1/3, 2/3, 1`. Enrollment is modeled as 2 months on and 10 months off
each year for 3 years.

``` r

lambdaC <- -log(1 - seasonal_event_rate_control) / season_length_years
eta <- -log(1 - dropout_6mo) / season_length_years
enroll_pattern <- c(1, 0, 1, 0, 1, 0)
enroll_periods <- c(2, 10, 2, 10, 2, 10)

design_tte <- gsSurv(
  k = 3,
  test.type = 4,
  alpha = alpha,
  beta = beta,
  timing = timing[1:2],
  sfu = sfHSD,
  sfupar = 1,
  sfl = sfHSD,
  sflpar = -2,
  lambdaC = lambdaC,
  hr = hr1,
  hr0 = hr0,
  eta = eta,
  gamma = enroll_pattern,
  R = enroll_periods,
  T = 42,
  minfup = 6,
  ratio = ratio
) |>
  toInteger()

planned_final_events <- design_tte$n.I[design_tte$k]
planned_counts <- as.integer(round(planned_final_events * timing))
planned_counts[3] <- planned_final_events
planned_counts[2] <- max(planned_counts[2], planned_counts[1] + 1L)
planned_counts[3] <- max(planned_counts[3], planned_counts[2] + 1L)

design_exact <- toBinomialExact(design_tte, observedEvents = planned_counts)

planned_enrollment_period <- as.numeric(rowSums(as.matrix(design_tte$gamma))) * enroll_periods
season_id <- rep(1:3, each = 2)
planned_enrollment_by_season <- as.integer(round(tapply(planned_enrollment_period, season_id, sum)))
planned_enrollment_control <- as.integer(round(planned_enrollment_by_season / (1 + ratio)))
planned_enrollment_experimental <- planned_enrollment_by_season - planned_enrollment_control
```

The table below summarizes planned event looks and exact efficacy
bounds.

``` r

target_alpha_spend <- design_tte$upper$sf(
  alpha = alpha,
  t = timing,
  param = design_tte$upper$param
)$spend

achieved_alpha_spend <- cumsum(
  gsBinomialExact(
    k = design_exact$k,
    theta = design_exact$theta[1],
    n.I = design_exact$n.I,
    a = design_exact$lower$bound,
    b = design_exact$n.I + 1
  )$lower$prob[, 1]
)

achieved_power_h1 <- cumsum(
  gsBinomialExact(
    k = design_exact$k,
    theta = design_exact$theta[2],
    n.I = design_exact$n.I,
    a = design_exact$lower$bound,
    b = design_exact$n.I + 1
  )$lower$prob[, 1]
)

tibble(
  Season = 1:3,
  `Spending time` = timing,
  `Planned total events` = design_exact$n.I,
  `Exact efficacy bound (x <= a)` = design_exact$lower$bound,
  `Target cumulative alpha spend` = target_alpha_spend,
  `Achieved cumulative alpha spend` = achieved_alpha_spend,
  `Cumulative power under H1` = achieved_power_h1
) |>
  gt() |>
  fmt_number(columns = 2, decimals = 3) |>
  fmt_number(columns = 5:7, decimals = 4) |>
  tab_header(
    title = "Planned exact binomial seasonal monitoring",
    subtitle = "Super-superiority example with Pocock-like efficacy spending"
  )
```

| Planned exact binomial seasonal monitoring |  |  |  |  |  |  |
|----|----|----|----|----|----|----|
| Super-superiority example with Pocock-like efficacy spending |  |  |  |  |  |  |
| Season | Spending time | Planned total events | Exact efficacy bound (x \<= a) | Target cumulative alpha spend | Achieved cumulative alpha spend | Cumulative power under H1 |
| 1 | 0.333 | 12 | 3 | 0.0112 | 0.0030 | 0.2824 |
| 2 | 0.667 | 24 | 10 | 0.0192 | 0.0094 | 0.7469 |
| 3 | 1.000 | 36 | 18 | 0.0250 | 0.0244 | 0.9578 |

The next table gives planned enrollment/sample size by season and
overall.

``` r

enrollment_table <- tibble(
  Season = as.character(1:3),
  `Control planned enrollment` = planned_enrollment_control,
  `Experimental planned enrollment` = planned_enrollment_experimental
) |>
  dplyr::mutate(
    `Total planned enrollment` = `Control planned enrollment` + `Experimental planned enrollment`,
    `Cumulative planned enrollment` = cumsum(`Total planned enrollment`)
  )

dplyr::bind_rows(
  enrollment_table,
  tibble(
    Season = "Overall",
    `Control planned enrollment` = sum(enrollment_table$`Control planned enrollment`),
    `Experimental planned enrollment` = sum(enrollment_table$`Experimental planned enrollment`),
    `Total planned enrollment` = sum(enrollment_table$`Total planned enrollment`),
    `Cumulative planned enrollment` = sum(enrollment_table$`Total planned enrollment`)
  )
) |>
  gt() |>
  tab_header(title = "Planned enrollment by season and overall")
```

| Planned enrollment by season and overall |  |  |  |  |
|----|----|----|----|----|
| Season | Control planned enrollment | Experimental planned enrollment | Total planned enrollment | Cumulative planned enrollment |
| 1 | 269 | 808 | 1077 | 1077 |
| 2 | 269 | 808 | 1077 | 2154 |
| 3 | 269 | 808 | 1077 | 3231 |
| Overall | 807 | 2424 | 3231 | 3231 |

## Example repeated and sequential p-values

Suppose observed event totals at the three seasonal analyses are equal
to the planned totals and observed experimental events are as below.

``` r

example_x <- pmax(0, design_exact$lower$bound - c(0L, 1L, 0L))
example_p <- repeatedPValueBinomialExact(
  gsD = design_tte,
  n.I = design_exact$n.I,
  x = example_x
)
example_p
#>   Analysis n.I  x repeated_p_value
#> 1        1  12  3      0.006666324
#> 2        2  24  9      0.003251657
#> 3        3  36 18      0.024388104
#>   bound_at_repeated_p_value
#> 1                         3
#> 2                         9
#> 3                        18
```

The sequential p-value is the minimum repeated p-value:

``` r

sequentialPValueBinomialExact(
  gsD = design_tte,
  n.I = design_exact$n.I,
  x = example_x
)
#> [1] 0.003251657
```

## Seasonal event/dropout model for simulation

For each arm and season, we use a competing-risk approximation with
constant event and dropout hazards over 6 months:

- event before dropout,
- dropout before event,
- neither event nor dropout (carries into next season).

In the simulation, we add a new enrollment cohort each season to
represent annual enrollment windows.

``` r

seasonal_probs <- function(ve, lambda_c, eta, season_years = 0.5) {
  lambda_e <- lambda_c * (1 - ve)
  arm_probs <- function(lambda_event) {
    total <- lambda_event + eta
    p_event <- lambda_event / total * (1 - exp(-total * season_years))
    p_drop <- eta / total * (1 - exp(-total * season_years))
    p_stay <- exp(-total * season_years)
    c(event = p_event, dropout = p_drop, stay = p_stay)
  }
  list(control = arm_probs(lambda_c), experimental = arm_probs(lambda_e))
}

probs_alt <- seasonal_probs(ve = ve1, lambda_c = lambdaC, eta = eta)
probs_null <- seasonal_probs(ve = ve0, lambda_c = lambdaC, eta = eta)
```

To keep the simulation aligned with the planned final information, we
select a per-season enrollment target so expected total events under the
alternative are close to the planned final event count.

``` r

expected_events_3_seasons <- function(p_event, p_stay) {
  p_event * (3 + 2 * p_stay + p_stay^2)
}

f_control <- expected_events_3_seasons(
  p_event = probs_alt$control["event"],
  p_stay = probs_alt$control["stay"]
)
f_experimental <- expected_events_3_seasons(
  p_event = probs_alt$experimental["event"],
  p_stay = probs_alt$experimental["stay"]
)

enroll_control_per_season <- ceiling(planned_final_events / (f_control + ratio * f_experimental))
enroll_experimental_per_season <- ratio * enroll_control_per_season

tibble(
  Arm = c("Control", "Experimental"),
  `Enrolled each season` = c(enroll_control_per_season, enroll_experimental_per_season)
) |>
  gt() |>
  tab_header(title = "Simulation enrollment assumptions")
```

| Simulation enrollment assumptions |                      |
|-----------------------------------|----------------------|
| Arm                               | Enrolled each season |
| Control                           | 1410                 |
| Experimental                      | 4230                 |

## Fixed and adaptive simulation functions

The adaptive rule is intentionally simple and blinded:

- after season 1, increase season-2 enrollment if total events are below
  planned look-1 events,
- after season 2, optionally increase season-3 enrollment similarly,
- spending fractions remain fixed at `1/3, 2/3, 1`.

``` r

simulate_one_trial <- function(
    ve,
    adaptive = FALSE,
    max_multiplier = 2,
    lambda_c = lambdaC,
    eta_rate = eta,
    enroll_control = enroll_control_per_season,
    enroll_experimental = enroll_experimental_per_season) {
  probs <- seasonal_probs(ve = ve, lambda_c = lambda_c, eta = eta_rate)

  enroll_c <- rep(enroll_control, 3L)
  enroll_e <- rep(enroll_experimental, 3L)
  at_risk_c <- 0L
  at_risk_e <- 0L

  cum_total <- integer(3L)
  cum_exp <- integer(3L)

  for (season in 1:3) {
    if (adaptive && season == 2) {
      mult <- min(max_multiplier, max(1, planned_counts[1] / max(cum_total[1], 1)))
      enroll_c[2] <- as.integer(ceiling(enroll_control * mult))
      enroll_e[2] <- as.integer(ceiling(enroll_experimental * mult))
    }
    if (adaptive && season == 3) {
      mult <- min(max_multiplier, max(1, planned_counts[2] / max(cum_total[2], 1)))
      enroll_c[3] <- as.integer(ceiling(enroll_control * mult))
      enroll_e[3] <- as.integer(ceiling(enroll_experimental * mult))
    }

    at_risk_c <- at_risk_c + enroll_c[season]
    at_risk_e <- at_risk_e + enroll_e[season]

    out_c <- as.integer(rmultinom(1, at_risk_c, probs$control))
    out_e <- as.integer(rmultinom(1, at_risk_e, probs$experimental))

    inc_total <- out_c[1] + out_e[1]
    inc_exp <- out_e[1]

    cum_total[season] <- if (season == 1) inc_total else cum_total[season - 1] + inc_total
    cum_exp[season] <- if (season == 1) inc_exp else cum_exp[season - 1] + inc_exp

    at_risk_c <- out_c[3]
    at_risk_e <- out_e[3]
  }

  # Use analyses through the first look where cumulative events reach/exceed
  # planned final events, so only one look has spending time >= 1.
  reached_final <- which(cum_total >= planned_final_events)
  looks <- if (length(reached_final) == 0) 1:3 else seq_len(reached_final[1])
  informative <- looks[cum_total[looks] > 0]
  if (length(informative) > 1) {
    informative <- informative[c(TRUE, diff(cum_total[informative]) > 0)]
  }

  if (length(informative) == 0) {
    return(list(reject = FALSE, looks = length(looks), total_events = cum_total[3]))
  }

  # Internal helper is used only for vignette simulation speed.
  bounds_at_alpha <- gsDesign:::binomialExactLowerBound(
    gsD = design_tte,
    n.I = cum_total[informative],
    alpha = alpha
  )
  reject <- any(cum_exp[informative] <= bounds_at_alpha)
  total_enrolled <- sum(enroll_c + enroll_e)

  list(
    reject = reject,
    looks = length(informative),
    total_events = cum_total[3],
    total_enrolled = total_enrolled
  )
}

simulate_scenario <- function(
    ve,
    adaptive = FALSE,
    nsim = 600,
    seed = 1,
    lambda_c = lambdaC,
    eta_rate = eta) {
  set.seed(seed)
  out <- replicate(
    nsim,
    simulate_one_trial(
      ve = ve,
      adaptive = adaptive,
      lambda_c = lambda_c,
      eta_rate = eta_rate
    ),
    simplify = FALSE
  )
  tibble(
    reject = as.logical(vapply(out, `[[`, logical(1), "reject")),
    looks = as.integer(vapply(out, `[[`, integer(1), "looks")),
    total_events = as.integer(vapply(out, `[[`, integer(1), "total_events")),
    total_enrolled = as.numeric(vapply(out, `[[`, numeric(1), "total_enrolled"))
  )
}
```

## Lightweight runnable simulation

``` r

sim_fixed_null <- simulate_scenario(ve = ve0, adaptive = FALSE, nsim = 150, seed = 101)
sim_fixed_alt <- simulate_scenario(ve = ve1, adaptive = FALSE, nsim = 150, seed = 202)
sim_adapt_null <- simulate_scenario(ve = ve0, adaptive = TRUE, nsim = 150, seed = 303)
sim_adapt_alt <- simulate_scenario(ve = ve1, adaptive = TRUE, nsim = 150, seed = 404)

summarize_oc <- function(x) {
  p <- mean(x)
  se <- sqrt(p * (1 - p) / length(x))
  c(estimate = p, mc_se = se)
}

oc <- rbind(
  `Fixed: Type I error (VE = 30%)` = summarize_oc(sim_fixed_null$reject),
  `Fixed: Power (VE = 80%)` = summarize_oc(sim_fixed_alt$reject),
  `Adaptive: Type I error (VE = 30%)` = summarize_oc(sim_adapt_null$reject),
  `Adaptive: Power (VE = 80%)` = summarize_oc(sim_adapt_alt$reject)
)

tibble(
  Scenario = rownames(oc),
  Estimate = oc[, "estimate"],
  `Monte Carlo SE` = oc[, "mc_se"]
) |>
  gt() |>
  fmt_number(columns = 2:3, decimals = 4) |>
  tab_header(
    title = "Lightweight simulation results",
    subtitle = "Exact-binomial monitoring with seasonal analyses"
  )
```

| Lightweight simulation results                   |          |                |
|--------------------------------------------------|----------|----------------|
| Exact-binomial monitoring with seasonal analyses |          |                |
| Scenario                                         | Estimate | Monte Carlo SE |
| Fixed: Type I error (VE = 30%)                   | 0.0200   | 0.0114         |
| Fixed: Power (VE = 80%)                          | 0.8933   | 0.0252         |
| Adaptive: Type I error (VE = 30%)                | 0.0267   | 0.0132         |
| Adaptive: Power (VE = 80%)                       | 0.9600   | 0.0160         |

``` r

tibble(
  Scenario = c("Fixed", "Adaptive"),
  `Mean final events under VE=30%` = c(mean(sim_fixed_null$total_events), mean(sim_adapt_null$total_events)),
  `Mean final events under VE=80%` = c(mean(sim_fixed_alt$total_events), mean(sim_adapt_alt$total_events)),
  `Mean total enrolled under VE=30%` = c(mean(sim_fixed_null$total_enrolled), mean(sim_adapt_null$total_enrolled)),
  `Mean total enrolled under VE=80%` = c(mean(sim_fixed_alt$total_enrolled), mean(sim_adapt_alt$total_enrolled)),
  `Mean looks used under VE=30%` = c(mean(sim_fixed_null$looks), mean(sim_adapt_null$looks)),
  `Mean looks used under VE=80%` = c(mean(sim_fixed_alt$looks), mean(sim_adapt_alt$looks))
) |>
  gt() |>
  fmt_number(columns = 2:7, decimals = 2) |>
  tab_header(title = "Monitoring behavior in simulation")
```

| Monitoring behavior in simulation |  |  |  |  |  |  |
|----|----|----|----|----|----|----|
| Scenario | Mean final events under VE=30% | Mean final events under VE=80% | Mean total enrolled under VE=30% | Mean total enrolled under VE=80% | Mean looks used under VE=30% | Mean looks used under VE=80% |
| Fixed | 69.20 | 35.50 | 16,920.00 | 16,920.00 | 2.49 | 3.00 |
| Adaptive | 74.25 | 46.26 | 17,722.91 | 21,642.89 | 2.29 | 3.00 |

## Example with lower-than-planned event rates

To illustrate adaptation when events are lower than planned, we halve
the seasonal control event rate from 0.3% to 0.15%. The adaptive design
then increases subsequent seasonal enrollment based on blinded
cumulative event counts.

``` r

lambdaC_low <- -log(1 - 0.0015) / season_length_years

sim_low_fixed <- simulate_scenario(
  ve = ve1,
  adaptive = FALSE,
  nsim = 300,
  seed = 505,
  lambda_c = lambdaC_low
)
sim_low_adapt <- simulate_scenario(
  ve = ve1,
  adaptive = TRUE,
  nsim = 300,
  seed = 606,
  lambda_c = lambdaC_low
)

tibble(
  Scenario = c("Fixed, low event rate", "Adaptive, low event rate"),
  `Power under H1 (VE=80%)` = c(mean(sim_low_fixed$reject), mean(sim_low_adapt$reject)),
  `Mean total events` = c(mean(sim_low_fixed$total_events), mean(sim_low_adapt$total_events)),
  `Mean total enrolled` = c(mean(sim_low_fixed$total_enrolled), mean(sim_low_adapt$total_enrolled)),
  `Mean looks used` = c(mean(sim_low_fixed$looks), mean(sim_low_adapt$looks))
) |>
  gt() |>
  fmt_number(columns = 2:5, decimals = 3) |>
  tab_header(
    title = "Lower-than-planned event rate illustration",
    subtitle = "Adaptive approach increases enrollment to recover information"
  )
```

| Lower-than-planned event rate illustration |  |  |  |  |
|----|----|----|----|----|
| Adaptive approach increases enrollment to recover information |  |  |  |  |
| Scenario | Power under H1 (VE=80%) | Mean total events | Mean total enrolled | Mean looks used |
| Fixed, low event rate | 0.597 | 17.477 | 16,920.000 | 2.953 |
| Adaptive, low event rate | 0.813 | 26.503 | 26,996.187 | 2.943 |

## Larger offline runs (template)

The chunk below is intentionally not executed in package builds.

``` r

# Suggested offline settings
type1_nsim <- 20000
power_nsim <- 3500

sim_fixed_null_big <- simulate_scenario(ve = ve0, adaptive = FALSE, nsim = type1_nsim, seed = 5001)
sim_adapt_null_big <- simulate_scenario(ve = ve0, adaptive = TRUE, nsim = type1_nsim, seed = 5002)

sim_fixed_alt_big <- simulate_scenario(ve = ve1, adaptive = FALSE, nsim = power_nsim, seed = 6001)
sim_adapt_alt_big <- simulate_scenario(ve = ve1, adaptive = TRUE, nsim = power_nsim, seed = 6002)
```

## Notes and extensions

- The adaptive pathway shown here is blinded because it uses total event
  counts only; treatment-group differences are not used to update
  enrollment.
- Spending fractions are kept fixed at `1/3, 2/3, 1`.
- For modified intention-to-treat analyses, additional exclusion/dropout
  mechanisms can be layered into the simulation by reducing at-risk
  counts before each seasonal event/dropout draw.
- Simple superiority and non-inferiority variants can be studied by
  changing `hr0`/`hr1` and rebuilding the same workflow.

## References

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
For a general introduction to exact-binomial vaccine efficacy
monitoring, see
[`vignette("VaccineEfficacy", package = "gsDesign")`](https://keaven.github.io/gsDesign/articles/VaccineEfficacy.md).

We focus on exact binomial monitoring with spending functions:

- analyses after each season with equally spaced spending times,
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
season_length_months <- 6
season_length_years <- season_length_months / 12
dropout_6mo <- 0.10

n_seasons <- 3
stopifnot(n_seasons >= 2)
timing <- seq_len(n_seasons) / n_seasons

enrollment_months <- 2
off_enrollment_months <- 10
annual_cycle_months <- enrollment_months + off_enrollment_months
enroll_pattern <- c(rep(c(1, 0), n_seasons - 1), 1)
enroll_periods <- c(rep(c(enrollment_months, off_enrollment_months), n_seasons - 1), enrollment_months)
calendar_time <- enrollment_months + season_length_months +
  annual_cycle_months * (seq_len(n_seasons) - 1)

test_lower <- rep(FALSE, n_seasons)
test_lower[1] <- TRUE
```

For the exact binomial approximation, the probability that an event is
in the experimental group is

``` r

p_event_experimental <- function(ve, randomization_ratio) {
  randomization_ratio / (randomization_ratio + 1 / (1 - ve))
}

p0 <- p_event_experimental(ve0, ratio)
p1 <- p_event_experimental(ve1, ratio)
c(p0 = p0, p1 = p1)
#>        p0        p1 
#> 0.6774194 0.3750000
```

## Initial group sequential setup

To define spending-function monitoring, we first construct a
calendar-time `gsSurvCalendar` object and then convert to integer event
looks and exact binomial bounds. Here we use 3 looks at months 8, 20,
32, corresponding to the end of each season after that year’s enrollment
period. Enrollment is modeled as 2 months on and 10 months off each year
for 3 years. The `gsSurvCalendar` inputs use months as the time unit, so
seasonal event and dropout probabilities are converted to monthly
hazards before fitting the design. Since events are seasonal, the
control event hazard is modeled as piecewise constant: positive for the
6-month high-risk season and zero afterward.

``` r

lambdaC <- c(-log(1 - seasonal_event_rate_control) / season_length_months, 0)
S <- season_length_months
eta <- -log(1 - dropout_6mo) / season_length_months

# Integer conversion can slightly adjust total enrollment so the final integer
# event target is achievable with the seasonal piecewise event-rate model.
design_calendar <- gsSurvCalendar(
  test.type = 4,                  # Non-binding lower bound framework
  alpha = alpha,                  # One-sided Type I error
  beta = beta,                    # Type II error
  calendarTime = calendar_time,   # Analysis times in months
  spending = "information",       # Spending by information fraction
  sfu = sfHSD,                    # Efficacy spending function
  sfupar = 1,                     # Pocock-like efficacy spending
  sfl = sfHSD,                    # Futility spending function
  sflpar = -2,                    # Futility spending parameter
  lambdaC = lambdaC,              # Control hazard rate per month by period
  S = S,                          # Event-rate period duration in months
  hr = hr1,                       # Alternative hypothesis HR
  hr0 = hr0,                      # Null hypothesis HR
  eta = eta,                      # Dropout hazard rate per month
  gamma = enroll_pattern,         # Relative enrollment rates by period
  R = enroll_periods,             # Enrollment period durations in months
  minfup = season_length_months,  # Minimum follow-up for final enrollees
  ratio = ratio,                  # Experimental:control randomization ratio
  testLower = test_lower          # Futility only at selected analyses
) |>
  toInteger() |>
  suppressWarnings()

gsBoundSummary(design_calendar)
#>    Analysis              Value Efficacy Futility
#>   IA 1: 33%                  Z   2.2831  -0.1175
#>    N: 10530        p (1-sided)   0.0112   0.5468
#>  Events: 12       ~HR at bound   0.1528   0.7571
#>   Month: 11 P(Cross) if HR=0.7   0.0112   0.4532
#>             P(Cross) if HR=0.2   0.4105   0.0148
#>   IA 2: 67%                  Z   2.2844       NA
#>    N: 21059        p (1-sided)   0.0112       NA
#>  Events: 24       ~HR at bound   0.2385       NA
#>   Month: 21 P(Cross) if HR=0.7   0.0192       NA
#>             P(Cross) if HR=0.2   0.7541       NA
#>       Final                  Z   2.3013       NA
#>    N: 31588        p (1-sided)   0.0107       NA
#>  Events: 36       ~HR at bound   0.2887       NA
#>   Month: 32 P(Cross) if HR=0.7   0.0247       NA
#>             P(Cross) if HR=0.2   0.9065       NA

planned_final_events <- design_calendar$n.I[design_calendar$k]
planned_counts <- as.integer(round(planned_final_events * timing))
planned_counts[n_seasons] <- planned_final_events
for (j in seq_along(planned_counts)[-1]) {
  planned_counts[j] <- max(planned_counts[j], planned_counts[j - 1] + 1L)
}

design_exact <- toBinomialExact(design_calendar, observedEvents = planned_counts)

planned_enrollment_period <- as.numeric(rowSums(as.matrix(design_calendar$gamma))) *
  as.numeric(design_calendar$R)
season_id <- rep(seq_len(n_seasons), each = 2, length.out = length(planned_enrollment_period))
planned_enrollment_by_season <- as.integer(round(tapply(planned_enrollment_period, season_id, sum)))
planned_enrollment_control <- as.integer(round(planned_enrollment_by_season / (1 + ratio)))
planned_enrollment_experimental <- planned_enrollment_by_season - planned_enrollment_control
planned_cum_enrollment <- cumsum(planned_enrollment_by_season)
```

The table above is the initial survival-design approximation and
includes the approximate futility `Z`-boundary. The table below
summarizes planned event looks and exact binomial efficacy/futility
bounds. In this table, `x` is the cumulative number of observed events
in the experimental arm at a given analysis.

``` r

target_alpha_spend <- design_calendar$upper$sf(
  alpha = alpha,
  t = timing,
  param = design_calendar$upper$param
)$spend

achieved_alpha_spend <- cumsum(
  gsBinomialExact(
    k = design_exact$k,            # Number of analyses
    theta = design_exact$theta[1], # Null event probability in experimental arm
    n.I = design_exact$n.I,        # Cumulative events by analysis
    a = design_exact$lower$bound,  # Efficacy bounds (x <= a crosses)
    b = design_exact$n.I + 1       # Non-binding upper bound for alpha-spend check
  )$lower$prob[, 1]
)

achieved_power_h1 <- cumsum(
  gsBinomialExact(
    k = design_exact$k,            # Number of analyses
    theta = design_exact$theta[2], # Alternative event probability in experimental arm
    n.I = design_exact$n.I,        # Cumulative events by analysis
    a = design_exact$lower$bound,  # Efficacy bounds
    b = design_exact$n.I + 1       # Non-binding upper bound for cumulative efficacy probability
  )$lower$prob[, 1]
)

ve_from_bound <- function(x, n, ratio) {
  out <- rep(NA_real_, length(x))
  ok <- x >= 0 & x < n
  if (any(ok)) {
    p <- x[ok] / n[ok]
    hr <- p / (ratio * (1 - p))
    out[ok] <- 1 - hr
  }
  out
}

futility_active <- if (!is.null(design_calendar$testLower)) {
  tl <- design_calendar$testLower
  if (length(tl) == 1) tl <- rep(tl, design_exact$k)
  as.logical(tl)
} else {
  design_exact$upper$bound <= design_exact$n.I
}
nominal_p_futility <- rep(NA_real_, design_exact$k)
nominal_p_futility[futility_active] <- stats::pbinom(
  q = design_exact$upper$bound[futility_active],
  size = design_exact$n.I[futility_active],
  prob = p0
)

tibble(
  Season = seq_len(n_seasons),
  `Spending time` = timing,
  `Planned total events` = design_exact$n.I,
  `Approx cumulative enrollment` = planned_cum_enrollment,
  `Exact efficacy bound (x <= a)` = design_exact$lower$bound,
  `VE at bound (efficacy)` = ve_from_bound(design_exact$lower$bound, design_exact$n.I, ratio),
  `Nominal 1-sided p at bound (efficacy)` = stats::pbinom(design_exact$lower$bound, design_exact$n.I, p0),
  `Exact futility bound (x >= b)` = ifelse(futility_active, design_exact$upper$bound, NA_integer_),
  `VE at bound (futility)` = ve_from_bound(
    ifelse(futility_active, design_exact$upper$bound, -1L),
    design_exact$n.I,
    ratio
  ),
  `Nominal 1-sided p at bound (futility)` = nominal_p_futility,
  `Target cumulative alpha spend` = target_alpha_spend,
  `Achieved cumulative alpha spend` = achieved_alpha_spend,
  `Cumulative power under H1` = achieved_power_h1
) |>
  gt() |>
  fmt_number(columns = 2, decimals = 3) |>
  fmt_percent(columns = c(`VE at bound (efficacy)`, `VE at bound (futility)`), decimals = 1) |>
  fmt_number(
    columns = c(
      `Nominal 1-sided p at bound (efficacy)`,
      `Nominal 1-sided p at bound (futility)`,
      `Target cumulative alpha spend`,
      `Achieved cumulative alpha spend`,
      `Cumulative power under H1`
    ),
    decimals = 4
  ) |>
  tab_spanner(
    label = "Efficacy",
    columns = c(
      `Exact efficacy bound (x <= a)`,
      `VE at bound (efficacy)`,
      `Nominal 1-sided p at bound (efficacy)`
    )
  ) |>
  tab_spanner(
    label = "Futility",
    columns = c(
      `Exact futility bound (x >= b)`,
      `VE at bound (futility)`,
      `Nominal 1-sided p at bound (futility)`
    )
  ) |>
  tab_header(
    title = "Planned exact binomial seasonal monitoring",
    subtitle = "Super-superiority example with Pocock-like efficacy spending"
  ) |>
  tab_footnote(
    footnote = "x denotes cumulative observed events in the experimental arm; efficacy is established when x is at or below the listed efficacy bound.",
    locations = cells_column_labels(columns = `Exact efficacy bound (x <= a)`)
  ) |>
  tab_footnote(
    footnote = "Blank futility entries indicate no futility stopping boundary at that analysis.",
    locations = cells_column_labels(columns = `Exact futility bound (x >= b)`)
  )
```

[TABLE]

The next table gives planned enrollment/sample size by season and
overall.

``` r

enrollment_table <- tibble(
  Season = as.character(seq_len(n_seasons)),
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
| 1 | 2632 | 7897 | 10529 | 10529 |
| 2 | 2632 | 7897 | 10529 | 21058 |
| 3 | 2632 | 7897 | 10529 | 31587 |
| Overall | 7896 | 23691 | 31587 | 31587 |

## Example repeated and sequential p-values

Suppose observed event totals at the 3 seasonal analyses are equal to
the planned totals and observed experimental events are as below. Here,
`x` is the observed number of events in the experimental arm. The offset
sets season 2 to be one event above the efficacy bound to demonstrate
that the repeated p-value is greater than 0.025.

``` r

x_offset_from_efficacy <- rep(0L, n_seasons)
x_offset_from_efficacy[min(2L, n_seasons)] <- 1L
example_x <- pmax(0L, design_exact$lower$bound + x_offset_from_efficacy)
example_p <- repeatedPValueBinomialExact(
  gsD = design_calendar,
  n.I = design_exact$n.I,
  x = example_x
)
example_p
#>   Analysis n.I  x repeated_p_value
#> 1        1  12  3      0.006666324
#> 2        2  24 11      0.040110828
#> 3        3  36 18      0.024388104
#>   bound_at_repeated_p_value
#> 1                         3
#> 2                        11
#> 3                        18
```

The sequential p-value is the minimum repeated p-value:

``` r

sequentialPValueBinomialExact(
  gsD = design_calendar,
  n.I = design_exact$n.I,
  x = example_x
)
#> [1] 0.006666324
```

## Update exact bounds at analysis time

The official package path for updating exact-binomial bounds at analysis
time is to call
[`toBinomialExact()`](https://keaven.github.io/gsDesign/reference/toBinomialExact.md)
with `observedEvents`.

The spending denominator remains the original planned final event count
from the design object, so earlier analyses are not changed when
observed totals differ from plan. At look `j`, spending time is based on
`observedEvents[j] / planned_final_events` (capped at 1). If a look
reaches the planned final event count, all remaining spending is used at
that look.

If the final look is under-run but you still want to use full alpha at
the last analysis, set `maxSpend = TRUE`. This only changes the final
spending time to 1 and leaves earlier looks unchanged.

For explicit control, you can pass `usTime` (and for `test.type = 4`,
`lsTime`) directly to
[`toBinomialExact()`](https://keaven.github.io/gsDesign/reference/toBinomialExact.md),
following the same spending-time conventions as
[`gsDesign()`](https://keaven.github.io/gsDesign/reference/gsDesign.md),
[`gsSurv()`](https://keaven.github.io/gsDesign/reference/nSurv.md), and
[`gsSurvCalendar()`](https://keaven.github.io/gsDesign/reference/gsSurvCalendar.md).
As above, setting `x` one event above an updated efficacy bound at a
look gives a repeated p-value above 0.025 for that analysis.

``` r

observed_counts_update <- c(
  planned_counts[-n_seasons],
  max(planned_counts[n_seasons - 1] + 1L, planned_counts[n_seasons] - 5L)
)
update_exact <- toBinomialExact(design_calendar, observedEvents = observed_counts_update)
update_exact_full <- toBinomialExact(
  design_calendar,
  observedEvents = observed_counts_update,
  maxSpend = TRUE
)

tibble(
  Analysis = seq_along(update_exact$n.I),
  `Observed total events` = update_exact$n.I,
  `Updated efficacy bound (x <= a), default spending` = update_exact$lower$bound,
  `Updated efficacy bound (x <= a), maxSpend=TRUE` = update_exact_full$lower$bound,
  `Updated futility bound, default spending` = update_exact$upper$bound,
  `Updated futility bound, maxSpend=TRUE` = update_exact_full$upper$bound
) |>
  gt() |>
  tab_header(title = "Updated exact bounds using observedEvents")
```

| Updated exact bounds using observedEvents |  |  |  |  |  |
|----|----|----|----|----|----|
| Analysis | Observed total events | Updated efficacy bound (x \<= a), default spending | Updated efficacy bound (x \<= a), maxSpend=TRUE | Updated futility bound, default spending | Updated futility bound, maxSpend=TRUE |
| 1 | 12 | 3 | 3 | 9 | 9 |
| 2 | 24 | 10 | 10 | 16 | 16 |
| 3 | 31 | 15 | 15 | 20 | 20 |

## Lightweight runnable simulation

We use the package helper
[`simBinomialSeasonalExact()`](https://keaven.github.io/gsDesign/reference/simBinomialSeasonalExact.md)
to run both fixed and blinded-adaptive seasonal scenarios. In this
vignette, we set `final_full_spending = TRUE` to force full alpha
spending at the final look even when the final observed total event
count is below plan.

``` r

ve_scenarios <- c(`H0 (VE=30%)` = ve0, `H1 (VE=80%)` = ve1)
planned_control_event_rates <- rep(seasonal_event_rate_control, length(ve_scenarios))

sim_light <- simBinomialSeasonalExact(
  gsD = design_calendar,
  ve = ve_scenarios,
  nsim = rep(150, length(ve_scenarios)),
  control_event_rate = planned_control_event_rates,
  season_length = season_length_years,
  dropout_rate = dropout_6mo,
  planned_counts = planned_counts,
  enroll_control_per_look = planned_enrollment_control,
  enroll_experimental_per_look = planned_enrollment_experimental,
  adaptive = c(FALSE, TRUE),
  max_multiplier = 2,
  final_full_spending = TRUE,
  seed = 101
)
```

``` r

oc <- sim_light$summary |>
  dplyr::mutate(
    Scenario = ifelse(adaptive, paste0("Adaptive: ", scenario), paste0("Fixed: ", scenario))
  ) |>
  dplyr::select(
    Scenario,
    `Efficacy crossing probability` = rejection_rate,
    `Futility stopping probability` = futility_stop_rate,
    `MC SE (efficacy)` = mc_se,
    `MC SE (futility)` = futility_mc_se,
    `Mean total events` = mean_total_events,
    `Mean total enrolled` = mean_total_enrolled,
    `Mean looks used` = mean_looks
  )

oc |>
  gt() |>
  fmt_number(columns = 2:5, decimals = 4) |>
  fmt_number(columns = 6:8, decimals = 2) |>
  tab_header(
    title = "Lightweight simulation results",
    subtitle = "Exact-binomial monitoring with seasonal analyses"
  ) |>
  tab_footnote(
    footnote = "For VE=30% scenarios, efficacy crossing probability is Type I error under the non-binding futility convention (futility crossings do not block later efficacy crossings).",
    locations = cells_column_labels(columns = `Efficacy crossing probability`)
  )
```

| Lightweight simulation results |  |  |  |  |  |  |  |
|----|----|----|----|----|----|----|----|
| Exact-binomial monitoring with seasonal analyses |  |  |  |  |  |  |  |
| Scenario | Efficacy crossing probability¹ | Futility stopping probability | MC SE (efficacy) | MC SE (futility) | Mean total events | Mean total enrolled | Mean looks used |
| Fixed: H0 (VE=30%) | 0.0133 | 0.7067 | 0.0094 | 0.0372 | 35.73 | 13,617.51 | 1.29 |
| Adaptive: H0 (VE=30%) | 0.0200 | 0.7200 | 0.0114 | 0.0367 | 35.41 | 13,406.93 | 1.27 |
| Fixed: H1 (VE=80%) | 0.9667 | 0.0200 | 0.0147 | 0.0114 | 28.89 | 17,829.11 | 1.69 |
| Adaptive: H1 (VE=80%) | 0.9667 | 0.0200 | 0.0147 | 0.0114 | 30.01 | 19,729.27 | 1.71 |
| ¹ For VE=30% scenarios, efficacy crossing probability is Type I error under the non-binding futility convention (futility crossings do not block later efficacy crossings). |  |  |  |  |  |  |  |

## Example with lower-than-planned event rates

To illustrate adaptation when events are lower than planned, we halve
the seasonal control event rate and compare fixed versus adaptive
monitoring for both `VE = 30%` and `VE = 80%`.

``` r

low_control_event_rates <- planned_control_event_rates / 2

sim_low <- simBinomialSeasonalExact(
  gsD = design_calendar,
  ve = ve_scenarios,
  nsim = rep(300, length(ve_scenarios)),
  control_event_rate = low_control_event_rates,
  season_length = season_length_years,
  dropout_rate = dropout_6mo,
  planned_counts = planned_counts,
  enroll_control_per_look = planned_enrollment_control,
  enroll_experimental_per_look = planned_enrollment_experimental,
  adaptive = c(FALSE, TRUE),
  max_multiplier = 2,
  final_full_spending = TRUE,
  seed = 505
)

low <- sim_low$summary
tibble(
  Scenario = c(
    "Without adaptation: Type I error (VE=30%)",
    "With adaptation: Type I error (VE=30%)",
    "Without adaptation: Power (VE=80%)",
    "With adaptation: Power (VE=80%)"
  ),
  `Efficacy crossing probability` = c(
    low$rejection_rate[!low$adaptive & low$scenario == "H0 (VE=30%)"],
    low$rejection_rate[low$adaptive & low$scenario == "H0 (VE=30%)"],
    low$rejection_rate[!low$adaptive & low$scenario == "H1 (VE=80%)"],
    low$rejection_rate[low$adaptive & low$scenario == "H1 (VE=80%)"]
  ),
  `Futility stopping probability` = c(
    low$futility_stop_rate[!low$adaptive & low$scenario == "H0 (VE=30%)"],
    low$futility_stop_rate[low$adaptive & low$scenario == "H0 (VE=30%)"],
    low$futility_stop_rate[!low$adaptive & low$scenario == "H1 (VE=80%)"],
    low$futility_stop_rate[low$adaptive & low$scenario == "H1 (VE=80%)"]
  ),
  `Mean total events` = c(
    low$mean_total_events[!low$adaptive & low$scenario == "H0 (VE=30%)"],
    low$mean_total_events[low$adaptive & low$scenario == "H0 (VE=30%)"],
    low$mean_total_events[!low$adaptive & low$scenario == "H1 (VE=80%)"],
    low$mean_total_events[low$adaptive & low$scenario == "H1 (VE=80%)"]
  ),
  `Mean total enrolled` = c(
    low$mean_total_enrolled[!low$adaptive & low$scenario == "H0 (VE=30%)"],
    low$mean_total_enrolled[low$adaptive & low$scenario == "H0 (VE=30%)"],
    low$mean_total_enrolled[!low$adaptive & low$scenario == "H1 (VE=80%)"],
    low$mean_total_enrolled[low$adaptive & low$scenario == "H1 (VE=80%)"]
  ),
  `Mean looks used` = c(
    low$mean_looks[!low$adaptive & low$scenario == "H0 (VE=30%)"],
    low$mean_looks[low$adaptive & low$scenario == "H0 (VE=30%)"],
    low$mean_looks[!low$adaptive & low$scenario == "H1 (VE=80%)"],
    low$mean_looks[low$adaptive & low$scenario == "H1 (VE=80%)"]
  )
) |>
  gt() |>
  fmt_number(columns = 2:3, decimals = 4) |>
  fmt_number(columns = 4:6, decimals = 2) |>
  tab_header(
    title = "Lower-than-planned event rate illustration",
    subtitle = "Adaptive approach increases enrollment to recover information"
  ) |>
  tab_footnote(
    footnote = "Type I error rows use non-binding futility for efficacy crossing probability; futility stopping probability is shown separately.",
    locations = cells_column_labels(columns = `Efficacy crossing probability`)
  )
```

| Lower-than-planned event rate illustration |  |  |  |  |  |
|----|----|----|----|----|----|
| Adaptive approach increases enrollment to recover information |  |  |  |  |  |
| Scenario | Efficacy crossing probability¹ | Futility stopping probability | Mean total events | Mean total enrolled | Mean looks used |
| Without adaptation: Type I error (VE=30%) | 0.0267 | 0.3367 | 39.59 | 22,146.00 | 2.10 |
| With adaptation: Type I error (VE=30%) | 0.0300 | 0.3733 | 36.81 | 21,733.09 | 1.90 |
| Without adaptation: Power (VE=80%) | 0.9200 | 0.0000 | 22.04 | 23,795.54 | 2.26 |
| With adaptation: Power (VE=80%) | 0.9667 | 0.0000 | 25.93 | 30,396.28 | 2.11 |
| ¹ Type I error rows use non-binding futility for efficacy crossing probability; futility stopping probability is shown separately. |  |  |  |  |  |

This table provides side-by-side comparisons of Type I error, power, and
futility stopping probability without and with adaptation under the
lower-than-planned event-rate scenario.

## Larger offline runs (template)

The chunk below is intentionally not executed in package builds.

``` r

# Suggested offline settings
type1_nsim <- 20000
power_nsim <- 3500

sim_type1_big <- simBinomialSeasonalExact(
  gsD = design_calendar,
  ve = c(`H0 (VE=30%)` = ve0),
  nsim = type1_nsim,
  control_event_rate = seasonal_event_rate_control,
  season_length = season_length_years,
  dropout_rate = dropout_6mo,
  planned_counts = planned_counts,
  enroll_control_per_look = planned_enrollment_control,
  enroll_experimental_per_look = planned_enrollment_experimental,
  adaptive = c(FALSE, TRUE),
  final_full_spending = TRUE,
  seed = 5001
)

sim_power_big <- simBinomialSeasonalExact(
  gsD = design_calendar,
  ve = c(`H1 (VE=80%)` = ve1),
  nsim = power_nsim,
  control_event_rate = seasonal_event_rate_control,
  season_length = season_length_years,
  dropout_rate = dropout_6mo,
  planned_counts = planned_counts,
  enroll_control_per_look = planned_enrollment_control,
  enroll_experimental_per_look = planned_enrollment_experimental,
  adaptive = c(FALSE, TRUE),
  final_full_spending = TRUE,
  seed = 6001
)
```

## Notes and extensions

- The adaptive pathway shown here is blinded because it uses total event
  counts only; treatment-group differences are not used to update
  enrollment.
- Spending fractions are set by `timing`; with the current specification
  they are 0.333, 0.667, 1.
- For modified intention-to-treat analyses, additional exclusion/dropout
  mechanisms can be layered into the simulation by reducing at-risk
  counts before each seasonal event/dropout draw.
- Simple superiority and non-inferiority variants can be studied by
  changing `hr0`/`hr1` and rebuilding the same workflow.

## References

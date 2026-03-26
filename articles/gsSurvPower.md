# Power Computation for Group Sequential Survival Designs

## Motivation

[`gsSurv()`](https://keaven.github.io/gsDesign/reference/nSurv.md) and
[`gsSurvCalendar()`](https://keaven.github.io/gsDesign/reference/gsSurvCalendar.md)
derive sample sizes and enrollment rates to achieve a target power for a
given hazard ratio. In practice, we often want to answer the reverse
question: *given a specified hazard ratio, fixed enrollment, dropout,
and analysis timing assumptions, what power does the design achieve?*

Common scenarios include:

- **Sensitivity analysis**: What happens to power if the true hazard
  ratio is 0.75 instead of the design assumption of 0.65?
- **Changing alpha**: What if the multiplicity scheme initially
  allocates \\\alpha = 0.0125\\ and later allows \\\alpha = 0.025\\?
- **Modified enrollment**: What if enrollment is slower than planned?
- **Different analysis times**: What if interim analyses occur at
  calendar times that differ from the original design?

[`gsSurvPower()`](https://keaven.github.io/gsDesign/reference/gsSurvPower.md)
addresses these questions by computing power for a group sequential
survival design under user-specified assumptions.

## Quick start

If you already have a design object, the most common workflow is to
reuse its defaults and override only the assumptions you want to
stress-test.

``` r
design <- gsSurv(
  k = 3, test.type = 4, alpha = 0.025, sided = 1, beta = 0.1,
  sfu = sfHSD, sfupar = -4, sfl = sfHSD, sflpar = -2,
  lambdaC = log(2) / 12, hr = 0.7, hr0 = 1,
  eta = 0.01, gamma = 10, R = 16, minfup = 12, T = 28
)

pwr_design <- gsSurvPower(x = design, plannedCalendarTime = design$T)
pwr_design$power
```

    ## [1] 0.9

The returned object contains the same design-style structure as
[`gsSurv()`](https://keaven.github.io/gsDesign/reference/nSurv.md), but
with `variable = "Power"`. The most useful components to inspect first
are:

- `pwr_design$power` for overall power.
- `pwr_design$n.I` for expected events at each analysis.
- `pwr_design$T` for analysis times.
- `pwr_design$timing` for information fractions.
- `pwr_design$upper$bound` and `pwr_design$lower$bound` for the bounds
  being applied.

## How gsSurvPower uses your inputs

[`gsSurvPower()`](https://keaven.github.io/gsDesign/reference/gsSurvPower.md)
accepts an optional `gsSurv`-class object `x`, including output from
[`gsSurv()`](https://keaven.github.io/gsDesign/reference/nSurv.md) and
[`gsSurvCalendar()`](https://keaven.github.io/gsDesign/reference/gsSurvCalendar.md),
that provides defaults for all parameters. Any parameter the user
explicitly specifies overrides the corresponding value from `x`. When
`x` is not provided, all design parameters must be specified directly.

### Hazard ratio roles

Two distinct hazard ratios play different roles:

- **`hr`**: The assumed hazard ratio under which power is computed. This
  is the “what-if” treatment effect.
- **`hr1`**: The design hazard ratio used to calibrate futility bounds
  (`test.type` 3, 4, 7, 8 only; not used for `test.type` 5, 6 or harm
  bounds). When `x` is provided, `hr1` defaults to `x$hr` (the effect
  size the trial was originally designed for). Futility bounds remain
  calibrated to the design assumption even when power is evaluated under
  a different `hr`.

### Analysis timing: calendar time vs. event-driven

Analysis times can be specified by calendar time, by target event
counts, or by a combination of criteria. The choice has an important
consequence for sensitivity analyses:

- **`plannedCalendarTime`** fixes the calendar time of each analysis.
  Expected events are then recomputed under the assumed HR. A worse HR
  (closer to 1) produces *more* expected events at the same calendar
  time because the experimental arm fails faster. This gives an
  “unconditional” power that reflects how the assumed treatment effect
  influences event accrual.

- **`targetEvents`** fixes the event count at each analysis. The
  calendar time is the time until expected events reach the target under
  the assumed HR. Since the event counts are held constant, the
  information fractions do not change with HR, and the resulting power
  matches the `gsDesign` power plot (`plot(x, plottype = 2)`) to
  numerical precision.

Both modes are useful. Calendar-time analyses are natural when the
protocol specifies analysis dates; event-driven analyses are natural
when the protocol specifies event targets.

### Quick decision guide

| If the protocol fixes… | Use…                  | What changes in a sensitivity analysis         |
|------------------------|-----------------------|------------------------------------------------|
| Analysis dates         | `plannedCalendarTime` | Expected events and information fractions      |
| Event targets          | `targetEvents`        | Time until expected events reach those targets |

Additional criteria can be combined per-analysis, each specified as a
scalar (recycled to all `k` analyses) or a vector of length `k` with
`NA` for “not applicable”:

- `maxExtension`: Maximum time beyond the floor to wait for target
  events.
- `minTimeFromPreviousAnalysis`: Minimum elapsed time since the previous
  analysis.
- `minN`: Minimum sample size enrolled before analysis.
- `minFollowUp`: Minimum follow-up after `minN` is reached.

When multiple criteria apply to a single analysis, the analysis time is
the maximum of all floor criteria, with `targetEvents` potentially
extending beyond the floor. `maxExtension` acts as a hard cap: the
analysis time never exceeds `plannedCalendarTime + maxExtension` (or
`T[i-1] + maxExtension` when no calendar time is specified), even if
other criteria such as `minTimeFromPreviousAnalysis` or
`minN + minFollowUp` would push it later.

### Spending and method

- **`spending`**: One of `"information"` (default) or `"calendar"`.
  Information-based spending tracks the fraction of statistical
  information accumulated; calendar-based spending sets
  `usTime = lsTime = T / max(T)`. Custom spending times can also be
  passed via `usTime` and `lsTime`, but they are ignored when
  `spending = "calendar"`.

- **`informationRates`**: Planned information fractions (vector of
  length `k`). When provided, spending fractions are
  `pmin(informationRates, actual_timing)` at each analysis, preventing
  over-spending when events arrive faster than planned and
  under-spending when behind. This planned-vs-actual information scale
  takes precedence over `spending`, `usTime`, and `lsTime`; upper and
  lower spending both use the same capped vector.

- **`fullSpendingAtFinal`**: When `TRUE`, the final element of the
  spending-time vector is forced to 1 after applying `informationRates`,
  calendar spending, or user-supplied `usTime` / `lsTime`. This is
  useful when the selected spending-time vector would otherwise end
  below 1.

- **`method`**: One of `"LachinFoulkes"` (default), `"Schoenfeld"`,
  `"Freedman"`, or `"BernsteinLagakos"`. Controls how fixed-design
  events (`n.fix`) and drift parameter \\\theta\\ are computed when `x`
  is not provided. When `x` is provided, `x$n.fix` and, implicitly,
  \\\theta\\ are used directly for exact consistency with the design.

### Stratified targetEvents

`targetEvents` accepts a scalar (recycled), a vector of length `k` (one
overall target per analysis), or a matrix with `k` rows and `nstrata`
columns (per-stratum targets). A vector of length `k` is always
interpreted as overall targets; to specify per-stratum targets for a
single analysis, use a 1-row matrix.

## Power under alternative assumptions

Passing the design’s analysis times with the same hazard ratio exactly
reproduces the design power (90%). Internally,
[`gsSurvPower()`](https://keaven.github.io/gsDesign/reference/gsSurvPower.md)
uses `x$n.fix` (when `x` is provided) so that the drift parameter
\\\theta\\ and bounds are normalized identically to
[`gsSurv()`](https://keaven.github.io/gsDesign/reference/nSurv.md). The
assumed HR’s drift is obtained by method-specific scaling:

- For Schoenfeld, LachinFoulkes, and BernsteinLagakos:
  \\\theta\_{\text{assumed}} = \theta\_{\text{design}} \times
  \|\log(\text{hr}/\text{hr}\_0)\| /
  \|\log(\text{hr}\_1/\text{hr}\_0)\|\\
- For Freedman: \\\theta\_{\text{assumed}} = \theta\_{\text{design}}
  \times \|\delta(\text{hr})\| / \|\delta(\text{hr}\_1)\|\\ where
  \\\delta(\text{hr}) = (\text{hr} - 1) / (\text{hr} + 1/\text{ratio})\\

This reproduces the design power exactly at `hr = hr1` and scales
correctly for other hazard ratios, matching
[`rpact::getPowerSurvival()`](https://docs.rpact.org/reference/getPowerSurvival.html)
to within 0.5% across methods.

``` r
cat("Design power:", round((1 - design$beta) * 100, 1), "%\n")
```

    ## Design power: 90 %

``` r
cat("gsSurvPower:  ", round(pwr_design$power * 100, 1), "%\n")
```

    ## gsSurvPower:   90 %

### Power under a different hazard ratio

Suppose the true treatment effect is HR = 0.8 instead of the design
assumption of 0.7:

``` r
pwr_worse <- gsSurvPower(x = design, hr = 0.8, plannedCalendarTime = design$T)
cat("Power at HR = 0.8:", round(pwr_worse$power * 100, 1), "%\n")
```

    ## Power at HR = 0.8: 54.1 %

The futility bounds remain calibrated to the design HR (0.7), but power
is evaluated under the assumed HR (0.8).

### Power over a range of hazard ratios

``` r
hr_grid <- seq(0.55, 0.90, by = 0.05)
power_vals <- sapply(hr_grid, function(h) {
  p <- gsSurvPower(x = design, hr = h, plannedCalendarTime = design$T)
  p$power
})
results <- data.frame(HR = hr_grid, Power = round(power_vals * 100, 1))
results
```

    ##     HR Power
    ## 1 0.55  99.9
    ## 2 0.60  99.4
    ## 3 0.65  97.1
    ## 4 0.70  90.0
    ## 5 0.75  75.2
    ## 6 0.80  54.1
    ## 7 0.85  32.5
    ## 8 0.90  16.2

## Multiple timing criteria

Real trials often use multiple criteria for analysis timing. In
practice, a protocol may specify target event counts, planned calendar
times, minimum follow-up after enrollment completes, and caps on how
long analyses can be delayed.
[`gsSurvPower()`](https://keaven.github.io/gsDesign/reference/gsSurvPower.md)
lets you combine all of these in a single call. Approximations are based
on expected event accumulation under the assumed HR. Thus, computations
do not take into account the stochastic variability in event accrual.
While
[`gsSurvPower()`](https://keaven.github.io/gsDesign/reference/gsSurvPower.md)
should be adequate for most purposes, verification for key scenarios
should consider simulation using the **simtrial** R package.

### Setup

The design enrolls at rate 39.3 patients/month for 16 months (629
patients total), with a 12-month control median and HR = 0.7. The three
analyses are planned at months 12.4, 18.9, 28, so IA1 occurs *before*
planned enrollment completion and IA2/FA occur *after*.

We layer four criteria:

| Criterion             | IA1   | IA2                 | FA                   |
|-----------------------|-------|---------------------|----------------------|
| `plannedCalendarTime` | 12.4  | 18.9                | 28                   |
| `targetEvents`        | 117.7 | 235.5               | 353.2                |
| `minN + minFollowUp`  | —     | all enrolled + 2 mo | all enrolled + 12 mo |
| `maxExtension`        | 3 mo  | 12 mo               | 20 mo                |

The floor for each analysis is the *latest* of the applicable
`plannedCalendarTime`, `minN + minFollowUp`, and previous-analysis
constraints. If expected events have not reached the target at the
floor, the analysis can be extended until the time that expected events
reach the target, up to `plannedCalendarTime + maxExtension`.

``` r
total_N <- floor(sum(design$gamma * design$R))
```

### Baseline: design assumptions

Under design assumptions the criteria reproduce the planned timing
exactly. The `minN + minFollowUp` floor for IA2 is 16 + 2 = 18 months,
which is below the planned time of 18.9 months, so the planned calendar
time drives IA2. The FA floor from `minN + minFollowUp` is 16 + 12 = 28,
which coincides with the planned time. Since the design’s expected event
counts match the targets, the `maxExtension` is not needed and the
result matches the design power.

``` r
pwr_multi <- gsSurvPower(
  x = design,
  targetEvents = design$n.I,
  plannedCalendarTime = design$T,
  minN = c(NA, total_N, total_N),
  minFollowUp = c(NA, 2, 12),
  maxExtension = c(3, 12, 20)
)

data.frame(
  Analysis = 1:design$k,
  Planned_Time = round(design$T, 1),
  Actual_Time = round(pwr_multi$T, 1),
  Target_Events = round(design$n.I, 1),
  Actual_Events = round(pwr_multi$n.I, 1)
)
```

    ##   Analysis Planned_Time Actual_Time Target_Events Actual_Events
    ## 1        1         12.4        12.4         117.7         117.7
    ## 2        2         18.9        18.9         235.5         235.5
    ## 3        3         28.0        28.0         353.2         353.2

``` r
cat("Power:", round(pwr_multi$power * 100, 1), "%\n")
```

    ## Power: 90 %

### Scenario 1: slower enrollment

If enrollment proceeds at half the planned rate, it takes 32 months to
reach 629 patients. If we simply target the same sample size (double the
duration of enrollment) and event targets, we will extend the expected
timing of analyses from 12.4, 18.9, 28 months but have the same power
and bounds.

``` r
pwr_slow_simple <- gsSurvPower(
  x = design,
  gamma = design$gamma / 2,
  targetN = total_N,
  targetEvents = design$n.I
)


pwr_slow_simple |> gsBoundSummary()
```

    ## Method: LachinFoulkes 
    ##     Analysis              Value Efficacy Futility
    ##    IA 1: 33%                  Z   3.0107  -0.2388
    ##       N: 364        p (1-sided)   0.0013   0.5944
    ##  Events: 118       ~HR at bound   0.5741   1.0450
    ##    Month: 19   P(Cross) if HR=1   0.0013   0.4056
    ##              P(Cross) if HR=0.7   0.1412   0.0148
    ##    IA 2: 67%                  Z   2.5465   0.9410
    ##       N: 556        p (1-sided)   0.0054   0.1733
    ##  Events: 236       ~HR at bound   0.7176   0.8846
    ##    Month: 28   P(Cross) if HR=1   0.0062   0.8347
    ##              P(Cross) if HR=0.7   0.5815   0.0437
    ##        Final                  Z   1.9992   1.9992
    ##       N: 630        p (1-sided)   0.0228   0.0228
    ##  Events: 354       ~HR at bound   0.8084   0.8084
    ##    Month: 38   P(Cross) if HR=1   0.0233   0.9767
    ##              P(Cross) if HR=0.7   0.9000   0.1000

With `maxExtension = c(3, 12, 20)`, each analysis can extend beyond
`plannedCalendarTime` by the specified amount while waiting for expected
events to reach the target—but never past the cap. The
`minN + minFollowUp` floor for IA2 is 32 + 2 = 34 months, far beyond
`plannedCalendarTime[2] + maxExtension[2]`, so the cap overrides. Note
that `maxExtension` is always measured from `plannedCalendarTime`, not
from the floor, so it acts as a hard deadline on how long the sponsor is
willing to wait.

``` r
pwr_slow <- gsSurvPower(
  x = design,
  gamma = design$gamma / 2,
  targetEvents = design$n.I,
  plannedCalendarTime = design$T,
  minN = c(NA, total_N, total_N),
  minFollowUp = c(NA, 2, 12),
  maxExtension = c(3, 12, 20)
)
```

    ## Warning in find_time_for_events(total_event_targets[analysis_index]): Target
    ## 353 events may not be achievable

``` r
data.frame(
  Analysis = 1:design$k,
  Planned_Time = round(design$T, 1),
  Actual_Time = round(pwr_slow$T, 1),
  Target_Events = round(design$n.I, 1),
  Actual_Events = round(pwr_slow$n.I, 1)
)
```

    ##   Analysis Planned_Time Actual_Time Target_Events Actual_Events
    ## 1        1         12.4        15.4         117.7          86.1
    ## 2        2         18.9        30.9         235.5         189.3
    ## 3        3         28.0        48.0         353.2         233.6

``` r
cat("Power:", round(pwr_slow$power * 100, 1), "%\n")
```

    ## Power: 74.3 %

Each analysis is capped by `plannedCalendarTime + maxExtension`. The
final analysis achieves only 234 of the targeted 353 events, and power
drops from 90% to 74.3%.

### Scenario 2: higher control failure rate

If the control median is 8 months instead of 12, events accumulate
faster. Expected events reach the target well before the planned
calendar times, so the `plannedCalendarTime` floor determines the
analysis schedule. The trial over-runs its event targets substantially,
yielding higher-than-planned power.

``` r
pwr_fast <- gsSurvPower(
  x = design,
  lambdaC = log(2) / 8,
  targetEvents = design$n.I,
  plannedCalendarTime = design$T,
  minN = c(NA, total_N, total_N),
  minFollowUp = c(NA, 2, 12),
  maxExtension = c(3, 12, 20)
)

data.frame(
  Analysis = 1:design$k,
  Planned_Time = round(design$T, 1),
  Actual_Time = round(pwr_fast$T, 1),
  Target_Events = round(design$n.I, 1),
  Actual_Events = round(pwr_fast$n.I, 1)
)
```

    ##   Analysis Planned_Time Actual_Time Target_Events Actual_Events
    ## 1        1         12.4        12.4         117.7         161.5
    ## 2        2         18.9        18.9         235.5         310.8
    ## 3        3         28.0        28.0         353.2         437.7

``` r
cat("Power:", round(pwr_fast$power * 100, 1), "%\n")
```

    ## Power: 94.9 %

The final analysis collects 438 events vs. the target of 353, and power
rises to 94.9%.

### Controlling spending with informationRates

When events fall short of the target (as in Scenario 1), the actual
information fraction at each analysis may be lower than planned. By
default, bounds are computed at the actual information fractions. The
`informationRates` parameter lets you cap spending at
`pmin(informationRates, actual_timing)` — preventing over-spending if
events arrive faster than planned, and under-spending if they arrive
slower. This is useful when the protocol pre-specifies spending based on
planned information fractions. If `informationRates` is supplied, this
information-based cap takes precedence over `spending = "calendar"` and
over manual `usTime` / `lsTime` overrides.

Setting `fullSpendingAtFinal = TRUE` forces the spending fraction at the
final analysis to 1 after the capped spending fractions are computed.
The example below uses a final planned spending fraction of 0.95 to show
the effect explicitly. Without `fullSpendingAtFinal`, the final spending
fraction would remain 0.95 rather than 1.

``` r
# Scenario 1 with informationRates and fullSpendingAtFinal
planned_info_rates <- c(design$timing[-design$k], 0.95)

pwr_slow_ir <- gsSurvPower(
  x = design,
  gamma = design$gamma / 2,
  targetEvents = design$n.I,
  plannedCalendarTime = design$T,
  minN = c(NA, total_N, total_N),
  minFollowUp = c(NA, 2, 12),
  maxExtension = c(3, 12, 20),
  informationRates = planned_info_rates,
  fullSpendingAtFinal = TRUE
)
```

    ## Warning in find_time_for_events(total_event_targets[analysis_index]): Target
    ## 353 events may not be achievable

``` r
spending_frac_used <- pmin(planned_info_rates, pwr_slow_ir$timing)
spending_frac_used[design$k] <- 1

data.frame(
  Analysis = 1:design$k,
  Actual_Events = round(pwr_slow_ir$n.I, 1),
  Actual_InfoFrac = round(pwr_slow_ir$timing, 3),
  Planned_InfoFrac = round(planned_info_rates, 3),
  Spending_Frac = round(spending_frac_used, 3)
)
```

    ##   Analysis Actual_Events Actual_InfoFrac Planned_InfoFrac Spending_Frac
    ## 1        1          86.1           0.369            0.333         0.333
    ## 2        2         189.3           0.811            0.667         0.667
    ## 3        3         233.6           1.000            0.950         1.000

``` r
cat("Power (default spending):       ", round(pwr_slow$power * 100, 1), "%\n")
```

    ## Power (default spending):        74.3 %

``` r
cat("Power (capped + full final):    ", round(pwr_slow_ir$power * 100, 1), "%\n")
```

    ## Power (capped + full final):     76.2 %

With `fullSpendingAtFinal = TRUE`, the final spending fraction is 1 even
though the capped planned-vs-actual fraction would otherwise be 0.95.
This produces slightly different final bounds compared to the same
`informationRates` specification with `fullSpendingAtFinal = FALSE`.

## Comparison with gsDesign power plots

The `gsDesign` package provides power plots via
`plot(design, plottype = 2)`. These hold event counts fixed at the
design values and vary only the drift parameter \\\theta\\. The table
below compares three approaches across a range of hazard ratios:

- **gsDesign**:
  [`gsProbability()`](https://keaven.github.io/gsDesign/reference/gsProbability.md)
  with design bounds, design events, scaled \\\theta\\. This is what
  `plot(design, plottype = 2)` computes.
- **gsSurvPower (fixed events)**:
  [`gsSurvPower()`](https://keaven.github.io/gsDesign/reference/gsSurvPower.md)
  with `targetEvents = design_events`. Events are held constant;
  calendar times adjust.
- **gsSurvPower (fixed calendar)**:
  [`gsSurvPower()`](https://keaven.github.io/gsDesign/reference/gsSurvPower.md)
  with `plannedCalendarTime = design$T`. Calendar times are held
  constant; events change with the assumed HR.

``` r
design_events <- design$n.I
hr_grid <- seq(0.55, 0.95, by = 0.05)

comparison <- data.frame(
  HR = hr_grid,
  gsDesign_plot = sapply(hr_grid, function(h) {
    delta_ratio <- abs(log(h)) / abs(log(design$hr))
    theta_h <- design$delta * delta_ratio
    gsp <- gsDesign::gsProbability(
      k = design$k, theta = theta_h,
      n.I = design$n.I,
      a = design$lower$bound, b = design$upper$bound, r = 18)
    sum(gsp$upper$prob)
  }),
  fixed_events = sapply(hr_grid, function(h) {
    gsSurvPower(x = design, hr = h, targetEvents = design_events)$power
  }),
  fixed_calendar = sapply(hr_grid, function(h) {
    gsSurvPower(x = design, hr = h, plannedCalendarTime = design$T)$power
  })
)
comparison[, -1] <- round(comparison[, -1] * 100, 2)
comparison
```

    ##     HR gsDesign_plot fixed_events fixed_calendar
    ## 1 0.55         99.95        99.95          99.92
    ## 2 0.60         99.57        99.57          99.43
    ## 3 0.65         97.40        97.40          97.14
    ## 4 0.70         90.00        90.00          90.00
    ## 5 0.75         74.37        74.37          75.21
    ## 6 0.80         52.53        52.53          54.10
    ## 7 0.85         31.05        31.05          32.54
    ## 8 0.90         15.36        15.36          16.20
    ## 9 0.95          6.44         6.44           6.69

**Key observations:**

- The `gsDesign_plot` and `fixed_events` columns match to numerical
  precision because both condition on the same event counts at each
  analysis. When using `targetEvents`,
  [`gsSurvPower()`](https://keaven.github.io/gsDesign/reference/gsSurvPower.md)
  reproduces the `gsDesign` power plot exactly.

- The `fixed_calendar` column differs modestly because fixing calendar
  times allows the expected event count to change with the assumed HR. A
  worse HR (closer to 1) produces more expected events at the same
  calendar time, since the experimental arm has a higher failure rate.
  This slightly changes the statistical information at each analysis,
  producing an “unconditional” power that accounts for the interplay
  between treatment effect and event accrual.

### Bounds stability

When using `targetEvents`, the efficacy and futility bounds do not
change with the assumed HR. The bounds are determined entirely by the
design parameters (alpha/beta spending, information fractions, `n.fix`)
and are reused directly from the input design `x` when the timing
matches:

``` r
design_events <- design$n.I
cat("Design bounds (Z-scale):\n")
```

    ## Design bounds (Z-scale):

``` r
cat("  Efficacy:", round(design$upper$bound, 4), "\n")
```

    ##   Efficacy: 3.0107 2.5465 1.9992

``` r
cat("  Futility:", round(design$lower$bound, 4), "\n\n")
```

    ##   Futility: -0.2388 0.941 1.9992

``` r
for (h in c(0.5, 0.7, 0.8, 1.0)) {
  pwr <- gsSurvPower(x = design, hr = h, targetEvents = design_events)
  cat(sprintf("HR=%.1f  Efficacy: %s  Futility: %s  (identical: %s)\n",
    h,
    paste(round(pwr$upper$bound, 4), collapse = ", "),
    paste(round(pwr$lower$bound, 4), collapse = ", "),
    identical(pwr$upper$bound, design$upper$bound) &&
      identical(pwr$lower$bound, design$lower$bound)))
}
```

    ## HR=0.5  Efficacy: 3.0107, 2.5465, 1.9992  Futility: -0.2388, 0.941, 1.9992  (identical: TRUE)
    ## HR=0.7  Efficacy: 3.0107, 2.5465, 1.9992  Futility: -0.2388, 0.941, 1.9992  (identical: TRUE)
    ## HR=0.8  Efficacy: 3.0107, 2.5465, 1.9992  Futility: -0.2388, 0.941, 1.9992  (identical: TRUE)
    ## HR=1.0  Efficacy: 3.0107, 2.5465, 1.9992  Futility: -0.2388, 0.941, 1.9992  (identical: TRUE)

With `plannedCalendarTime`, different assumed HRs produce different
expected event counts and therefore different information fractions, so
the bounds are appropriately recomputed via
[`gsDesign::gsDesign()`](https://keaven.github.io/gsDesign/reference/gsDesign.md).

## Changing alpha

A common use case is evaluating power at a different one-sided alpha
level — for example, when a graphical multiplicity procedure initially
allocates \\\alpha = 0.0125\\ to one hypothesis and later, after another
hypothesis is rejected, propagates alpha so that \\\alpha = 0.025\\ is
available.

Here we design at \\\alpha = 0.0125\\ and then ask: what is the power if
we can test at \\\alpha = 0.025\\?

When `x` is provided and the information fractions (timing) match the
original design,
[`gsSurvPower()`](https://keaven.github.io/gsDesign/reference/gsSurvPower.md)
recalculates **efficacy bounds** at the new alpha using
`gsDesign(test.type = 1)` (efficacy-only) while **preserving the
original futility bounds** from `x`. This follows the same convention as
[`gsBoundSummary()`](https://keaven.github.io/gsDesign/reference/gsBoundSummary.md).
Any futility bound that would exceed the new efficacy bound is clipped.

When timing changes (e.g., different `targetEvents`), both bounds are
recomputed from scratch using the full `test.type` and spending
functions.

``` r
# Design at one-sided alpha = 0.0125
design_a0125 <- gsSurv(
  k = 3, test.type = 4, alpha = 0.0125, sided = 1, beta = 0.1,
  sfu = sfHSD, sfupar = -4, sfl = sfHSD, sflpar = -2,
  lambdaC = log(2) / 12, hr = 0.7, hr0 = 1,
  eta = 0.01, gamma = 10, R = 16, minfup = 12, T = 28
)

cat("=== Original design (alpha = 0.0125) ===\n")
```

    ## === Original design (alpha = 0.0125) ===

``` r
cat("Efficacy bounds:", round(design_a0125$upper$bound, 4), "\n")
```

    ## Efficacy bounds: 3.2153 2.7838 2.2837

``` r
cat("Futility bounds:", round(design_a0125$lower$bound, 4), "\n\n")
```

    ## Futility bounds: -0.0741 1.1739 2.2837

``` r
# Power at alpha = 0.025 with same event counts (timing preserved)
events_a0125 <- design_a0125$n.I
pwr_a025 <- gsSurvPower(x = design_a0125, alpha = 0.025, targetEvents = events_a0125)

cat("=== gsSurvPower at alpha = 0.025 ===\n")
```

    ## === gsSurvPower at alpha = 0.025 ===

``` r
cat("Efficacy bounds:", round(pwr_a025$upper$bound, 4), "\n")
```

    ## Efficacy bounds: 3.0107 2.5465 1.9992

``` r
cat("Futility bounds:", round(pwr_a025$lower$bound, 4), "\n")
```

    ## Futility bounds: -0.0741 1.1739 1.9992

``` r
cat("Power:          ", round(pwr_a025$power * 100, 1), "%\n\n")
```

    ## Power:           88.6 %

``` r
# Cross-check: gsBoundSummary at the same alternate alpha
# (only test.type 1, 4, 6, 7, 8 are supported)
cat("=== gsBoundSummary (alpha = 0.025) ===\n")
```

    ## === gsBoundSummary (alpha = 0.025) ===

``` r
print(gsBoundSummary(design_a0125, alpha = 0.025))
```

    ##     Analysis              Value α=0.0125 α=0.025 Futility
    ##    IA 1: 33%                  Z   3.2153  3.0107  -0.0741
    ##       N: 576        p (1-sided)   0.0007  0.0013   0.5295
    ##  Events: 139       ~HR at bound   0.5791  0.5995   1.0127
    ##    Month: 12   P(Cross) if HR=1   0.0007  0.0013   0.4705
    ##              P(Cross) if HR=0.7   0.1324  0.1813   0.0148
    ##    IA 2: 67%                  Z   2.7838  2.5465   1.1739
    ##       N: 742        p (1-sided)   0.0027  0.0054   0.1202
    ##  Events: 278       ~HR at bound   0.7157  0.7364   0.8685
    ##    Month: 19   P(Cross) if HR=1   0.0031  0.0062   0.8857
    ##              P(Cross) if HR=0.7   0.5790  0.6689   0.0437
    ##        Final                  Z   2.2837  1.9992   2.2837
    ##       N: 742        p (1-sided)   0.0112  0.0228   0.0112
    ##  Events: 416       ~HR at bound   0.7993  0.8219   0.7993
    ##    Month: 28   P(Cross) if HR=1   0.0116  0.0219   0.9884
    ##              P(Cross) if HR=0.7   0.9000  0.9295   0.1000

Note that
[`gsBoundSummary()`](https://keaven.github.io/gsDesign/reference/gsBoundSummary.md)
adds an \\\alpha = 0.025\\ column for `test.type` 1, 4, 6, 7, and 8. For
binding types (3, 5),
[`gsBoundSummary()`](https://keaven.github.io/gsDesign/reference/gsBoundSummary.md)
does not support alternate alpha, but
[`gsSurvPower()`](https://keaven.github.io/gsDesign/reference/gsSurvPower.md)
handles them using the same approach: recompute efficacy with
`test.type = 1` at the new alpha and keep original futility bounds.

### Binding type example (test.type = 3)

``` r
design3 <- gsSurv(
  k = 3, test.type = 3, alpha = 0.0125, sided = 1, beta = 0.1,
  sfu = sfHSD, sfupar = -4, sfl = sfHSD, sflpar = -2,
  lambdaC = log(2) / 12, hr = 0.7, eta = 0.01,
  gamma = 10, R = 16, minfup = 12, T = 28
)
events3 <- design3$n.I

pwr3_a025 <- gsSurvPower(x = design3, alpha = 0.025, targetEvents = events3)

cat("=== Binding futility (test.type=3) at alpha = 0.025 ===\n")
```

    ## === Binding futility (test.type=3) at alpha = 0.025 ===

``` r
cat("Original efficacy:", round(design3$upper$bound, 4), "\n")
```

    ## Original efficacy: 3.2153 2.7835 2.2484

``` r
cat("New efficacy:     ", round(pwr3_a025$upper$bound, 4), "\n")
```

    ## New efficacy:      3.0107 2.5465 1.9992

``` r
cat("Original futility:", round(design3$lower$bound, 4), "\n")
```

    ## Original futility: -0.0936 1.1463 2.2484

``` r
cat("New futility:     ", round(pwr3_a025$lower$bound, 4), "\n")
```

    ## New futility:      -0.0936 1.1463 1.9992

``` r
cat("Power:            ", round(pwr3_a025$power * 100, 1), "%\n")
```

    ## Power:             88.2 %

The futility bounds are preserved from the original design. At the final
analysis where the original futility bound equals the original efficacy
bound, the new efficacy bound (which is lower) becomes the clip point.

The output retains the original `test.type` and records the new `alpha`:

``` r
cat("test.type:", pwr3_a025$test.type, "(same as input design)\n")
```

    ## test.type: 3 (same as input design)

``` r
cat("alpha:    ", pwr3_a025$alpha, "(updated to new value)\n")
```

    ## alpha:     0.025 (updated to new value)

## Example: event-based timing

Instead of calendar times, analyses can be triggered by target event
counts:

``` r
pwr_events <- gsSurvPower(
  x = design,
  targetEvents = c(75, 150, 225)
)
cat("Analysis times:", round(pwr_events$T, 1), "\n")
```

    ## Analysis times: 9.7 14.2 18.2

``` r
cat("Events at each analysis:",
    round(pwr_events$n.I, 1), "\n")
```

    ## Events at each analysis: 75 150 225

``` r
cat("Power:", round(pwr_events$power * 100, 1), "%\n")
```

    ## Power: 73.5 %

## Example: slower enrollment at fixed analysis times

Another common sensitivity analysis is slower-than-planned enrollment.
When calendar analysis times are fixed, slower enrollment reduces the
expected number of events available at each look and therefore reduces
power.

``` r
pwr_slow_enroll <- gsSurvPower(
  x = design,
  gamma = design$gamma / 2,
  plannedCalendarTime = design$T
)

cat("Original final expected events:", round(pwr_design$n.I[design$k], 1), "\n")
```

    ## Original final expected events: 353.2

``` r
cat("Slower-enrollment final events:", round(pwr_slow_enroll$n.I[design$k], 1), "\n")
```

    ## Slower-enrollment final events: 176.6

``` r
cat("Original power:", round(pwr_design$power * 100, 1), "%\n")
```

    ## Original power: 90 %

``` r
cat("Slower-enrollment power:", round(pwr_slow_enroll$power * 100, 1), "%\n")
```

    ## Slower-enrollment power: 62.9 %

## Example: calendar-based spending

By default, alpha and beta spending track statistical **information
fractions** (`n.I / max(n.I)`). Setting `spending = "calendar"` instead
ties spending to calendar time fractions (`T / max(T)`). This
distinction matters when analysis times are unevenly spaced: event
accrual is slow early in the trial (enrollment is ongoing), so by the
time one-third of the statistical information has accumulated the trial
is already well past one-third of its calendar duration. The first
analysis in this design occurs about 12.4 months into a 28-month
trial—an information fraction of 0.333 but a calendar fraction of 0.444.
Calendar spending therefore spends more alpha early, producing a less
conservative interim efficacy bound and a slightly more conservative
final bound.

When `spending = "calendar"`, any user-supplied `usTime` and `lsTime`
overrides are **ignored**; the realized analysis times determine
spending fractions automatically.

``` r
# Information-based spending (default)
pwr_info <- gsSurvPower(
  x = design,
  plannedCalendarTime = design$T,
  spending = "information"
)

# Calendar-based spending
pwr_cal <- gsSurvPower(
  x = design,
  plannedCalendarTime = design$T,
  spending = "calendar"
)

# Compare spending fractions and bounds
data.frame(
  Analysis = 1:design$k,
  Calendar_Time = round(pwr_info$T, 1),
  InfoFraction = round(pwr_info$timing, 3),
  CalendarFraction = round(pwr_cal$T / max(pwr_cal$T), 3),
  Bound_Info = round(pwr_info$upper$bound, 4),
  Bound_Calendar = round(pwr_cal$upper$bound, 4)
)
```

    ##   Analysis Calendar_Time InfoFraction CalendarFraction Bound_Info
    ## 1        1          12.4        0.333            0.444     3.0107
    ## 2        2          18.9        0.667            0.673     2.5465
    ## 3        3          28.0        1.000            1.000     1.9992
    ##   Bound_Calendar
    ## 1         2.8359
    ## 2         2.5874
    ## 3         2.0058

At analysis 1 (month ~12), the calendar fraction (0.444) substantially
exceeds the information fraction (0.333). Calendar spending allocates
more alpha to this look, so the efficacy bound drops from 3.01 to 2.84—
a meaningful difference for interim decision-making. By the final
analysis the bounds nearly converge because both fractions equal 1.

Note that passing `usTime` or `lsTime` with `spending = "calendar"` has
no effect—the calendar fractions override them:

``` r
pwr_cal_override <- gsSurvPower(
  x = design,
  plannedCalendarTime = design$T,
  spending = "calendar",
  usTime = c(0.2, 0.6, 1),
  lsTime = c(0.3, 0.8, 1)
)

# Bounds are identical regardless of usTime/lsTime
identical(pwr_cal$upper$bound, pwr_cal_override$upper$bound)
```

    ## [1] TRUE

## Example: stratified event targets

When a trial enrolls patients from multiple strata with different event
rates, you may want to specify per-stratum event targets rather than a
single overall number. `targetEvents` accepts a matrix with `k` rows
(analyses) and `nstrata` columns (strata). Row sums give the overall
target used to solve each analysis time.

Consider a two-stratum design where stratum 1 has median survival of 6
months and stratum 2 has 12 months. We target 30 events (20 + 10) at the
interim and 60 events (40 + 20) at the final analysis:

``` r
# Per-stratum event targets: rows = analyses, columns = strata
event_matrix <- matrix(
  c(20, 10,   # interim: 20 from stratum 1, 10 from stratum 2
    40, 20),  # final:   40 from stratum 1, 20 from stratum 2
  nrow = 2, byrow = TRUE
)

pwr_strat <- gsSurvPower(
  k = 2, test.type = 1, alpha = 0.025, sided = 1,
  lambdaC = matrix(log(2) / c(6, 12), ncol = 2),
  hr = 0.7, eta = 0.01,
  gamma = matrix(c(5, 5), ncol = 2), R = 12, ratio = 1,
  targetEvents = event_matrix
)

# The analysis times are solved so that total expected events
# match the row sums of the target matrix
data.frame(
  Analysis = 1:2,
  Target_Stratum1 = event_matrix[, 1],
  Target_Stratum2 = event_matrix[, 2],
  Target_Total = rowSums(event_matrix),
  Expected_Events = round(pwr_strat$n.I, 1),
  Calendar_Time = round(pwr_strat$T, 1)
)
```

    ##   Analysis Target_Stratum1 Target_Stratum2 Target_Total Expected_Events
    ## 1        1              20              10           30              30
    ## 2        2              40              20           60              60
    ##   Calendar_Time
    ## 1          10.5
    ## 2          17.1

``` r
cat("Power:", round(pwr_strat$power * 100, 1), "%\n")
```

    ## Power: 27.8 %

The matrix format is also used in the biomarker example below, where
`lambdaC` and `gamma` vary by stratum but `plannedCalendarTime` drives
the timing.

## Example: biomarker subgroup to stratified design

A common scenario is designing a trial for a biomarker-defined subgroup,
then assessing what power the same enrollment provides for the overall
(stratified) population under a more conservative treatment effect. Note
that the `gsDesign2` package could be used to design with different
hazard ratios in the biomarker-positive and biomarker-negative
populations simultaneously; here we illustrate the simpler approach
using
[`gsSurvPower()`](https://keaven.github.io/gsDesign/reference/gsSurvPower.md).

### Step 1: Design for the biomarker-positive subgroup

Suppose 60% of the population is biomarker-positive (prevalence = 0.6),
the control median survival in this subgroup is 12 months, the hazard
ratio is 0.65, and we target 90% power at one-sided \\\alpha = 0.0125\\
(e.g., from a graphical multiplicity allocation):

``` r
prevalence <- 0.6
median_bm_pos <- 12    # control median in biomarker+ (months)
median_bm_neg <- 10    # control median in biomarker- (shorter prognosis)

bm_design <- gsSurvCalendar(
  test.type = 4, alpha = 0.0125, beta = 0.1,
  sfu = sfHSD, sfupar = -4, sfl = sfHSD, sflpar = -2,
  calendarTime = c(12, 24, 36),
  lambdaC = log(2) / median_bm_pos, hr = 0.65, eta = 0.01,
  gamma = 10, R = 18, minfup = 18, ratio = 1
)

summary(bm_design)
```

    ## [1] "Asymmetric two-sided group sequential design with non-binding futility bound, 3 analyses, time-to-event outcome with sample size 450 and 286 events required, 90 percent power, 1.25 percent (1-sided) Type I error to detect a hazard ratio of 0.65. Enrollment and total study durations are assumed to be 18 and 36 months, respectively. Efficacy bounds derived using a Hwang-Shih-DeCani spending function with gamma = -4. Futility bounds derived using a Hwang-Shih-DeCani spending function with gamma = -2."

``` r
gsBoundSummary(bm_design)
```

    ## Method: LachinFoulkes 
    ##     Analysis               Value Efficacy Futility
    ##    IA 1: 24%                   Z   3.3706  -0.5564
    ##       N: 300         p (1-sided)   0.0004   0.7110
    ##   Events: 69        ~HR at bound   0.4424   1.1441
    ##    Month: 12    P(Cross) if HR=1   0.0004   0.2890
    ##              P(Cross) if HR=0.65   0.0563   0.0096
    ##    IA 2: 72%                   Z   2.6841   1.3965
    ##       N: 450         p (1-sided)   0.0036   0.0813
    ##  Events: 206        ~HR at bound   0.6876   0.8229
    ##    Month: 24    P(Cross) if HR=1   0.0039   0.9208
    ##              P(Cross) if HR=0.65   0.6595   0.0504
    ##        Final                   Z   2.2896   2.2896
    ##       N: 450         p (1-sided)   0.0110   0.0110
    ##  Events: 286        ~HR at bound   0.7625   0.7625
    ##    Month: 36    P(Cross) if HR=1   0.0115   0.9885
    ##              P(Cross) if HR=0.65   0.9000   0.1000

### Step 2: Power for the overall (stratified) population

Now consider enrolling the entire population using the same enrollment
duration and analysis calendar times. The biomarker-positive enrollment
rate comes from the subgroup design. The biomarker-negative enrollment
rate is proportionate based on prevalence: if biomarker-positive
patients enroll at rate \\\gamma\_{+}\\, biomarker-negative patients
enroll at rate \\\gamma\_{-} = \gamma\_{+} \times (1 - p) / p\\.

We use a **stratified** approach: `lambdaC` and `gamma` are specified as
matrices with two columns (one per stratum), allowing different control
hazard rates and enrollment rates in each biomarker subgroup. The
overall hazard ratio assumed is 0.75 (attenuated because the
biomarker-negative subgroup has a weaker treatment effect).

``` r
# Control hazard rates by stratum
lambdaC_pos <- log(2) / median_bm_pos
lambdaC_neg <- log(2) / median_bm_neg

# Enrollment rates by stratum (proportionate to prevalence)
gamma_pos <- bm_design$gamma
gamma_neg <- bm_design$gamma * (1 - prevalence) / prevalence

# Stratified inputs: matrix with columns = strata
lambdaC_strat <- matrix(c(lambdaC_pos, lambdaC_neg), ncol = 2)
gamma_strat <- matrix(c(gamma_pos, gamma_neg), ncol = 2)

pwr_overall <- gsSurvPower(
  k = 3, test.type = 4, alpha = 0.0125, sided = 1,
  sfu = sfHSD, sfupar = -4, sfl = sfHSD, sflpar = -2,
  lambdaC = lambdaC_strat, hr = 0.75, eta = 0.01,
  gamma = gamma_strat, R = 18, ratio = 1,
  plannedCalendarTime = c(12, 24, 36)
)

summary(pwr_overall)
```

    ## [1] "Asymmetric two-sided group sequential design with non-binding futility bound, 3 analyses, time-to-event outcome with sample size 748 and 511 events required, 81.6536623365655 percent power, 1.25 percent (1-sided) Type I error to detect a hazard ratio of 0.75. Enrollment and total study durations are assumed to be 18 and 36 months, respectively. Efficacy bounds derived using a Hwang-Shih-DeCani spending function with gamma = -4. Futility bounds derived using a Hwang-Shih-DeCani spending function with gamma = -2."

``` r
gsBoundSummary(pwr_overall)
```

    ## Method: LachinFoulkes 
    ##     Analysis               Value Efficacy Futility
    ##    IA 1: 25%                   Z   3.3527  -0.4978
    ##       N: 500         p (1-sided)   0.0004   0.6907
    ##  Events: 128        ~HR at bound   0.5523   1.0921
    ##    Month: 12    P(Cross) if HR=1   0.0004   0.3093
    ##              P(Cross) if HR=0.75   0.0422   0.0168
    ##    IA 2: 74%                   Z   2.6616   1.4525
    ##       N: 748         p (1-sided)   0.0039   0.0732
    ##  Events: 376        ~HR at bound   0.7598   0.8608
    ##    Month: 24    P(Cross) if HR=1   0.0042   0.9288
    ##              P(Cross) if HR=0.75   0.5527   0.0978
    ##        Final                   Z   2.2919   2.2919
    ##       N: 748         p (1-sided)   0.0110   0.0110
    ##  Events: 511        ~HR at bound   0.8164   0.8164
    ##    Month: 36    P(Cross) if HR=1   0.0115   0.9885
    ##              P(Cross) if HR=0.75   0.8165   0.1835

The overall design enrolls more patients (the full population rather
than just the 60% biomarker-positive subgroup) and has a higher event
rate in the biomarker-negative stratum (shorter control median), but
assumes a weaker overall treatment effect (HR = 0.75 vs. 0.65).

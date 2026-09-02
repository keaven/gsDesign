# Power Computation for Group Sequential Survival Designs

## Motivation

[`gsSurvPower()`](https://keaven.github.io/gsDesign/devel/reference/gsSurvPower.md)
has two primary uses:

1.  **Compute achieved power without deriving sample size.** Given
    enrollment, failure, dropout, treatment-effect, and analysis-timing
    assumptions, what power does the design achieve?
2.  **Evaluate scenarios for an existing design.** What happens when
    enrollment, failure rates, the hazard ratio, or operational timing
    rules differ from plan?

This reverses the usual role of
[`gsSurv()`](https://keaven.github.io/gsDesign/devel/reference/nSurv.md)
and
[`gsSurvCalendar()`](https://keaven.github.io/gsDesign/devel/reference/gsSurvCalendar.md),
which derive sample sizes or enrollment rates to achieve target power.

Common scenarios include:

- **Sensitivity analysis**: What happens to power if the true hazard
  ratio is 0.75 instead of the design assumption of 0.65?
- **Changing alpha**: What if the multiplicity scheme initially
  allocates \\\alpha = 0.0125\\ and later allows \\\alpha = 0.025\\?
- **Modified enrollment**: What if enrollment is slower than planned?
- **Modified failure or dropout rates**: What if events accumulate
  faster or slower than planned?
- **Different analysis times**: What if interim analyses occur at
  calendar times that differ from the original design?

[`gsSurvPower()`](https://keaven.github.io/gsDesign/devel/reference/gsSurvPower.md)
addresses these questions by computing power for a group sequential
survival design under user-specified assumptions. For deriving the
initial survival sample size design, see
[`vignette("gsSurvBasicExamples")`](https://keaven.github.io/gsDesign/devel/articles/gsSurvBasicExamples.md).
For reproducing SAS PROC SEQDESIGN survival sample size output, see
[`vignette("SeqDesignSurvival")`](https://keaven.github.io/gsDesign/devel/articles/SeqDesignSurvival.md).

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
[`gsSurv()`](https://keaven.github.io/gsDesign/devel/reference/nSurv.md),
but with `variable = "Power"`. The most useful components to inspect
first are:

- `pwr_design$power` for overall power.
- `pwr_design$n.I` for expected events at each analysis.
- `pwr_design$T` for analysis times.
- `pwr_design$timing` for information fractions.
- `pwr_design$upper$bound` and `pwr_design$lower$bound` for the bounds
  being applied.

### What this calculation does—and does not do

[`gsSurvPower()`](https://keaven.github.io/gsDesign/devel/reference/gsSurvPower.md)
applies asymptotic group sequential calculations to expected enrollment,
dropout, event accumulation, and analysis timing under one set of
assumptions. Thus, an event- or enrollment-triggered analysis time is
the *expected* time at which its rule is met.

It does not simulate trial-to-trial variation in enrollment, failure,
dropout, or operational analysis timing. Use simulation when that
variability may materially affect operating characteristics, such as the
probability of meeting competing timing rules, the distribution of
analysis dates, or power under realistic trial execution. Packages such
as [**simtrial**](https://merck.github.io/simtrial/) can support that
more comprehensive evaluation.

## How gsSurvPower uses your inputs

[`gsSurvPower()`](https://keaven.github.io/gsDesign/devel/reference/gsSurvPower.md)
accepts an optional `gsSurv`-class object `x`, including output from
[`gsSurv()`](https://keaven.github.io/gsDesign/devel/reference/nSurv.md)
and
[`gsSurvCalendar()`](https://keaven.github.io/gsDesign/devel/reference/gsSurvCalendar.md),
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

### Beta spending in scenario analyses

Beta spending is a design rule for constructing futility bounds, not a
promise that every scenario evaluated will have the design’s Type II
error. It helps to separate two quantities:

- **Design beta** (`x$beta`) is allocated across analyses by `sfl`,
  `sflpar`, and the lower spending-time vector. For beta-spending
  designs, the futility bounds are calibrated under `hr1`, the design
  alternative.
- **Achieved beta** (`1 - power`, returned as `beta`) is the probability
  of not rejecting the null under the scenario’s `hr`, enrollment,
  failure, dropout, and analysis timing. It can be much larger or
  smaller than design beta.

For `test.type = 4`, the non-binding designation means that the futility
bound is ignored when controlling Type I error. It remains an
operational stopping bound and therefore affects achieved power. The
same distinction between design beta and achieved beta applies to the
beta-spending futility bounds in `test.type` 3, 7, and 8. Test types 5
and 6 instead spend lower-bound probability under the null, and harm
spending for test types 7 and 8 is a separate null-based calculation.

When a reference design `x` is supplied, futility-bound handling follows
these rules:

| Scenario change | Futility-bound handling |
|----|----|
| Information fractions and spending inputs unchanged | Reuse the bounds from `x` |
| Only alpha or the upper spending function changes, with timing unchanged | Preserve the bounds from `x`, clipping only if a lower bound exceeds the new efficacy bound |
| Information fractions or spending times change | Recompute the bounds on the new schedule using design beta, `hr1`, `sfl`, and `sflpar` |
| `informationRates`, calendar or planned-versus-actual spending, or `lsTime` is supplied | Derive the selected lower effective spending-time vector and recompute the bounds |

Thus, changing `hr` with fixed event targets generally preserves the
original information fractions and futility bounds. Changing `hr` at
fixed calendar times can change expected event fractions, causing the
bounds to be recalibrated on the new information schedule while
retaining the original design-beta calibration.

For instance, the following comparison evaluates the design assumptions
and then HR = 0.8 with either fixed event targets or fixed calendar
times. The target beta spending remains 0.10, but achieved beta is much
higher under the weaker treatment effect. Fixed events preserve the
original bounds; fixed calendar times slightly change expected
information fractions and therefore the recalibrated bounds.

``` r

beta_cases <- list(
  `Design assumptions` = pwr_design,
  `HR 0.8, fixed events` = gsSurvPower(
    x = design, hr = 0.8, targetEvents = design$n.I
  ),
  `HR 0.8, fixed calendar` = gsSurvPower(
    x = design, hr = 0.8, plannedCalendarTime = design$T
  )
)

collapse_values <- function(x) paste(round(x, 3), collapse = ", ")

data.frame(
  Scenario = names(beta_cases),
  Information_Fractions = vapply(
    beta_cases, function(x) collapse_values(x$timing), character(1)
  ),
  Futility_Bounds = vapply(
    beta_cases, function(x) collapse_values(x$lower$bound), character(1)
  ),
  Target_Beta_Spending = vapply(
    beta_cases, function(x) sum(x$lower$spend), numeric(1)
  ),
  Achieved_Beta = vapply(beta_cases, function(x) x$beta, numeric(1))
)
```

    ##                                      Scenario Information_Fractions
    ## Design assumptions         Design assumptions       0.333, 0.667, 1
    ## HR 0.8, fixed events     HR 0.8, fixed events       0.333, 0.667, 1
    ## HR 0.8, fixed calendar HR 0.8, fixed calendar       0.337, 0.671, 1
    ##                             Futility_Bounds Target_Beta_Spending Achieved_Beta
    ## Design assumptions     -0.239, 0.941, 1.999                  0.1    0.09999999
    ## HR 0.8, fixed events   -0.239, 0.941, 1.999                  0.1    0.47468735
    ## HR 0.8, fixed calendar     -0.222, 0.957, 2                  0.1    0.45896681

### Analysis timing: calendar time vs. event-driven

Analysis times can be specified by calendar time, by target event
counts, or by a combination of criteria. The choice has an important
consequence for sensitivity analyses:

- **`plannedCalendarTime`** fixes the calendar time when used alone.
  When combined with other timing rules, it supplies an earliest time or
  floor. Expected events are then recomputed under the assumed HR. A
  worse HR (closer to 1) produces *more* expected events at the same
  calendar time because the experimental arm fails faster. This gives an
  “unconditional” power that reflects how the assumed treatment effect
  influences event accrual.

- **`targetEvents`** fixes the overall event count at each analysis. The
  calendar time is the time until expected events reach the target under
  the assumed HR. Since the event counts are held constant, the
  information fractions do not change with HR, and the resulting power
  matches the `gsDesign` power plot (`plot(x, plottype = 2)`) to
  numerical precision.

Both modes are useful. Calendar-time analyses are natural when the
protocol specifies analysis dates; event-driven analyses are natural
when the protocol specifies event targets.

When both `plannedCalendarTime` and `targetEvents` are specified,
`plannedCalendarTime` is a floor rather than an exact analysis time. If
the expected event target is reached before that time, the analysis
remains at the planned calendar time and may include more events than
targeted. If the target has not been reached, the analysis is delayed
until it is reached. Supplying `maxExtension` caps that delay at
`plannedCalendarTime + maxExtension`; when the cap is reached first, the
analysis proceeds with fewer expected events than targeted. Other
applicable floor criteria can require an even later analysis, subject to
the same hard extension cap.

`maxCalendarTime` supplies a different kind of deadline: it is an
absolute calendar-time cap rather than an extension measured from a
timing anchor. After combining all floor and event requirements, the
expected analysis time is capped at `maxCalendarTime`. If both
`maxExtension` and `maxCalendarTime` are supplied, the earlier deadline
applies. This distinction preserves the existing meaning of
`maxExtension` while matching the absolute-cap behavior of simtrial’s
`max_extension_for_target_event`.

### Quick decision guide

| Operational rule | Argument | Interpretation |
|----|----|----|
| Analyze at a calendar time | `plannedCalendarTime` | Exact time alone; earliest time when combined |
| Analyze after an overall event target | `targetEvents` | Expected time the overall target is reached |
| Require event targets by stratum | `targetEventsPerStratum` | Earliest time every active stratum target is reached |
| Require spacing between looks | `minTimeFromPreviousAnalysis` | Earliest time relative to the previous analysis |
| Require enrollment plus follow-up | `minN`, `minFollowUp` | Earliest time satisfying both criteria |
| Require enrollment by stratum plus follow-up | `minNPerStratum`, `minFollowUp` | Earliest time every active stratum requirement plus follow-up is met |
| Require final minimum follow-up | explicit `minfup` | Final-analysis floor after enrollment ends |
| Cap delay relative to a timing anchor | `maxExtension` | Relative hard cap preserving the existing gsDesign convention |
| Stop at an absolute calendar deadline | `maxCalendarTime` | Absolute hard cap, corresponding to simtrial cut behavior |

For scenario analyses, override only the assumptions that change:

| Scenario                           | Arguments commonly changed          |
|------------------------------------|-------------------------------------|
| Treatment effect                   | `hr`                                |
| Control failure rates              | `lambdaC`, `S`                      |
| Dropout                            | `eta`, `etaE`                       |
| Enrollment rate or shape           | `gamma`                             |
| Enrollment duration or target size | `R`, or `targetN`                   |
| Operational analysis rules         | Timing arguments in the table above |

Per-analysis timing rules can be combined, each specified as a scalar
(recycled to all `k` analyses) or a vector of length `k` with `NA` for
“not applicable”:

- `plannedCalendarTime`: Calendar-time floor for the analysis.
- `targetEvents`: Overall event requirement for the analysis.
- `maxExtension`: Maximum time beyond the floor to wait for target
  events.
- `maxCalendarTime`: Absolute calendar-time deadline for an analysis.
- `minTimeFromPreviousAnalysis`: Minimum elapsed time since the previous
  analysis.
- `minN`: Minimum sample size enrolled before analysis.
- `minNPerStratum`: Matrix of minimum enrollment by analysis and
  stratum; `NA` deactivates only the corresponding stratum requirement.
- `minFollowUp`: Additional follow-up after active `minN` or
  `minNPerStratum` requirements are reached. `NA` means no additional
  follow-up, while a non-missing value requires an enrollment threshold
  at the same analysis.
- `targetEventsPerStratum`: Matrix of event requirements by analysis and
  stratum; `NA` deactivates only the corresponding stratum requirement.

Each analysis must retain at least one active floor or event
requirement. The mixed-`NA` convention is specific to timing rules. For
selective bounds, use `FALSE` rather than `NA` in `testUpper`,
`testLower`, or `testHarm`. Spending-time inputs (`informationRates`,
`usTime`, and `lsTime`) describe a complete spending schedule and
therefore must not contain `NA`.

When multiple criteria apply to a single analysis, the analysis time is
the maximum of all floor criteria and all overall or per-stratum
event-target times. Thus, active requirements use AND logic.
`maxExtension` defines a hard deadline: the analysis time never exceeds
`plannedCalendarTime + maxExtension` (or `T[i-1] + maxExtension` when no
calendar time is specified), even if other criteria such as
`minTimeFromPreviousAnalysis` or enrollment plus follow-up would push it
later. `maxCalendarTime` is then applied as an absolute cap.

### Relationship to simtrial analysis cuts

The timing grammar intentionally parallels
[`simtrial::get_analysis_date()`](https://merck.github.io/simtrial/reference/get_analysis_date.html),
with camel-case names and one value per planned analysis. The main
distinction is conceptual:
[`gsSurvPower()`](https://keaven.github.io/gsDesign/devel/reference/gsSurvPower.md)
applies the rules to expected event and enrollment counts, whereas
simtrial applies them to a realized simulated data set. Consequently,
matching rules do not imply identical analysis dates in any one
simulated trial.

| simtrial cut argument | [`gsSurvPower()`](https://keaven.github.io/gsDesign/devel/reference/gsSurvPower.md) argument | Relationship |
|----|----|----|
| `planned_calendar_time` | `plannedCalendarTime` | Calendar-time floor when combined |
| `target_event_overall` | `targetEvents` | Overall event requirement |
| `target_event_per_stratum` | `targetEventsPerStratum` | Per-stratum requirement; rows index analyses and columns index strata |
| `min_time_after_previous_analysis` | `minTimeFromPreviousAnalysis` | Minimum gap from the preceding analysis |
| `min_n_overall` | `minN` | Overall enrollment requirement |
| `min_n_per_stratum` | `minNPerStratum` | Per-stratum enrollment requirement; rows index analyses and columns index strata |
| `min_followup` | `minFollowUp` | Follow-up after all active enrollment requirements |
| `max_extension_for_target_event` | `maxCalendarTime` | Absolute calendar cap, despite the simtrial argument’s name |

simtrial specifies one cut at a time and therefore uses a named vector
for its per-stratum requirements.
[`gsSurvPower()`](https://keaven.github.io/gsDesign/devel/reference/gsSurvPower.md)
specifies all `k` analyses in one call and uses a `k`-by-`nstrata`
matrix; use `NA` for an inactive stratum at a look. `maxExtension`
remains available for the older gsDesign relative-cap convention and has
no exact simtrial counterpart.

### Common timing pitfalls

The timing arguments in
[`gsSurvPower()`](https://keaven.github.io/gsDesign/devel/reference/gsSurvPower.md)
describe a fixed operational plan. They do not solve the study design to
achieve power the way
[`gsSurv()`](https://keaven.github.io/gsDesign/devel/reference/nSurv.md)
does. Several inputs are therefore easy to misread.

**`minfup` is a final-analysis floor, not a target event rule.** If
`minfup` is explicitly supplied, the final analysis cannot occur before
enrollment has ended and the last enrolled subject has at least that
much follow-up. For an event-driven design with enrollment durations
`R`, the final analysis time is at least `sum(R) + minfup`. If the
requested final `targetEvents` is expected earlier, the final analysis
remains delayed to satisfy minimum follow-up, and the expected final
event count may exceed the event target.

``` r

pwr_minfup <- gsSurvPower(
  k = 3, test.type = 1, alpha = 0.025, sided = 1,
  sfu = sfLDOF, sfupar = NULL,
  lambdaC = log(2) / 15, hr = 0.7, hr0 = 1,
  eta = 0.001,
  gamma = c(1, 2, 3, 4) * 500 /
    sum(c(1, 2, 3, 4) * c(2, 2, 2, 6)),
  R = c(2, 2, 2, 6),
  targetEvents = c(100, 200, 300),
  minfup = 25,
  ratio = 1.5,
  testUpper = TRUE, testLower = FALSE
)

data.frame(
  Analysis = 1:3,
  Time = round(pwr_minfup$T, 1),
  Events = round(pwr_minfup$n.I, 1)
)
```

    ##   Analysis Time Events
    ## 1        1 13.3  100.0
    ## 2        2 21.1  200.0
    ## 3        3 37.0  329.9

**`targetN` changes enrollment duration, not enrollment rates.** Use
`targetN` when `gamma` gives relative or absolute enrollment rates and
you want
[`gsSurvPower()`](https://keaven.github.io/gsDesign/devel/reference/gsSurvPower.md)
to rescale `R` so that `sum(gamma * R) == targetN`. Do not also specify
a non-`NULL` `R`. If the protocol fixes enrollment duration, specify `R`
and scale `gamma` yourself.

``` r

pwr_target_n <- gsSurvPower(
  k = 2, test.type = 1, alpha = 0.025, sided = 1,
  lambdaC = log(2) / 15, hr = 0.7, hr0 = 1,
  eta = 0.001,
  gamma = c(10, 20, 30, 40),
  targetN = 500,
  plannedCalendarTime = c(24, 36),
  ratio = 1.5,
  testUpper = TRUE, testLower = FALSE
)

pwr_target_n$R
```

    ## [1] 5 5 5 5

``` r

sum(rowSums(pwr_target_n$gamma) * pwr_target_n$R)
```

    ## [1] 500

**`maxExtension` needs a floor time.** `maxExtension` is the amount of
time the analysis may wait beyond a floor criterion while waiting for
`targetEvents`. A floor can come from `plannedCalendarTime`,
`minTimeFromPreviousAnalysis`, `minN`, or an explicitly supplied final
`minfup`. Without a floor, `maxExtension` is not meaningful.

``` r

pwr_extension <- gsSurvPower(
  k = 3, test.type = 1, alpha = 0.025, sided = 1,
  lambdaC = log(2) / 15, hr = 0.7, hr0 = 1,
  eta = 0.001,
  gamma = c(1, 2, 3, 4) * 500 /
    sum(c(1, 2, 3, 4) * c(2, 2, 2, 6)),
  R = c(2, 2, 2, 6),
  plannedCalendarTime = c(24, 30, 36),
  targetEvents = c(200, 300, 400),
  maxExtension = c(0, 6, 6),
  ratio = 1.5,
  testUpper = TRUE, testLower = FALSE
)

round(pwr_extension$T, 1)
```

    ## [1] 24.0 32.4 42.0

**`maxCalendarTime` is an absolute date, not a duration.** Use it when
the operational rule is “analyze no later than month 30,” including when
there is an event requirement but no natural floor from which to measure
an extension. If a target or floor is not reached by that date, the
analysis proceeds at the cap under the expected-value calculation. This
matches how simtrial applies `max_extension_for_target_event`, despite
the latter argument’s name. When a relative extension and an absolute
deadline are both part of the plan, supply both cap arguments; the
earlier one controls.

**`minN + minFollowUp` can define analysis timing, but analyses must
remain strictly increasing.** This pair says: wait until at least `minN`
subjects are enrolled, then wait `minFollowUp` additional time. It can
be used as the primary timing rule, but the resulting analysis times and
expected event totals must increase across analyses. If two analyses use
the same enrollment threshold and follow-up rule, add
`plannedCalendarTime`, `targetEvents`, or `minTimeFromPreviousAnalysis`
to separate them.

For a stratified plan, replace or supplement `minN` with a
`minNPerStratum` matrix. The follow-up clock starts after the last
active overall or per-stratum enrollment threshold is reached.

``` r

pwr_min_n <- gsSurvPower(
  k = 3, test.type = 1, alpha = 0.025, sided = 1,
  lambdaC = log(2) / 15, hr = 0.7, hr0 = 1,
  eta = 0.001,
  gamma = c(1, 2, 3, 4) * 500 /
    sum(c(1, 2, 3, 4) * c(2, 2, 2, 6)),
  R = c(2, 2, 2, 6),
  minN = c(100, 300, 500),
  minFollowUp = c(6, 6, 6),
  ratio = 1.5,
  testUpper = TRUE, testLower = FALSE
)

data.frame(
  Analysis = 1:3,
  Time = round(pwr_min_n$T, 1),
  N = round(pwr_min_n$N, 1),
  Events = round(pwr_min_n$n.I, 1)
)
```

    ##   Analysis Time     N Events
    ## 1        1 10.4 411.1   56.3
    ## 2        2 14.4 500.0  115.7
    ## 3        3 18.0 500.0  163.7

### Spending and method

- **`spending`**: One of `"information"` (default), `"calendar"`, or
  `"min_planned_actual"`. Information-based spending tracks the fraction
  of statistical information accumulated; calendar-based spending sets
  `usTime = lsTime = T / max(T)`. With a reference design `x`,
  planned-versus-actual spending sets both spending-time vectors to
  `pmin(x$n.I, actual events) / x$n.I[k]`, matching simtrial’s
  `ia_alpha_spending = "min_planned_actual"` convention. Custom spending
  times can also be passed via `usTime` and `lsTime`, but they are
  ignored for the latter two modes.

- **`informationRates`**: Planned information-fraction caps (complete
  vector of length `k`, without missing values). At each analysis, the
  effective spending time is `pmin(informationRates, actual_timing)`.
  Thus, spending cannot run ahead of either the planned information
  schedule or the information actually accumulated. `informationRates`
  takes precedence over `spending`, `usTime`, and `lsTime`; upper and
  lower spending both use the same effective spending-time vector.

- **`fullSpendingAtFinal`**: When `TRUE`, the final element of the upper
  and lower spending-time vectors is forced to 1 after applying
  `informationRates`, calendar spending, or user-supplied `usTime` /
  `lsTime`. This is useful when a selected spending-time vector would
  otherwise leave either upper- or lower-bound spending incomplete.

- **`method`**: One of `"LachinFoulkes"` (default), `"Schoenfeld"`,
  `"Freedman"`, or `"BernsteinLagakos"`. Controls how fixed-design
  events (`n.fix`) and drift parameter \\\theta\\ are computed when `x`
  is not provided. When `x` is provided, `x$n.fix` and, implicitly,
  \\\theta\\ are used directly for exact consistency with the design.

### Stratified timing arguments

`targetEvents` accepts a scalar (recycled), a vector of length `k` (one
overall target per analysis). Use `targetEventsPerStratum` for a matrix
with `k` rows and `nstrata` columns. A vector of length `k` is always
interpreted as overall targets; to specify per-stratum targets for a
single analysis, use a 1-row matrix. Overall and per-stratum event
requirements can be supplied together, and the analysis waits for all
active requirements unless a cap intervenes. A matrix passed to
`targetEvents` remains accepted as a deprecated alias, but its entries
are now enforced per stratum rather than being reduced to row sums.

`minNPerStratum` uses the same matrix layout for enrollment
requirements. When it is supplied with `minFollowUp`, the follow-up
interval begins only after every active overall and per-stratum
enrollment requirement has been reached.

## Power under alternative assumptions

Passing the design’s analysis times with the same hazard ratio exactly
reproduces the design power (90%). Internally,
[`gsSurvPower()`](https://keaven.github.io/gsDesign/devel/reference/gsSurvPower.md)
uses `x$n.fix` (when `x` is provided) so that the drift parameter
\\\theta\\ and bounds are normalized identically to
[`gsSurv()`](https://keaven.github.io/gsDesign/devel/reference/nSurv.md).
The assumed HR’s drift is obtained by method-specific scaling:

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

For instance, the following example shows how departures from the
planned hazard ratio affect power when the planned calendar analysis
times are held fixed.

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
[`gsSurvPower()`](https://keaven.github.io/gsDesign/devel/reference/gsSurvPower.md)
lets you combine all of these in a single call. As noted above, these
are expected-value calculations; simulation is needed to characterize
variability in when the rules are met. For instance, the following
examples show the impact of slower enrollment and faster control
failures when timing floors and extension caps are applied together.

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


pwr_slow_simple |> gsBoundSummary() |> lt()
```

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

### Controlling effective spending time

When events fall short of the target (as in Scenario 1), the actual
event count at each analysis may be lower than planned. By default,
bounds are computed at the scenario’s information fractions,
`n.I / max(n.I)`, which always end at 1. With a reference design `x`,
`spending = "min_planned_actual"` instead uses
`pmin(x$n.I, scenario n.I) / x$n.I[k]`. This is the expected-value
analogue of simtrial’s planned-versus-actual spending option: spending
cannot run ahead of the planned event count at a look or the events
expected under the scenario.

``` r

pwr_slow_min_spending <- gsSurvPower(
  x = design,
  gamma = design$gamma / 2,
  targetEvents = design$n.I,
  plannedCalendarTime = design$T,
  minN = c(NA, total_N, total_N),
  minFollowUp = c(NA, 2, 12),
  maxExtension = c(3, 12, 20),
  spending = "min_planned_actual"
)
```

    ## Warning in find_time_for_events(total_event_targets[analysis_index]): Target
    ## 353 events may not be achievable

``` r

data.frame(
  Analysis = 1:design$k,
  Planned_Events = round(design$n.I, 1),
  Scenario_Events = round(pwr_slow_min_spending$n.I, 1),
  Effective_Spending_Time = round(
    pmin(design$n.I, pwr_slow_min_spending$n.I) / design$n.I[design$k],
    3
  )
)
```

    ##   Analysis Planned_Events Scenario_Events Effective_Spending_Time
    ## 1        1          117.7            86.1                   0.244
    ## 2        2          235.5           189.3                   0.536
    ## 3        3          353.2           233.6                   0.661

The same effective spending-time vector is used for the upper and lower
bounds. Set `fullSpendingAtFinal = TRUE` to spend fully at the final
analysis, corresponding to simtrial’s
`fa_alpha_spending = "full_alpha"`; leave it `FALSE` for
information-fraction final spending.

#### User-specified spending-time caps with `informationRates`

For a spending schedule specified directly rather than through the
reference design’s planned event counts, `informationRates` supplies
planned information-fraction caps. The effective spending time is
`pmin(informationRates, actual_timing)` at each analysis. This prevents
spending ahead of the planned information schedule when events arrive
faster than planned and ahead of the information actually accumulated
when events arrive slower. If `informationRates` is supplied, it takes
precedence over `spending = "calendar"` and over manual `usTime` /
`lsTime` overrides.

Setting `fullSpendingAtFinal = TRUE` forces both the upper and lower
effective spending times at the final analysis to 1 after the caps are
applied. The example below uses a final planned information-fraction cap
of 0.95 to show the effect explicitly. Without `fullSpendingAtFinal`,
the final effective spending time would remain 0.95 rather than 1.

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

effective_spending_time <- pmin(planned_info_rates, pwr_slow_ir$timing)
effective_spending_time[design$k] <- 1

data.frame(
  Analysis = 1:design$k,
  Actual_Events = round(pwr_slow_ir$n.I, 1),
  Actual_InfoFrac = round(pwr_slow_ir$timing, 3),
  Planned_InfoFrac = round(planned_info_rates, 3),
  Effective_Spending_Time = round(effective_spending_time, 3),
  Futility_Bound = round(pwr_slow_ir$lower$bound, 3),
  Incremental_Beta_Spend = round(pwr_slow_ir$lower$spend, 4)
)
```

    ##   Analysis Actual_Events Actual_InfoFrac Planned_InfoFrac
    ## 1        1          86.1           0.369            0.333
    ## 2        2         189.3           0.811            0.667
    ## 3        3         233.6           1.000            0.950
    ##   Effective_Spending_Time Futility_Bound Incremental_Beta_Spend
    ## 1                   0.333         -0.166                 0.0148
    ## 2                   0.667          1.173                 0.0289
    ## 3                   1.000          1.981                 0.0563

``` r

cat("Power (default spending):       ", round(pwr_slow$power * 100, 1), "%\n")
```

    ## Power (default spending):        74.3 %

``` r

cat("Power (capped + full final):    ", round(pwr_slow_ir$power * 100, 1), "%\n")
```

    ## Power (capped + full final):     76.2 %

With `fullSpendingAtFinal = TRUE`, the final upper and lower effective
spending times are 1 even though the planned-vs-actual cap would
otherwise be 0.95. The displayed incremental beta spending shows how
design beta is allocated across the recalibrated futility bounds. This
produces slightly different final bounds compared to the same
`informationRates` specification with `fullSpendingAtFinal = FALSE`.

## Additional and advanced examples

The remaining sections cover validation against standard power plots and
more specialized changes to spending, alpha, and stratified assumptions.
They are useful when the basic scenario-and-timing workflow above is not
sufficient. For instance, in the following example the impact of fixing
event counts rather than calendar times is shown across a range of
hazard ratios.

### Comparison with gsDesign power plots

The `gsDesign` package provides power plots via
`plot(design, plottype = 2)`. These hold event counts fixed at the
design values and vary only the drift parameter \\\theta\\. The table
below compares three approaches across a range of hazard ratios:

- **gsDesign**:
  [`gsProbability()`](https://keaven.github.io/gsDesign/devel/reference/gsProbability.md)
  with design bounds, design events, scaled \\\theta\\. This is what
  `plot(design, plottype = 2)` computes.
- **gsSurvPower (fixed events)**:
  [`gsSurvPower()`](https://keaven.github.io/gsDesign/devel/reference/gsSurvPower.md)
  with `targetEvents = design_events`. Events are held constant;
  calendar times adjust.
- **gsSurvPower (fixed calendar)**:
  [`gsSurvPower()`](https://keaven.github.io/gsDesign/devel/reference/gsSurvPower.md)
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
  [`gsSurvPower()`](https://keaven.github.io/gsDesign/devel/reference/gsSurvPower.md)
  reproduces the `gsDesign` power plot exactly.

- The `fixed_calendar` column differs modestly because fixing calendar
  times allows the expected event count to change with the assumed HR. A
  worse HR (closer to 1) produces more expected events at the same
  calendar time, since the experimental arm has a higher failure rate.
  This slightly changes the statistical information at each analysis,
  producing an “unconditional” power that accounts for the interplay
  between treatment effect and event accrual.

#### Bounds stability

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
[`gsDesign::gsDesign()`](https://keaven.github.io/gsDesign/devel/reference/gsDesign.md).

### Changing alpha

A common use case is evaluating power at a different one-sided alpha
level — for example, when a graphical multiplicity procedure initially
allocates \\\alpha = 0.0125\\ to one hypothesis and later, after another
hypothesis is rejected, propagates alpha so that \\\alpha = 0.025\\ is
available.

Here we design at \\\alpha = 0.0125\\ and then ask: what is the power if
we can test at \\\alpha = 0.025\\?

When `x` is provided and the information fractions (timing) match the
original design,
[`gsSurvPower()`](https://keaven.github.io/gsDesign/devel/reference/gsSurvPower.md)
recalculates **efficacy bounds** at the new alpha using the non-binding
efficacy convention while **preserving the original efficacy testing
schedule and futility bounds** from `x`. This follows the same
convention as
[`gsBoundSummary()`](https://keaven.github.io/gsDesign/devel/reference/gsBoundSummary.md).
Any futility bound that would exceed the new efficacy bound is clipped.

For test types 1, 4, 6, and 8 this non-binding calculation is
appropriate for evaluating alpha propagated by a Maurer–Bretz graphical
multiple-testing procedure. For binding test types 2, 3, 5, and 7, the
calculation below is a planning sensitivity analysis only and should not
be interpreted as graphical alpha recycling or as a sequential p-value.

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

    ## Power:           93 %

``` r

# Cross-check: gsBoundSummary at the same alternate alpha
# (only non-binding test.type 1, 4, 6, and 8 are supported)
cat("=== gsBoundSummary (alpha = 0.025) ===\n")
```

    ## === gsBoundSummary (alpha = 0.025) ===

``` r

gsBoundSummary(design_a0125, alpha = 0.025) |> lt()
```

Note that
[`gsBoundSummary()`](https://keaven.github.io/gsDesign/devel/reference/gsBoundSummary.md)
adds an \\\alpha = 0.025\\ column for non-binding `test.type` 1, 4, 6,
and 8. It does not support alternate alpha for binding types 2, 3, 5, or
7.
[`gsSurvPower()`](https://keaven.github.io/gsDesign/devel/reference/gsSurvPower.md)
can still recompute efficacy with the non-binding convention for a
binding input design, retain the original `testUpper` schedule, and keep
the original futility bounds, but that result is a planning sensitivity
analysis rather than a Maurer–Bretz multiplicity calculation.

#### Binding type planning sensitivity example (test.type = 3)

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

    ## Power:             92.7 %

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

### Event-based timing

Instead of calendar times, analyses can be triggered by target event
counts. For instance, the following example fixes the information at
each analysis through event targets while allowing the expected calendar
times to adjust.

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

### Slower enrollment at fixed analysis times

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

### Calendar-based spending

By default, alpha and beta spending track statistical **information
fractions** (`n.I / max(n.I)`). Setting `spending = "calendar"` instead
ties spending to calendar time fractions (`T / max(T)`). This
distinction matters when analysis times are unevenly spaced: event
accrual is slow early in the trial (enrollment is ongoing), so by the
time one-third of the statistical information has accumulated the trial
is already well past one-third of its calendar duration. The first
analysis in this design occurs about 12.4 months into a 28-month
trial—an information fraction of 0.333 but a calendar fraction of 0.444.
Calendar spending therefore spends more alpha and beta early, producing
less conservative interim efficacy and futility bounds and slightly more
conservative final bounds.

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
  Efficacy_Info = round(pwr_info$upper$bound, 4),
  Efficacy_Calendar = round(pwr_cal$upper$bound, 4),
  Futility_Info = round(pwr_info$lower$bound, 4),
  Futility_Calendar = round(pwr_cal$lower$bound, 4),
  Beta_Spend_Info = round(pwr_info$lower$spend, 4),
  Beta_Spend_Calendar = round(pwr_cal$lower$spend, 4)
)
```

    ##   Analysis Calendar_Time InfoFraction CalendarFraction Efficacy_Info
    ## 1        1          12.4        0.333            0.444        3.0107
    ## 2        2          18.9        0.667            0.673        2.5465
    ## 3        3          28.0        1.000            1.000        1.9992
    ##   Efficacy_Calendar Futility_Info Futility_Calendar Beta_Spend_Info
    ## 1            2.8359       -0.2388           -0.0593          0.0148
    ## 2            2.5874        0.9410            0.8902          0.0289
    ## 3            2.0058        1.9992            2.0058          0.0563
    ##   Beta_Spend_Calendar
    ## 1              0.0224
    ## 2              0.0222
    ## 3              0.0555

At analysis 1 (month ~12), the calendar fraction (0.444) substantially
exceeds the information fraction (0.333). Calendar spending allocates
more alpha to this look, so the efficacy bound drops from 3.01 to 2.84—
a meaningful difference for interim decision-making. By the final
analysis the bounds nearly converge because both fractions equal 1. The
same change allocates more design beta to the first look and raises the
futility bound from -0.24 to -0.06, making early futility stopping
easier.

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

### Stratified event targets

When a trial enrolls patients from multiple strata with different event
rates, you may want to specify per-stratum event targets rather than a
single overall number. `targetEventsPerStratum` accepts a matrix with
`k` rows (analyses) and `nstrata` columns (strata). The analysis waits
until each non-`NA` entry in its row is reached. Because event rates can
differ across strata, events in one stratum can exceed its requirement
while the other stratum catches up; the overall count therefore need not
equal the row sum.

Consider a two-stratum design where stratum 1 has median survival of 6
months and stratum 2 has 12 months. We require at least 20 and 10 events
by stratum at the interim, and 40 and 20 events by stratum at the final
analysis:

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
  targetEventsPerStratum = event_matrix
)

# Every stratum requirement is met; one can be exceeded while another catches up.
actual_events_by_stratum <- pwr_strat$eDC + pwr_strat$eDE
data.frame(
  Analysis = 1:2,
  Target_Stratum1 = event_matrix[, 1],
  Expected_Stratum1 = round(actual_events_by_stratum[, 1], 1),
  Target_Stratum2 = event_matrix[, 2],
  Expected_Stratum2 = round(actual_events_by_stratum[, 2], 1),
  Expected_Total = round(pwr_strat$n.I, 1),
  Calendar_Time = round(pwr_strat$T, 1)
)
```

    ##   Analysis Target_Stratum1 Expected_Stratum1 Target_Stratum2 Expected_Stratum2
    ## 1        1              20                20              10              11.7
    ## 2        2              40                40              20              26.3
    ##   Expected_Total Calendar_Time
    ## 1           31.7          10.8
    ## 2           66.3          19.1

``` r

cat("Power:", round(pwr_strat$power * 100, 1), "%\n")
```

    ## Power: 30.3 %

The biomarker example below also uses matrix-valued `lambdaC` and
`gamma` to represent strata, but its timing is driven by
`plannedCalendarTime` rather than per-stratum targets.

### Biomarker subgroup to stratified design

A common scenario is designing a trial for a biomarker-defined subgroup,
then assessing what power the same enrollment provides for the overall
(stratified) population under a more conservative treatment effect. Note
that the `gsDesign2` package could be used to design with different
hazard ratios in the biomarker-positive and biomarker-negative
populations simultaneously; here we illustrate the simpler approach
using
[`gsSurvPower()`](https://keaven.github.io/gsDesign/devel/reference/gsSurvPower.md).

#### Step 1: Design for the biomarker-positive subgroup

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

gsBoundSummary(bm_design) |> lt()
```

#### Step 2: Power for the overall (stratified) population

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

gsBoundSummary(pwr_overall) |> lt()
```

The overall design enrolls more patients (the full population rather
than just the 60% biomarker-positive subgroup) and has a higher event
rate in the biomarker-negative stratum (shorter control median), but
assumes a weaker overall treatment effect (HR = 0.75 vs. 0.65).

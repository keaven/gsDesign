# Compute power for a group sequential survival design

`gsSurvPower()` computes power for a group sequential survival design
with specified enrollment, dropout, treatment effect, and analysis
timing. Unlike
[`gsSurv()`](https://keaven.github.io/gsDesign/devel/reference/nSurv.md)
and
[`gsSurvCalendar()`](https://keaven.github.io/gsDesign/devel/reference/gsSurvCalendar.md)
which solve for sample size to achieve target power, `gsSurvPower()`
takes fixed design assumptions and computes the resulting power. Its two
primary uses are computing achieved power when sample size is not being
derived and evaluating alternative enrollment, failure,
treatment-effect, and analysis timing scenarios. It computes one set of
assumptions at a time; scenario grids are evaluated with separate calls.
For `k = 1`, power is computed through the fixed-design
`nSurv(beta = NULL)` path. The returned object is normalized as a
single-analysis `gsSurv` object so it can be passed to
[`toInteger`](https://keaven.github.io/gsDesign/devel/reference/toInteger.md)
and
[`gsBoundSummary`](https://keaven.github.io/gsDesign/devel/reference/gsBoundSummary.md).

## Usage

``` r
gsSurvPower(
  x = NULL,
  k = NULL,
  test.type = NULL,
  alpha = NULL,
  sided = NULL,
  astar = NULL,
  sfu = NULL,
  sfupar = NULL,
  sfl = NULL,
  sflpar = NULL,
  sfharm = NULL,
  sfharmparam = NULL,
  r = NULL,
  usTime = NULL,
  lsTime = NULL,
  testUpper = NULL,
  testLower = NULL,
  testHarm = NULL,
  lambdaC = NULL,
  hr = NULL,
  hr0 = NULL,
  hr1 = NULL,
  eta = NULL,
  etaE = NULL,
  gamma = NULL,
  R = NULL,
  targetN = NULL,
  S = NULL,
  ratio = NULL,
  minfup = NULL,
  method = NULL,
  spending = c("information", "calendar", "min_planned_actual"),
  plannedCalendarTime = NULL,
  targetEvents = NULL,
  maxExtension = NULL,
  minTimeFromPreviousAnalysis = NULL,
  minN = NULL,
  minFollowUp = NULL,
  informationRates = NULL,
  fullSpendingAtFinal = FALSE,
  tol = .Machine$double.eps^0.25,
  targetEventsPerStratum = NULL,
  maxCalendarTime = NULL,
  minNPerStratum = NULL
)
```

## Arguments

- x:

  Optional `gsSurv` or `gsSurvCalendar` object providing defaults for
  all parameters. When provided, any user-specified parameter overrides
  the corresponding value from `x`.

- k:

  Number of analyses planned, including interim and final.

- test.type:

  `1` = one-sided, `2` = two-sided symmetric, `3` = two-sided,
  asymmetric, beta-spending with binding lower bound, `4` = two-sided,
  asymmetric, beta-spending with non-binding lower bound, `5` =
  two-sided, asymmetric, lower bound spending under the null hypothesis
  with binding lower bound, `6` = two-sided, asymmetric, lower bound
  spending under the null hypothesis with non-binding lower bound, `7` =
  two-sided, asymmetric, with binding futility and binding harm bounds,
  `8` = two-sided, asymmetric, with non-binding futility and non-binding
  harm bounds.

- alpha:

  Type I error rate. Default is 0.025 since 1-sided testing is default.
  Internally divided by `sided` before passing to
  [`gsDesign()`](https://keaven.github.io/gsDesign/devel/reference/gsDesign.md),
  matching the convention used by
  [`gsSurv()`](https://keaven.github.io/gsDesign/devel/reference/nSurv.md)
  and
  [`gsSurvCalendar()`](https://keaven.github.io/gsDesign/devel/reference/gsSurvCalendar.md).

- sided:

  1 for 1-sided, 2 for 2-sided testing. Used to convert `alpha` to
  one-sided via `alpha / sided` for internal calculations, matching the
  convention of
  [`gsSurv()`](https://keaven.github.io/gsDesign/devel/reference/nSurv.md)
  and
  [`nSurv()`](https://keaven.github.io/gsDesign/devel/reference/nSurv.md).
  When `x` is provided and `sided` is omitted, `gsSurvPower()` reuses
  the stored sided value from the design call when available.

- astar:

  Lower bound total crossing probability for `test.type` 5 or 6. Default
  0.

- sfu:

  Upper bound spending function (default `sfHSD`).

- sfupar:

  Parameter for `sfu` (default -4).

- sfl:

  Lower bound spending function (default `sfHSD`).

- sflpar:

  Parameter for `sfl` (default -2).

- sfharm:

  Spending function for the harm bound, used with `test.type = 7` or
  `test.type = 8`. Default `sfHSD`.

- sfharmparam:

  Real value, default \\-2\\. Parameter for the harm bound spending
  function `sfharm`.

- r:

  Integer grid parameter for numerical integration (default 18).

- usTime:

  Upper spending time override; vector of length `k` without missing
  values, or `NULL` (default) to use information fractions. Ignored when
  `spending = "calendar"`, because realized analysis times determine the
  spending fractions.

- lsTime:

  Lower spending time override; vector of length `k` without missing
  values, or `NULL` (default) to use information fractions. Ignored when
  `spending = "calendar"`.

- testUpper:

  Indicator of which analyses include an efficacy test. `TRUE` (default)
  for all analyses. A logical vector of length `k` may be specified.
  Missing values are not allowed; use `FALSE` to omit the test at an
  analysis.

- testLower:

  Indicator of which analyses include a futility test. `TRUE` (default)
  for all analyses. A logical vector of length `k` may be specified.
  Missing values are not allowed; use `FALSE` to omit the test at an
  analysis.

- testHarm:

  Indicator of which analyses include a harm bound. `TRUE` (default) for
  all analyses. A logical vector of length `k` may be specified. Missing
  values are not allowed; use `FALSE` to omit the test at an analysis.
  Only used for `test.type` 7 or 8.

- lambdaC:

  Scalar, vector, or matrix of control event hazard rates. Rows = time
  periods, columns = strata.

- hr:

  Assumed hazard ratio (experimental/control) for power computation.
  This is the "what-if" treatment effect.

- hr0:

  Null hazard ratio. Set `hr0 > 1` for non-inferiority.

- hr1:

  Design alternative hazard ratio used to calibrate futility bounds
  (`test.type` 3, 4, 7, 8 only; not used for 5, 6 or harm bounds).
  Defaults to `x$hr` when `x` is provided, otherwise `hr`.

- eta:

  Scalar, vector, or matrix of control dropout hazard rates.

- etaE:

  Experimental dropout hazard rates; if `NULL`, set to `eta`.

- gamma:

  Scalar, vector, or matrix of enrollment rates by period (rows) and
  strata (columns).

- R:

  Scalar or vector of enrollment period durations.

- targetN:

  Target total sample size. When specified, `R` is uniformly rescaled so
  that `sum(gamma * R) == targetN`, preserving the relative duration of
  each enrollment period. This changes enrollment duration rather than
  the enrollment rates. Cannot be used together with an explicit
  non-`NULL` `R`; to keep a fixed enrollment duration, specify `R` and
  scale `gamma` directly.

- S:

  Scalar or vector of piecewise failure period durations; `NULL` for
  exponential failure.

- ratio:

  Randomization ratio (experimental/control). Default 1.

- minfup:

  Minimum follow-up time. When explicitly supplied, event-driven
  analyses cannot place the final analysis before the end of enrollment
  plus `minfup`.

- method:

  Sample-size variance formulation. One of `"LachinFoulkes"` (default),
  `"Schoenfeld"`, `"Freedman"`, or `"BernsteinLagakos"`. Affects `n.fix`
  computation when `x` is not provided.

- spending:

  One of `"information"` (default), `"calendar"`, or
  `"min_planned_actual"`. Information spending tracks expected event
  fractions within the scenario. Calendar spending uses `T / max(T)`.
  With a reference design `x`, `"min_planned_actual"` uses
  `pmin(x$n.I, actual events) / x$n.I[k]`, matching the planned-versus-
  actual spending convention in simtrial. The latter two modes derive
  `usTime` and `lsTime` and ignore user-supplied overrides.

- plannedCalendarTime:

  Calendar times for analyses (time 0 = start of randomization). Scalar
  (recycled) or vector of length `k`. Use `NA` for analyses not
  determined by calendar time.

- targetEvents:

  Overall target number of events at each analysis. Scalar (recycled) or
  vector of length `k`. Use `NA` for analyses without an overall event
  requirement. A matrix is accepted as a deprecated alias for
  `targetEventsPerStratum`.

- maxExtension:

  Maximum time extension beyond the floor time to wait for
  `targetEvents`. Scalar or vector of length `k`. Requires a floor
  timing criterion for the affected analysis, most commonly
  `plannedCalendarTime`. Use `NA` for analyses without a relative
  extension cap.

- minTimeFromPreviousAnalysis:

  Minimum elapsed time since the previous analysis. Scalar or vector of
  length `k`. Ignored for the first analysis. Use `NA` for later
  analyses without a spacing requirement.

- minN:

  Minimum total sample size enrolled before analysis can proceed. Scalar
  or vector of length `k`. Can be used with `minFollowUp` as the primary
  timing criterion; the resulting analysis times and expected event
  totals must be strictly increasing. Use `NA` for analyses without an
  overall enrollment requirement.

- minFollowUp:

  Minimum follow-up time after all active `minN` and `minNPerStratum`
  requirements are reached. Scalar or vector of length `k`. Must be
  \>= 0. Use `NA` for no additional follow-up at an analysis. Each
  non-missing value requires an active `minN` or `minNPerStratum`
  requirement at the same analysis.

- informationRates:

  Numeric vector of length `k` specifying planned information-fraction
  caps, with no missing values. At each analysis, the effective upper
  and lower spending time is `pmin(informationRates, actual_timing)`,
  where `actual_timing` is expected events divided by maximum expected
  events. This prevents spending ahead of either the planned information
  schedule or the information actually accumulated. When supplied,
  `informationRates` takes precedence over `spending`, `usTime`, and
  `lsTime`; upper and lower spending use the same effective
  spending-time vector. Default `NULL` uses actual information fractions
  (or calendar fractions when `spending = "calendar"`).

- fullSpendingAtFinal:

  Logical. When `TRUE`, the final element of the effective upper and
  lower spending-time vectors is forced to 1 after applying
  `informationRates`, calendar or planned-versus-actual spending, or
  user-supplied `usTime`/`lsTime`. This ensures full upper- and
  lower-bound spending whenever a selected spending-time vector would
  otherwise end below 1. Default `FALSE`.

- tol:

  Tolerance for [`uniroot`](https://rdrr.io/r/stats/uniroot.html) when
  solving for analysis times.

- targetEventsPerStratum:

  Per-stratum event requirements. Numeric matrix with `k` rows and one
  column per stratum; `NA` omits a stratum requirement at an analysis.
  The analysis waits until every active stratum requirement and any
  overall `targetEvents` requirement are met.

- maxCalendarTime:

  Absolute calendar-time cap for each analysis. Scalar or vector of
  length `k`. When supplied with `maxExtension`, the earlier cap
  applies. This corresponds to `max_extension_for_target_event` in
  simtrial. Use `NA` for analyses without an absolute calendar-time cap.

- minNPerStratum:

  Per-stratum minimum enrollment requirements. Numeric matrix with `k`
  rows and one column per stratum; `NA` omits a stratum requirement at
  an analysis.

## Value

An object of class `c("gsSurvPower", "gsSurv", "gsDesign")` containing:

- k:

  Number of analyses.

- n.I:

  Total expected events at each analysis.

- timing:

  Information fractions at each analysis.

- T:

  Calendar times of analyses.

- eDC, eDE:

  Expected events by stratum (control, experimental).

- eNC, eNE:

  Expected sample sizes by stratum (control, experimental).

- N:

  Cumulative total expected enrollment at each analysis.

- upper, lower:

  Bounds and crossing probabilities.

- harm:

  Harm-bound information when `test.type` is 7 or 8.

- en, theta:

  Expected sample size summary and drift values returned by
  [`gsDesign::gsProbability()`](https://keaven.github.io/gsDesign/devel/reference/gsProbability.md).

- hr, hr0, hr1:

  Assumed, null, and design hazard ratios.

- power:

  Overall power (sum of upper-bound crossing probabilities under the
  assumed HR).

- beta:

  Type II error (`1 - power`).

- variable:

  Always `"Power"`.

- test.type, alpha, sided, method, spending, call:

  Design settings and the original call used for the power calculation.

- inputs:

  Evaluated arguments supplied to `gsSurvPower()`. The calculation can
  be reproduced under the same package version with
  `do.call(gsSurvPower, inputs)`. When `x` is supplied, the evaluated
  reference design is retained so that inherited design settings and
  planned-versus-actual spending can be reproduced.

- informationRates, fullSpendingAtFinal:

  Planned information-fraction caps and final effective-spending-time
  setting used for bound spending.

- testUpper, testLower, testHarm:

  Logical indicators of which analyses include each bound type, when
  relevant.

- lambdaC, etaC, etaE, gamma, R, S, ratio, minfup:

  Rate and timing inputs used in the calculation.

## Details

**Accepting a gsSurv object:** An optional `gsSurv`-class object `x`
provides defaults for all parameters. This includes output from
[`gsSurv()`](https://keaven.github.io/gsDesign/devel/reference/nSurv.md)
and
[`gsSurvCalendar()`](https://keaven.github.io/gsDesign/devel/reference/gsSurvCalendar.md).
User-specified parameters override these defaults, enabling "what-if"
analyses: e.g., `gsSurvPower(x = design, hr = 0.8)` evaluates power
under HR = 0.8 using all other parameters from the design. When `x` is
not provided, all design parameters must be specified directly.

**Interpretation and limitations:** Enrollment, dropout, event
accumulation, and analysis timing are represented by their expected
values under the supplied assumptions. Consequently, event- and
enrollment-triggered analysis times are expected analysis times, not
simulated realizations. The calculation does not represent
trial-to-trial variation in enrollment, failure, dropout, or operational
timing. Use simulation when that variation may materially affect
operating characteristics or the probability that combined timing rules
are met; see, for example, the [simtrial
package](https://merck.github.io/simtrial/).

**Hazard ratio roles:** Two distinct hazard ratios serve different
purposes. `hr` is the assumed treatment effect under which power is
evaluated. `hr1` is the design alternative used to calibrate futility
bounds (for `test.type` 3, 4, 7, 8). It is not used for `test.type` 5 or
6 (which use H0 spending for the lower bound) or for harm bounds. When
`x` is provided, `hr1` defaults to `x$hr`, so futility bounds remain
calibrated to the original design even when power is evaluated under a
different `hr`.

**Beta spending in scenario analyses:** For beta-spending test types 3,
4, 7, and 8, `x$beta` is the design beta used with `hr1`, `sfl`, and
`sflpar` to calibrate futility bounds. The `beta` returned by
`gsSurvPower()` instead equals `1 - power` under the scenario
assumptions and can differ substantially from the design beta.

- When information fractions and spending inputs are unchanged, futility
  bounds are reused from `x`.

- When information fractions or spending times change, futility bounds
  are recomputed on the new schedule using the design beta and `hr1`;
  achieved beta is then evaluated under `hr`.

- When only alpha or upper-bound spending changes with timing fixed,
  futility bounds from `x` are preserved, apart from clipping a lower
  bound that exceeds the new efficacy bound.

Test types 5 and 6 spend lower-bound probability under the null rather
than beta under the alternative. Harm spending for test types 7 and 8 is
also a separate null-based calculation.

**Analysis timing:** Analysis times are determined by per-analysis
criteria. Except for the final-analysis-only scalar `minfup`, each
timing-rule parameter can be a scalar (recycled to all `k` analyses), a
vector of length `k`, or `NA` at position `i` to indicate that the rule
does not apply to analysis `i`. For the per-stratum matrix arguments,
`NA` deactivates only that analysis-by-stratum requirement.

The choice between `plannedCalendarTime` and overall `targetEvents` has
an important consequence for sensitivity analyses:

- Used alone, `plannedCalendarTime` fixes calendar times; when combined
  with other criteria, it supplies a timing floor. Expected events are
  recomputed under the assumed HR. A worse HR produces more events at
  the same calendar time (the experimental arm fails faster). This gives
  an "unconditional" power.

- `targetEvents` fixes overall event counts; calendar times adjust.
  Since events are held constant, information fractions do not change
  with HR, and results match the `gsDesign` power plot
  (`plot(x, plottype = 2)`) to numerical precision.

**How criteria combine within a single analysis:** For analysis `i`, the
analysis time `T[i]` is determined as:

1.  Compute floor times from applicable criteria:
    `plannedCalendarTime[i]`, `T[i-1] + minTimeFromPreviousAnalysis[i]`,
    and time when `minN[i]` enrolled + `minFollowUp[i]`, and the
    corresponding time for every active column of `minNPerStratum[i, ]`.
    When `minfup` is explicitly supplied, the final analysis also has a
    floor at the end of enrollment plus `minfup`.

2.  `floor_time = max(all applicable floor times)`.

3.  Find the expected time for the overall `targetEvents[i]` and for
    every active column of `targetEventsPerStratum[i, ]`. Their maximum
    is `t_events`, so all active requirements use AND logic. If
    `t_events <= floor_time`, analysis at `floor_time`. If
    `t_events > floor_time` and `maxExtension[i]` is set, analysis at
    `min(t_events, floor_time + maxExtension[i])`. Otherwise, analysis
    at `t_events`.

4.  If no event requirement is active: analysis at `floor_time`.

5.  `maxExtension` defines a hard deadline: the analysis time is never
    pushed beyond `plannedCalendarTime[i] + maxExtension[i]` (or
    `T[i-1] + maxExtension[i]` when no calendar time is specified), even
    if other criteria such as `minTimeFromPreviousAnalysis` or
    `minN + minFollowUp` would require a later time. Each analysis using
    `maxExtension` must have a floor timing criterion such as
    `plannedCalendarTime`, `minTimeFromPreviousAnalysis`, `minN`,
    `minNPerStratum`, or explicit final-analysis `minfup`.

6.  Finally, `maxCalendarTime[i]` applies an absolute calendar-time cap.
    If both cap types are supplied, the earlier cap applies. This
    mirrors the realized-cut grammar in simtrial, where the argument
    named `max_extension_for_target_event` is applied as an absolute
    analysis date.

**Normalization and consistency:** When `x` is provided, `x$n.fix` is
used for the
[`gsDesign::gsDesign()`](https://keaven.github.io/gsDesign/devel/reference/gsDesign.md)
call to ensure the internal drift parameter \\\theta\\ and bounds match
the original design exactly. The assumed HR's drift is obtained by
scaling: \\\theta\_{\mathrm{assumed}} = \theta\_{\mathrm{design}} \times
\|\log(\mathrm{hr}/\mathrm{hr}\_0)\| /
\|\log(\mathrm{hr}\_1/\mathrm{hr}\_0)\|\\. Power is computed via
[`gsDesign::gsProbability()`](https://keaven.github.io/gsDesign/devel/reference/gsProbability.md)
with actual expected events as `n.I`. At the design HR, this reproduces
the design power exactly.

**Stratified timing requirements:** `targetEvents` accepts a scalar
(recycled) or a vector of length `k` for overall event targets. Use
`targetEventsPerStratum` for a `k`-by-`nstrata` matrix of per-stratum
event requirements and `minNPerStratum` for per-stratum enrollment
requirements. Overall and per-stratum requirements may be combined and
all active requirements must be met unless a cap intervenes. `NA` omits
a requirement. A matrix passed through `targetEvents` is a deprecated
alias for `targetEventsPerStratum`; unlike the earlier row-sum
interpretation, its entries are enforced by stratum.

**Bound recalculation when parameters change:** When `x` is provided,
the handling of bounds depends on which parameters change relative to
the original design:

- **No bound parameters changed** (same `alpha`, `sfu`, `sfupar`) and
  timing matches: both bounds are reused from `x` exactly.

- **Upper-bound parameters changed** (`alpha`, `sfu`, or `sfupar`) but
  timing matches: new efficacy bounds are computed using the non-binding
  efficacy convention at the new alpha while preserving the original
  `testUpper` schedule and futility bounds from `x`. Any futility bound
  that exceeds the new efficacy bound is clipped. This follows the same
  convention as
  [`gsBoundSummary()`](https://keaven.github.io/gsDesign/devel/reference/gsBoundSummary.md).
  Lower-bound spending settings from `x` are intentionally kept in this
  branch, which avoids complications with `astar` validation for binding
  types. For non-binding test types 1, 4, 6, and 8, this calculation can
  be used to evaluate alpha propagated by a graphical multiple-testing
  procedure. For binding test types 2, 3, 5, and 7, it is a planning
  sensitivity calculation only; it is not a Maurer–Bretz
  sequential-p-value or graphical alpha-recycling procedure.

- **Timing changed** (different target events or calendar times): both
  bounds are recomputed from scratch using the full `test.type` and all
  spending parameters.

## See also

[`vignette("gsSurvPower", package = "gsDesign")`](https://keaven.github.io/gsDesign/devel/articles/gsSurvPower.md)
for worked examples including calendar spending, stratified event
targets, and biomarker subgroup analyses.

[`vignette("gsSurvBasicExamples", package = "gsDesign")`](https://keaven.github.io/gsDesign/devel/articles/gsSurvBasicExamples.md)
for deriving survival sample size designs and
[`vignette("SeqDesignSurvival", package = "gsDesign")`](https://keaven.github.io/gsDesign/devel/articles/SeqDesignSurvival.md)
for reproducing SAS PROC SEQDESIGN survival output.

[`gsSurv`](https://keaven.github.io/gsDesign/devel/reference/nSurv.md),
[`gsSurvCalendar`](https://keaven.github.io/gsDesign/devel/reference/gsSurvCalendar.md),
[`gsDesign`](https://keaven.github.io/gsDesign/devel/reference/gsDesign.md),
[`gsProbability`](https://keaven.github.io/gsDesign/devel/reference/gsProbability.md)

## Examples

``` r
# Create a design, then evaluate power at the design HR
design <- gsSurv(
  k = 3, test.type = 4, alpha = 0.025, sided = 1, beta = 0.1,
  lambdaC = log(2) / 12, hr = 0.7, eta = 0.01,
  gamma = 10, R = 16, minfup = 12, T = 28
)
pwr <- gsSurvPower(x = design, plannedCalendarTime = design$T)
pwr$power  # should be 0.9
#> [1] 0.9

# Power under a worse HR
gsSurvPower(x = design, hr = 0.8, plannedCalendarTime = design$T)$power
#> [1] 0.5410332

# Event-driven timing (matches gsDesign power plot)
design_events <- design$n.I
gsSurvPower(x = design, hr = 0.8, targetEvents = design_events)$power
#> [1] 0.5253127

# Without a reference design
gsSurvPower(
  k = 2, test.type = 4, alpha = 0.025, sided = 1,
  lambdaC = log(2) / 6, hr = 0.65, eta = 0.01,
  gamma = 8, R = 18, ratio = 1,
  plannedCalendarTime = c(24, 36)
)$power
#> [1] 0.625026

# Use targetN without R to solve enrollment duration from relative rates
pwr_target_n <- gsSurvPower(
  k = 2, test.type = 1, alpha = 0.025, sided = 1,
  lambdaC = log(2) / 15, hr = 0.7, eta = 0.001,
  gamma = c(10, 20, 30, 40), targetN = 500,
  ratio = 1.5, plannedCalendarTime = c(24, 36),
  testLower = FALSE
)
sum(rowSums(pwr_target_n$gamma) * pwr_target_n$R)
#> [1] 500

# Require event counts within each stratum
pwr_stratified <- gsSurvPower(
  k = 2, test.type = 1, alpha = 0.025, sided = 1,
  lambdaC = matrix(log(2) / c(6, 12), ncol = 2),
  hr = 0.7, eta = 0.01,
  gamma = matrix(c(5, 5), ncol = 2), R = 12, ratio = 1,
  targetEventsPerStratum = matrix(
    c(20, 10, 40, 20), nrow = 2, byrow = TRUE
  )
)
pwr_stratified$eDC + pwr_stratified$eDE
#>      [,1]     [,2]
#> [1,]   20 11.67240
#> [2,]   40 26.25659
```

# Compute power for a group sequential survival design

`gsSurvPower()` computes power for a group sequential survival design
with specified enrollment, dropout, treatment effect, and analysis
timing. Unlike
[`gsSurv()`](https://keaven.github.io/gsDesign/reference/nSurv.md) and
[`gsSurvCalendar()`](https://keaven.github.io/gsDesign/reference/gsSurvCalendar.md)
which solve for sample size to achieve target power, `gsSurvPower()`
takes fixed design assumptions and computes the resulting power. It is
meant to compute for a single set of assumptions at a time; different
scenarios are evaluated with separate calls.

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
  spending = c("information", "calendar"),
  plannedCalendarTime = NULL,
  targetEvents = NULL,
  maxExtension = NULL,
  minTimeFromPreviousAnalysis = NULL,
  minN = NULL,
  minFollowUp = NULL,
  informationRates = NULL,
  fullSpendingAtFinal = FALSE,
  tol = .Machine$double.eps^0.25
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
  [`gsDesign()`](https://keaven.github.io/gsDesign/reference/gsDesign.md),
  matching the convention used by
  [`gsSurv()`](https://keaven.github.io/gsDesign/reference/nSurv.md) and
  [`gsSurvCalendar()`](https://keaven.github.io/gsDesign/reference/gsSurvCalendar.md).

- sided:

  1 for 1-sided, 2 for 2-sided testing. Used to convert `alpha` to
  one-sided via `alpha / sided` for internal calculations, matching the
  convention of
  [`gsSurv()`](https://keaven.github.io/gsDesign/reference/nSurv.md) and
  [`nSurv()`](https://keaven.github.io/gsDesign/reference/nSurv.md).
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

  Upper spending time override; vector of length `k` or `NULL` (default)
  to use information fractions. Ignored when `spending = "calendar"`,
  because realized analysis times determine the spending fractions.

- lsTime:

  Lower spending time override; vector of length `k` or `NULL` (default)
  to use information fractions. Ignored when `spending = "calendar"`.

- testUpper:

  Indicator of which analyses include an efficacy test. `TRUE` (default)
  for all analyses. A logical vector of length `k` may be specified.

- testLower:

  Indicator of which analyses include a futility test. `TRUE` (default)
  for all analyses. A logical vector of length `k` may be specified.

- testHarm:

  Indicator of which analyses include a harm bound. `TRUE` (default) for
  all analyses. A logical vector of length `k` may be specified. Only
  used for `test.type` 7 or 8.

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
  each enrollment period. This is a convenience for "what-if" analyses
  where the enrollment rate changes but the target sample size stays the
  same (or vice versa). Cannot be used together with an explicit `R`.

- S:

  Scalar or vector of piecewise failure period durations; `NULL` for
  exponential failure.

- ratio:

  Randomization ratio (experimental/control). Default 1.

- minfup:

  Minimum follow-up time.

- method:

  Sample-size variance formulation. One of `"LachinFoulkes"` (default),
  `"Schoenfeld"`, `"Freedman"`, or `"BernsteinLagakos"`. Affects `n.fix`
  computation when `x` is not provided.

- spending:

  One of `"information"` (default) or `"calendar"`. Controls whether
  alpha/beta spending tracks information fractions or calendar time
  fractions (`T / max(T)`). With calendar spending, `usTime` and
  `lsTime` are derived from the realized analysis times and any
  user-supplied overrides are ignored.

- plannedCalendarTime:

  Calendar times for analyses (time 0 = start of randomization). Scalar
  (recycled) or vector of length `k`. Use `NA` for analyses not
  determined by calendar time.

- targetEvents:

  Target number of events at each analysis. Scalar (recycled), vector of
  length `k` (overall targets), or matrix with `k` rows and `nstrata`
  columns (per-stratum targets). Use `NA` for analyses not determined by
  events. When a matrix is supplied, row sums give the total event
  target used to solve each analysis time.

- maxExtension:

  Maximum time extension beyond the floor time to wait for
  `targetEvents`. Scalar or vector of length `k`.

- minTimeFromPreviousAnalysis:

  Minimum elapsed time since the previous analysis. Scalar or vector of
  length `k`. Ignored for the first analysis.

- minN:

  Minimum total sample size enrolled before analysis can proceed. Scalar
  or vector of length `k`.

- minFollowUp:

  Minimum follow-up time after `minN` is reached. Scalar or vector of
  length `k`. Must be \>= 0.

- informationRates:

  Numeric vector of length `k` specifying planned information fractions.
  When provided, spending fractions are
  `pmin(informationRates, actual_timing)` at each analysis, where
  `actual_timing` is expected events divided by maximum expected events.
  This prevents over-spending when events are ahead of schedule and
  under-spends when behind. When supplied, these planned-vs-actual
  information fractions take precedence over `spending`, `usTime`, and
  `lsTime`; both upper and lower spending times use the same capped
  vector. Default `NULL` uses actual information fractions (or calendar
  fractions when `spending = "calendar"`).

- fullSpendingAtFinal:

  Logical. When `TRUE`, the spending fraction at the final analysis is
  forced to 1 after applying `informationRates`, calendar spending, or
  user-supplied `usTime`/`lsTime`. This ensures full alpha spending
  whenever the selected spending-time vector would otherwise end
  below 1. Default `FALSE`.

- tol:

  Tolerance for [`uniroot`](https://rdrr.io/r/stats/uniroot.html) when
  solving for analysis times.

## Value

An object of class `c("gsSurv", "gsDesign")` containing:

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

- upper, lower:

  Bounds and crossing probabilities.

- harm:

  Harm-bound information when `test.type` is 7 or 8.

- en, theta:

  Expected sample size summary and drift values returned by
  [`gsDesign::gsProbability()`](https://keaven.github.io/gsDesign/reference/gsProbability.md).

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

  Design settings used for the power calculation.

- testUpper, testLower, testHarm:

  Logical indicators of which analyses include each bound type, when
  relevant.

- lambdaC, etaC, etaE, gamma, R, S, ratio, minfup:

  Rate and timing inputs used in the calculation.

## Details

**Accepting a gsSurv object:** An optional `gsSurv`-class object `x`
provides defaults for all parameters. This includes output from
[`gsSurv()`](https://keaven.github.io/gsDesign/reference/nSurv.md) and
[`gsSurvCalendar()`](https://keaven.github.io/gsDesign/reference/gsSurvCalendar.md).
User-specified parameters override these defaults, enabling "what-if"
analyses: e.g., `gsSurvPower(x = design, hr = 0.8)` evaluates power
under HR = 0.8 using all other parameters from the design. When `x` is
not provided, all design parameters must be specified directly.

**Hazard ratio roles:** Two distinct hazard ratios serve different
purposes. `hr` is the assumed treatment effect under which power is
evaluated. `hr1` is the design alternative used to calibrate futility
bounds (for `test.type` 3, 4, 7, 8). It is not used for `test.type` 5 or
6 (which use H0 spending for the lower bound) or for harm bounds. When
`x` is provided, `hr1` defaults to `x$hr`, so futility bounds remain
calibrated to the original design even when power is evaluated under a
different `hr`.

**Analysis timing:** Analysis times are determined by per-analysis
criteria. Each timing parameter can be a scalar (recycled to all `k`
analyses), a vector of length `k`, or `NA` at position `i` to indicate
the criterion does not apply to analysis `i`.

The choice between `plannedCalendarTime` and `targetEvents` has an
important consequence for sensitivity analyses:

- `plannedCalendarTime` fixes calendar times; expected events are
  recomputed under the assumed HR. A worse HR produces more events at
  the same calendar time (the experimental arm fails faster). This gives
  an "unconditional" power.

- `targetEvents` fixes event counts; calendar times adjust. Since events
  are held constant, information fractions do not change with HR, and
  results match the `gsDesign` power plot (`plot(x, plottype = 2)`) to
  numerical precision.

**How criteria combine within a single analysis:** For analysis `i`, the
analysis time `T[i]` is determined as:

1.  Compute floor times from applicable criteria:
    `plannedCalendarTime[i]`, `T[i-1] + minTimeFromPreviousAnalysis[i]`,
    and time when `minN[i]` enrolled + `minFollowUp[i]`.

2.  `floor_time = max(all applicable floor times)`.

3.  If `targetEvents[i]` is specified: find `t_events` when expected
    events reach target. If `t_events <= floor_time`, analysis at
    `floor_time`. If `t_events > floor_time` and `maxExtension[i]` is
    set, analysis at `min(t_events, floor_time + maxExtension[i])`.
    Otherwise, analysis at `t_events`.

4.  If no `targetEvents`: analysis at `floor_time`.

5.  `maxExtension` is a hard cap: the analysis time is never pushed
    beyond `plannedCalendarTime[i] + maxExtension[i]` (or
    `T[i-1] + maxExtension[i]` when no calendar time is specified), even
    if other criteria such as `minTimeFromPreviousAnalysis` or
    `minN + minFollowUp` would require a later time.

**Normalization and consistency:** When `x` is provided, `x$n.fix` is
used for the
[`gsDesign::gsDesign()`](https://keaven.github.io/gsDesign/reference/gsDesign.md)
call to ensure the internal drift parameter \\\theta\\ and bounds match
the original design exactly. The assumed HR's drift is obtained by
scaling: \\\theta\_{\mathrm{assumed}} = \theta\_{\mathrm{design}} \times
\|\log(\mathrm{hr}/\mathrm{hr}\_0)\| /
\|\log(\mathrm{hr}\_1/\mathrm{hr}\_0)\|\\. Power is computed via
[`gsDesign::gsProbability()`](https://keaven.github.io/gsDesign/reference/gsProbability.md)
with actual expected events as `n.I`. At the design HR, this reproduces
the design power exactly.

**Stratified targetEvents:** `targetEvents` accepts a scalar (recycled),
a vector of length `k` (overall targets per analysis), or a matrix with
`k` rows and `nstrata` columns (per-stratum targets). A vector of length
`k` is always interpreted as overall targets; use a matrix for
per-stratum specification.

**Bound recalculation when parameters change:** When `x` is provided,
the handling of bounds depends on which parameters change relative to
the original design:

- **No bound parameters changed** (same `alpha`, `sfu`, `sfupar`) and
  timing matches: both bounds are reused from `x` exactly.

- **Upper-bound parameters changed** (`alpha`, `sfu`, or `sfupar`) but
  timing matches: new efficacy bounds are computed via
  `gsDesign(test.type = 1)` at the new alpha, while the original
  futility bounds from `x` are preserved. Any futility bound that
  exceeds the new efficacy bound is clipped. This follows the same
  convention as
  [`gsBoundSummary()`](https://keaven.github.io/gsDesign/reference/gsBoundSummary.md).
  Lower-bound spending settings from `x` are intentionally kept in this
  branch, which avoids complications with `astar` validation for binding
  types.

- **Timing changed** (different target events or calendar times): both
  bounds are recomputed from scratch using the full `test.type` and all
  spending parameters.

## See also

[`vignette("gsSurvPower", package = "gsDesign")`](https://keaven.github.io/gsDesign/articles/gsSurvPower.md)
for worked examples including calendar spending, stratified event
targets, and biomarker subgroup analyses.

[`gsSurv`](https://keaven.github.io/gsDesign/reference/nSurv.md),
[`gsSurvCalendar`](https://keaven.github.io/gsDesign/reference/gsSurvCalendar.md),
[`gsDesign`](https://keaven.github.io/gsDesign/reference/gsDesign.md),
[`gsProbability`](https://keaven.github.io/gsDesign/reference/gsProbability.md)

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
#> [1] 0.5253124

# Without a reference design
gsSurvPower(
  k = 2, test.type = 4, alpha = 0.025, sided = 1,
  lambdaC = log(2) / 6, hr = 0.65, eta = 0.01,
  gamma = 8, R = 18, ratio = 1,
  plannedCalendarTime = c(24, 36)
)$power
#> [1] 0.625026
```

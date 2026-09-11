# Median follow-up across all planned participants

Compute the modeled population median follow-up at a calendar cutoff, or
solve for the earliest cutoff achieving a target median. The population
includes everyone in the complete planned enrollment, assigning zero
follow-up to participants not yet enrolled. Enrollment is not extended
or resized by these functions.

## Usage

``` r
medianFollowUp(
  x = NULL,
  T = NULL,
  gamma = NULL,
  R = NULL,
  eta = NULL,
  etaE = NULL,
  lambdaC = NULL,
  hr = NULL,
  S = NULL,
  ratio = NULL,
  stopAtEvent = FALSE,
  tol = 1e-08
)

minMedianFollowUp(
  x = NULL,
  ...,
  target,
  gamma = NULL,
  R = NULL,
  eta = NULL,
  etaE = NULL,
  lambdaC = NULL,
  hr = NULL,
  S = NULL,
  ratio = NULL,
  stopAtEvent = FALSE,
  tol = 1e-08
)
```

## Arguments

- x:

  Optional `nSurv` or `gsSurv` design supplying defaults.

- T:

  Finite, nonnegative calendar cutoff vector. Defaults to `x$T`;
  required without a design. Time is measured from trial start.

- gamma:

  Enrollment rates, using the control-arm rate convention of
  [`gsSurv()`](https://keaven.github.io/gsDesign/reference/nSurv.md).
  Rows are calendar enrollment periods, columns are strata. A scalar is
  constant over periods and strata; a vector specifies periods.

- R:

  Positive enrollment-period durations. Enrollment stops at `sum(R)`.
  Required with `gamma` when not supplied by `x`.

- eta:

  Control dropout hazards; finite and nonnegative. Rows are
  participant-time hazard intervals, columns are strata. A scalar is
  constant over intervals and strata; a vector specifies intervals.
  Standalone default is zero.

- etaE:

  Experimental dropout hazards, in the same form as `eta`. When omitted,
  inherit from `x`, otherwise default to `eta`. Explicit `NULL` requests
  equality with the resolved `eta`.

- lambdaC:

  Control event hazards, in the same form as `eta`. Required from `x` or
  explicitly when `stopAtEvent = TRUE`; otherwise not used or required.

- hr:

  Positive experimental/control event hazard ratio, required when event
  stopping is enabled. Experimental event hazards are `lambdaC * hr`.
  Unlike a design solve, `hr = 1` is permitted.

- S:

  Positive durations of event/dropout hazard intervals, excluding the
  final interval, which extends indefinitely. These intervals measure
  time since each participant enrolled, not calendar time. With `K`
  hazard rows, `length(S) = K - 1`. Omission inherits `x$S`; explicit
  `NULL` requests constant hazards. Also used for dropout when events do
  not stop follow-up. Enrollment and hazard grids may differ.

- ratio:

  Positive experimental/control allocation ratio; scalar or one value
  per stratum. Standalone default is 1.

- stopAtEvent:

  Nonmissing logical scalar. If `FALSE` (default), follow-up stops at
  dropout or cutoff, ignoring events. If `TRUE`, it stops at the first
  of event, dropout and cutoff.

- tol:

  Positive absolute numerical tolerance in follow-up-time units, default
  `1e-8`.

- ...:

  Must be empty. In `minMedianFollowUp()`, this guard prevents old
  positional cutoff arguments from being silently interpreted as
  targets.

- target:

  Required named nonnegative scalar median-follow-up target.

## Value

`medianFollowUp()` returns a numeric median per cutoff;
`minMedianFollowUp()` returns one calendar cutoff.

## Details

Omitted model inputs inherit the design's stored assumptions; explicit
non-NULL inputs override them. The exceptions with meaningful explicit
NULL values are `S` and `etaE`, as documented above. Incompatible
dimensions are errors, not silently truncated inputs.

Within each arm and stratum, event/dropout survival is calculated from
piecewise-constant hazards on participant time. For follow-up `u >= 0`,
the proportion with follow-up greater than `u` is the planned-population
fraction enrolled before `T - u`, multiplied by the probability of
remaining uncensored through `u`, and summed over arms and strata.
Arm/stratum weights reflect planned enrollment and randomization. This
is a population quantile, not the median of individual expected times,
the expected finite-sample median, or a reverse Kaplan-Meier estimate.

The lower 0.5 quantile resolves non-unique medians. In particular, the
median is zero until more than half the planned population has enrolled.
Quantile bisection retains this convention across enrollment pauses and
flat portions of the distribution. Without dropout or event stopping,
uniform enrollment over 12 months gives median `max(0, T - 6)`.

The inverse uses bounded bisection: by cutoff `sum(R) + target`, all
planned participants have had the opportunity to attain the target. If
the median is still below target, dropout/event stopping makes that
target unattainable, and an informative error is returned. A zero target
returns zero. The achieved median is checked against `target` within
`tol`.

This replaces the former forward `minMedianFollowUp(x, calendarTime)`
calculation among participants enrolled to date. Migrate forward calls
to `medianFollowUp(x, T = ...)`; inverse calls require
`minMedianFollowUp(x, target = ...)`. This intentionally changes the
population definition as well as the function's role.

## See also

[`gsSurv`](https://keaven.github.io/gsDesign/reference/nSurv.md),
[`plotMinMedianFollowUp`](https://keaven.github.io/gsDesign/reference/plotMinMedianFollowUp.md)

## Examples

``` r
medianFollowUp(T = c(3, 6, 12, 18), gamma = 10, R = 12)
#> [1]  0  0  6 12
minMedianFollowUp(target = 6, gamma = 10, R = 12)
#> [1] 12
x <- gsSurv(gamma = 10, R = 12, T = 30, minfup = 18)
medianFollowUp(x)
#> [1]  4.078063 10.183086 24.000000
medianFollowUp(x, stopAtEvent = TRUE)
#> [1] 2.518443 5.914619 7.668978
minMedianFollowUp(x, target = 3, stopAtEvent = TRUE)
#> [1] 10.89807
medianFollowUp(T = c(12, 18, 24), gamma = c(5, 10), R = c(6, 6),
  eta = c(.01, .02), etaE = c(.005, .01),
  lambdaC = c(.08, .04), hr = .7, S = 6, stopAtEvent = TRUE)
#> [1]  3.253447  7.442845 11.109512
```

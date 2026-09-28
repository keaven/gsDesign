# Calibrate Futility Spending to Unconditional Probability of Success

Select one free beta-spending parameter to match the unconditional
prior-predictive probability of success
[`gsPOS()`](https://keaven.github.io/gsDesign/reference/gsCP.md).
Recalculate maximum information to preserve reference frequentist power.

## Usage

``` r
gsPOSFutilitySpending(x, target_pos, sfl = x$lower$sf, prior, control = list())
```

## Arguments

- x:

  A `gsDesign`, `gsSurv`, `gsSurvCalendar`, or `gsSurvPower` design with
  `test.type` 3 or 4. The analysis information fractions in `x$timing`
  are held fixed. These fractions are distinct from the times supplied
  to the spending functions; see **Information fractions and spending
  times** below.

- target_pos:

  A single probability of success strictly between zero and one for the
  complete design. This is not an interim-specific target.

- sfl:

  A supported one-parameter lower spending function or its name.
  Defaults to `x$lower$sf`, the reference futility spending function.
  Supply `sfl` to override it; a two-parameter reference family requires
  an explicit one-parameter choice. A custom function must expose
  exactly one free parameter. For `sfLinear`, a single free knot is
  placed at the first active interim futility spending time.

- prior:

  List with finite numeric vectors `z` (standardized effects on the
  [`gsCPOS()`](https://keaven.github.io/gsDesign/reference/gsCP.md)
  theta scale) and `wgts` (nonnegative prior masses or density-weighted
  quadrature weights). Weights must have positive total and are
  normalized internally. The prior must be supplied explicitly and is
  held fixed throughout fitting. For the default
  [`gsBoundSummary()`](https://keaven.github.io/gsDesign/reference/gsBoundSummary.md)
  prior, use `normalGrid(mu = x$delta / 2, sigma = 10 / sqrt(x$n.fix))`.

- control:

  Named numerical controls. `pos_tol` is the maximum absolute POS
  residual (default `1e-4`, finite and in (0, 0.1)). Other controls and
  defaults are as in
  [`gsCPOSFutilitySpending`](https://keaven.github.io/gsDesign/reference/gsCPOSFutilitySpending.md):
  `start`, `lower`, `upper`, `maxit`, `reltol`, `backward`, and `trace`.
  Unknown or invalid controls are errors.

## Value

A `c("gsPOSFutilitySpending", "gsDesign")` object, retaining survival
classes when applicable, with `posFutilitySpending` diagnostics. These
include `target_pos`, `achieved_pos`, residual, normalized prior, fitted
parameters, information, frequentist power, reference settings and
solver diagnostics including `pos_tol`. There is no interim target
index. Error classes use the prefix `gsPOSFutilitySpending`.

## Details

[`gsPOS()`](https://keaven.github.io/gsDesign/reference/gsCP.md)
averages the probability of any efficacy rejection over the supplied
effect prior, before observing trial data or conditioning on
continuation. The prior weights are normalized and then held fixed
during fitting. No interim index is required because POS is a single
scalar for the entire trial. Consequently, an unconstrained
two-parameter spending family cannot be identified from POS alone and is
rejected. A custom one-parameter wrapper may fix the other parameters
explicitly.

Unconditional POS calibration is not Dragalin's conditional-assurance
criterion. Compare
[`gsCPOSFutilitySpending`](https://keaven.github.io/gsDesign/reference/gsCPOSFutilitySpending.md)
and
[`gsCAFutilitySpending`](https://keaven.github.io/gsDesign/reference/gsCAFutilitySpending.md)
for continuation-conditioned targets. For a point prior at the planned
alternative, POS equals the power already preserved by the design
builder: the spending shape is then not identified by that target. A
valid starting solution can be returned, but does not imply uniqueness.
Other priors can also produce flat or nonmonotone objectives. Inspect
information inflation and all operating characteristics.

## Information fractions and spending times

All six spending calibrators keep the reference analysis information
fractions `x$timing` fixed. These are the cumulative information
fractions `x$n.I / x$n.I[x$k]`, ending at 1. For example,
`x$timing = c(.5, .75, 1)` keeps the analyses at 50%, 75%, and 100% of
the final information. Power-preserving calibration may change the
maximum information and thus the absolute information `n.I` at every
analysis while retaining these fractions. Fixed-information calibration
([`gsCAFutilitySpending()`](https://keaven.github.io/gsDesign/reference/gsCAFutilitySpending.md)
and `gsCPOSFutilitySpending(mode = "fixed_information")`) also holds
`n.I` and the efficacy boundaries fixed.

Spending times are the inputs to the spending functions, stored in
`x$upper$sTime` and `x$lower$sTime`. These are also retained during
calibration but may differ from the information fractions; for example,
calendar-based spending uses fractions of calendar time. Thus fixed
information fractions do not mean that spending must use information
time, or that absolute calendar analysis dates must be fixed. See
**Survival designs** for how survival calendar times are handled.

## Survival designs

Survival inputs retain their survival classes and endpoint assumptions.
Each candidate reconstructs the statistical design and its survival
plan, so targets and diagnostics are evaluated on the returned
event-count scale. For
[`gsSurv()`](https://keaven.github.io/gsDesign/reference/nSurv.md) and
[`gsSurvCalendar()`](https://keaven.github.io/gsDesign/reference/gsSurvCalendar.md)
inputs, information fractions, spending times, and the
enrollment/follow-up constraint are retained; enrollment rates or
durations are recalculated as required. Calendar designs with fixed
enrollment and follow-up retain their calendar schedule up to numerical
tolerance. Stored calls are not evaluated.

For
[`gsSurvPower()`](https://keaven.github.io/gsDesign/reference/gsSurvPower.md)
inputs, power-preserving calibration fixes the realized calendar times
and enrollment periods and rescales enrollment rates to attain the
fitted event counts. The evaluated alternative `x$hr` and its achieved
power are used, even if the original design alternative `x$hr1`
differed. Original event-trigger and calendar-cap rules are not
re-applied: the realized schedule becomes the new plan.
Fixed-information conditional-POS/CA calibration instead retains the
survival plan, event counts and efficacy bounds while updating futility
and achieved power.

Priors and explicit `theta` remain standardized drifts per square root
event, not hazard ratios. Rounding with
[`toInteger()`](https://keaven.github.io/gsDesign/reference/toInteger.md)
after calibration can change the target; calibration of an already
rounded reference may return noninteger event counts. The final analysis
is not a valid target index for interim calibration: `i` identifies the
interim bound or continuation event at which the target is evaluated.

## See also

[`gsPOS`](https://keaven.github.io/gsDesign/reference/gsCP.md),
[`gsCPOSFutilitySpending`](https://keaven.github.io/gsDesign/reference/gsCPOSFutilitySpending.md),
[`gsCAFutilitySpending`](https://keaven.github.io/gsDesign/reference/gsCAFutilitySpending.md)

## Examples

``` r
x <- gsDesign(k = 3, test.type = 4, sflpar = 1)
prior <- list(z = c(0, x$delta / 2, x$delta), wgts = c(.1, .4, .5))
target <- gsPOS(x, prior$z, prior$wgts)
fit <- gsPOSFutilitySpending(x, target, prior = prior,
                            control = list(start = 0))
fit$posFutilitySpending$sflpar
#> [1] -2.07866
gsPOS(fit, prior$z, prior$wgts)
#> [1] 0.5978036
```

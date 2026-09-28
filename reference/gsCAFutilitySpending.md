# Calibrate Futility Spending at Fixed Information

Compatibility wrapper for
`gsCPOSFutilitySpending(mode = "fixed_information")`, retaining the
legacy argument, diagnostic and error names. Fit beta-spending
parameters to conditional-assurance targets while holding the reference
information and efficacy boundaries fixed. Overall power may change.
Total beta is solved internally so that the spending rule and the
terminal decision at the fixed efficacy boundary are consistent.

## Usage

``` r
gsCAFutilitySpending(
  x,
  target_ca,
  i = seq_along(target_ca),
  sfl = x$lower$sf,
  prior,
  control = list()
)
```

## Arguments

- x:

  A `gsDesign`, `gsSurv`, `gsSurvCalendar`, or `gsSurvPower` design with
  `test.type` 3 or 4. The analysis information fractions in `x$timing`
  are held fixed. These fractions are distinct from the times supplied
  to the spending functions; see **Information fractions and spending
  times** below.

- target_ca:

  Conditional-assurance targets strictly between zero and one.

- i:

  Unique active interim futility indices, one per target.

- sfl:

  Supported lower spending function or its name. Defaults to
  `x$lower$sf`, the reference futility spending function. Supply `sfl`
  to override it. See Details.

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

  Named numerical controls. Use `ca_tol` for the maximum absolute target
  residual (default `1e-4`, finite and in (0, 0.1)). All other controls
  and defaults are as in
  [`gsCPOSFutilitySpending`](https://keaven.github.io/gsDesign/reference/gsCPOSFutilitySpending.md):
  `start`, `lower`, `upper`, `maxit`, `reltol`, `backward`, and `trace`.
  Unknown or invalid controls are errors.

## Value

A `c("gsCAFutilitySpending", "gsDesign")` object, with
`caFutilitySpending` diagnostics analogous to those of
`gsCPOSFutilitySpending`, using `target_ca`, `achieved_ca` and `ca_tol`.
Additional fields include `achieved_beta`, `achieved_type1`, and
`fixed_information`. The returned `beta` is achieved overall beta, not
the reference beta. Error classes use the prefix `gsCAFutilitySpending`.

## Details

This is the fixed-information counterpart of
[`gsCPOSFutilitySpending`](https://keaven.github.io/gsDesign/reference/gsCPOSFutilitySpending.md).
The prior, information, efficacy boundaries, spending times and testing
indicators are held fixed. For each candidate spending parameter set,
[`gsBound1()`](https://keaven.github.io/gsDesign/reference/gsBound.md)
derives interim futility bounds, and
[`gsProbability()`](https://keaven.github.io/gsDesign/reference/gsProbability.md)
evaluates total beta when final lower and upper bounds coincide. An
internal scalar solve makes that beta agree with the beta used by the
spending function.

The probability target conditions on continuation through an analysis,
not on an observed statistic at a boundary. An externally calculated
fixed-design
[`gsPOS()`](https://keaven.github.io/gsDesign/reference/gsCP.md)
benchmark can be supplied as a target. This implements a spending-based
fixed-information conditional-assurance rule, not a full sample-size
re-estimation procedure.

With nonbinding futility (`test.type = 4`), the efficacy-only type I
error specification is unchanged. With binding futility
(`test.type = 3`), changing futility while freezing efficacy can change
actual type I error, including increasing it above the reference alpha.
Inspect `achieved_type1`; this function does not promise preservation of
alpha or power in that case. The reference nominal alpha remains in
`x$alpha`.

Replay by calling this function with the original reference, the fitted
spending family, prior and targets, and `control$start` set to the
fitted free parameters. A usual power-preserving
[`gsDesign()`](https://keaven.github.io/gsDesign/reference/gsDesign.md)
call is not an equivalent reconstruction. The internally fitted beta and
spending parameters together specify the lower spending rule at the
fixed information.

## Information fractions and spending times

All six spending calibrators keep the reference analysis information
fractions `x$timing` fixed. These are the cumulative information
fractions `x$n.I / x$n.I[x$k]`, ending at 1. For example,
`x$timing = c(.5, .75, 1)` keeps the analyses at 50%, 75%, and 100% of
the final information. Power-preserving calibration may change the
maximum information and thus the absolute information `n.I` at every
analysis while retaining these fractions. Fixed-information calibration
(`gsCAFutilitySpending()` and
`gsCPOSFutilitySpending(mode = "fixed_information")`) also holds `n.I`
and the efficacy boundaries fixed.

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

[`gsCPOSFutilitySpending`](https://keaven.github.io/gsDesign/reference/gsCPOSFutilitySpending.md),
[`gsCPOS`](https://keaven.github.io/gsDesign/reference/gsCP.md),
[`gsPOS`](https://keaven.github.io/gsDesign/reference/gsCP.md),
[`gsBound1`](https://keaven.github.io/gsDesign/reference/gsBound.md)

## Examples

``` r
x <- gsDesign(k = 2, test.type = 4, sflpar = 0)
prior <- list(z = c(0, x$delta), wgts = c(.2, .8))
target <- gsCPOS(1, x, prior$z, prior$wgts)
fit <- gsCAFutilitySpending(x, target, prior = prior,
                           control = list(start = 1))
fit$caFutilitySpending[c("sflpar", "achieved_ca", "achieved_beta")]
#> $sflpar
#> [1] 0
#> 
#> $achieved_ca
#> [1] 0.8433125
#> 
#> $achieved_beta
#> [1] 0.1
#> 
stopifnot(identical(fit$n.I, x$n.I),
          identical(fit$upper$bound, x$upper$bound))
```

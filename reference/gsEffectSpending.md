# Calibrate Spending to Natural-Scale Effects at Boundaries

Select efficacy, futility or harm spending parameters, separately or
jointly, to match approximate observed effects at interim boundaries.
Candidate designs are rebuilt with gsDesign(), preserving nominal error
budgets and planned power while allowing maximum information to change.

## Usage

``` r
gsEffectSpending(
  x,
  target_effect,
  i = seq_along(target_effect),
  bound = "futility",
  spending = NULL,
  scale = "difference",
  effect = list(),
  control = list()
)
```

## Arguments

- x:

  A `gsDesign`, `gsSurv`, `gsSurvCalendar`, or `gsSurvPower` design with
  `test.type` 3, 4, 7, or 8. The analysis information fractions in
  `x$timing` are held fixed. These fractions are distinct from the times
  supplied to the spending functions; see **Information fractions and
  spending times** below.

- target_effect:

  Finite natural-scale effect targets.

- i:

  Interim indices, one per target. Duplicate boundary/index pairs and
  inactive boundaries are not allowed.

- bound:

  "efficacy", "futility" or "harm", scalar or one per target.

- spending:

  Spending function/name for a single boundary, or a named list keyed by
  targeted boundaries. NULL retains the reference families.

- scale:

  "difference", "rr" or "hr".

- effect:

  Endpoint metadata. For differences, optional endpoint is
  "mean_difference" or "risk_difference"; for RR it is "risk_ratio".
  Difference/RR designs require nondegenerate delta0/delta1 metadata and
  n.fix \> 1. For RR, delta0/delta1 must be log ratios. HR requires
  information = "events", ratio (experimental/control), hr0 (null HR),
  and hr1 (alternative HR), all explicitly supplied. For statistical
  designs, the reference delta must agree with abs(log(hr1/hr0)) \*
  sqrt(ratio)/(1 + ratio), verifying its event-count scale. For survival
  designs, metadata must match the stored allocation and hazard ratios;
  the selected survival method determines the drift.

- control:

  Named solver list. start, lower and upper are parameter vectors for
  one boundary or named lists by boundary for joint fits. Defaults use
  the reference/family settings described in gsCPFutilitySpending.
  effect_tol is a positive finite absolute tolerance in natural effect
  units, scalar or one per target (default 1e-4). maxit is a positive
  integer (default 500), reltol is positive finite (default 1e-10), and
  trace is a scalar logical (default FALSE). Unknown controls are
  errors. sfLinear starts are increasing cumulative proportions; user
  limits are unsupported for sfLinear, whose internal logit coordinates
  are searched over \[-12, 12\].

## Value

A gsDesign object also inheriting from gsEffectSpending, retaining
survival classes when applicable. Component effectSpending contains a
target/achieved/residual table, named spending specifications and free
parameters, effect metadata, solver diagnostics, information inflation,
power and local identifiability diagnostics. replay contains arguments
for do.call(gsDesign, ...); for HR, also restore the returned
hr/hr0/ratio metadata for HR summaries. Errors inherit from
gsEffectSpending_error with input_error or convergence_error suffixes.

## Details

One target per free parameter is required for each selected family.
Supported families are shared with gsCPFutilitySpending(), including
two-parameter functions and piecewise linear spending. Joint fits check
all targets simultaneously. Untargeted spending specifications remain
fixed, but numerical boundaries may change as information is
recalculated.

These are approximate effects at bounds, not true-effect assumptions,
posterior estimates or bias-adjusted sequential estimates. HRs and RRs
are supplied as ratios, not logs. Risk differences must lie in \[-1,
1\]. An effect is transformed using each candidate's information.

Count equality does not ensure identifiability. A numerical Jacobian
rank and condition number are returned as local diagnostics, not proofs
of uniqueness. Harm/futility coincidence is reported and may indicate
capping. A failed search does not prove mathematical infeasibility.
Inspect all operating characteristics and sample-size inflation before
choosing a design. Changing timing or rounding need not retain the
calibrated effects.

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
Candidate probabilities are evaluated on the statistical event-count
scale. Power-preserving probability calibration of fixed-duration,
rate-scaled designs rebuilds the survival plan only for the selected fit
and checks all targets again on the returned object. If the deferred
search or that check fails, calibration retries once with full survival
reconstruction, retaining the best available internal parameters as
starting values. Effect calibration and accrual- or follow-up-duration
solves reconstruct the plan for every candidate. For
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

gsCPFutilitySpending, gsDelta, gsRR, gsHR, gsBoundSummary

## Examples

``` r
x <- gsDesign(k = 3, test.type = 4, n.fix = 200, delta1 = .2, sflpar = 1)
target <- gsDelta(x$lower$bound[1], 1, x)
fit <- gsEffectSpending(x, target, spending = sfHSD,
                        control = list(start = 0))
fit$effectSpending$targets
#>      bound i target_effect achieved_effect     residual
#> 1 futility 1     0.0364253       0.0364253 4.587386e-12
replay <- do.call(gsDesign, fit$effectSpending$replay)
gsDelta(replay$lower$bound[1], 1, replay)
#> [1] 0.0364253
```

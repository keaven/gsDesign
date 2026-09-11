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

  Fixed-timing gsDesign reference with test.type 3, 4, 7 or 8. Direct
  survival objects are unsupported.

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
  and hr1 (alternative HR), all explicitly supplied. The reference delta
  must agree with abs(log(hr1/hr0)) \* sqrt(ratio)/(1 + ratio),
  verifying its event-count scale.

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

A gsDesign object also inheriting from gsEffectSpending. Component
effectSpending contains a target/achieved/residual table, named spending
specifications and free parameters, effect metadata, solver diagnostics,
information inflation, power and local identifiability diagnostics.
replay contains arguments for do.call(gsDesign, ...); for HR, also
restore the returned hr/hr0/ratio metadata for HR summaries. Errors
inherit from gsEffectSpending_error with input_error or
convergence_error suffixes.

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

# Calibrate Futility Spending to Conditional Power Targets

`gsCPFutilitySpending()` selects parameters for a beta-spending futility
boundary so that conditional power at one or more interim futility
bounds matches specified targets. Each candidate design is reconstructed
with
[`gsDesign()`](https://keaven.github.io/gsDesign/reference/gsDesign.md),
which recalculates the statistical information required to retain the
reference design's unconditional power.

## Usage

``` r
gsCPFutilitySpending(
  x,
  target_cp,
  i = seq_along(target_cp),
  sfl = "sfHSD",
  theta = NULL,
  control = list()
)
```

## Arguments

- x:

  A fixed-timing `gsDesign` object with `test.type` 3, 4, 7, or 8.

- target_cp:

  Numeric vector of conditional power targets strictly between zero and
  one.

- i:

  Interim analysis indices corresponding to `target_cp`. Values must
  identify active futility bounds, be unique, and be in `1:(x$k - 1)`.
  Results are ordered by analysis.

- sfl:

  Futility spending function, supplied as a supported function or its
  character name. The default is `"sfHSD"`.

- theta:

  Optional future effect for conditional power. A scalar is recycled;
  otherwise its length must equal `target_cp`. When `NULL`, the observed
  effect at each candidate lower bound is used.

- control:

  Optional named list of numerical solver settings. Unspecified
  components retain their defaults; ordinary use does not require this
  argument. These settings affect the search, not the effect assumption
  or CP target. Unknown names and invalid values produce input errors.

  `start`

  :   Initial spending parameters (default `NULL`). When omitted, use
      the reference design's parameters if its spending function and
      parameter count match; otherwise use the family defaults below.
      Custom spending functions require an explicit starting vector.

  `lower`, `upper`

  :   Search limits for the spending parameters, not Z-boundaries (both
      default `NULL`, selecting the family defaults below). Supplied
      start and limit vectors must be finite numeric vectors matching
      the number of free parameters. Limits must satisfy `lower < upper`
      and contain the starting values.

  `cp_tol`

  :   Maximum absolute difference between achieved and targeted CP at
      every selected analysis (default `1e-4`). Must be a finite scalar
      strictly between 0 and 0.1.

  `maxit`

  :   Positive integer iteration limit for the joint optimizer (default
      500), not a global limit on design evaluations or the
      one-parameter root search.

  `reltol`

  :   Positive finite scalar controlling internal numerical convergence
      (default `1e-10`). This does not replace the final `cp_tol`
      acceptance check.

  `backward`

  :   Use latest-to-earliest initialization before joint refinement for
      multiple targets (default `TRUE`).

  `trace`

  :   Display joint-optimizer progress (default `FALSE`). Both
      `backward` and `trace` must be nonmissing scalar logical values.

## Value

A calibrated design with class `c("gsCPFutilitySpending", "gsDesign")`.
The `cpFutilitySpending` component contains targets, achieved
conditional powers, effects, fitted spending metadata, information,
reference efficacy and harm specifications, and solver diagnostics.

Invalid inputs raise a `gsCPFutilitySpending_input_error`. A well-formed
target that cannot be attained raises a
`gsCPFutilitySpending_infeasible_error`; optimizer failure raises a
`gsCPFutilitySpending_convergence_error`.

## Details

Conditional power is evaluated at the candidate lower bound. When
`theta` is `NULL`, the future effect is the observed effect implied by
that bound, `lower$bound[i] / sqrt(n.I[i])`, following the default
convention in
[`gsCP()`](https://keaven.github.io/gsDesign/reference/gsCP.md). The
calculation conditions on the interim statistic even though it is at a
stopping boundary; future futility bounds remain part of the conditional
power calculation.

One-target calibration supports the one-parameter families `sfHSD`,
`sfPower`, `sfExponential`, and `sfLDOF`. Two-target calibration
supports `sfLogistic`, `sfBetaDist`, `sfCauchy`, `sfNormal`,
`sfExtremeValue`, and `sfExtremeValue2`. `sfLinear` may be used with any
number of targets and is the intended choice for more than two. Its knot
times are fixed at the lower spending times for the targeted analyses;
the fitted cumulative spending proportions are constrained to be
strictly increasing and between zero and one.

With multiple targets, a latest-to-earliest coordinate solve supplies
starting values for a final joint constrained optimization. A result is
returned only when every conditional power residual is within
`control$cp_tol`.

The fitted lower spending parameters depend on the complete design,
including efficacy spending. For `test.type` 7 and 8 they may also
depend on harm spending. Changing any of those specifications requires
recalibration.
[`toInteger()`](https://keaven.github.io/gsDesign/reference/toInteger.md)
carries the fitted spending function and parameters forward, but
rounding information can change the achieved conditional power and does
not trigger recalibration.

## Spending-parameter search defaults

When not supplied in `control`, parameter limits and fallback starting
values are selected by family:

|  |  |  |  |
|----|----|----|----|
| Family | Start | Lower | Upper |
| `sfHSD` | -2 | -40 | 40 |
| `sfPower` | 1 | 1e-4 | 50 |
| `sfExponential` | 0.5 | 1e-4 | 1.5 |
| `sfLDOF` | 1 | 0.005 | 20 |
| `sfBetaDist` | c(1, 1) | c(1e-3, 1e-3) | c(50, 50) |
| Other supported two-parameter families | c(0, 1) | c(-20, 1e-3) | c(20, 50) |
| Custom function | Required | -20 per parameter | 20 per parameter |

For `sfLinear`, `start` instead contains one cumulative spending
proportion per target, strictly increasing and in (0, 1). When omitted,
starting proportions are derived from the reference design's cumulative
lower spending divided by beta and adjusted to satisfy these
constraints. User-supplied `lower` and `upper` are not supported for its
constrained parameterization.

## See also

[`gsDesign`](https://keaven.github.io/gsDesign/reference/gsDesign.md),
[`gsSurv`](https://keaven.github.io/gsDesign/reference/nSurv.md),
[`gsCP`](https://keaven.github.io/gsDesign/reference/gsCP.md),
[`sfLinear`](https://keaven.github.io/gsDesign/reference/sfLinear.md),
[`toInteger`](https://keaven.github.io/gsDesign/reference/toInteger.md),
[`gsPPFutilitySpending`](https://keaven.github.io/gsDesign/reference/gsPPFutilitySpending.md)

## Examples

``` r
# Lan-DeMets O'Brien-Fleming efficacy spending with futility only at IA 1.
x <- gsDesign(
  k = 3, test.type = 4, timing = c(.5, .75),
  sfu = sfLDOF,
  sfl = sfHSD, sflpar = 1,
  testLower = c(TRUE, FALSE, FALSE)
)
target_cp <- .3
# With theta = NULL (the default), CP uses the observed effect implied
# by the interim futility bound.
fit <- gsCPFutilitySpending(x, target_cp = target_cp, i = 1)
fit$cpFutilitySpending[c("target_cp", "achieved_cp", "sflpar")]
#> $target_cp
#> [1] 0.3
#> 
#> $achieved_cp
#> [1] 0.3
#> 
#> $sflpar
#> [1] 2.430891
#> 

# Use the fitted spending parameter in the final gsDesign.
final_design <- gsDesign(
  k = 3, test.type = 4, timing = c(.5, .75),
  sfu = sfLDOF,
  sfl = sfHSD, sflpar = fit$cpFutilitySpending$sflpar,
  testLower = c(TRUE, FALSE, FALSE)
)

# The final design has CP 0.3000 at the first interim futility bound.
gsBoundSummary(
  final_design,
  exclude = "B-value"
)
#>                Analysis               Value Efficacy Futility
#>               IA 1: 50%                   Z   2.9626   1.1538
#>  N/Fixed design N: 0.63         p (1-sided)   0.0015   0.1243
#>                             ~delta at bound   1.1490   0.4475
#>                                    Spending   0.0015   0.0771
#>                                          CP   0.9994   0.3000
#>                                       CP H1   0.9979   0.8145
#>                                          PP   0.9900   0.3552
#>                         P(Cross) if delta=0   0.0015   0.8757
#>                         P(Cross) if delta=1   0.3504   0.0771
#>               IA 2: 75%                   Z   2.3590       NA
#>  N/Fixed design N: 0.95         p (1-sided)   0.0092       NA
#>                             ~delta at bound   0.7470       NA
#>                                    Spending   0.0081       NA
#>                                          CP   0.9222       NA
#>                                       CP H1   0.9700       NA
#>                                          PP   0.8901       NA
#>                         P(Cross) if delta=0   0.0092       NA
#>                         P(Cross) if delta=1   0.7801       NA
#>                   Final                   Z   2.0141       NA
#>  N/Fixed design N: 1.27         p (1-sided)   0.0220       NA
#>                             ~delta at bound   0.5523       NA
#>                                    Spending   0.0154       NA
#>                         P(Cross) if delta=0   0.0196       NA
#>                         P(Cross) if delta=1   0.9000       NA

# Use the same test type, timing, and spending in a survival design.
# Other survival inputs use gsSurv() defaults. The IA 1 futility CP row
# again shows 0.3000, agreeing with target_cp up to numerical tolerance.
surv_design <- gsSurv(
  k = 3, test.type = 4, timing = c(.5, .75),
  sfu = sfLDOF,
  sfl = sfHSD, sflpar = fit$cpFutilitySpending$sflpar,
  testLower = c(TRUE, FALSE, FALSE)
)
gsBoundSummary(surv_design, exclude = "B-value")
#>     Analysis              Value Efficacy Futility
#>    IA 1: 50%                  Z   2.9626   1.1538
#>       N: 284        p (1-sided)   0.0015   0.1243
#>  Events: 102       ~HR at bound   0.5554   0.7953
#>    Month: 11           Spending   0.0015   0.0771
#>                              CP   0.9994   0.3000
#>                           CP H1   0.9979   0.8145
#>                              PP   0.9900   0.3552
#>                P(Cross) if HR=1   0.0015   0.8757
#>              P(Cross) if HR=0.6   0.3504   0.0771
#>    IA 2: 75%                  Z   2.3590       NA
#>       N: 318        p (1-sided)   0.0092       NA
#>  Events: 153       ~HR at bound   0.6823       NA
#>    Month: 14           Spending   0.0081       NA
#>                              CP   0.9222       NA
#>                           CP H1   0.9700       NA
#>                              PP   0.8901       NA
#>                P(Cross) if HR=1   0.0092       NA
#>              P(Cross) if HR=0.6   0.7801       NA
#>        Final                  Z   2.0141       NA
#>       N: 318        p (1-sided)   0.0220       NA
#>  Events: 204       ~HR at bound   0.7538       NA
#>    Month: 18           Spending   0.0154       NA
#>                P(Cross) if HR=1   0.0196       NA
#>              P(Cross) if HR=0.6   0.9000       NA

# Optionally require an absolute CP residual no larger than 0.000001.
fit_tight <- gsCPFutilitySpending(
  x, target_cp = target_cp, i = 1,
  control = list(cp_tol = 1e-6)
)
abs(fit_tight$cpFutilitySpending$achieved_cp - target_cp) <= 1e-6
#> [1] TRUE
```

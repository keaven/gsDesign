# Calibrate Futility Spending to Predictive Power Targets

Select beta-spending futility parameters so that posterior predictive
power at selected interim lower bounds matches the requested targets.
Each candidate is rebuilt with
[`gsDesign()`](https://keaven.github.io/gsDesign/reference/gsDesign.md),
recalculating information to preserve the reference design's target
unconditional power.

## Usage

``` r
gsPPFutilitySpending(
  x,
  target_pp,
  i = seq_along(target_pp),
  sfl = "sfHSD",
  prior,
  control = list()
)
```

## Arguments

- x:

  A fixed-timing `gsDesign` object with `test.type` 3, 4, 7, or 8.

- target_pp:

  Numeric vector of predictive power targets strictly between zero and
  one.

- i:

  Unique active interim futility analysis indices, one per target, in
  `1:(x$k - 1)`. Results are ordered by analysis.

- sfl:

  Supported lower spending function or its character name. Default
  `"sfHSD"`. See Details for supported families.

- prior:

  A list containing finite numeric vectors `z` and `wgts` of the same
  positive length. `z` gives standardized effect values on the
  [`gsPP()`](https://keaven.github.io/gsDesign/reference/gsCP.md) theta
  scale. `wgts` gives nonnegative prior masses or density-weighted
  quadrature weights, with positive total weight. For example, use
  `normalGrid(mu = x$delta / 2, sigma = 10 / sqrt(x$n.fix))` for the
  default prior in `gsBoundSummary(x)`. Weights are normalized
  internally; the normalized prior is retained in the result. A
  one-point prior targets fixed-effect CP.

- control:

  Optional named list of numerical solver settings. Unspecified settings
  retain their defaults; unknown names and invalid values cause input
  errors. These controls change the search, not the prior or target.

  `start`

  :   Initial spending parameters (default `NULL`). Use matching
      reference parameters or family defaults when omitted. Custom
      functions require explicit starts. For `sfLinear`, supply one
      strictly increasing cumulative spending proportion in (0, 1) per
      target, not the full spending parameter vector.

  `lower`, `upper`

  :   Spending-parameter search limits, not Z-boundaries (default
      `NULL`, selecting family defaults). Start and limit vectors must
      be finite and match the free parameter count; `lower < upper` must
      hold and contain the start. Supplied limits are not supported for
      constrained `sfLinear`.

  `pp_tol`

  :   Maximum absolute predictive power residual at every target
      (default `1e-4`); a finite scalar in (0, 0.1).

  `maxit`

  :   Positive integer joint-optimizer iteration limit (default 500),
      not a global limit on design evaluations or the one-parameter root
      search.

  `reltol`

  :   Positive finite internal convergence tolerance (default `1e-10`);
      does not replace the `pp_tol` check.

  `backward`

  :   Initialize multiple-target fitting from the latest interim
      backward before joint refinement (default `TRUE`).

  `trace`

  :   Display joint-optimizer progress (default `FALSE`). Both logical
      controls must be nonmissing scalars.

## Value

A calibrated object with class `c("gsPPFutilitySpending", "gsDesign")`.
Its `ppFutilitySpending` component records `target_pp`, `achieved_pp`,
residuals, analysis indices, normalized prior, fitted spending
parameters, information, unconditional power, reference settings, and
solver diagnostics (including `pp_tol`). Invalid inputs, infeasible
searches, and convergence failures raise respectively
`gsPPFutilitySpending_input_error`,
`gsPPFutilitySpending_infeasible_error`, and
`gsPPFutilitySpending_convergence_error`, all inheriting from
`gsPPFutilitySpending_error`. These describe the implemented search, not
a global certificate of mathematical infeasibility.

## Details

[`gsPP()`](https://keaven.github.io/gsDesign/reference/gsCP.md) averages
conditional power over the posterior effect distribution to give the
probability of future efficacy rejection. This is not the posterior
probability of a positive effect, observed-effect CP, or CP H1. The
prior is held fixed throughout calibration, but the posterior is
recomputed at each candidate lower bound using its information. As in
[`gsPP()`](https://keaven.github.io/gsDesign/reference/gsCP.md),
conditioning uses the interim statistic, not additionally the event of
surviving previous looks. The current bound is a conditioning state, not
a reason to set predictive power to zero.

One target supports `sfHSD`, `sfPower`, `sfExponential`, and `sfLDOF`;
two targets support `sfLogistic`, `sfBetaDist`, `sfCauchy`, `sfNormal`,
`sfExtremeValue`, and `sfExtremeValue2`. `sfLinear` supports one or more
targets with fixed knots at their lower spending times. The target count
must equal the number of free parameters. The solver is shared with
[`gsCPFutilitySpending()`](https://keaven.github.io/gsDesign/reference/gsCPFutilitySpending.md),
including its latest-to-earliest initialization and joint refinement.
Only fits meeting all target tolerances are returned.

Preserve the complete reference design when replaying fitted parameters.
Changing timing, efficacy or harm spending, or testing indicators
requires recalibration. Use the same prior and effect scale when
verifying PP with
[`gsBoundSummary()`](https://keaven.github.io/gsDesign/reference/gsBoundSummary.md).
Direct survival-object calibration is unsupported; the vignette
[`vignette("CPFutilitySpending")`](https://keaven.github.io/gsDesign/articles/CPFutilitySpending.md)
shows reconstruction of a survival design from a matching statistical
reference.

[`toInteger()`](https://keaven.github.io/gsDesign/reference/toInteger.md)
retains the spending specification but does not recalibrate PP after
rounding. Extremely remote prior support can make the likelihood
normalization in
[`gsPP()`](https://keaven.github.io/gsDesign/reference/gsCP.md)
numerically undefined; such candidates are rejected and the diagnostic
reports this if no valid design can be constructed.

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

[`gsCPFutilitySpending`](https://keaven.github.io/gsDesign/reference/gsCPFutilitySpending.md),
[`gsPP`](https://keaven.github.io/gsDesign/reference/gsCP.md),
[`normalGrid`](https://keaven.github.io/gsDesign/reference/normalGrid.md),
[`gsBoundSummary`](https://keaven.github.io/gsDesign/reference/gsBoundSummary.md)

## Examples

``` r
x <- gsDesign(
  k = 3, test.type = 4, timing = c(.5, .75),
  sfu = sfLDOF, sfl = sfHSD, sflpar = 1,
  testLower = c(TRUE, FALSE, FALSE)
)
prior <- normalGrid(mu = x$delta / 2, sigma = 10 / sqrt(x$n.fix))
fit <- gsPPFutilitySpending(x, target_pp = .3, i = 1, prior = prior)
final_design <- gsDesign(
  k = 3, test.type = 4, timing = c(.5, .75),
  sfu = sfLDOF, sfl = sfHSD,
  sflpar = fit$ppFutilitySpending$sflpar,
  testLower = c(TRUE, FALSE, FALSE)
)
gsBoundSummary(final_design, prior = prior, exclude = "B-value")
#>                Analysis               Value Efficacy Futility
#>               IA 1: 50%                   Z   2.9626   1.0469
#>  N/Fixed design N: 0.61         p (1-sided)   0.0015   0.1476
#>                             ~delta at bound   1.1744   0.4150
#>                                    Spending   0.0015   0.0700
#>                                          CP   0.9994   0.2293
#>                                       CP H1   0.9975   0.7672
#>                                          PP   0.9900   0.3000
#>                         P(Cross) if delta=0   0.0015   0.8524
#>                         P(Cross) if delta=1   0.3300   0.0700
#>               IA 2: 75%                   Z   2.3590       NA
#>  N/Fixed design N: 0.91         p (1-sided)   0.0092       NA
#>                             ~delta at bound   0.7635       NA
#>                                    Spending   0.0081       NA
#>                                          CP   0.9222       NA
#>                                       CP H1   0.9672       NA
#>                                          PP   0.8900       NA
#>                         P(Cross) if delta=0   0.0094       NA
#>                         P(Cross) if delta=1   0.7631       NA
#>                   Final                   Z   2.0141       NA
#>  N/Fixed design N: 1.21         p (1-sided)   0.0220       NA
#>                             ~delta at bound   0.5646       NA
#>                                    Spending   0.0154       NA
#>                         P(Cross) if delta=0   0.0206       NA
#>                         P(Cross) if delta=1   0.9000       NA
# Optional tighter predictive power acceptance tolerance:
fit_tight <- gsPPFutilitySpending(
  x, target_pp = .3, i = 1, prior = prior,
  control = list(pp_tol = 1e-6)
)
fit_tight$ppFutilitySpending$residual
#> [1] 2.668129e-10
```

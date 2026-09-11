# Calibrate Futility Spending to Conditional Probability of Success

Select beta-spending parameters to match
[`gsCPOS()`](https://keaven.github.io/gsDesign/reference/gsCP.md)
targets at selected interims, either preserving reference power or
fixing reference information.

## Usage

``` r
gsCPOSFutilitySpending(
  x,
  target_cpos,
  i = seq_along(target_cpos),
  sfl = "sfHSD",
  prior,
  control = list(),
  mode = c("preserve_power", "fixed_information")
)
```

## Arguments

- x:

  A fixed-timing `gsDesign` object with `test.type` 3 or 4.

- target_cpos:

  Numeric conditional assurance targets strictly between zero and one,
  one per selected interim.

- i:

  Unique active interim futility indices, defaulting to
  `seq_along(target_cpos)`. Results are ordered by analysis.

- sfl:

  Supported lower spending function or its name; default `"sfHSD"`. See
  Details.

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

  Named list of solver controls. `cpos_tol` is the maximum absolute
  target residual (default `1e-4`, finite and in (0, 0.1)). The
  remaining controls have the same definitions and defaults as in
  [`gsPPFutilitySpending`](https://keaven.github.io/gsDesign/reference/gsPPFutilitySpending.md):
  `start`, `lower`, and `upper` (all `NULL`); `maxit` (500); `reltol`
  (`1e-10`); `backward` (`TRUE`); and `trace` (`FALSE`). Unknown,
  unnamed, duplicate or invalid controls are errors. `pp_tol` and
  `cp_tol` are not accepted here.

- mode:

  Design constraint: `"preserve_power"` (default) rebuilds candidates
  with
  [`gsDesign()`](https://keaven.github.io/gsDesign/reference/gsDesign.md),
  allowing maximum information to change. `"fixed_information"` holds
  information and efficacy boundaries fixed, solving total beta
  internally and allowing overall power to change.

## Value

A `c("gsCPOSFutilitySpending", "gsDesign")` object. Component
`cposFutilitySpending` contains targets (`target_cpos`), achieved values
(`achieved_cpos`), residuals, indices, normalized prior, fitted
parameters, information and power, reference settings and solver
diagnostics. It also records `continuation_probability`,
`joint_future_efficacy` and `unconditional_pos`. Errors inherit from
`gsCPOSFutilitySpending_error`, with suffixes `_input_error`,
`_infeasible_error` or `_convergence_error`. Both modes also record
`mode`, `fixed_information`, `achieved_beta` and `achieved_type1`.

## Details

Both modes target the existing
[`gsCPOS()`](https://keaven.github.io/gsDesign/reference/gsCP.md)
calculation. In fixed-information mode,
[`gsBound1()`](https://keaven.github.io/gsDesign/reference/gsBound.md)
derives lower bounds and an internal beta solve makes spending
consistent with the final decision. For binding futility, changing lower
bounds while fixing efficacy can increase actual type I error above
nominal alpha; inspect `achieved_type1`. Replay this mode with the
original reference and fitted parameters as `control$start`; an ordinary
power-preserving
[`gsDesign()`](https://keaven.github.io/gsDesign/reference/gsDesign.md)
call is not equivalent. The legacy
[`gsCAFutilitySpending`](https://keaven.github.io/gsDesign/reference/gsCAFutilitySpending.md)
interface is a compatibility wrapper.

Conditional assurance is the prior-averaged probability of future
efficacy rejection given that neither stopping boundary has been crossed
through interim `i`. It includes the entire previous stopping history.
Conditioning on continuation reweights the effect distribution; this
differs from
[`gsPP()`](https://keaven.github.io/gsDesign/reference/gsCP.md), which
conditions on an exact interim statistic, and from unconditional
[`gsPOS()`](https://keaven.github.io/gsDesign/reference/gsCP.md). A
point prior gives fixed-effect success conditional on continuation, not
conditional power at the futility bound.

A fixed-design
[`gsPOS()`](https://keaven.github.io/gsDesign/reference/gsCP.md) value
at a separately chosen feasible sample size can be computed once and
supplied as a benchmark target. The benchmark must not be recomputed
from candidates. Preserving power while adjusting information is an
extension of a fixed-information conditional-assurance rule, not an
implementation of sample-size re-estimation. Inspect sample-size
inflation, overall operating characteristics and effect sizes at all
bounds.

The supported spending families and one-target-per-free-parameter rule
are the same as for
[`gsPPFutilitySpending`](https://keaven.github.io/gsDesign/reference/gsPPFutilitySpending.md),
including two-parameter families and `sfLinear`. The shared solver
accepts only fits meeting every target tolerance; failure is not a proof
of global infeasibility.

Candidate continuation probabilities at or below
`sqrt(.Machine$double.eps)` are rejected to avoid unstable conditioning.
Harm-bound designs are unsupported because
[`gsCPOS()`](https://keaven.github.io/gsDesign/reference/gsCP.md) does
not account for their harm stopping probability in its denominator.
Direct survival objects are unsupported; use a matching fixed-timing
statistical design. Replay parameters with the complete reference design
and the same prior. Spending functions retain their usual timing
flexibility, but changed timing, testing indicators or rounding need not
retain exact target values.

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

[`gsCPOS`](https://keaven.github.io/gsDesign/reference/gsCP.md),
[`gsPOS`](https://keaven.github.io/gsDesign/reference/gsCP.md),
[`gsPPFutilitySpending`](https://keaven.github.io/gsDesign/reference/gsPPFutilitySpending.md),
[`gsCPFutilitySpending`](https://keaven.github.io/gsDesign/reference/gsCPFutilitySpending.md)

## Examples

``` r
x <- gsDesign(k = 3, test.type = 4, timing = c(.5, .75), sflpar = 1)
prior <- list(z = c(0, x$delta), wgts = c(.2, .8))
target <- gsCPOS(i = 1, x = x, theta = prior$z, wgts = prior$wgts)
fit <- gsCPOSFutilitySpending(
  x, target_cpos = target, i = 1, prior = prior,
  control = list(start = 0)
)
fit$cposFutilitySpending$sflpar
#> [1] 1
gsCPOS(i = 1, x = fit, theta = prior$z, wgts = prior$wgts)
#> [1] 0.870641
fixed <- gsCPOSFutilitySpending(
  x, target_cpos = target, prior = prior, mode = "fixed_information"
)
fixed$cposFutilitySpending[c("mode", "achieved_cpos", "achieved_beta")]
#> $mode
#> [1] "fixed_information"
#> 
#> $achieved_cpos
#> [1] 0.870641
#> 
#> $achieved_beta
#> [1] 0.09999996
#> 
stopifnot(identical(fixed$n.I, x$n.I))
```

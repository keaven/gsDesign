# Calibrate Futility Spending to Unconditional Probability of Success

Select one free beta-spending parameter to match the unconditional
prior-predictive probability of success
[`gsPOS()`](https://keaven.github.io/gsDesign/reference/gsCP.md).
Recalculate maximum information to preserve reference frequentist power.

## Usage

``` r
gsPOSFutilitySpending(x, target_pos, sfl = "sfHSD", prior, control = list())
```

## Arguments

- x:

  A fixed-timing `gsDesign` object with `test.type` 3 or 4.

- target_pos:

  A single probability of success strictly between zero and one for the
  complete design. This is not an interim-specific target.

- sfl:

  A supported one-parameter lower spending function or its name. Default
  `"sfHSD"`. A custom function must expose exactly one free parameter.
  For `sfLinear`, a single free knot is placed at the first active
  interim futility spending time.

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

A `c("gsPOSFutilitySpending", "gsDesign")` object with
`posFutilitySpending` diagnostics. These include `target_pos`,
`achieved_pos`, residual, normalized prior, fitted parameters,
information, frequentist power, reference settings and solver
diagnostics including `pos_tol`. There is no interim target index. Error
classes use the prefix `gsPOSFutilitySpending`.

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

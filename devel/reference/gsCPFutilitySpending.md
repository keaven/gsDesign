# Calibrate Futility Spending to Conditional-Power Targets

`gsCPFutilitySpending()` selects parameters for a beta-spending futility
boundary so that conditional power at one or more interim futility
bounds matches specified targets. Each candidate design is reconstructed
with
[`gsDesign()`](https://keaven.github.io/gsDesign/devel/reference/gsDesign.md),
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

  Numeric vector of conditional-power targets strictly between zero and
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

  Optional named list with components `start`, `lower`, `upper`,
  `cp_tol` (default `1e-4`), `maxit` (default 500), `reltol` (default
  `1e-10`), `backward` (default `TRUE`), and `trace` (default `FALSE`).
  For `sfLinear`, `start` is a vector of cumulative spending
  proportions; for other families it contains the spending-function
  parameters.

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
[`gsCP()`](https://keaven.github.io/gsDesign/devel/reference/gsCP.md).
The calculation conditions on the interim statistic even though it is at
a stopping boundary; future futility bounds remain part of the
conditional-power calculation.

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
returned only when every conditional-power residual is within
`control$cp_tol`.

The fitted lower spending parameters depend on the complete design,
including efficacy spending. For `test.type` 7 and 8 they may also
depend on harm spending. Changing any of those specifications requires
recalibration.
[`toInteger()`](https://keaven.github.io/gsDesign/devel/reference/toInteger.md)
carries the fitted spending function and parameters forward, but
rounding information can change the achieved conditional power and does
not trigger recalibration.

## See also

[`gsDesign`](https://keaven.github.io/gsDesign/devel/reference/gsDesign.md),
[`gsCP`](https://keaven.github.io/gsDesign/devel/reference/gsCP.md),
[`sfLinear`](https://keaven.github.io/gsDesign/devel/reference/sfLinear.md),
[`toInteger`](https://keaven.github.io/gsDesign/devel/reference/toInteger.md)

## Examples

``` r
x <- gsDesign(
  k = 3, test.type = 4, timing = c(.5, .75),
  sfu = sfHSD, sfupar = -4,
  sfl = sfHSD, sflpar = 1
)
observed_effect <- x$lower$bound[1] / sqrt(x$n.I[1])
target <- sum(gsCP(
  x, i = 1, zi = x$lower$bound[1], theta = observed_effect
)$upper$prob)
fit <- gsCPFutilitySpending(x, target_cp = target, i = 1)
fit$cpFutilitySpending[c("target_cp", "achieved_cp", "sflpar")]
#> $target_cp
#> [1] 0.1629274
#> 
#> $achieved_cp
#> [1] 0.1629274
#> 
#> $sflpar
#> [1] 1
#> 

target_h1 <- sum(gsCP(
  x, i = 1, zi = x$lower$bound[1], theta = x$delta
)$upper$prob)
fit_h1 <- gsCPFutilitySpending(
  x, target_cp = target_h1, i = 1, theta = x$delta
)
fit_h1$cpFutilitySpending$theta
#> [1] 3.241516
```

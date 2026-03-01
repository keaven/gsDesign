# Selective bound testing at interim analyses

## Introduction

In many clinical trial designs, it is desirable to test only certain
boundaries at specific interim analyses. For example:

- **Futility testing at early interims only**: In some trial designs, a
  futility assessment is only meaningful at the first interim analysis.
  Later analyses focus solely on efficacy.
- **No efficacy testing at the first interim**: Some regulatory or
  operational considerations may preclude testing for efficacy at the
  very first interim.
- **Selective harm monitoring**: For designs with harm bounds
  (`test.type = 7` or `8`), harm monitoring may be needed only at
  certain analyses.

The `testUpper`, `testLower`, and `testHarm` parameters in
[`gsDesign()`](https://keaven.github.io/gsDesign/reference/gsDesign.md),
[`gsSurv()`](https://keaven.github.io/gsDesign/reference/nSurv.md), and
[`gsSurvCalendar()`](https://keaven.github.io/gsDesign/reference/gsSurvCalendar.md)
allow fine-grained control over which bounds are active at each
analysis. When a bound is inactive at a given analysis, it is set to an
extreme value (\\\pm 20\\ on the Z-scale) so that it cannot be crossed,
and is displayed as `NA` in summaries.

## Parameters

Each of `testUpper`, `testLower`, and `testHarm` accepts either a single
logical value (recycled to all analyses) or a logical vector of length
`k` (the number of analyses):

| Parameter   | Description                     | Default | Constraints                                                                                                                                                                  |
|-------------|---------------------------------|---------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `testUpper` | Test the upper (efficacy) bound | `TRUE`  | Must be `TRUE` at the final analysis. For `test.type` 1 and 2, overridden to all `TRUE`.                                                                                     |
| `testLower` | Test the lower (futility) bound | `TRUE`  | Ignored for `test.type = 1` (one-sided). Overridden to all `TRUE` for `test.type = 2` (symmetric). For `test.type >= 3`, at least one analysis must have `testLower = TRUE`. |
| `testHarm`  | Test the harm bound             | `TRUE`  | Only applies to `test.type = 7` or `8`. At least one analysis must have `testHarm = TRUE`.                                                                                   |

**Validation**: At every analysis, at least one of the active bounds
must be `TRUE`. If all three are `FALSE` at any analysis, an error is
raised.

## Example 1: Futility testing only at the first interim

A common scenario is to test for futility only at the first interim
analysis, with efficacy testing at all analyses. This is useful when the
trial’s data monitoring committee wants an early “go/no-go” decision,
but not ongoing futility monitoring.

``` r
# 3-analysis design with non-binding futility (test.type = 4)
# Futility testing only at IA1
x1 <- gsDesign(
  k = 3,
  test.type = 4,
  alpha = 0.025,
  beta = 0.1,
  sfu = sfHSD,
  sfupar = -4,
  sfl = sfHSD,
  sflpar = -2,
  testLower = c(TRUE, FALSE, FALSE)
)
```

The lower bound is active only at IA1. At IA2 and the final analysis,
the futility bound shows as `NA`:

``` r
gsBoundSummary(x1)
#>                Analysis               Value Efficacy Futility
#>               IA 1: 33%                   Z   3.0107  -0.2387
#>  N/Fixed design N: 0.36         p (1-sided)   0.0013   0.5943
#>                             ~delta at bound   1.5553  -0.1233
#>                         P(Cross) if delta=0   0.0013   0.4057
#>                         P(Cross) if delta=1   0.1412   0.0148
#>               IA 2: 67%                   Z   2.5465       NA
#>  N/Fixed design N: 0.71         p (1-sided)   0.0054       NA
#>                             ~delta at bound   0.9302       NA
#>                         P(Cross) if delta=0   0.0062       NA
#>                         P(Cross) if delta=1   0.5815       NA
#>                   Final                   Z   1.9992       NA
#>  N/Fixed design N: 1.07         p (1-sided)   0.0228       NA
#>                             ~delta at bound   0.5963       NA
#>                         P(Cross) if delta=0   0.0244       NA
#>                         P(Cross) if delta=1   0.9077       NA
```

The probabilities under the null and alternative are recomputed
accounting for the inactive bounds. Notice the cumulative futility
crossing probability does not increase after IA1 since no further
futility testing occurs.

We can also see the bounds in the
[`print()`](https://rdrr.io/r/base/print.html) output:

``` r
x1
#> Asymmetric two-sided group sequential design with
#> 90 % power and 2.5 % Type I Error.
#> Upper bound spending computations assume
#> trial continues if lower bound is crossed.
#> 
#>            Sample
#>             Size    ----Lower bounds----  ----Upper bounds-----
#>   Analysis Ratio*   Z   Nominal p Spend+  Z   Nominal p Spend++
#>          1  0.357 -0.24    0.4057 0.0148 3.01    0.0013  0.0013
#>          2  0.713    NA        NA     NA 2.55    0.0054  0.0049
#>          3  1.070    NA        NA     NA 2.00    0.0228  0.0188
#>      Total                        0.0148                 0.0250 
#> + lower bound beta spending (under H1):
#>  Hwang-Shih-DeCani spending function with gamma = -2.
#> ++ alpha spending:
#>  Hwang-Shih-DeCani spending function with gamma = -4.
#> * Sample size ratio compared to fixed design with no interim
#> 
#> Boundary crossing probabilities and expected sample size
#> assume any cross stops the trial
#> 
#> Upper boundary (power or Type I Error)
#>           Analysis
#>    Theta      1      2      3  Total   E{N}
#>   0.0000 0.0013 0.0049 0.0181 0.0244 0.7779
#>   3.2415 0.1412 0.4403 0.3262 0.9077 0.8016
#> 
#> Lower boundary (futility or Type II Error)
#>           Analysis
#>    Theta      1 2 3  Total
#>   0.0000 0.4057 0 0 0.4057
#>   3.2415 0.0148 0 0 0.0148
```

### Plotting

The standard plot shows the active bounds, with inactive bounds omitted:

``` r
plot(x1, plottype = 1)
```

![Power plot with futility only at
IA1](SelectiveBoundTesting_files/figure-html/unnamed-chunk-6-1.svg)

Power plot with futility only at IA1

## Example 2: No efficacy testing at the first interim

In some settings, particularly early-phase or adaptive designs, efficacy
testing may be deferred until sufficient data have accrued. Here we skip
the efficacy bound at the first interim:

``` r
# 3-analysis design with binding futility (test.type = 3)
# No efficacy testing at IA1
x2 <- gsDesign(
  k = 3,
  test.type = 3,
  alpha = 0.025,
  beta = 0.1,
  sfu = sfHSD,
  sfupar = -4,
  sfl = sfHSD,
  sflpar = -2,
  testUpper = c(FALSE, TRUE, TRUE)
)
```

``` r
gsBoundSummary(x2)
#>                Analysis               Value Efficacy Futility
#>               IA 1: 33%                   Z       NA  -0.2579
#>  N/Fixed design N: 0.35         p (1-sided)       NA   0.6018
#>                             ~delta at bound       NA  -0.1346
#>                         P(Cross) if delta=0       NA   0.3982
#>                         P(Cross) if delta=1       NA   0.0148
#>               IA 2: 67%                   Z   2.4976   0.9138
#>   N/Fixed design N: 0.7         p (1-sided)   0.0063   0.1804
#>                             ~delta at bound   0.9215   0.3371
#>                         P(Cross) if delta=0   0.0062   0.8279
#>                         P(Cross) if delta=1   0.5841   0.0437
#>                   Final                   Z   1.9593   1.9593
#>  N/Fixed design N: 1.05         p (1-sided)   0.0250   0.0250
#>                             ~delta at bound   0.5902   0.5902
#>                         P(Cross) if delta=0   0.0250   0.9750
#>                         P(Cross) if delta=1   0.9006   0.0994
```

At IA1, only the futility bound is active. The efficacy bound appears as
`NA` for that analysis.

## Example 3: Survival design with selective bounds via gsSurv

The `testUpper`, `testLower`, and `testHarm` parameters pass through to
[`gsSurv()`](https://keaven.github.io/gsDesign/reference/nSurv.md) and
[`gsSurvCalendar()`](https://keaven.github.io/gsDesign/reference/gsSurvCalendar.md):

``` r
# Survival design with futility only at IA1
xs <- gsSurv(
  k = 3,
  test.type = 4,
  alpha = 0.025,
  beta = 0.1,
  hr = 0.7,
  timing = c(0.5, 0.75),
  sfu = sfHSD,
  sfupar = -4,
  sfl = sfHSD,
  sflpar = -2,
  lambdaC = log(2) / 12,
  eta = 0.01,
  gamma = 10,
  R = 12,
  T = 36,
  minfup = 24,
  testLower = c(TRUE, FALSE, FALSE)
)
gsBoundSummary(xs)
#> Method: LachinFoulkes 
#>     Analysis              Value Efficacy Futility
#>    IA 1: 50%                  Z   2.7500   0.4555
#>       N: 524        p (1-sided)   0.0030   0.3244
#>  Events: 179       ~HR at bound   0.6623   0.9340
#>    Month: 15   P(Cross) if HR=1   0.0030   0.6756
#>              P(Cross) if HR=0.7   0.3572   0.0269
#>    IA 2: 75%                  Z   2.4318       NA
#>       N: 524        p (1-sided)   0.0075       NA
#>  Events: 268       ~HR at bound   0.7427       NA
#>    Month: 23   P(Cross) if HR=1   0.0089       NA
#>              P(Cross) if HR=0.7   0.6959       NA
#>        Final                  Z   2.0116       NA
#>       N: 524        p (1-sided)   0.0221       NA
#>  Events: 357       ~HR at bound   0.8081       NA
#>    Month: 36   P(Cross) if HR=1   0.0239       NA
#>              P(Cross) if HR=0.7   0.9067       NA
```

## Example 4: Selective harm monitoring (test.type 7/8)

For designs with a separate harm bound, the `testHarm` parameter
controls which analyses include harm monitoring. This can be useful when
harm monitoring is most critical during early enrollment, before
longer-term safety data are available.

``` r
# Harm bound design with harm monitoring only at IA1 and IA2
xh <- gsDesign(
  k = 3,
  test.type = 8,
  alpha = 0.025,
  beta = 0.1,
  astar = 0.05,
  sfu = sfHSD,
  sfupar = -4,
  sfl = sfHSD,
  sflpar = -2,
  sfharm = sfHSD,
  sfharmparam = 1,
  testHarm = c(TRUE, TRUE, FALSE)
)
gsBoundSummary(xh)
#>                Analysis               Value    Harm Futility
#>               IA 1: 33%                   Z -2.0061  -0.2387
#>  N/Fixed design N: 0.36         p (1-sided)  0.9776   0.5943
#>                             ~delta at bound -1.0363  -0.1233
#>                         P(Cross) if delta=0  0.0224   0.4057
#>                         P(Cross) if delta=1  0.0000   0.0148
#>               IA 2: 67%                   Z -1.9827   0.9411
#>  N/Fixed design N: 0.71         p (1-sided)  0.9763   0.1733
#>                             ~delta at bound -0.7242   0.3438
#>                         P(Cross) if delta=0  0.0385   0.8347
#>                         P(Cross) if delta=1  0.0000   0.0437
#>                   Final                   Z      NA   1.9992
#>  N/Fixed design N: 1.07         p (1-sided)      NA   0.0228
#>                             ~delta at bound      NA   0.5963
#>                         P(Cross) if delta=0      NA   0.9767
#>                         P(Cross) if delta=1      NA   0.1000
#>  Efficacy
#>    3.0107
#>    0.0013
#>    1.5553
#>    0.0013
#>    0.1412
#>    2.5465
#>    0.0054
#>    0.9302
#>    0.0062
#>    0.5815
#>    1.9992
#>    0.0228
#>    0.5963
#>    0.0233
#>    0.9000
```

The harm bound is `NA` at the final analysis.

## Example 5: Combining selective efficacy and futility

Both `testUpper` and `testLower` can be specified simultaneously. For
example, a design with futility-only at IA1 and efficacy-only at IA2:

``` r
# Futility only at IA1, efficacy only at IA2, both at Final
x5 <- gsDesign(
  k = 3,
  test.type = 4,
  alpha = 0.025,
  beta = 0.1,
  sfu = sfHSD,
  sfupar = -4,
  sfl = sfHSD,
  sflpar = -2,
  testUpper = c(FALSE, TRUE, TRUE),
  testLower = c(TRUE, FALSE, FALSE)
)
gsBoundSummary(x5)
#>                Analysis               Value Efficacy Futility
#>               IA 1: 33%                   Z       NA  -0.2387
#>  N/Fixed design N: 0.36         p (1-sided)       NA   0.5943
#>                             ~delta at bound       NA  -0.1233
#>                         P(Cross) if delta=0       NA   0.4057
#>                         P(Cross) if delta=1       NA   0.0148
#>               IA 2: 67%                   Z   2.4979       NA
#>  N/Fixed design N: 0.71         p (1-sided)   0.0062       NA
#>                             ~delta at bound   0.9124       NA
#>                         P(Cross) if delta=0   0.0062       NA
#>                         P(Cross) if delta=1   0.5945       NA
#>                   Final                   Z   1.9947       NA
#>  N/Fixed design N: 1.07         p (1-sided)   0.0230       NA
#>                             ~delta at bound   0.5949       NA
#>                         P(Cross) if delta=0   0.0244       NA
#>                         P(Cross) if delta=1   0.9083       NA
```

Note the `NA` values: efficacy is `NA` at IA1, and futility is `NA` at
IA2 and the final analysis.

## Validation rules

The following rules are enforced:

1.  **`testUpper` must be `TRUE` at the final analysis** (the trial must
    always be able to reject \\H_0\\).
2.  **At least one bound must be active at every analysis**. For
    example, setting `testUpper = c(FALSE, TRUE, TRUE)` and
    `testLower = c(FALSE, TRUE, TRUE)` would fail because no bound is
    active at IA1.
3.  **`test.type = 1`**: Only one-sided efficacy testing. `testLower` is
    ignored (set to `FALSE` internally).
4.  **`test.type = 2`**: Symmetric two-sided testing. Both `testUpper`
    and `testLower` are overridden to all `TRUE`.
5.  **`test.type` 3–8**: `testLower` must be `TRUE` for at least one
    analysis.
6.  **`test.type` 7 and 8**: `testHarm` must be `TRUE` for at least one
    analysis.

``` r
# This fails: testUpper must be TRUE at the final analysis
try(gsDesign(k = 3, test.type = 3, testUpper = c(TRUE, TRUE, FALSE)))
#> Error in gsTestBoundsCheck(x$k, x$test.type, testUpper, testLower, testHarm) : 
#>   testUpper must be TRUE at the final analysis
```

``` r
# This fails: no bound active at analysis 1
try(gsDesign(k = 3, test.type = 4,
  testUpper = c(FALSE, TRUE, TRUE),
  testLower = c(FALSE, TRUE, TRUE)
))
#> Error in gsTestBoundsCheck(x$k, x$test.type, testUpper, testLower, testHarm) : 
#>   At analysis 1 at least one of testUpper, testLower, or testHarm must be TRUE
```

## Accessing stored flags

The `testUpper`, `testLower`, and `testHarm` logical vectors are stored
on the returned `gsDesign` object:

``` r
x1$testUpper
#> [1] TRUE TRUE TRUE
x1$testLower
#> [1]  TRUE FALSE FALSE
x1$testHarm
#> [1] FALSE FALSE FALSE
```

These can be inspected programmatically for downstream analyses or
reporting.

## Type I Error Preservation

A key property of the selective bounds implementation is that **Type I
error is preserved at the nominal level** regardless of which analyses
are skipped.

### How it works

When bounds are selectively deactivated, the cumulative spending at each
*performed* analysis remains at the spending function’s planned value.
At inactive analyses, the cumulative spending is frozen (no incremental
spend), causing the C code to produce \\\pm\\EXTREMEZ bounds. At the
next active analysis, the incremental spend absorbs the budget from any
prior skipped analyses, so the cumulative spend catches up to the
planned level. The efficacy bounds at active analyses are then
recomputed using the modified spending with the sample size held fixed,
ensuring the total alpha spent equals the nominal level.

### Non-binding futility (test.type 4 or 6)

For non-binding designs, the efficacy bounds are computed under the
assumption that the trial *may continue past the futility bound* (i.e.,
futility does not contribute to the upper alpha calculation). Since
upper bounds are independent of lower bounds, removing futility has no
effect on the upper (efficacy) bounds or the non-binding alpha:

``` r
# Baseline non-binding design
x_nb <- gsDesign(k = 3, test.type = 4, alpha = 0.025, beta = 0.1)

# Remove futility at IA2 and final
x_nb_sel <- gsDesign(k = 3, test.type = 4, alpha = 0.025, beta = 0.1,
  testLower = c(TRUE, FALSE, FALSE))

# Non-binding alpha (computed ignoring lower bounds)
nb_alpha_base <- sum(gsDesign:::gsprob(0, x_nb$n.I, rep(-20, 3), x_nb$upper$bound, r = x_nb$r)$probhi)
nb_alpha_sel  <- sum(gsDesign:::gsprob(0, x_nb_sel$n.I, rep(-20, 3), x_nb_sel$upper$bound, r = x_nb_sel$r)$probhi)
cat("Baseline non-binding alpha: ", nb_alpha_base, "\n")
#> Baseline non-binding alpha:  0.025
cat("Selective non-binding alpha:", nb_alpha_sel , "\n")
#> Selective non-binding alpha: 0.025
cat("Upper bounds identical:     ", all.equal(x_nb$upper$bound, x_nb_sel$upper$bound), "\n")
#> Upper bounds identical:      TRUE
```

When removing early efficacy bounds, the upper bounds at active analyses
adjust to absorb the redistributed spending, still totalling exactly
\\\alpha = 0.025\\:

``` r
# Remove efficacy at IA1
x_nb_eff <- gsDesign(k = 3, test.type = 4, alpha = 0.025, beta = 0.1,
  testUpper = c(FALSE, TRUE, TRUE))
nb_alpha_eff <- sum(gsDesign:::gsprob(0, x_nb_eff$n.I, rep(-20, 3), x_nb_eff$upper$bound, r = x_nb_eff$r)$probhi)
cat("Non-binding alpha (skip IA1 efficacy):", nb_alpha_eff, "\n")
#> Non-binding alpha (skip IA1 efficacy): 0.025
```

### Binding futility (test.type 3 or 5)

For binding designs, the efficacy bounds depend on the futility bounds.
When futility bounds are selectively removed, the bounds are recomputed
with the modified spending while holding sample size fixed. This ensures
the cumulative Type I error remains at the nominal level:

``` r
# Baseline binding design
x_b <- gsDesign(k = 3, test.type = 3, alpha = 0.025, beta = 0.1)
cat("Baseline alpha:", sum(x_b$upper$prob[, 1]), "\n")
#> Baseline alpha: 0.02500087

# Remove futility at IA2 and final
x_b_sel <- gsDesign(k = 3, test.type = 3, alpha = 0.025, beta = 0.1,
  testLower = c(TRUE, FALSE, FALSE))
cat("Selective alpha:", sum(x_b_sel$upper$prob[, 1]), "\n")
#> Selective alpha: 0.025

# Remove efficacy at IA1
x_b_eff <- gsDesign(k = 3, test.type = 3, alpha = 0.025, beta = 0.1,
  testUpper = c(FALSE, TRUE, TRUE))
cat("Skip IA1 efficacy alpha:", sum(x_b_eff$upper$prob[, 1]), "\n")
#> Skip IA1 efficacy alpha: 0.025
```

In all cases, the actual Type I error is exactly \\\alpha = 0.025\\
(within numerical tolerance). The sample size remains unchanged from the
baseline design, and the bounds at active analyses adjust to properly
allocate the spending budget.

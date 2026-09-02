# Summarize an exact binomial vaccine or prevention efficacy design

Creates a vaccine or prevention efficacy summary table from an exact
binomial design. The table includes event-count bounds, efficacy at each
bound, cumulative error spending, and cumulative efficacy-crossing
probabilities for selected efficacy assumptions. Optional time-to-event
design information adds planned analysis times and expected enrollment.

## Usage

``` r
VEtable(x, ve, tteDesign = NULL, ratio = NULL)
```

## Arguments

- x:

  An object of class `gsBinomialExact`, generally created by
  [`toBinomialExact`](https://keaven.github.io/gsDesign/devel/reference/toBinomialExact.md).

- ve:

  Numeric vector of vaccine or prevention efficacy assumptions strictly
  between 0 and 1.

- tteDesign:

  Optional `gsSurv` object with the same number of analyses as `x`. When
  supplied, planned analysis time and expected enrollment are included.

- ratio:

  Experimental-to-control randomization ratio. By default, this is taken
  from `tteDesign` or from a design created by
  [`toBinomialExact()`](https://keaven.github.io/gsDesign/devel/reference/toBinomialExact.md).

## Value

A tibble with one row per analysis. The columns contain analysis number,
optional timing and enrollment, total cases, exact efficacy and futility
bounds, efficacy at each bound, cumulative alpha and beta spending, and
cumulative efficacy-crossing probability under each value in `ve`.

## Details

Vaccine efficacy (VE), also termed prevention efficacy (PE) for
non-vaccine preventive interventions, is translated to the exact
binomial probability that an event is in the experimental group using
the specified randomization ratio. The argument is named \`ve\` because
the motivating application is a vaccine trial; the same calculation
applies to PE. Cumulative alpha is calculated while ignoring non-binding
futility, as is required for exact efficacy Type I error control.

## See also

[`toBinomialExact`](https://keaven.github.io/gsDesign/devel/reference/toBinomialExact.md),
[`vignette("VaccineEfficacy")`](https://keaven.github.io/gsDesign/devel/articles/VaccineEfficacy.md)

## Examples

``` r
x <- gsSurv(
  k = 2, test.type = 4, timing = .6, ratio = 3,
  hr = .3, hr0 = .7, lambdaC = .002, eta = .0001,
  gamma = 10, R = 8, T = 24, minfup = 16
)
exact <- toBinomialExact(x)
VEtable(exact, ve = c(.5, .7), tteDesign = x)
#> # A tibble: 2 × 12
#>   Analysis  Time     N Cases Success Futility ve_efficacy ve_futility   alpha
#>      <int> <dbl> <dbl> <dbl>   <dbl>    <dbl>       <dbl>       <dbl>   <dbl>
#> 1        1  15.9  3569    40      18       26       0.727       0.381 0.00246
#> 2        2  24    3569    67      37       38       0.589       0.563 0.0222 
#> # ℹ 3 more variables: beta <dbl>, `50%` <dbl>, `70%` <dbl>
```

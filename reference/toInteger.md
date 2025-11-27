# Translate group sequential design to integer events (survival designs) or sample size (other designs)

Translate group sequential design to integer events (survival designs)
or sample size (other designs)

## Usage

``` r
toInteger(x, ratio = x$ratio, roundUpFinal = TRUE)
```

## Arguments

- x:

  An object of class `gsDesign` or `gsSurv`.

- ratio:

  Usually corresponds to experimental:control sample size ratio. If an
  integer is provided, rounding is done to a multiple of `ratio + 1`.
  See details. If input is non integer, rounding is done to the nearest
  integer or nearest larger integer depending on `roundUpFinal`.

- roundUpFinal:

  Sample size is rounded up to a value of `ratio + 1` with the default
  `roundUpFinal = TRUE` if `ratio` is a non-negative integer. If
  `roundUpFinal = FALSE` and `ratio` is a non-negative integer, sample
  size is rounded to the nearest multiple of `ratio + 1`. For event
  counts, `roundUpFinal = TRUE` rounds final event count up; otherwise,
  just rounded if `roundUpFinal = FALSE`. See details.

## Value

Output is an object of the same class as input `x`; i.e., `gsDesign`
with integer vector for `n.I` or `gsSurv` with integer vector `n.I` and
integer total sample size. See details.

## Details

It is useful to explicitly provide the argument `ratio` when a
`gsDesign` object is input since
[`gsDesign()`](https://keaven.github.io/gsDesign/reference/gsDesign.md)
does not have a `ratio` in return. `ratio = 0, roundUpFinal = TRUE` will
just round up the sample size (also event count). Rounding of event
count targets is not impacted by `ratio`. Since `x <- gsSurv(ratio = M)`
returns a value for `ratio`, `toInteger(x)` will round to a multiple of
`M + 1` if `M` is a non-negative integer; otherwise, just rounding will
occur. The most common example would be if there is 1:1 randomization
(2:1) and the user wishes an even (multiple of 3) sample size, then
`toInteger()` will operate as expected. To just round without concern
for randomization ratio, set `ratio = 0`. If `toInteger(x, ratio = 3)`,
rounding for final sample size is done to a multiple of 3 + 1 = 4; this
could represent a 3:1 or 1:3 randomization ratio. For 3:2 randomization,
`ratio = 4` would ensure rounding sample size to a multiple of 5.

## Examples

``` r
# The following code derives the group sequential design using the method
# of Lachin and Foulkes

x <- gsSurv(
  k = 3,                 # 3 analyses
  test.type = 4,         # Non-binding futility bound 1 (no futility bound) and 4 are allowable
  alpha = .025,          # 1-sided Type I error
  beta = .1,             # Type II error (1 - power)
  timing = c(0.45, 0.7), # Proportion of final planned events at interims
  sfu = sfHSD,           # Efficacy spending function
  sfupar = -4,           # Parameter for efficacy spending function
  sfl = sfLDOF,          # Futility spending function; not needed for test.type = 1
  sflpar = 0,            # Parameter for futility spending function
  lambdaC = .001,        # Exponential failure rate
  hr = 0.3,              # Assumed proportional hazard ratio (1 - vaccine efficacy = 1 - VE)
  hr0 = 0.7,             # Null hypothesis VE
  eta = 5e-04,           # Exponential dropout rate
  gamma = 10,            # Piecewise exponential enrollment rates
  R = 16,                # Time period durations for enrollment rates in gamma
  T = 24,                # Planned trial duration
  minfup = 8,            # Planned minimum follow-up
  ratio = 3              # Randomization ratio (experimental:control)
)
# Convert sample size to multiple of ratio + 1 = 4, round event counts.
# Default is to round up both event count and sample size for final analysis
toInteger(x)
#> Time to event group sequential design with HR= 0.3 
#> Non-inferiority design with null HR= 0.7 
#> Randomization (Exp/Control):  ratio= 3 
#> Asymmetric two-sided group sequential design with
#> 90 % power and 2.5 % Type I Error.
#> Upper bound spending computations assume
#> trial continues if lower bound is crossed.
#> 
#>                ----Lower bounds----  ----Upper bounds-----
#>   Analysis N   Z   Nominal p Spend+  Z   Nominal p Spend++
#>          1 31 0.07    0.5277 0.0141 2.83    0.0023  0.0023
#>          2 48 1.11    0.8673 0.0345 2.52    0.0059  0.0047
#>          3 69 2.00    0.9774 0.0514 2.00    0.0226  0.0179
#>      Total                   0.1000                 0.0250 
#> + lower bound beta spending (under H1):
#>  Lan-DeMets O'Brien-Fleming approximation spending function (no parameters).
#> ++ alpha spending:
#>  Hwang-Shih-DeCani spending function with gamma = -4.
#> 
#> Boundary crossing probabilities and expected sample size
#> assume any cross stops the trial
#> 
#> Upper boundary (power or Type I Error)
#>           Analysis
#>    Theta      1      2      3  Total E{N}
#>   0.0000 0.0023 0.0047 0.0159 0.0230 41.5
#>   0.4065 0.2863 0.3402 0.2762 0.9027 49.7
#> 
#> Lower boundary (futility or Type II Error)
#>           Analysis
#>    Theta      1      2      3  Total
#>   0.0000 0.5277 0.3439 0.1054 0.9770
#>   0.4065 0.0141 0.0345 0.0487 0.0973
#>              T        n Events HR futility HR efficacy
#> IA 1  15.22419 8624.502     31       0.680       0.217
#> IA 2  19.23447 9064.000     48       0.483       0.302
#> Final 24.19069 9064.000     69       0.401       0.401
#> Accrual rates:
#>      Stratum 1
#> 0-16     566.5
#> Control event rates (H1):
#>       Stratum 1
#> 0-Inf         0
#> Censoring rates:
#>       Stratum 1
#> 0-Inf         0
```

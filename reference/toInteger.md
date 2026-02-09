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
#> Group sequential design (method=; k=3 analyses; Two-sided asymmetric with non-binding futility)
#> N=9064.0 subjects | D=69.0 events | T=24.2 study duration | accrual=16.0 Accrual duration | minfup=8.2 minimum follow-up | ratio=3 randomization ratio (experimental/control)
#> 
#> Spending functions:
#>   Efficacy bounds derived using a Hwang-Shih-DeCani spending function with gamma = -4.
#>   Futility bounds derived using a Lan-DeMets O'Brien-Fleming approximation spending function (no parameters).
#> 
#> Analysis summary:
#>    Analysis              Value Efficacy Futility
#>   IA 1: 45%                  Z   2.8273   0.0695
#>     N: 8626        p (1-sided)   0.0023   0.4723
#>  Events: 31       ~HR at bound   0.2167   0.6801
#>   Month: 15 P(Cross) if HR=0.7   0.0023   0.5277
#>             P(Cross) if HR=0.3   0.2863   0.0141
#>   IA 2: 70%                  Z   2.5197   1.1139
#>     N: 9064        p (1-sided)   0.0059   0.1327
#>  Events: 48       ~HR at bound   0.3022   0.4829
#>   Month: 19 P(Cross) if HR=0.7   0.0071   0.8716
#>             P(Cross) if HR=0.3   0.6265   0.0486
#>       Final                  Z   2.0035   2.0035
#>     N: 9064        p (1-sided)   0.0226   0.0226
#>  Events: 69       ~HR at bound   0.4010   0.4010
#>   Month: 24 P(Cross) if HR=0.7   0.0230   0.9770
#>             P(Cross) if HR=0.3   0.9027   0.0973
#> 
#> Key inputs (names preserved):
#>                                desc    item value   input
#>                     Accrual rate(s)   gamma 566.5   gamma
#>            Accrual rate duration(s)       R    16       R
#>              Control hazard rate(s) lambdaC 0.001 lambdaC
#>             Control dropout rate(s)     eta     0     eta
#>        Experimental dropout rate(s)    etaE     0    etaE
#>  Event and dropout rate duration(s)       S  NULL       S
```

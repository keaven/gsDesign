# Integer sample size and event counts

## Introduction

The **gsDesign** package was originally designed to have continuous
sample size planned rather than integer-based sample size. Designs with
time-to-event outcomes also had non-integer event counts at times of
analysis. This vignette documents the capability to convert to integer
sample sizes and event counts. This has a couple of implications on
design characteristics:

- Information fraction on output will not be exactly as input due to
  rounding.
- Power on output will not be exactly as input.

This document goes through examples to demonstrate the calculations. The
new function as of July 2023 is the
[`toInteger()`](https://keaven.github.io/gsDesign/reference/toInteger.md)
which operates on group sequential designs to convert to integer-based
total sample size and event counts at analyses. As of November 2024, the
rounding defaults are changing as documented below. We begin with a
summary of the method. Then we provide an abbreviated example for a
time-to-event endpoint design to demonstrate basic concepts. We follow
with a more extended example for a binary endpoint to explain more
details.

## Summary of method

``` r
library(gsDesign)
```

``` r
x <- gsSurv(ratio = 1, hr = .74)
y <- x |> toInteger()
# Continuous event counts
x$n.I
```

    ## [1] 165.0263 330.0526 495.0789

``` r
# Rounded event counts at interims, rounded up at final analysis
y$n.I
```

    ## [1] 165 330 496

``` r
# Continuous sample size at interim and final analyses
as.numeric(x$eNE + x$eNC)
```

    ## [1] 510.9167 730.7015 730.7015

``` r
# Rounded up to even final sample size given that x$ratio = 1
# and rounding to multiple of x$ratio + 1
as.numeric(y$eNE + y$eNC)
```

    ## [1] 511.2601 732.0000 732.0000

``` r
# With roundUpFinal = FALSE, final sample size rounded to nearest integer
z <- x |> toInteger(roundUpFinal = FALSE)
as.numeric(z$eNE + z$eNC)
```

    ## [1] 510.6594 730.0000 730.0000

- When `ratio` is a positive integer, the final sample size is rounded
  to a multiple of `ratio + 1`.
  - For 1:1 randomization (experimental:control), set `ratio = 1` to
    round to an even sample size.
  - For 2:1 randomization, set `ratio = 2` to round to a multiple of 3.
  - For 3:2 randomization, set `ratio = 4` to round to a multiple of 5.
  - Note that for the final analysis the sample size is rounded up to
    the nearest multiple of `ratio + 1` when `roundUpFinal = TRUE` is
    specified. If `roundUpFinal = FALSE`, the final sample size is
    rounded to the nearest multiple of `ratio + 1`.

## Binomial endpoint designs

### Fixed sample size

We present a simple example based on comparing binomial rates with
interim analyses after 50% and 75% of events. We assume a 2:1
experimental:control randomization ratio. Note that the sample size is
not an integer. We target 80% power (`beta = .2`).

``` r
n.fix <- nBinomial(p1 = .2, p2 = .1, alpha = .025, beta = .2, ratio = 2)
n.fix
```

    ## [1] 429.8846

If we replace the `beta` argument above with a integer sample size that
is a multiple of 3 so that we get the desired 2:1 integer sample sizes
per arm (432 = 144 control + 288 experimental targeted) we get slightly
larger than the targeted 80% power:

``` r
nBinomial(p1 = .2, p2 = .1, alpha = .025, n = 432, ratio = 2)
```

    ## [1] 0.801814

### 1-sided design

Now we convert the fixed sample size `n.fix` from above to a 1-sided
group sequential design with interims after 50% and 75% of observations.
Again, sample size at each analysis is not an integer. We use the
Lan-DeMets spending function approximating an O’Brien-Fleming efficacy
bound.

``` r
# 1-sided design (efficacy bound only; test.type = 1)
xb <- gsDesign(alpha = .025, beta = .2, n.fix = n.fix, test.type = 1, sfu = sfLDOF, timing = c(.5, .75))
# Continuous sample size (non-integer) at planned analyses
xb$n.I
```

    ## [1] 219.1621 328.7432 438.3243

Next we convert to integer sample sizes at each analysis. Interim sample
sizes are rounded to the nearest integer. The default
`roundUpFinal = TRUE` rounds the final sample size to the nearest
integer to 1 + the experimental:control randomization ratio. Thus, the
final sample size of 441 below is a multiple of 3.

``` r
# Convert to integer sample size with even multiple of ratio + 1
# i.e., multiple of 3 in this case at final analysis
x_integer <- toInteger(xb, ratio = 2)
x_integer$n.I
```

    ## [1] 219 329 441

Next we examine the efficacy bound of the 2 designs as they are slightly
different.

``` r
# Bound for continuous sample size design
xb$upper$bound
```

    ## [1] 2.962588 2.359018 2.014084

``` r
# Bound for integer sample size design
x_integer$upper$bound
```

    ## [1] 2.974067 2.366106 2.012987

The differences are associated with slightly different timing of the
analyses associated with the different sample sizes noted above:

``` r
# Continuous design sample size fractions at analyses
xb$timing
```

    ## [1] 0.50 0.75 1.00

``` r
# Integer design sample size fractions at analyses
x_integer$timing
```

    ## [1] 0.4965986 0.7460317 1.0000000

These differences also make a difference in the cumulative Type I error
associated with each analysis as shown below.

``` r
# Continuous sample size design
cumsum(xb$upper$prob[, 1])
```

    ## [1] 0.001525323 0.009649325 0.025000000

``` r
# Specified spending based on the spending function
xb$upper$sf(alpha = xb$alpha, t = xb$timing, xb$upper$param)$spend
```

    ## [1] 0.001525323 0.009649325 0.025000000

``` r
# Integer sample size design
cumsum(x_integer$upper$prob[, 1])
```

    ## [1] 0.001469404 0.009458454 0.025000000

``` r
# Specified spending based on the spending function
# Slightly different from continuous design due to slightly different information fraction
x$upper$sf(alpha = x_integer$alpha, t = x_integer$timing, x_integer$upper$param)$spend
```

    ## [1] 0.01547975 0.02079331 0.02500000

Finally, we look at cumulative boundary crossing probabilities under the
alternate hypothesis for each design. Due to rounding up the final
sample size, the integer-based design has slightly higher total power
than the specified 80% (Type II error `beta = 0.2.`). Interim power is
slightly lower for the integer-based design since sample size is rounded
to the nearest integer rather than rounded up as at the final analysis.

``` r
# Cumulative upper boundary crossing probability under alternate by analysis
# under alternate hypothesis for continuous sample size
cumsum(xb$upper$prob[, 2])
```

    ## [1] 0.1679704 0.5399906 0.8000000

``` r
# Same for integer sample sizes at each analysis
cumsum(x_integer$upper$prob[, 2])
```

    ## [1] 0.1649201 0.5374791 0.8025140

### Non-binding design

The default `test.type = 4` has a non-binding futility bound. We examine
behavior of this design next. The futility bound is moderately
aggressive and, thus, there is a compensatory increase in sample size to
retain power. The parameter `delta1` is the natural parameter denoting
the difference in response (or failure) rates of 0.2 vs. 0.1 that was
specified in the call to
[`nBinomial()`](https://keaven.github.io/gsDesign/reference/varBinomial.md)
above.

``` r
# 2-sided asymmetric design with non-binding futility bound (test.type = 4)
xnb <- gsDesign(
  alpha = .025, beta = .2, n.fix = n.fix, test.type = 4,
  sfu = sfLDOF, sfl = sfHSD, sflpar = -2,
  timing = c(.5, .75), delta1 = .1
)
# Continuous sample size for non-binding design
xnb$n.I
```

    ## [1] 231.9610 347.9415 463.9219

As before, we convert to integer sample sizes at each analysis and see
the slight deviations from the interim timing of 0.5 and 0.75.

``` r
xnbi <- toInteger(xnb, ratio = 2)
# Integer design sample size at each analysis
xnbi$n.I
```

    ## [1] 232 348 465

``` r
# Information fraction based on integer sample sizes
xnbi$timing
```

    ## [1] 0.4989247 0.7483871 1.0000000

These differences also make a difference in the Type I error associated
with each analysis

``` r
# Type I error, continuous design
cumsum(xnb$upper$prob[, 1])
```

    ## [1] 0.001525323 0.009630324 0.023013764

``` r
# Type I error, integer design
cumsum(xnbi$upper$prob[, 1])
```

    ## [1] 0.001507499 0.009553042 0.022999870

The Type I error ignoring the futility bounds just shown does not use
the full targeted 0.025 as the calculations assume the trial stops for
futility if an interim futility bound is crossed. The non-binding Type I
error assuming the trial does not stop for futility is:

``` r
# Type I error for integer design ignoring futility bound
cumsum(xnbi$falseposnb)
```

    ## [1] 0.001507499 0.009571518 0.025000000

Finally, we look at cumulative lower boundary crossing probabilities
under the alternate hypothesis for the integer-based design and compare
to the planned \\\beta\\-spending. We note that the final Type II error
spending is slightly lower than the targeted 0.2 due to rounding up the
final sample size.

``` r
# Actual cumulative beta spent at each analysis
cumsum(xnbi$lower$prob[, 2])
```

    ## [1] 0.05360549 0.10853733 0.19921266

``` r
# Spending function target is the same at interims, but larger at final
xnbi$lower$sf(alpha = xnbi$beta, t = xnbi$n.I / max(xnbi$n.I), param = xnbi$lower$param)$spend
```

    ## [1] 0.05360549 0.10853733 0.20000000

The \\\beta\\-spending lower than 0.2 in the first row above is due to
the final sample size powering the trial to greater than 0.8 as seen
below.

``` r
# beta-spending
sum(xnbi$upper$prob[, 2])
```

    ## [1] 0.8007874

## References

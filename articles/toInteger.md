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

This document goes through examples to demonstrate the calculations. We
begin with a summary of the current method, then use binomial endpoint
designs to introduce the basic sample-size rounding behavior. The final
section covers time-to-event designs, where event counts and enrollment
are both converted to integer-compatible plans.

## Summary of method

``` r

library(gsDesign)
```

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
- For a `gsSurv` object, `n.I` is an event-count schedule rather than a
  sample-size schedule. Interim event counts are rounded to the nearest
  integer, while the final event count is rounded up when
  `roundUpFinal = TRUE`.
- Survival-design sample size is rounded separately to an
  allocation-compatible total sample size. In seasonal or piecewise
  event-rate designs,
  [`toInteger()`](https://keaven.github.io/gsDesign/reference/toInteger.md)
  may adjust that rounded sample size by allocation multiples, with a
  warning, when needed to make the final integer event target
  achievable. See
  [`vignette("MultiSeasonRareEvents", package = "gsDesign")`](https://keaven.github.io/gsDesign/articles/MultiSeasonRareEvents.md)
  for a complete seasonal exact-binomial monitoring workflow.

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

If we replace the `beta` argument above with an integer sample size that
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
x_integer$upper$sf(alpha = x_integer$alpha, t = x_integer$timing, x_integer$upper$param)$spend
```

    ## [1] 0.001469404 0.009458454 0.025000000

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

## Time-to-event endpoint designs

For a `gsSurv` object, `n.I` is the event-count schedule. The
[`toInteger()`](https://keaven.github.io/gsDesign/reference/toInteger.md)
algorithm first converts event counts to integers. Interim event counts
are rounded to the nearest integer. The final event count is rounded up
when `roundUpFinal = TRUE`; otherwise, it is rounded to the nearest
integer. Values within 0.01 of an integer are rounded to that integer,
and the resulting sequence is forced to be positive and strictly
increasing. The group sequential design is then recomputed with
[`gsDesign()`](https://keaven.github.io/gsDesign/reference/gsDesign.md)
at the integer event counts so the bounds, information fractions, and
crossing probabilities reflect the integer schedule.

Total sample size is handled separately. The final expected enrollment
is rounded to a multiple of `ratio + 1`, rounded up by default or to the
nearest multiple if `roundUpFinal = FALSE`. Enrollment rates are scaled
to achieve that rounded sample size over the original calendar plan. If
that normally rounded sample size cannot support the final integer event
target,
[`toInteger()`](https://keaven.github.io/gsDesign/reference/toInteger.md)
increases or decreases the final sample size by allocation multiples
until the event target is achievable, with a warning. Finally, the
survival quantities are rebuilt: the final analysis time is solved to
match the final integer event target, and the interim calendar times are
solved to match the integer-design information fractions.

``` r

x <- gsSurv(ratio = 1, hr = .74)
y <- x |> toInteger()
# Continuous event counts
x$n.I
```

    ## [1] 165.0263 330.0526 495.0789

``` r

# Event counts converted to integers
y$n.I
```

    ## [1] 165 331 496

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

    ## [1] 512.6326 734.0000 734.0000

``` r

# With roundUpFinal = FALSE, final sample size rounded to nearest integer
z <- x |> toInteger(roundUpFinal = FALSE)
as.numeric(z$eNE + z$eNC)
```

    ## [1] 511.8246 732.0000 732.0000

### Seasonal design with a final zero event-rate period

Seasonal rare-event designs often use piecewise event rates with nonzero
rates during seasons and zero rates outside seasons. The example below
has three 6-month seasons separated by off-season zero event-rate
periods; the final piecewise event-rate period is zero. This is the
setting where it is especially important that `roundUpFinal = TRUE`
applies to the final event count. For a complete seasonal exact-binomial
monitoring workflow, see
[`vignette("MultiSeasonRareEvents", package = "gsDesign")`](https://keaven.github.io/gsDesign/articles/MultiSeasonRareEvents.md).

``` r

seasonal_event_rate_control <- 0.003
season_length <- 0.5
dropout_6mo <- 0.10

season_rate <- -log(1 - seasonal_event_rate_control) / season_length
dropout_rate <- -log(1 - dropout_6mo) / season_length

seasonal_design <- gsSurv(
  k = 3,
  test.type = 4,
  alpha = 0.025,
  beta = 0.1,
  timing = c(1 / 3, 2 / 3),
  sfu = sfHSD,
  sfupar = 1,
  sfl = sfHSD,
  sflpar = -2,
  lambdaC = c(season_rate, 0, season_rate, 0, season_rate, 0),
  S = c(6, 6, 6, 6, 6),
  hr = 0.2,
  hr0 = 0.7,
  eta = dropout_rate,
  gamma = c(1, 0, 1, 0, 1, 0),
  R = c(2, 10, 2, 10, 2, 10),
  T = 42,
  minfup = 6,
  ratio = 3,
  testLower = c(TRUE, FALSE, FALSE)
)

# Continuous event targets and expected enrollment before integer conversion
seasonal_design$n.I
```

    ## [1] 11.67361 23.34721 35.02082

``` r

rowSums(seasonal_design$eNC + seasonal_design$eNE)
```

    ## [1] 2023.714 3362.740 4004.492

``` r

seasonal_design$T
```

    ## [1] 13.03217 25.03845 42.00000

The final continuous event target is just under 36 events, so with the
default `roundUpFinal = TRUE` the integer event target is 36. The final
expected sample size is just over 4099, which rounds up to 4100 for 3:1
randomization. For this design, the rounded sample size supports the
rounded-up final event target, so no sample-size feasibility warning is
needed. The final analysis time moves later because the rounded-up event
target requires additional follow-up under the late zero event-rate
period.

``` r

seasonal_integer <- toInteger(seasonal_design)

data.frame(
  analysis = seq_len(seasonal_design$k),
  continuous_events = round(seasonal_design$n.I, 3),
  integer_events = seasonal_integer$n.I,
  continuous_time = round(seasonal_design$T, 3),
  integer_time = round(seasonal_integer$T, 3),
  integer_enrollment = round(rowSums(seasonal_integer$eNC + seasonal_integer$eNE), 3)
)
```

    ##   analysis continuous_events integer_events continuous_time integer_time
    ## 1        1            11.674             12          13.032       13.032
    ## 2        2            23.347             24          25.038       25.038
    ## 3        3            35.021             36          42.000       42.000
    ##   integer_enrollment
    ## 1           2080.066
    ## 2           3456.378
    ## 3           4116.000

``` r

# Final integer sample size remains a multiple of ratio + 1.
rowSums(seasonal_integer$eNC + seasonal_integer$eNE)[seasonal_integer$k]
```

    ## [1] 4116

The important point is that final event-count rounding is not
interchangeable with final sample-size rounding. Integer event targets
define the information schedule; the enrollment plan and analysis times
are then adjusted only as much as needed to keep those integer event
targets attainable under the piecewise event-rate model.

The feasibility adjustment is easier to see in a rare-event design where
the rounded-up event target is too high for the initially rounded sample
size. In the next example, the final event target rounds up to 43, but
the rounded final sample size of 5038 cannot ever produce that many
expected events.
[`toInteger()`](https://keaven.github.io/gsDesign/reference/toInteger.md)
increases final sample size by allocation multiples and warns.

``` r

rare_design <- gsSurv(
  k = 3,
  test.type = 4,
  alpha = 0.025,
  beta = 0.1,
  timing = c(1 / 3, 2 / 3),
  sfu = sfHSD,
  sfupar = 1,
  sfl = sfHSD,
  sflpar = -2,
  lambdaC = -log(1 - 0.0015) / 0.5,
  hr = 0.2,
  hr0 = 0.7,
  eta = dropout_rate,
  gamma = c(1, 0, 1, 0, 1, 0),
  R = c(2, 10, 2, 10, 2, 10),
  T = 42,
  minfup = 6,
  ratio = 1
)

rare_integer <- toInteger(rare_design)

data.frame(
  continuous_final_events = rare_design$n.I[rare_design$k],
  integer_final_events = rare_integer$n.I[rare_integer$k],
  continuous_final_enrollment = rowSums(rare_design$eNC + rare_design$eNE)[rare_design$k],
  integer_final_enrollment = rowSums(rare_integer$eNC + rare_integer$eNE)[rare_integer$k]
)
```

    ##   continuous_final_events integer_final_events continuous_final_enrollment
    ## 1                42.12931                   43                    5037.812
    ##   integer_final_enrollment
    ## 1                     5142

## References

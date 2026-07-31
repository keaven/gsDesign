# Planning enrollment and follow-up for survival designs

## Overview

Survival trial planning connects three time quantities:

- enrollment duration;
- minimum follow-up after the last participant enrolls; and
- total study duration.

The identity is

``` text
total study duration = enrollment duration + minimum follow-up.
```

[`gsSurv()`](https://keaven.github.io/gsDesign/reference/nSurv.md) can
solve one component of this plan while deriving a powered group
sequential design.
[`gsSurvCalendar()`](https://keaven.github.io/gsDesign/reference/gsSurvCalendar.md)
uses the same enrollment model but fixes analysis times on the calendar.
[`gsSurvPower()`](https://keaven.github.io/gsDesign/reference/gsSurvPower.md)
answers the reverse question: given a fixed operational plan, what power
will it achieve? Finally,
[`toInteger()`](https://keaven.github.io/gsDesign/reference/toInteger.md)
converts continuous expected events and enrollment to an
integer-compatible plan.

``` r

library(gsDesign)

lambdaC <- log(2) / 12
hr <- 0.7

# Four enrollment periods with equal relative rate increments.
gamma_ramp <- 1:4
R_ramp <- rep(1, 4)
```

Every `nSurv` object contains identical scalar values `n` and `N` for
total expected enrollment. Every `gsSurv` object contains `N` as a
vector of cumulative total expected enrollment at each analysis. It is
the row total of the control and experimental enrollment components:

``` r

x$N == rowSums(x$eNC) + rowSums(x$eNE)
```

## Pattern 1: fix study duration and minimum follow-up

This is the most common planning pattern. Specifying `T` and `minfup`
fixes the enrollment duration at `T - minfup`. The values in `gamma`
describe the relative ramp-up shape;
[`gsSurv()`](https://keaven.github.io/gsDesign/reference/nSurv.md)
scales all rates proportionally to power the trial. When the supplied
`R` periods do not fill the enrollment duration, the last period is
extended.

``` r

fixed_duration <- gsSurv(
  k = 3,
  lambdaC = lambdaC,
  hr = hr,
  T = 26,
  minfup = 12,
  gamma = gamma_ramp,
  R = R_ramp
)

data.frame(
  period = seq_along(fixed_duration$R),
  duration = fixed_duration$R,
  rate = as.vector(fixed_duration$gamma)
)
#>   period duration     rate
#> 1      1        1 12.16013
#> 2      2        1 24.32026
#> 3      3        1 36.48039
#> 4      4       11 48.64053

fixed_duration$N
#> [1] 524.8498 608.0066 608.0066
```

Here enrollment lasts 14 months. The first three ramp-up periods last
one month each and the fourth rate continues through the remaining 11
months.

## Pattern 2: fix rates and minimum follow-up

Set `T = NULL` to keep `gamma` fixed and solve how long enrollment must
remain open. The final `R` period is extended to obtain the required
sample size; the earlier ramp-up periods are unchanged.

``` r

fixed_rates <- gsSurv(
  k = 3,
  lambdaC = lambdaC,
  hr = hr,
  T = NULL,
  minfup = 12,
  gamma = gamma_ramp,
  R = R_ramp
)

data.frame(
  period = seq_along(fixed_rates$R),
  duration = fixed_rates$R,
  rate = as.vector(fixed_rates$gamma)
)
#>   period duration rate
#> 1      1  1.00000    1
#> 2      2  1.00000    2
#> 3      3  1.00000    3
#> 4      4 98.34222    4

c(
  enrollment_duration = sum(fixed_rates$R),
  minimum_follow_up = fixed_rates$minfup,
  total_duration = max(fixed_rates$T)
)
#> enrollment_duration   minimum_follow_up      total_duration 
#>            101.3422             12.0000            113.3422
```

Absolute rates of 1, 2, 3, and 4 participants per month are deliberately
low, so this example produces a long enrollment duration. In practice,
multiply the ramp by realistic site-level or program-level rates.

## Pattern 3: fix enrollment and solve follow-up

With both `T = NULL` and `minfup = NULL`, enrollment rates and their
durations are fixed.
[`gsSurv()`](https://keaven.github.io/gsDesign/reference/nSurv.md)
solves the follow-up duration needed to power the trial. This option can
fail when the fixed enrollment plan is over-powered even with almost no
follow-up, or under-powered regardless of follow-up.

``` r

fixed_enrollment <- gsSurv(
  k = 3,
  lambdaC = lambdaC,
  hr = hr,
  T = NULL,
  minfup = NULL,
  gamma = 50 * gamma_ramp,
  R = R_ramp
)

c(
  enrollment_duration = sum(fixed_enrollment$R),
  minimum_follow_up = fixed_enrollment$minfup,
  total_duration = max(fixed_enrollment$T)
)
#> enrollment_duration   minimum_follow_up      total_duration 
#>             4.00000            23.87818            27.87818
```

When this solve is infeasible, revise the fixed enrollment plan, target
power, or event assumptions rather than interpreting the error as a
numerical failure.

## Calendar-time analyses

Use
[`gsSurvCalendar()`](https://keaven.github.io/gsDesign/reference/gsSurvCalendar.md)
when interim analyses are specified as months from the start of
enrollment. The final calendar time and `minfup` imply the enrollment
duration, while the four-period ramp-up is scaled to power the trial.

``` r

calendar_design <- gsSurvCalendar(
  calendarTime = c(12, 18, 26),
  lambdaC = lambdaC,
  hr = hr,
  minfup = 12,
  gamma = gamma_ramp,
  R = R_ramp
)

data.frame(
  analysis_month = calendar_design$T,
  expected_events = calendar_design$n.I,
  expected_enrollment = calendar_design$N
)
#>   analysis_month expected_events expected_enrollment
#> 1             12        111.9795            510.3446
#> 2             18        233.6376            607.5531
#> 3             26        353.0288            607.5531
```

Use [`gsSurv()`](https://keaven.github.io/gsDesign/reference/nSurv.md)
instead when analyses are defined by event or information fractions
rather than calendar dates.

## Power for a fixed operational plan

[`gsSurvPower()`](https://keaven.github.io/gsDesign/reference/gsSurvPower.md)
does not resize enrollment to hit target power. It evaluates power for
the supplied rates, durations, treatment effect, and analysis timing.
For example, the following sensitivity analysis evaluates 80% of the
planned enrollment rates at the original calendar analysis times.

``` r

slower_enrollment <- gsSurvPower(
  x = fixed_duration,
  gamma = 0.8 * fixed_duration$gamma,
  plannedCalendarTime = fixed_duration$T
)

c(
  planned_power = 1 - fixed_duration$beta,
  slower_enrollment_power = slower_enrollment$power
)
#>           planned_power slower_enrollment_power 
#>               0.9000000               0.8265161
```

Use `targetEvents = fixed_duration$n.I` instead of `plannedCalendarTime`
when event counts, rather than dates, remain fixed and the analysis
dates may move.

## Integer event and enrollment plans

Design calculations use expected counts and can therefore be
non-integer. Apply
[`toInteger()`](https://keaven.github.io/gsDesign/reference/toInteger.md)
after deriving the design to obtain integer event targets and a final
total enrollment compatible with the randomization allocation.

``` r

integer_design <- toInteger(fixed_duration)

data.frame(
  analysis = seq_len(integer_design$k),
  events = integer_design$n.I,
  enrollment = integer_design$N
)
#>   analysis events enrollment
#> 1        1    118   526.5706
#> 2        2    236   610.0000
#> 3        3    354   610.0000
```

The input `ratio` is experimental-to-control randomization. For example,
`ratio = 1` produces allocation-compatible even totals; `ratio = 2`
produces totals compatible with 2:1 randomization.

## Stratified enrollment

For a stratified design, matrix columns identify strata. Align the
columns of the control hazards, dropout rates, and enrollment rates. The
example below uses two strata with different control medians and
enrollment contributions.

``` r

lambda_strata <- matrix(log(2) / c(10, 16), nrow = 1)
gamma_strata <- cbind(
  0.6 * gamma_ramp,
  0.4 * gamma_ramp
)

stratified_design <- gsSurv(
  k = 3,
  lambdaC = lambda_strata,
  hr = hr,
  eta = matrix(c(0.001, 0.001), nrow = 1),
  T = 26,
  minfup = 12,
  gamma = gamma_strata,
  R = R_ramp
)

data.frame(
  analysis = seq_len(stratified_design$k),
  control = rowSums(stratified_design$eNC),
  experimental = rowSums(stratified_design$eNE),
  total = stratified_design$N
)
#>   analysis  control experimental    total
#> 1        1 262.5933     262.5933 525.1867
#> 2        2 306.8094     306.8094 613.6188
#> 3        3 306.8094     306.8094 613.6188
```

The same matrix conventions apply to
[`gsSurvCalendar()`](https://keaven.github.io/gsDesign/reference/gsSurvCalendar.md)
and
[`gsSurvPower()`](https://keaven.github.io/gsDesign/reference/gsSurvPower.md).
For final operational planning, inspect both `N` and the
stratum-specific `eNC` and `eNE` matrices before applying
[`toInteger()`](https://keaven.github.io/gsDesign/reference/toInteger.md).

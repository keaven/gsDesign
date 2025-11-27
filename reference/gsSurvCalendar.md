# Time-to-event endpoint design with calendar timing of analyses

Time-to-event endpoint design with calendar timing of analyses

## Usage

``` r
gsSurvCalendar(
  test.type = 4,
  alpha = 0.025,
  sided = 1,
  beta = 0.1,
  astar = 0,
  sfu = gsDesign::sfHSD,
  sfupar = -4,
  sfl = gsDesign::sfHSD,
  sflpar = -2,
  calendarTime = c(12, 24, 36),
  spending = c("information", "calendar"),
  lambdaC = log(2)/6,
  hr = 0.6,
  hr0 = 1,
  eta = 0,
  etaE = NULL,
  gamma = 1,
  R = 12,
  S = NULL,
  minfup = 18,
  ratio = 1,
  r = 18,
  tol = 1e-06
)
```

## Arguments

- test.type:

  Test type. See
  [`gsSurv`](https://keaven.github.io/gsDesign/reference/nSurv.md).

- alpha:

  Type I error rate. Default is 0.025 since 1-sided testing is default.

- sided:

  `1` for 1-sided testing, `2` for 2-sided testing.

- beta:

  Type II error rate. Default is 0.10 (90% power); `NULL` if power is to
  be computed based on other input values.

- astar:

  Normally not specified. If `test.type = 5` or `6`, `astar` specifies
  the total probability of crossing a lower bound at all analyses
  combined. This will be changed to `1 - alpha` when default value of
  `0` is used. Since this is the expected usage, normally `astar` is not
  specified by the user.

- sfu:

  A spending function or a character string indicating a boundary type
  (that is, `"WT"` for Wang-Tsiatis bounds, `"OF"` for O'Brien-Fleming
  bounds and `"Pocock"` for Pocock bounds). For one-sided and symmetric
  two-sided testing is used to completely specify spending
  (`test.type = 1`, `2`), `sfu`. The default value is `sfHSD` which is a
  Hwang-Shih-DeCani spending function.

- sfupar:

  Real value, default is `-4` which is an O'Brien-Fleming-like
  conservative bound when used with the default Hwang-Shih-DeCani
  spending function. This is a real-vector for many spending functions.
  The parameter `sfupar` specifies any parameters needed for the
  spending function specified by `sfu`; this will be ignored for
  spending functions (`sfLDOF`, `sfLDPocock`) or bound types (`"OF"`,
  `"Pocock"`) that do not require parameters.

- sfl:

  Specifies the spending function for lower boundary crossing
  probabilities when asymmetric, two-sided testing is performed
  (`test.type = 3`, `4`, `5`, or `6`). Unlike the upper bound, only
  spending functions are used to specify the lower bound. The default
  value is `sfHSD` which is a Hwang-Shih-DeCani spending function. The
  parameter `sfl` is ignored for one-sided testing (`test.type = 1`) or
  symmetric 2-sided testing (`test.type = 2`).

- sflpar:

  Real value, default is `-2`, which, with the default Hwang-Shih-DeCani
  spending function, specifies a less conservative spending rate than
  the default for the upper bound.

- calendarTime:

  Vector of increasing positive numbers with calendar times of analyses.
  Time 0 is start of randomization.

- spending:

  Select between calendar-based spending and information-based spending.

- lambdaC:

  Scalar, vector or matrix of event hazard rates for the control group;
  rows represent time periods while columns represent strata; a vector
  implies a single stratum.

- hr:

  Hazard ratio (experimental/control) under the alternate hypothesis
  (scalar).

- hr0:

  Hazard ratio (experimental/control) under the null hypothesis
  (scalar).

- eta:

  Scalar, vector or matrix of dropout hazard rates for the control
  group; rows represent time periods while columns represent strata; if
  entered as a scalar, rate is constant across strata and time periods;
  if entered as a vector, rates are constant across strata.

- etaE:

  Matrix dropout hazard rates for the experimental group specified in
  like form as `eta`; if `NULL`, this is set equal to `eta`.

- gamma:

  A scalar, vector or matrix of rates of entry by time period (rows) and
  strata (columns); if entered as a scalar, rate is constant across
  strata and time periods; if entered as a vector, rates are constant
  across strata.

- R:

  A scalar or vector of durations of time periods for recruitment rates
  specified in rows of `gamma`. Length is the same as number of rows in
  `gamma`. Note that when variable enrollment duration is specified
  (input `T = NULL`), the final enrollment period is extended as long as
  needed.

- S:

  A scalar or vector of durations of piecewise constant event rates
  specified in rows of `lambda`, `eta` and `etaE`; this is `NULL` if
  there is a single event rate per stratum (exponential failure) or
  length of the number of rows in `lambda` minus 1, otherwise.

- minfup:

  A non-negative scalar less than the maximum value in `calendarTime`.
  Enrollment will be cut off at the difference between the maximum value
  in `calendarTime` and `minfup`.

- ratio:

  Randomization ratio of experimental treatment divided by control;
  normally a scalar, but may be a vector with length equal to number of
  strata.

- r:

  Integer value (\>= 1 and \<= 80) controlling the number of numerical
  integration grid points. Default is 18, as recommended by Jennison and
  Turnbull (2000). Grid points are spread out in the tails for accurate
  probability calculations. Larger values provide more grid points and
  greater accuracy but slow down computation. Jennison and Turnbull
  (p. 350) note an accuracy of \\10^{-6}\\ with `r = 16`. This parameter
  is normally not changed by users.

- tol:

  Tolerance for error passed to the
  [`gsDesign`](https://keaven.github.io/gsDesign/reference/gsDesign.md)
  function.

## Examples

``` r
# First example: while timing is calendar-based, spending is event-based
x <- gsSurvCalendar() %>% toInteger()
gsBoundSummary(x)
#>     Analysis              Value Efficacy Futility
#>    IA 1: 29%                  Z   3.0856  -0.4349
#>       N: 130        p (1-sided)   0.0010   0.6682
#>   Events: 50       ~HR at bound   0.4178   1.1309
#>    Month: 12   P(Cross) if HR=1   0.0010   0.3318
#>              P(Cross) if HR=0.6   0.1018   0.0122
#>    IA 2: 79%                  Z   2.3279   1.3991
#>       N: 194        p (1-sided)   0.0100   0.0809
#>  Events: 137       ~HR at bound   0.6718   0.7874
#>    Month: 24   P(Cross) if HR=1   0.0106   0.9213
#>              P(Cross) if HR=0.6   0.7505   0.0606
#>        Final                  Z   2.0154   2.0154
#>       N: 194        p (1-sided)   0.0219   0.0219
#>  Events: 173       ~HR at bound   0.7361   0.7361
#>    Month: 36   P(Cross) if HR=1   0.0228   0.9772
#>              P(Cross) if HR=0.6   0.9001   0.0999

# Second example: both timing and spending are calendar-based
# This results in less spending at interims and leaves more for final analysis
y <- gsSurvCalendar(spending = "calendar") %>% toInteger()
gsBoundSummary(y)
#>     Analysis              Value Efficacy Futility
#>    IA 1: 29%                  Z   3.0107  -0.3784
#>       N: 126        p (1-sided)   0.0013   0.6474
#>   Events: 49       ~HR at bound   0.4231   1.1142
#>    Month: 12   P(Cross) if HR=1   0.0013   0.3526
#>              P(Cross) if HR=0.6   0.1123   0.0148
#>    IA 2: 79%                  Z   2.5581   1.1380
#>       N: 188        p (1-sided)   0.0053   0.1276
#>  Events: 133       ~HR at bound   0.6417   0.8209
#>    Month: 24   P(Cross) if HR=1   0.0062   0.8785
#>              P(Cross) if HR=0.6   0.6593   0.0437
#>        Final                  Z   1.9854   1.9854
#>       N: 188        p (1-sided)   0.0235   0.0235
#>  Events: 168       ~HR at bound   0.7361   0.7361
#>    Month: 36   P(Cross) if HR=1   0.0237   0.9763
#>              P(Cross) if HR=0.6   0.9006   0.0994

# Note that calendar timing for spending relates to planned timing for y
# rather than timing in y after toInteger() conversion

# Values plugged into spending function for calendar time
y$usTime
#> [1] 0.3333333 0.6666667 1.0000000
# Actual calendar fraction from design after toInteger() conversion
y$T / max(y$T)
#> [1] 0.3317245 0.6637292 1.0000000
```

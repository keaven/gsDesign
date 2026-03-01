# Group sequential design with calendar-based timing of analyses

This is like
[`gsSurv()`](https://keaven.github.io/gsDesign/reference/nSurv.md), but
the timing of analyses is specified in calendar time units. Information
fraction is computed from the input rates and the calendar times.
Spending can be based on information fraction as in Lan and DeMets
(1983) or calendar time units as in Lan and DeMets (1989).

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
  sfharm = gsDesign::sfHSD,
  sfharmparam = -2,
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
  tol = .Machine$double.eps^0.25,
  testUpper = TRUE,
  testLower = TRUE,
  testHarm = TRUE,
  method = c("LachinFoulkes", "Schoenfeld", "Freedman", "BernsteinLagakos")
)
```

## Arguments

- test.type:

  `1=`one-sided  
  `2=`two-sided symmetric  
  `3=`two-sided, asymmetric, beta-spending with binding lower bound  
  `4=`two-sided, asymmetric, beta-spending with non-binding lower
  bound  
  `5=`two-sided, asymmetric, lower bound spending under the null
  hypothesis with binding lower bound  
  `6=`two-sided, asymmetric, lower bound spending under the null
  hypothesis with non-binding lower bound  
  `7=`two-sided, asymmetric, with binding futility and binding harm
  bounds  
  `8=`two-sided, asymmetric, with non-binding futility and non-binding
  harm bounds.  
  See details, examples and manual.

- alpha:

  Type I error rate. Default is 0.025 since 1-sided testing is default.

- sided:

  `1` for 1-sided testing, `2` for 2-sided testing.

- beta:

  Type II error rate. Default is 0.10 (90% power); `NULL` if power is to
  be computed based on other input values.

- astar:

  Total spending for the lower (test.type 5 or 6) or harm (test.type 7
  or 8) bound under the null hypothesis. Default is 0. For `test.type` 5
  or 6, `astar` specifies the total probability of crossing a lower
  bound at all analyses combined. For `test.type` 7 or 8, `astar`
  specifies the total probability of crossing the harm bound at all
  analyses combined under the null hypothesis. If `astar = 0`, it will
  be changed to \\1 - \\`alpha`.

- sfu:

  A spending function or a character string indicating a boundary type
  (that is, “WT” for Wang-Tsiatis bounds, “OF” for O'Brien-Fleming
  bounds and “Pocock” for Pocock bounds). For one-sided and symmetric
  two-sided testing is used to completely specify spending
  (`test.type=1, 2`), `sfu`. The default value is `sfHSD` which is a
  Hwang-Shih-DeCani spending function. See details,
  [`vignette("SpendingFunctionOverview")`](https://keaven.github.io/gsDesign/articles/SpendingFunctionOverview.md),
  manual and examples.

- sfupar:

  Real value, default is \\-4\\ which is an O'Brien-Fleming-like
  conservative bound when used with the default Hwang-Shih-DeCani
  spending function. This is a real-vector for many spending functions.
  The parameter `sfupar` specifies any parameters needed for the
  spending function specified by `sfu`; this is not needed for spending
  functions (`sfLDOF`, `sfLDPocock`) or bound types (“OF”, “Pocock”)
  that do not require parameters. Note that `sfupar` can be specified as
  a positive scalar for `sfLDOF` for a generalized O'Brien-Fleming
  spending function.

- sfl:

  Specifies the spending function for lower boundary crossing
  probabilities when asymmetric, two-sided testing is performed
  (`test.type = 3`, `4`, `5`, or `6`). Unlike the upper bound, only
  spending functions are used to specify the lower bound. The default
  value is `sfHSD` which is a Hwang-Shih-DeCani spending function. The
  parameter `sfl` is ignored for one-sided testing (`test.type=1`) or
  symmetric 2-sided testing (`test.type=2`). See details, spending
  functions, manual and examples.

- sflpar:

  Real value, default is \\-2\\, which, with the default
  Hwang-Shih-DeCani spending function, specifies a less conservative
  spending rate than the default for the upper bound.

- sfharm:

  A spending function for the harm bound, used with `test.type = 7` or
  `test.type = 8`. Default is `sfHSD`. See
  [`spendingFunction`](https://keaven.github.io/gsDesign/reference/spendingFunction.md)
  for details.

- sfharmparam:

  Real value, default is \\-2\\. Parameter for the harm bound spending
  function `sfharm`.

- calendarTime:

  Vector of increasing positive numbers with calendar times of analyses.
  Time 0 is start of randomization.

- spending:

  Select between calendar-based spending and information-based spending.

- lambdaC:

  Scalar, vector or matrix of event hazard rates for the control group;
  rows represent time periods while columns represent strata; a vector
  implies a single stratum. Note that rates corresponding the final time
  period are extended indefinitely.

- hr:

  Hazard ratio (experimental/control) under the alternate hypothesis
  (scalar, \> 0, must differ from `hr0`). Both `hr < hr0` (experimental
  is beneficial when lower hazard is better) and `hr > hr0` (e.g.,
  time-to-response or safety designs) are supported.

- hr0:

  Hazard ratio (experimental/control) under the null hypothesis (scalar,
  \> 0, must differ from `hr`).

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
  length of the number of rows in `lambda` minus 1, otherwise. The final
  time period is extended indefinitely for each stratum.

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

- testUpper:

  Indicator of which analyses should include an upper (efficacy) bound.
  A single value of `TRUE` (default) indicates all analyses have an
  efficacy bound. Otherwise, a logical vector of length `k` indicating
  which analyses will have an efficacy bound. Overridden to all `TRUE`
  for `test.type` 1 and 2. Must be `TRUE` at the final analysis to
  achieve targeted power. At each analysis, at least one of `testUpper`,
  `testLower`, or `testHarm` must be `TRUE`. Where `testUpper` is
  `FALSE`, the upper bound is set to `+20` (effectively `Inf`) and
  displayed as `NA` in output.

- testLower:

  Indicator of which analyses should include a lower (futility) bound. A
  single value of `TRUE` (default) indicates all analyses have a lower
  bound; `FALSE` indicates none. Otherwise, a logical vector of length
  `k`. Ignored for `test.type` 1 (one-sided, no lower bound). Overridden
  to all `TRUE` for `test.type` 2 (symmetric). For `test.type` 3–8, at
  least one analysis must be `TRUE`. Where `testLower` is `FALSE`, the
  lower bound is set to `-20` (effectively `-Inf`) and displayed as `NA`
  in output.

- testHarm:

  Indicator of which analyses should include a harm bound. A single
  value of `TRUE` (default) indicates all analyses have a harm bound;
  `FALSE` indicates none. Otherwise, a logical vector of length `k`.
  Only used for `test.type` 7 or 8; at least one analysis must be `TRUE`
  for those types. Where `testHarm` is `FALSE`, the harm bound is set to
  `-20` (effectively `-Inf`) and displayed as `NA` in output.

- method:

  One of `"LachinFoulkes"` (default), `"Schoenfeld"`, `"Freedman"`, or
  `"BernsteinLagakos"`. Note: `"Schoenfeld"` and `"Freedman"` methods
  only support superiority testing (`hr0 = 1`). `"Freedman"` does not
  support stratified populations.

## References

Lan KKG and DeMets DL (1983), Discrete Sequential Boundaries for
Clinical Trials. *Biometrika*, 70, 659-663.

Lan KKG and DeMets DL (1989), Group Sequential Procedures: Calendar vs.
Information Time. *Statistics in Medicine*, 8, 1191-1198.

Schoenfeld D (1981), The Asymptotic Properties of Nonparametric Tests
for Comparing Survival Distributions. *Biometrika*, 68, 316-319.

Freedman LS (1982), Tables of the Number of Patients Required in
Clinical Trials Using the Logrank Test. *Statistics in Medicine*, 1,
121-129.

## See also

[`gsSurv`](https://keaven.github.io/gsDesign/reference/nSurv.md),
[`gsDesign`](https://keaven.github.io/gsDesign/reference/gsDesign.md),
[`gsBoundSummary`](https://keaven.github.io/gsDesign/reference/gsBoundSummary.md)

## Examples

``` r
# First example: while timing is calendar-based, spending is event-based
x <- gsSurvCalendar() |> toInteger()
gsBoundSummary(x)
#>     Analysis              Value Efficacy Futility
#>    IA 1: 29%                  Z   3.0856  -0.4349
#>       N: 130        p (1-sided)   0.0010   0.6682
#>   Events: 50       ~HR at bound   0.4178   1.1309
#>    Month: 12   P(Cross) if HR=1   0.0010   0.3318
#>              P(Cross) if HR=0.6   0.1018   0.0122
#>    IA 2: 79%                  Z   2.3279   1.3991
#>       N: 196        p (1-sided)   0.0100   0.0809
#>  Events: 137       ~HR at bound   0.6718   0.7874
#>    Month: 24   P(Cross) if HR=1   0.0106   0.9213
#>              P(Cross) if HR=0.6   0.7505   0.0606
#>        Final                  Z   2.0154   2.0154
#>       N: 196        p (1-sided)   0.0219   0.0219
#>  Events: 173       ~HR at bound   0.7361   0.7361
#>    Month: 36   P(Cross) if HR=1   0.0228   0.9772
#>              P(Cross) if HR=0.6   0.9001   0.0999

# Second example: both timing and spending are calendar-based
# This results in less spending at interims and leaves more for final analysis
y <- gsSurvCalendar(spending = "calendar") |> toInteger()
gsBoundSummary(y)
#>     Analysis              Value Efficacy Futility
#>    IA 1: 29%                  Z   3.0107  -0.3784
#>       N: 126        p (1-sided)   0.0013   0.6474
#>   Events: 49       ~HR at bound   0.4231   1.1142
#>    Month: 12   P(Cross) if HR=1   0.0013   0.3526
#>              P(Cross) if HR=0.6   0.1123   0.0148
#>    IA 2: 79%                  Z   2.5581   1.1380
#>       N: 190        p (1-sided)   0.0053   0.1276
#>  Events: 133       ~HR at bound   0.6417   0.8209
#>    Month: 24   P(Cross) if HR=1   0.0062   0.8785
#>              P(Cross) if HR=0.6   0.6593   0.0437
#>        Final                  Z   1.9854   1.9854
#>       N: 190        p (1-sided)   0.0235   0.0235
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
#> [1] 0.3317243 0.6637288 1.0000000
```

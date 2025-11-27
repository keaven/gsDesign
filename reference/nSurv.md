# Advanced time-to-event sample size calculation

`nSurv()` is used to calculate the sample size for a clinical trial with
a time-to-event endpoint and an assumption of proportional hazards. This
set of routines is new with version 2.7 and will continue to be modified
and refined to improve input error checking and output format with
subsequent versions. It allows both the Lachin and Foulkes (1986) method
(fixed trial duration) as well as the Kim and Tsiatis(1990) method
(fixed enrollment rates and either fixed enrollment duration or fixed
minimum follow-up). Piecewise exponential survival is supported as well
as piecewise constant enrollment and dropout rates. The methods are for
a 2-arm trial with treatment groups referred to as experimental and
control. A stratified population is allowed as in Lachin and Foulkes
(1986); this method has been extended to derive non-inferiority as well
as superiority trials. Stratification also allows power calculation for
meta-analyses. `gsSurv()` combines `nSurv()` with
[`gsDesign()`](https://keaven.github.io/gsDesign/reference/gsDesign.md)
to derive a group sequential design for a study with a time-to-event
endpoint.

## Usage

``` r
# S3 method for class 'nSurv'
print(x, digits = 4, ...)

nSurv(
  lambdaC = log(2)/6,
  hr = 0.6,
  hr0 = 1,
  eta = 0,
  etaE = NULL,
  gamma = 1,
  R = 12,
  S = NULL,
  T = 18,
  minfup = 6,
  ratio = 1,
  alpha = 0.025,
  beta = 0.1,
  sided = 1,
  tol = .Machine$double.eps^0.25
)

tEventsIA(x, timing = 0.25, tol = .Machine$double.eps^0.25)

nEventsIA(tIA = 5, x = NULL, target = 0, simple = TRUE)

gsSurv(
  k = 3,
  test.type = 4,
  alpha = 0.025,
  sided = 1,
  beta = 0.1,
  astar = 0,
  timing = 1,
  sfu = sfHSD,
  sfupar = -4,
  sfl = sfHSD,
  sflpar = -2,
  r = 18,
  lambdaC = log(2)/6,
  hr = 0.6,
  hr0 = 1,
  eta = 0,
  etaE = NULL,
  gamma = 1,
  R = 12,
  S = NULL,
  T = 18,
  minfup = 6,
  ratio = 1,
  tol = .Machine$double.eps^0.25,
  usTime = NULL,
  lsTime = NULL
)

# S3 method for class 'gsSurv'
print(x, digits = 2, ...)

# S3 method for class 'gsSurv'
xtable(
  x,
  caption = NULL,
  label = NULL,
  align = NULL,
  digits = NULL,
  display = NULL,
  auto = FALSE,
  footnote = NULL,
  fnwid = "9cm",
  timename = "months",
  ...
)
```

## Arguments

- x:

  An object of class `nSurv` or `gsSurv`. `print.nSurv()` is used for an
  object of class `nSurv` which will generally be output from `nSurv()`.
  For `print.gsSurv()` is used for an object of class `gsSurv` which
  will generally be output from `gsSurv()`. `nEventsIA` and `tEventsIA`
  operate on both the `nSurv` and `gsSurv` class.

- digits:

  Number of digits past the decimal place to print (`print.gsSurv.`);
  also a pass through to generic
  [`xtable()`](https://keaven.github.io/gsDesign/reference/xtable.md)
  from `xtable.gsSurv()`.

- ...:

  other arguments that may be passed to generic functions underlying the
  methods here.

- lambdaC:

  scalar, vector or matrix of event hazard rates for the control group;
  rows represent time periods while columns represent strata; a vector
  implies a single stratum.

- hr:

  hazard ratio (experimental/control) under the alternate hypothesis
  (scalar).

- hr0:

  hazard ratio (experimental/control) under the null hypothesis
  (scalar).

- eta:

  scalar, vector or matrix of dropout hazard rates for the control
  group; rows represent time periods while columns represent strata; if
  entered as a scalar, rate is constant across strata and time periods;
  if entered as a vector, rates are constant across strata.

- etaE:

  matrix dropout hazard rates for the experimental group specified in
  like form as `eta`; if NULL, this is set equal to `eta`.

- gamma:

  a scalar, vector or matrix of rates of entry by time period (rows) and
  strata (columns); if entered as a scalar, rate is constant across
  strata and time periods; if entered as a vector, rates are constant
  across strata.

- R:

  a scalar or vector of durations of time periods for recruitment rates
  specified in rows of `gamma`. Length is the same as number of rows in
  `gamma`. Note that when variable enrollment duration is specified
  (input `T=NULL`), the final enrollment period is extended as long as
  needed.

- S:

  a scalar or vector of durations of piecewise constant event rates
  specified in rows of `lambda`, `eta` and `etaE`; this is NULL if there
  is a single event rate per stratum (exponential failure) or length of
  the number of rows in `lambda` minus 1, otherwise.

- T:

  study duration; if `T` is input as `NULL`, this will be computed on
  output; see details.

- minfup:

  follow-up of last patient enrolled; if `minfup` is input as `NULL`,
  this will be computed on output; see details.

- ratio:

  randomization ratio of experimental treatment divided by control;
  normally a scalar, but may be a vector with length equal to number of
  strata.

- alpha:

  type I error rate. Default is 0.025 since 1-sided testing is default.

- beta:

  type II error rate. Default is 0.10 (90% power); NULL if power is to
  be computed based on other input values.

- sided:

  1 for 1-sided testing, 2 for 2-sided testing.

- tol:

  for cases when `T` or `minfup` values are derived through root finding
  (`T` or `minfup` input as `NULL`), `tol` provides the level of error
  input to the [`uniroot()`](https://rdrr.io/r/stats/uniroot.html)
  root-finding function. The default is the same as for
  [`uniroot`](https://rdrr.io/r/stats/uniroot.html).

- timing:

  Sets relative timing of interim analyses in `gsSurv`. Default of 1
  produces equally spaced analyses. Otherwise, this is a vector of
  length `k` or `k-1`. The values should satisfy
  `0 < timing[1] < timing[2] < ... < timing[k-1] < timing[k]=1`. For
  `tEventsIA`, this is a scalar strictly between 0 and 1 that indicates
  the targeted proportion of final planned events available at an
  interim analysis.

- tIA:

  Timing of an interim analysis; should be between 0 and `y$T`.

- target:

  The targeted proportion of events at an interim analysis. This is used
  for root-finding will be 0 for normal use.

- simple:

  See output specification for `nEventsIA()`.

- k:

  Number of analyses planned, including interim and final.

- test.type:

  `1=`one-sided  
  `2=`two-sided symmetric  
  `3=`two-sided, asymmetric, beta-spending with binding lower bound  
  `4=`two-sided, asymmetric, beta-spending with non-binding lower
  bound  
  `5=`two-sided, asymmetric, lower bound spending under the null
  hypothesis with binding lower bound  
  `6=`two-sided, asymmetric, lower bound spending under the null
  hypothesis with non-binding lower bound.  
  See details, examples and manual.

- astar:

  Normally not specified. If `test.type=5` or `6`, `astar` specifies the
  total probability of crossing a lower bound at all analyses combined.
  This will be changed to \\1 - \\`alpha` when default value of 0 is
  used. Since this is the expected usage, normally `astar` is not
  specified by the user.

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
  spending function specified by `sfu`; this will be ignored for
  spending functions (`sfLDOF`, `sfLDPocock`) or bound types (“OF”,
  “Pocock”) that do not require parameters. Note that `sfupar` can be
  specified as a positive scalar for `sfLDOF` for a generalized
  O'Brien-Fleming spending function.

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

- r:

  Integer value (\>= 1 and \<= 80) controlling the number of numerical
  integration grid points. Default is 18, as recommended by Jennison and
  Turnbull (2000). Grid points are spread out in the tails for accurate
  probability calculations. Larger values provide more grid points and
  greater accuracy but slow down computation. Jennison and Turnbull
  (p. 350) note an accuracy of \\10^{-6}\\ with `r = 16`. This parameter
  is normally not changed by users.

- usTime:

  Default is NULL in which case upper bound spending time is determined
  by `timing`. Otherwise, this should be a vector of length `k` with the
  spending time at each analysis (see Details in help for `gsDesign`).

- lsTime:

  Default is NULL in which case lower bound spending time is determined
  by `timing`. Otherwise, this should be a vector of length `k` with the
  spending time at each analysis (see Details in help for `gsDesign`).

- caption:

  passed through to generic
  [`xtable()`](https://keaven.github.io/gsDesign/reference/xtable.md).

- label:

  passed through to generic
  [`xtable()`](https://keaven.github.io/gsDesign/reference/xtable.md).

- align:

  passed through to generic
  [`xtable()`](https://keaven.github.io/gsDesign/reference/xtable.md).

- display:

  passed through to generic
  [`xtable()`](https://keaven.github.io/gsDesign/reference/xtable.md).

- auto:

  passed through to generic
  [`xtable()`](https://keaven.github.io/gsDesign/reference/xtable.md).

- footnote:

  footnote for xtable output; may be useful for describing some of the
  design parameters.

- fnwid:

  a text string controlling the width of footnote text at the bottom of
  the xtable output.

- timename:

  character string with plural of time units (e.g., "months")

## Value

`nSurv()` returns an object of type `nSurv` with the following
components:

- alpha:

  As input.

- sided:

  As input.

- beta:

  Type II error; if missing, this is computed.

- power:

  Power corresponding to input `beta` or computed if output `beta` is
  computed.

- lambdaC:

  As input.

- etaC:

  As input.

- etaE:

  As input.

- gamma:

  As input unless none of the following are `NULL`: `T`, `minfup`,
  `beta`; otherwise, this is a constant times the input value required
  to power the trial given the other input variables.

- ratio:

  As input.

- R:

  As input unless `T` was `NULL` on input.

- S:

  As input.

- T:

  As input.

- minfup:

  As input.

- hr:

  As input.

- hr0:

  As input.

- n:

  Total expected sample size corresponding to output accrual rates and
  durations.

- d:

  Total expected number of events under the alternate hypothesis.

- tol:

  As input, except when not used in computations in which case this is
  returned as `NULL`. This and the remaining output below are not
  printed by the [`print()`](https://rdrr.io/r/base/print.html)
  extension for the `nSurv` class.

- eDC:

  A vector of expected number of events by stratum in the control group
  under the alternate hypothesis.

- eDE:

  A vector of expected number of events by stratum in the experimental
  group under the alternate hypothesis.

- eDC0:

  A vector of expected number of events by stratum in the control group
  under the null hypothesis.

- eDE0:

  A vector of expected number of events by stratum in the experimental
  group under the null hypothesis.

- eNC:

  A vector of the expected accrual in each stratum in the control group.

- eNE:

  A vector of the expected accrual in each stratum in the experimental
  group.

- variable:

  A text string equal to "Accrual rate" if a design was derived by
  varying the accrual rate, "Accrual duration" if a design was derived
  by varying the accrual duration, "Follow-up duration" if a design was
  derived by varying follow-up duration, or "Power" if accrual rates and
  duration as well as follow-up duration was specified and `beta=NULL`
  was input.

`gsSurv()` returns much of the above plus variables in the class
`gsDesign`; see
[`gsDesign`](https://keaven.github.io/gsDesign/reference/gsDesign.md)
for general documentation on what is returned in `gs`. The value of
`gs$n.I` represents the number of endpoints required at each analysis to
adequately power the trial. Other items returned by `gsSurv()` are:

- lambdaC:

  As input.

- etaC:

  As input.

- etaE:

  As input.

- gamma:

  As input unless none of the following are `NULL`: `T`, `minfup`,
  `beta`; otherwise, this is a constant times the input value required
  to power the trial given the other input variables.

- ratio:

  As input.

- R:

  As input unless `T` was `NULL` on input.

- S:

  As input.

- T:

  As input.

- minfup:

  As input.

- hr:

  As input.

- hr0:

  As input.

- eNC:

  Total expected sample size corresponding to output accrual rates and
  durations.

- eNE:

  Total expected sample size corresponding to output accrual rates and
  durations.

- eDC:

  Total expected number of events under the alternate hypothesis.

- eDE:

  Total expected number of events under the alternate hypothesis.

- tol:

  As input, except when not used in computations in which case this is
  returned as `NULL`. This and the remaining output below are not
  printed by the [`print()`](https://rdrr.io/r/base/print.html)
  extension for the `nSurv` class.

- eDC:

  A vector of expected number of events by stratum in the control group
  under the alternate hypothesis.

- eDE:

  A vector of expected number of events by stratum in the experimental
  group under the alternate hypothesis.

- eNC:

  A vector of the expected accrual in each stratum in the control group.

- eNE:

  A vector of the expected accrual in each stratum in the experimental
  group.

- variable:

  A text string equal to "Accrual rate" if a design was derived by
  varying the accrual rate, "Accrual duration" if a design was derived
  by varying the accrual duration, "Follow-up duration" if a design was
  derived by varying follow-up duration, or "Power" if accrual rates and
  duration as well as follow-up duration was specified and `beta=NULL`
  was input.

`nEventsIA()` returns the expected proportion of the final planned
events observed at the input analysis time minus `target` when
`simple=TRUE`. When `simple=FALSE`, `nEventsIA` returns a list with
following components:

- T:

  The input value `tIA`.

- eDC:

  The expected number of events in the control group at time the output
  time `T`.

- eDE:

  The expected number of events in the experimental group at the output
  time `T`.

- eNC:

  The expected enrollment in the control group at the output time `T`.

- eNE:

  The expected enrollment in the experimental group at the output time
  `T`.

`tEventsIA()` returns the same structure as
`nEventsIA(..., simple=TRUE)` when

## Details

[`print()`](https://rdrr.io/r/base/print.html),
[`xtable()`](https://keaven.github.io/gsDesign/reference/xtable.md) and
[`summary()`](https://rdrr.io/r/base/summary.html) methods are provided
to operate on the returned value from `gsSurv()`, an object of class
`gsSurv`. [`print()`](https://rdrr.io/r/base/print.html) is also
extended to `nSurv` objects. The functions
[`gsBoundSummary`](https://keaven.github.io/gsDesign/reference/gsBoundSummary.md)
(data frame for tabular output),
[`xprint`](https://keaven.github.io/gsDesign/reference/gsBoundSummary.md)
(application of `xtable` for tabular output) and `summary.gsSurv`
(textual summary of `gsDesign` or `gsSurv` object) may be preferred
summary functions; see example in vignettes. See also
[gsBoundSummary](https://keaven.github.io/gsDesign/reference/gsBoundSummary.md)
for output of tabular summaries of bounds for designs produced by
`gsSurv()`.

Both `nEventsIA` and `tEventsIA` require a group sequential design for a
time-to-event endpoint of class `gsSurv` as input. `nEventsIA`
calculates the expected number of events under the alternate hypothesis
at a given interim time. `tEventsIA` calculates the time that the
expected number of events under the alternate hypothesis is a given
proportion of the total events planned for the final analysis.

`nSurv()` produces an object of class `nSurv` with the number of
subjects and events for a set of pre-specified trial parameters, such as
accrual duration and follow-up period. The underlying power calculation
is based on Lachin and Foulkes (1986) method for proportional hazards
assuming a fixed underlying hazard ratio between 2 treatment groups. The
method has been extended here to enable designs to test non-inferiority.
Piecewise constant enrollment and failure rates are assumed and a
stratified population is allowed. See also
[`nSurvival`](https://keaven.github.io/gsDesign/reference/nSurvival.md)
for other Lachin and Foulkes (1986) methods assuming a constant hazard
difference or exponential enrollment rate.

When study duration (`T`) and follow-up duration (`minfup`) are fixed,
`nSurv` applies exactly the Lachin and Foulkes (1986) method of
computing sample size under the proportional hazards assumption when For
this computation, enrollment rates are altered proportionately to those
input in `gamma` to achieve the power of interest.

Given the specified enrollment rate(s) input in `gamma`, `nSurv` may
also be used to derive enrollment duration required for a trial to have
defined power if `T` is input as `NULL`; in this case, both `R`
(enrollment duration for each specified enrollment rate) and `T` (study
duration) will be computed on output.

Alternatively and also using the fixed enrollment rate(s) in `gamma`, if
minimum follow-up `minfup` is specified as `NULL`, then the enrollment
duration(s) specified in `R` are considered fixed and `minfup` and `T`
are computed to derive the desired power. This method will fail if the
specified enrollment rates and durations either over-powers the trial
with no additional follow-up or underpowers the trial with infinite
follow-up. This method produces a corresponding error message in such
cases.

The input to `gsSurv` is a combination of the input to `nSurv()` and
[`gsDesign()`](https://keaven.github.io/gsDesign/reference/gsDesign.md).

`nEventsIA()` is provided to compute the expected number of events at a
given point in time given enrollment, event and censoring rates. The
routine is used with a root finding routine to approximate the
approximate timing of an interim analysis. It is also used to extend
enrollment or follow-up of a fixed design to obtain a sufficient number
of events to power a group sequential design.

## References

Kim KM and Tsiatis AA (1990), Study duration for clinical trials with
survival response and early stopping rule. *Biometrics*, 46, 81-92

Lachin JM and Foulkes MA (1986), Evaluation of Sample Size and Power for
Analyses of Survival with Allowance for Nonuniform Patient Entry, Losses
to Follow-Up, Noncompliance, and Stratification. *Biometrics*, 42,
507-519.

Schoenfeld D (1981), The Asymptotic Properties of Nonparametric Tests
for Comparing Survival Distributions. *Biometrika*, 68, 316-319.

## See also

[`gsBoundSummary`](https://keaven.github.io/gsDesign/reference/gsBoundSummary.md),
[`xprint`](https://keaven.github.io/gsDesign/reference/gsBoundSummary.md),
[`vignette("gsDesignPackageOverview")`](https://keaven.github.io/gsDesign/articles/gsDesignPackageOverview.md),
[plot.gsDesign](https://keaven.github.io/gsDesign/reference/plot.gsDesign.md),
[`gsDesign`](https://keaven.github.io/gsDesign/reference/gsDesign.md),
[`gsHR`](https://keaven.github.io/gsDesign/reference/gsBoundSummary.md),
[`nSurvival`](https://keaven.github.io/gsDesign/reference/nSurvival.md)

[`uniroot`](https://rdrr.io/r/stats/uniroot.html)

[`Normal`](https://rdrr.io/r/stats/Normal.html)
[`xtable`](https://rdrr.io/pkg/xtable/man/xtable.html)

## Author

Keaven Anderson <keaven_anderson@merck.com>

## Examples

``` r
# vary accrual rate to obtain power
nSurv(lambdaC = log(2) / 6, hr = .5, eta = log(2) / 40, gamma = 1, T = 36, minfup = 12)
#> Fixed design, two-arm trial with time-to-event
#> outcome (Lachin and Foulkes, 1986).
#> Solving for:  Accrual rate 
#> Hazard ratio                  H1/H0=0.5/1
#> Study duration:                   T=36
#> Accrual duration:                   24
#> Min. end-of-study follow-up: minfup=12
#> Expected events (total, H1):        86.3258
#> Expected sample size (total):       119.8184
#> Accrual rates:
#>      Stratum 1
#> 0-24    4.9924
#> Control event rates (H1):
#>       Stratum 1
#> 0-Inf    0.1155
#> Censoring rates:
#>       Stratum 1
#> 0-Inf    0.0173
#> Power:                 100*(1-beta)=90%
#> Type I error (1-sided):   100*alpha=2.5%
#> Equal randomization:          ratio=1

# vary accrual duration to obtain power
nSurv(lambdaC = log(2) / 6, hr = .5, eta = log(2) / 40, gamma = 6, minfup = 12)
#> Fixed design, two-arm trial with time-to-event
#> outcome (Lachin and Foulkes, 1986).
#> Solving for:  Accrual rate 
#> Hazard ratio                  H1/H0=0.5/1
#> Study duration:                   T=18
#> Accrual duration:                   6
#> Min. end-of-study follow-up: minfup=12
#> Expected events (total, H1):        86.8217
#> Expected sample size (total):       137.2033
#> Accrual rates:
#>     Stratum 1
#> 0-6   22.8672
#> Control event rates (H1):
#>       Stratum 1
#> 0-Inf    0.1155
#> Censoring rates:
#>       Stratum 1
#> 0-Inf    0.0173
#> Power:                 100*(1-beta)=90%
#> Type I error (1-sided):   100*alpha=2.5%
#> Equal randomization:          ratio=1

# vary follow-up duration to obtain power
nSurv(lambdaC = log(2) / 6, hr = .5, eta = log(2) / 40, gamma = 6, R = 25)
#> Fixed design, two-arm trial with time-to-event
#> outcome (Lachin and Foulkes, 1986).
#> Solving for:  Accrual rate 
#> Hazard ratio                  H1/H0=0.5/1
#> Study duration:                   T=18
#> Accrual duration:                   12
#> Min. end-of-study follow-up: minfup=6
#> Expected events (total, H1):        87.2677
#> Expected sample size (total):       155.8581
#> Accrual rates:
#>      Stratum 1
#> 0-12   12.9882
#> Control event rates (H1):
#>       Stratum 1
#> 0-Inf    0.1155
#> Censoring rates:
#>       Stratum 1
#> 0-Inf    0.0173
#> Power:                 100*(1-beta)=90%
#> Type I error (1-sided):   100*alpha=2.5%
#> Equal randomization:          ratio=1

# piecewise constant enrollment rates (vary accrual duration)
nSurv(
  lambdaC = log(2) / 6, hr = .5, eta = log(2) / 40, gamma = c(1, 3, 6),
  R = c(3, 6, 9), T = NULL, minfup = 12
)
#> Fixed design, two-arm trial with time-to-event
#> outcome (Lachin and Foulkes, 1986).
#> Solving for:  Accrual duration 
#> Hazard ratio                  H1/H0=0.5/1
#> Study duration:                   T=37.7809
#> Accrual duration:                   25.7809
#> Min. end-of-study follow-up: minfup=12
#> Expected events (total, H1):        86.3632
#> Expected sample size (total):       121.6855
#> Accrual rates:
#>         Stratum 1
#> 0-3             1
#> 3-9             3
#> 9-25.78         6
#> Control event rates (H1):
#>       Stratum 1
#> 0-Inf    0.1155
#> Censoring rates:
#>       Stratum 1
#> 0-Inf    0.0173
#> Power:                 100*(1-beta)=90%
#> Type I error (1-sided):   100*alpha=2.5%
#> Equal randomization:          ratio=1

# stratified population (vary accrual duration)
nSurv(
  lambdaC = matrix(log(2) / c(6, 12), ncol = 2), hr = .5, eta = log(2) / 40,
  gamma = matrix(c(2, 4), ncol = 2), minfup = 12
)
#> Fixed design, two-arm trial with time-to-event
#> outcome (Lachin and Foulkes, 1986).
#> Solving for:  Accrual rate 
#> Hazard ratio                  H1/H0=0.5/1
#> Study duration:                   T=18
#> Accrual duration:                   6
#> Min. end-of-study follow-up: minfup=12
#> Expected events (total, H1):        87.6736
#> Expected sample size (total):       179.9025
#> Accrual rates:
#>     Stratum 1 Stratum 2
#> 0-6    9.9946   19.9892
#> Control event rates (H1):
#>       Stratum 1 Stratum 2
#> 0-Inf    0.1155    0.0578
#> Censoring rates:
#>       Stratum 1 Stratum 2
#> 0-Inf    0.0173    0.0173
#> Power:                 100*(1-beta)=90%
#> Type I error (1-sided):   100*alpha=2.5%
#> Equal randomization:          ratio=1

# piecewise exponential failure rates (vary accrual duration)
nSurv(lambdaC = log(2) / c(6, 12), hr = .5, eta = log(2) / 40, S = 3, gamma = 6, minfup = 12)
#> Fixed design, two-arm trial with time-to-event
#> outcome (Lachin and Foulkes, 1986).
#> Solving for:  Accrual rate 
#> Hazard ratio                  H1/H0=0.5/1
#> Study duration:                   T=18
#> Accrual duration:                   6
#> Min. end-of-study follow-up: minfup=12
#> Expected events (total, H1):        87.9869
#> Expected sample size (total):       183.8174
#> Accrual rates:
#>     Stratum 1
#> 0-6   30.6362
#> Control event rates (H1):
#>       Stratum 1
#> 0-3      0.1155
#> 3-Inf    0.0578
#> Censoring rates:
#>       Stratum 1
#> 0-3      0.0173
#> 3-Inf    0.0173
#> Power:                 100*(1-beta)=90%
#> Type I error (1-sided):   100*alpha=2.5%
#> Equal randomization:          ratio=1

# combine it all: 2 strata, 2 failure rate periods
nSurv(
  lambdaC = matrix(log(2) / c(6, 12, 18, 24), ncol = 2), hr = .5,
  eta = matrix(log(2) / c(40, 50, 45, 55), ncol = 2), S = 3,
  gamma = matrix(c(3, 6, 5, 7), ncol = 2), R = c(5, 10), minfup = 12
)
#> Fixed design, two-arm trial with time-to-event
#> outcome (Lachin and Foulkes, 1986).
#> Solving for:  Accrual rate 
#> Hazard ratio                  H1/H0=0.5/1
#> Study duration:                   T=18
#> Accrual duration:                   6
#> Min. end-of-study follow-up: minfup=12
#> Expected events (total, H1):        88.7326
#> Expected sample size (total):       255.7917
#> Accrual rates:
#>     Stratum 1 Stratum 2
#> 0-5   14.4788   24.1313
#> 5-6   28.9576   33.7838
#> Control event rates (H1):
#>       Stratum 1 Stratum 2
#> 0-3      0.1155    0.0385
#> 3-Inf    0.0578    0.0289
#> Censoring rates:
#>       Stratum 1 Stratum 2
#> 0-3      0.0173    0.0154
#> 3-Inf    0.0139    0.0126
#> Power:                 100*(1-beta)=90%
#> Type I error (1-sided):   100*alpha=2.5%
#> Equal randomization:          ratio=1

# example where only 1 month of follow-up is desired
# set failure rate to 0 after 1 month using lambdaC and S
nSurv(lambdaC = c(.4, 0), hr = 2 / 3, S = 1, minfup = 1)
#> Fixed design, two-arm trial with time-to-event
#> outcome (Lachin and Foulkes, 1986).
#> Solving for:  Accrual rate 
#> Hazard ratio                  H1/H0=0.6667/1
#> Study duration:                   T=18
#> Accrual duration:                   17
#> Min. end-of-study follow-up: minfup=1
#> Expected events (total, H1):        257.7578
#> Expected sample size (total):       914.4375
#> Accrual rates:
#>      Stratum 1
#> 0-17   53.7904
#> Control event rates (H1):
#>       Stratum 1
#> 0-1         0.4
#> 1-Inf       0.0
#> Censoring rates:
#>       Stratum 1
#> 0-1           0
#> 1-Inf         0
#> Power:                 100*(1-beta)=90%
#> Type I error (1-sided):   100*alpha=2.5%
#> Equal randomization:          ratio=1

# group sequential design (vary accrual rate to obtain power)
x <- gsSurv(
  k = 4, sfl = sfPower, sflpar = .5, lambdaC = log(2) / 6, hr = .5,
  eta = log(2) / 40, gamma = 1, T = 36, minfup = 12
)
x
#> Time to event group sequential design with HR= 0.5 
#> Equal randomization:          ratio=1
#> Asymmetric two-sided group sequential design with
#> 90 % power and 2.5 % Type I Error.
#> Upper bound spending computations assume
#> trial continues if lower bound is crossed.
#> 
#>                 ----Lower bounds----  ----Upper bounds-----
#>   Analysis  N   Z   Nominal p Spend+  Z   Nominal p Spend++
#>          1  29 0.23    0.5895 0.0500 3.16    0.0008  0.0008
#>          2  58 0.86    0.8056 0.0207 2.82    0.0024  0.0022
#>          3  87 1.46    0.9277 0.0159 2.44    0.0074  0.0059
#>          4 116 2.01    0.9780 0.0134 2.01    0.0220  0.0161
#>      Total                    0.1000                 0.0250 
#> + lower bound beta spending (under H1):
#>  Kim-DeMets (power) spending function with rho = 0.5.
#> ++ alpha spending:
#>  Hwang-Shih-DeCani spending function with gamma = -4.
#> 
#> Boundary crossing probabilities and expected sample size
#> assume any cross stops the trial
#> 
#> Upper boundary (power or Type I Error)
#>           Analysis
#>    Theta      1      2      3      4  Total E{N}
#>   0.0000 0.0008 0.0022 0.0055 0.0102 0.0187 46.5
#>   0.3489 0.0995 0.3393 0.3388 0.1224 0.9000 71.2
#> 
#> Lower boundary (futility or Type II Error)
#>           Analysis
#>    Theta      1      2      3      4  Total
#>   0.0000 0.5895 0.2470 0.1079 0.0369 0.9813
#>   0.3489 0.0500 0.0207 0.0159 0.0134 0.1000
#>              T         n    Events HR futility HR efficacy
#> IA 1  12.24228  81.46723  28.76662       0.919       0.308
#> IA 2  18.97078 126.24254  57.53324       0.797       0.476
#> IA 3  25.02728 159.70989  86.29986       0.730       0.591
#> Final 36.00000 159.70989 115.06648       0.687       0.687
#> Accrual rates:
#>      Stratum 1
#> 0-24      6.65
#> Control event rates (H1):
#>       Stratum 1
#> 0-Inf      0.12
#> Censoring rates:
#>       Stratum 1
#> 0-Inf      0.02
print(xtable::xtable(x,
  footnote = "This is a footnote; note that it can be wide.",
  caption = "Caption example."
))
#> % latex table generated in R 4.5.2 by xtable 1.8-4 package
#> % Thu Nov 27 02:58:37 2025
#> \begin{table}[ht]
#> \centering
#> \begin{tabular}{rllll}
#>   \hline
#>  & Analysis & Value & Futility & Efficacy \\ 
#>   \hline
#> 1 & IA 1: 25$\backslash$\% & Z-value & 0.23 & 3.16 \\ 
#>   2 & N: 82 & HR & 0.92 & 0.31 \\ 
#>   3 & Events: 29 & p (1-sided) & 0.4105 & 8e-04 \\ 
#>   4 & 12.2 months & P$\backslash$\{Cross$\backslash$\} if HR=1 & 0.5895 & 8e-04 \\ 
#>   5 &   & P$\backslash$\{Cross$\backslash$\} if HR=0.5 & 0.05 & 0.0995 \\ 
#>   6 & $\backslash$hline IA 2: 50$\backslash$\% & Z-value & 0.86 & 2.82 \\ 
#>   7 & N: 128 & HR & 0.8 & 0.48 \\ 
#>   8 & Events: 58 & p (1-sided) & 0.1944 & 0.0024 \\ 
#>   9 & 19 months & P$\backslash$\{Cross$\backslash$\} if HR=1 & 0.8366 & 0.003 \\ 
#>   10 &   & P$\backslash$\{Cross$\backslash$\} if HR=0.5 & 0.0707 & 0.4388 \\ 
#>   11 & $\backslash$hline IA 3: 75$\backslash$\% & Z-value & 1.46 & 2.44 \\ 
#>   12 & N: 160 & HR & 0.73 & 0.59 \\ 
#>   13 & Events: 87 & p (1-sided) & 0.0723 & 0.0074 \\ 
#>   14 & 25 months & P$\backslash$\{Cross$\backslash$\} if HR=1 & 0.9445 & 0.0085 \\ 
#>   15 &   & P$\backslash$\{Cross$\backslash$\} if HR=0.5 & 0.0866 & 0.7776 \\ 
#>   16 & $\backslash$hline Final analysis & Z-value & 2.01 & 2.01 \\ 
#>   17 & N: 160 & HR & 0.69 & 0.69 \\ 
#>   18 & Events: 116 & p (1-sided) & 0.022 & 0.022 \\ 
#>   19 & 36 months & P$\backslash$\{Cross$\backslash$\} if HR=1 & 0.9813 & 0.0187 \\ 
#>   20 &   & P$\backslash$\{Cross$\backslash$\} if HR=0.5 & 0.1 & 0.9 $\backslash$$\backslash$ $\backslash$hline $\backslash$multicolumn\{4\}\{p\{ 9cm \}\}\{$\backslash$footnotesize This is a footnote; note that it can be wide. \} \\ 
#>    \hline
#> \end{tabular}
#> \caption{Caption example.} 
#> \end{table}
# find expected number of events at time 12 in the above trial
nEventsIA(x = x, tIA = 10)
#> [1] 20.51876

# find time at which 1/4 of events are expected
tEventsIA(x = x, timing = .25)
#> $T
#> [1] 12.24228
#> 
#> $eDC
#> [1] 17.92465
#> 
#> $eDE
#> [1] 10.84196
#> 
#> $eNC
#> [1] 40.73361
#> 
#> $eNE
#> [1] 40.73361
#> 
```

# Advanced time-to-event sample size calculation

`nSurv()` is used to calculate the sample size for a two-arm clinical
trial with a time-to-event endpoint under the assumption of proportional
hazards. The default method assumes a fixed enrollment duration and
fixed trial duration; in this case the required sample size is achieved
by increasing enrollment rates. `nSurv()` implements the
`Lachin and Foulkes (1986)` method as default. Schoenfeld (1981),
Freedman (1982), and Bernstein and Lagakos (1989) methods are also
supported; see Details. `gsSurv()` combines `nSurv()` with
[`gsDesign()`](https://keaven.github.io/gsDesign/reference/gsDesign.md)
to derive a group sequential design for a study with a time-to-event
endpoint.

## Usage

``` r
tEventsIA(x, timing = 0.25, tol = .Machine$double.eps^0.25)

nEventsIA(tIA = 5, x = NULL, target = 0, simple = TRUE)

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
  tol = .Machine$double.eps^0.25,
  method = c("LachinFoulkes", "Schoenfeld", "Freedman", "BernsteinLagakos")
)

# S3 method for class 'nSurv'
print(x, digits = 3, show_strata = TRUE, ...)

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
  sfharm = sfHSD,
  sfharmparam = -2,
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
  lsTime = NULL,
  method = c("LachinFoulkes", "Schoenfeld", "Freedman", "BernsteinLagakos")
)

# S3 method for class 'gsSurv'
print(x, digits = 3, show_gsDesign = FALSE, show_strata = TRUE, ...)
```

## Arguments

- x:

  An object of class `nSurv` or `gsSurv`. `print.nSurv()` is used for an
  object of class `nSurv` which will generally be output from `nSurv()`.
  For `print.gsSurv()` is used for an object of class `gsSurv` which
  will generally be output from `gsSurv()`. `nEventsIA` and `tEventsIA`
  operate on both the `nSurv` and `gsSurv` class.

- timing:

  Sets relative timing of interim analyses in `gsSurv`. Default of 1
  produces equally spaced analyses. Otherwise, this is a vector of
  length `k` or `k-1`. The values should satisfy
  `0 < timing[1] < timing[2] < ... < timing[k-1] < timing[k]=1`. For
  `tEventsIA`, this is a scalar strictly between 0 and 1 that indicates
  the targeted proportion of final planned events available at an
  interim analysis.

- tol:

  For cases when `T` or `minfup` values are derived through root finding
  (`T` or `minfup` input as `NULL`), `tol` provides the level of error
  input to the [`uniroot()`](https://rdrr.io/r/stats/uniroot.html)
  root-finding function. The default is the same as for
  [`uniroot`](https://rdrr.io/r/stats/uniroot.html).

- tIA:

  Timing of an interim analysis; should be between 0 and `y$T`.

- target:

  The targeted proportion of events at an interim analysis. This is used
  for root-finding will be 0 for normal use.

- simple:

  See output specification for `nEventsIA()`.

- lambdaC:

  Scalar, vector or matrix of event hazard rates for the control group;
  rows represent time periods while columns represent strata; a vector
  implies a single stratum. Note that rates corresponding the final time
  period are extended indefinitely.

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
  (input `T=NULL`), the final enrollment period is extended as long as
  needed; otherwise enrollment after `sum(R)` is 0.

- S:

  A scalar or vector of durations of piecewise constant event rates
  specified in rows of `lambda`, `eta` and `etaE`; this is `NULL` if
  there is a single event rate per stratum (exponential failure) or
  length of the number of rows in `lambda` minus 1, otherwise. The final
  time period is extended indefinitely for each stratum.

- T:

  Study duration; if `T` is input as `NULL`, this will be computed on
  output; see details.

- minfup:

  Follow-up of last patient enrolled; if `minfup` is input as `NULL`,
  this will be computed on output; see details.

- ratio:

  Randomization ratio of experimental treatment divided by control;
  normally a scalar, but may be a vector with length equal to number of
  strata.

- alpha:

  Type I error rate. Default is 0.025 since 1-sided testing is default.

- beta:

  Type II error rate. Default is 0.10 (90% power); `NULL` if power is to
  be computed based on other input values.

- sided:

  `1` for 1-sided testing, `2` for 2-sided testing.

- method:

  One of `"LachinFoulkes"` (default), `"Schoenfeld"`, `"Freedman"`, or
  `"BernsteinLagakos"`. Note: `"Schoenfeld"` and `"Freedman"` methods
  only support superiority testing (`hr0 = 1`). `"Freedman"` does not
  support stratified populations.

- digits:

  Number of digits past the decimal place to print (`print.gsSurv.`);
  also a pass through to generic
  [`xtable()`](https://keaven.github.io/gsDesign/reference/xtable.md)
  from `xtable.gsSurv()`.

- show_strata:

  Logical; for `print.gsSurv()`, include strata summaries.

- ...:

  Other arguments that may be passed to generic functions underlying the
  methods here.

- caption:

  Passed through to generic
  [`xtable()`](https://keaven.github.io/gsDesign/reference/xtable.md).

- label:

  Passed through to generic
  [`xtable()`](https://keaven.github.io/gsDesign/reference/xtable.md).

- align:

  Passed through to generic
  [`xtable()`](https://keaven.github.io/gsDesign/reference/xtable.md).

- display:

  Passed through to generic
  [`xtable()`](https://keaven.github.io/gsDesign/reference/xtable.md).

- auto:

  Passed through to generic
  [`xtable()`](https://keaven.github.io/gsDesign/reference/xtable.md).

- footnote:

  Footnote for xtable output; may be useful for describing some of the
  design parameters.

- fnwid:

  A text string controlling the width of footnote text at the bottom of
  the xtable output.

- timename:

  Character string with plural of time units (e.g., "months")

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
  hypothesis with non-binding lower bound  
  `7=`two-sided, asymmetric, with binding futility and binding harm
  bounds  
  `8=`two-sided, asymmetric, with non-binding futility and non-binding
  harm bounds.  
  See details, examples and manual.

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
  spending time at each analysis (see Details section of
  [`gsDesign`](https://keaven.github.io/gsDesign/reference/gsDesign.md)).

- lsTime:

  Default is NULL in which case lower bound spending time is determined
  by `timing`. Otherwise, this should be a vector of length `k` with the
  spending time at each analysis (see Details section of
  [`gsDesign`](https://keaven.github.io/gsDesign/reference/gsDesign.md)).

- show_gsDesign:

  Logical; for `print.gsSurv()`, include gsDesign details.

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

`gsSurv()` returns much of the above plus an object of class `gsDesign`
in a variable named `gs`; see
[`gsDesign`](https://keaven.github.io/gsDesign/reference/gsDesign.md)
for general documentation on what is returned in `gs`. The value of
`gs$n.I` represents the number of endpoints required at each analysis to
adequately power the trial. Other items returned by `gsSurv()` are:

- gs:

  A group sequential design (`gsDesign`) object.

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

The Lachin and Foulkes method uses both null and alternate hypothesis
variances to derive sample size and is extended here to support
non-inferiority, super-superiority, and stratified designs. As an
alternative, the Kim and Tsiatis (1990) method can be used with fixed
enrollment rates and either fixed enrollment duration or fixed minimum
follow-up. The Schoenfeld approach uses the asymptotic distribution of
the log-rank statistic under the assumption of proportional hazards and
local alternatives (i.e., \\\log(HR)\\ is small). The Freedman approach
uses the same asymptotic distribution and, like the Schoenfeld approach,
uses just the null hypothesis variance to derive sample size. The
Bernstein and Lagakos (1989) approach was derived to compute sample size
for a stratified model with a common proportional hazards assumption
across strata. Like the Lachin and Foulkes (1986) method, it uses both
null and alternate hypothesis variances to compute sample size; however,
the null hypothesis variance is computed differently. The Bernstein and
Lagakos (1989) approach uses the alternate hypothesis failure rate
assumptions for both the control and experimental groups, while the
Lachin and Foulkes method uses null hypothesis rates that average the
alternate hypothesis failure rates to get similar numbers of expected
events under the null and alternate hypotheses. Since the Lachin and
Foulkes method has fewer events under the null hypothesis (less
statistical information), it calculates less power than the Bernstein
and Lagakos method. Piecewise exponential survival is supported as well
as piecewise constant enrollment and dropout rates. The methods are for
a 2-arm trial with treatment groups referred to as experimental and
control. A stratified population is allowed as in Lachin and Foulkes
(1986); this method has been extended to derive non-inferiority as well
as superiority trials. Stratification also allows power calculation for
meta-analyses.

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

Freedman LS (1982), Tables of the Number of Patients Required in
Clinical Trials Using the Logrank Test. *Statistics in Medicine*, 1,
121-129.

## See also

[`uniroot`](https://rdrr.io/r/stats/uniroot.html)

[`gsBoundSummary`](https://keaven.github.io/gsDesign/reference/gsBoundSummary.md),
[`xprint`](https://keaven.github.io/gsDesign/reference/gsBoundSummary.md),
[`gsSurvCalendar`](https://keaven.github.io/gsDesign/reference/gsSurvCalendar.md),
[gsDesign-package](https://keaven.github.io/gsDesign/reference/gsDesign-package.md),
[plot.gsDesign](https://keaven.github.io/gsDesign/reference/plot.gsDesign.md),
[`gsDesign`](https://keaven.github.io/gsDesign/reference/gsDesign.md),
[`gsHR`](https://keaven.github.io/gsDesign/reference/gsBoundSummary.md),
[`nSurvival`](https://keaven.github.io/gsDesign/reference/nSurvival.md)

[`Normal`](https://rdrr.io/r/stats/Normal.html)
[`xtable`](https://rdrr.io/pkg/xtable/man/xtable.html)

## Author

Keaven Anderson <keaven_anderson@merck.com>

## Examples

``` r
# Vary accrual rate gamma to obtain power
# T, minfup and R all specified, although R will be adjusted on output
# gamma as input will be multiplied in output to achieve desired power
# Default method is Lachin and Foulkes
x_nsurv <- nSurv(
  lambdaC = log(2) / 6, R = 10, hr = .5, eta = .001, gamma = 1,
  alpha = 0.02, beta = .15, T = 36, minfup = 12, method = "LachinFoulkes"
)
# Demonstrate print method
print(x_nsurv)
#> nSurv fixed-design summary (method=LachinFoulkes; target=Accrual rate)
#> HR=0.500 vs HR0=1.000 | alpha=0.020 (sided=1) | power=85.0%
#> N=95.7 subjects | D=78.1 events | T=36.0 study duration | accrual=24.0 Accrual duration | minfup=12.0 minimum follow-up | ratio=1 randomization ratio (experimental/control)
#> 
#> Key inputs (names preserved):
#>                                desc    item value input
#>                     Accrual rate(s)   gamma 3.986     1
#>            Accrual rate duration(s)       R    24    10
#>              Control hazard rate(s) lambdaC 0.116 0.116
#>             Control dropout rate(s)     eta 0.001 0.001
#>        Experimental dropout rate(s)    etaE 0.001  etaE
#>  Event and dropout rate duration(s)       S  NULL     S
# Same assumptions for group sequential design
x_gs <- gsSurv(
  k = 4, sfl = gsDesign::sfPower, sflpar = .5, lambdaC = log(2) / 6, hr = .5,
  eta = .001, gamma = 1, T = 36, minfup = 12, method = "LachinFoulkes"
)
print(x_gs)
#> Group sequential design (method=LachinFoulkes; k=4 analyses; Two-sided asymmetric with non-binding futility)
#> N=140.7 subjects | D=114.8 events | T=36.0 study duration | accrual=24.0 Accrual duration | minfup=12.0 minimum follow-up | ratio=1 randomization ratio (experimental/control)
#> 
#> Spending functions:
#>   Efficacy bounds derived using a Hwang-Shih-DeCani spending function with gamma = -4.
#>   Futility bounds derived using a Kim-DeMets (power) spending function with rho = 0.
#> 
#> Analysis summary:
#> Method: LachinFoulkes 
#>     Analysis              Value Efficacy Futility
#>    IA 1: 25%                  Z   3.1554   0.2264
#>        N: 76        p (1-sided)   0.0008   0.4105
#>   Events: 29       ~HR at bound   0.3079   0.9190
#>    Month: 13   P(Cross) if HR=1   0.0008   0.5895
#>              P(Cross) if HR=0.5   0.0995   0.0500
#>    IA 2: 50%                  Z   2.8183   0.8619
#>       N: 116        p (1-sided)   0.0024   0.1944
#>   Events: 58       ~HR at bound   0.4752   0.7965
#>    Month: 20   P(Cross) if HR=1   0.0030   0.8366
#>              P(Cross) if HR=0.5   0.4388   0.0707
#>    IA 3: 75%                  Z   2.4390   1.4589
#>       N: 142        p (1-sided)   0.0074   0.0723
#>   Events: 87       ~HR at bound   0.5912   0.7302
#>    Month: 26   P(Cross) if HR=1   0.0085   0.9445
#>              P(Cross) if HR=0.5   0.7776   0.0866
#>        Final                  Z   2.0136   2.0136
#>       N: 142        p (1-sided)   0.0220   0.0220
#>  Events: 115       ~HR at bound   0.6867   0.6867
#>    Month: 36   P(Cross) if HR=1   0.0187   0.9813
#>              P(Cross) if HR=0.5   0.9000   0.1000
#> 
#> Key inputs (names preserved):
#>                                desc    item value input
#>                     Accrual rate(s)   gamma 5.863     1
#>            Accrual rate duration(s)       R    24    12
#>              Control hazard rate(s) lambdaC 0.116 0.116
#>             Control dropout rate(s)     eta 0.001 0.001
#>        Experimental dropout rate(s)    etaE 0.001  etaE
#>  Event and dropout rate duration(s)       S  NULL     S
# Demonstrate xtable method for gsSurv
print(xtable::xtable(x_gs,
  footnote = "This is a footnote; note that it can be wide.",
  caption = "Caption example for xtable output."
))
#> % latex table generated in R 4.5.2 by xtable 1.8-8 package
#> % Sat Feb 28 21:19:42 2026
#> \begin{table}[ht]
#> \centering
#> \begin{tabular}{rllll}
#>   \hline
#>  & Analysis & Value & Futility & Efficacy \\ 
#>   \hline
#> 1 & IA 1: 25$\backslash$\% & Z-value & 0.23 & 3.16 \\ 
#>   2 & N: 76 & HR & 0.92 & 0.31 \\ 
#>   3 & Events: 29 & p (1-sided) & 0.4105 & 8e-04 \\ 
#>   4 & 12.8 months & P$\backslash$\{Cross$\backslash$\} if HR=1 & 0.5895 & 8e-04 \\ 
#>   5 &   & P$\backslash$\{Cross$\backslash$\} if HR=0.5 & 0.05 & 0.0995 \\ 
#>   6 & $\backslash$hline IA 2: 50$\backslash$\% & Z-value & 0.86 & 2.82 \\ 
#>   7 & N: 116 & HR & 0.8 & 0.48 \\ 
#>   8 & Events: 58 & p (1-sided) & 0.1944 & 0.0024 \\ 
#>   9 & 19.6 months & P$\backslash$\{Cross$\backslash$\} if HR=1 & 0.8366 & 0.003 \\ 
#>   10 &   & P$\backslash$\{Cross$\backslash$\} if HR=0.5 & 0.0707 & 0.4388 \\ 
#>   11 & $\backslash$hline IA 3: 75$\backslash$\% & Z-value & 1.46 & 2.44 \\ 
#>   12 & N: 142 & HR & 0.73 & 0.59 \\ 
#>   13 & Events: 87 & p (1-sided) & 0.0723 & 0.0074 \\ 
#>   14 & 25.7 months & P$\backslash$\{Cross$\backslash$\} if HR=1 & 0.9445 & 0.0085 \\ 
#>   15 &   & P$\backslash$\{Cross$\backslash$\} if HR=0.5 & 0.0866 & 0.7776 \\ 
#>   16 & $\backslash$hline Final analysis & Z-value & 2.01 & 2.01 \\ 
#>   17 & N: 142 & HR & 0.69 & 0.69 \\ 
#>   18 & Events: 115 & p (1-sided) & 0.022 & 0.022 \\ 
#>   19 & 36 months & P$\backslash$\{Cross$\backslash$\} if HR=1 & 0.9813 & 0.0187 \\ 
#>   20 &   & P$\backslash$\{Cross$\backslash$\} if HR=0.5 & 0.1 & 0.9 $\backslash$$\backslash$ $\backslash$hline $\backslash$multicolumn\{4\}\{p\{ 9cm \}\}\{$\backslash$footnotesize This is a footnote; note that it can be wide. \} \\ 
#>    \hline
#> \end{tabular}
#> \caption{Caption example for xtable output.} 
#> \end{table}
# Demonstrate nEventsIA method
# find expected number of events at time 12 in the above trial
nEventsIA(x = x_gs, tIA = 10)
#> [1] 18.92635

# find time at which 1/4 of events are expected
tEventsIA(x = x_gs, timing = .25)
#> $T
#> [1] 12.76571
#> 
#> $eDC
#> [1] 17.79583
#> 
#> $eDE
#> [1] 10.90882
#> 
#> $eNC
#> [1] 37.42481
#> 
#> $eNE
#> [1] 37.42481
#> 

# Adjust accrual duration R to achieve desired power
# Trial duration T input as NULL and will be computed based on
# accrual duration R and minimum follow-up duration minfup
# Minimum follow-up duration minfup is specified
# We use the Schoenfeld method to compute accrual duration R
# Control median survival time is 6
nSurv(
  lambdaC = log(2) / 6, hr = .5, eta = .001, gamma = 6,
  alpha = .025, beta = .1, minfup = 12, T = NULL, method = "Schoenfeld"
)
#> nSurv fixed-design summary (method=Schoenfeld; target=Accrual duration)
#> HR=0.500 vs HR0=1.000 | alpha=0.025 (sided=1) | power=90.0%
#> N=109.5 subjects | D=86.2 events | T=30.2 study duration | accrual=18.2 Accrual duration | minfup=12.0 minimum follow-up | ratio=1 randomization ratio (experimental/control)
#> 
#> Key inputs (names preserved):
#>                                desc    item  value input
#>                     Accrual rate(s)   gamma      6     6
#>            Accrual rate duration(s)       R 18.243    12
#>              Control hazard rate(s) lambdaC  0.116 0.116
#>             Control dropout rate(s)     eta  0.001 0.001
#>        Experimental dropout rate(s)    etaE  0.001  etaE
#>  Event and dropout rate duration(s)       S   NULL     S
# Same assumptions for group sequential design
gsSurv(
  k = 4, sfu = gsDesign::sfHSD, sfupar = -4, sfl = gsDesign::sfPower, sflpar = .5,
  lambdaC = log(2) / 6, hr = .5, eta = .001, gamma = 6,
  T = 36, minfup = 12, method = "Schoenfeld"
) |>
  print()
#> Group sequential design (method=Schoenfeld; k=4 analyses; Two-sided asymmetric with non-binding futility)
#> N=142.9 subjects | D=116.6 events | T=36.0 study duration | accrual=24.0 Accrual duration | minfup=12.0 minimum follow-up | ratio=1 randomization ratio (experimental/control)
#> 
#> Spending functions:
#>   Efficacy bounds derived using a Hwang-Shih-DeCani spending function with gamma = -4.
#>   Futility bounds derived using a Kim-DeMets (power) spending function with rho = 0.
#> 
#> Analysis summary:
#> Method: Schoenfeld 
#>     Analysis              Value Efficacy Futility
#>    IA 1: 25%                  Z   3.1554   0.2264
#>        N: 78        p (1-sided)   0.0008   0.4105
#>   Events: 30       ~HR at bound   0.3107   0.9196
#>    Month: 13   P(Cross) if HR=1   0.0008   0.5895
#>              P(Cross) if HR=0.5   0.0995   0.0500
#>    IA 2: 50%                  Z   2.8183   0.8619
#>       N: 118        p (1-sided)   0.0024   0.1944
#>   Events: 59       ~HR at bound   0.4780   0.7979
#>    Month: 20   P(Cross) if HR=1   0.0030   0.8366
#>              P(Cross) if HR=0.5   0.4388   0.0707
#>    IA 3: 75%                  Z   2.4390   1.4589
#>       N: 144        p (1-sided)   0.0074   0.0723
#>   Events: 88       ~HR at bound   0.5936   0.7320
#>    Month: 26   P(Cross) if HR=1   0.0085   0.9445
#>              P(Cross) if HR=0.5   0.7776   0.0866
#>        Final                  Z   2.0136   2.0136
#>       N: 144        p (1-sided)   0.0220   0.0220
#>  Events: 117       ~HR at bound   0.6887   0.6887
#>    Month: 36   P(Cross) if HR=1   0.0187   0.9813
#>              P(Cross) if HR=0.5   0.9000   0.1000
#> 
#> Key inputs (names preserved):
#>                                desc    item value input
#>                     Accrual rate(s)   gamma 5.955     6
#>            Accrual rate duration(s)       R    24    12
#>              Control hazard rate(s) lambdaC 0.116 0.116
#>             Control dropout rate(s)     eta 0.001 0.001
#>        Experimental dropout rate(s)    etaE 0.001  etaE
#>  Event and dropout rate duration(s)       S  NULL     S

# Vary minimum follow-up duration minfup to obtain power
# Accrual duration R rate gamma are fixed and will not change on output.
# Trial duration T and minimum follow-up minfup are input as NULL
# and will be computed on output.
# We will use the Freedman method to compute sample size
# Control median survival time is 6
# Often this method will fail as the accrual duration and rate provide too
# little or too much sample size.
nSurv(
  lambdaC = log(2) / 6, hr = .5, eta = .001, gamma = 6, R = 25,
  alpha = .025, beta = .1, minfup = NULL, T = NULL, method = "Freedman"
)
#> nSurv fixed-design summary (method=Freedman; target=Follow-up duration)
#> HR=0.500 vs HR0=1.000 | alpha=0.025 (sided=1) | power=90.0%
#> N=150.0 subjects | D=86.8 events | T=25.3 study duration | accrual=25.0 Accrual duration | minfup=0.3 minimum follow-up | ratio=1 randomization ratio (experimental/control)
#> 
#> Key inputs (names preserved):
#>                                desc    item value input
#>                     Accrual rate(s)   gamma     6     6
#>            Accrual rate duration(s)       R    25    25
#>              Control hazard rate(s) lambdaC 0.116 0.116
#>             Control dropout rate(s)     eta 0.001 0.001
#>        Experimental dropout rate(s)    etaE 0.001  etaE
#>  Event and dropout rate duration(s)       S  NULL     S
# Same assumptions for group sequential design
gsSurv(
  k = 4, sfu = gsDesign::sfHSD, sfupar = -4, sfl = gsDesign::sfPower, sflpar = .5,
  lambdaC = log(2) / 6, hr = .5, eta = .001, gamma = 6,
  T = 36, minfup = 12, method = "Freedman"
) |>
  print()
#> Group sequential design (method=Freedman; k=4 analyses; Two-sided asymmetric with non-binding futility)
#> N=154.5 subjects | D=126.1 events | T=36.0 study duration | accrual=24.0 Accrual duration | minfup=12.0 minimum follow-up | ratio=1 randomization ratio (experimental/control)
#> 
#> Spending functions:
#>   Efficacy bounds derived using a Hwang-Shih-DeCani spending function with gamma = -4.
#>   Futility bounds derived using a Kim-DeMets (power) spending function with rho = 0.
#> 
#> Analysis summary:
#> Method: Freedman 
#>     Analysis              Value Efficacy Futility
#>    IA 1: 25%                  Z   3.1554   0.2264
#>        N: 84        p (1-sided)   0.0008   0.4105
#>   Events: 32       ~HR at bound   0.3249   0.9225
#>    Month: 13   P(Cross) if HR=1   0.0008   0.5895
#>              P(Cross) if HR=0.5   0.0995   0.0500
#>    IA 2: 50%                  Z   2.8183   0.8619
#>       N: 128        p (1-sided)   0.0024   0.1944
#>   Events: 64       ~HR at bound   0.4916   0.8048
#>    Month: 20   P(Cross) if HR=1   0.0030   0.8366
#>              P(Cross) if HR=0.5   0.4388   0.0707
#>    IA 3: 75%                  Z   2.4390   1.4589
#>       N: 156        p (1-sided)   0.0074   0.0723
#>   Events: 95       ~HR at bound   0.6055   0.7407
#>    Month: 26   P(Cross) if HR=1   0.0085   0.9445
#>              P(Cross) if HR=0.5   0.7776   0.0866
#>        Final                  Z   2.0136   2.0136
#>       N: 156        p (1-sided)   0.0220   0.0220
#>  Events: 127       ~HR at bound   0.6986   0.6986
#>    Month: 36   P(Cross) if HR=1   0.0187   0.9813
#>              P(Cross) if HR=0.5   0.9000   0.1000
#> 
#> Key inputs (names preserved):
#>                                desc    item value input
#>                     Accrual rate(s)   gamma 6.437     6
#>            Accrual rate duration(s)       R    24    12
#>              Control hazard rate(s) lambdaC 0.116 0.116
#>             Control dropout rate(s)     eta 0.001 0.001
#>        Experimental dropout rate(s)    etaE 0.001  etaE
#>  Event and dropout rate duration(s)       S  NULL     S

# piecewise constant enrollment rates (vary accrual rate to achieve power)
# also piecewise constant failure rates
# will specify annualized enrollment and failure rates
nSurv(
  lambdaC = -log(c(.95, .97, .98)), # 5%, 3% and 2% annual failure rates
  S = c(1, 1), # 1 year duration for first 2 failure rates, 3rd continues indefinitely
  R = c(.25, .25, 1.5), # 2-year enrollment with ramp-up over first 1/2 year
  gamma = c(1, 3, 6), # 1, 3 and 6 annualized enrollment rates will be
  # multiplied by ratio to achieve desired power
  hr = .5, eta = -log(1 - .01), # 1% annual censoring rate
  minfup = 3, T = 5, # 5-year trial duration with 3-year minimum follow-up
  alpha = .025, beta = .1, method = "LachinFoulkes"
)
#> nSurv fixed-design summary (method=LachinFoulkes; target=Accrual rate)
#> HR=0.500 vs HR0=1.000 | alpha=0.025 (sided=1) | power=90.0%
#> N=1088.8 subjects | D=91.1 events | T=5.0 study duration | accrual=2.0 Accrual duration | minfup=3.0 minimum follow-up | ratio=1 randomization ratio (experimental/control)
#> 
#> Key inputs (names preserved):
#>                                desc    item                     value
#>                     Accrual rate(s)   gamma 108.876, 326.629, 653.258
#>            Accrual rate duration(s)       R           0.25, 0.25, 1.5
#>              Control hazard rate(s) lambdaC         0.051, 0.03, 0.02
#>             Control dropout rate(s)     eta          0.01, 0.01, 0.01
#>        Experimental dropout rate(s)    etaE          0.01, 0.01, 0.01
#>  Event and dropout rate duration(s)       S                      1, 1
#>              input
#>            1, 3, 6
#>    0.25, 0.25, 1.5
#>  0.051, 0.03, 0.02
#>               0.01
#>               etaE
#>               1, 1
# Same assumptions for group sequential design
gsSurv(
  k = 4, sfu = gsDesign::sfHSD, sfupar = -4, sfl = gsDesign::sfPower, sflpar = .5,
  lambdaC = -log(c(.95, .97, .98)), # 5%, 3% and 2% annual failure rates
  S = c(1, 1), # 1 year duration for first 2 failure rates, 3rd continues indefinitely
  R = c(.25, .25, 1.5), # 2-year enrollment with ramp-up over first 1/2 year
  gamma = c(1, 3, 6), # 1, 3 and 6 annualized enrollment rates will be
  # multiplied by ratio to achieve desired power
  hr = .5, eta = -log(1 - .01), # 1% annual censoring rate
  minfup = 3, T = 5, # 5-year trial duration with 3-year minimum follow-up
  alpha = .025, beta = .1, method = "LachinFoulkes"
) |>
  print()
#> Group sequential design (method=LachinFoulkes; k=4 analyses; Two-sided asymmetric with non-binding futility)
#> N=1451.2 subjects | D=121.4 events | T=5.0 study duration | accrual=2.0 Accrual duration | minfup=3.0 minimum follow-up | ratio=1 randomization ratio (experimental/control)
#> 
#> Spending functions:
#>   Efficacy bounds derived using a Hwang-Shih-DeCani spending function with gamma = -4.
#>   Futility bounds derived using a Kim-DeMets (power) spending function with rho = 0.
#> 
#> Analysis summary:
#> Method: LachinFoulkes 
#>     Analysis              Value Efficacy Futility
#>    IA 1: 25%                  Z   3.1554   0.2264
#>      N: 1198        p (1-sided)   0.0008   0.4105
#>   Events: 31       ~HR at bound   0.3181   0.9211
#>     Month: 2   P(Cross) if HR=1   0.0008   0.5895
#>              P(Cross) if HR=0.5   0.0995   0.0500
#>    IA 2: 50%                  Z   2.8183   0.8619
#>      N: 1452        p (1-sided)   0.0024   0.1944
#>   Events: 61       ~HR at bound   0.4851   0.8015
#>     Month: 2   P(Cross) if HR=1   0.0030   0.8366
#>              P(Cross) if HR=0.5   0.4388   0.0707
#>    IA 3: 75%                  Z   2.4390   1.4589
#>      N: 1452        p (1-sided)   0.0074   0.0723
#>   Events: 92       ~HR at bound   0.5998   0.7366
#>     Month: 3   P(Cross) if HR=1   0.0085   0.9445
#>              P(Cross) if HR=0.5   0.7776   0.0866
#>        Final                  Z   2.0136   2.0136
#>      N: 1452        p (1-sided)   0.0220   0.0220
#>  Events: 122       ~HR at bound   0.6939   0.6939
#>     Month: 5   P(Cross) if HR=1   0.0187   0.9813
#>              P(Cross) if HR=0.5   0.9000   0.1000
#> 
#> Key inputs (names preserved):
#>                                desc    item                     value
#>                     Accrual rate(s)   gamma 145.125, 435.375, 870.749
#>            Accrual rate duration(s)       R           0.25, 0.25, 1.5
#>              Control hazard rate(s) lambdaC         0.051, 0.03, 0.02
#>             Control dropout rate(s)     eta          0.01, 0.01, 0.01
#>        Experimental dropout rate(s)    etaE          0.01, 0.01, 0.01
#>  Event and dropout rate duration(s)       S                      1, 1
#>              input
#>            1, 3, 6
#>    0.25, 0.25, 1.5
#>  0.051, 0.03, 0.02
#>               0.01
#>               etaE
#>               1, 1

# combine it all: 2 strata, 2 failure rate periods
# Note that method = "LachinFoulkes" may be preferred here
nSurv(
  lambdaC = matrix(log(2) / c(6, 12, 18, 24), ncol = 2), hr = .5,
  eta = matrix(log(2) / c(40, 50, 45, 55), ncol = 2), S = 3,
  gamma = matrix(c(3, 6, 5, 7), ncol = 2), R = c(5, 10), minfup = 12,
  alpha = .025, beta = .1, method = "BernsteinLagakos"
)
#> nSurv fixed-design summary (method=BernsteinLagakos; target=Accrual rate)
#> HR=0.500 vs HR0=1.000 | alpha=0.025 (sided=1) | power=90.0%
#> N=226.8 subjects | D=78.7 events | T=18.0 study duration | accrual=6.0 Accrual duration | minfup=12.0 minimum follow-up | ratio=1 randomization ratio (experimental/control)
#> 
#> Expected events by stratum (H1):
#>   control experimental  total
#> 1  26.517       16.431 42.949
#> 2  22.980       12.761 35.741
#> 
#> Key inputs (names preserved):
#>                                desc    item                           value
#>                     Accrual rate(s)   gamma  12.84, 25.68, 21.4 ... (len=4)
#>            Accrual rate duration(s)       R                            5, 1
#>              Control hazard rate(s) lambdaC 0.116, 0.058, 0.039 ... (len=4)
#>             Control dropout rate(s)     eta 0.017, 0.014, 0.015 ... (len=4)
#>        Experimental dropout rate(s)    etaE 0.017, 0.014, 0.015 ... (len=4)
#>  Event and dropout rate duration(s)       S                               3
#>                            input
#>              3, 6, 5 ... (len=4)
#>                            5, 10
#>  0.116, 0.058, 0.039 ... (len=4)
#>  0.017, 0.014, 0.015 ... (len=4)
#>                             etaE
#>                                3
# Same assumptions for group sequential design
gsSurv(
  k = 4, sfu = gsDesign::sfHSD, sfupar = -4, sfl = gsDesign::sfPower, sflpar = .5,
  lambdaC = matrix(log(2) / c(6, 12, 18, 24), ncol = 2), hr = .5,
  eta = matrix(log(2) / c(40, 50, 45, 55), ncol = 2), S = 3,
  gamma = matrix(c(3, 6, 5, 7), ncol = 2), R = c(5, 10), minfup = 12,
  alpha = .025, beta = .1, method = "BernsteinLagakos"
) |>
  print()
#> Group sequential design (method=BernsteinLagakos; k=4 analyses; Two-sided asymmetric with non-binding futility)
#> N=302.4 subjects | D=104.9 events | T=18.0 study duration | accrual=6.0 Accrual duration | minfup=12.0 minimum follow-up | ratio=1 randomization ratio (experimental/control)
#> 
#> Spending functions:
#>   Efficacy bounds derived using a Hwang-Shih-DeCani spending function with gamma = -4.
#>   Futility bounds derived using a Kim-DeMets (power) spending function with rho = 0.
#> 
#> Analysis summary:
#> Method: BernsteinLagakos 
#>     Analysis              Value Efficacy Futility
#>    IA 1: 25%                  Z   3.1554   0.2264
#>       N: 250        p (1-sided)   0.0008   0.4105
#>   Events: 27       ~HR at bound   0.2916   0.9154
#>     Month: 5   P(Cross) if HR=1   0.0008   0.5895
#>              P(Cross) if HR=0.5   0.0995   0.0500
#>    IA 2: 50%                  Z   2.8183   0.8619
#>       N: 304        p (1-sided)   0.0024   0.1944
#>   Events: 53       ~HR at bound   0.4592   0.7882
#>     Month: 8   P(Cross) if HR=1   0.0030   0.8366
#>              P(Cross) if HR=0.5   0.4388   0.0707
#>    IA 3: 75%                  Z   2.4390   1.4589
#>       N: 304        p (1-sided)   0.0074   0.0723
#>   Events: 79       ~HR at bound   0.5770   0.7197
#>    Month: 12   P(Cross) if HR=1   0.0085   0.9445
#>              P(Cross) if HR=0.5   0.7776   0.0866
#>        Final                  Z   2.0136   2.0136
#>       N: 304        p (1-sided)   0.0220   0.0220
#>  Events: 105       ~HR at bound   0.6749   0.6749
#>    Month: 18   P(Cross) if HR=1   0.0187   0.9813
#>              P(Cross) if HR=0.5   0.9000   0.1000
#> 
#> Key inputs (names preserved):
#>                                desc    item                             value
#>                     Accrual rate(s)   gamma 17.115, 28.525, 34.23 ... (len=4)
#>            Accrual rate duration(s)       R                              5, 1
#>              Control hazard rate(s) lambdaC   0.116, 0.039, 0.058 ... (len=4)
#>             Control dropout rate(s)     eta   0.017, 0.015, 0.014 ... (len=4)
#>        Experimental dropout rate(s)    etaE   0.017, 0.015, 0.014 ... (len=4)
#>  Event and dropout rate duration(s)       S                                 3
#>                            input
#>              3, 5, 6 ... (len=4)
#>                            5, 10
#>  0.116, 0.039, 0.058 ... (len=4)
#>  0.017, 0.015, 0.014 ... (len=4)
#>                             etaE
#>                                3
#> 
#> Expected events by stratum (H1) at final analysis:
#>    stratum control experimental  total
#>  Stratum 1  35.346       21.902 57.248
#>  Stratum 2  30.631       17.010 47.641

# Example to compute power for a fixed design.
# Trial duration T, minimum follow-up minfup and accrual duration R are all
# specified and will not change on output.
# beta=NULL will compute power and output will be the same as if beta were specified.
# This option is not available for group sequential designs.
nSurv(
  lambdaC = log(2) / 6, hr = .5, eta = .001, gamma = 6, R = 25,
  alpha = .025, beta = NULL, minfup = 12, T = 36, method = "LachinFoulkes"
) |>
  print()
#> nSurv fixed-design summary (method=LachinFoulkes; target=Power)
#> HR=0.500 vs HR0=1.000 | alpha=0.025 (sided=1) | power=96.5%
#> N=144.0 subjects | D=117.5 events | T=36.0 study duration | accrual=24.0 Accrual duration | minfup=12.0 minimum follow-up | ratio=1 randomization ratio (experimental/control)
#> 
#> Key inputs (names preserved):
#>                                desc    item value input
#>                     Accrual rate(s)   gamma     6     6
#>            Accrual rate duration(s)       R    24    25
#>              Control hazard rate(s) lambdaC 0.116 0.116
#>             Control dropout rate(s)     eta 0.001 0.001
#>        Experimental dropout rate(s)    etaE 0.001  etaE
#>  Event and dropout rate duration(s)       S  NULL     S
```

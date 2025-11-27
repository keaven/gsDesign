# Expected number of events for a time-to-event study

`eEvents()` is used to calculate the expected number of events for a
population with a time-to-event endpoint. It is based on calculations
demonstrated in Lachin and Foulkes (1986) and is fundamental in
computations for the sample size method they propose. Piecewise
exponential survival and dropout rates are supported as well as
piecewise uniform enrollment. A stratified population is allowed. Output
is the expected number of events observed given a trial duration and the
above rate parameters.

`eEvents()` produces an object of class `eEvents` with the number of
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

`print.eEvents()` formats the output for an object of class `eEvents`
and returns the input value.

## Usage

``` r
eEvents(
  lambda = 1,
  eta = 0,
  gamma = 1,
  R = 1,
  S = NULL,
  T = 2,
  Tfinal = NULL,
  minfup = 0,
  digits = 4
)

# S3 method for class 'eEvents'
print(x, digits = 4, ...)
```

## Arguments

- lambda:

  scalar, vector or matrix of event hazard rates; rows represent time
  periods while columns represent strata; a vector implies a single
  stratum.

- eta:

  scalar, vector or matrix of dropout hazard rates; rows represent time
  periods while columns represent strata; if entered as a scalar, rate
  is constant across strata and time periods; if entered as a vector,
  rates are constant across strata.

- gamma:

  a scalar, vector or matrix of rates of entry by time period (rows) and
  strata (columns); if entered as a scalar, rate is constant across
  strata and time periods; if entered as a vector, rates are constant
  across strata.

- R:

  a scalar or vector of durations of time periods for recruitment rates
  specified in rows of `gamma`. Length is the same as number of rows in
  `gamma`. Note that the final enrollment period is extended as long as
  needed.

- S:

  a scalar or vector of durations of piecewise constant event rates
  specified in rows of `lambda`, `eta` and `etaE`; this is NULL if there
  is a single event rate per stratum (exponential failure) or length of
  the number of rows in `lambda` minus 1, otherwise.

- T:

  time of analysis; if `Tfinal=NULL`, this is also the study duration.

- Tfinal:

  Study duration; if `NULL`, this will be replaced with `T` on output.

- minfup:

  time from end of planned enrollment (`sum(R)` from output value of
  `R`) until `Tfinal`.

- digits:

  which controls number of digits for printing.

- x:

  an object of class `eEvents` returned from `eEvents()`.

- ...:

  Other arguments that may be passed to the generic print function.

## Value

`eEvents()` and `print.eEvents()` return an object of class `eEvents`
which contains the following items:

- lambda:

  as input; converted to a matrix on output.

- eta:

  as input; converted to a matrix on output.

- gamma:

  as input.

- R:

  as input.

- S:

  as input.

- T:

  as input.

- Tfinal:

  planned duration of study.

- minfup:

  as input.

- d:

  expected number of events.

- n:

  expected sample size.

- digits:

  as input.

## References

Lachin JM and Foulkes MA (1986), Evaluation of Sample Size and Power for
Analyses of Survival with Allowance for Nonuniform Patient Entry, Losses
to Follow-Up, Noncompliance, and Stratification. *Biometrics*, 42,
507-519.

Bernstein D and Lagakos S (1978), Sample size and power determination
for stratified clinical trials. *Journal of Statistical Computation and
Simulation*, 8:65-73.

## See also

[`vignette("gsDesignPackageOverview")`](https://keaven.github.io/gsDesign/articles/gsDesignPackageOverview.md),
[plot.gsDesign](https://keaven.github.io/gsDesign/reference/plot.gsDesign.md),
[`gsDesign`](https://keaven.github.io/gsDesign/reference/gsDesign.md),
[`gsHR`](https://keaven.github.io/gsDesign/reference/gsBoundSummary.md),
[`nSurvival`](https://keaven.github.io/gsDesign/reference/nSurvival.md)

## Author

Keaven Anderson <keaven_anderson@merck.com>

## Examples

``` r
# 3 enrollment periods, 3 piecewise exponential failure rates
str(eEvents(
  lambda = c(.05, .02, .01), eta = .01, gamma = c(5, 10, 20),
  R = c(2, 1, 2), S = c(1, 1), T = 20
))
#> List of 11
#>  $ lambda: num [1:3, 1] 0.05 0.02 0.01
#>   ..- attr(*, "dimnames")=List of 2
#>   .. ..$ : chr [1:3] "0-1" "1-2" "2-20"
#>   .. ..$ : chr "Stratum 1"
#>  $ eta   : num [1:3, 1] 0.01 0.01 0.01
#>   ..- attr(*, "dimnames")=List of 2
#>   .. ..$ : chr [1:3] "0-1" "1-2" "2-20"
#>   .. ..$ : chr "Stratum 1"
#>  $ gamma : num [1:3, 1] 5 10 20
#>   ..- attr(*, "dimnames")=List of 2
#>   .. ..$ : chr [1:3] "0-2" "2-3" "3-5"
#>   .. ..$ : chr "Stratum 1"
#>  $ R     : num [1:3] 2 1 2
#>  $ S     : num [1:2] 1 1
#>  $ T     : num 20
#>  $ Tfinal: num 20
#>  $ minfup: num 0
#>  $ d     : num 11
#>  $ n     : num 60
#>  $ digits: num 4
#>  - attr(*, "class")= chr "eEvents"

# control group for example from Bernstein and Lagakos (1978)
lamC <- c(1, .8, .5)
n <- eEvents(
  lambda = matrix(c(lamC, lamC * 2 / 3), ncol = 6), eta = 0,
  gamma = matrix(.5, ncol = 6), R = 2, T = 4
)
```

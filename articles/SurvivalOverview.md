# Overview of survival endpoint design

## Introduction

This article/vignette provides a summary of functions in the
***gsDesign*** package supporting design and evaluation of trial designs
for time-to-event outcomes. We do not focus on detailed output options,
but what numbers summarizing the design are based on. If you are not
looking for this level of detail and just want to see how to design a
fixed or group sequential design for a time-to-event endpoint, see the
vignette *Basic time-to-event group sequential design using gsSurv*.

The following functions support use of the very straightforward
Schoenfeld (1981) approximation for 2-arm trials:

- [`nEvents()`](https://keaven.github.io/gsDesign/reference/nSurvival.md):
  number of events to achieve power or power given number of events with
  no interim analysis.
- [`zn2hr()`](https://keaven.github.io/gsDesign/reference/nSurvival.md):
  approximate the observed hazard ratio (HR) required to achieve a
  targeted Z-value for a given number of events.
- [`hrn2z()`](https://keaven.github.io/gsDesign/reference/nSurvival.md):
  approximate Z-value corresponding to a specified HR and event count.
- [`hrz2n()`](https://keaven.github.io/gsDesign/reference/nSurvival.md):
  approximate event count corresponding to a specified HR and Z-value.

The above functions do not directly support sample size calculations.
This is done with the Lachin and Foulkes (1986) method. Functions
include:

- [`nSurv()`](https://keaven.github.io/gsDesign/reference/nSurv.md):
  More flexible enrollment scenarios; single analysis.
- [`gsSurv()`](https://keaven.github.io/gsDesign/reference/nSurv.md):
  Group sequential design extension of
  [`nSurv()`](https://keaven.github.io/gsDesign/reference/nSurv.md).
- [`nSurvival()`](https://keaven.github.io/gsDesign/reference/nSurvival.md):
  Sample size restricted to single enrollment rate, single analysis;
  this has been effectively replaced and generalized by
  [`nSurv()`](https://keaven.github.io/gsDesign/reference/nSurv.md) and
  [`gsSurv()`](https://keaven.github.io/gsDesign/reference/nSurv.md).

Output for survival design information is supported in various formats:

- [`gsBoundSummary()`](https://keaven.github.io/gsDesign/reference/gsBoundSummary.md):
  Tabular summary of a design in a data frame.
- [`plot.gsDesign()`](https://keaven.github.io/gsDesign/reference/plot.gsDesign.md):
  Various plot summaries of a design.
- [`gsHR()`](https://keaven.github.io/gsDesign/reference/gsBoundSummary.md):
  Approximate HR required to cross a bound.

## Schoenfeld approximation support

We will assume a hazard ratio \\\nu \< 1\\ represents a benefit of
experimental treatment over control. We let \\\delta = \log\nu\\ denote
the so-called *natural parameter* for this case. Asymptotically the
distribution of the Cox model estimate \\\hat{\delta}\\ under the
proportional hazards assumption is (Schoenfeld (1981)) \\\hat\delta\sim
\text{Normal}(\delta=\log\nu, (1+r)^2/nr).\\ The inverse of the variance
is the statistical information: \\\mathcal I = nr/(1 + r)^2.\\ Using a
Cox model to estimate \\\delta\\, the Wald test for \\\text{H}\_0:
\delta=0\\ can be approximated with the asymptotic variance from above
as:

\\Z_W\approx \frac{\sqrt
{nr}}{1+r}\hat\delta=\frac{\ln(\hat\nu)\sqrt{nr}}{1+r}.\\

Also, we know that the Wald test \\Z_W\\ and a standard normal version
of the logrank \\Z\\ are both asymptotically efficient and therefore
asymptotically equivalent, at least under a local hypothesis framework.
We denote the *standardized effect size* as

\\\theta = \delta\sqrt r / (1+r)= \log(\nu)\sqrt r / (1+r).\\ Letting
\\\hat\theta = -\sqrt r/(1+r)\hat\delta\\ and \\n\\ representing the
number of events observed, we have \\\hat \theta \sim
\text{Normal}(\theta, 1/ n).\\ Thus, the standardized Z version of the
logrank is approximately distributed as

\\Z\sim\text{Normal}(\sqrt n\theta,1).\\ Treatment effect favoring
experimental treatment compared to control in this notation corresponds
to a hazard ratio \\\nu \< 1\\, as well as negative values of the
standardized effect \\\theta\\, natural parameter \\\delta\\ and
standardized Z-test.

### Power and sample size with `nEvents()`

Based on the above, the power for the logrank test when \\n\\ events
have been observed is approximated by

\\P\[Z\le z\]=\Phi(z -\sqrt n\theta)=\Phi(z- \sqrt{nr}/(1+r)\log\nu).\\
Thus, assuming \\n=100\\ events and \\\delta = \log\nu=-\log(.7)\\, and
\\r=1\\ (equal randomization) we approximate power for the logrank test
when \\\alpha=0.025\\ as

``` r
n <- 100
hr <- .7
delta <- log(hr)
alpha <- .025
r <- 1
pnorm(qnorm(alpha) - sqrt(n * r) / (1 + r) * delta)
#> [1] 0.4299155
```

We can compute this with
[`gsDesign::nEvents()`](https://keaven.github.io/gsDesign/reference/nSurvival.md)
as:

``` r
nEvents(n = n, alpha = alpha, hr = hr, r = r)
#> [1] 0.4299155
```

We solve for the number of events \\n\\ to see how many events are
required to obtain a desired power

\\1-\beta=P(Z\ge \Phi^{-1}(1-\alpha))\\ with

\\n = \left(\frac{\Phi^{-1}
(1-\alpha)+\Phi^{-1}(1-\beta)}{\theta}\right)^2
=\frac{(1+r)^2}{r(\log\nu)^2}\left({\Phi^{-1}
(1-\alpha)+\Phi^{-1}(1-\beta)}\right)^2.\\ Thus, the approximate number
of events required to power for HR=0.7 with \\\alpha=0.025\\ one-sided
and power \\1-\beta=0.9\\ is

``` r
beta <- 0.1
(1 + r)^2 / r / log(hr)^2 * ((qnorm(1 - alpha) + qnorm(1 - beta)))^2
#> [1] 330.3779
```

which, rounding up, matches (with tabular output):

``` r
nEvents(hr = hr, alpha = alpha, beta = beta, r = 1, tbl = TRUE) |>
  kable()
```

|  hr |   n | alpha | sided | beta | Power |     delta | ratio | hr0 |        se |
|----:|----:|------:|------:|-----:|------:|----------:|------:|----:|----------:|
| 0.7 | 331 | 0.025 |     1 |  0.1 |   0.9 | 0.1783375 |     1 |   1 | 0.1099299 |

The notation `delta` in the above table changes the sign for the
standardized treatment effect \\\theta\\ in the above:

``` r
theta <- delta * sqrt(r) / (1 + r)
theta
#> [1] -0.1783375
```

The `se` in the table is the estimated standard error for the log hazard
ratio \\\delta=\log\hat\nu\\

``` r
(1 + r) / sqrt(331 * r)
#> [1] 0.1099299
```

### Group sequential design

We can create a group sequential design for the above problem either
with \\\theta\\ or with the fixed design sample size. The parameter
`delta` in
[`gsDesign()`](https://keaven.github.io/gsDesign/reference/gsDesign.md)
corresponds to standardized effect size with sign changed \\-\theta\\ in
notation used above and by Jennison and Turnbull (2000), while the
natural parameter, \\\log(\text{HR})\\ is in the parameter `delta1`
passed to
[`gsDesign()`](https://keaven.github.io/gsDesign/reference/gsDesign.md).
The name of the effect size is specified in `deltaname` and the
parameter `logdelta = TRUE` indicates that `delta` input needs to be
exponentiated to obtain HR in the output below. This example code can be
useful in practice. We begin by passing the number of events for a fixed
design in the parameter `n.fix` (continuous, not rounded) to adapt to a
group sequential design. By rounding to integer event counts with the
[`toInteger()`](https://keaven.github.io/gsDesign/reference/toInteger.md)
function we increase the power slightly over the targeted 90%.

``` r
Schoenfeld <- gsDesign(
  k = 2,
  n.fix = nEvents(hr = hr, alpha = alpha, beta = beta, r = 1),
  delta1 = log(hr)
) |> toInteger()
#> toInteger: rounding done to nearest integer since ratio was not specified as postive integer .
Schoenfeld |>
  gsBoundSummary(deltaname = "HR", logdelta = TRUE, Nname = "Events") |>
  kable(row.names = FALSE)
```

| Analysis    | Value              | Efficacy | Futility |
|:------------|:-------------------|---------:|---------:|
| IA 1: 50%   | Z                  |   2.7522 |   0.4084 |
| Events: 172 | p (1-sided)        |   0.0030 |   0.3415 |
|             | ~HR at bound       |   0.6572 |   0.9396 |
|             | P(Cross) if HR=1   |   0.0030 |   0.6585 |
|             | P(Cross) if HR=0.7 |   0.3397 |   0.0268 |
| Final       | Z                  |   1.9810 |   1.9810 |
| Events: 345 | p (1-sided)        |   0.0238 |   0.0238 |
|             | ~HR at bound       |   0.8079 |   0.8079 |
|             | P(Cross) if HR=1   |   0.0239 |   0.9761 |
|             | P(Cross) if HR=0.7 |   0.9004 |   0.0996 |

### Information based design

Exactly the same result can be obtained with the following, passing the
standardized effect size `theta` from above to the parameter `delta` in
[`gsDesign()`](https://keaven.github.io/gsDesign/reference/gsDesign.md).

``` r
Schoenfeld <- gsDesign(k = 2, delta = -theta, delta1 = log(hr)) |> toInteger()
```

We noted above that the asymptotic variance for \\\hat\theta\\ is
\\1/n\\ which corresponds to statistical information \\\mathcal I=n\\
for the parameter \\\theta\\. Thus, the value

``` r
Schoenfeld$n.I
#> [1] 172 345
```

corresponds both to the number of events and the statistical information
for the standardized effect size \\\theta\\ required to power the trial
at the desired level. Note that if you plug in the natural parameter
\\\delta= -\log\nu \> 0\\, then \\n.I\\ returns the statistical
information for the log hazard ratio.

``` r
gsDesign(k = 2, delta = -log(hr))$n.I
#> [1] 43.06893 86.13786
```

The reader may wish to look above to derive the exact relationship
between events and statistical information for \\\delta\\.

### Approximating boundary characteristics

Another application of the Schoenfeld (1981) method is to approximate
boundary characteristics of a design. We will consider
[`zn2hr()`](https://keaven.github.io/gsDesign/reference/nSurvival.md),
[`gsHR()`](https://keaven.github.io/gsDesign/reference/gsBoundSummary.md)
and
[`gsBoundSummary()`](https://keaven.github.io/gsDesign/reference/gsBoundSummary.md)
to approximate the treatment effect required to cross design bounds.
[`zn2hr()`](https://keaven.github.io/gsDesign/reference/nSurvival.md) is
complemented by the functions
[`hrn2z()`](https://keaven.github.io/gsDesign/reference/nSurvival.md)
and
[`hrz2n()`](https://keaven.github.io/gsDesign/reference/nSurvival.md).
We begin with the basic approximation used across all of these functions
in this section and follow with a sub-section with example code to
reproduce some of what is in the table above.

We return to the following equation from above:

\\Z\approx Z_W\approx \frac{\sqrt
{nr}}{1+r}\hat\delta=\frac{\ln(\hat\nu)\sqrt{nr}}{1+r}.\\ By fixing
\\Z=z, n\\ we can solve for \\\hat\nu\\ from the above:

\\\hat{\nu} = \exp(z(1+r)/\sqrt{rn}).\\ By fixing \\\hat\nu\\ and \\z\\,
we can solve for the corresponding number of events required: \\ n =
(z(1+r)/\log(\hat{\nu}))^2/r.\\

### Examples

We continue with the `Schoenfeld` example event counts:

``` r
Schoenfeld$n.I
#> [1] 172 345
```

We reproduce the approximate hazard ratios required to cross efficacy
bounds using the Schoenfeld approximations above:

``` r
gsHR(
  z = Schoenfeld$upper$bound, # Z-values at bound
  i = 1:2, # Analysis number
  x = Schoenfeld, # Group sequential design from above
  ratio = r # Experimental/control randomization ratio
)
#> [1] 0.6572433 0.8079049
```

For the following examples, we assume \\r=1\\.

``` r
r <- 1
```

1.  Assuming a Cox model estimate \\\hat\nu\\ and a corresponding event
    count, approximately what Z-value (p-value) does this correspond to?
    We use the first equation above:

``` r
hr <- .73 # Observed hr
events <- 125 # Events in analysis

z <- log(hr) * sqrt(events * r) / (1 + r)
c(z, pnorm(z)) # Z- and p-value
#> [1] -1.75928655  0.03926443
```

We replicate the Z-value with

``` r
hrn2z(hr = hr, n = events, ratio = r)
#> [1] 1.759287
```

2.  Assuming an efficacy bound Z-value and event count, approximately
    what hazard ratio must be observed to cross the bound? We use the
    second equation above:

``` r
z <- qnorm(.025)
events <- 120
exp(z * (1 + r) / sqrt(r * events))
#> [1] 0.6991858
```

We can reproduce this with
[`zn2hr()`](https://keaven.github.io/gsDesign/reference/nSurvival.md) by
switching the sign of `z` above; note that the default is `ratio = 1`
for all of these functions and often is not specified:

``` r
zn2hr(z = -z, n = events, ratio = r)
#> [1] 0.6991858
```

3.  Finally, if we want an observed hazard ratio \\\hat\nu = .8\\ to
    represent a positive result, how many events would be need to
    observe to achieve a 1-sided p-value of 0.025? assuming 2:1
    randomization? We use the third equation above:

``` r
r <- 2
hr <- .8
z <- qnorm(.025)
events <- (z * (1 + r) / log(hr))^2 / r
events
#> [1] 347.1683
```

This is replicated with

``` r
hrz2n(hr = hr, z = z, ratio = r)
#> [1] 347.1683
```

## Lachin and Foulkes design

For the purpose of sample size and power for group sequential design,
the Lachin and Foulkes (1986) is recommended based on substantial
evaluation not documented further here. We try to make clear here what
some of the strengths and weaknesses of both the Lachin and Foulkes
(1986) method as well as its implementation in the
[`gsDesign::nSurv()`](https://keaven.github.io/gsDesign/reference/nSurv.md)
(fixed design) and
[`gsDesign::gsSurv()`](https://keaven.github.io/gsDesign/reference/nSurv.md)
(group sequential) functions. For historical and testing purposes, we
also discuss use of the less flexible
[`gsDesign::nSurvival()`](https://keaven.github.io/gsDesign/reference/nSurvival.md)
function that was independently programmed and can be used for some
limited validations of
[`gsDesign::nSurv()`](https://keaven.github.io/gsDesign/reference/nSurv.md).

### Model assumptions

Some detail in specification comes With the flexibility allowed by the
Lachin and Foulkes (1986) method. The model assumes

- Piecewise constant enrollment rates with a target fixed duration of
  enrollment; since inter-arrival times follow a Poisson process, the
  actual enrollment time to achieve the targeted enrollment is random.
- A fixed minimum follow-up period.
- Piecewise exponential failure rates for the control group.
- A single, constant hazard ratio for the experimental group relative to
  the control group.
- Piecewise exponential loss-to-follow-up rates.
- A stratified population.
- A fixed randomization ratio of experimental to control group
  assignment.

Other than the proportional hazards assumption, this allows a great deal
of flexibility in trial design assumptions. While Lachin and Foulkes
(1986) adjusts the piecewise constant enrollment rates proportionately
to derive a sample size,
[`gsDesign::nSurv()`](https://keaven.github.io/gsDesign/reference/nSurv.md)
also enables the approach of Kim and Tsiatis (1990) which fixes
enrollment rates and extends the final enrollment rate duration to power
the trial; the minimum follow-up period is still assumed with this
approach. We do not enable the drop-in option proposed in Lachin and
Foulkes (1986).

The two practical differences the Lachin and Foulkes (1986) method has
from the Schoenfeld (1981) method are:

1.  By assuming enrollment, failure and dropout rates the method
    delivers sample size \\N\\ as well as events required.
2.  The variance for the log hazard ratio \\\hat\delta\\ is computed
    differently and both a null (\\\sigma^2_0\\) and alternate
    hypothesis (\\\sigma^2_1\\) variance are incorporated through the
    formula \\N = \left(\frac{\Phi^{-1}(1-\alpha)\sigma_0 +
    \Phi^{-1}(1-\beta)\sigma_1}{\delta}\right).\\ The null hypothesis is
    derived by averaging the alternate hypothesis rates, weighting
    according to the proportion randomized in each group.

### Fixed design

We will use the same hazard ratio 0.7 as for the Schoenfeld (1981)
sample size calculations above. We assume further that the trial will
enroll for a constant rate for 12 months, have a control group median of
8 months (exponential failure rate \\\lambda = \log(2)/8\\), a dropout
rate of 0.001 per month, and 16 months of minimum follow-up. As before,
we assume a randomization ratio \\r=1\\, one-sided Type I error
\\\alpha=0.025\\, 90% power which is equivalent to Type II error
\\\beta=0.1\\.

``` r
r <- 1 # Experimental/control randomization ratio
alpha <- 0.025 # 1-sided Type I error
beta <- 0.1 # Type II error (1 - power)
hr <- 0.7 # Hazard ratio (experimental / control)
controlMedian <- 8
dropoutRate <- 0.001 # Exponential dropout rate per time unit
enrollDuration <- 12
minfup <- 16 # Minimum follow-up
Nlf <- nSurv(
  lambdaC = log(2) / controlMedian,
  hr = hr,
  eta = dropoutRate,
  T = enrollDuration + minfup, # Trial duration
  minfup = minfup,
  ratio = r,
  alpha = alpha,
  beta = beta
)
cat(paste("Sample size: ", ceiling(Nlf$n), "Events: ", ceiling(Nlf$d), "\n"))
#> Sample size:  422 Events:  330
```

Recall that the Schoenfeld (1981) method recommended 331 events. The two
methods tend to yield very similar event count recommendations, but not
the same. Other methods will also differ slightly; see Lachin and
Foulkes (1986). Sample size recommendations can vary more between
methods.

We can get the same result with the
[`nSurvival()`](https://keaven.github.io/gsDesign/reference/nSurvival.md)
routine since only a single enrollment, failure and dropout rate is
proposed for this example.

``` r
lambda1 <- log(2) / controlMedian
nSurvival(
  lambda1 = lambda1,
  lambda2 = lambda1 * hr,
  Ts = enrollDuration + minfup,
  Tr = enrollDuration,
  eta = dropoutRate,
  ratio = r,
  alpha = alpha,
  beta = beta
)
#> Fixed design, two-arm trial with time-to-event
#> outcome (Lachin and Foulkes, 1986).
#> Study duration (fixed):          Ts=28
#> Accrual duration (fixed):        Tr=12
#> Uniform accrual:              entry="unif"
#> Control median:      log(2)/lambda1=8
#> Experimental median: log(2)/lambda2=11.4
#> Censoring median:        log(2)/eta=693.1
#> Control failure rate:       lambda1=0.087
#> Experimental failure rate:  lambda2=0.061
#> Censoring rate:                 eta=0.001
#> Power:                 100*(1-beta)=90%
#> Type I error (1-sided):   100*alpha=2.5%
#> Equal randomization:          ratio=1
#> Sample size based on hazard ratio=0.7 (type="rr")
#> Sample size (computed):           n=422
#> Events required (computed): nEvents=330
```

### Group sequential design

Now we produce a group sequential design with a default asymmetric
design with a futility bound based on \\\beta\\-spending. We round
interim event counts and round up the final event count to ensure the
targeted power.

``` r
k <- 2 # Total number of analyses
lfgs <- gsSurv(
  k = 2,
  lambdaC = log(2) / controlMedian,
  hr = hr,
  eta = dropoutRate,
  T = enrollDuration + minfup, # Trial duration
  minfup = minfup,
  ratio = r,
  alpha = alpha,
  beta = beta
) |> toInteger()
lfgs |>
  gsBoundSummary() |>
  kable(row.names = FALSE)
```

| Analysis    | Value              | Efficacy | Futility |
|:------------|:-------------------|---------:|---------:|
| IA 1: 50%   | Z                  |   2.7500 |   0.4150 |
| N: 440      | p (1-sided)        |   0.0030 |   0.3391 |
| Events: 172 | ~HR at bound       |   0.6575 |   0.9387 |
| Month: 13   | P(Cross) if HR=1   |   0.0030 |   0.6609 |
|             | P(Cross) if HR=0.7 |   0.3422 |   0.0269 |
| Final       | Z                  |   1.9811 |   1.9811 |
| N: 440      | p (1-sided)        |   0.0238 |   0.0238 |
| Events: 344 | ~HR at bound       |   0.8076 |   0.8076 |
| Month: 28   | P(Cross) if HR=1   |   0.0239 |   0.9761 |
|             | P(Cross) if HR=0.7 |   0.9006 |   0.0994 |

Although we did not use the Schoenfeld (1981) for sample size, it is
still used for the approximate HR at bound calculation above:

``` r
events <- lfgs$n.I
z <- lfgs$upper$bound
zn2hr(z = z, n = events) # Schoenfeld approximation to HR
#> [1] 0.6574636 0.8076464
```

### Plotting

There are various plots available. The approximate hazard ratios
required to cross bounds again use the Schoenfeld (1981) approximation.
For a **ggplot2** version of this plot, use the default `base = FALSE`.

``` r
plot(lfgs, pl = "hr", dgt = 2, base = TRUE)
```

![](SurvivalOverview_files/figure-html/unnamed-chunk-26-1.svg)

### Event accrual

The variance calculations for the Lachin and Foulkes method are mostly
determined by expected event accrual under the null and alternate
hypotheses. The null hypothesis characterized above is seemingly
designed so that event accrual will be similar under each hypothesis.
You can see the expected events accrued at each analysis under the
alternate hypothesis with:

``` r
tibble::tibble(
  Analysis = 1:2,
  `Control events` = lfgs$eDC,
  `Experimental events` = lfgs$eDE
) |>
  kable()
```

| Analysis | Control events | Experimental events |
|---------:|---------------:|--------------------:|
|        1 |       97.04664 |            74.95336 |
|        2 |      184.48403 |           159.51599 |

It is worth noting that if events accrue at the same rate in both the
null and alternate hypothesis, then the expected duration of time to
achieve the targeted events would be shortened. Keep in mind that there
can be many reasons events will accrue at a different rate than in the
design plan.

The expected event accrual of events over time for a design can be
computed as follows:

``` r
Month <- seq(0.025, enrollDuration + minfup, .025)
plot(
  c(0, Month),
  c(0, sapply(Month, function(x) {
    nEventsIA(tIA = x, x = lfgs)
  })),
  type = "l", xlab = "Month", ylab = "Expected events",
  main = "Expected event accrual over time"
)
```

![](SurvivalOverview_files/figure-html/unnamed-chunk-28-1.svg)

On the other hand, if you want to know the expected time to accrue 25%
of the final events and what the expected enrollment accrual is at that
time, you compute using:

``` r
b <- tEventsIA(x = lfgs, timing = 0.25)
cat(paste(
  " Time: ", round(b$T, 1),
  "\n Expected enrollment:", round(b$eNC + b$eNE, 1),
  "\n Expected control events:", round(b$eDC, 1),
  "\n Expected experimental events:", round(b$eDE, 1), "\n"
))
#>  Time:  8.9 
#>  Expected enrollment: 325.7 
#>  Expected control events: 49.1 
#>  Expected experimental events: 36.9
```

For expected accrual of events without a design returned by
[`gsDesign::gsSurv()`](https://keaven.github.io/gsDesign/reference/nSurv.md),
see the help file for
[`gsDesign::eEvents()`](https://keaven.github.io/gsDesign/reference/eEvents.md).

## References

Jennison, Christopher, and Bruce W. Turnbull. 2000. *Group Sequential
Methods with Applications to Clinical Trials*. Boca Raton, FL: Chapman;
Hall/CRC.

Kim, Kyungmann, and Anastasios A. Tsiatis. 1990. “Study Duration for
Clinical Trials with Survival Response and Early Stopping Rule.”
*Biometrics* 46: 81–92.

Lachin, John M., and Mary A. Foulkes. 1986. “Evaluation of Sample Size
and Power for Analyses of Survival with Allowance for Nonuniform Patient
Entry, Losses to Follow-up, Noncompliance, and Stratification.”
*Biometrics* 42: 507–19.

Schoenfeld, David. 1981. “The Asymptotic Properties of Nonparametric
Tests for Comparing Survival Distributions.” *Biometrika* 68 (1):
316–19.

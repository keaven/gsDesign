# Futility and harm bounds for overall survival monitoring

## Introduction

When clinical trials include overall survival (OS) as a secondary or
exploratory endpoint, regulators may recommend not only monitoring for
early evidence of efficacy and futility, but also for potential *harm* —
that is, evidence that the experimental treatment may be *worsening*
survival relative to control. This article demonstrates how the
**gsDesign** package supports group sequential designs with three
boundaries: an **efficacy** (upper) bound, a **futility** (lower) bound,
and a **harm** bound, using `test.type = 7` (binding) and
`test.type = 8` (non-binding).

### Regulatory context: FDA guidance on OS monitoring in oncology

The FDA draft guidance *Assessment of Overall Survival Evidence in
Support of Accelerated Approval of Oncology Therapeutics* (U.S. Food and
Drug Administration 2024) describes expectations for monitoring OS in
the context of trials that may receive accelerated approval based on
surrogate endpoints. The guidance states that sponsors should specify
pre-planned boundaries for interim OS monitoring, including criteria for
stopping a trial early if there is evidence of a *detrimental effect on
OS*. Key points include:

- Sponsors should include a **pre-specified statistical analysis plan**
  for interim OS analyses, including the timing and number of interim
  looks.
- At a minimum, the guidance expects monitoring for **OS harm** (i.e., a
  detrimental trend in overall survival) using pre-specified boundaries.
- Separate from the harm boundary, the sponsor should establish a
  **futility boundary** to stop the trial if the experimental treatment
  is unlikely to demonstrate an OS benefit.
- The statistical plan should describe the spending functions used for
  each boundary and how the overall Type I error and Type II error are
  controlled.

This motivates the design framework with `test.type = 7` (binding
futility and harm bounds) and `test.type = 8` (non-binding futility and
harm bounds), where three boundaries are simultaneously specified using
spending functions.

The harm bound implemented in gsDesign is a new method that is easy to
use — a principled, straightforward extension of the widely used group
sequential spending function framework. While we believe this approach
is understandable, useful, and flexible, other methods for monitoring
potential harm may also be considered. However, there are limitations
with this approach. The example presented here has higher mortality risk
than many cases. With lower mortality risk, modifications of this
approach or other approaches may be preferable.

### Design framework overview

In a standard two-sided asymmetric group sequential design
(`test.type = 3` or `4`), there are two boundaries:

- **Efficacy (upper) bound**: Reject \\H_0\\ if the test statistic
  exceeds this boundary (evidence of treatment benefit).
- **Futility (lower) bound**: Stop for futility if the test statistic
  falls below this boundary (insufficient evidence of treatment
  benefit).

The harm bound extension (`test.type = 7` or `8`) adds a third boundary:

- **Harm bound**: Signal that the experimental treatment may be harming
  patients (evidence of a *detrimental* effect).

The harm bound lies below the futility bound. At each analysis, there
are four possible outcomes:

1.  **Cross the efficacy bound** (above): Stop for efficacy.
2.  **Between the efficacy and futility bounds**: Continue the trial.
3.  **Cross the futility bound but not the harm bound** (between
    futility and harm): Stop for futility.
4.  **Cross the harm bound** (below): Stop for harm.

The harm bound is intended so that if a small observed p-value *favoring
control* is observed, the harm bound will be crossed. That is, the harm
bound flags evidence that the experimental treatment may be *worsening*
survival — a negative treatment effect on the log hazard ratio scale.

## Design with non-binding bounds (`test.type = 8`)

We demonstrate a survival design using
[`gsSurvCalendar()`](https://keaven.github.io/gsDesign/reference/gsSurvCalendar.md)
with `test.type = 8` (non-binding futility and harm bounds). The
scenario is based on a 1:1 randomized trial monitoring overall survival
with:

- **Median control survival**: 3 years (36 months), i.e., \\\lambda_C =
  \log(2)/36\\.
- **Target hazard ratio**: HR = 0.75 (25% reduction in hazard).
- **Power**: 90% (\\\beta = 0.1\\).
- **One-sided \\\alpha\\**: 0.0125 (e.g., the OS component of a trial
  with multiplicity adjustment).
- **Enrollment**: Uniform enrollment over 18 months.
- **Study duration**: 5 years (60 months) with planned analyses at years
  1, 2, 3, 4, and 5 from start of enrollment.

The `astar` parameter controls the total spending for the harm bound
under \\H_0\\. We set `astar = 0.1`, meaning the total probability of
crossing the harm bound under \\H_0\\ is 10%.

### Spending function specification

We specify:

- **Efficacy bound**: Lan-DeMets O’Brien-Fleming (`sfLDOF`) spending
  function (conservative, spending little \\\alpha\\ at early analyses).
- **Futility bound**: Hwang-Shih-DeCani (HSD) spending function with
  \\\gamma = -2\\ (moderate \\\beta\\-spending under \\H_1\\).
- **Harm bound**: Lan-DeMets Pocock (`sfLDPocock`) spending function
  (spending under \\H_0\\ for detecting harm).

``` r
x8 <- gsSurvCalendar(
  test.type = 8,
  alpha = 0.0125,
  beta = 0.1,
  astar = 0.1,
  calendarTime = c(12, 24, 36, 48, 60),
  sfu = sfLDOF,
  sfl = sfHSD, sflpar = -2,
  sfharm = sfLDPocock,
  lambdaC = log(2) / 36,
  hr = 0.75,
  R = 18,
  minfup = 42
)
```

### Summary

The [`summary()`](https://rdrr.io/r/base/summary.html) method provides a
concise description of the design:

``` r
cat(strwrap(summary(x8), width = 65), sep = "\n")
#> Asymmetric two-sided group sequential design with non-binding
#> futility and harm bounds, 5 analyses, time-to-event outcome with
#> sample size 1148 and 657 events required, 90 percent power, 1.25
#> percent (1-sided) Type I error to detect a hazard ratio of 0.75.
#> Enrollment and total study durations are assumed to be 18 and 60
#> months, respectively. Efficacy bounds derived using a Lan-DeMets
#> O'Brien-Fleming approximation spending function (no parameters).
#> Futility bounds derived using a Hwang-Shih-DeCani spending
#> function with gamma = -2. Harm bounds derived using a Lan-DeMets
#> Pocock approximation spending function.
```

### Detailed boundary table

The
[`gsBoundSummary()`](https://keaven.github.io/gsDesign/reference/gsBoundSummary.md)
function produces a tabular summary with columns for each boundary. By
default, `B-value`, `Spending`, `CP`, `CP H1`, and `PP` are excluded. We
note that for the first interim analysis, the efficacy bound is so
extreme it is effectively impossible to cross. However, the harm and
futility bounds are more moderate, allowing for early stopping if there
is evidence of harm or futility. The futility bound is an indicator of
why bounds are often non-binding — the futility bound is not intended to
be a strict stopping rule, but rather a signal that the trial may be
unlikely to succeed if it continues. Crossing the harm bound is a
stronger indication that the treatment may be harmful, and the trial
should be at least paused with a recommendation to review the safety and
other endpoint data.

``` r
gsBoundSummary(x8)
#> Method: LachinFoulkes 
#>     Analysis               Value    Harm Futility Efficacy
#>    IA 1: 11%                   Z -2.1121  -1.4408   7.4336
#>       N: 766         p (1-sided)  0.9827   0.9252   0.0000
#>   Events: 73        ~HR at bound  1.6434   1.4034   0.1740
#>    Month: 12    P(Cross) if HR=1  0.0173   0.0748   0.0000
#>              P(Cross) if HR=0.75  0.0004   0.0039   0.0000
#>    IA 2: 38%                   Z -1.7667   0.1212   3.8622
#>      N: 1148         p (1-sided)  0.9614   0.4518   0.0001
#>  Events: 253        ~HR at bound  1.2491   0.9849   0.6149
#>    Month: 24    P(Cross) if HR=1  0.0507   0.5554   0.0001
#>              P(Cross) if HR=0.75  0.0004   0.0181   0.0574
#>    IA 3: 63%                   Z -1.7256   1.0566   2.9347
#>      N: 1148         p (1-sided)  0.9578   0.1454   0.0017
#>  Events: 416        ~HR at bound  1.1846   0.9015   0.7497
#>    Month: 36    P(Cross) if HR=1  0.0736   0.8641   0.0017
#>              P(Cross) if HR=0.75  0.0004   0.0398   0.4990
#>    IA 4: 83%                   Z -1.7170   1.7357   2.5278
#>      N: 1148         p (1-sided)  0.9570   0.0413   0.0057
#>  Events: 548        ~HR at bound  1.1580   0.8622   0.8057
#>    Month: 48    P(Cross) if HR=1  0.0890   0.9631   0.0062
#>              P(Cross) if HR=0.75  0.0004   0.0675   0.7996
#>        Final                   Z -1.7149   2.3072   2.3072
#>      N: 1148         p (1-sided)  0.9568   0.0105   0.0105
#>  Events: 657        ~HR at bound  1.1433   0.8352   0.8352
#>    Month: 60    P(Cross) if HR=1  0.1000   0.9888   0.0112
#>              P(Cross) if HR=0.75  0.0004   0.1000   0.9000
```

Conditional power (CP, CP H1) and predictive power (PP) can also be
included in the summary. Below we show the full table with all
statistics, including conditional and predictive power at each boundary:

``` r
gsBoundSummary(x8, exclude = c())
#> Method: LachinFoulkes 
#>     Analysis               Value    Harm Futility Efficacy
#>    IA 1: 11%                   Z -2.1121  -1.4408   7.4336
#>       N: 766         p (1-sided)  0.9827   0.9252   0.0000
#>   Events: 73        ~HR at bound  1.6434   1.4034   0.1740
#>    Month: 12            Spending  0.0173   0.0039   0.0000
#>                          B-value -0.7011  -0.4782   2.4674
#>                               CP  0.0000   0.0000   1.0000
#>                            CP H1  0.4619   0.5942   1.0000
#>                               PP  0.0011   0.0097   1.0000
#>                 P(Cross) if HR=1  0.0173   0.0748   0.0000
#>              P(Cross) if HR=0.75  0.0004   0.0039   0.0000
#>    IA 2: 38%                   Z -1.7667   0.1212   3.8622
#>      N: 1148         p (1-sided)  0.9614   0.4518   0.0001
#>  Events: 253        ~HR at bound  1.2491   0.9849   0.6149
#>    Month: 24            Spending  0.0334   0.0143   0.0001
#>                          B-value -1.0954   0.0751   2.3947
#>                               CP  0.0000   0.0024   1.0000
#>                            CP H1  0.0097   0.4033   0.9994
#>                               PP  0.0000   0.0358   0.9994
#>                 P(Cross) if HR=1  0.0507   0.5554   0.0001
#>              P(Cross) if HR=0.75  0.0004   0.0181   0.0574
#>    IA 3: 63%                   Z -1.7256   1.0566   2.9347
#>      N: 1148         p (1-sided)  0.9578   0.1454   0.0017
#>  Events: 416        ~HR at bound  1.1846   0.9015   0.7497
#>    Month: 36            Spending  0.0229   0.0217   0.0016
#>                          B-value -1.3725   0.8404   2.3343
#>                               CP  0.0000   0.0396   0.9928
#>                            CP H1  0.0000   0.3449   0.9928
#>                               PP  0.0000   0.0776   0.9759
#>                 P(Cross) if HR=1  0.0736   0.8641   0.0017
#>              P(Cross) if HR=0.75  0.0004   0.0398   0.4990
#>    IA 4: 83%                   Z -1.7170   1.7357   2.5278
#>      N: 1148         p (1-sided)  0.9570   0.0413   0.0057
#>  Events: 548        ~HR at bound  1.1580   0.8622   0.8057
#>    Month: 48            Spending  0.0154   0.0277   0.0046
#>                          B-value -1.5689   1.5860   2.3098
#>                               CP  0.0000   0.1578   0.8708
#>                            CP H1  0.0000   0.3906   0.9337
#>                               PP  0.0000   0.1793   0.8485
#>                 P(Cross) if HR=1  0.0890   0.9631   0.0062
#>              P(Cross) if HR=0.75  0.0004   0.0675   0.7996
#>        Final                   Z -1.7149   2.3072   2.3072
#>      N: 1148         p (1-sided)  0.9568   0.0105   0.0105
#>  Events: 657        ~HR at bound  1.1433   0.8352   0.8352
#>    Month: 60            Spending  0.0110   0.0325   0.0062
#>                          B-value -1.7149   2.3072   2.3072
#>                 P(Cross) if HR=1  0.1000   0.9888   0.0112
#>              P(Cross) if HR=0.75  0.0004   0.1000   0.9000
```

### Interpreting the boundaries

The design has five analyses at calendar times of 12, 24, 36, 48, and 60
months. At each analysis, the test statistic (Z-value) is compared
against three boundaries:

``` r
bounds <- data.frame(
  Analysis = 1:x8$k,
  Month = x8$T,
  Events = ceiling(x8$n.I),
  Harm = round(x8$harm$bound, 2),
  Futility = round(x8$lower$bound, 2),
  Efficacy = round(x8$upper$bound, 2)
)
kable(bounds, caption = "Z-value boundaries at each analysis")
```

| Analysis | Month | Events |  Harm | Futility | Efficacy |
|---------:|------:|-------:|------:|---------:|---------:|
|        1 |    12 |     73 | -2.11 |    -1.44 |     7.43 |
|        2 |    24 |    253 | -1.77 |     0.12 |     3.86 |
|        3 |    36 |    416 | -1.73 |     1.06 |     2.93 |
|        4 |    48 |    548 | -1.72 |     1.74 |     2.53 |
|        5 |    60 |    657 | -1.71 |     2.31 |     2.31 |

Z-value boundaries at each analysis

**Decision rules at each analysis:**

- If \\Z \>\\ efficacy bound: Stop for efficacy (reject \\H_0\\).
- If futility bound \\\< Z \leq\\ efficacy bound: Continue the trial.
- If harm bound \\\< Z \leq\\ futility bound: Stop for futility.
- If \\Z \leq\\ harm bound: Stop for harm.

Note that the harm bound is always at or below the futility bound. At
early analyses, the harm and futility bounds may coincide when the harm
spending function has not yet allocated sufficient spending to
differentiate them.

### Boundary crossing probabilities

We examine the operating characteristics under two scenarios: no
treatment effect (HR = 1, i.e., under \\H_0\\) and the design
alternative (HR = 0.75).

``` r
probs <- data.frame(
  Scenario = c(rep("Under H0 (HR=1)", x8$k), rep("Under H1 (HR=0.75)", x8$k)),
  Analysis = rep(1:x8$k, 2),
  Month = rep(x8$T, 2),
  `P(Efficacy)` = c(cumsum(x8$upper$prob[, 1]), cumsum(x8$upper$prob[, 2])),
  `P(Futility)` = c(cumsum(x8$lower$prob[, 1]), cumsum(x8$lower$prob[, 2])),
  `P(Harm)` = c(cumsum(x8$harm$prob[, 1]), cumsum(x8$harm$prob[, 2])),
  check.names = FALSE
)
kable(probs, digits = 4, caption = "Cumulative boundary crossing probabilities")
```

| Scenario           | Analysis | Month | P(Efficacy) | P(Futility) | P(Harm) |
|:-------------------|---------:|------:|------------:|------------:|--------:|
| Under H0 (HR=1)    |        1 |    12 |      0.0000 |      0.0748 |  0.0173 |
| Under H0 (HR=1)    |        2 |    24 |      0.0001 |      0.5554 |  0.0507 |
| Under H0 (HR=1)    |        3 |    36 |      0.0017 |      0.8641 |  0.0736 |
| Under H0 (HR=1)    |        4 |    48 |      0.0062 |      0.9631 |  0.0890 |
| Under H0 (HR=1)    |        5 |    60 |      0.0112 |      0.9888 |  0.1000 |
| Under H1 (HR=0.75) |        1 |    12 |      0.0000 |      0.0039 |  0.0004 |
| Under H1 (HR=0.75) |        2 |    24 |      0.0574 |      0.0181 |  0.0004 |
| Under H1 (HR=0.75) |        3 |    36 |      0.4990 |      0.0398 |  0.0004 |
| Under H1 (HR=0.75) |        4 |    48 |      0.7996 |      0.0675 |  0.0004 |
| Under H1 (HR=0.75) |        5 |    60 |      0.9000 |      0.1000 |  0.0004 |

Cumulative boundary crossing probabilities

Under \\H_0\\, the cumulative probability of crossing the harm bound
across all analyses is approximately 0.1, reflecting the spending
allocated to the harm boundary. Under \\H_1\\ (HR = 0.75), crossing the
harm bound is very unlikely (4^{-4}), since the treatment is beneficial.

### Visualization

All standard [`plot()`](https://rdrr.io/r/graphics/plot.default.html)
types are supported for `test.type = 7` and `8` designs, with a third
line (or set of lines) shown for the harm bound.

#### Z-value boundaries

The default plot shows Z-value boundaries at each analysis. Three
boundaries are displayed: efficacy (upper), futility (lower), and harm
(below futility).

``` r
plot(x8)
```

![Z-value boundaries for non-binding harm bound
design](HarmBound_files/figure-html/unnamed-chunk-9-1.svg)

Z-value boundaries for non-binding harm bound design

#### Boundary crossing probabilities

The power plot (`plottype = 2`) shows cumulative boundary crossing
probabilities as a function of the treatment effect. Three sets of lines
appear: upper bound (cumulative efficacy crossing probability),
1-Futility bound, and 1-Harm bound. The harm lines are above the
futility lines because the probability of crossing the harm bound is
less than or equal to the probability of crossing the futility bound. We
note that when the underlying treatment effect favors control, the high
probability of crossing the harm bound indicates that the harm bound is
sensitive and serves its intended purpose

``` r
plot(x8, plottype = 2)
```

![Boundary crossing probabilities for non-binding harm bound
design](HarmBound_files/figure-html/unnamed-chunk-10-1.svg)

Boundary crossing probabilities for non-binding harm bound design

#### Approximate treatment effect at boundaries

The effect size plot (`plottype = 3`) shows the approximate treatment
effect at each boundary. For survival designs, this is expressed as the
approximate hazard ratio at the boundary.

``` r
plot(x8, plottype = 3)
```

![Approximate treatment effect at
boundaries](HarmBound_files/figure-html/unnamed-chunk-11-1.svg)

Approximate treatment effect at boundaries

#### Conditional power at boundaries

Conditional power (`plottype = 4`) at each interim analysis is shown for
all three boundaries. This is generally not a very useful plot.

``` r
plot(x8, plottype = 4)
```

![Conditional power at
boundaries](HarmBound_files/figure-html/unnamed-chunk-12-1.svg)

Conditional power at boundaries

#### Spending function plot

The spending function plot (`plottype = 5`) shows the three spending
functions: \\\alpha\\ (efficacy), \\\beta\\ (futility), and harm.

``` r
plot(x8, plottype = 5)
```

![Spending functions for non-binding harm bound
design](HarmBound_files/figure-html/unnamed-chunk-13-1.svg)

Spending functions for non-binding harm bound design

#### B-values at boundaries

B-values (`plottype = 7`) are Z-values scaled by \\\sqrt{t}\\ where
\\t\\ is the information fraction. As discussed by Proschan, Lan, and
Wittes (2006), the expected value of B-values increases linearly with
the information fraction under the assumption of a constant treatment
effect (proportional hazards). This linear relationship makes B-values
useful for visual assessment of treatment effect trends across interim
analyses: departures from linearity may suggest non-proportional hazards
or other changes in treatment effect over time. Three boundary lines are
shown: efficacy, futility, and harm.

``` r
plot(x8, plottype = 7)
```

![B-values at
boundaries](HarmBound_files/figure-html/unnamed-chunk-14-1.svg)

B-values at boundaries

## Design with binding bounds (`test.type = 7`)

For `test.type = 7`, both the futility and harm bounds are **binding** —
meaning the computation of the efficacy bound assumes the trial *will*
stop if either bound is crossed. This yields a slightly less
conservative efficacy bound (easier to cross), but at the cost of
inflated Type I error if the stopping rule is not strictly followed.

We first create a binding design with \\\alpha = 0.0125\\ to compare
with the non-binding design above:

``` r
x7 <- gsSurvCalendar(
  test.type = 7,
  alpha = 0.0125,
  beta = 0.1,
  astar = 0.1,
  calendarTime = c(12, 24, 36, 48, 60),
  sfu = sfLDOF,
  sfl = sfHSD, sflpar = -2,
  sfharm = sfLDPocock,
  lambdaC = log(2) / 36,
  hr = 0.75,
  R = 18,
  minfup = 42
)
```

### Comparing binding and non-binding

``` r
comparison <- data.frame(
  Bound = c("Efficacy", "Futility", "Harm"),
  `Binding (type 7)` = c(
    paste(round(x7$upper$bound, 3), collapse = ", "),
    paste(round(x7$lower$bound, 3), collapse = ", "),
    paste(round(x7$harm$bound, 3), collapse = ", ")
  ),
  `Non-binding (type 8)` = c(
    paste(round(x8$upper$bound, 3), collapse = ", "),
    paste(round(x8$lower$bound, 3), collapse = ", "),
    paste(round(x8$harm$bound, 3), collapse = ", ")
  ),
  check.names = FALSE
)
kable(comparison, caption = "Comparison of binding vs. non-binding Z-value boundaries")
```

| Bound    | Binding (type 7)                       | Non-binding (type 8)                   |
|:---------|:---------------------------------------|:---------------------------------------|
| Efficacy | 7.434, 3.862, 2.934, 2.523, 2.248      | 7.434, 3.862, 2.935, 2.528, 2.307      |
| Futility | -1.458, 0.09, 1.016, 1.689, 2.248      | -1.441, 0.121, 1.057, 1.736, 2.307     |
| Harm     | -2.112, -1.767, -1.726, -1.717, -1.715 | -2.112, -1.767, -1.726, -1.717, -1.715 |

Comparison of binding vs. non-binding Z-value boundaries

Note that the efficacy bounds for `test.type = 7` (binding) are slightly
lower (easier to cross) than for `test.type = 8` (non-binding). The
maximum number of events for `test.type = 7` (639) is also slightly
smaller than for `test.type = 8` (657), reflecting the assumption that
the trial will stop at the lower bounds.

``` r
gsBoundSummary(x7)
#> Method: LachinFoulkes 
#>     Analysis               Value    Harm Futility Efficacy
#>    IA 1: 11%                   Z -2.1121  -1.4578   7.4336
#>       N: 746         p (1-sided)  0.9827   0.9275   0.0000
#>   Events: 71        ~HR at bound  1.6550   1.4158   0.1698
#>    Month: 12    P(Cross) if HR=1  0.0173   0.0725   0.0000
#>              P(Cross) if HR=0.75  0.0005   0.0039   0.0000
#>    IA 2: 38%                   Z -1.7667   0.0895   3.8622
#>      N: 1118         p (1-sided)  0.9614   0.4643   0.0001
#>  Events: 246        ~HR at bound  1.2531   0.9886   0.6107
#>    Month: 24    P(Cross) if HR=1  0.0507   0.5430   0.0001
#>              P(Cross) if HR=0.75  0.0005   0.0181   0.0539
#>    IA 3: 63%                   Z -1.7256   1.0159   2.9344
#>      N: 1118         p (1-sided)  0.9578   0.1548   0.0017
#>  Events: 404        ~HR at bound  1.1874   0.9038   0.7467
#>    Month: 36    P(Cross) if HR=1  0.0736   0.8551   0.0017
#>              P(Cross) if HR=0.75  0.0005   0.0398   0.4829
#>    IA 4: 83%                   Z -1.7170   1.6890   2.5229
#>      N: 1118         p (1-sided)  0.9570   0.0456   0.0058
#>  Events: 533        ~HR at bound  1.1604   0.8639   0.8037
#>    Month: 48    P(Cross) if HR=1  0.0890   0.9592   0.0063
#>              P(Cross) if HR=0.75  0.0005   0.0675   0.7881
#>        Final                   Z -1.7149   2.2480   2.2480
#>      N: 1118         p (1-sided)  0.9568   0.0123   0.0123
#>  Events: 639        ~HR at bound  1.1454   0.8370   0.8370
#>    Month: 60    P(Cross) if HR=1  0.1000   0.9875   0.0125
#>              P(Cross) if HR=0.75  0.0005   0.1000   0.9000
```

### Efficacy bounds at alternate \\\alpha\\ levels

The
[`gsBoundSummary()`](https://keaven.github.io/gsDesign/reference/gsBoundSummary.md)
function accepts an `alpha` argument to display efficacy bounds at one
or more alternate \\\alpha\\ levels alongside the original design. Here
we show the non-binding design (`x8`) with efficacy bounds for both
\\\alpha = 0.0125\\ (the design level) and \\\alpha = 0.025\\:

``` r
gsBoundSummary(x8, alpha = 0.025)
#>     Analysis               Value α=0.0125 α=0.025 Futility    Harm
#>    IA 1: 11%                   Z   7.4336  6.6513  -1.4408 -2.1121
#>       N: 766         p (1-sided)   0.0000  0.0000   0.9252  0.9827
#>   Events: 73        ~HR at bound   0.1740  0.2092   1.4034  1.6434
#>    Month: 12    P(Cross) if HR=1   0.0000  0.0000   0.0748  0.0173
#>              P(Cross) if HR=0.75   0.0000  0.0000   0.0039  0.0004
#>    IA 2: 38%                   Z   3.8622  3.4312   0.1212 -1.7667
#>      N: 1148         p (1-sided)   0.0001  0.0003   0.4518  0.9614
#>  Events: 253        ~HR at bound   0.6149  0.6492   0.9849  1.2491
#>    Month: 24    P(Cross) if HR=1   0.0001  0.0003   0.5554  0.0507
#>              P(Cross) if HR=0.75   0.0574  0.1259   0.0181  0.0004
#>    IA 3: 63%                   Z   2.9347  2.5948   1.0566 -1.7256
#>      N: 1148         p (1-sided)   0.0017  0.0047   0.1454  0.9578
#>  Events: 416        ~HR at bound   0.7497  0.7751   0.9015  1.1846
#>    Month: 36    P(Cross) if HR=1   0.0017  0.0048   0.8641  0.0736
#>              P(Cross) if HR=0.75   0.4990  0.6323   0.0398  0.0004
#>    IA 4: 83%                   Z   2.5278  2.2359   1.7357 -1.7170
#>      N: 1148         p (1-sided)   0.0057  0.0127   0.0413  0.9570
#>  Events: 548        ~HR at bound   0.8057  0.8261   0.8622  1.1580
#>    Month: 48    P(Cross) if HR=1   0.0062  0.0138   0.9631  0.0890
#>              P(Cross) if HR=0.75   0.7996  0.8684   0.0675  0.0004
#>        Final                   Z   2.3072  2.0432   2.3072 -1.7149
#>      N: 1148         p (1-sided)   0.0105  0.0205   0.0105  0.9568
#>  Events: 657        ~HR at bound   0.8352  0.8526   0.8352  1.1433
#>    Month: 60    P(Cross) if HR=1   0.0112  0.0201   0.9888  0.1000
#>              P(Cross) if HR=0.75   0.9000  0.9218   0.1000  0.0004
```

## Practical considerations

### Choice of spending functions

The choice of spending functions for the three boundaries should reflect
regulatory and scientific considerations:

- **Efficacy**: A conservative spending function such as Lan-DeMets
  O’Brien-Fleming (`sfLDOF`) is typical, spending very little \\\alpha\\
  at early interim analyses when limited information is available.
- **Futility**: Moderate spending (e.g., HSD with \\\gamma = -2\\)
  allows early stopping for futility when the treatment effect is
  clearly absent.
- **Harm**: The Lan-DeMets Pocock (`sfLDPocock`) spending function
  provides more aggressive spending at early analyses, which is
  appropriate for harm monitoring since detecting a detrimental effect
  early is critical for patient safety.

### Interpreting the harm bound

The harm bound is intended so that if a small observed p-value *favoring
control* is observed, the harm bound will be crossed. In terms of the
test statistic, a negative Z-value indicates that the hazard rate is
higher in the experimental arm than the control arm — i.e., the
experimental treatment appears to be worsening survival. When the
Z-value falls below the harm bound, this constitutes a statistical
signal that the treatment may be harmful, and the trial should be
stopped with a recommendation to review the safety data.

The harm spending is computed under \\H_0\\ (no treatment effect),
reflecting the probability of observing an apparent harmful effect *by
chance* when there is actually no true effect. This controls the
probability of a false harm signal.

### Harm bound capping

In the implementation, the harm bound is automatically **capped** so it
never exceeds the futility bound. This ensures the ordering: harm bound
\\\leq\\ futility bound \\\leq\\ efficacy bound at every analysis.

### When to use `test.type = 7` vs. `test.type = 8`

- **`test.type = 8` (non-binding)** is most often preferred in practice.
  Regulators will generally expect non-binding bounds, which preserve
  Type I error control regardless of whether the stopping rules are
  strictly followed. Since Data Monitoring Committees (DMCs) typically
  retain discretion to continue or stop a trial based on the totality of
  the evidence, the non-binding approach ensures that the statistical
  validity of the efficacy analysis is maintained even if a futility or
  harm boundary is crossed but the trial continues.
- **`test.type = 7` (binding)** is appropriate when there is a firm
  commitment to stop the trial upon crossing any boundary. This provides
  a small efficiency gain (slightly easier efficacy bounds and fewer
  required events) but requires strict protocol adherence. If the trial
  does not stop after crossing a binding boundary, Type I error may be
  inflated.

In most regulatory settings, `test.type = 8` is the safer and more
common choice.

### Why a separate “binding harm / non-binding futility” option is unnecessary

One might consider a design where the futility bound is non-binding but
the harm bound is binding. In practice, such a distinction has no
computational effect. The harm bound is computed *after* the efficacy
and futility bounds are set and does not feed back into those
computations. When the futility bound is non-binding (as in
`test.type = 8`), the efficacy bound is computed ignoring all
lower-bound stopping. Since the harm bound lies below the futility
bound, making the harm bound “binding” while the futility bound remains
non-binding would not change the efficacy boundary, the required number
of events, the final Z-values, or the p-values — the results are
identical.

The only difference would be in *interpretation*: whether crossing the
harm bound is treated as a firm commitment to stop or as advisory
information for the DMC. This interpretive distinction does not require
a separate `test.type`; it can be addressed in the protocol language and
the DMC charter. The `test.type = 8` framework already provides full
flexibility for the DMC to treat the harm bound as either advisory or
mandatory.

### Adjusting the boundaries

The boundaries are adjustable through several design parameters:

- **Alternate `astar`**: Controls the Type I error allocated to excess
  OS harm detection.
- **Alternate spending functions**: Different spending functions for
  efficacy, futility, and harm boundaries change the aggressiveness of
  each boundary across analyses.
- **Alternate timing of analyses**: Changing the calendar times of
  interim analyses shifts the information available at each look.

Regardless of the statistical design, bounds must be clinically,
ethically, and statistically sound. As previously noted, this approach
is one option to address the regulatory expectation for OS harm
monitoring, but other approaches may also be considered.

## References

Proschan, Michael A., K. K. Gordon Lan, and Janet Turk Wittes. 2006.
*Statistical Monitoring of Clinical Trials: A Unified Approach*. New
York, NY: Springer.

U.S. Food and Drug Administration. 2024. “Assessment of Overall Survival
Evidence in Support of Accelerated Approval of Oncology Therapeutics:
Draft Guidance for Industry.”
<https://www.fda.gov/media/188274/download>.

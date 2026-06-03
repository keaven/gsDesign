# Reproducing PROC SEQDESIGN survival designs in gsDesign

``` r

library(gsDesign)
```

## Overview

This vignette emphasizes exact numerical reproduction of SAS PROC
SEQDESIGN survival outputs in gsDesign when design assumptions are
matched. We first reproduce the SAS fractional-time table to printed
precision. We then show different options that may lead to confusion in
translating SAS PROC SEQDESIGN calls to gsDesign.

### Starting point: SAS PROC SEQDESIGN survival example

Consider the example described in the SAS Documentation: [Computing
Sample Size for Survival Data with Uniform
Accrual](https://support.sas.com/documentation/cdl/en/statug/68162/HTML/default/statug_seqdesign_examples14.htm).
The first PROC SEQDESIGN call in that example does not specify
`ACCTIME`; SAS therefore derives a range of possible accrual times. The
comparison below uses the subsequent SAS call with `ACCTIME=18`, which
fixes the maximum sample size at `15 * 18 = 270` subjects and asks SAS
to solve the follow-up time. Note that the SAS survival sample size
model is specified as uses the Schoenfeld formula for the targeted event
counts. The computed sample size and event counts at each analysis are
continuous values, not rounded to integers.

``` sas
proc seqdesign; /* Group sequential design procedure */
    ErrorSpend: design /* Label for this design block */
                nstages=4 /* Total analyses including final */
                method=errfuncobf /* Lan-DeMets O'Brien-Fleming spending */
                alt=twosided /* Two-sided alternative hypothesis */
                stop=reject /* Early stop only for efficacy */
                alpha=0.05 /* Total two-sided Type I error */
                beta=0.10 /* Type II error (90% power) */
                ;
    samplesize model(ceiladjdesign=include)= /* Survival model */
        twosamplesurvival( /* Two-sample survival endpoint */
        nullhazard = 0.03466 /* Control hazard under H0 */
        hazard     = 0.01733 /* Experimental hazard under H1 */
        accrual    = uniform /* Uniform enrollment */
        accrate    = 15 /* Subjects enrolled per time unit */
        acctime    = 18 /* Accrual duration in time units */
    );
run;
```

**SAS assumptions summary:**

- 4-stage group sequential design
- Lan-DeMets O’Brien-Fleming error spending function
- Two-sided symmetric test, total alpha = 0.05
- 90% power (beta = 0.10)
- Equally spaced information fractions: 0.25, 0.50, 0.75, 1.00
- Schoenfeld formula for required number of events
- Fixed accrual rate and duration, so the maximum sample size is \\N =
  \text{ACCRATE} \times \text{ACCTIME} = 15 \times 18 = 270\\
- Study duration \\T\\ solved to achieve the required events
- Hazard ratio \\HR = 0.01733 / 0.03466 = 0.5\\

SAS does produce a sample size in this example. In the “Sample Size
Summary” table for the `ACCTIME=18` case, it reports
`Max Sample Size = 270`, `Expected Sample Size (Null Ref) = 269.9206`,
`Expected Sample Size (Alt Ref) = 263.1141`,
`Follow-up Time = 7.133226`, and `Total Time = 25.13323`. The maximum
sample size is not calculated from the event formula; it is implied
directly by the fixed accrual rate and accrual duration:
`15 subjects/time unit * 18 time units = 270 subjects`.

SAS reports two sets of analysis quantities. We focus first on the
fractional-time design, where the analysis times are not rounded, and
then return to the `CEILING=TIME` adjusted design later.

``` r

sas_fractional <- data.frame(
  Analysis = 1:4,
  Events = c(22.26962, 44.53924, 66.80886, 89.07847),
  Calendar_time = c(11.2631, 16.2875, 20.4926, 25.13323),
  N = c(168.95, 244.31, 270.00, 270.00),
  Upper_Z = c(4.33263, 2.96333, 2.35902, 2.01409)
)

sas_ceiling_time <- data.frame(
  Analysis = 1:4,
  Events = c(25.11225, 48.22068, 69.38712, 92.92776),
  Calendar_time = c(12, 17, 21, 26),
  N = c(180, 255, 270, 270),
  Upper_Z = c(4.15591, 2.90189, 2.36973, 2.01362)
)
```

To reproduce the SAS fractional-time output exactly while specifying
analysis timing in calendar units, we use
`gsDesign::gsSurvCalendar(calendarTime = sas_fractional$Calendar_time)`.
We keep one-sided `alpha = 0.025`, use `method = "Schoenfeld"`, and keep
accrual fixed at 15 subjects per time unit for 18 time units by setting
`R = 18` with `minfup = max(calendarTime) - R`.

``` r

des <- gsSurvCalendar(
  test.type = 2,
  alpha     = 0.025,
  beta      = 0.10,
  sfu       = sfLDOF, # Lan-DeMets O'Brien--Fleming
  calendarTime = sas_fractional$Calendar_time,
  spending  = "information",
  lambdaC   = 0.03466,
  hr        = 0.5,
  eta       = 0, # No dropout
  gamma     = 15, # Uniform accrual rate of 15/month
  R         = 18, # Accrual duration (months)
  minfup    = max(sas_fractional$Calendar_time) - 18,
  ratio     = 1, # 1:1 randomization
  method    = "Schoenfeld"
)

# des |> gsBoundSummary(tdigits = 2, ddigits = 2) |> gt::gt()
```

### Side-by-side comparison table

``` r

# Get results for comparison from gsDesign object
events_a2 <- round(des$n.I, 2) # Event counts
z_a2 <- round(des$upper$bound, 4) # Z-boundaries
N2a <- sum(des$eNC[4, ]) + sum(des$eNE[4, ]) # Total sample size

knitr::kable(
  data.frame(
    Analysis = 1:4,
    Events_SAS = round(sas_fractional$Events, 2),
    Events_gsDesign = events_a2,
    Z_SAS = round(sas_fractional$Upper_Z, 4),
    Z_gsDesign = z_a2
  ),
  caption = "Side-by-side comparison of events and Z-boundaries at each look."
)
```

| Analysis | Events_SAS | Events_gsDesign |  Z_SAS | Z_gsDesign |
|---------:|-----------:|----------------:|-------:|-----------:|
|        1 |      22.27 |           22.27 | 4.3326 |     4.3326 |
|        2 |      44.54 |           44.54 | 2.9633 |     2.9631 |
|        3 |      66.81 |           66.81 | 2.3590 |     2.3590 |
|        4 |      89.08 |           89.08 | 2.0141 |     2.0141 |

Side-by-side comparison of events and Z-boundaries at each look.
{.table}

The rest of this vignette identifies the key assumptions in each system
and explains why alternative parameter translations can produce
different results. Those who would like to know more details about the
design of the time-to-event functionality in gsDesign should consult
[`vignette("SurvivalOverview")`](https://keaven.github.io/gsDesign/articles/SurvivalOverview.md).

## Key differences: SAS SEQDESIGN vs. R gsDesign

There are four practical translation points that affect the output from
the example above.

### 1. Event formula

- **SAS:** Schoenfeld (1981). Uses only the null-hypothesis variance.
- **gsDesign:** Lachin and Foulkes (1986) by default. Uses both null and
  alternative hypothesis variances. L-F is slightly more conservative,
  giving ~1-2% more events than Schoenfeld for the same parameters. Use
  `method = "Schoenfeld"` to match the SAS event formula.

### 2. Alpha handling in `gsDesign()` and `gsSurv()`

[`gsDesign()`](https://keaven.github.io/gsDesign/reference/gsDesign.md)
stores and spends the **one-sided** Type I error. Thus, for a symmetric
two-sided design (`test.type = 2`), `alpha = 0.025` means 0.025 in each
tail, or 0.05 total two-sided Type I error.

This convention is deliberate: most group sequential computations in
[`gsDesign()`](https://keaven.github.io/gsDesign/reference/gsDesign.md)
are organized around the upper-bound crossing probability. A symmetric
two-sided design is represented by mirroring that upper-bound spending
in the lower tail. Thus the `alpha` argument is still the per-tail
crossing probability, even though the design has both an upper and lower
efficacy boundary.

[`gsSurv()`](https://keaven.github.io/gsDesign/reference/nSurv.md)
follows the same convention internally. If a user prefers to enter the
total two-sided alpha, `alpha = 0.05, sided = 2` is equivalent to
`alpha = 0.025, sided = 1` for this example because
[`gsSurv()`](https://keaven.github.io/gsDesign/reference/nSurv.md)
passes `alpha / sided` to
[`gsDesign()`](https://keaven.github.io/gsDesign/reference/gsDesign.md).

Here we use `test.type = 2` and `alpha = 0.025` to make the symmetric
two-sided
[`gsDesign()`](https://keaven.github.io/gsDesign/reference/gsDesign.md)
object match the SAS two-sided total alpha of 0.05.

### 3. Accrual duration and follow-up time

With `ACCTIME=18`, SAS fixes the accrual duration and total maximum
sample size and solves for the additional follow-up time. To match this
in [`gsSurv()`](https://keaven.github.io/gsDesign/reference/nSurv.md),
set both `T = NULL` and `minfup = NULL`. This tells
[`gsSurv()`](https://keaven.github.io/gsDesign/reference/nSurv.md) to
keep the input accrual rate and accrual duration fixed, then solve the
follow-up duration needed for the final group sequential event
requirement. If analysis times are specified directly in calendar units,
the corresponding
[`gsSurvCalendar()`](https://keaven.github.io/gsDesign/reference/gsSurvCalendar.md)
setup is `calendarTime = ...` with
`minfup = max(calendarTime) - accrual_duration`.

This is a common source of apparent disagreement. For a fixed-duration
survival design, `T` is the total study duration and `minfup` is the
minimum follow-up after enrollment closes. With scalar accrual,
specifying both `T` and `minfup` makes the implied accrual duration
`T - minfup`; specifying only one of them can therefore change which
quantity
[`gsSurv()`](https://keaven.github.io/gsDesign/reference/nSurv.md)
solves for. The SAS comparison fixes accrual at 18 time units and lets
the total time be derived.

### 4. Fractional time vs. ceiling time

The original SAS fractional-time design has equal information fractions
and final events 89.07847. The SAS ceiling-time adjusted design rounds
analysis times to 12, 17, 21, and 26. These rounded calendar times imply
unequal information fractions and final events 92.92776. Both are valid
SAS outputs; they should not be mixed when comparing against gsDesign.

The distinction matters because SAS’s fractional-time table answers
“what analysis times give the target information fractions?”, while the
ceiling-time table answers “what happens after those analysis times are
rounded up to whole time units?” Once calendar times are rounded up,
subjects are followed longer, more events are expected, and the
O’Brien-Fleming spending times are no longer exactly 0.25, 0.50, 0.75,
and 1.00.

The translation used below is summarized as follows:

| Quantity | SAS | gsDesign | Reason |
|:---|:---|:---|:---|
| Two-sided Type I error | alpha = 0.05 total | alpha = 0.025 per tail | gsDesign stores and spends one-sided alpha |
| Symmetric two-sided design | Early stop to reject either side | test.type = 2 | Mirrors the upper and lower efficacy boundaries |
| Analysis timing input | Calendar times reported by PROC output | gsSurvCalendar(calendarTime = …) | Uses direct calendar-time analysis specification |
| Event formula | Schoenfeld log-rank information | method = “Schoenfeld” | Avoids Lachin-Foulkes default event calculation |
| Accrual duration | ACCTIME = 18 | R = 18 | Keeps the same fixed accrual duration |
| Total study duration | Total Time = 25.13323 | T = NULL | Lets gsSurv() solve total time from fixed accrual |
| Follow-up after accrual | Derived as 7.133226 | minfup = NULL | Lets gsSurv() solve the follow-up duration |

Translation from the SAS PROC SEQDESIGN example to gsDesign inputs.
{.table}

## Aligning the two approaches

The exact fractional-time reproduction above uses
[`gsSurvCalendar()`](https://keaven.github.io/gsDesign/reference/gsSurvCalendar.md)
because SAS reports analysis timing in calendar units. An equivalent
information-time translation using
[`gsSurv()`](https://keaven.github.io/gsDesign/reference/nSurv.md) is
shown next.

### `gsSurv()` with aligned parameters

Let’s start our work with gsDesign by defining parameters to match the
SAS fractional-time design:

``` r

k <- 4
alpha_sas <- 0.05 # Two-sided total alpha (SAS convention)
alpha_gsdesign <- alpha_sas / 2 # gsDesign uses one-sided alpha
beta <- 0.10 # 1 - power = 0.10 -> 90% power
lambdaC <- 0.03466 # Control hazard rate
lambdaE <- 0.01733 # Experimental hazard rate
HR <- lambdaE / lambdaC # = 0.5
timing <- c(0.25, 0.50, 0.75, 1.00) # Equally spaced information fractions
accrate <- 15 # Uniform accrual rate (subjects per time unit)
accrual_duration <- 18 # Accrual duration (time units)
sas_total_time <- 25.13323
sas_followup_time <- sas_total_time - accrual_duration
N <- accrate * accrual_duration
```

Instead of starting with a call to
[`gsDesign::gsDesign()`](https://keaven.github.io/gsDesign/reference/gsDesign.md),
we begin with
[`gsDesign::gsSurv()`](https://keaven.github.io/gsDesign/reference/nSurv.md).
The [`gsSurv()`](https://keaven.github.io/gsDesign/reference/nSurv.md)
function combines
[`nSurv()`](https://keaven.github.io/gsDesign/reference/nSurv.md) with
[`gsDesign()`](https://keaven.github.io/gsDesign/reference/gsDesign.md)
(group sequential boundaries) in one call. It is the standard gsDesign
function for designing time-to-event trials.

The call below uses the same two-sided symmetric structure as SAS:

- `test.type = 2` for symmetric two-sided boundaries;
- `alpha = 0.025`, the one-sided alpha corresponding to SAS’s total
  two-sided alpha of 0.05;
- `method = "Schoenfeld"` for the SAS event formula;
- `T = NULL` and `minfup = NULL` so the accrual rate and accrual
  duration remain fixed while
  [`gsSurv()`](https://keaven.github.io/gsDesign/reference/nSurv.md)
  solves the follow-up duration.

``` r

des_2 <- gsSurv(
  k = 4,
  test.type = 2, # Symmetric two-sided design
  alpha = alpha_gsdesign, # One-sided alpha; SAS total alpha is 2 * this
  beta = 0.10,
  sfu = sfLDOF,
  timing = c(.25, .50, .75, 1),
  lambdaC = 0.03466,
  hr = 0.5,
  eta = 0, # Assume no dropout
  gamma = accrate,
  R = accrual_duration,
  T = NULL,
  minfup = NULL,
  ratio = 1,
  method = "Schoenfeld"
)
des_2
#> Group sequential design (method=Schoenfeld; k=4 analyses; Two-sided symmetric)
#> HR=0.500 vs HR0=1.000 | alpha=0.025 (sided=2) | power=90.0%
#> N=270.0 subjects | D=89.1 events | T=25.1 study duration | accrual=18.0 Accrual duration | minfup=7.1 minimum follow-up | ratio=1 randomization ratio (experimental/control)
#> 
#> Spending functions:
#>   Bounds derived using a  Lan-DeMets O'Brien-Fleming approximation spending function (no parameters).
#> 
#> Analysis summary:
#> Method: Schoenfeld 
#>    Analysis              Value Efficacy Futility
#>   IA 1: 25%                  Z   4.3326  -4.3326
#>      N: 170        p (1-sided)   0.0000   0.0000
#>  Events: 23       ~HR at bound   0.1594   6.2728
#>   Month: 11   P(Cross) if HR=1   0.0000   0.0000
#>             P(Cross) if HR=0.5   0.0035   0.0000
#>   IA 2: 50%                  Z   2.9631  -2.9631
#>      N: 246        p (1-sided)   0.0015   0.0015
#>  Events: 45       ~HR at bound   0.4115   2.4302
#>   Month: 16   P(Cross) if HR=1   0.0015   0.0015
#>             P(Cross) if HR=0.5   0.2579   0.0000
#>   IA 3: 75%                  Z   2.3590  -2.3590
#>      N: 272        p (1-sided)   0.0092   0.0092
#>  Events: 67       ~HR at bound   0.5615   1.7811
#>   Month: 20   P(Cross) if HR=1   0.0096   0.0096
#>             P(Cross) if HR=0.5   0.6853   0.0000
#>       Final                  Z   2.0141  -2.0141
#>      N: 272        p (1-sided)   0.0220   0.0220
#>  Events: 90       ~HR at bound   0.6526   1.5323
#>   Month: 25   P(Cross) if HR=1   0.0250   0.0250
#>             P(Cross) if HR=0.5   0.9000   0.0000
#> 
#> Key inputs (names preserved):
#>                                desc    item value input
#>                     Accrual rate(s)   gamma    15    15
#>            Accrual rate duration(s)       R    18    18
#>              Control hazard rate(s) lambdaC 0.035 0.035
#>             Control dropout rate(s)     eta     0     0
#>        Experimental dropout rate(s)    etaE     0  etaE
#>  Event and dropout rate duration(s)       S  NULL     S
```

**Observations:**

Using [`gsSurv()`](https://keaven.github.io/gsDesign/reference/nSurv.md)
with parameters that align with SAS settings, the fractional-time output
agrees with SAS. The final follow-up duration is 7.13321, giving total
study duration 25.13321.

``` r

gs_fractional <- data.frame(
  Analysis = 1:k,
  Events_SAS = sas_fractional$Events,
  Events_gsDesign = des_2$n.I,
  Time_SAS = sas_fractional$Calendar_time,
  Time_gsDesign = des_2$T,
  N_SAS = sas_fractional$N,
  N_gsDesign = rowSums(des_2$eNC) + rowSums(des_2$eNE),
  Z_SAS = sas_fractional$Upper_Z,
  Z_gsDesign = des_2$upper$bound
)

knitr::kable(
  round(gs_fractional, 5),
  caption = "Fractional-time SAS output compared with gsSurv()."
)
```

| Analysis | Events_SAS | Events_gsDesign | Time_SAS | Time_gsDesign | N_SAS | N_gsDesign | Z_SAS | Z_gsDesign |
|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| 1 | 22.26962 | 22.2696 | 11.26310 | 11.26306 | 168.95 | 168.9459 | 4.33263 | 4.33263 |
| 2 | 44.53924 | 44.5392 | 16.28750 | 16.28746 | 244.31 | 244.3119 | 2.96333 | 2.96313 |
| 3 | 66.80886 | 66.8088 | 20.49260 | 20.49260 | 270.00 | 270.0000 | 2.35902 | 2.35904 |
| 4 | 89.07847 | 89.0784 | 25.13323 | 25.13321 | 270.00 | 270.0000 | 2.01409 | 2.01409 |

Fractional-time SAS output compared with gsSurv(). {.table}

The final event count is 89.07847 in both systems. The
[`print()`](https://rdrr.io/r/base/print.html) and
[`gsBoundSummary()`](https://keaven.github.io/gsDesign/reference/gsBoundSummary.md)
methods display rounded integer sample sizes and events, but the object
retains the fractional values shown above.

If the SAS follow-up time is already known, the equivalent
fixed-follow-up translation is `T = NULL` with `minfup` set to the SAS
follow-up time. In that case,
[`gsSurv()`](https://keaven.github.io/gsDesign/reference/nSurv.md) holds
the follow-up duration fixed and solves the accrual duration needed for
the final group sequential event target:

``` r

des_fixed_followup <- gsSurv(
  k = 4,
  test.type = 2,
  alpha = alpha_gsdesign,
  beta = 0.10,
  sfu = sfLDOF,
  timing = c(.25, .50, .75, 1),
  lambdaC = 0.03466,
  hr = 0.5,
  eta = 0,
  gamma = accrate,
  R = accrual_duration,
  T = NULL,
  minfup = sas_followup_time,
  ratio = 1,
  method = "Schoenfeld"
)

fixed_followup_check <- data.frame(
  Quantity = c(
    "Final study duration",
    "Accrual duration",
    "Final events",
    "Final N"
  ),
  Solved_followup = c(
    des_2$T[k],
    sum(des_2$R),
    des_2$n.I[k],
    sum(des_2$eNC[k, ] + des_2$eNE[k, ])
  ),
  Specified_followup = c(
    des_fixed_followup$T[k],
    sum(des_fixed_followup$R),
    des_fixed_followup$n.I[k],
    sum(des_fixed_followup$eNC[k, ] + des_fixed_followup$eNE[k, ])
  )
)
fixed_followup_check[-1] <- lapply(fixed_followup_check[-1], round, digits = 5)

knitr::kable(
  fixed_followup_check,
  caption = "Both fixed-accrual translations produce the same final design."
)
```

| Quantity             | Solved_followup | Specified_followup |
|:---------------------|----------------:|-------------------:|
| Final study duration |        25.13321 |           25.13322 |
| Accrual duration     |        18.00000 |           17.99999 |
| Final events         |        89.07840 |           89.07840 |
| Final N              |       270.00003 |          269.99988 |

Both fixed-accrual translations produce the same final design. {.table}

### Matching the SAS ceiling-time adjusted design

The SAS example also reports a `CEILING=TIME` adjusted design. This is
not the same design as the equal-information fractional-time output
above. The analysis times are rounded up to 12, 17, 21, and 26, which
increases the expected events and changes the information fractions. For
calendar-scheduled analyses in general, this would naturally be
specified with
`gsSurvCalendar(calendarTime = c(12, 17, 21, 26), spending = "information")`.
To match the SAS `CEILING=TIME` table exactly, we retain fixed accrual
and use the implied event counts at those rounded calendar times.

We can reproduce the ceiling-time event counts directly from the fixed
accrual rate, fixed accrual duration, and exponential event rates. With
equal randomization, the control and experimental accrual rates are each
7.5 per time unit.

``` r

event_count_at_time <- function(time) {
  control_events <- eEvents(
    lambda = lambdaC,
    gamma = accrate / (1 + 1),
    R = accrual_duration,
    T = time
  )$d
  experimental_events <- eEvents(
    lambda = lambdaE,
    gamma = accrate / (1 + 1),
    R = accrual_duration,
    T = time
  )$d
  sum(control_events) + sum(experimental_events)
}

ceiling_times <- ceiling(sas_fractional$Calendar_time)
ceiling_events <- vapply(ceiling_times, event_count_at_time, numeric(1))

des_ceiling <- gsDesign(
  k = k,
  test.type = 2,
  alpha = alpha_gsdesign,
  beta = beta,
  sfu = sfLDOF,
  n.I = ceiling_events,
  timing = ceiling_events / max(ceiling_events)
)

gs_ceiling <- data.frame(
  Analysis = 1:k,
  Events_SAS = sas_ceiling_time$Events,
  Events_gsDesign = ceiling_events,
  Time_SAS = sas_ceiling_time$Calendar_time,
  Time_gsDesign = ceiling_times,
  N_SAS = sas_ceiling_time$N,
  N_gsDesign = pmin(accrate * ceiling_times, N),
  Z_SAS = sas_ceiling_time$Upper_Z,
  Z_gsDesign = des_ceiling$upper$bound
)

knitr::kable(
  round(gs_ceiling, 5),
  caption = "Ceiling-time SAS output compared with gsDesign()."
)
```

| Analysis | Events_SAS | Events_gsDesign | Time_SAS | Time_gsDesign | N_SAS | N_gsDesign | Z_SAS | Z_gsDesign |
|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| 1 | 25.11225 | 25.11225 | 12 | 12 | 180 | 180 | 4.15591 | 4.15591 |
| 2 | 48.22068 | 48.22068 | 17 | 17 | 255 | 255 | 2.90189 | 2.90177 |
| 3 | 69.38712 | 69.38712 | 21 | 21 | 270 | 270 | 2.36973 | 2.36975 |
| 4 | 92.92776 | 92.92776 | 26 | 26 | 270 | 270 | 2.01362 | 2.01362 |

Ceiling-time SAS output compared with gsDesign(). {.table}

The remaining small differences in the printed Z-values are numerical
rounding differences. The important conceptual distinction is that the
SAS fractional-time and ceiling-time tables are different designs: one
uses equal information fractions, and the other uses rounded calendar
analysis times.

## References

Lachin, John M., and Mary A. Foulkes. 1986. “Evaluation of Sample Size
and Power for Analyses of Survival with Allowance for Nonuniform Patient
Entry, Losses to Follow-up, Noncompliance, and Stratification.”
*Biometrics* 42: 507–19.

Schoenfeld, David. 1981. “The Asymptotic Properties of Nonparametric
Tests for Comparing Survival Distributions.” *Biometrika* 68 (1):
316–19.

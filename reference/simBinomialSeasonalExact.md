# Simulate exact-binomial seasonal monitoring scenarios

Simulate seasonal rare-event trials monitored with exact-binomial
efficacy bounds derived from a \`gsSurv\` design. This helper supports
fixed enrollment and a simple blinded information-adaptive enrollment
rule while keeping the spending framework fixed through the original
\`gsSurv\` design object.

The function summarizes empirical rejection rates (Type I error or
power), futility stopping rates (binding interpretation), Monte Carlo
standard errors, average final events, average total enrollment, and
average number of informative looks.

## Usage

``` r
simBinomialSeasonalExact(
  gsD,
  ve = c(0.3, 0.8),
  nsim = c(600, 600),
  control_event_rate = c(0.003, 0.003),
  season_length = 0.5,
  dropout_rate = 0.1,
  planned_counts = NULL,
  timing = NULL,
  enroll_control_per_look = NULL,
  enroll_experimental_per_look = NULL,
  adaptive = c(FALSE, TRUE),
  adapt_looks = NULL,
  max_multiplier = 2,
  usTime = NULL,
  lsTime = NULL,
  final_full_spending = FALSE,
  seed = NULL,
  return_trials = FALSE
)
```

## Arguments

- gsD:

  A \`gsSurv\` object with \`test.type\` 1 or 4.

- ve:

  Numeric vector of vaccine efficacy (or prevention efficacy) scenarios
  to simulate.

- nsim:

  Integer scalar or vector giving the number of simulations per element
  of \`ve\`.

- control_event_rate:

  Numeric scalar or vector with control seasonal event probabilities
  corresponding to \`ve\`.

- season_length:

  Numeric scalar \> 0 giving season duration in years.

- dropout_rate:

  Seasonal dropout probability in \`\[0, 1)\`.

- planned_counts:

  Optional increasing integer vector of planned cumulative events at
  analyses. If \`NULL\`, these are derived from \`timing \*
  toInteger(gsD)\$n.I\[k\]\`.

- timing:

  Optional increasing cumulative spending-time vector ending at 1 used
  to derive \`planned_counts\` when \`planned_counts = NULL\`.

- enroll_control_per_look:

  Optional control-arm enrollment by look (scalar or length \`k\`
  integer vector). If \`NULL\`, this is calibrated from
  \`planned_counts\` under the largest value of \`ve\`.

- enroll_experimental_per_look:

  Optional experimental-arm enrollment by look (scalar or length \`k\`
  integer vector). If \`NULL\`, this is set using \`gsD\$ratio\` from
  \`enroll_control_per_look\`.

- adaptive:

  Logical vector specifying whether to simulate fixed and/or adaptive
  enrollment scenarios.

- adapt_looks:

  Integer vector of look indices after which adaptation can be applied
  (default: all interim looks).

- max_multiplier:

  Maximum multiplicative enrollment increase at a look when adaptation
  is enabled.

- usTime:

  Optional upper spending-time override passed to \[toBinomialExact()\].
  If \`NULL\`, spending time defaults to \`planned_counts /
  planned_final_events\` (capped at 1).

- lsTime:

  Optional lower spending-time override for \`test.type = 4\`. If
  \`NULL\`, this defaults to \`usTime\`.

- final_full_spending:

  Logical scalar. If \`TRUE\`, force full alpha spending at the final
  analysis even when the final observed total event count is below
  planned final events.

- seed:

  Optional integer seed for reproducibility.

- return_trials:

  Logical. If \`TRUE\`, return trial-level simulation outcomes.

## Value

A list with:

- \`summary\`:

  Data frame with scenario-level summaries.

- \`planned\`:

  List with planned counts, exact design object, and planned/calibrated
  enrollment by look.

- \`inputs\`:

  List of simulation inputs used.

- \`trials\`:

  Optional trial-level data frame (\`NULL\` unless \`return_trials =
  TRUE\`).

## See also

\[toBinomialExact()\], \[repeatedPValueBinomialExact()\],
\[sequentialPValueBinomialExact()\]

## Examples

``` r
x <- gsSurv(
  k = 3, test.type = 4, alpha = 0.025, beta = 0.1, timing = c(1 / 3, 2 / 3),
  sfu = sfHSD, sfupar = 1, sfl = sfHSD, sflpar = -2,
  lambdaC = -log(1 - 0.003) / 0.5,
  hr = 0.2, hr0 = 0.7, eta = -log(1 - 0.1) / 0.5,
  gamma = c(1, 0, 1, 0, 1, 0), R = c(2, 10, 2, 10, 2, 10),
  T = 42, minfup = 6, ratio = 3
) |> toInteger()

simBinomialSeasonalExact(
  gsD = x,
  ve = c(0.3, 0.8),
  nsim = c(50, 50),
  control_event_rate = c(0.003, 0.003),
  seed = 123
)$summary
#>    scenario  ve control_event_rate adaptive nsim rejection_rate      mc_se
#> 1 Scenario1 0.3              0.003    FALSE   50           0.02 0.01979899
#> 2 Scenario1 0.3              0.003     TRUE   50           0.04 0.02771281
#> 3 Scenario2 0.8              0.003    FALSE   50           0.86 0.04907138
#> 4 Scenario2 0.8              0.003     TRUE   50           0.98 0.01979899
#>   futility_stop_rate futility_mc_se mean_total_events mean_total_enrolled
#> 1               0.98     0.01979899             70.30            16920.00
#> 2               0.96     0.02771281             72.72            18379.52
#> 3               0.16     0.05184593             35.66            16920.00
#> 4               0.02     0.01979899             46.84            21251.22
#>   mean_looks
#> 1       2.52
#> 2       2.32
#> 3       3.00
#> 4       3.00
```

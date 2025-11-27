# Power Table for Binomial Tests

Creates a power table for binomial tests with various control group
response rates and treatment effects. The function can compute power and
Type I error either analytically or through simulation. With large
simulations, the function is still fast and can produce exact power
values to within simulation error.

## Usage

``` r
binomialPowerTable(
  pC = c(0.8, 0.9, 0.95),
  delta = seq(-0.05, 0.05, 0.025),
  n = 70,
  ratio = 1,
  alpha = 0.025,
  delta0 = 0,
  scale = "Difference",
  failureEndpoint = TRUE,
  simulation = FALSE,
  nsim = 1e+06,
  adj = 0,
  chisq = 0
)
```

## Arguments

- pC:

  Vector of control group response rates.

- delta:

  Vector of treatment effects (differences in response rates).

- n:

  Total sample size.

- ratio:

  Ratio of experimental to control sample size.

- alpha:

  Type I error rate.

- delta0:

  Non-inferiority margin.

- scale:

  Scale for the test (`"Difference"`, `"RR"`, or `"OR"`).

- failureEndpoint:

  Logical indicating if the endpoint is a failure (`TRUE`) or success
  (`FALSE`).

- simulation:

  Logical indicating whether to use simulation (`TRUE`) or analytical
  (`FALSE`) power calculation.

- nsim:

  Number of simulations to run when `simulation = TRUE`.

- adj:

  Use continuity correction for the testing (default is 0; only used if
  `simulation = TRUE`).

- chisq:

  Chi-squared value for the test (default is 0; only used if
  `simulation = TRUE`).

## Value

A data frame containing:

- `pC`:

  Control group response or failure rate.

- `delta`:

  Treatment effect.

- `pE`:

  Experimental group response or failure rate.

- `Power`:

  Power for the test (asymptotic or simulated).

## Details

The function `binomialPowerTable()` creates a grid of all combinations
of control group response rates and treatment effects. All out of range
values (i.e., where the experimental group response rate is not between
0 and 1) are filtered out. For each combination, it computes the power
either analytically using
[`nBinomial()`](https://keaven.github.io/gsDesign/reference/varBinomial.md)
or through simulation using
[`simBinomial()`](https://keaven.github.io/gsDesign/reference/varBinomial.md).
When using simulation, the `simPowerBinomial()` function (not exported)
is called internally to perform the simulations. Assuming \\p\\ is the
true probability of a positive test, the simulation standard error is
\$\$\text{SE} = \sqrt{p(1 - p) / \text{nsim}}.\$\$ For example, when
approximating an underlying Type I error rate of 0.025, the simulation
standard error is 0.000156 with 1000000 simulations and the approximated
power 95 is 0.025 +/- 1.96 \* SE = 0.025 +/- 0.000306.

## See also

[`nBinomial`](https://keaven.github.io/gsDesign/reference/varBinomial.md),
[`simBinomial`](https://keaven.github.io/gsDesign/reference/varBinomial.md)

## Examples

``` r
# Create a power table with analytical power calculation
power_table <- binomialPowerTable(
  pC = c(0.8, 0.9),
  delta = seq(-0.05, 0.05, 0.025),
  n = 70
)

# Create a power table with simulation
power_table_sim <- binomialPowerTable(
  pC = c(0.8, 0.9),
  delta = seq(-0.05, 0.05, 0.025),
  n = 70,
  simulation = TRUE,
  nsim = 10000
)
```

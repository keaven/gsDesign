# Exact binomial repeated p-values for a group sequential design

Computes repeated p-values for the exact binomial design implied by a
\[gsSurv()\] object. The p-value at analysis \`j\` is the smallest local
one-sided alpha level for which the observed experimental-arm event
count crosses the exact lower efficacy bound at that analysis.
Non-binding futility bounds are ignored for the Type I error
calculation.

## Usage

``` r
repeatedPValueBinomialExact(
  gsD,
  n.I = NULL,
  x = NULL,
  interval = c(1e-20, 0.9999),
  tol = 1e-08,
  maxiter = 100,
  check = FALSE
)
```

## Arguments

- gsD:

  A \`gsSurv\` object with \`test.type\` 1 or 4.

- n.I:

  Increasing integer total event counts at completed analyses. If
  \`NULL\`, the planned exact binomial event counts from
  \`toBinomialExact(gsD)\` are used. This must have at most 1 value
  greater than or equal to planned final events (\`gsD\$maxn.IPlan\` if
  available, otherwise \`max(gsD\$n.I)\`).

- x:

  Integer experimental-arm event counts at the analyses in \`n.I\`.

- interval:

  Search interval for the p-values. As in \[sequentialPValue()\], values
  outside this interval are truncated to the nearest endpoint.

- tol:

  Relative tolerance for the monotone bisection search on the alpha
  scale.

- maxiter:

  Maximum number of bisection iterations for each analysis.

- check:

  Logical. If \`TRUE\`, checks the monotonicity of the alpha-indexed
  integer efficacy bounds on a coarse grid and warns if it is violated.

## Value

A data frame with one row per completed analysis containing:

- \`Analysis\`:

  Analysis index.

- \`n.I\`:

  Total events at analysis.

- \`x\`:

  Observed experimental-arm events.

- \`repeated_p_value\`:

  Repeated p-value for the analysis.

- \`bound_at_repeated_p_value\`:

  Integer efficacy bound at the repeated p-value.

## See also

\[sequentialPValueBinomialExact()\], \[sequentialPValue()\],
\[toBinomialExact()\], \[gsBinomialExact()\]

## Examples

``` r
x <- gsSurv(
  k = 3, test.type = 4, alpha = 0.025, beta = 0.1, timing = c(0.45, 0.7),
  sfu = sfHSD, sfupar = -4, sfl = sfLDOF, sflpar = 0,
  lambdaC = 0.001, hr = 0.3, hr0 = 0.7, eta = 5e-04,
  gamma = 10, R = 16, T = 24, minfup = 8, ratio = 3
)
counts <- toBinomialExact(x)$n.I
repeatedPValueBinomialExact(gsD = x, n.I = counts, x = c(12, 23, 38))
#>   Analysis n.I  x repeated_p_value bound_at_repeated_p_value
#> 1        1  31 12      0.008683036                        12
#> 2        2  48 23      0.013085131                        23
#> 3        3  69 38      0.019672838                        38
```

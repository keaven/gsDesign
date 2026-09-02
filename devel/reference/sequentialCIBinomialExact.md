# Exact sequential confidence intervals for vaccine or prevention efficacy

Forms a sequential confidence interval after each completed analysis by
intersecting the exact repeated confidence intervals through that
analysis.

## Usage

``` r
sequentialCIBinomialExact(
  gsD,
  n.I = NULL,
  x = NULL,
  conf.level = 0.95,
  tol = 1e-08,
  maxiter = 100
)
```

## Arguments

- gsD:

  A \`gsSurv\` object with non-binding \`test.type\` 1, 4, 6, or 8.

- n.I:

  Increasing integer total event counts at completed analyses. If
  \`NULL\`, planned integer event counts from \`toInteger(gsD)\` are
  used.

- x:

  Integer experimental-arm event counts at the analyses in \`n.I\`.

- conf.level:

  Two-sided confidence level.

- tol:

  Absolute tolerance for bisection on the conditional binomial
  event-probability scale.

- maxiter:

  Maximum bisection iterations for each confidence limit.

## Value

A data frame with one row per completed analysis containing the observed
counts, efficacy estimate, sequential confidence limits, confidence
level, and one-sided tail level.

## Details

The interval is the inversion of \[sequentialPValueBinomialExact()\]
applied in both directions: a candidate efficacy remains in the
confidence set only when neither one-sided repeated test has rejected it
at any completed analysis. Thus the sequential interval through analysis
\`j\` is the intersection of repeated intervals 1 through \`j\`.

## See also

\[ciBinomialExact()\], \[repeatedCIBinomialExact()\],
\[sequentialPValueBinomialExact()\]

## Examples

``` r
design <- gsSurv(
  k = 3, test.type = 4, timing = c(.45, .7), ratio = 3,
  hr = .3, hr0 = .7
)
counts <- toBinomialExact(design)$n.I
# \donttest{
sequentialCIBinomialExact(design, counts, x = c(12, 23, 38))
#>   Analysis n.I  x  estimate  conf.low conf.high conf.level tail_alpha
#> 1        1  31 12 0.7894737 0.3792904 0.9345737       0.95      0.025
#> 2        2  48 23 0.6933333 0.3792904 0.8562642       0.95      0.025
#> 3        3  68 38 0.5777778 0.3792904 0.7471530       0.95      0.025
# }
```

# Exact repeated confidence intervals for vaccine or prevention efficacy

Inverts exact binomial efficacy tests at each completed analysis to
obtain repeated confidence intervals for vaccine or prevention efficacy.

## Usage

``` r
repeatedCIBinomialExact(
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
counts, efficacy estimate, repeated confidence limits, confidence level,
and one-sided tail level.

## Details

A two-sided interval with confidence level \`1 - alpha\` uses the same
spending function, spending times, and count-path ordering in both
directions, with \`alpha / 2\` in each tail. The lower efficacy limit
inverts the usual lower event-count efficacy test. The upper efficacy
limit inverts its mirror image after exchanging experimental- and
control-arm event counts. This mirrored test is not the design's
futility boundary.

Non-binding futility and harm are ignored in both directions. Coverage
is generally conservative because the exact rejection regions are
discrete. Spending time remains relative to the planned final event
count.

This follows the repeated-confidence-interval construction of Jennison
and Turnbull (1984), using exact Bernoulli ordering as in Coe and
Tamhane (1993).

## References

Jennison, C. and Turnbull, B. W. (1984). Repeated confidence intervals
for group sequential clinical trials. \*Controlled Clinical Trials\*, 5,
33–45.

Coe, P. R. and Tamhane, A. C. (1993). Small sample confidence intervals
for the difference, ratio and odds ratio of two success probabilities.
\*Controlled Clinical Trials\*, 14, 270–290.

## See also

\[ciBinomialExact()\], \[sequentialCIBinomialExact()\],
\[repeatedPValueBinomialExact()\]

## Examples

``` r
design <- gsSurv(
  k = 3, test.type = 4, timing = c(.45, .7), ratio = 3,
  hr = .3, hr0 = .7
)
counts <- toBinomialExact(design)$n.I
# \donttest{
repeatedCIBinomialExact(design, counts, x = c(12, 23, 38))
#>   Analysis n.I  x  estimate  conf.low conf.high conf.level tail_alpha
#> 1        1  31 12 0.7894737 0.3792904 0.9345737       0.95      0.025
#> 2        2  48 23 0.6933333 0.3477728 0.8562642       0.95      0.025
#> 3        3  68 38 0.5777778 0.2902891 0.7471530       0.95      0.025
# }
```

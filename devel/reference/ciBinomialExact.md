# Exact confidence intervals for vaccine or prevention efficacy

Computes a fixed-look Clopper–Pearson confidence interval for vaccine or
prevention efficacy after conditioning on the total number of events.

## Usage

``` r
ciBinomialExact(
  x,
  n,
  ratio = 1,
  conf.level = 0.95,
  alternative = c("two.sided", "lower", "upper")
)
```

## Arguments

- x:

  Number of events in the experimental group.

- n:

  Total number of events.

- ratio:

  Experimental-to-control randomization ratio.

- conf.level:

  Confidence level.

- alternative:

  Character string specifying a two-sided interval, a lower confidence
  bound, or an upper confidence bound for efficacy.

## Value

A one-row data frame containing the observed counts, randomization
ratio, efficacy estimate, confidence limits, and confidence level.

## Details

Conditional on \`n\`, \`x\` is binomial with event probability \`p\` in
the experimental group. Clopper–Pearson limits for \`p\` are transformed
using \`efficacy = 1 - p / (ratio \* (1 - p))\`. Because this
transformation is decreasing, the probability limits are reversed on the
efficacy scale. The same calculation applies to vaccine efficacy (VE)
and prevention efficacy (PE).

## See also

\[repeatedCIBinomialExact()\], \[sequentialCIBinomialExact()\]

## Examples

``` r
ciBinomialExact(x = 16, n = 78, ratio = 3)
#>    x  n ratio  estimate  conf.low conf.high conf.level          method
#> 1 16 78     3 0.9139785 0.8490973 0.9536666       0.95 Clopper-Pearson
```

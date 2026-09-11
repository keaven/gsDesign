# Exact conditional power for a group sequential binomial design

Computes exact conditional probabilities of crossing future boundaries,
given the cumulative experimental-arm event count at an interim
analysis.

## Usage

``` r
gsCPBinomialExact(
  x,
  i = 1,
  x.i,
  theta = NULL,
  ve = NULL,
  ratio = x$ratio,
  binding = TRUE
)
```

## Arguments

- x:

  An exact binomial spending design returned by \[toBinomialExact()\].

- i:

  Interim analysis at which conditioning occurs; must be less than
  \`x\$k\`.

- x.i:

  Cumulative experimental-arm events observed at analysis \`i\`.

- theta:

  Conditional probabilities that a future event occurs in the
  experimental arm. If \`NULL\`, the observed probability and the values
  in \`x\$theta\` are used.

- ve:

  Vaccine or prevention efficacy assumptions. These are converted to
  conditional event probabilities using \`ratio\`. Specify at most one
  of \`theta\` and \`ve\`.

- ratio:

  Experimental-to-control randomization ratio. This defaults to the
  ratio retained by \[toBinomialExact()\]. It is required when \`ve\` is
  supplied and is also used to report efficacy corresponding to
  \`theta\`.

- binding:

  Logical indicating whether future futility or harm boundaries stop the
  trial. With \`FALSE\`, conditional efficacy power ignores these future
  non-binding boundaries. This argument does not restrict the observed
  result at analysis \`i\`.

## Value

An object of class \`gsBinomialExactCP\`. Components include future
absolute event counts, assumed conditional event probabilities and
efficacies, per-analysis efficacy and futility crossing probabilities,
continuation probabilities, and total conditional power and futility.

## Details

Conditional on the interim count, future experimental-arm event
increments are independent binomial random variables. Their distribution
is propagated through the remaining integer boundaries. Thus the
calculation is exact under the same conditional-binomial assumptions
used by \[gsBinomialExact()\].

The calculation conditions only on the statistic at analysis \`i\`, as
\[gsCP()\] does. It is computed regardless of whether the observed count
has crossed a current efficacy, futility, or harm boundary. This gives a
hypothetical projection if follow-up were to continue; it does not
reverse a stopping decision. The \`binding\` argument controls only
whether futility or harm boundaries at future analyses are enforced.
Thus, the default \`binding = TRUE\` includes future non-efficacy
stopping, whereas \`binding = FALSE\` ignores it.

## See also

\[gsCP()\], \[toBinomialExact()\], \[VEtable()\]

## Examples

``` r
design <- gsSurv(
  k = 2, test.type = 4, timing = .5, ratio = 3,
  hr = .3, hr0 = .7
)
exact_design <- toBinomialExact(design)
gsCPBinomialExact(exact_design, i = 1, x.i = 20, ve = c(.5, .7))
#> $k
#> [1] 1
#> 
#> $analysis
#> [1] 2
#> 
#> $n.I
#> [1] 66
#> 
#> $i
#> [1] 1
#> 
#> $n.I.i
#> [1] 33
#> 
#> $x.i
#> [1] 20
#> 
#> $theta
#> [1] 0.6000000 0.4736842
#> 
#> $efficacy
#> [1] 0.5 0.7
#> 
#> $binding
#> [1] TRUE
#> 
#> $lower
#> $lower$bound
#> [1] 36
#> 
#> $lower$prob
#>            0.6000000 0.4736842
#> Analysis 2 0.1210987 0.6197621
#> 
#> 
#> $upper
#> $upper$bound
#> [1] 38
#> 
#> $upper$prob
#>            0.6000000 0.4736842
#> Analysis 2 0.7940754 0.2571398
#> 
#> 
#> $continuation
#>             0.6000000 0.4736842
#> Analysis 2 0.08482594 0.1230981
#> 
#> $conditional_power
#> [1] 0.1210987 0.6197621
#> 
#> $conditional_futility
#> [1] 0.7940754 0.2571398
#> 
#> attr(,"class")
#> [1] "gsBinomialExactCP"
```

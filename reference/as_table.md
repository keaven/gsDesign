# Create a summary table

Create a tibble to summarize an object; currently only implemented for
[`gsBinomialExact`](https://keaven.github.io/gsDesign/reference/gsBinomialExact.md).

## Usage

``` r
as_table(x, ...)

# S3 method for class 'gsBinomialExact'
as_table(x, ...)
```

## Arguments

- x:

  Object to be summarized.

- ...:

  Other parameters that may be specific to the object.

## Value

A tibble which may have an extended class to enable further output
processing.

## Details

Currently only implemented for
[`gsBinomialExact`](https://keaven.github.io/gsDesign/reference/gsBinomialExact.md)
objects. Creates a table to summarize an object. For
[`gsBinomialExact`](https://keaven.github.io/gsDesign/reference/gsBinomialExact.md),
this summarized operating characteristics across a range of effect
sizes.

## See also

[`vignette("binomialSPRTExample")`](https://keaven.github.io/gsDesign/articles/binomialSPRTExample.md)

## Examples

``` r
b <- binomialSPRT(p0 = .1, p1 = .35, alpha = .08, beta = .2, minn = 10, maxn = 25)
b_power <- gsBinomialExact(
  k = length(b$n.I), theta = seq(.1, .45, .05), n.I = b$n.I,
  a = b$lower$bound, b = b$upper$bound
)
b_power |>
  as_table() |>
  as_gt()


  


Operating Characteristics for the Truncated SPRT Design
```

Assumes trial evaluated sequentially after each response

Underlying  
response rate

Probability of crossing

Average  
sample size

Futility bound

Efficacy bound

10%

0.94

0.04

12.1

15%

0.78

0.15

13.6

20%

0.57

0.32

14.3

25%

0.37

0.53

14.2

30%

0.22

0.71

13.4

35%

0.12

0.84

12.5

40%

0.06

0.92

11.6

45%

0.03

0.97

11.0

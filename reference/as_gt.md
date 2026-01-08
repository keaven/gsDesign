# Convert a summary table object to a gt object

Convert a summary table object created with
[`as_table`](https://keaven.github.io/gsDesign/reference/as_table.md) to
a `gt_tbl` object; currently only implemented for
[`gsBinomialExact`](https://keaven.github.io/gsDesign/reference/gsBinomialExact.md).

## Usage

``` r
as_gt(x, ...)

# S3 method for class 'gsBinomialExactTable'
as_gt(
  x,
  ...,
  title = "Operating Characteristics for the Truncated SPRT Design",
  subtitle = "Assumes trial evaluated sequentially after each response",
  theta_label = html("Underlying<br>response rate"),
  bound_label = c("Futility bound", "Efficacy bound"),
  prob_decimals = 2,
  en_decimals = 1,
  rr_decimals = 0
)
```

## Arguments

- x:

  Object to be converted.

- ...:

  Other parameters that may be specific to the object.

- title:

  Table title.

- subtitle:

  Table subtitle.

- theta_label:

  Label for theta.

- bound_label:

  Label for bounds.

- prob_decimals:

  Number of decimal places for probability of crossing.

- en_decimals:

  Number of decimal places for expected number of observations when
  bound is crossed or when trial ends without crossing.

- rr_decimals:

  Number of decimal places for response rates.

## Value

A `gt_tbl` object that may be extended by overloaded versions of
`as_gt`.

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
safety_design <- binomialSPRT(
  p0 = .04, p1 = .1, alpha = .04, beta = .2, minn = 4, maxn = 75
)
safety_power <- gsBinomialExact(
  k = length(safety_design$n.I),
  theta = seq(.02, .16, .02),
  n.I = safety_design$n.I,
  a = safety_design$lower$bound,
  b = safety_design$upper$bound
)
safety_power |>
  as_table() |>
  as_gt(
    theta_label = gt::html("Underlying<br>AE rate"),
    prob_decimals = 3,
    bound_label = c("low rate", "high rate")
  )


  


Operating Characteristics for the Truncated SPRT Design
```

Assumes trial evaluated sequentially after each response

Underlying  
AE rate

Probability of crossing

Average  
sample size

low rate

high rate

2%

0.964

0.001

34.8

4%

0.769

0.019

46.4

6%

0.506

0.108

54.3

8%

0.291

0.290

56.1

10%

0.155

0.516

52.8

12%

0.079

0.714

46.8

14%

0.039

0.851

40.2

16%

0.020

0.930

34.2

# Convert a summary table object to a gt object

`as_gt()` is deprecated in favor of
[`lt()`](https://rdrr.io/pkg/lt/man/lt.html), which produces a
lightweight HTML table without the heavy gt dependency. `as_gt()` is
kept for one release so existing code that customizes the output with gt
functions keeps working; it still returns a `gt_tbl` object and requires
gt to be installed. New code should use
[`lt()`](https://rdrr.io/pkg/lt/man/lt.html); see
[`lt-methods`](https://keaven.github.io/gsDesign/devel/reference/lt-methods.md)
for the available arguments, which mirror those of `as_gt()`.

## Usage

``` r
as_gt(x, ...)

# S3 method for class 'gsBinomialExactTable'
as_gt(
  x,
  ...,
  title = "Operating Characteristics for the Truncated SPRT Design",
  subtitle = "Assumes trial evaluated sequentially after each response",
  theta_label = gt::html("Underlying<br>response rate"),
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
`as_gt()`.

## See also

[`lt()`](https://rdrr.io/pkg/lt/man/lt.html),
[`lt-methods`](https://keaven.github.io/gsDesign/devel/reference/lt-methods.md)

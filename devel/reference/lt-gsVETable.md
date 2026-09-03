# Format a vaccine or prevention efficacy summary table

Applies standard labels, number formats, spanners, and explanatory
footnotes to a table returned by
[`VEtable`](https://keaven.github.io/gsDesign/devel/reference/VEtable.md).

## Usage

``` r
# S3 method for class 'gsVETable'
lt(
  data,
  ...,
  title = "Design Bounds and Operating Characteristics",
  subtitle = NULL,
  efficacy_label = c("VE", "PE"),
  time_decimals = 1,
  efficacy_decimals = 2,
  spending_decimals = 4
)
```

## Arguments

- data:

  A `gsVETable` object returned by
  [`VEtable`](https://keaven.github.io/gsDesign/devel/reference/VEtable.md).

- ...:

  Additional arguments passed to
  [`lt`](https://rdrr.io/pkg/lt/man/lt.html).

- title:

  Table title.

- subtitle:

  Optional table subtitle.

- efficacy_label:

  Whether to label efficacy as vaccine efficacy (`"VE"`) or prevention
  efficacy (`"PE"`).

- time_decimals:

  Number of decimal places for analysis time.

- efficacy_decimals:

  Number of decimal places for efficacy at the boundaries and power.

- spending_decimals:

  Number of decimal places for alpha and beta spending.

## Value

An `lt_tbl` object.

# Save a summary table object as an RTF file

Convert and save the summary table object created with
[`as_table`](https://keaven.github.io/gsDesign/reference/as_table.md) to
an RTF file using r2rtf; currently only implemented for
[`gsBinomialExact`](https://keaven.github.io/gsDesign/reference/gsBinomialExact.md).

## Usage

``` r
as_rtf(x, ...)

# S3 method for class 'gsBinomialExactTable'
as_rtf(
  x,
  file,
  ...,
  title = paste("Operating Characteristics by Underlying Response Rate for",
    "Exact Binomial Group Sequential Design"),
  theta_label = "Underlying Response Rate",
  response_outcome = TRUE,
  bound_label = if (response_outcome) c("Futility Bound", "Efficacy Bound") else
    c("Efficacy Bound", "Futility Bound"),
  en_label = "Expected Sample Sizes",
  prob_decimals = 2,
  en_decimals = 1,
  rr_decimals = 0
)

# S3 method for class 'gsBoundSummary'
as_rtf(
  x,
  file,
  ...,
  title = "Boundary Characteristics for Group Sequential Design",
  footnote_p_onesided = "one-side p-value for experimental better than control",
  footnote_appx_effect_at_bound = NULL,
  footnote_p_cross_h0 = "Cumulative type I error assuming binding futility bound",
  footnote_p_cross_h1 = "Cumulative power under the alternate hypothesis",
  footnote_specify = NULL,
  footnote_text = NULL
)
```

## Arguments

- x:

  Object to be saved as RTF file.

- ...:

  Other parameters that may be specific to the object.

- file:

  File path for the output.

- title:

  Title of the report.

- theta_label:

  Label for theta.

- response_outcome:

  Logical values indicating if the outcome is response rate (`TRUE`) or
  failure rate (`FALSE`). The default value is `TRUE`.

- bound_label:

  Label for bounds. If the outcome is response rate, then the label is
  "Futility bound" and "Efficacy bound". If the outcome is failure rate,
  then the label is "Efficacy bound" and "Futility bound".

- en_label:

  Label for expected number.

- prob_decimals:

  Number of decimal places for probability of crossing.

- en_decimals:

  Number of decimal places for expected number of observations when
  bound is crossed or when trial ends without crossing.

- rr_decimals:

  Number of decimal places for response rates.

- footnote_p_onesided:

  Footnote for one-side p-value.

- footnote_appx_effect_at_bound:

  Footnote for approximate effect treatment at bound.

- footnote_p_cross_h0:

  Footnote for cumulative type I error.

- footnote_p_cross_h1:

  Footnote for cumulative power under the alternate hypothesis.

- footnote_specify:

  Vector of string to put footnote super script.

- footnote_text:

  Vector of string of footnote text.

## Value

`as_rtf()` returns the input `x` invisibly.

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
# as_rtf for gsBinomialExact
zz <- gsBinomialExact(
  k = 3, theta = seq(0.1, 0.9, 0.1), n.I = c(12, 24, 36),
  a = c(-1, 0, 11), b = c(5, 9, 12)
)
zz %>%
  as_table() %>%
  as_rtf(
    file = tempfile(fileext = ".rtf"),
    title = "Power/Type I Error and Expected Sample Size for a Group Sequential Design"
  )

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
safety_power %>%
  as_table() %>%
  as_rtf(
    file = tempfile(fileext = ".rtf"),
    theta_label = "Underlying\nAE Rate",
    prob_decimals = 3,
    bound_label = c("Low Rate", "High Rate")
  )
# as_rtf for gsBoundSummary
xgs <- gsSurv(lambdaC = .2, hr = .5, eta = .1, T = 2, minfup = 1.5)
gsBoundSummary(xgs, timename = "Year", tdigits = 1) %>% as_rtf(file = tempfile(fileext = ".rtf"))

ss <- nSurvival(
  lambda1 = .2, lambda2 = .1, eta = .1, Ts = 2, Tr = .5,
  sided = 1, alpha = .025, ratio = 2
)
xs <- gsDesign(nFixSurv = ss$n, n.fix = ss$nEvents, delta1 = log(ss$lambda2 / ss$lambda1))
gsBoundSummary(xs, logdelta = TRUE, ratio = ss$ratio) %>% as_rtf(file = tempfile(fileext = ".rtf"))

xs <- gsDesign(nFixSurv = ss$n, n.fix = ss$nEvents, delta1 = log(ss$lambda2 / ss$lambda1))
gsBoundSummary(xs, logdelta = TRUE, ratio = ss$ratio) %>% 
  as_rtf(file = tempfile(fileext = ".rtf"),
  footnote_specify = "Z",
  footnote_text = "Z-Score")
```

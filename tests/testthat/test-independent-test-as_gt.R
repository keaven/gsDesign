test_that("Snapshot test for gsBinomialExact safety table", {
  skip_on_cran()

  gt_to_latex <- function(data) cat(as.character(gt::as_latex(data)))

  safety_design <- binomialSPRT(p0 = 0.04, p1 = 0.1, alpha = 0.04, beta = 0.2, minn = 4, maxn = 75)
  safety_power <- gsBinomialExact(
    k = length(safety_design$n.I),
    theta = seq(0.02, 0.16, 0.02),
    n.I = safety_design$n.I,
    a = safety_design$lower$bound,
    b = safety_design$upper$bound
  )
  output <- safety_power %>%
    as_table() %>%
    as_gt(
      theta_label = gt::html("Underlying<br>AE rate"),
      prob_decimals = 3,
      bound_label = c("low rate", "high rate")
    )

  expect_s3_class(output, "gt_tbl")

  local_edition(3)
  expect_snapshot_output(gt_to_latex(output))
})

test_that("Number of set decimals for `Probability of crossing` are respected", {
  safety_design <- binomialSPRT(p0 = 0.04, p1 = 0.1, alpha = 0.04, beta = 0.2, minn = 4, maxn = 75)
  safety_power <- gsBinomialExact(
    k = length(safety_design$n.I),
    theta = seq(0.02, 0.16, 0.02),
    n.I = safety_design$n.I,
    a = safety_design$lower$bound,
    b = safety_design$upper$bound
  )
  output <- safety_power %>%
    as_table() %>%
    as_gt(
      theta_label = gt::html("Underlying<br>AE rate"),
      prob_decimals = 3,
      bound_label = c("low rate", "high rate")
    )

  # Get formats where columns include "Lower" or "Upper"
  prob_format <- Filter(function(x) any(x$columns %in% c("Lower", "Upper")), output[["_formats"]])

  # Get formats where columns include "theta"
  rr_format <- Filter(function(x) any(x$columns == "theta"), output[["_formats"]])

  expect_true(all(sapply(prob_format, function(x) x$decimals == 3)))
  expect_true(all(sapply(rr_format, function(x) x$decimals == 1)))
})

test_that("We can set custom title and subtitles", {
  safety_design <- binomialSPRT(p0 = 0.04, p1 = 0.1, alpha = 0.04, beta = 0.2, minn = 4, maxn = 75)
  safety_power <- gsBinomialExact(
    k = length(safety_design$n.I),
    theta = seq(0.02, 0.16, 0.02),
    n.I = safety_design$n.I,
    a = safety_design$lower$bound,
    b = safety_design$upper$bound
  )
  output <- safety_power %>%
    as_table() %>%
    as_gt(
      title = "Custom Title",
      subtitle = "Custom Subtitle",
      theta_label = gt::html("Underlying<br>AE rate"),
      prob_decimals = 3,
      bound_label = c("low rate", "high rate")
    )

  expect_equal(output[["_heading"]]$title, "Custom Title")
  expect_equal(output[["_heading"]]$subtitle, "Custom Subtitle")
})

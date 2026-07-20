safety_lt <- function(...) {
  safety_design <- binomialSPRT(p0 = 0.04, p1 = 0.1, alpha = 0.04, beta = 0.2, minn = 4, maxn = 75)
  safety_power <- gsBinomialExact(
    k = length(safety_design$n.I),
    theta = seq(0.02, 0.16, 0.02),
    n.I = safety_design$n.I,
    a = safety_design$lower$bound,
    b = safety_design$upper$bound
  )
  safety_power |>
    as_table() |>
    lt::lt(...)
}

# Number formatting operations recorded on an lt_tbl for the given columns.
fmt_for <- function(x, cols) {
  Filter(
    function(op) op$type == "fmt_number" && any(op$columns %in% cols),
    x$ops
  )
}

test_that("Number of set decimals for `Probability of crossing` are respected", {
  output <- safety_lt(
    theta_label = I("Underlying<br>AE rate"),
    prob_decimals = 3,
    bound_label = c("low rate", "high rate")
  )

  prob_format <- fmt_for(output, c("Lower", "Upper"))
  rr_format <- fmt_for(output, "theta")

  expect_true(all(vapply(prob_format, function(x) x$decimals == 3, logical(1))))
  expect_true(all(vapply(rr_format, function(x) x$decimals == 0, logical(1))))
})

test_that("We can set custom title and subtitles", {
  output <- safety_lt(
    title = "Custom Title",
    subtitle = "Custom Subtitle",
    theta_label = I("Underlying<br>AE rate"),
    prob_decimals = 3,
    bound_label = c("low rate", "high rate")
  )

  expect_equal(output$header$title, "Custom Title")
  expect_equal(output$header$subtitle, "Custom Subtitle")
})

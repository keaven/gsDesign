test_that("print.gsSurv prints full t-distribution spending parameters (issue #307)", {
  # The t-distribution spending function has parameters with decimal values.
  # print.gsSurv previously split the summary on bare periods, truncating
  # "a = -1.63774" to "a = -1". Verify all three parameters are printed.
  x <- gsSurv(
    k = 3, test.type = 4, alpha = 0.025, beta = 0.1, timing = 1,
    sfu = sfTDist, sfupar = c(0.2, 0.5, 0.01, 0.1, 3),
    sfl = sfLDOF, sflpar = 0,
    lambdaC = log(2) / 6, hr = 0.6, hr0 = 1, eta = 0.01,
    gamma = c(2.5, 5, 7.5, 10), R = c(2, 2, 2, 6), T = 18, minfup = 6, ratio = 1
  )
  out <- paste(capture.output(print(x)), collapse = "\n")

  # The full t-distribution parameter sentence must appear intact.
  expect_match(
    out,
    "t-distribution spending function with a = -1.63774, b = 2.96683, df = 3",
    fixed = TRUE
  )
  # And it must not be truncated to just the first (integer) digit.
  expect_false(grepl("spending function with a = -1\\.\\n", out))
})

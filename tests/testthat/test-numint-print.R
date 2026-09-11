# Snapshot tests for designs in which some analyses have no bound (zero
# incremental spending or a skipped analysis). These document how the
# "no bound" sentinel produced by the C code is displayed.

# Ignore incidental trailing spaces and blank lines in printed output.
numint_print_output <- function(x) {
  x <- sub("[[:blank:]]+$", "", x)
  x[nzchar(x)]
}

testthat::test_that("printing designs with zero-spend analyses is stable", {
  testthat::local_edition(3)
  x <- gsDesign(k = 4, test.type = 1, sfu = sfTruncated, sfupar = list(sf = sfHSD, param = -4, trange = c(0.4, 1)))
  testthat::expect_snapshot(print(x), transform = numint_print_output)
  testthat::expect_snapshot(print(gsBoundSummary(x)), transform = numint_print_output)
  y <- gsDesign(k = 3, test.type = 4, testUpper = c(FALSE, TRUE, TRUE), testLower = c(TRUE, FALSE, TRUE))
  testthat::expect_snapshot(print(y), transform = numint_print_output)
  testthat::expect_snapshot(print(gsBoundSummary(y)), transform = numint_print_output)
  testthat::expect_snapshot(print(gsProbability(d = y, theta = c(0, y$delta, 2 * y$delta))), transform = numint_print_output)
})

testthat::test_that("printing low-level boundary objects with zero spending is stable", {
  testthat::local_edition(3)
  testthat::expect_snapshot(print(gsBound(I = c(1, 2, 3), trueneg = c(0.01, 0, 0.02), falsepos = c(0.001, 0, 0.024))), transform = numint_print_output)
  testthat::expect_snapshot(print(gsBound1(theta = 0, I = c(1, 2, 3), a = rep(-20, 3), probhi = c(0.001, 0, 0.024))), transform = numint_print_output)
})

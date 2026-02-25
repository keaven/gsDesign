test_that("gsDensity computes interim density values", {
  expect_error(gsDensity(list()), "must have class gsDesign or gsProbability")

  x <- gsDesign(k = 3, test.type = 4, alpha = 0.025, beta = 0.1)
  res <- gsDensity(x, theta = c(0, x$delta), i = 2L, zi = c(-1, 0, 1), r = 10L)
  expect_equal(dim(res$density), c(3, 2))
  expect_equal(length(res$zi), 3)
  expect_equal(length(res$theta), 2)
})

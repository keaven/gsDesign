test_that("nBinomial1Sample returns full table when beta is NULL", {
  res <- nBinomial1Sample(
    p0 = 0.9, p1 = 0.95, alpha = 0.05,
    beta = NULL, n = 10:12
  )
  expect_true(is.data.frame(res))
  expect_equal(nrow(res), 3)
  expect_true(all(c("p0", "p1", "alpha", "beta", "n", "b", "alphaR", "Power") %in% names(res)))
})

test_that("nBinomial1Sample handles boundary conditions for power", {
  expect_error(
    nBinomial1Sample(p0 = 0.9, p1 = 0.95, alpha = 0.05, beta = 0.1, n = 5:6),
    "insufficient to power trial"
  )
  expect_error(
    nBinomial1Sample(p0 = 0.5, p1 = 0.9, alpha = 0.05, beta = 0.9, n = 50:55),
    "All input sample sizes"
  )
})

test_that("nBinomial1Sample supports outtype and conservative options", {
  res <- nBinomial1Sample(
    p0 = 0.8, p1 = 0.9, alpha = 0.05, beta = 0.2,
    n = 70:90, outtype = 2, conservative = TRUE
  )
  expect_true(is.data.frame(res))
  expect_true(res$n %in% 70:90)

  n_required <- nBinomial1Sample(
    p0 = 0.8, p1 = 0.9, alpha = 0.05, beta = 0.2,
    n = 70:90, outtype = 1, conservative = FALSE
  )
  expect_true(n_required %in% 70:90)
})

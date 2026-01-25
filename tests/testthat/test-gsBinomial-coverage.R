test_that("ciBinomial handles scales and edge cases", {
  res <- ciBinomial(x1 = 5L, x2 = 3L, n1 = 10L, n2 = 10L, scale = "Difference")
  expect_true(all(c("lower", "upper") %in% names(res)))


  res <- ciBinomial(x1 = 0L, x2 = 2L, n1 = 10L, n2 = 10L, scale = "RR")
  expect_true(is.finite(res$upper))
  expect_equal(res$lower, 0)

  res <- ciBinomial(x1 = 1L, x2 = 0L, n1 = 10L, n2 = 10L, scale = "RR")
  expect_true(res$upper >= 1)

  res <- ciBinomial(x1 = 0L, x2 = 9L, n1 = 10L, n2 = 10L, scale = "OR")
  expect_true(is.numeric(res$upper))
})

test_that("nBinomial supports multiple scales and outputs", {
  out <- nBinomial(p1 = 0.6, p2 = 0.4, alpha = 0.05, beta = 0.2, scale = "Difference")
  expect_true(out > 0)

  out <- nBinomial(p1 = 0.6, p2 = 0.4, alpha = 0.05, beta = 0.2, scale = "RR", outtype = 2)
  expect_true(all(c("n1", "n2") %in% names(out)))

  out <- nBinomial(p1 = 0.6, p2 = 0.4, alpha = 0.05, beta = 0.2, scale = "OR", outtype = 3)
  expect_true(all(c("n", "Power", "sigma0", "sigma1") %in% names(out)))

  out <- nBinomial(p1 = 0.6, p2 = 0.4, alpha = 0.05, beta = 0.2, scale = "LNOR", outtype = 3)
  expect_true(all(c("n", "Power") %in% names(out)))

  pwr <- nBinomial(p1 = 0.6, p2 = 0.4, alpha = 0.05, n = 50, scale = "Difference", outtype = 2)
  expect_true(all(c("n1", "n2", "Power") %in% names(pwr)))

  pwr <- nBinomial(p1 = 0.6, p2 = 0.4, alpha = 0.05, n = 50, scale = "RR", outtype = 3)
  expect_true(all(c("n", "Power") %in% names(pwr)))

  expect_error(
    nBinomial(p1 = 0.5, p2 = 0.5, alpha = 0.05, beta = 0.2, delta0 = 0, scale = "Difference"),
    "p1 may not equal p2"
  )
  expect_error(
    nBinomial(p1 = 0.6, p2 = 0.5, alpha = 0.05, beta = 0.2, delta0 = 0.1, scale = "Difference"),
    "p1 - p2 may not equal delta0"
  )
})

test_that("testBinomial and simBinomial work for alternative scales", {
  z <- testBinomial(x1 = 5, x2 = 4, n1 = 10, n2 = 10, scale = "Difference")
  expect_true(is.numeric(z))

  z <- testBinomial(x1 = 5, x2 = 4, n1 = 10, n2 = 10, scale = "RR")
  expect_true(is.numeric(z))

  z <- testBinomial(x1 = 5, x2 = 4, n1 = 10, n2 = 10, scale = "OR")
  expect_true(is.numeric(z))

  z <- testBinomial(x1 = 5, x2 = 4, n1 = 10, n2 = 10, scale = "LNOR")
  expect_true(is.numeric(z))

  z <- testBinomial(
    x1 = c(0, 10), x2 = c(0, 10), n1 = 10, n2 = 10,
    scale = "LNOR", chisq = 1, adj = 1
  )
  expect_equal(length(z), 2)

  set.seed(1)
  sim <- simBinomial(p1 = 0.6, p2 = 0.4, n1 = 10L, n2 = 10L, nsim = 20, scale = "RR")
  expect_equal(length(sim), 20)
})

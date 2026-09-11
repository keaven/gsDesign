test_that("ciBinomialExact transforms Clopper-Pearson limits to efficacy", {
  result <- ciBinomialExact(x = 16, n = 78, ratio = 3, conf.level = .95)
  probability_ci <- stats::binom.test(16, 78, conf.level = .95)$conf.int
  transform <- function(p) 1 - p / (3 * (1 - p))

  expect_equal(result$estimate, transform(16 / 78))
  expect_equal(result$conf.low, transform(probability_ci[2]))
  expect_equal(result$conf.high, transform(probability_ci[1]))
  expect_equal(result$method, "Clopper-Pearson")
})

test_that("ciBinomialExact supports one-sided efficacy limits", {
  lower <- ciBinomialExact(16, 78, ratio = 3, alternative = "lower")
  upper <- ciBinomialExact(16, 78, ratio = 3, alternative = "upper")

  expect_equal(lower$conf.high, 1)
  expect_equal(upper$conf.low, -Inf)
  expect_true(lower$conf.low < lower$estimate)
  expect_true(upper$conf.high > upper$estimate)
})

test_that("ciBinomialExact validates inputs", {
  expect_error(ciBinomialExact(-1, 10), "non-negative integer")
  expect_error(ciBinomialExact(11, 10), "cannot exceed")
  expect_error(ciBinomialExact(1, 0), "positive integer")
  expect_error(ciBinomialExact(1, 10, ratio = 0), "finite positive scalar")
  expect_error(ciBinomialExact(1, 10, conf.level = 1), "strictly between")
})

exact_ci_design <- function() {
  gsSurv(
    k = 3,
    test.type = 4,
    alpha = .025,
    beta = .1,
    timing = c(.45, .7),
    sfu = sfHSD,
    sfupar = -3,
    sfl = sfHSD,
    sflpar = -3,
    ratio = 3,
    hr = .3,
    hr0 = .7
  )
}

test_that("repeated exact intervals use equal tails and mirrored ordering", {
  design <- exact_ci_design()
  counts <- toBinomialExact(design)$n.I
  result <- repeatedCIBinomialExact(design, counts, c(12, 23, 38), tol = 1e-6)

  expect_equal(result$tail_alpha, rep(.025, 3))
  expect_true(all(result$conf.low <= result$estimate))
  expect_true(all(result$estimate <= result$conf.high))
  expect_true(all(is.finite(result$conf.low)))
  expect_true(all(result$conf.high <= 1))
})

test_that("a one-look repeated interval reduces to Clopper-Pearson", {
  design <- gsSurv(
    k = 1, test.type = 1, alpha = .025, beta = .1,
    ratio = 3, hr = .3, hr0 = .7
  )
  n <- toInteger(design)$n.I
  x <- 13
  fixed <- ciBinomialExact(x, n, ratio = 3)
  repeated <- repeatedCIBinomialExact(design, n, x, tol = 1e-7)

  expect_equal(repeated$conf.low, fixed$conf.low, tolerance = 1e-6)
  expect_equal(repeated$conf.high, fixed$conf.high, tolerance = 1e-6)
})

test_that("sequential exact intervals intersect repeated intervals", {
  design <- exact_ci_design()
  counts <- toBinomialExact(design)$n.I
  repeated <- repeatedCIBinomialExact(design, counts, c(12, 23, 38), tol = 1e-6)
  sequential <- sequentialCIBinomialExact(design, counts, c(12, 23, 38), tol = 1e-6)

  expect_equal(sequential$conf.low, cummax(repeated$conf.low))
  expect_equal(sequential$conf.high, cummin(repeated$conf.high))
  expect_true(all(diff(sequential$conf.low) >= 0))
  expect_true(all(diff(sequential$conf.high) <= 0))
})

test_that("repeated exact confidence intervals validate inputs", {
  design <- exact_ci_design()
  counts <- toBinomialExact(design)$n.I

  expect_error(repeatedCIBinomialExact(list(), counts, c(1, 2, 3)), "class gsSurv")
  expect_error(repeatedCIBinomialExact(design, counts, NULL), "must contain")
  expect_error(repeatedCIBinomialExact(design, counts[-1], c(1, 2, 3)), "same length")
  expect_error(repeatedCIBinomialExact(design, counts, counts + 1), "cannot exceed")
  expect_error(repeatedCIBinomialExact(design, counts, c(1, 2, 3), tol = 0), "positive scalar")
})

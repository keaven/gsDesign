test_that("toBinomialExact validates inputs", {
  expect_error(toBinomialExact(list()), "must have class gsSurv")

  x_bad <- gsSurv(
    k = 2, test.type = 2, alpha = 0.025, beta = 0.1,
    timing = 1, sfu = sfHSD, sfupar = -4,
    lambdaC = 0.1, hr = 0.7, hr0 = 1, eta = 0.01,
    gamma = 5, R = 6, T = 12, minfup = 6
  )
  expect_error(toBinomialExact(x_bad), "test.type must be 1, 4, 6, or 8")

  x <- gsSurv(
    k = 2, test.type = 4, alpha = 0.025, beta = 0.1,
    timing = 1, sfu = sfHSD, sfupar = -4, sfl = sfLDOF, sflpar = 0,
    lambdaC = 0.1, hr = 0.7, hr0 = 1, eta = 0.01,
    gamma = 5, R = 6, T = 12, minfup = 6
  )
  expect_error(
    toBinomialExact(x, observedEvents = c(1.5, 3)),
    "must be a vector of increasing positive integers"
  )
  expect_error(
    toBinomialExact(x, observedEvents = c(5, 4)),
    "must be a vector of increasing positive integers"
  )
  expect_error(
    toBinomialExact(x, observedEvents = 5),
    "must have at least 2 values"
  )
  if (!is.null(x$maxn.IPlan) && is.finite(x$maxn.IPlan) && x$maxn.IPlan > 0) {
    expect_error(
      toBinomialExact(
        x,
        observedEvents = c(as.integer(x$maxn.IPlan), as.integer(x$maxn.IPlan) + 1)
      ),
      "at most 1 value"
    )
  }
})

test_that("toBinomialExact returns gsBinomialExact objects", {
  x <- gsSurv(
    k = 2, test.type = 4, alpha = 0.025, beta = 0.1,
    timing = 1, sfu = sfHSD, sfupar = -4, sfl = sfLDOF, sflpar = 0,
    lambdaC = 0.1, hr = 0.7, hr0 = 1, eta = 0.01,
    gamma = 5, R = 6, T = 12, minfup = 6
  )
  y <- toBinomialExact(x)
  expect_s3_class(y, "gsBinomialExact")
  expect_true(is.list(y$init_approx))

  obs <- as.integer(round(x$n.I))
  if (obs[2] <= obs[1]) obs[2] <- obs[1] + 1
  y <- toBinomialExact(x, observedEvents = obs)
  expect_s3_class(y, "gsBinomialExact")
})

test_that("toBinomialExact retains spending design metadata", {
  design <- gsSurv(
    k = 3,
    test.type = 4,
    alpha = .025,
    beta = .1,
    timing = c(.45, .7),
    sfu = sfHSD,
    sfupar = -4,
    sfl = sfLDOF,
    sflpar = 0,
    lambdaC = .001,
    hr = .3,
    hr0 = .7,
    eta = 5e-4,
    gamma = 10,
    R = 16,
    T = 24,
    minfup = 8,
    ratio = 3
  )
  result <- toBinomialExact(
    design,
    observedEvents = c(20, 55, 75),
    usTime = c(.25, .65, 1),
    lsTime = c(.2, .6, 1),
    maxSpend = TRUE
  )

  expect_s3_class(result, "gsBinomialExactSpending")
  expect_s3_class(result, "gsBinomialExact")
  expect_identical(
    class(result),
    c("gsBinomialExactSpending", "gsBinomialExact", "gsProbability")
  )
  expect_equal(result$alpha, design$alpha)
  expect_equal(result$beta, design$beta)
  expect_equal(result$ratio, design$ratio)
  expect_equal(result$testUpper, design$testUpper)
  expect_equal(result$testLower, design$testLower)
  expect_equal(result$usTime, c(.25, .65, 1))
  expect_equal(result$lsTime, c(.2, .6, 1))
  expect_equal(result$maxn.IPlan, design$maxn.IPlan)
  expect_true(result$maxSpend)
  expect_identical(result$call[[1]], quote(toBinomialExact))
})

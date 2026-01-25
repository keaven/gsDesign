test_that("toBinomialExact validates inputs", {
  expect_error(toBinomialExact(list()), "must have class gsSurv")

  x_bad <- gsSurv(
    k = 2, test.type = 2, alpha = 0.025, beta = 0.1,
    timing = 1, sfu = sfHSD, sfupar = -4,
    lambdaC = 0.1, hr = 0.7, hr0 = 1, eta = 0.01,
    gamma = 5, R = 6, T = 12, minfup = 6
  )
  expect_error(toBinomialExact(x_bad), "test.type must be 1 or 4")

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

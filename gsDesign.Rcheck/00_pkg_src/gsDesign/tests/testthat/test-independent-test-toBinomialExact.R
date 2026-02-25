surv_design <- function(test.type = 4) {
  gsSurv(
    k = 3,
    test.type = test.type,
    alpha = 0.025,
    beta = 0.1,
    timing = c(0.45, 0.7),
    sfu = sfHSD,
    sfupar = -4,
    sfl = sfLDOF,
    sflpar = 0,
    lambdaC = 0.001,
    hr = 0.3,
    hr0 = 0.7,
    eta = 5e-04,
    gamma = 10,
    R = 16,
    T = 24,
    minfup = 8,
    ratio = 3
  )
}

test_that("toBinomialExact validates inputs", {
  expect_error(toBinomialExact(1), "class gsSurv")

  design <- surv_design()
  design_bad <- design
  design_bad$test.type <- 2
  expect_error(toBinomialExact(design_bad), "test.type must be 1 or 4")

  expect_error(
    toBinomialExact(design, observedEvents = c(20.5, 30)),
    "vector of increasing positive integers"
  )
  expect_error(
    toBinomialExact(design, observedEvents = c(30, 30, 40)),
    "vector of increasing positive integers"
  )
  expect_error(
    toBinomialExact(design, observedEvents = 50),
    "must have at least 2 values"
  )

  design_int <- toInteger(design)
  too_many_final <- c(design_int$maxn.IPlan, design_int$maxn.IPlan + 1)
  expect_error(
    toBinomialExact(design, observedEvents = too_many_final),
    "at most 1 value in observedEvents"
  )
})

test_that("toBinomialExact converts survival design to monotone integer bounds", {
  design <- surv_design()
  expected_counts <- toInteger(design)$n.I

  result <- toBinomialExact(design)

  expect_s3_class(result, c("gsBinomialExact", "gsProbability"))
  expect_equal(result$k, design$k)
  expect_equal(result$n.I, expected_counts)

  expect_equal(result$lower$bound, c(12, 23, 38))
  expect_equal(result$upper$bound, c(22, 30, 39))
  expect_equal(result$init_approx$a, c(12, 23, 38))
  expect_equal(result$init_approx$b, c(21, 29, 39))

  expect_true(all(diff(result$lower$bound) >= 0))
  expect_true(all(diff(result$upper$bound) >= 0))
  expect_true(all(result$lower$bound < result$upper$bound))
})

test_that("observedEvents re-plans design using supplied event counts", {
  design <- surv_design()
  observed <- c(20, 55, 80)

  result <- toBinomialExact(design, observedEvents = observed)

  expect_equal(result$k, length(observed))
  expect_equal(result$n.I, observed)

  expect_equal(result$lower$bound, c(6, 28, 45))
  expect_equal(result$upper$bound, c(17, 33, 46))
  expect_equal(result$init_approx$a, c(6, 28, 44))
  expect_equal(result$init_approx$b, c(16, 32, 45))

  expect_true(all(diff(result$lower$bound) >= 0))
  expect_true(all(diff(result$upper$bound) >= 0))
  expect_true(all(result$lower$bound < result$upper$bound))
})

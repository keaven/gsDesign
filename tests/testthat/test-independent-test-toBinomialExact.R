surv_design <- function(
    test.type = 4,
    testLower = TRUE,
    astar = 0,
    testHarm = TRUE) {
  gsSurv(
    k = 3,
    test.type = test.type,
    alpha = 0.025,
    beta = 0.1,
    astar = astar,
    timing = c(0.45, 0.7),
    sfu = sfHSD,
    sfupar = -4,
    sfl = sfLDOF,
    sflpar = 0,
    sfharm = sfHSD,
    sfharmparam = 2,
    lambdaC = 0.001,
    hr = 0.3,
    hr0 = 0.7,
    eta = 5e-04,
    gamma = 10,
    R = 16,
    T = 24,
    minfup = 8,
    ratio = 3,
    testLower = testLower,
    testHarm = testHarm
  )
}

test_that("toBinomialExact validates inputs", {
  expect_error(toBinomialExact(1), "class gsSurv")

  design <- surv_design()
  design_bad <- design
  design_bad$test.type <- 2
  expect_error(toBinomialExact(design_bad), "test.type must be 1, 4, 6, or 8")

  expect_error(
    toBinomialExact(design, alpha = c(0.01, 0.02)),
    "toBinomialExact: alpha must be a finite numeric scalar in \\(0, 1\\)"
  )
  expect_error(
    toBinomialExact(design, alpha = 1),
    "toBinomialExact: alpha must be a finite numeric scalar in \\(0, 1\\)"
  )
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
  expect_error(
    toBinomialExact(design, maxSpend = c(TRUE, FALSE)),
    "maxSpend must be TRUE or FALSE"
  )
  expect_error(
    toBinomialExact(design, usTime = c(0.4, 0.3, 1)),
    "usTime must be strictly increasing and positive"
  )
  expect_error(
    toBinomialExact(design, usTime = 0.3),
    "usTime must have length k or k-1"
  )

  design_int <- toInteger(design)
  too_many_final <- c(design_int$maxn.IPlan, design_int$maxn.IPlan + 1)
  expect_error(
    toBinomialExact(design, observedEvents = too_many_final),
    "at most 1 value in observedEvents"
  )
})

test_that("toBinomialExact documents its test.type support matrix", {
  expect_s3_class(toBinomialExact(surv_design(test.type = 1)), "gsBinomialExact")
  expect_s3_class(toBinomialExact(surv_design(test.type = 4)), "gsBinomialExact")
  expect_s3_class(toBinomialExact(surv_design(test.type = 6)), "gsBinomialExact")
  expect_s3_class(toBinomialExact(surv_design(test.type = 8)), "gsBinomialExact")

  expected_reason <- c(
    `2` = "symmetric two-sided boundaries",
    `3` = "binding futility bounds",
    `5` = "binding lower bounds",
    `7` = "binding futility and harm bounds"
  )
  for (test_type in as.integer(names(expected_reason))) {
    expect_error(
      toBinomialExact(surv_design(test.type = test_type)),
      expected_reason[[as.character(test_type)]],
      label = paste("test.type", test_type)
    )
  }
})

test_that("toBinomialExact partitions test.type 8 futility and harm stops", {
  design <- surv_design(test.type = 8, astar = 0.2)
  design_integer <- toInteger(design)
  result <- toBinomialExact(design)
  spending_time <- pmin(result$n.I / design_integer$maxn.IPlan, 1)
  harm_target <- design$harm$sf(
    alpha = design$astar,
    t = spending_time,
    param = design$harm$param
  )$spend
  total_lower_target <- design$lower$sf(
    alpha = design$beta,
    t = spending_time,
    param = design$lower$param
  )$spend

  expect_equal(result$test.type, 8)
  expect_equal(result$astar, design$astar)
  expect_equal(result$testLower, rep(TRUE, design$k))
  expect_equal(result$testHarm, rep(TRUE, design$k))
  expect_equal(result$upper$prob, result$futility$prob + result$harm$prob)
  expect_equal(
    result$upper$bound,
    pmin(result$futility$bound, result$harm$bound)
  )
  expect_true(all(cumsum(result$harm$prob[, 1]) <= harm_target + 1e-10))
  expect_true(all(cumsum(result$upper$prob[, 2]) <= total_lower_target + 1e-10))

  nonbinding_efficacy <- gsBinomialExact(
    k = result$k,
    theta = result$theta[1],
    n.I = result$n.I,
    a = result$lower$bound,
    b = result$n.I + 1L
  )
  expect_lte(sum(nonbinding_efficacy$lower$prob), design$alpha)
})

test_that("test.type 8 honors selective futility and harm looks", {
  design <- surv_design(
    test.type = 8,
    astar = 0.2,
    testLower = c(FALSE, TRUE, TRUE),
    testHarm = c(TRUE, FALSE, TRUE)
  )
  result <- toBinomialExact(design)

  expect_identical(result$testLower, c(FALSE, TRUE, TRUE))
  expect_identical(result$testHarm, c(TRUE, FALSE, TRUE))
  expect_equal(unname(result$futility$prob[1, ]), c(0, 0), tolerance = 1e-12)
  expect_equal(unname(result$harm$prob[2, ]), c(0, 0), tolerance = 1e-12)
  expect_equal(result$upper$prob, result$futility$prob + result$harm$prob)
})

test_that("test.type 8 supports analysis-time overrides", {
  design <- surv_design(test.type = 8)
  observed <- c(20L, 55L, 75L)
  result <- toBinomialExact(
    design,
    observedEvents = observed,
    alpha = 0.01,
    usTime = c(0.25, 0.65, 0.95),
    lsTime = c(0.2, 0.55, 0.9),
    maxSpend = TRUE
  )

  expect_equal(result$n.I, observed)
  expect_equal(result$alpha, 0.01)
  expect_equal(result$astar, 0.99)
  expect_equal(result$upper$prob, result$futility$prob + result$harm$prob)
})

test_that("three-region exact recursion reduces to gsBinomialExact", {
  theta <- c(0.3, 0.5)
  n.I <- c(20L, 40L, 60L)
  a <- c(3L, 8L, 15L)
  b <- c(12L, 23L, 34L)
  expected <- gsBinomialExact(k = 3, theta = theta, n.I = n.I, a = a, b = b)
  result <- gsBinomialExactHarm(
    theta = theta,
    n.I = n.I,
    a = a,
    futility = b,
    harm = n.I + 1L,
    testLower = rep(TRUE, 3),
    testHarm = rep(FALSE, 3)
  )

  expect_equal(result$lower$prob, expected$lower$prob, tolerance = 1e-12)
  expect_equal(result$upper$prob, expected$upper$prob, tolerance = 1e-12)
  expect_equal(result$en, expected$en, tolerance = 1e-12)
  expect_equal(result$futility$prob, expected$upper$prob, tolerance = 1e-12)
  expect_equal(result$harm$prob, expected$upper$prob * 0, tolerance = 1e-12)
})

test_that("toBinomialExact converts test.type 6 lower spending under H0", {
  design <- surv_design(test.type = 6, astar = 0.2)
  design_integer <- toInteger(design)
  result <- toBinomialExact(design)
  spending_time <- pmin(result$n.I / design_integer$maxn.IPlan, 1)
  target <- design$lower$sf(
    alpha = design$astar,
    t = spending_time,
    param = design$lower$param
  )$spend
  realized <- cumsum(result$upper$prob[, 1])

  expect_equal(result$test.type, 6)
  expect_equal(result$astar, design$astar)
  expect_equal(result$testLower, rep(TRUE, design$k))
  expect_true(all(diff(result$lower$bound) >= 0))
  expect_true(all(diff(result$upper$bound) >= 0))
  expect_true(all(result$lower$bound < result$upper$bound))
  expect_true(all(realized <= target + 1e-10))
})

test_that("default test.type 6 has exhaustive final exact decision regions", {
  design <- surv_design(test.type = 6)
  result <- toBinomialExact(design)

  expect_equal(result$astar, 1 - result$alpha)
  expect_equal(result$upper$bound[design$k], result$lower$bound[design$k] + 1L)
  expect_equal(
    sum(result$lower$prob[, 1]) + sum(result$upper$prob[, 1]),
    1,
    tolerance = 1e-10
  )
})

test_that("test.type 6 honors selective lower looks", {
  design <- surv_design(
    test.type = 6,
    astar = 0.2,
    testLower = c(TRUE, FALSE, TRUE)
  )
  result <- toBinomialExact(design)

  expect_identical(result$testLower, c(TRUE, FALSE, TRUE))
  expect_equal(unname(result$upper$prob[2, ]), c(0, 0), tolerance = 1e-12)
})

test_that("test.type 6 supports alpha and spending-time overrides", {
  design_default <- surv_design(test.type = 6)
  observed <- c(20L, 55L, 75L)
  updated <- toBinomialExact(
    design_default,
    observedEvents = observed,
    alpha = 0.01,
    usTime = c(0.25, 0.65, 0.95),
    lsTime = c(0.2, 0.55, 0.9),
    maxSpend = TRUE
  )

  expect_equal(updated$n.I, observed)
  expect_equal(updated$alpha, 0.01)
  expect_equal(updated$astar, 0.99)
  expect_equal(updated$upper$bound[3], updated$lower$bound[3] + 1L)

  design_custom <- surv_design(test.type = 6, astar = 0.97)
  expect_error(
    toBinomialExact(design_custom, alpha = 0.05),
    "alpha override requires astar <= 1 - alpha"
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

test_that("toBinomialExact supports alpha override", {
  design <- surv_design()
  observed <- c(20, 55, 80)

  result_default <- toBinomialExact(design)
  result_alpha <- toBinomialExact(design, alpha = 0.01)
  result_observed_default <- toBinomialExact(design, observedEvents = observed)
  result_observed_alpha <- toBinomialExact(design, observedEvents = observed, alpha = 0.01)

  expect_equal(result_alpha$n.I, result_default$n.I)
  expect_equal(result_observed_alpha$n.I, observed)
  expect_lt(sum(result_alpha$lower$prob[, 1]), sum(result_default$lower$prob[, 1]))
  expect_lt(
    sum(result_observed_alpha$lower$prob[, 1]),
    sum(result_observed_default$lower$prob[, 1])
  )
  expect_lte(sum(result_alpha$lower$prob[, 1]), 0.01)
  expect_lte(sum(result_observed_alpha$lower$prob[, 1]), 0.01)
})

test_that("toBinomialExact works for one-sided designs with observedEvents", {
  design_one_sided <- surv_design(test.type = 1)
  observed <- c(20, 55, 80)

  result <- toBinomialExact(design_one_sided, observedEvents = observed)

  expect_equal(result$n.I, observed)
  expect_true(all(result$upper$bound == observed + 1))
  expect_true(all(result$lower$bound < result$upper$bound))
  expect_error(
    toBinomialExact(design_one_sided, observedEvents = observed, lsTime = c(0.2, 0.6, 1)),
    "lsTime can only be specified for test.type = 4, 6, or 8"
  )
})

test_that("toBinomialExact can force full spending at final under-run look", {
  design <- surv_design(test.type = 1)
  planned <- toInteger(design)$n.I
  observed <- c(planned[1], planned[2], planned[3] - 3L)

  result_default <- toBinomialExact(design, observedEvents = observed, maxSpend = FALSE)
  result_full <- toBinomialExact(design, observedEvents = observed, maxSpend = TRUE)

  expect_equal(result_default$n.I, observed)
  expect_equal(result_full$n.I, observed)
  expect_gte(result_full$lower$bound[3], result_default$lower$bound[3])
  expect_gte(
    sum(result_full$lower$prob[, 1]),
    sum(result_default$lower$prob[, 1])
  )
})

test_that("toBinomialExact supports explicit usTime and lsTime overrides", {
  design <- surv_design(test.type = 4)
  observed <- c(20, 55, 75)
  us_time <- c(0.25, 0.65, 0.95)
  ls_time <- c(0.2, 0.55, 0.9)

  result_custom <- toBinomialExact(
    design,
    observedEvents = observed,
    usTime = us_time,
    lsTime = ls_time
  )
  result_custom_full <- toBinomialExact(
    design,
    observedEvents = observed,
    usTime = us_time,
    lsTime = ls_time,
    maxSpend = TRUE
  )

  expect_equal(result_custom$n.I, observed)
  expect_equal(result_custom_full$n.I, observed)
  expect_gte(result_custom_full$lower$bound[3], result_custom$lower$bound[3])
})

test_that("toBinomialExact honors selective futility looks from gsSurv", {
  design_all <- surv_design(test.type = 4, testLower = TRUE)
  design_sel <- surv_design(test.type = 4, testLower = c(TRUE, FALSE, FALSE))
  observed <- toInteger(design_sel)$n.I

  result_all <- toBinomialExact(design_all, observedEvents = observed)
  result_sel <- toBinomialExact(design_sel, observedEvents = observed)

  expect_true(result_sel$upper$bound[1] <= observed[1])
  expect_gte(result_sel$upper$bound[2], result_all$upper$bound[2])
  expect_gte(result_sel$upper$bound[3], result_all$upper$bound[3])
})

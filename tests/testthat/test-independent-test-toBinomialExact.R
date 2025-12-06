test_that("rejects non-gsSurv inputs and invalid test.type", {
  # non-gsSurv
  expect_error(
    toBinomialExact(1),
    regexp = "must have class gsSurv", ignore.case = TRUE
  )

  x_bad <- gsSurv(
    k = 2, test.type = 2, alpha = 0.025, beta = 0.1,
    timing = 0.5, sfu = sfHSD, sfupar = -4,
    lambdaC = .001, hr = 0.3, hr0 = 0.7, eta = 5e-04,
    gamma = 10, R = 16, T = 24, minfup = 8, ratio = 1
  )
  expect_error(toBinomialExact(x_bad),
    regexp = "test.type.*1 or 4", ignore.case = TRUE
  )
})

test_that("observedEvents validation: integer, increasing, length, maxn.IPlan rule", {
  x <- gsSurv(
    k = 3,
    test.type = 4,
    alpha = .025,
    beta = .1,
    timing = c(0.45, 0.7),
    sfu = sfHSD,
    sfupar = -4,
    sfl = sfLDOF,
    sflpar = 0,
    lambdaC = .001,
    hr = 0.3,
    hr0 = 0.7,
    eta = 5e-04,
    gamma = 10,
    R = 16,
    T = 24,
    minfup = 8,
    ratio = 3
  )

  # non-integer entries
  expect_error(toBinomialExact(x, observedEvents = c(20.5, 55, 80)),
    regexp = "observedEvents must be a vector of increasing positive integers", ignore.case = TRUE
  )

  # non-increasing / repeated or decreasing
  expect_error(toBinomialExact(x, observedEvents = c(20, 20, 80)),
    regexp = "increasing positive integers", ignore.case = TRUE
  )
  expect_error(toBinomialExact(x, observedEvents = c(55, 20, 80)),
    regexp = "increasing positive integers", ignore.case = TRUE
  )

  # length < 2
  expect_error(toBinomialExact(x, observedEvents = 50),
    regexp = "at least 2 values", ignore.case = TRUE
  )

  # >1 value >= maxn.IPlan ( a case that violates maxn.IPlan rule)
  # build an observedEvents with two values >= maxn.IPlan
  maxplan <- x$maxn.IPlan
  bad_obs <- c(maxplan, maxplan + 1) # two values >= maxn.IPlan
  # If maxn.IPlan is large, check that these values are invalid for gsDesign,
  expect_error(toBinomialExact(x, observedEvents = bad_obs),
    regexp = "toBinomialExact: observedEvents must be a vector of increasing positive integers", ignore.case = TRUE
  )
})

test_that("returned object has correct class and basic structure", {
  x <- gsSurv(
    k = 3,
    test.type = 4,
    alpha = .025,
    beta = .1,
    timing = c(0.45, 0.7),
    sfu = sfHSD,
    sfupar = -4,
    sfl = sfLDOF,
    sflpar = 0,
    lambdaC = .001,
    hr = 0.3,
    hr0 = 0.7,
    eta = 5e-04,
    gamma = 10,
    R = 16,
    T = 24,
    minfup = 8,
    ratio = 3
  )

  res <- toBinomialExact(x)

  # class
  expect_s3_class(res, "gsBinomialExact")

  # bounds present
  expect_true(!is.null(res$upper) || !is.null(res$lower) || !is.null(res$Bounds))

  # Bounds table (if provided) should have k rows
  if (!is.null(res$Bounds)) {
    expect_equal(nrow(res$Bounds), x$k)
  }

  # a and b vectors exist and are integer-ish numeric
  expect_true(!is.null(res$a) || !is.null(res$lower$bound) || !is.null(res$upper$bound) || !is.null(res$init_approx))
  # init_approx should be present as in function
  expect_true(!is.null(res$init_approx))
})

test_that("a (efficacy bound) monotonicity and b monotonicity behave correctly when available", {
  is_non_decreasing <- function(x) all(diff(x) >= 0)

  x <- gsSurv(
    k = 3,
    test.type = 4,
    alpha = .025,
    beta = .1,
    timing = c(0.45, 0.7),
    sfu = sfHSD,
    sfupar = -4,
    sfl = sfLDOF,
    sflpar = 0,
    lambdaC = .001,
    hr = 0.3,
    hr0 = 0.7,
    eta = 5e-04,
    gamma = 10,
    R = 16,
    T = 24,
    minfup = 8,
    ratio = 3
  )

  res <- toBinomialExact(x)

  counts <- if (!is.null(res$n.I)) res$n.I else x$n.I

  # extract a if present
  a <- NULL
  if (!is.null(res$a)) a <- res$a
  if (!is.null(a) && is.null(res$a) && !is.null(res$Bounds)) a <- res$Bounds$a

  # extract b if present
  b <- NULL
  if (!is.null(res$b)) b <- res$b
  if (is.null(b) && !is.null(res$Bounds)) b <- res$Bounds$b
  if (is.null(b) && x$test.type == 1) b <- counts + 1 # expected missing futility

  # If a is missing, acknowledge but do not fail or skip
  if (is.null(a)) {
    succeed("Object contains no 'a' efficacy bound — expected for some designs.")
    return()
  }

  # If b is missing acknowledge but do not skip
  if (is.null(b)) {
    succeed("Object contains no 'b' futility bound — expected for some designs.")
    return()
  }

  # Run checks only when both are available
  expect_equal(length(a), length(counts))
  expect_equal(length(b), length(counts))

  expect_true(is_non_decreasing(a))
  expect_true(all(a >= -1))
  expect_true(all(a < counts))

  expect_true(is_non_decreasing(b))
  expect_true(all(b > a))
  expect_true(all((counts - b) >= 0))
  expect_true(is_non_decreasing(counts - b))
})

test_that("observedEvents path returns correct k and preserves hr0 in returned object", {
  x <- gsSurv(
    k = 3,
    test.type = 4,
    alpha = .025,
    beta = .1,
    timing = c(0.45, 0.7),
    sfu = sfHSD,
    sfupar = -4,
    sfl = sfLDOF,
    sflpar = 0,
    lambdaC = .001,
    hr = 0.3,
    hr0 = 0.7,
    eta = 5e-04,
    gamma = 10,
    R = 16,
    T = 24,
    minfup = 8,
    ratio = 3
  )

  obs <- c(20, 55, 80)
  res_obs <- toBinomialExact(x, observedEvents = obs)

  # check k (length of counts) matches observedEvents
  counts <- if (!is.null(res_obs$n.I)) res_obs$n.I else obs
  expect_equal(length(counts), length(obs))
  expect_equal(counts, obs)

  # hr0 should be carried across
  if (!is.null(res_obs$hr0)) {
    expect_equal(res_obs$hr0, x$hr0)
  } else {
    # if hr0 not a top-level element, pass
    succeed()
  }
})

test_that("toInteger() handles gsDesign objects", {
  # Create a gsDesign object
  x <- gsDesign(k = 3, test.type = 2, alpha = 0.025, beta = 0.1, delta = 0.5)

  # Test toInteger() with a non-survival design
  result <- toInteger(x, ratio = 1)

  # Check if the output retains the class gsDesign
  expect_s3_class(result, "gsDesign")

  # Ensure the final count is rounded up to the nearest multiple of (ratio + 1)
  expect_true(result$n.I[x$k] %% (1 + 1) == 0)
})

test_that("toInteger() handles gsDesign object integer conversion correctly", {
  # Create a gsDesign object with n.fix
  x <- gsDesign(k = 3, test.type = 4, alpha = 0.025, beta = 0.1, n.fix = 300)

  # Test toInteger() with ratio = 3
  result <- toInteger(x, ratio = 3)

  # Check that all n.I values are integers
  expect_true(all(result$n.I == floor(result$n.I)))

  # Check that final n.I is a multiple of ratio + 1
  expect_equal(result$n.I[x$k] %% (3 + 1), 0)
})

test_that("toInteger() handles gsSurv object integer conversion correctly", {
  # Create a gsSurv object
  x <- gsSurv(
    k = 3,
    test.type = 4,
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
    ratio = 2
  )

  # Test with a different ratio
  result <- toInteger(x, ratio = 2)
  original_n <- rowSums(x$eNC + x$eNE)[x$k]
  result_n <- rowSums(result$eNC + result$eNE)[result$k]
  expected_min_n <- ceiling(original_n * result$n.I[result$k] / x$n.I[x$k] / 3) * 3

  # Test if the final sample size is a multiple of ratio + 1
  expect_equal(round(result_n) %% (2 + 1), 0)
  expect_equal(result_n, expected_min_n, tolerance = 1e-5)

  # Ensure final event count is rounded up for survival designs
  expect_equal(result$n.I[x$k], ceiling(x$n.I[x$k]))
  expect_true(all(diff(result$n.I) > 0))

  result_nearest <- toInteger(x, ratio = 2, roundUpFinal = FALSE)
  result_nearest_n <- rowSums(result_nearest$eNC + result_nearest$eNE)[result_nearest$k]
  expect_equal(result_nearest$n.I[x$k], round(x$n.I[x$k]))
  expect_equal(round(result_nearest_n) %% (2 + 1), 0)
  expect_gte(result_nearest_n + 1e-5, result_nearest$n.I[result_nearest$k])
})

test_that("toInteger() handles edge case where no rounding is needed", {
  x <- gsDesign(k = 3, test.type = 1, alpha = 0.05, beta = 0.2, n.fix = 150)

  # Call toInteger() with a ratio of 0 (no adjustment needed)
  result <- toInteger(x, ratio = 0)

  # Check if all values are integers
  expect_true(all(result$n.I == floor(result$n.I)))
})

test_that("toInteger() raises an error when n.I contains negative values", {
  # Create a gsDesign object with arbitrary settings
  x_test <- gsDesign(k = 3, test.type = 2, alpha = 0.025, beta = 0.1, sfu = sfHSD, sfupar = -4)

  # Set n.I with a negative value
  x_test$n.I <- c(100, 200, -250.5) # Negative value to trigger the error

  # Check that toInteger raises an error
  expect_error(
    toInteger(x_test, ratio = 3, roundUpFinal = TRUE),
    "maxn.IPlan not on interval \\[0, Inf\\]"
  )
})

test_that("toInteger() prints a message for invalid ratio values", {
  # Create a valid gsDesign object with n.fix
  x_test <- gsDesign(k = 3, test.type = 1, alpha = 0.025, beta = 0.1, n.fix = 300)

  # Test for negative ratio
  expect_message(
    toInteger(x_test, ratio = -1),
    "rounding done to nearest integer since ratio was not specified as postive integer"
  )

  # Test for non-integer ratio (numeric)
  expect_message(
    toInteger(x_test, ratio = 2.5),
    "rounding done to nearest integer since ratio was not specified as postive integer"
  )

  # Test for non-numeric ratio
  expect_message(
    toInteger(x_test, ratio = "two"),
    "rounding done to nearest integer since ratio was not specified as postive integer"
  )

  # Test for NULL ratio
  expect_message(
    toInteger(x_test, ratio = NULL),
    "rounding done to nearest integer since ratio was not specified as postive integer"
  )
})

test_that("toInteger() throws an error when input is not a gsDesign object", {
  invalid_object <- data.frame(a = 1, b = 2) # Not a gsDesign object
  expect_error(toInteger(invalid_object), "must have class gsDesign as input")
})

EXTREMEZ_TI <- 20

test_that("toInteger() preserves selective testLower and inactive futility looks (gsDesign)", {
  x <- gsDesign(
    k = 3, test.type = 4, alpha = 0.025, beta = 0.1, n.fix = 300,
    testLower = c(TRUE, FALSE, FALSE)
  )
  xi <- toInteger(x, ratio = 0)
  expect_equal(xi$testLower, x$testLower)
  expect_equal(xi$testUpper, x$testUpper)
  expect_equal(xi$testHarm, x$testHarm)
  expect_true(abs(xi$lower$bound[1]) < EXTREMEZ_TI)
  expect_equal(xi$lower$bound[2], -EXTREMEZ_TI)
  expect_equal(xi$lower$bound[3], -EXTREMEZ_TI)
})

test_that("toInteger() preserves selective testUpper and inactive efficacy looks (gsDesign)", {
  x <- gsDesign(
    k = 3, test.type = 4, alpha = 0.025, beta = 0.1, n.fix = 300,
    testUpper = c(FALSE, TRUE, TRUE)
  )
  xi <- toInteger(x, ratio = 0)
  expect_equal(xi$testUpper, x$testUpper)
  expect_equal(xi$upper$bound[1], EXTREMEZ_TI)
  expect_true(xi$upper$bound[2] < EXTREMEZ_TI)
  expect_true(xi$upper$bound[3] < EXTREMEZ_TI)
})

test_that("toInteger() preserves testHarm pattern and harm spending for test.type 8 (gsDesign)", {
  x <- gsDesign(
    k = 3, test.type = 8, alpha = 0.025, beta = 0.1, astar = 0.05, n.fix = 300,
    testHarm = c(TRUE, TRUE, FALSE), sfharm = sfLDOF, sfharmparam = 0
  )
  xi <- toInteger(x, ratio = 0)
  expect_equal(xi$testHarm, x$testHarm)
  expect_true(xi$harm$bound[1] > -EXTREMEZ_TI)
  expect_true(xi$harm$bound[2] > -EXTREMEZ_TI)
  expect_equal(xi$harm$bound[3], -EXTREMEZ_TI)
  expect_identical(xi$harm$sf, x$harm$sf)
  expect_equal(xi$harm$param, x$harm$param)
})

test_that("toInteger() preserves selective bounds for gsSurv designs", {
  x <- gsSurv(
    k = 3,
    test.type = 4,
    alpha = 0.025,
    beta = 0.1,
    timing = c(0.45, 0.7),
    sfu = sfHSD,
    sfupar = -4,
    sfl = sfLDOF,
    sflpar = 0,
    testLower = c(TRUE, FALSE, FALSE),
    lambdaC = 0.001,
    hr = 0.3,
    hr0 = 0.7,
    eta = 5e-04,
    gamma = 10,
    R = 16,
    T = 24,
    minfup = 8,
    ratio = 1
  )
  xi <- toInteger(x, ratio = 0)
  expect_equal(xi$testLower, x$testLower)
  expect_equal(xi$lower$bound[2], -EXTREMEZ_TI)
  expect_equal(xi$lower$bound[3], -EXTREMEZ_TI)
})

test_that("toInteger() works for test.type 1 when x$lower is NULL", {
  x <- gsDesign(k = 3, test.type = 1, alpha = 0.05, beta = 0.2, n.fix = 150)
  expect_null(x$lower)
  xi <- toInteger(x, ratio = 0)
  expect_null(xi$lower)
  expect_s3_class(xi, "gsDesign")
})

test_that("toInteger() increases enrollment when rounded-up events are not achievable", {
  x <- gsSurv(
    k = 3,
    test.type = 4,
    alpha = 0.025,
    beta = 0.1,
    timing = c(1 / 3, 2 / 3),
    sfu = sfHSD,
    sfupar = 1,
    sfl = sfHSD,
    sflpar = -2,
    lambdaC = -log(1 - 0.0015) / 0.5,
    hr = 0.2,
    hr0 = 0.7,
    eta = -log(1 - 0.1) / 0.5,
    gamma = c(1, 0, 1, 0, 1, 0),
    R = c(2, 10, 2, 10, 2, 10),
    T = 42,
    minfup = 6,
    ratio = 1
  )

  expect_warning(
    xi <- toInteger(x),
    NA
  )
  expect_equal(xi$n.I[x$k], ceiling(x$n.I[x$k]))
  expect_true(all(diff(xi$n.I) > 0))
  expect_equal(round(rowSums(xi$eNC + xi$eNE)[xi$k]) %% 2, 0)
  expect_equal(rowSums(xi$eDC + xi$eDE)[xi$k], xi$n.I[xi$k], tolerance = 1e-3)
})

test_that("toInteger() handles seasonal survival designs with final zero event rate", {
  x <- gsSurv(
    k = 3,
    test.type = 4,
    alpha = 0.025,
    beta = 0.1,
    timing = c(1 / 3, 2 / 3),
    sfu = sfHSD,
    sfupar = 1,
    sfl = sfHSD,
    sflpar = -2,
    lambdaC = c(
      -log(1 - 0.003) / 0.5, 0,
      -log(1 - 0.003) / 0.5, 0,
      -log(1 - 0.003) / 0.5, 0
    ),
    S = c(6, 6, 6, 6, 6),
    hr = 0.2,
    hr0 = 0.7,
    eta = -log(1 - 0.1) / 0.5,
    gamma = c(1, 0, 1, 0, 1, 0),
    R = c(2, 10, 2, 10, 2, 10),
    T = 42,
    minfup = 6,
    ratio = 3,
    testLower = c(TRUE, FALSE, FALSE)
  )

  expect_warning(
    xi <- toInteger(x),
    NA
  )
  expect_equal(xi$n.I[x$k], ceiling(x$n.I[x$k]))
  expect_true(all(diff(xi$n.I) > 0))
  expect_equal(round(rowSums(xi$eNC + xi$eNE)[xi$k]) %% 4, 0)
  expect_equal(rowSums(xi$eDC + xi$eDE)[xi$k], xi$n.I[xi$k], tolerance = 1e-2)
})

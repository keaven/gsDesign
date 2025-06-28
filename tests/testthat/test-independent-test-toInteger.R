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

  # Test if the final sample size is a multiple of ratio + 1
  expect_true(result$n.I[x$k] %% (2 + 1) == 0)

  # Ensure final count is rounded up correctly when roundUpFinal is TRUE
  expect_equal(result$n.I[x$k], ceiling(x$n.I[x$k]))
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
    "toInteger: rounding done to nearest integer since ratio was not specified as positive integer"
  )

  # Test for non-integer ratio (numeric)
  expect_message(
    toInteger(x_test, ratio = 2.5),
    "toInteger: rounding done to nearest integer since ratio was not specified as positive integer"
  )

  # Test for non-numeric ratio
  expect_message(
    toInteger(x_test, ratio = "two"),
    "toInteger: rounding done to nearest integer since ratio was not specified as positive integer"
  )

  # Test for NULL ratio
  expect_message(
    toInteger(x_test, ratio = NULL),
    "toInteger: rounding done to nearest integer since ratio was not specified as positive integer"
  )
})

test_that("toInteger() throws an error when input is not a gsDesign object", {
  invalid_object <- data.frame(a = 1, b = 2) # Not a gsDesign object
  expect_error(toInteger(invalid_object), "must have class gsDesign as input")
})

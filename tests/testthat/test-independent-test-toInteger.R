test_that("toInteger() handles valid gsDesign inputs correctly", {
  # a gsSurv object
  x <- gsSurv(
    k = 3,                 # 3 analyses
    test.type = 4,         # Non-binding futility bound 1 (no futility bound) and 4 are allowable
    alpha = .025,          # 1-sided Type I error
    beta = .1,             # Type II error (1 - power)
    timing = c(0.45, 0.7), # Proportion of final planned events at interims
    sfu = sfHSD,           # Efficacy spending function
    sfupar = -4,           # Parameter for efficacy spending function
    sfl = sfLDOF,          # Futility spending function; not needed for test.type = 1
    sflpar = 0,            # Parameter for futility spending function
    lambdaC = .001,        # Exponential failure rate
    hr = 0.3,              # Assumed proportional hazard ratio (1 - vaccine efficacy = 1 - VE)
    hr0 = 0.7,             # Null hypothesis VE
    eta = 5e-04,           # Exponential dropout rate
    gamma = 10,            # Piecewise exponential enrollment rates
    R = 16,                # Time period durations for enrollment rates in gamma
    T = 24,                # Planned trial duration
    minfup = 8,            # Planned minimum follow-up
    ratio = 3              # Randomization ratio (experimental:control)
  )
  
  # Test toInteger function with the generated gsSurv object
  result <- toInteger(x, ratio = 3)
  
  # Check that the output is of class gsSurv and gsDesign
  expect_s3_class(result, c("gsSurv", "gsDesign"))
  
  # Test that the sample sizes are rounded integers
  expect_true(all(result$n.I == round(result$n.I)))
  
  # Ensure final count is rounded up correctly when roundUpFinal is TRUE
  expect_equal(result$n.I[x$k], ceiling(x$n.I[x$k]))

})


test_that("toInteger() handles different ratio values correctly", {
  # Create a gsSurv object
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
    ratio = 2
  )
  
  # Test with a different ratio
  result <- toInteger(x, ratio = 2)
  
  # Test if the final sample size is a multiple of ratio + 1
  expect_true(result$n.I[x$k] %% (2 + 1) == 0)
  
  # Ensure final count is rounded up correctly when roundUpFinal is TRUE
  expect_equal(result$n.I[x$k], ceiling(x$n.I[x$k]))
})

test_that("toInteger() handles non-survival gsDesign objects", {
  # Create a non-survival gsDesign object
  x <- gsDesign(
    k = 3,
    test.type = 2,
    alpha = 0.025,
    beta = 0.1,
    delta = 0.5
  )
  
  # Test the toInteger function with the non-survival design
  result <- toInteger(x, ratio = 1)
  
  # Check if the output retains the class gsDesign
  expect_s3_class(result, "gsDesign")
  
  # Ensure the final count is rounded up to the nearest multiple of (ratio + 1)
  expect_true(result$n.I[x$k] %% (1 + 1) == 0)
  
})


test_that("toInteger() raises an error when n.I contains negative values", {
  # Create a gsDesign object with arbitrary settings
  x_test <- gsDesign(
    k = 3,                 # 3 analyses
    test.type = 2,         # Binding futility bound
    alpha = .025,          # 1-sided Type I error
    beta = .1,             # Type II error
    sfu = sfHSD,           # Efficacy spending function
    sfupar = -4            # Parameter for efficacy spending function
  )
  
  # Set n.I with a negative value
  x_test$n.I <- c(100, 200, -250.5)  # Negative value to trigger the error
  
  # Check that toInteger raises an error
  expect_error(
    toInteger(x_test, ratio = 3, roundUpFinal = TRUE),
    regexp = "maxn.IPlan not on interval \\[0, Inf\\]",
    info = "toInteger should raise an error when n.I contains negative values"
  )
})


test_that("toInteger() raises an error for invalid ratio values", {
  
  # Create a gsDesign object with arbitrary settings
  x_test <- gsDesign(
    k = 3,                 # 3 analyses
    test.type = 1,         # Non-binding futility bound
    alpha = .025,          # 1-sided Type I error
    beta = .1,             # Type II error
    sfu = sfHSD,           # Efficacy spending function
    sfupar = -4            # Parameter for efficacy spending function
  )
  
  # Test for negative ratio
  expect_error(
    toInteger(x_test, ratio = -1, roundUpFinal = TRUE),
    regexp = "input ratio must be a non-negative integer",
    info = "toInteger should raise an error for negative ratio"
  )
  
  # Test for non-integer ratio (numeric)
  expect_error(
    toInteger(x_test, ratio = 2.5, roundUpFinal = TRUE),
    regexp = "input ratio must be a non-negative integer",
    info = "toInteger should raise an error for non-integer ratio"
  )
  
  # Test for non-integer ratio (character)
  expect_error(
    toInteger(x_test, ratio = "two", roundUpFinal = TRUE),
    regexp = "input ratio must be a non-negative integer",
    info = "toInteger should raise an error for character ratio"
  )
  
  # Test for NULL ratio
  expect_error(
    toInteger(x_test, ratio = NULL, roundUpFinal = TRUE),
    regexp = "input ratio must be a non-negative integer",
    info = "toInteger should raise an error for NULL ratio"
  )
})

test_that("toInteger throws an error when input is not a gsDesign object", {
  invalid_object <- data.frame(a = 1, b = 2)  # Not a gsDesign object
  
  # Expect an error when passing an invalid input
  expect_error(toInteger(invalid_object), "must have class gsDesign as input")
})

test_that("toInteger handles edge case where no rounding is needed", {
  x <- gsDesign(k = 3, test.type = 1, alpha = 0.05, beta = 0.2, 
                timing = c(0.33, 0.67, 1), n.I = c(50, 100, 150))
  
  # Call the function with a ratio of 0 (no adjustment to sample size)
  result <- toInteger(x, ratio = 0)
  
  # Check if the sample sizes remain unchanged
  expect_equal(result$n.I, x$n.I)
})
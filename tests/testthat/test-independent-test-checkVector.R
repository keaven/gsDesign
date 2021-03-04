# Test checkVector function
#----------------------------------------------

testthat::test_that("Test checkVector for invalid value for length", code = {
  x <- c(1, 5, 2, 3)
  testthat::expect_error(checkVector(x, length = "e"),
    info = "Test checkVector for invalid value for length"
  )
})


testthat::test_that("Test checkVector length not matching vector length", code = {
  x <- c(1, 5, 2, 3)
  testthat::expect_error(checkVector(x, length = 2),
    info = "Test checkVector length not matching vector length"
  )
})


testthat::test_that("Test checkVector with correct value of the length parameter ", code = {
  x <- c(1, 5, 2, 3)
  testthat::expect_invisible(checkVector(x, length = 4))
})
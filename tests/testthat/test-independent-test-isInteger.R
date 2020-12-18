# Test isInteger function
#----------------------------------------------

### Test isInteger
testthat::test_that("Test: isInteger with invalid input", code = {
  M <- "a"
  testthat::expect_false(isInteger(M),
    info = "Test isInteger with invalid input"
  )
})

testthat::test_that("Test: isInteger for floating values", code = {
  M <- 55.9
  testthat::expect_false(isInteger(M),
    info = "Test isInteger for floating values"
  )
})

testthat::test_that("Test: isInteger for floating value with decimal value 0", code = {
  M <- 55.00
  testthat::expect_true(isInteger(M),
    info = "Test isInteger for floating value with decimal value 0"
  )
})
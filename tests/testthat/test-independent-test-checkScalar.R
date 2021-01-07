# Test checkScalar function
#----------------------------------------------

testthat::test_that("Test checkScalar for invalid value for isType", code = {
  x <- 5
  testthat::expect_error(checkScalar(x, isType = 12),
    info = "Test checkScalar for invalid range"
  )
})


testthat::test_that("Test checkScalar with valid value", code = {
  x <- 5
  testthat::expect_invisible(checkScalar(x, isType = "numeric"))
})
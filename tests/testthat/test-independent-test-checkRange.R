# Test checkRange function
#----------------------------------------------

testthat::test_that("Test checkRange for invaild value for variable interval", code = {
  M <- c(3, 6, 2)
  testthat::expect_error(checkRange(M, 1:10),
    info = "Test checkRange for invaild value for variable interval"
  )
})


testthat::test_that("Test checkRange valid value", code = {
  testthat::expect_invisible(checkRange(1:5, interval = c(1, 5), inclusion = c(TRUE, TRUE)))
})

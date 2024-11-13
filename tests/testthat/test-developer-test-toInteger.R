# Test toInteger function
#----------------------------------------------

### Test toInteger
testthat::test_that("Test: toInteger with invalid input", code = {
  M <- "a"
  testthat::expect_error(toInteger(x = M),
    info = "Test toInteger with invalid input"
  )
})

x <- gsDesign(n.fix = 100)
testthat::test_that("Test: toInteger for fractional and negative values", code = {
  M <- 55.9
  testthat::expect_message(toInteger(x, ratio = M),
    info = "Test toInteger for floating values"
  )
  M <- -1
  testthat::expect_message(toInteger(x, ratio = M),
                         info = "Test toInteger for negative value of ratio"
  )
  # Note that x$ratio = NULL
  testthat::expect_message(toInteger(x),
                         info = "Test toInteger for NULL value of ratio"
  )
})

testthat::test_that("Test: toInteger for even sample size", code = {
  testthat::expect_true(max(toInteger(x, ratio = 1)$n.I) %% 2 == 0,
    info = "Test toInteger for floating value with decimal value 0"
  )
})

testthat::test_that("Test: toInteger for multiple of 5", code = {
  testthat::expect_true(max(toInteger(x, ratio = 4)$n.I) %% 5 == 0,
                        info = "Test toInteger for floating value with decimal value 0"
  )
})

# Now test survival endpoint
x <- gsSurvCalendar(hr = .64) # This gives 252.1852 as sample size, 227.1393 as final event count
# Should round event counts (up for final) and 
# round up final event count final sample size only as well
y <- toInteger(x) 
testthat::test_that("Test: toInteger for survival endpoint event count works properly", code = {
  # Interim event counts rounded
  testthat::expect_equal(min(round(x$n.I[1:x$k - 1]) - y$n.I[1:x$k - 1]), 0)
  # Final event count round up
  testthat::expect_true((y$n.I - x$n.I)[x$k] >= 0,
                        info = "Test toInteger of gsSurv rounds up final event count"
  )
  # Final sample size rounds to even
  testthat::expect_true((y$eNC + y$eNE)[x$k] %% 2 == 0)
  # Final event count rounds up
  testthat::expect_gte((y$eNC + y$eNE - x$eNC - x$eNE)[x$k], 0)
})

#----------------------------------
### Testing  print.eEvents function
#----------------------------------

testthat::test_that("Test: checking function for incorrect input", {
  x <- 5
  testthat::expect_error(print.eEvents(x), info = "Checking for incorrect input")
})


testthat::test_that("Test: checking for control group ", {
  lamC <- c(1, .8, .5)
  x <- eEvents(
    lambda = matrix(c(lamC, lamC * 2 / 3), ncol = 6), eta = 0,
    gamma = matrix(.5, ncol = 6), R = 2, T = 4
  )
  local_edition(3) # use 3rd edition of testthat for this testcase
  expect_snapshot_output(x = print.eEvents(x))
})
#----------------------------------
### Testing  print.nSurv function
#----------------------------------

testthat::test_that("Test: checking for incorrect input", {
  x <- 5
  testthat::expect_error(print.nSurv(x), info = "Checking for incorrect input")
})


testthat::test_that("Test: checking for Censoring Rates", {
  x <- nSurv(
    lambdaC = log(2) / 6, hr = 0.6, hr0 = 1, eta = 0, etaE = 0,
    gamma = 1, R = 12, S = NULL, T = NULL, minfup = 0.2,
    ratio = 1, alpha = 0.025, beta = 0.1, sided = 1,
    tol = .Machine$double.eps^0.25
  )
  local_edition(3) # use 3rd edition of testthat for this test case
  expect_snapshot_output(x = print.nSurv(x))
})

testthat::test_that("Test: checking for Control Censoring Rates", {
  x <- nSurv(
    lambdaC = log(2) / 6, hr = 0.6, hr0 = 1, eta = 0, etaE = 0.2, gamma = 1,
    R = 12, S = NULL,
    T = NULL, minfup = 0.2, ratio = 1, alpha = 0.025,
    beta = 0.1, sided = 1, tol = .Machine$double.eps^0.25
  )
  local_edition(3) # use 3rd edition of testthat for this test case
  expect_snapshot_output(x = print.nSurv(x))
})


testthat::test_that("Test: checking for ratio != 1", {
  x <- nSurv(
    lambdaC = log(2) / 6, hr = 0.6, hr0 = 1, eta = 0,
    etaE = 0.2, gamma = 1, R = 12, S = NULL, T = NULL,
    minfup = 0.2, ratio = 0.8, alpha = 0.025, beta = 0.1,
    sided = 1, tol = .Machine$double.eps^0.25
  )
  local_edition(3) # use 3rd edition of testthat for this test case
  expect_snapshot_output(x = print.nSurv(x))
})
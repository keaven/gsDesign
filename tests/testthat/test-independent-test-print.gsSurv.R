#----------------------------------
### Testing  print.gsSurv function
#----------------------------------

testthat::test_that("Test: checking hazard ratio hr0 = 1", {
  x <- gsSurv(
    k = 3, test.type = 4, alpha = 0.025, sided = 1, beta = 0.1,
    astar = 0, timing = 1, sfu = gsDesign::sfHSD, sfupar = -4, sfl = gsDesign::sfHSD,
    sflpar = -2, r = 18, lambdaC = log(2) / 6, hr = 0.5, hr0 = 1,
    eta = 0, etaE = NULL, gamma = 1, R = 18, S = NULL, T = NULL,
    minfup = 0.5, ratio = 1, tol = .Machine$double.eps^0.25,
    usTime = NULL, lsTime = NULL
  )
  local_edition(3) # use 3rd edition of testthat for this testcase
  expect_snapshot_output(x = print.gsSurv(x))
})


testthat::test_that("Test: checking hazard ratio hr0 != 1", {
  x <- gsSurv(
    k = 3, test.type = 4, alpha = 0.025, sided = 1, beta = 0.1,
    astar = 0, timing = 1, sfu = gsDesign::sfHSD, sfupar = -4, sfl = gsDesign::sfHSD,
    sflpar = -2, r = 18, lambdaC = log(2) / 6, hr = 0.5, hr0 = 1.5,
    eta = 0, etaE = NULL, gamma = 1, R = 18, S = NULL, T = NULL,
    minfup = 0.5, ratio = 1, tol = .Machine$double.eps^0.25,
    usTime = NULL, lsTime = NULL
  )
  local_edition(3) # use 3rd edition of testthat for this testcase
  expect_snapshot_output(x = print.gsSurv(x))
})


testthat::test_that("Test: checking test.type > 1", {
  x <- gsSurv(
    k = 4, sfl = gsDesign::sfPower, sflpar = .5, lambdaC = log(2) / 6, hr = .5,
    eta = log(2) / 40, gamma = 1, T = 36, minfup = 12, test.type = 3
  )
  local_edition(3) # use 3rd edition of testthat for this testcase
  expect_snapshot_output(x = print.gsSurv(x))
})


testthat::test_that("Test: checking test.type = 1", {
  x <- gsSurv(
    k = 4, sfl = gsDesign::sfPower, sflpar = .5, lambdaC = log(2) / 6, hr = .5,
    eta = log(2) / 40, gamma = 1, T = 36, minfup = 12, test.type = 1
  )
  local_edition(3) # use 3rd edition of testthat for this testcase
  expect_snapshot_output(x = print.gsSurv(x))
})

testthat::test_that("Test: checking ratio = 0.6", {
  x <- gsSurv(
    k = 4, sfl = gsDesign::sfPower, sflpar = .5, lambdaC = log(2) / 6, hr = .5,
    eta = log(2) / 40, gamma = 1, T = 36, minfup = 12, test.type = 3, ratio = 0.6
  )
  local_edition(3) # use 3rd edition of testthat for this testcase
  expect_snapshot_output(x = print.gsSurv(x))
})
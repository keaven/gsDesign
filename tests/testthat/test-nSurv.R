testthat::context("Survival endpoint sample size")

testthat::test_that("Testing nSurv vs nSurvival and nEvents", {
  # consider a trial with 2 year maximum follow-up,
  # 6 month uniform enrollment
  # Treatment/placebo hazards = 0.14/0.2 per 1 person-year
  # HR = 0.7
  # drop out hazard 0.1 per 1 person-year
  # alpha = 0.025 (1-sided)
  # power = 0.9 (default beta=.1)
  ss <- nSurvival(
    lambda1 = .2, lambda2 = .14, eta = .1, Ts = 2, Tr = .5,
    sided = 1, alpha = .025
  )
  ns <- nSurv(lambdaC = .2, hr = .7, eta = .1, T=2, minfup=1.5)
  nsg <- nSurv(lambdaC = .2, hr = .7, eta = .1, R = 0.5, T = NULL, minfup = NULL, gamma = ns$gamma)
  ne <- nEvents(hr=.7)
  testthat::expect_equal(ss$n, ns$n, info = "Checking sample size")
  testthat::expect_equal(round(ns$n,3), round(nsg$n,3), info = "Checking sample size")
  testthat::expect_equal(ss$nEvents, ns$d, info = "Checking event count")
  testthat::expect_lt(abs(ns$d - ne),3)
})

testthat::test_that("Checking consistency of Schoenfeld approximations", {
  z <- hrn2z(hr = .7, n = 100, ratio = 1.5)
  hr <- zn2hr(z = -z, n = 100, ratio = 1.5)
  n <- hrz2n(z = -z, hr = .7, ratio = 1.5)
  testthat::expect_equal(hr, .7, info = "Checking zn2hr vs hrn2z")
  testthat::expect_equal(n, 100, info = "Checking hrz2n vs hrn2z")
})

testthat::test_that("Checking consistency nEvents power vs sample size", {
  ss <- nEvents(hr = .7, tbl = TRUE)
  ne <- nEvents(hr = .7)
  pwr <- nEvents(hr = .7, n = ne, tbl = TRUE)
  testthat::expect_equal(ss$n, ceiling(ne), info = "Checking tabular output")
  testthat::expect_equal(pwr$Power, .9, info = "Checking power calculation")
})

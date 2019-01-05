testthat::context("normal grid inputs")

testthat::test_that("test.normalGrid.bounds", {
  testthat::expect_error(gsDesign::normalGrid(bounds = "abc"), info = "Checking for incorrect variable type")
  testthat::expect_error(gsDesign::normalGrid(bounds = 0), info = "Checking for out-of-range variable value")
  testthat::expect_error(gsDesign::normalGrid(bounds = c(2)), info = "Checking for incorrect variable length")
})

testthat::test_that("test.normalGrid.mu", {
  testthat::expect_error(gsDesign::normalGrid(mu = "abc"), info = "Checking for incorrect variable type")
  testthat::expect_error(gsDesign::normalGrid(mu = rep(1, 2)), info = "Checking for incorrect variable length")
})

testthat::test_that("test.normalGrid.r", {
  testthat::expect_error(gsDesign::normalGrid(r = "abc"), info = "Checking for incorrect variable type")
  testthat::expect_error(gsDesign::normalGrid(r = 0), info = "Checking for out-of-range variable value")
  testthat::expect_error(gsDesign::normalGrid(r = 81), info = "Checking for out-of-range variable value")
  testthat::expect_error(gsDesign::normalGrid(r = rep(1, 2)), info = "Checking for incorrect variable length")
})

testthat::test_that("test.normalGrid.sigma", {
  testthat::expect_error(gsDesign::normalGrid(sigma = "abc"), info = "Checking for incorrect variable type")
  testthat::expect_error(gsDesign::normalGrid(sigma = 0), info = "Checking for out-of-range variable value")
  testthat::expect_error(gsDesign::normalGrid(sigma = rep(1, 2)), info = "Checking for incorrect variable length")
})

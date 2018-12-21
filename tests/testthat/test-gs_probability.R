testthat::context('gs probability')

testthat::test_that("test.gsProbability.a", {
  testthat::expect_error(gsDesign::gsProbability(a = "abc"), info = "Checking for incorrect variable type")
  testthat::expect_error(gsDesign::gsProbability(a = c(1, 2), k = 3), info = "Checking for incorrect variable length")
})

testthat::test_that("test.gsProbability.b", {
  testthat::expect_error(gsDesign::gsProbability(b = "abc"), info = "Checking for incorrect variable type")
  testthat::expect_error(gsDesign::gsProbability(b = c(1, 2), k = 3), info = "Checking for incorrect variable length")
})

testthat::test_that("test.gsProbability.k", {
  testthat::expect_error(gsDesign::gsProbability(k = "abc"), info = "Checking for incorrect variable type")
  testthat::expect_error(gsDesign::gsProbability(k = -1), info = "Checking for out-of-range variable value")
  testthat::expect_error(gsDesign::gsProbability(k = 1, d = gsDesign::gsDesign()), info = "Checking for out-of-range variable value")
  testthat::expect_error(gsDesign::gsProbability(k = 31), info = "Checking for out-of-range variable value")
  testthat::expect_error(gsDesign::gsProbability(k = seq(2)), info = "Checking for incorrect variable length")
})

testthat::test_that("test.gsProbability.n.I", {
  testthat::expect_error(gsDesign::gsProbability(n.I = "abc"), info = "Checking for incorrect variable type")
  testthat::expect_error(gsDesign::gsProbability(n.I = 0), info = "Checking for out-of-range variable value")
  testthat::expect_error(gsDesign::gsProbability(n.I = c(2, 1)), info = "Checking for out-of-order input sequence")
  testthat::expect_error(gsDesign::gsProbability(n.I = c(1, 2), k = 3), info = "Checking for incorrect variable length")
})

testthat::test_that("test.gsProbability.r", {
  testthat::expect_error(gsDesign::gsProbability(r = "abc"), info = "Checking for incorrect variable type")
  testthat::expect_error(gsDesign::gsProbability(r = 0), info = "Checking for out-of-range variable value")
  testthat::expect_error(gsDesign::gsProbability(r = 81), info = "Checking for out-of-range variable value")
  testthat::expect_error(gsDesign::gsProbability(r = rep(1, 2)), info = "Checking for incorrect variable length")
})

testthat::test_that("test.gsProbability.theta", {
  testthat::expect_error(gsDesign::gsProbability(theta = "abc"), info = "Checking for incorrect variable type")
})

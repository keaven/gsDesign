testthat::context("plot inputs")

testthat::test_that("test.plot.gsDesign.plottype", {
  testthat::expect_error(gsDesign::plot.gsDesign(plottype = "abc"), info = "Checking for incorrect variable type")
  testthat::expect_error(gsDesign::plot.gsDesign(plottype = 0), info = "Checking for out-of-range variable value")
  testthat::expect_error(gsDesign::plot.gsDesign(plottype = 8), info = "Checking for out-of-range variable value")
  testthat::expect_error(gsDesign::plot.gsDesign(plottype = rep(2, 2)), info = "Checking for incorrect variable length")
})

testthat::test_that("test.plot.gsProbability.plottype", {
  testthat::expect_error(gsDesign::plot.gsProbability(plottype = "abc"), info = "Checking for incorrect variable type")
  testthat::expect_error(gsDesign::plot.gsProbability(plottype = 0), info = "Checking for out-of-range variable value")
  testthat::expect_error(gsDesign::plot.gsProbability(plottype = 8), info = "Checking for out-of-range variable value")
  testthat::expect_error(gsDesign::plot.gsProbability(plottype = rep(2, 2)), info = "Checking for incorrect variable length")
})

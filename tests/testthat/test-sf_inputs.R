testthat::context('sf inputs')

testthat::test_that("test.sfTDist.param", {
  testthat::expect_error(gsDesign::sfTDist(param = rep(1, 4)), info = "Checking for incorrect variable length")
  testthat::expect_error(gsDesign::sfTDist(param = c(1, 0, 1)), info = "Checking for out-of-range variable value")
  testthat::expect_error(gsDesign::sfTDist(param = c(1, 1, 0.5)), info = "Checking for out-of-range variable value")
  testthat::expect_error(gsDesign::sfTDist(param = 1, 1:3/4, c(0.25, 0.5, 0.75, 0.1, 0.2, 0.3)),
               info = "Checking for out-of-range variable value")
})

testthat::test_that("test.sfTDist.param ", {
  testthat::expect_error(gsDesign::sfTDist(param = "abc"),
               info = "Checking for incorrect variable type")
})

testthat::test_that("test.sfpower.param", {
  testthat::expect_error(sfpower(param = "abc"), info = "Checking for incorrect variable type")
  testthat::expect_error(sfpower(param = rep(1, 2)), info = "Checking for incorrect variable length")
  testthat::expect_error(sfpower(param = -1), info = "Checking for out-of-range variable value")
})

testthat::test_that("test.sfnorm.param", {
  testthat::expect_error(sfnorm(param = rep(1, 3)), info = "Checking for incorrect variable length")
  testthat::expect_error(sfnorm(param = c(0.1, 0.6, 0.2, 0.05), k = 5, 
                      timing = c(0.1, 0.25, 0.4, 0.6)), info = "Checking for out-of-order input sequence")
})

testthat::test_that("test.sfnorm.param ", {
  testthat::expect_error(sfnorm(param = "abc"), info = "Checking for incorrect variable type")
  testthat::expect_error(sfnorm(param = c(1, 0)), info = "Checking for out-of-range variable value")
})

testthat::test_that("test.sflogistic.param", {
  testthat::expect_error(sflogistic(param = rep(1, 3)), info = "Checking for incorrect variable length")
  testthat::expect_error(sflogistic(param = c(0.1, 0.6, 0.2, 0.05), k = 5, 
                          timing = c(0.1, 0.25, 0.4, 0.6)), info = "Checking for out-of-order input sequence")
})

testthat::test_that("test.sflogistic.param ", {
  testthat::expect_error(sflogistic(param = "abc"), info = "Checking for incorrect variable type")
  testthat::expect_error(sflogistic(param = c(1, 0)), info = "Checking for out-of-range variable value")
})

testthat::test_that("test.sfHSD.param", {
  testthat::expect_error(gsDesign::sfHSD(param = "abc"), info = "Checking for incorrect variable type")
  testthat::expect_error(gsDesign::sfHSD(param = rep(1, 2)), info = "Checking for incorrect variable length")
  testthat::expect_error(gsDesign::sfHSD(param = -41), info = "Checking for out-of-range variable value")
  testthat::expect_error(gsDesign::sfHSD(param = 41), info = "Checking for out-of-range variable value")
})

testthat::test_that("test.sfexp.param", {
  testthat::expect_error(sfexp(param = "abc"), info = "Checking for incorrect variable type")
  testthat::expect_error(sfexp(param = rep(1, 2)), info = "Checking for incorrect variable length")
  testthat::expect_error(sfexp(param = 0), info = "Checking for out-of-range variable value")
  testthat::expect_error(sfexp(param = 11), info = "Checking for out-of-range variable value")
})

testthat::test_that("test.sfcauchy.param", {
  testthat::expect_error(sfcauchy(param = rep(1, 3)), info = "Checking for incorrect variable length")
  testthat::expect_error(sfcauchy(param = c(0.1, 0.6, 0.2, 0.05), k = 5, 
                        timing = c(0.1, 0.25, 0.4, 0.6)), info = "Checking for out-of-order input sequence")
})

testthat::test_that("test.sfcauchy.param ", {
  testthat::expect_error(sfcauchy(param = "abc"), info = "Checking for incorrect variable type")
  testthat::expect_error(sfcauchy(param = c(1, 0)), info = "Checking for out-of-range variable value")
})
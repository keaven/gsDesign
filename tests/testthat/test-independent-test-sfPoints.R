source('../gsDesign_independent_code.R')
#-----------------------------------
### Testing sfPoints function
#-----------------------------------

testthat::test_that("Test: alpha - - Variable Type,  Out-of-range",  {
  testthat::expect_error(gsDesign::sfPoints(alpha = "abc", t = c(.1,  .4), 
                                            param = c(0.1, 0.2)), 
                         info = "Checking for incorrect variable type")
  
  testthat::expect_error(gsDesign::sfPoints(alpha = 0, t = c(.1,  .4), 
                                            param = c(0.1, 0.2)), 
                         info = "Checking for out-of-range variable value")
  
  
  testthat::expect_error(gsDesign::sfPoints(alpha = -1, t = c(.1,  .4), 
                                            param = c(0.1, 0.2)), 
                         info = "Checking for out-of-range variable value")
  
})


testthat::test_that("Test: t - Checking Variable Type,  
                    Out-of-Range,  Order-of-List",  {
  
  testthat::expect_error(gsDesign::sfPoints(alpha = .025, t = "a", 
                                            param = c(0.1, 0.2)), 
                         info = "Checking for incorrect variable type")
  
  testthat::expect_error(gsDesign::sfPoints(alpha = .025, t = c("a", "b"), 
                                            param = c(0.1, 0.2)), 
                         info = "Checking for incorrect variable type")
  
  
  testthat::expect_error(gsDesign::sfPoints(alpha = .025, t = c(-.5, .75), 
                                            param = c(0.1, 0.2)), 
                         info = "Checking for out-of-range variable value")
  
  testthat::expect_error(gsDesign::sfPoints(alpha = .025, t = c(.5, -.75), 
                                            param = c(0.1, 0.2)), 
                         info = "Checking for out-of-range variable value")
  
  
  testthat::expect_error(gsDesign::sfPoints(alpha = .025, t = c(1, -5), 
                                            param = c(0.1, 0.2)), 
                         info = "Checking for out-of-range variable value")
  
  
  testthat::expect_error(gsDesign::sfPoints(alpha = .025, t = c(-1, 5), 
                                            param = c(0.1, 0.2)), 
                         info = "Checking for out-of-range variable value")
  
  testthat::expect_error(gsDesign::sfPoints(alpha = .025, t = c(.2, .0, .4), 
                                            param = c(.1,  .4, .5, .3)), 
                         info = "Checking for order of the list")
  
})


testthat::test_that("Test: param - Checking Variable Type,  
                    Out-of-Range,  Order-of-List",  {
  
  testthat::expect_error(gsDesign::sfPoints(alpha = .025, t = c(.1,  .4), 
                                            param = c("a", "b")),  
                         info = "Checking for incorrect variable type")
  
  testthat::expect_error(gsDesign::sfPoints(alpha = .025, t = c(.1,  .4), 
                                            param = "a"),  
                         info = "Checking for incorrect variable type")
  
  
  testthat::expect_error(gsDesign::sfPoints(alpha = .025, t = c(.1,  .4), 
                                            param = 4),  
                         info = "Checking for incorrect variable type") 
  
  
  testthat::expect_error(gsDesign::sfPoints(alpha = .025, t = c(.01,  .05,  .1,  .25,  .5), 
                                            param = c(.01,  .05,  .1,  .25,  .5,  1)), 
                         info = "Checking for out-of-range variable value")
  
  
  testthat::expect_error(gsDesign::sfPoints(alpha = .025, t = c(.01,  .05,  .1,  .25,  .5, 1), 
                                            param = c(-.01,  .05,  .1,  .5,  .75)), 
                         info = "Checking for out-of-range variable value")
  
  testthat::expect_error(gsDesign::sfPoints(alpha = .025, t = c(.01,  .05,  .1,  .25,  .5, 1), 
                                            param = c(.01,  .05,  .1,  .5,  7)), 
                         info = "Checking for out-of-range variable value")
  
  
  testthat::expect_error(gsDesign::sfPoints(alpha = .025, t = c(.01,  .05,  .1,  .25,  .5, 1), 
                                            param = c(.01,  .05,  1,  .25,  .5)),  
                         info = "Checking for incorrect variable type")
  
})


testthat::test_that("Test: output validation for equal length t and param
                     source : gsDesign_independent_code.R)",  {
  
  t <- c(.01,  .05,  .1,  .25,  .5, 1)
  param <- c(.01,  .05,  .1,  .25,  .5,  1)
  alpha <- 0.025 
  
  spend <- gsDesign::sfPoints(alpha, t, param)$spend
  expected_spend <- validate_sfPoints(alpha, t, param)
  expect_equal(spend, expected_spend)
  
})

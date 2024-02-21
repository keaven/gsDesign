#----------------------------------
### Testing sfStep function
#----------------------------------


testthat::test_that("test: alpha - Testing incorrect variable type, 
                    out-of-range variable value", {
                      
  testthat::expect_error(gsDesign::sfStep(alpha = "abc",t = c(.25, 0.5,1),
                                            param = c(0.3 ,0.5, 0.65, 0.75)),
                         info = "Checking for incorrect variable type")
  
  testthat::expect_error(gsDesign::sfStep(alpha = 0,t = c(.25, 0.5,1),
                         param = c(-0.00001, 0.01, 0.05, 0.1, 0.25, 1)),
                         info = "Checking for out-of-range variable value")
  
})

testthat::test_that("test: t - Testing incorrect variable type, 
                    out-of-range variable value", {
  
  testthat::expect_error(gsDesign::sfStep(alpha = 0.25,t = c('a', 0.5,1),
                                            param = c(0.3, 0.5, 0.65, 0.75)),
                         info = "Checking for incorrect variable type")
  
  testthat::expect_error(gsDesign::sfStep(alpha = 0.25,t = c(-.25, 0.5,1),
                                            param = c(0.01, 0.05, 0.65, 0.75)),
                         info = "Checking for out-of-range variable value")
  
})

testthat::test_that("test: param - Testing incorrect variable type, 
                    out-of-range variable value", {
                      
  testthat::expect_error(gsDesign::sfStep(alpha = 0.25,t = c(0.25, 0.5,1),
                                            param = c(0.01, 0.05, 'a', 0.25)),
                         info = "Checking for incorrect variable type")
  
  testthat::expect_error(gsDesign::sfStep(alpha = 0.25,t = c(0.25, 0.5,1),
                                            param = c(0.01, 0.05, 0.65, 0.75, 0.8)),
                         info = "Checking for param length : must have even length")
  
  testthat::expect_error(gsDesign::sfStep(alpha = 0.25,t = c(0.25, 0.5,1),
                                          param = c(0.01, 0.05, 0.1, 0.25, 1, 1.01)),
                         info = "Checking for out-of-range variable value")
  
  testthat::expect_error(gsDesign::sfStep(alpha = 0.25,t = c(0.25, 0.5,1),
                                            param = c(-0.01, 0.05, 0.1, 0.25, 0.9, 1)),
                         info = "Checking for out-of-range variable value")
  
})

testthat::test_that("Test: Output validation,
                    Source: helper.R", {
                      
  alpha <- 0.025
  t = c(0, 0.25, .3, .35, 0.5, .65, .9, 1)
  param <- c(	0.3,	0.5,	0.65,	0.5,0.75,	0.9)
                      
  spend <- gsDesign::sfStep(alpha = alpha,t = t, param = param)$spend
  expected_spend <- validate_sfStep(alpha,t,param)
  expect_equal(spend,expected_spend)
})

#-----------------------------------
# Test sfNormal function
#-----------------------------------

testthat::test_that("Test: alpha - Checking Variable Type,  
                    Out-of-Range,  Order-of-List",  {
                      
  testthat::expect_error(gsDesign::sfNormal(alpha = "abc", t = c(.1,  .4), 
                                            param = c(0.1, 0.2)), 
                         info = "Checking for incorrect variable type"
  )
  
  testthat::expect_error(gsDesign::sfNormal(alpha = -1, t = c(.1,  .4), 
                                            param = c(0.1, 0.2)), 
                         info = "Checking for out-of-range variable value"
  )
  
})


testthat::test_that("Test: t - Checking Variable Type,  
                    Out-of-Range,  Order-of-List",  {
  
 
  testthat::expect_error(gsDesign::sfNormal(alpha = .025, t = c("a", "b"), 
                                            param = c(0.1, 0.2)), 
                         info = "Checking for incorrect variable type"
  )
  
 
  
  testthat::expect_error(gsDesign::sfNormal(alpha = .025, t = c(-.5, .75), 
                                            param = c(0.1, 0.2)), 
                         info = "Checking for out-of-range variable value"
  )
  
 
  testthat::expect_error(gsDesign::sfNormal(alpha = .025, t = c(-1, -6), 
                                            param = c(0.1, 0.2)), 
                         info = "Checking for out-of-range variable value"
  )
  
 
})



testthat::test_that("Test: param:  - Checking Variable Type,  
                    Out-of-Range,  Order-of-List",  {
  
  testthat::expect_error(gsDesign::sfNormal(alpha = .025, t = c(.1,  .4), 
                                            param = c("a", "b")),  
                         info = "Checking for incorrect variable type"
  )
  
 
  testthat::expect_error(gsDesign::sfNormal(alpha = .025, t = c(.1,  .4), param = .4),  
                         info = "Checking for incorrect variable type"
  ) 
  
  testthat::expect_error(gsDesign::sfNormal(alpha = .025, t = c(.1,  .4), param = c(.4)),  
                         info = "Checking for length of the variable"
  )
  
  testthat::expect_error(gsDesign::sfNormal(alpha = .025, t = c(.1,  .4), 
                                            param = c(.2, .55, .75)),  
                         info = "Checking for length of the variable"
  )
  
  testthat::expect_error(gsDesign::sfNormal(alpha = .025, t = c(.1,  .4), 
                                            param = c(.2, .45, .55, 0.75, 0.85)),  
                         info = "Checking for length of the variable"
  )
  
  testthat::expect_error(gsDesign::sfNormal(alpha = .025, t = c(.1,  .4), 
                                            param = c(.2, .45, .55, 0.75, 0.85)),  
                         info = "Checking for length of the variable"
  )
  
  testthat::expect_error(gsDesign::sfNormal(alpha = .025, t = c(.1,  .4), 
                                            param = c(0, 0)),  
                         info = "Checking for out-of-range of the variable"
  )
  
 
  
  testthat::expect_error(gsDesign::sfNormal(alpha = .025, t = c(.1,  .4), 
                                            param = c(.1, -5)),  
                         info = "Checking for out-of-range of the variable"
  )
  
  testthat::expect_error(gsDesign::sfNormal(alpha = .025, t = c(.1,  .4), 
                                            param = c(.1, 0)),  
                         info = "Checking for out-of-range of the variable"
  )
  
  
  
  
  testthat::expect_error(gsDesign::sfNormal(alpha = .025, t = c(.1,  .4), 
                                            param = c(NULL, 0.2, 0.05, .4)),  
                         info = "Checking for out-of-range of the variable"
  )
  
  testthat::expect_error(gsDesign::sfNormal(alpha = .025, t = c(.1,  .4), 
                                            param = c(0.1, 0.01, 0.1, 0.4)),  
                         info = "Checking for out-of-range of the variable"
  )
  
  testthat::expect_error(gsDesign::sfNormal(alpha = .025, t = c(.1,  .4), 
                                            param = c(0.01, 0.1, 0.4, 0.1)),  
                         info = "Checking for out-of-range of the variable"
  )
  
  testthat::expect_error(gsDesign::sfNormal(alpha = .025, t = c(.1,  .4), 
                                            param = c(0.01, -0.1, 0.1, 0.4)),  
                         info = "Checking for out-of-range of the variable"
  )
  
 
  testthat::expect_error(gsDesign::sfNormal(alpha = .025, t = c(.1,  .4), 
                                            param = c(0.4, 0.1, 0.1, 0.4)),  
                         info = "Checking for out-of-range of the variable"
  )
  
})


testthat::test_that("Test: output validation param of length 2,  
                    Source: helper.R",  {
  
  t <- c(0.2, 0.5, .7, 1)
  param<-c(0,  1)
  alpha<-0.025
  
  sp <- gsDesign::sfNormal(alpha, t, param)$spend
  expected_sp <- validate_sfNormal(alpha, t, param)
  expect_equal(sp,expected_sp)
  
})
 
testthat::test_that("Test: output validation with param of length 4,  
                    Source: helper.R",  {
  
  t <- c(0.2, 0.5, 0.7, 1)
  param<-c(0.01, 0.1, 0.1, 0.4)
  alpha<-0.025
  
  sp <- gsDesign::sfNormal(alpha, t, param)$spend
  expected_sp <- validate_sfNormal(alpha, t, param)
  expect_equal(sp,expected_sp)
  
})
#-----------------------------------
### Testing sfExtremeValue function
#-----------------------------------

testthat::test_that("Test: alpha - Testing incorrect variable type,  
                    out-of-range variable value",  {
  testthat::expect_error(gsDesign::sfExtremeValue(alpha = "abc", t = c(.1,  .4), 
                                                  param = c(0.1, 0.2)), 
                         info = "Checking for incorrect variable type"
  )
  
  testthat::expect_error(gsDesign::sfExtremeValue(alpha = 0, t = c(.1,  .4), 
                                                  param = c(0.1, 0.2)), 
                         info = "Checking for out-of-range variable value"
  )
  
    
  testthat::expect_error(gsDesign::sfExtremeValue(alpha = -1, t = c(.1,  .4), 
                                                  param = c(0.1, 0.2)), 
                         info = "Checking for out-of-range variable value"
  )
  
})

# t is numeric vector
testthat::test_that("Test: t - Testing incorrect variable type,  out-of-range variable value, order of the list",  {
  
   
  testthat::expect_error(gsDesign::sfExtremeValue(alpha = .025, t = c("a", "b"), 
                                                  param = c(0.1, 0.2)), 
                         info = "Checking for incorrect variable type"
  )
  
  testthat::expect_error(gsDesign::sfExtremeValue(alpha = .025, t = c(-.5, .75), 
                                                  param = c(0.1, 0.2)), 
                         info = "Checking for out-of-range variable value"
  )
  
  testthat::expect_error(gsDesign::sfExtremeValue(alpha = .025, t = c(-.75, 1), 
                                                  param = c(0.1, 0.2)), 
                         info = "Checking for out-of-range variable value"
  )
  
   
  testthat::expect_error(gsDesign::sfExtremeValue(alpha = .025, t = c(-1, -6), 
                                                  param = c(0.1, 0.2)), 
                         info = "Checking for out-of-range variable value"
  )
  
 
})



# param is numeric ,  positive,  of length 2 or 4 vector. Value ranges from 0 to 1(including)
testthat::test_that("Test: param - Testing incorrect variable type,  
                    out-of-range variable value",  {
  
  testthat::expect_error(gsDesign::sfExtremeValue(alpha = .025, t = c(.1,  .4), 
                                                  param = c("a", "b")),  
                         info = "Checking for incorrect variable type"
  )
  
  
  testthat::expect_error(gsDesign::sfExtremeValue(alpha = .025, t = c(.1,  .4), 
                                                  param = 4),  
                         info = "Checking for incorrect variable type"
  )  
  
  testthat::expect_error(gsDesign::sfExtremeValue(alpha = .025, t = c(.1,  .4), 
                                                  param = .4),  
                         info = "Checking for incorrect variable type"
  ) 
  
  testthat::expect_error(gsDesign::sfExtremeValue(alpha = .025, t = c(.1,  .4), 
                                                  param = c(.4)),  
                         info = "Checking for length of the variable"
  )
  
  testthat::expect_error(gsDesign::sfExtremeValue(alpha = .025, t = c(.1,  .4), 
                                                  param = c(.2, .55, .75)),  
                         info = "Checking for length of the variable"
  )
  
  testthat::expect_error(gsDesign::sfExtremeValue(alpha = .025, t = c(.1,  .4), 
                                                  param = c(.2, .45, .55, 0.75, 0.85)),  
                         info = "Checking for length of the variable"
  )
  
  testthat::expect_error(gsDesign::sfExtremeValue(alpha = .025, t = c(.1,  .4), 
                                                  param = c(1, 0)),  
                         info = "Checking for out-of-range of the variable"
  )
  
  testthat::expect_error(gsDesign::sfExtremeValue(alpha = .025, t = c(.1,  .4), 
                                                  param = c(1, -5)),  
                         info = "Checking for out-of-range of the variable"
  )
  
  testthat::expect_error(gsDesign::sfExtremeValue(alpha = .025, t = c(.1,  .4), 
                                                  param = c(-3, -1)),  ## param should be positivie
                         info = "Checking for out-of-range of the variable"
  )
   
  
  testthat::expect_error(gsDesign::sfExtremeValue(alpha = .025, t = c(.1,  .4), 
                                                  param = c(NULL, 0.2, 0.05, .4)),  
                         info = "Checking for out-of-range of the variable"
  )
  
  testthat::expect_error(gsDesign::sfExtremeValue(alpha = .025, t = c(.1,  .4), 
                                                  param = c(0.2, 0.05, NULL, .4)),  
                         info = "Checking for out-of-range of the variable"
  )
  
  testthat::expect_error(gsDesign::sfExtremeValue(alpha = .025, t = c(.1,  .4), 
                                                  param = c(0.1, 0.01, 0.1, 0.4)),  
                         info = "Checking for out-of-range of the variable"
  )
  
  testthat::expect_error(gsDesign::sfExtremeValue(alpha = .025, t = c(.1,  .4), 
                                                  param = c(0.01, 0.1, 0.4, 0.1)),  
                         info = "Checking for out-of-range of the variable"
  )
  
  testthat::expect_error(gsDesign::sfExtremeValue(alpha = .025, t = c(.1,  .4), 
                                                  param = c(0.01, -0.1, 0.1, 0.4)),  
                         info = "Checking for out-of-range of the variable"
  )
  
   
  testthat::expect_error(gsDesign::sfExtremeValue(alpha = .025, t = c(.1,  .4), 
                                                  param = c(0.4, 0.1, 0.1, 0.4)),  
                         info = "Checking for out-of-range of the variable"
  )
  
})


testthat::test_that("Test: output validation param length as 2,  
                    Source: helper.R",  {
  
  t <- c(0.2, 0.15, .75, 1)
  param<-c(0.1, 0.2)
  alpha<-0.02
  
  sp <- gsDesign::sfExtremeValue(alpha, t, param)$spend
  expected_sp <- validate_sfExtremeValue(alpha, t, param)
  expect_equal(sp,expected_sp)
})


 
testthat::test_that("Test: output validation param length as 4,  
                     Source: helper.R",  {
  
  t <- c(0.2, 0.15, 0.75, 1)
  param<-c(0.1, 0.2, 0.2, 0.3)
  alpha<-0.02

  sp <- gsDesign::sfExtremeValue(alpha, t, param)$spend
  expected_sp <- validate_sfExtremeValue(alpha, t, param)
  expect_equal(sp,expected_sp)
})
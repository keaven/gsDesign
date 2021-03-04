source('../gsDesign_independent_code.R')
#----------------------------------
### Testing sfCauchy function
#----------------------------------

testthat::test_that("Test: alpha - Testing incorrect variable type, 
                    out-of-range variable value", {
  testthat::expect_error(gsDesign::sfCauchy(alpha = "abc", t = c(.1, .4), 
                                            param = c(0.1, 0.2)), 
                         info = "Checking for incorrect variable type"
  )
  
  testthat::expect_error(gsDesign::sfCauchy(alpha = 0, t = c(.1, .4), 
                                            param = c(0.1, 0.2)), 
                         info = "Checking for out-of-range variable value"
  )
  
 
  testthat::expect_error(gsDesign::sfCauchy(alpha = -1, t = c(.1, .4), 
                                            param = c(0.1, 0.2)), 
                         info = "Checking for out-of-range variable value"
  )
  
})


testthat::test_that("Test: t - Testing incorrect variable type, 
                    out-of-range variable value", {
  
 
  
  testthat::expect_error(gsDesign::sfCauchy(alpha = .025, t = c("a", "b"), 
                                            param = c(0.1, 0.2)), 
                         info = "Checking for incorrect variable type"
  )
  
 
  testthat::expect_error(gsDesign::sfCauchy(alpha = .025, t = c(-.5, .75), 
                                            param = c(0.1, 0.2)), 
                         info = "Checking for out-of-range variable value"
  )
  
  testthat::expect_error(gsDesign::sfCauchy(alpha = .025, t = c(-.75, 1), 
                                            param = c(0.1, 0.2)), 
                         info = "Checking for out-of-range variable value"
  )
  
  
 
  
  testthat::expect_error(gsDesign::sfCauchy(alpha = .025, t = c(-1, -6), 
                                            param = c(0.1, 0.2)), 
                         info = "Checking for out-of-range variable value"
  )
  
 
  testthat::expect_error(gsDesign::sfCauchy(alpha = .025, t = c(0.2, 0.5, , 0.7, 1), 
                                            param = c(0.1, 0.2)), 
                         info = "Error in c(0.2, 0.5, , 0.7, 1) : argument 3 is empty"
  )
  
 
})



testthat::test_that("Test: param - Testing incorrect variable type, 
                    out-of-range variable value", {
  
  testthat::expect_error(gsDesign::sfCauchy(alpha = .025, t = c(.1, .4), 
                                            param = c("a", "b")), 
                         info = "Checking for incorrect variable type"
  )
  
  
  testthat::expect_error(gsDesign::sfCauchy(alpha = .025, t = c(.1, .4), param = 4), 
                         info = "Checking for incorrect variable type"
  )  
  
  testthat::expect_error(gsDesign::sfCauchy(alpha = .025, t = c(.1, .4), param = .4), 
                         info = "Checking for incorrect variable type"
  ) 
  
  testthat::expect_error(gsDesign::sfCauchy(alpha = .025, t = c(.1, .4), 
                                            param = c(.4)), 
                         info = "Checking for length of the variable"
  )
  
  testthat::expect_error(gsDesign::sfCauchy(alpha = .025, t = c(.1, .4), 
                                            param = c(.2, .55, .75)), 
                         info = "Checking for length of the variable"
  )
  
  testthat::expect_error(gsDesign::sfCauchy(alpha = .025, t = c(.1, .4), 
                                            param = c(.2, .45, .55, 0.75, 0.85)), 
                         info = "Checking for length of the variable"
  )
  
  testthat::expect_error(gsDesign::sfCauchy(alpha = .025, t = c(.1, .4), 
                                            param = c(0, 0)), 
                         info = "Checking for out-of-range of the variable"
  )
  
 
  
  testthat::expect_error(gsDesign::sfCauchy(alpha = .025, t = c(.1, .4), 
                                            param = c(.1, -5)), 
                         info = "Checking for out-of-range of the variable"
  )
  
  testthat::expect_error(gsDesign::sfCauchy(alpha = .025, t = c(.1, .4), 
                                            param = c(.1, 0)), 
                         info = "Checking for out-of-range of the variable"
  )
  
  
  testthat::expect_error(gsDesign::sfCauchy(alpha = .025, t = c(.1, .4), 
                                            param = c(NULL, 0.2, 0.05, .4)), 
                         info = "Checking for out-of-range of the variable"
  )
  
  testthat::expect_error(gsDesign::sfCauchy(alpha = .025, t = c(.1, .4), 
                                            param = c(0.1, 0.01, 0.1, 0.4)), 
                         info = "Checking for out-of-range of the variable"
  )
  
  testthat::expect_error(gsDesign::sfCauchy(alpha = .025, t = c(.1, .4), 
                                            param = c(0.01, 0.1, 0.4, 0.1)), 
                         info = "Checking for out-of-range of the variable"
  )
  
  testthat::expect_error(gsDesign::sfCauchy(alpha = .025, t = c(.1, .4), 
                                            param = c(0.01, -0.1, 0.1, 0.4)), 
                         info = "Checking for out-of-range of the variable"
  )
  
  
  testthat::expect_error(gsDesign::sfCauchy(alpha = .025, t = c(.1, .4), 
                                            param = c(0.4, 0.1, 0.1, 0.4)), 
                         info = "Checking for out-of-range of the variable"
  )
  
})


testthat::test_that("Test: output validation param length as 2, 
                    Source: gsDesign_independent_code.R", {
  
  t <- c(0.25, 0.5, 0.75, 1)
  param <- c(1, 2)
  alpha <- 0.05
    
  sp <- gsDesign::sfCauchy(alpha, t, param)$spend
  expect_sp <- validate_sfCauchy(alpha, t, param)
  expect_equal(sp, expect_sp)
})

 

testthat::test_that("Test: output validation param length as 4, 
                    Source: gsDesign_independent_code.R", {
  t <- c(0.25, 0.5, .75, 1)
  param <- c(0.2, 0.4, 0.1, 0.3)
  alpha <- 0.05
  
  sp <- gsDesign::sfCauchy(alpha, t, param)$spend
  expect_sp <- validate_sfCauchy(alpha, t, param)
  expect_equal(sp, expect_sp)
})

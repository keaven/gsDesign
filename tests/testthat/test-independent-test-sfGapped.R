source('../gsDesign_independent_code.R')

#-----------------------------------
### Testing sfGapped function
#-----------------------------------

testthat::test_that("Test: alpha - Testing incorrect variable type,
                    out-of-range variable value", {
  
  tx <- (0:100) / 100
  param <- list(trange = c(.2, .8), sf = gsDesign::sfHSD, param = 1 )
  
  testthat::expect_error(gsDesign::sfGapped(alpha = "abc",t = c(.1, .4),param ),
                         info = "Checking for incorrect variable type"
  )
  
  testthat::expect_error(gsDesign::sfGapped(alpha = 0,t = c(.1, .4),param ),
                         info = "Checking for out-of-range variable value"
  )
  
  
  testthat::expect_error(gsDesign::sfGapped(alpha = -1,t = c(.1, .4),param ),
                         info = "Checking for out-of-range variable value"
  )
  
  
})


# t is numeric vector
testthat::test_that("Test: t - Checking Variable Type, 
                    Out-of-Range, Order-of-List", {
  
  param <- list(trange = c(.2, .8), sf = gsDesign::sfHSD, param=1 )
  
  testthat::expect_error(gsDesign::sfGapped(alpha = .025,t = "a",param ),
                         info = "Checking for incorrect variable type"
  )
  
  testthat::expect_error(gsDesign::sfGapped(alpha = .025,t = c("a","b"),param ),
                         info = "Checking for incorrect variable type"
  )
  
  testthat::expect_error(gsDesign::sfGapped(alpha = .025,t = c(-.5,.75),param ),
                         info = "Checking for out-of-range variable value"
  )
  
  testthat::expect_error(gsDesign::sfGapped(alpha = .025,t = c(.5,-.75),param ),
                         info = "Checking for out-of-range variable value"
  )
  
 
  testthat::expect_error(gsDesign::sfGapped(alpha = .025,t = c(1,-5),param ),
                         info = "Checking for out-of-range variable value"
  )
  testthat::expect_error(gsDesign::sfGapped(alpha = .025,t = c(-1,5),param ),
                         info = "Checking for out-of-range variable value"
  )
  
})


#param is numeric vector
testthat::test_that("Test: param - Checking Variable Type, 
                    Out-of-Range, Order-of-List", {
  
  #Testing for sfGapped.param.trange
  tx <- (0:100) / 100
  param <- list(trange = "a", sf = gsDesign::sfHSD, param = 1)
  testthat::expect_error(gsDesign::sfGapped(alpha = .05,t = tx,param),
                         info = "Checking for incorrect variable type"
  )
  
  param <- list(trange = .3, sf = gsDesign::sfHSD, param = 1)
  testthat::expect_error(gsDesign::sfGapped(alpha = .05,t = tx,param),
                         info = "Checking for incorrect variable type"
  )
  
  param <- list(trange = c("a","b"), sf = gsDesign::sfHSD, param = 1)
  testthat::expect_error(gsDesign::sfGapped(alpha = .05,t = tx,param),
                         info = "Checking for incorrect variable type"
  )
  
  param <- list(trange = c(0,1.1), sf = gsDesign::sfHSD, param = 1)
  testthat::expect_error(gsDesign::sfGapped(alpha = .05,t = tx,param),
                         info = "Checking for out-of-range variable value"
  )
  
  param <- list(trange = c(0,-8), sf = gsDesign::sfHSD, param = 1)
  testthat::expect_error(gsDesign::sfGapped(alpha = .05,t = tx,param),
                         info = "Checking for out-of-range variable value"
  )
  
  param <- list(trange = c(-2,8), sf = gsDesign::sfHSD, param = 1)
  testthat::expect_error(gsDesign::sfGapped(alpha = .05,t = tx,param),
                         info = "Checking for out-of-range variable value"
  )
  
  param <- list(trange = c(.8,.5), sf = gsDesign::sfHSD, param = 1)
  testthat::expect_error(gsDesign::sfGapped(alpha = .05,t = tx,param),
                         info = "Checking for out-of-range variable value"
  )
  
  param <- list(trange = c(.8,.8), sf = gsDesign::sfHSD, param = 1)
  testthat::expect_error(gsDesign::sfGapped(alpha = .05,t = tx,param),
                         info = "Checking for out-of-range variable value"
  )
  
  param <- list(trange = c(.0,.0), sf = gsDesign::sfHSD, param = 1)
  testthat::expect_error(gsDesign::sfGapped(alpha = .05,t = tx,param),
                         info = "Checking for order of the list"
  )
  
  ##Testing for sfGapped.param.param <TBD>
  param <- list(trange = c(.2,.8), sf = gsDesign::sfHSD, param = "a" )
  testthat::expect_error(gsDesign::sfGapped(alpha = .05,t = tx,param),
                         info = "Checking for out-of-range variable value"
  )
  
  param <- list(trange = c(.2,.8), sf = gsDesign::sfHSD, param = c(0,1) )
  testthat::expect_error(gsDesign::sfGapped(alpha = .05,t = tx,param),
                         info = "Checking for out-of-range variable value"
  )
  
  param <- list(trange = c(.2,.8), sf = gsDesign::sfHSD, param = NULL )
  testthat::expect_error(gsDesign::sfGapped(alpha = .05,t = tx,param),
                         info = "Checking for out-of-range variable value"
  )
  
 
  #Testing for sfGapped.param.sf assigning invalid value
  testthat::expect_error(gsDesign::sfGapped(alpha = .05,t = tx,
                                       param =  param <- list(trange = c(.2,.8), 
                                       sf = sfHSD1, param = 1 )),
                         info = "Checking for out-of-range variable value"
  )
  
  param <- list(trange = c(.2,.8), sf = NULL, param = 1 )
  testthat::expect_error(gsDesign::sfGapped(alpha = .05,t = tx,param),
                         info = "Checking for out-of-range variable value"
  )
  
  
})


testthat::test_that("Test: sfNormal, 
                    Source: gsDesign_independent_code.R", {
  tx <- c(0.167,0.333,0.5,0.667,0.833,1)
  param <- list(trange = c(.2, .8), sf = gsDesign::sfNormal, param = c(1,2))
  alpha<-0.05 

  spend <- gsDesign::sfGapped(alpha,tx,param)$spend
  expected_spend <- validate_sfGapped(alpha,tx,param)
  expect_equal(spend,expected_spend)
})


testthat::test_that("Test: sfExponential: Output verification, 
                    Source: gsDesign_independent_code.R", {
  
  tx <- c(0.167,0.333,0.5,0.667,0.833,1)
  param <- list(trange = c(.2, .8), sf = gsDesign::sfExponential, param = 1.5 )
  alpha<-0.05

  spend <- gsDesign::sfGapped(alpha,tx,param)$spend
  expected_spend <- validate_sfGapped(alpha,tx,param)
  expect_equal(spend,expected_spend)
})


testthat::test_that("Test:  sfLDPocock: Output verification, 
                    Source: gsDesign_independent_code.R", {
  
  
  tx <- c(0.167,0.333,0.5,0.667,0.833,1)
  param <- list(trange = c(.2, .8), sf = gsDesign::sfLDPocock, param = 1 )
  alpha<-0.05
   
  spend <- gsDesign::sfGapped(alpha,tx,param)$spend
  expected_spend <- validate_sfGapped(alpha,tx,param)
  expect_equal(spend,expected_spend)
})


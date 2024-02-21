#-----------------------------------
### Testing spendingFunction  function
#-----------------------------------

testthat::test_that("Test: alpha - incorrect variable type", {
  tx <- (0:100) / 100
  param <- list(trange = c(.2, .8), sf = gsDesign::sfHSD, param = 1)

  testthat::expect_error(gsDesign::spendingFunction(alpha = "abc", t = c(.1, .4), param),
    info = "Checking for incorrect variable type"
  )

  testthat::expect_error(gsDesign::spendingFunction(alpha = 0, t = c(.1, .4), param),
    info = "Checking for out-of-range variable value"
  )


  testthat::expect_error(gsDesign::spendingFunction(alpha = -1, t = c(.1, .4), param),
    info = "Checking for out-of-range variable value"
  )
})


# t is numeric vector
testthat::test_that("Test: t - Checking Variable Type, Out-of-Range, 
                    Order-of-List", {
  param <- list(trange = c(.2, .8), sf = gsDesign::sfHSD, param = 1)

  testthat::expect_error(gsDesign::spendingFunction(alpha = .025, t = "a", param),
    info = "Checking for incorrect variable type"
  )

  testthat::expect_error(gsDesign::spendingFunction(alpha = .025, t = c("a", "b"), param),
    info = "Checking for incorrect variable type"
  )

  testthat::expect_error(gsDesign::spendingFunction(alpha = .025, t = c(-.5, .75), param),
    info = "Checking for out-of-range variable value"
  )

  testthat::expect_error(gsDesign::spendingFunction(alpha = .025, t = c(.5, -.75), param),
    info = "Checking for out-of-range variable value"
  )


  testthat::expect_error(gsDesign::spendingFunction(alpha = .025, t = c(1, -5), param),
    info = "Checking for out-of-range variable value"
  )
  testthat::expect_error(gsDesign::spendingFunction(alpha = .025, t = c(-1, 5), param),
    info = "Checking for out-of-range variable value"
  )
})



testthat::test_that("Test: output validation for alpha - 0.025, 
                    Source: helper.R )", {
  tx <- c(.025, .05, .25, .75, 1)
  alpha <- 0.025
  param <- 1

  spend <- gsDesign::spendingFunction(alpha, tx, param)$spend
  expected_spend <- validate_spendingFunction(alpha, tx, param)
  expect_equal(spend, expected_spend)
})

testthat::test_that("Test: output validation for alpha - 0.02, 
                    Source: helper.R )", {

  ## spendingFunction ###
  tx <- c(.2, .15, 1)
  alpha <- 0.02
  param <- NULL

  spend <- gsDesign::spendingFunction(alpha, tx, param)$spend
  expected_spend <- validate_spendingFunction(alpha, tx, param)
  expect_equal(spend, expected_spend)
})



testthat::test_that("Test: output validation for param - 0, 
                    Source: helper.R )", {
  tx <- c(0.9, .5)
  alpha <- .01
  param <- 0

  spend <- gsDesign::spendingFunction(alpha, tx, param)$spend
  expected_spend <- validate_spendingFunction(alpha, tx, param)
  expect_equal(spend, expected_spend)
})



testthat::test_that("Test: output validation for param - 5, 
                    Source: helper.R )", {
  tx <- c(.25, 0.5, 0.75, 1)
  alpha <- .025
  param <- 5

  spend <- gsDesign::spendingFunction(alpha, tx, param)$spend
  expected_spend <- validate_spendingFunction(alpha, tx, param)
  expect_equal(spend, expected_spend)
})

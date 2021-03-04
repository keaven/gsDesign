source('../gsDesign_independent_code.R')

#-----------------------------------
### Testing sfTDist function
#-----------------------------------


testthat::test_that("Test: alpha - incorrect variable type", {
  testthat::expect_error(gsDesign::sfTDist(
    alpha = "abc", t = c(.1, .4),
    param = c(0.1, 0.2)
  ),
  info = "Checking for incorrect variable type"
  )

  testthat::expect_error(gsDesign::sfTDist(
    alpha = 0, t = c(.1, .4),
    param = c(0.1, 0.2)
  ),
  info = "Checking for out-of-range variable value"
  )


  testthat::expect_error(gsDesign::sfTDist(
    alpha = -1, t = c(.1, .4),
    param = c(0.1, 0.2)
  ),
  info = "Checking for out-of-range variable value"
  )
})


testthat::test_that("Test: t - Checking Variable Type, 
                    Out-of-Range, Order-of-List", {
  testthat::expect_error(gsDesign::sfTDist(alpha = .025, t = "a", param = c(0.1, 0.2)),
    info = "Checking for incorrect variable type"
  )

  testthat::expect_error(gsDesign::sfTDist(
    alpha = .025, t = c("a", "b"),
    param = c(0.1, 0.2)
  ),
  info = "Checking for incorrect variable type"
  )


  testthat::expect_error(gsDesign::sfTDist(
    alpha = .025, t = c(-.5, .75),
    param = c(0.1, 0.2)
  ),
  info = "Checking for out-of-range variable value"
  )

  testthat::expect_error(gsDesign::sfTDist(
    alpha = .025, t = c(.5, -.75),
    param = c(0.1, 0.2)
  ),
  info = "Checking for out-of-range variable value"
  )

  testthat::expect_error(gsDesign::sfTDist(
    alpha = .025, t = c(1, 6),
    param = c(0.1, 0.2)
  ),
  info = "Checking for out-of-range variable value"
  )
  testthat::expect_error(gsDesign::sfTDist(
    alpha = .025, t = c(6, 1),
    param = c(0.1, 0.2)
  ),
  info = "Checking for out-of-range variable value"
  )

  testthat::expect_error(gsDesign::sfTDist(
    alpha = .025, t = c(1, -5),
    param = c(0.1, 0.2)
  ),
  info = "Checking for out-of-range variable value"
  )
  testthat::expect_error(gsDesign::sfTDist(
    alpha = .025, t = c(-1, 5),
    param = c(0.1, 0.2)
  ),
  info = "Checking for out-of-range variable value"
  )
})



testthat::test_that("Test: param - Checking Variable Type, Out-of-Range, 
                    Order-of-List", {
  testthat::expect_error(gsDesign::sfTDist(
    alpha = .025, t = c(.1, .4),
    param = c("a", "b")
  ),
  info = "Checking for incorrect variable type"
  )

  testthat::expect_error(gsDesign::sfTDist(alpha = .025, t = c(.1, .4), param = "a"),
    info = "Checking for incorrect variable type"
  )


  testthat::expect_error(gsDesign::sfTDist(alpha = .025, t = c(.1, .4), param = 4),
    info = "Checking for incorrect variable type"
  )



  testthat::expect_error(gsDesign::sfTDist(
    alpha = .025, t = c(.1, .4),
    param = c(.2, .55, .75)
  ),
  info = "Checking for length of the variable"
  )

  testthat::expect_error(gsDesign::sfTDist(
    alpha = .025, t = c(.1, .4),
    param = c(.2, .45, .55, 0.75, 0.85)
  ),
  info = "Checking for length of the variable"
  )

  testthat::expect_error(gsDesign::sfTDist(
    alpha = .025, t = c(.1, .4),
    param = c(1, 0)
  ),
  info = "Checking for out-of-range of the variable"
  )

  testthat::expect_error(gsDesign::sfTDist(
    alpha = .025, t = c(.1, .4),
    param = c(1, -5)
  ),
  info = "Checking for out-of-range of the variable"
  )

  testthat::expect_error(gsDesign::sfTDist(
    alpha = .025, t = c(.1, .4),
    param = c(-3, -1)
  ),
  info = "Checking for out-of-range of the variable"
  )

  testthat::expect_error(gsDesign::sfTDist(
    alpha = .025, t = c(.1, .4),
    param = c(NULL, 0.2, 0.05, .4)
  ),
  info = "Checking for out-of-range of the variable"
  )

  testthat::expect_error(gsDesign::sfTDist(
    alpha = .025, t = c(.1, .4),
    param = c(0.2, NULL, 0.05, .4)
  ),
  info = "Checking for out-of-range of the variable"
  )


  testthat::expect_error(gsDesign::sfTDist(
    alpha = .025, t = c(.1, .4),
    param = c(0.1, 0.01, 0.1, 0.4)
  ),
  info = "Checking for out-of-range of the variable"
  )

  testthat::expect_error(gsDesign::sfTDist(
    alpha = .025, t = c(.1, .4),
    param = c(0.01, 0.1, 0.4, 0.1)
  ),
  info = "Checking for out-of-range of the variable"
  )

  testthat::expect_error(gsDesign::sfTDist(
    alpha = .025, t = c(.1, .4),
    param = c(0.01, -0.1, 0.1, 0.4)
  ),
  info = "Checking for out-of-range of the variable"
  )
})



testthat::test_that("Test: output validation param of length 3, 
                    Source: gsDesign_independent_code.R)", {
  t <- c(.01, .05, .1, .25, .5, 1, 1.02)
  alpha <- 0.025
  param <- c(.25, .1, 1)

  spend <- gsDesign::sfTDist(alpha, t, param)$spend
  expected_spend <- validate_sfTDist(alpha, t, param)
  expect_equal(spend, expected_spend)
})


testthat::test_that("Test: output validation param of length 5, 
                    Source: gsDesign_independent_code.R", {
  t <- c(.01, .05, .1, .25, .5, 1, 1.02)
  alpha <- 0.025
  param <- c(.1, .25, 0.3, 0.5, 2)


  spend <- sfTDist(alpha, t, param)$spend
  expected_spend <- validate_sfTDist(alpha, t, param)
  expect_equal(spend, expected_spend)
})
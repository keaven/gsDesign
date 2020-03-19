testthat::context("Two-sample normal sample size and power tests")

testthat::test_that("Testing nNormal input types", {
  testthat::expect_error(gsDesign::nNormal(alpha="abc"), info = "Checking for incorrect variable type")
  testthat::expect_error(gsDesign::nNormal(beta="abc"), info = "Checking for incorrect variable type")
  testthat::expect_error(gsDesign::nNormal(delta1="abc"), info = "Checking for incorrect variable type")
  testthat::expect_error(gsDesign::nNormal(sd="abc"), info = "Checking for incorrect variable type")
  testthat::expect_error(gsDesign::nNormal(sided="abc"), info = "Checking for incorrect variable type")
  testthat::expect_error(gsDesign::nNormal(delta0="abc"), info = "Checking for incorrect variable type")
  testthat::expect_error(gsDesign::nNormal(outtype="abc"), info = "Checking for incorrect variable type")
})

testthat::test_that("Testing nNormal input values", {
  x <- nNormal(outtype = 3)
  testthat::expect_equal(x$sd, x$sd2, info = "Checking that sd2 set to sd if missing")
  testthat::expect_error(nNormal(delta1=1,delta0=1), info = "Checking for unequal delta1, delta0")
})

testthat::test_that("Testing nNormal output data frame", {
  x <- names(nNormal(outtype = 3))
  y <- c("n","n1","n2","alpha","sided","beta","Power","sd","sd2","delta1","delta0","se") 
  testthat::expect_equal(min(x==y), 1, info = "Checking output data frame columns for outtype = 3")
  x <- names(nNormal(outtype = 3, n=200))
  testthat::expect_equal(min(x==y), 1, info = "Checking output data frame columns for outtype = 3")
  x <- names(nNormal(outtype = 2))
  y <- c("n1","n2") 
  testthat::expect_equal(min(x==y), 1, info = "Checking output data frame columns for outtype = 3")
  x <- names(nNormal(outtype = 2, n=200))
  y <- c("n1","n2","Power") 
  testthat::expect_equal(min(x==y), 1, info = "Checking output data frame columns for outtype = 3")
})

testthat::test_that("Test nNormal numeric results", {
  # Use examples from vignette
  r <- 2
  sigma <- sqrt((1+r)*(1.6^2 + 1.25^2/r)) 
  theta <- 0.8/sigma
  
  testthat::expect_equal(nNormal(delta1=0.8, sd = 1.6, sd2 = 1.25, alpha = 0.025, beta=.1, ratio = 2),
                         ((qnorm(.9)+qnorm(.975))/theta)^2,
                         info = "Checking sample size derivation with formula")
  testthat::expect_equal(nNormal(delta1=0.8, sd = 1.6, sd2 = 1.25, alpha = 0.025, n = 200, ratio = 2),
                         pnorm(qnorm(.975) - sqrt(200) * theta, lower.tail = FALSE),
                         info = "Checking power calculation with formula")
  # Check same power approximation vs simulation in nNormal vignette
  testthat::expect_equal(round(nNormal(delta1=0.8, sd = 1.6, sd2 = 1.25, alpha = 0.025, 
                                                 n = 200, ratio = 2),2),
                         0.95,
                         info = "Checking power calculation from simulation example")
})

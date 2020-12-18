source('../benchmarks/gsDesign_independent_code.R')
# Testing gsNormalGrid() : normalGrid() is intended to be used for computation of
# the expected value of a function of a normal random variable.
# The function produces grid points and weights to be used for numerical integration.

#--------------------------------------------------
# gridpts function is borrowed from gsdmvn package
# install.packages("remotes")
# remotes::install_github("keaven/gsdmvn")
#--------------------------------------------------

#--------------------------------------------------
# checking gsNormalGrid() for gridpoints output.
testthat::test_that(
  desc = "Test: gridpoints  validation, 
          source: gridpts function is borrowed from gsdmvn package",
  code = {
    bounds <- c(-100, 100)
    sigma <- 1
    mu <- 0
    
    y <- gsDesign::normalGrid(r = 18, mu = 0, bounds = bounds, sigma = sigma)
    x <- gridpts(r = 18, mu = mu, a = bounds[1], b = bounds[2])
    gridpoints <- x$z * sigma
    expect_equal(y$z, gridpoints)
})

## checking gsNormalGrid() for gridpoints error.
testthat::test_that(
  desc = "Test: gridpts() bounds",
  code = {
    bounds <- c(2, 1)
    sigma <- 1
    mu <- 0
    y <- gsDesign::normalGrid(r = 6, mu = 0, bounds = bounds, sigma = sigma)
    expect_error(gridpts(r = 6, mu = mu, a = bounds[1], b = bounds[2]))
  }
    
)


testthat::test_that(desc = "Test: checking r out of range", code = {
  bounds <- c(5, 10)
  sigma <- 1
  mu <- 0
  expect_error(gsDesign::normalGrid(r = 0.5, mu = 0, bounds = bounds, sigma = sigma))

})


testthat::test_that(desc = "Test: checking sigma out of range", code = {
  bounds <- c(1, 2)
  sigma <- -0.000001
  mu <- 0
  expect_error(gsDesign::normalGrid(r = 10, mu = 0, bounds = bounds, sigma = sigma))
})

## checking gsNormalGrid() for gridpoints error.
testthat::test_that(desc = "Test: checking gridpts() mu", code = {
  bounds <- c(0, 0)
  sigma <- 4
  mu <- -1
  y <- gsDesign::normalGrid(r = 80, mu = mu, bounds = bounds, sigma = sigma)
  expect_error(gridpts(r = 80, mu = mu, a = bounds[1], b = bounds[2]))
})


testthat::test_that(desc = "Test: checking bounds length", code = {
  bounds <- c(1)
  sigma <- 4
  mu <- -1
  expect_error(gsDesign::normalGrid(r = 6, mu = mu, bounds = bounds, sigma = sigma))
})

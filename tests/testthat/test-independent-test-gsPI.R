source('../gsDesign_independent_code.R')
#---------------
## gsPI

# For this test case, the tolerance is set to 1e-4 (= 0.0001), 
# the results should match up to 3-4 decimal places
#--------------

testthat::test_that(desc = "Test: checking out of range i", 
                    code = {
  x <- gsDesign(k = 3, test.type = 1, n.fix = 800)
  local_edition(3)
  expect_error(gsPI(x, i = 4, zi = 0, j = 2, level = 0.95, theta = c(0, 3), 
                    wgts = c(0.5, 0.5)))
})


testthat::test_that(desc = "Test: checking out of range zi", code = {
  x <- gsDesign(k = 3, test.type = 1, n.fix = 800)
  local_edition(3)
  expect_error(gsPI(x, i = 1, zi = Inf, j = 2, level = 0.95, theta = c(0, 3), 
                    wgts = c(0.5, 0.5)))
})


testthat::test_that(desc = "Test: checking out of range zi", code = {
  x <- gsDesign(k = 3, test.type = 1, n.fix = 800)
  local_edition(3)
  expect_error(gsPI(x, i = 1, zi = 1, j = 2, level = 0.95, theta = c(0, 3), wgts = c(-1, 1)))
})


testthat::test_that(desc = "Test: checking input length", code = {
  x <- gsDesign(k = 3, test.type = 1, n.fix = 800)
  local_edition(3)
  expect_error(gsPI(x, i = 1, zi = 1, j = 2, level = 0.95, theta = c(0, 1.5, 3), wgts = c(0.5, 0.5)))
})


testthat::test_that(desc = "Test: checking out of range R", code = {
  x <- gsDesign(k = 3, test.type = 1, n.fix = 800)
  local_edition(3)
  expect_error(gsPI(x, i = 1, zi = 1, j = 1, level = 0.95, theta = c(0, 3), wgts = c(0.5, 0.5)))
})


testthat::test_that(desc = "Test: checking variable type", code = {
  x <- seq(1, 2, 0.5)
  local_edition(3)
  expect_error(gsPI(x, i = 1, zi = 1, j = 1, level = 0.95, theta = c(0, 3),
                    wgts = c(0.5, 0.5)))
})


testthat::test_that(desc = "Test: checking output validation
                    source: gsDesign_independent_code.R", 
                    code = {
                      
    x <- gsDesign(k = 4, n.fix = 1371, timing = c(0.25,0.5, 0.7),
                  beta = 0.2, sfupar = -3, endpoint = "binomial", delta1 = 0.05)
    i <- 1
    j <- 3
    k <- x$k
    zi <- c(2.58, 1.93, 2.47, 2.41)
    alpha <-0.1
    mu<-0.05
    sigma1sq <- 0.025
    zi <- c(2.58, 1.93, 2.47, 2.41)
    prior <- normalGrid(mu = mu, sigma = sqrt(sigma1sq))
    
    PI <- gsPI(level = 0.9, x , i = i, j = 3, zi = zi[i], theta = prior$z,
         wgts = prior$wgts) 
    
    expected_PI <- validate_gsPI(x,i,j,k,zi,alpha,mu,sigma1sq)
    
    expect_lte(abs(PI[1] - expected_PI[1]), 1e-4)
    expect_equal(PI[2], expected_PI[2])

})

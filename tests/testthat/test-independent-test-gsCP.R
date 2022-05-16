#-------------
## Testing gsCP:
#source : test/benchmarks/gsCP.cywx

# For comparing floating-point numbers, an exact match cannot be expected. 
# For such test cases, the tolerance is set to 1e-6 (= 0.000001), 
# a sufficiently low value
#-------------

testthat::test_that(desc = "Test: one-sided output validation, 
                           source: CP Calculations done using East 6.5 file gsCP.cywx ",
  code = {
    x <- gsDesign(k = 3, test.type = 1, n.fix = 800)
    z1 <- -3.25558985896551
    theta1 <- -0.1977636
    
    CP <- gsCP(x, theta = theta1, i = 1, zi = z1, r = 80)
    local_edition(3)
    expect_equal(sum(CP$upper$prob) , 4.289818e-21)
})


testthat::test_that(desc = "Test: two-sided output validation,
                    source: CP Calculations done using East 6.5 file gsCP.cywx ",
  code = {
    x <- gsDesign(k = 3, test.type = 2, n.fix = 800)
    z1 <- 0.943317
    theta1 <- 0.05733214
    
    CP <- gsCP(x, theta = theta1, i = 1, zi = z1, r = 80)
    local_edition(3)
    expect_lte(abs(sum(CP$upper$prob) - 0.3306859), 1e-6)
})


testthat::test_that(desc = "Test: out of range i ", 
                    code = {
  x <- gsDesign(k = 3, test.type = 1, n.fix = 800)
  local_edition(3)
  expect_error(gsCP(x, theta = NULL, i = 5, zi = 0.943317, r = 18))
})


testthat::test_that(desc = "Test: zi is not a scalar", 
                    code = {
  x <- gsDesign(k = 3, test.type = 1, n.fix = 800)
  local_edition(3)
  expect_error(gsCP(x, theta = NULL, i = 2, zi = c(1, 2), r = 18))
})


testthat::test_that(desc = "Test: out of range zi - test.type = 2 ", 
                    code = {
  x <- gsDesign(k = 3, test.type = 2, n.fix = 800)
  local_edition(3)
  expect_error(gsCP(x, theta = NULL, i = 2, zi = 3, r = 18))
})


testthat::test_that(desc = "Test: out of range zi - test.type = 3", 
                    code = {
  x <- gsDesign(k = 3, test.type = 3, n.fix = 800)
  local_edition(3)
  expect_error(gsCP(x, theta = 0.5, i = 1, zi = -0.5, r = 80))
})


testthat::test_that(desc = "Test: output with theta null,
                    source: CP Calculations done using East 6.5", 
                    code = {
  x <- gsDesign(k = 3, test.type = 1, n.fix = 800)
  CP <- gsCP(x, theta = NULL, i = 1, zi = -3.255599, r = 80)
  expect_equal(sum(CP$upper$prob), 0.01858668, 1e-6)
})


testthat::test_that(desc = "Test: class object of gsDesign", code = {
  x <- seq(1, 2, 0.5)
  local_edition(3)
  expect_error(gsCP(x, theta = -0.1977636, i = 1, zi = -3.255599, r = 80))
})

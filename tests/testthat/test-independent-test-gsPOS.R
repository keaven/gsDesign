#------------
##gsPOS

# For comparing floating-point numbers, an exact match cannot be expected. 
# For such test cases, the tolerance is set to 1e-6 (= 0.000001), 
# a sufficiently low value
#------------


testthat::test_that(desc = "Test: checking class object of x", code = {
  x = seq(1,2,0.5)
  local_edition(3)
  expect_error(gsPOS(x,theta = c(0.3, 0.5), wgts = c(0.3, 0.5)))
})



testthat::test_that(desc = "Test: checking numeric check", code = {
  x = gsDesign(k = 3, test.type = 1, n.fix = 800)
  local_edition(3)
  expect_error(gsPOS(x,theta = 'theta', wgts = c(0.5, 0.5)))
})



testthat::test_that(desc = "Test: checking lengths of inputs", code = {
  x = gsDesign(k = 2, test.type = 1)
  local_edition(3)
  expect_error(gsPOS(x, theta = c(-1.50, -0.75 ,0.75, 1.50), 
  wgts =c(0.064758798, 0.301137432, 0.199471140, 0.301137432, 0.064758798)))
})


testthat::test_that(desc = "Test: checking output validation,
                    source: calculation done in excel using the formula in the gsDesign manual", code = {
  x = gsDesign(k = 2, test.type = 1)
  local_edition(3)
  POS <- (gsPOS(x, theta = c(-1.50, -0.75, 0.00, 0.75, 1.50), 
       wgts =c(0.064758798, 0.301137432,0.199471140, 0.301137432, 0.064758798)))
  expect_lte(abs(POS - 0.060780135), 1e-6)
})

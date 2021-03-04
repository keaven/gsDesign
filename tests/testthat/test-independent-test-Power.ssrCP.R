#-------------------------------------------------------------------------------
# Power.ssrCP : output validation : computes unconditional power for a 
# Sample size-re-estimation design.
# design derived by ssrCP.

# Expected Output Source is East 6.5
# Certain mismatches may be expected:
# around 2% in power and 5-10 in sample size
# Possible reasons: 
# (i)  East Power computation is simulation based
# (ii) East Sample Size computation uses rounded sample sizes
#-------------------------------------------------------------------------------

testthat::test_that(
  desc = "Test : checking r out of range : theta = NULL, delta = NULL", code = {
    xa <- ssrCP(z1 = seq(-3, 3, 0.1), theta = NULL, maxinc = 2, overrun = 0,
                beta = 0.1, cpadj = c(0.5, 1 - 0.2),
                x = gsDesign(k = 2, delta = 0.2), z2 = z2NC)
    
    expect_error(Power.ssrCP(x = xa, theta = NULL, delta = NULL, r = 81))
})



testthat::test_that(
  desc = "Test : checking r out of range : delta = NULL", code = {
    xa <- ssrCP(z1 = seq(-3, 3, 0.1), theta = NULL, maxinc = 2, overrun = 0,
                beta = 0.1, cpadj = c(0.5, 1 - 0.2),
                x = gsDesign(k = 2, delta = 0.2), z2 = z2NC)
    
    expect_error(Power.ssrCP(x = xa, theta = 0.5, delta = NULL, r = 81))
})


testthat::test_that(
  desc = "Test : checking r out of range : theta = NULL", code = {
    xa <- ssrCP(z1 = seq(-3, 3, 0.1), theta = NULL, maxinc = 2, overrun = 0,
                beta = 0.1, cpadj = c(0.5, 1 - 0.2),
                x = gsDesign(k = 2, delta = 0.2), z2 = z2NC)
    
    expect_error(Power.ssrCP(x = xa, theta = NULL, delta = 0.2, r = 81))
})



testthat::test_that(
  desc = "Test : checking x should be class of ssrCP", code = {
    xa <- gsDesign(k = 2, test.type = 2, n.fix = 800, timing = c(0.5, 1),
                   delta1 = 0.1146049, delta0 = 0)
    
    expect_error(Power.ssrCP(x = xa, theta = NULL, delta = NULL, r = 18))
})


# output validation : computes unconditional power for a conditional power.
testthat::test_that(
  desc = "Test : output validation
         source : East 6.5 output", code = {
    xa <- gsDesign(k = 2, test.type = 2, n.fix = 3200, timing = c(0.9, 1),
                   delta1 = 0.1146049, delta0 = 0)
    ssr <- ssrCP(z1 = 1.2, delta = 0.1146049, maxinc = 4, overrun = 0,
                 beta = 0.1, cpadj = c(0.8, 0.9), x = xa, z2 = z2Z)
    res1 <- Power.ssrCP(x = ssr, theta = 0.057302441, r = 18)

    expect_equal(res1$Power, 0.90242, 1e-1)
})


# output validation : computes unconditional power for a conditional power.
testthat::test_that(
  desc = "Test : output validation
          source : East 6.5 output", code = {
    x <- gsDesign(k = 2, test.type = 2, n.fix = 3200, timing = c(0.5, 1),
                  delta1 = 0.1146049, delta0 = 0)
    ssr <- ssrCP(z1 = 1.2, delta = 0.1146049, maxinc = 2, overrun = 0,
                 beta = 0.2, cpadj = c(0.3, 0.8), x = x, z2 = z2Z)
    res2 <- Power.ssrCP(x = ssr, theta = 0.057302441, r = 18)

    expect_equal(res2$Power, 0.9214, 1e-2)
})


# output validation : computes unconditional power for a conditional power.
testthat::test_that(
  desc = "Test : output validation
          source : East 6.5", code = {
    x <- gsDesign(k = 2, test.type = 2, n.fix = 3200, timing = c(0.5, 1),
                  delta1 = 0.1146049, delta0 = 0)
    ssr <- ssrCP(z1 = 1.2, delta = 0.1146049, maxinc = 2, overrun = 0,
                 beta = 0.2, cpadj = c(0.5, 0.6), x = x, z2 = z2Z)
    res3 <- Power.ssrCP(x = ssr, theta = 0.057302441, r = 18)
    
    expect_equal(res3$Power, 0.901, 1e-2) 
})
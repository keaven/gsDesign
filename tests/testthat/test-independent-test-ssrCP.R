source('../benchmarks/gsDesign_independent_code.R')
#-------------------------------------------------------------------------------
# ssrCp : ssrCP() adapts 2-stage group sequential designs to 2-stage sample size
# re-estimation designs based on interim analysis conditional power.

# For comparing floating-point numbers, an exact match cannot be expected. 
# For such test cases, the tolerance is set to 1e-6 (= 0.000001), 
# a sufficiently low value
#-------------------------------------------------------------------------------

testthat::test_that(
  desc = "Test: output validation stage 2 sample sizes (n2), conditional power (CP) 
          source : gsDesign_independent_code.R", code = {
    x <- gsDesign(k = 2, test.type = 2, n.fix = 800, timing = c(0.5, 1),
                  delta1 = 0.1146049, delta0 = 0, beta=0.2)
    z1 <- 1.19999

    a_res <- ssrCP(z1 = z1, theta = NULL, maxinc = 4, overrun = 0,
          beta = x$beta, cpadj = c(.3, 1 - x$beta),x = x,z2 = z2NC)
    
    e_res <- validate_ssrCP(x,z1)
    
    expect_equal(a_res$dat$n2, e_res[[1]], 1e-6)
    expect_equal(a_res$dat$CP, e_res[[2]], 1e-6)
})


testthat::test_that(
  desc = "Test : x object of class gsDesign", code = {
    expect_error(ssrCP(z1 = 1.15603343629543, theta = NULL, maxinc = 3,
                      overrun = 0, beta = 0.2, cpadj = c(.3, 0.8),
                      x = seq(0, 1, 0.5), z2 = z2Z))
})


testthat::test_that(
  desc = "Test : 2 stages input group sequential (k=2)", code = {
    expect_error(
      ssrCP(z1 = 1.15603343629543, theta = NULL, maxinc = 3, overrun = 0, 
            beta = 0.2, cpadj = c(.3, 0.8),
            x = gsDesign(k = 3, test.type = 2, n.fix = 800, timing = c(0.5, .8),
                        delta1 = 0.1146049, delta0 = 0), 
            z2 = z2Z))
})


testthat::test_that(
  desc = "Test : z1 out of range", code = {
    expect_error(ssrCP(z1 = Inf, theta = NULL, maxinc = 3,overrun = 0, 
                       beta = 0.2, cpadj = c(.3, 0.8),
                       x = gsDesign(k = 2, test.type = 2, n.fix = 800, 
                            timing = c(0.5, 1),delta1 = 0.1146049, delta0 = 0), 
                       z2 = z2Z))
})


testthat::test_that(
  desc = "Test : cpadj out of range", code = {
    expect_error(ssrCP(z1 = 1.15603343629543, theta = NULL, maxinc = 3,
                       overrun = 0, beta = 0.2, cpadj = c(.3, 1),
                       x = gsDesign(k = 2, test.type = 2, n.fix = 800, 
                             timing = c(0.5, 1),delta1 = 0.1146049, delta0 = 0), 
                       z2 = z2Z))
})


testthat::test_that(
  desc = "Test : cpadj increasing pair of numbers between 0 and 1 ", code = {
    expect_error(ssrCP(z1 = 1.15603343629543, theta = NULL, maxinc = 3,
                       overrun = 0, beta = 0.2, cpadj = c(.8, 0.5),
                       x = gsDesign(k = 2, test.type = 2, n.fix = 800, 
                              timing = c(0.5, 1),delta1 = 0.1146049, delta0 = 0), 
                       z2 = z2Z))
})


testthat::test_that(
  desc = "Test : overrun out of range", code = {
    expect_error(ssrCP(z1 = 1.15603343629543, theta = NULL, maxinc = 3,
                       overrun = -1, beta = 0.2, cpadj = c(.3, 0.8),
                      x = gsDesign(k = 2, test.type = 2, n.fix = 800, 
                            timing = c(0.5, 1),delta1 = 0.1146049, delta0 = 0), 
                      z2 = z2Z))
})


testthat::test_that(
  desc = "Test : out of range maxinc", code = {
    expect_error(ssrCP(z1 = seq(-3, 3, 0.1), theta = NULL, maxinc = -2, 
                       overrun = 0, beta = 0.1, cpadj = c(0.5, 1 - 0.2),
                       x = gsDesign(k = 2, delta = 0.2), z2 = z2NC ))
})


testthat::test_that(
  desc = "Test : output validation n2, CP
           source : gsDesign_independent_code.R", code = {
    x <- gsDesign(k = 2, test.type = 2, n.fix = 800, timing = c(0.5, 1),
                  delta1 = 0.1146049, delta0 = 0, beta=0.2)
    z1=1.16

    a_res <- ssrCP(z1=1.16, theta = NULL, maxinc = 4, overrun = 0,
                   beta = x$beta, cpadj = c(.3, 1 - x$beta), x = x, z2 = z2NC)
    
    e_res <- validate_ssrCP(x,z1)
    
    expect_equal(a_res$dat$n2, e_res[[1]], 1e-6)
    expect_equal(a_res$dat$CP, e_res[[2]], 1e-6)
})
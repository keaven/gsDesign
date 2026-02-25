#-------------------------------------------------------------------------------
# condPower :is a supportive routine that also is interesting in its own right; 
# it computes conditional power of a combination test given an interim test statistic, 
# stage 2 sample size and combination test statistic.

# Expected Output Source is East 6.5
# chart of East 6.5 workbook are in  "benchmarks/condPower-01.jpg & benchmarks/condPower-02.jpg.

#-------------------------------------------------------------------------------


testthat::test_that(
  desc = "Test : output validation condPower 
          source : CP calculator in East 6.5", 
  code = {
    x <- gsDesign(k = 2, test.type = 1, n.fix = 800, timing = c(0.5, 1),
                  delta1 = 0.1146049, delta0 = 0)
    
   
    a_res <- condPower(z1 = 1.151764990571, n2 = 403, z2 = z2NC, theta = NULL, x = x)
    ## The tolerance is high (=1e-3)
    ## because such differences are expected from the different software
    ## where # East Sample Size computation uses rounded sample sizes
    expect_equal(a_res, 0.308644, 1e-03)
})


testthat::test_that(
  desc = "Test : output validation condPower
          source : CP calculator in East 6.5", 
  code = {
    x <- gsDesign(k = 2, test.type = 1, n.fix = 800, timing = c(0.5, 1),
                  delta1 = 0.1146049, delta0 = 0)
    a_res <- condPower(z1 = 1.151764990571, n2 = 403, z2 = z2NC,
                       theta = 0.057339132, x = x)
   
    ## The tolerance is high (=1e-3)
    ## because such differences are expected from the different software
    ## where # East Sample Size computation uses rounded sample sizes
    
    expect_equal(a_res, 0.308644, 1e-03)
})
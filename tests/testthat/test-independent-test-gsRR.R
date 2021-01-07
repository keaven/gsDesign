## The benchmark values have been obtained from the stopping boundaries

## chart in the East 6.5 workbook - benchmarks/gsqplot.cywx

# For comparing floating-point numbers, an exact match cannot be expected. 
# For such test cases, the tolerance is set to 1e-6 (= 0.000001), 
# a sufficiently low value
#-------------------------------------------------------------------------------

test_that(desc = "check standardised treatment effect",
          code = {
     x <- gsDesign(k = 2, test.type = 1, alpha = 0.025, beta = 0.1, 
                   delta1 = 0.3, sfu = sfLDOF)

    res_RR <- gsRR(z = x$upper$bound, i = 1:x$k, x = x)
    
    expect_lte(abs(res_RR[1] - exp(0.38709581)), 1e-6)
    expect_lte(abs(res_RR[2] - exp(0.18188158)), 1e-6)
})

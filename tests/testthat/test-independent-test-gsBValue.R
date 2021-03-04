
## The expected values for these test cases are obtained by independently coding 
## the formula for B-values given in the help file of gsBValue() function.

# For comparing floating-point numbers, an exact match cannot be expected. 
# For such test cases, the tolerance is set to 1e-6 (= 0.000001), 
# a sufficiently low value
#-------------------------------------------------------------------------------

test_that(desc = "check B-values",
  code = {
    x <- gsDesign(k = 2, test.type = 1, alpha = 0.025, beta = 0.1, 
                  delta1 = 0.3, sfu = sfLDOF)
    
    bvals <- gsBValue(z = x$upper$bound, i = 1:2, x = x) #actual output
    
    computedBVals <- x$upper$bound * sqrt(x$timing)  #expected output

    expect_lte(abs(bvals[1] - computedBVals[1]), 1e-6)
    expect_lte(abs(bvals[2] - computedBVals[2]), 1e-6)
})
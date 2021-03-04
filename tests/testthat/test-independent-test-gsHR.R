## To test gsHR() we use zn2hr() which is already tested.

# For comparing floating-point numbers, an exact match cannot be expected. 
# For such test cases, the tolerance is set to 1e-6 (= 0.000001), 
# a sufficiently low value
#-------------------------------------------------------------------------------

test_that(desc = "test: output validation",
          code = {
    xgs <- gsSurv(lambdaC = .2, hr = .5, eta = .1, T = 2, minfup = 1.5)
    obs <- gsHR(z = xgs$lower$bound, i = 1:3, x = xgs)
    
    expected <- zn2hr(z = xgs$lower$bound, n = as.vector(xgs$eDC + xgs$eDE))
    
    expect_lte(abs(obs[1] - expected[1]), 1e-6)
    expect_lte(abs(obs[2] - expected[2]), 1e-6)
    expect_lte(abs(obs[3] - expected[3]), 1e-6)
})


test_that(desc = "output validation",
          code = {
    xgs <- gsSurv(lambdaC = .2, hr = .5, eta = .1, T = 2, minfup = 1.5)
    obs <- gsHR(z = xgs$upper$bound, i = 1:3, x = xgs)
    
    expected <- zn2hr(z = xgs$upper$bound, n = as.vector(xgs$eDC + xgs$eDE))
    
    expect_lte(abs(obs[1] - expected[1]), 1e-6)
    expect_lte(abs(obs[2] - expected[2]), 1e-6)
    expect_lte(abs(obs[3] - expected[3]), 1e-6)
})

#----------------------------------
### Testing  gsSurv function
#----------------------------------

# Test gsSurv for group sequential design (vary accrual rate to obtain power)
# Benchmark values have been obtained from East 6.5- benhcmark/gsSurv.cywx
# The tolerance for these test cases has been set to 2 after agreeing upon the
# differences with Keaven. The differences are owing to slightly different variance
# estimates used in computations in different softwares.

testthat::test_that(
  desc = "Test gsSurv group sequential design (vary accrual rate to obtain power)
  Benchmark values have been obtained from East 6.5 : gsSurv.cywx",
  code = {
    x <- gsSurv(k = 4, sfl = sfPower, sflpar = .5, lambdaC = log(2) / 6, hr = .5,
                eta = log(2) / 40, gamma = 1, T = 36, minfup = 12)

    y <- x$eDC + x$eDE

    testthat::expect_lte(object = abs(y[1] - 29.1514896), expected = 2)

    testthat::expect_lte(object = abs(y[2] - 58.3029792), expected = 2)

    testthat::expect_lte(object = abs(y[3] - 87.4544688), expected = 2)

    testthat::expect_lte(object = abs(y[4] - 116.6059584), expected = 2)
  }
)


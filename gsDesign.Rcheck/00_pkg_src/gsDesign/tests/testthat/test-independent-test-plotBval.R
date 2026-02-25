#################################################
# Test plotBval function
#################################################
## For comparing floating-point numbers, an exact match cannot be expected.
## For such test cases,the tolerance is set to 1e-6 (= 0.000001), a sufficiently 
## low value.

x <- gsDesign(k = 5, test.type = 2, n.fix = 800)
pltobj <- plotBval(x)

test_that(
  desc = "check the sample size",
  code = {
    nplot <- subset(pltobj$data, Bound == "Upper")$N
    expect_lte(abs(nplot[1] - x$n.I[1]), 1e-6)
    expect_lte(abs(nplot[2] - x$n.I[2]), 1e-6)
    expect_lte(abs(nplot[3] - x$n.I[3]), 1e-6)
    expect_lte(abs(nplot[4] - x$n.I[4]), 1e-6)
    expect_lte(abs(nplot[5] - x$n.I[5]), 1e-6)
  }
)


BLobs <- subset(pltobj$data, Bound == "Lower")$Z
BLexp <- sqrt(x$timing) * x$lower$bound
test_that(
  desc = "check B value for lower boundary",
  code = {
    expect_lte(abs(BLobs[1] - BLexp[1]), 1e-6)
    expect_lte(abs(BLobs[2] - BLexp[2]), 1e-6)
    expect_lte(abs(BLobs[3] - BLexp[3]), 1e-6)
    expect_lte(abs(BLobs[4] - BLexp[4]), 1e-6)
    expect_lte(abs(BLobs[5] - BLexp[5]), 1e-6)
  }
)

BUobs <- subset(pltobj$data, Bound == "Upper")$Z
BUexp <- sqrt(x$timing) * x$upper$bound
test_that(
  desc = "check B value for Upper boundary",
  code = {
    expect_lte(abs(BUobs[1] - BUexp[1]), 1e-6)
    expect_lte(abs(BUobs[2] - BUexp[2]), 1e-6)
    expect_lte(abs(BUobs[3] - BUexp[3]), 1e-6)
    expect_lte(abs(BUobs[4] - BUexp[4]), 1e-6)
    expect_lte(abs(BUobs[5] - BUexp[5]), 1e-6)
  }
)

test_that("plotBval: plots are correctly rendered", {
  vdiffr::expect_doppelganger("plotBval", plotBval(x))
})

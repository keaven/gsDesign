source('../gsDesign_independent_code.R')
#################################################
# Test plotHR function
#################################################

## For comparing floating-point numbers, an exact match cannot be expected.
## For such test cases,the tolerance is set to 1e-6 (= 0.000001), a sufficiently 
## low value.

xgs <- gsSurv(lambdaC = 0.2, hr = 0.5, eta = 0.1, T = 2, minfup = 1.5)
pltobj <- plotHR(xgs)

nexp <- xgs$n.I
test_that(
  desc = "checking number of events",
  code = {
    nobs <- subset(pltobj$data, Bound == "Upper")$N
    expect_lte(abs(nobs[1] - nexp[1]), 1e-6)
    expect_lte(abs(nobs[2] - nexp[2]), 1e-6)
    expect_lte(abs(nobs[3] - nexp[3]), 1e-6)
  }
)


HRUobs <- subset(pltobj$data, Bound == "Upper")$Z
HRUexp <- zn2hr(z = xgs$upper$bound, n = nexp)
test_that(
  desc = "Check HR for upper boundary.",
  code = {
    expect_lte(abs(HRUobs[1] - HRUexp[1]), 1e-6)
    expect_lte(abs(HRUobs[2] - HRUexp[2]), 1e-6)
    expect_lte(abs(HRUobs[3] - HRUexp[3]), 1e-6)
  }
)

HRLobs <- subset(pltobj$data, Bound == "Lower")$Z
HRLexp <- zn2hr(z = xgs$lower$bound, n = nexp)
test_that(
  desc = "Check HR for Lower boundary.",
  code = {
    expect_lte(abs(HRLobs[1] - HRLexp[1]), 1e-6)
    expect_lte(abs(HRLobs[2] - HRLexp[2]), 1e-6)
    expect_lte(abs(HRLobs[3] - HRLexp[3]), 1e-6)
  }
)


test_that("Test plotHR graphs are correctly rendered ", {
  save_plot_obj <- save_gg_plot(plotHR(xgs))
  local_edition(3)
  expect_snapshot_file(save_plot_obj, "plot_plotHR_1.png")
})

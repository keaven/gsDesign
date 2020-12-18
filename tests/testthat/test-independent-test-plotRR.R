source('../benchmarks/gsDesign_independent_code.R')
#################################################
# Test plotRR function
#################################################

## For comparing floating-point numbers, an exact match cannot be expected.
## For such test cases,the tolerance is set to 1e-6 (= 0.000001), a sufficiently
## low value.


x <- gsDesign()
pltobj <- plotRR(x)


test_that(
  desc = "check the sample size",
  code = {
    nplot <- subset(pltobj$data, Bound == "Upper")$N
    expect_lte(abs(nplot[1] - x$n.I[1]), 1e-6)
    expect_lte(abs(nplot[2] - x$n.I[2]), 1e-6)
    expect_lte(abs(nplot[3] - x$n.I[3]), 1e-6)
  }
)


rlow <- subset(pltobj$data, Bound == "Lower")$Z
expectedlow <- exp(gsDelta(z = x$lower$bound, i = 1:x$k, x))
test_that(
  desc = "check relative risk (RR) value for lower boundary",
  code = {
    expect_lte(abs(rlow[1] - expectedlow[1]), 1e-6)
    expect_lte(abs(rlow[2] - expectedlow[2]), 1e-6)
    expect_lte(abs(rlow[3] - expectedlow[3]), 1e-6)
  }
)

rup <- subset(pltobj$data, Bound == "Upper")$Z
expectedup <- exp(gsDelta(z = x$upper$bound, i = 1:x$k, x))
test_that(
  desc = "check relative risk (RR) value for Upper boundary",
  code = {
    expect_lte(abs(rup[1] - expectedup[1]), 1e-6)
    expect_lte(abs(rup[2] - expectedup[2]), 1e-6)
    expect_lte(abs(rup[3] - expectedup[3]), 1e-6)
  }
)



test_that("Test plotRR graphs are correctly rendered ", {
  save_plot_obj <- save_gg_plot(plotRR(x))
  local_edition(3)
  expect_snapshot_file(save_plot_obj, "plot_plotRR_1.png")
})

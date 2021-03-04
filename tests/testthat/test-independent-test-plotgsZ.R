source('../gsDesign_independent_code.R')
#################################################
# Test plotgsZ function
#################################################
## For comparing floating-point numbers, an exact match cannot be expected.
## For such test cases,the tolerance is set to 1e-6 (= 0.000001), a sufficiently
## low value.


x <- gsDesign(k = 5, test.type = 2, n.fix = 800)

pltobj <- plotgsZ(x)

test_that(
  desc = "check the sample size",
  code = {
    nplot <- subset(pltobj$data, Bound == "Upper")$N
    expect_equal(object = nplot, expected = x$n.I)
    expect_lte(abs(nplot[1] - x$n.I[1]), 1e-6)
    expect_lte(abs(nplot[2] - x$n.I[2]), 1e-6)
    expect_lte(abs(nplot[3] - x$n.I[3]), 1e-6)
    expect_lte(abs(nplot[4] - x$n.I[4]), 1e-6)
    expect_lte(abs(nplot[5] - x$n.I[5]), 1e-6)
  }
)


zlow <- subset(pltobj$data, Bound == "Lower")$Z
expectedlowb <- x$lower$bound

test_that(
  desc = "check Z values for lower boundary",
  code = {
    expect_lte(abs(zlow[1] - expectedlowb[1]), 1e-6)
    expect_lte(abs(zlow[2] - expectedlowb[2]), 1e-6)
    expect_lte(abs(zlow[3] - expectedlowb[3]), 1e-6)
    expect_lte(abs(zlow[4] - expectedlowb[4]), 1e-6)
    expect_lte(abs(zlow[5] - expectedlowb[5]), 1e-6)
  }
)

zup <- subset(pltobj$data, Bound == "Upper")$Z
expectedupb <- x$upper$bound
test_that(
  desc = "check Z value for upper boundary",
  code = {
    expect_lte(abs(zup[1] - expectedupb[1]), 1e-6)
    expect_lte(abs(zup[2] - expectedupb[2]), 1e-6)
    expect_lte(abs(zup[3] - expectedupb[3]), 1e-6)
    expect_lte(abs(zup[4] - expectedupb[4]), 1e-6)
    expect_lte(abs(zup[5] - expectedupb[5]), 1e-6)
  }
)


test_that("Test plotgsZ graphs are correctly rendered ", {
  save_plot_obj <- save_gg_plot(plotgsZ(x))
  local_edition(3)
  expect_snapshot_file(save_plot_obj, "plot_plotgsz_1.png")
})

#-------------------------------------------------------------------------------
# expected CP Calculations done using East 6.5
# source file : tests/benchmarks/gsqplot.cywx

# The tolerance in these tests is higher (1e-4) than what is used in other
# comparisons because the CP computations in the different softwares are
# expected to be slightly different.
#-------------------------------------------------------------------------------


test_that(desc = "check plot data values,
                  source: CP Calculations done using East 6.5",
         code = {
    x <- gsDesign(k = 3, test.type = 1, alpha = 0.025, beta = 0.1,
                  delta1 = 0.3, sfu = sfLDOF)

    pltobj <- plotgsCP(x)
    plot_CP <- subset(pltobj$data, Bound == "Upper")$CP

    expect_lte(abs(plot_CP[1] - 0.999999983702667), 1e-4)
    expect_lte(abs(plot_CP[2] - 0.969550518393642), 1e-4)
})


test_that(desc = "check plot data values for sample size,",
          code = {
    x <- gsDesign(k = 3, test.type = 1, alpha = 0.025, beta = 0.1,
                  delta1 = 0.3, sfu = sfLDOF)
    pltobj <- plotgsCP(x)
    nplot <- subset(pltobj$data, Bound == "Upper")$N

    expect_lte(abs(nplot[1] - x$n.I[1]), 1e-6)
    expect_lte(abs(nplot[2] - x$n.I[2]), 1e-6)
})

test_that("plotgsCP: plots are correctly rendered, test.type = 1", {
  x <- gsDesign(
    k = 3, test.type = 1, alpha = 0.025, beta = 0.1,
    delta1 = 0.3, sfu = sfLDOF
  )

  vdiffr::expect_doppelganger(
    "plotgsCP test type 1",
    plotgsCP(x = x)
  )
})

test_that("plotgsCP: plots are correctly rendered, test.type = 2", {
  x <- gsDesign(
    k = 3, test.type = 2, alpha = 0.025, beta = 0.1,
    delta1 = 0.3, sfu = sfLDOF
  )

  vdiffr::expect_doppelganger(
    "plotgsCP test type 2",
    plotgsCP(x = x)
  )
})

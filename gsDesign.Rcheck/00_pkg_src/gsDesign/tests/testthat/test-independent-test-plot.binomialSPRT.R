testthat::test_that("plot.binomialSPRT: plots are correctly rendered", {
  plotBSPRT <- binomialSPRT(
    p0 = 0.05,
    p1 = 0.25,
    alpha = 0.1,
    beta = 0.15,
    minn = 10,
    maxn = 35
  )

  vdiffr::expect_doppelganger(
    "binomial SPRT",
    plot.binomialSPRT(plotBSPRT)
  )
})

testthat::test_that("plot.binomialSPRT: plots are correctly rendered, plottype = 1", {
  plotBSPRT <- binomialSPRT(
    p0 = 0.05,
    p1 = 0.25,
    alpha = 0.1,
    beta = 0.15,
    minn = 10,
    maxn = 35
  )

  vdiffr::expect_doppelganger(
    "binomial SPRT plottype 1",
    plot.binomialSPRT(plotBSPRT, plottype = 1)
  )
})

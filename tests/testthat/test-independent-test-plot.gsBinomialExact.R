testthat::test_that("plot.gsBinomialExact: plots are correctly rendered, plottype = 1", {
  x <- gsBinomialExact(
    k = 3,
    theta = c(0.1, 0.2),
    n.I = c(36, 71, 107),
    a = c(2, 9, 17),
    b = c(13, 15, 18)
  )

  vdiffr::expect_doppelganger(
    "plottype 1",
    plot.gsBinomialExact(x, plottype = 1)
  )
})

testthat::test_that("plot.gsBinomialExact: plots are correctly rendered, plottype = 2", {
  x <- gsBinomialExact(
    k = 3,
    theta = c(0.1, 0.2),
    n.I = c(36, 71, 107),
    a = c(2, 9, 17),
    b = c(13, 15, 18)
  )

  vdiffr::expect_doppelganger(
    "plottype 2",
    plot.gsBinomialExact(x, plottype = 2)
  )
})

testthat::test_that("plot.gsBinomialExact: plots are correctly rendered, plottype = 6", {
  x <- gsBinomialExact(
    k = 3,
    theta = c(0.1, 0.2),
    n.I = c(36, 71, 107),
    a = c(2, 9, 17),
    b = c(13, 15, 18)
  )

  vdiffr::expect_doppelganger(
    "plottype 6",
    plot.gsBinomialExact(x, plottype = 6)
  )
})

testthat::test_that("plot.gsBinomialExact: plots are correctly rendered, plottype = 3", {
  x <- gsBinomialExact(
    k = 3,
    theta = c(0.1, 0.2),
    n.I = c(36, 71, 107),
    a = c(2, 9, 17),
    b = c(13, 15, 18)
  )

  vdiffr::expect_doppelganger(
    "plottype 3",
    plot.gsBinomialExact(x, plottype = 3)
  )
})

testthat::test_that("plot.gsBinomialExact: plots are correctly rendered, for plottype set to default", {
  x <- gsBinomialExact(
    k = 3,
    theta = c(0.1, 0.2),
    n.I = c(36, 71, 107),
    a = c(2, 9, 17),
    b = c(13, 15, 18)
  )

  vdiffr::expect_doppelganger(
    "plottype default",
    plot.gsBinomialExact(x)
  )
})

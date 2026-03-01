test_that("plot.gsDesign: plots are correctly rendered for plottype 1 and base set to TRUE", {
  x <- gsDesign(k = 5, test.type = 2, n.fix = 100)

  vdiffr::expect_doppelganger(
    "plottype 1 base TRUE",
    capture.output(plot.gsDesign(x, plottype = 1, base = TRUE))
  )
})

test_that("plot.gsDesign: plots are correctly rendered for plottype 1 and base set to FALSE", {
  x <- gsDesign(k = 5, test.type = 2, n.fix = 100)

  vdiffr::expect_doppelganger(
    "plottype 1 base FALSE",
    plot.gsDesign(x, plottype = 1, base = FALSE)
  )
})

test_that("plot.gsDesign: plots are correctly rendered for plottype = power and base set to FALSE", {
  x <- gsDesign(k = 5, test.type = 2, n.fix = 100)

  vdiffr::expect_doppelganger(
    "plottype power base FALSE",
    plot.gsDesign(x, plottype = "power", base = FALSE)
  )
})

test_that("plot.gsDesign: plots are correctly rendered for plottype 2 and base set to TRUE", {
  x <- gsDesign(k = 5, test.type = 2, n.fix = 100)

  vdiffr::expect_doppelganger(
    "plottype 2 base TRUE",
    capture.output(plot.gsDesign(x, plottype = 2, base = TRUE))
  )
})

test_that("plot.gsDesign: plots are correctly rendered for plottype 3 and base set to TRUE", {
  x <- gsDesign(k = 5, test.type = 2, n.fix = 100)

  vdiffr::expect_doppelganger(
    "plottype 3 base TRUE",
    capture.output(plot.gsDesign(x, plottype = 3, base = TRUE))
  )
})

test_that("plot.gsDesign: graphs are correctly rendered for plottype 4 and base set to FALSE", {
  x <- gsDesign(k = 5, test.type = 2, n.fix = 100)

  vdiffr::expect_doppelganger(
    "plottype 4 base FALSE",
    plot.gsDesign(x, plottype = 4, base = FALSE)
  )
})

test_that("plot.gsDesign: plots are correctly rendered for plottype 4 and base set to TRUE", {
  x <- gsDesign(k = 5, test.type = 2, n.fix = 100)

  vdiffr::expect_doppelganger(
    "plottype 4 base TRUE",
    capture.output(plot.gsDesign(x, plottype = 4, base = TRUE))
  )
})

test_that("plot.gsDesign: plots are correctly rendered for plottype 5 and base set to TRUE", {
  x <- gsDesign(k = 5, test.type = 2, n.fix = 100)

  vdiffr::expect_doppelganger(
    "plottype 5 base TRUE",
    capture.output(plot.gsDesign(x, plottype = 5, base = TRUE))
  )
})

test_that("plot.gsDesign: plots are correctly rendered for plottype 6 and base set to FALSE", {
  x <- gsDesign(k = 5, test.type = 2, n.fix = 100)

  vdiffr::expect_doppelganger(
    "plottype 6 base FALSE",
    plot.gsDesign(x, plottype = 6, base = FALSE)
  )
})

test_that("plot.gsDesign: plots are correctly rendered for plottype 6 and base set to TRUE", {
  x <- gsDesign(k = 5, test.type = 2, n.fix = 100)

  vdiffr::expect_doppelganger(
    "plottype 6 base TRUE",
    capture.output(plot.gsDesign(x, plottype = 6, base = TRUE))
  )
})

test_that("plot.gsDesign: plots are correctly rendered for plottype 7 and base set to TRUE", {
  x <- gsDesign(k = 5, test.type = 2, n.fix = 100)

  vdiffr::expect_doppelganger(
    "plottype 7 base TRUE",
    capture.output(plot.gsDesign(x, plottype = 7, base = TRUE))
  )
})

test_that("plot.gsDesign: plots are correctly rendered for gsSurv objects and base set to TRUE", {
  z <- gsSurv(
    k = 3, sfl = sfPower, sflpar = .5,
    lambdaC = log(2) / 6, hr = .5, eta = log(2) / 40,
    gamma = 1, T = 36, minfup = 12
  )

  vdiffr::expect_doppelganger(
    "gsSurv base TRUE",
    capture.output(plot.gsDesign(z, plottype = 2, base = TRUE))
  )
})

test_that("plot.gsDesign: plots are correctly rendered for gSurv objects and base set to FALSE", {
  z <- gsSurv(
    k = 3, sfl = sfPower, sflpar = .5,
    lambdaC = log(2) / 6, hr = .5, eta = log(2) / 40,
    gamma = 1, T = 36, minfup = 12
  )

  vdiffr::expect_doppelganger(
    "gsSurv base FALSE",
    plot.gsDesign(z, plottype = 2, base = FALSE)
  )
})

test_that("plot.gsDesign: plots are correctly rendered for test.type 1 and plottype 2", {
  y <- gsDesign(k = 5, test.type = 1, n.fix = 1)

  vdiffr::expect_doppelganger(
    "test type 1 plottype 2",
    capture.output(plot.gsDesign(y, plottype = 2, base = TRUE))
  )
})

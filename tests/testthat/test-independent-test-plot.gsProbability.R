x <- gsDesign(k = 5, test.type = 2, n.fix = 100)
y <- gsProbability(k = 5, theta = seq(0, .5, .025), x$n.I, x$lower$bound, x$upper$bound)

test_that("plot.gsProbability: plots are correctly rendered for plottype 1 and base set to TRUE", {
  vdiffr::expect_doppelganger(
    "plottype 1 base TRUE",
    capture.output(plot.gsProbability(y, plottype = 1, base = TRUE))
  )
})

test_that("plot.gsProbability: plots are correctly rendered for plottype 1 and base set to FALSE", {
  vdiffr::expect_doppelganger(
    "plottype 1 base FALSE",
    capture.output(plot.gsProbability(y, plottype = 1, base = FALSE))
  )
})

test_that("plot.gsProbability: plots are correctly rendered for plottype power and base set to FALSE", {
  vdiffr::expect_doppelganger(
    "plottype power base FALSE",
    capture.output(plot.gsProbability(y, plottype = "power", base = FALSE))
  )
})

test_that("plot.gsProbability: plots are correctly rendered for plottype 2 and base set to TRUE", {
  vdiffr::expect_doppelganger(
    "plottype 2 base TRUE",
    capture.output(plot.gsProbability(y, plottype = 2, base = TRUE))
  )
})

test_that("plot.gsProbability: plots are correctly rendered for plottype 4 and base set to FALSE", {
  vdiffr::expect_doppelganger(
    "plottype 4 base FALSE",
    capture.output(plot.gsProbability(y, plottype = 4, base = FALSE))
  )
})

test_that("plot.gsProbability: plots are correctly rendered for plottype 4 and base set to TRUE", {
  vdiffr::expect_doppelganger(
    "plottype 4 base TRUE",
    capture.output(plot.gsProbability(x, plottype = 4, base = TRUE))
  )
})

test_that("plot.gsProbability: plots are correctly rendered for plottype 6 and base set to FALSE", {
  vdiffr::expect_doppelganger(
    "plottype 6 base FALSE",
    capture.output(plot.gsProbability(y, plottype = 6, base = FALSE))
  )
})

test_that("plot.gsProbability: plots are correctly rendered for plottype 6 and base set to TRUE", {
  vdiffr::expect_doppelganger(
    "plottype 6 base TRUE",
    capture.output(plot.gsProbability(y, plottype = 6, base = TRUE))
  )
})

test_that("plot.gsProbability: plots are correctly rendered for plottype 7 and base set to TRUE", {
  vdiffr::expect_doppelganger(
    "plottype 7 base TRUE",
    capture.output(plot.gsProbability(y, plottype = 7, base = TRUE))
  )
})

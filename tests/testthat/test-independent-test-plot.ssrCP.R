testthat::test_that("plot.ssrCP: plots are correctly rendered (R < 4.6.0)", {
  local_edition(3)
  announce_snapshot_file("independent-test-plot.ssrCP/ssr-cp.svg")
  skip_unless_r("< 4.6.0")

  ssr_cp_des <- ssrCP(
    z1 = seq(-3, 3, 0.1), theta = NULL, maxinc = 2,
    overrun = 0, beta = 0.1, cpadj = c(0.5, 1 - 0.2),
    x = gsDesign(k = 2, delta = 0.2), z2 = z2NC
  )

  plot_ssr_cp <- function(x) {
    plot.ssrCP(
      x = x, z1ticks = NULL,
      mar = c(7, 4, 4, 4) + 0.1,
      ylab = "Adapted sample size", xlaboffset = -0.2, lty = 1, col = 1
    )
  }

  vdiffr::expect_doppelganger("ssr CP", plot_ssr_cp(ssr_cp_des))
})

# R 4.6.0 fixes plotmath subscript placement (tall subscripts were previously
# positioned too high), which changes text rendering and breaks vdiffr
# snapshots. Keep two expectations, one for R < 4.6.0 and one for R >= 4.6.0.
testthat::test_that("plot.ssrCP: plots are correctly rendered (R >= 4.6.0)", {
  local_edition(3)
  announce_snapshot_file("independent-test-plot.ssrCP/ssr-cp-r460plus.svg")
  skip_unless_r(">= 4.6.0")

  ssr_cp_des <- ssrCP(
    z1 = seq(-3, 3, 0.1), theta = NULL, maxinc = 2,
    overrun = 0, beta = 0.1, cpadj = c(0.5, 1 - 0.2),
    x = gsDesign(k = 2, delta = 0.2), z2 = z2NC
  )

  plot_ssr_cp <- function(x) {
    plot.ssrCP(
      x = x, z1ticks = NULL,
      mar = c(7, 4, 4, 4) + 0.1,
      ylab = "Adapted sample size", xlaboffset = -0.2, lty = 1, col = 1
    )
  }

  vdiffr::expect_doppelganger("ssr CP R460plus", plot_ssr_cp(ssr_cp_des))
})

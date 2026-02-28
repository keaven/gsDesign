testthat::test_that("plot.ssrCP: runs without error", {
  ssr_cp_des <- ssrCP(
    z1 = seq(-3, 3, 0.1), theta = NULL, maxinc = 2,
    overrun = 0, beta = 0.1, cpadj = c(0.5, 1 - 0.2),
    x = gsDesign(k = 2, delta = 0.2), z2 = z2NC
  )

  # Replaced vdiffr snapshot: base R math expressions (theta-hat) produce
  # sub-pixel SVG differences across R versions.
  expect_no_error(
    plot.ssrCP(
      x = ssr_cp_des, z1ticks = NULL,
      mar = c(7, 4, 4, 4) + 0.1,
      ylab = "Adapted sample size", xlaboffset = -0.2, lty = 1, col = 1
    )
  )
})

#----------------------
# plot.ssrCP
#---------------------

testthat::test_that("Test: plot.ssrCP graphs are correctly rendered ", {
  ssr.cp.des <- ssrCP(z1 = seq(-3, 3, 0.1), theta = NULL, maxinc = 2,
                      overrun = 0, beta = 0.1, cpadj = c(0.5, 1 - 0.2),
                      x = gsDesign(k = 2, delta = 0.2), z2 = z2NC)

  save_plot_obj <- save_gr_plot(plot.ssrCP(x = ssr.cp.des, z1ticks = NULL, 
                                       mar = c(7, 4, 4, 4) + 0.1,
    ylab = "Adapted sample size", xlaboffset = -0.2, lty = 1, col = 1))

  local_edition(3)
  expect_snapshot_file(save_plot_obj, "plot_ssrCP_1.png")
})

source('../benchmarks/gsDesign_independent_code.R')
# --------------------------------------------
# Test plot.binomialSPRT function
#----------------------------------------------

testthat::test_that(desc = "Test: plot.binomialSPRT graphs are correctly rendered ", 
                    code = {
  plotBSPRT <- binomialSPRT(
    p0 = 0.05,
    p1 = 0.25,
    alpha = 0.1,
    beta = 0.15,
    minn = 10,
    maxn = 35
  )

  save_plot_obj <- save_gg_plot(plot.binomialSPRT(plotBSPRT))
  
  local_edition(3)

  testthat::expect_snapshot_file(save_plot_obj, "plotbinomialSPRT.png")
})


testthat::test_that(desc = "Test: plot.binomialSPRT graphs are correctly rendered, 
                      plottype = 1 ", 
                    code = {
  plotBSPRT <- binomialSPRT(
    p0 = 0.05,
    p1 = 0.25,
    alpha = 0.1,
    beta = 0.15,
    minn = 10,
    maxn = 35
  )

  save_plot_obj <- save_gg_plot(plot.binomialSPRT(plotBSPRT, plottype = 1))
  
  local_edition(3)

  testthat::expect_snapshot_file(save_plot_obj, "plotbinomialSPRT_plottype_1.png")
})

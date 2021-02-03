source('../gsDesign_independent_code.R')
# --------------------------------------------
# Test plot.gsBinomialExact function
#----------------------------------------------

testthat::test_that(desc = "test: checking plot.gsBinomialExact graphs are 
                            correctly rendered, plottype=1", 
                    code = {
  plotBE_plottype_1 <- gsBinomialExact(
    k = 3,
    theta = c(0.1, 0.2),
    n.I = c(36, 71, 107),
    a = c(2, 9, 17),
    b = c(13, 15, 18)
  )

  save_plot_obj <- save_gg_plot(plot.gsBinomialExact(plotBE_plottype_1, plottype = 1))
  local_edition(3)

  testthat::expect_snapshot_file(save_plot_obj, "plotBinomialExact_1.png")
})


testthat::test_that(desc = "test: checking plot.gsBinomialExact graphs are 
                            correctly rendered, plottype = 2 ", 
                    code = {
  plotBE_plottype_2 <- gsBinomialExact(
    k = 3,
    theta = c(0.1, 0.2),
    n.I = c(36, 71, 107),
    a = c(2, 9, 17),
    b = c(13, 15, 18)
  )

  save_plot_obj <- save_gg_plot(plot.gsBinomialExact(plotBE_plottype_2, plottype = 2))
  local_edition(3)
  
  testthat::expect_snapshot_file(save_plot_obj, "plotBinomialExact_2.png")
})


testthat::test_that(desc = "test: checking plot.gsBinomialExact graphs are 
                            correctly rendered, plottype = 6", 
                    code = {
  plotBE_plottype_2 <- gsBinomialExact(
    k = 3,
    theta = c(0.1, 0.2),
    n.I = c(36, 71, 107),
    a = c(2, 9, 17),
    b = c(13, 15, 18)
  )

  save_plot_obj <- save_gg_plot(plot.gsBinomialExact(plotBE_plottype_2, plottype = 6))
  local_edition(3)
  
  testthat::expect_snapshot_file(save_plot_obj, "plotBinomialExact_6.png")
})


testthat::test_that(desc = "test: checking plot.gsBinomialExact graphs are 
                    correctly rendered, plottype = 3", 
                    code = {
  plotBE_plottype_2 <- gsBinomialExact(
    k = 3,
    theta = c(0.1, 0.2),
    n.I = c(36, 71, 107),
    a = c(2, 9, 17),
    b = c(13, 15, 18)
  )

  save_plot_obj <- save_gg_plot(plot.gsBinomialExact(plotBE_plottype_2, plottype = 3))
  local_edition(3)
  
  testthat::expect_snapshot_file(save_plot_obj, "plotBinomialExact_3.png")
})



testthat::test_that(desc = "test: checking plot.gsBinomialExact graphs are 
                            correctly rendered, for plottype set to default", 
                    code = {
  plot_BE <- gsBinomialExact(
    k = 3,
    theta = c(0.1, 0.2),
    n.I = c(36, 71, 107),
    a = c(2, 9, 17),
    b = c(13, 15, 18)
  )

  save_plot_obj <- save_gg_plot(plot.gsBinomialExact(plot_BE))
  local_edition(3)
  
  testthat::expect_snapshot_file(save_plot_obj, "plotBinomialExact.png")
})
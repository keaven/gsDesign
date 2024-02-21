# --------------------------------------------
# Test plot.gsProbability function
## save_gg_plot() is used for storing plots created using ggplot2 package,
## whereas save_gr_plot() is used with plots created using graphics package.
#----------------------------------------------

x <- gsDesign(k = 5, test.type = 2, n.fix = 100)

y <- gsProbability(k = 5, theta = seq(0, .5, .025), x$n.I, 
                   x$lower$bound, x$upper$bound)


test_that("Test plotgsProbability graphs are correctly rendered for plottype 1 and base R plotting package set to TRUE ", {
  local_edition(3)
  save_plot_obj <- save_gr_plot(plot.gsProbability(y, plottype = 1, base = TRUE))
  expect_snapshot_file(save_plot_obj, "plot_plotgsdp_1.png")
})


test_that("Test plot gsProbability graphs are correctly rendered for plottype 1 and base R plotting package set to FALSE", {
  save_plot_obj <- save_gg_plot(plot.gsProbability(y, plottype = 1, base = FALSE))

  local_edition(3)
  expect_snapshot_file(save_plot_obj, "plot_plotgsdp_2.png")
})


test_that("Test plot gsProbability graphs are correctly rendered for plottype power and base R plotting package set to FALSE", {
  save_plot_obj <- save_gg_plot(plot.gsProbability(y, plottype = "power", base = FALSE))

  local_edition(3)
  expect_snapshot_file(save_plot_obj, "plot_plotgsdp_3.png")
})


test_that("Test plot gsProbability graphs are correctly rendered for plottype 2 and base R plotting package set to TRUE", {
  local_edition(3)
  save_plot_obj <- save_gr_plot(plot.gsProbability(y, plottype = 2, base = TRUE))
  expect_snapshot_file(save_plot_obj, "plot_plotgsdp_4.png")
})


test_that("Test plot gsProbability graphs are correctly rendered for plottype 4 and base R plotting package set to FALSE", {
  save_plot_obj <- save_gg_plot(plot.gsProbability(y, plottype = 4, base = FALSE))
  local_edition(3)
  expect_snapshot_file(save_plot_obj, "plot_plotgsds_6.png")
})

test_that("Test plot gsProbability graphs are correctly rendered for plottype 4 and base R plotting package set to TRUE", {
  local_edition(3)
  save_plot_obj <- save_gr_plot(plot.gsProbability(x, plottype = 4, base = TRUE))
  expect_snapshot_file(save_plot_obj, "plot_plotgsds_7.png")
})


test_that("Test plot gsProbability graphs are correctly rendered for plottype 6 and base R plotting package set to FALSE", {
  save_plot_obj <- save_gg_plot(plot.gsProbability(y, plottype = 6, base = FALSE))
  local_edition(3)
  expect_snapshot_file(save_plot_obj, "plot_plotgsds_9.png")
})

test_that("Test gsProbability graphs are correctly rendered for plottype 6 and base R plotting package set to TRUE", {
  local_edition(3)
  save_plot_obj <- save_gr_plot(plot.gsProbability(y, plottype = 6, base = TRUE))
  expect_snapshot_file(save_plot_obj, "plot_plotgsdpa_1.png")
})

test_that("Test plotgsProbability graphs are correctly rendered for plottype 7 and base R plotting package set to TRUE", {
  local_edition(3)
  save_plot_obj <- save_gr_plot(plot.gsProbability(y, plottype = 7, base = TRUE))
  expect_snapshot_file(save_plot_obj, "plot_plotgsdpa_2.png")
})

source('../gsDesign_independent_code.R')
#-------------------------------------------------------------------------------
# hGraph : hGraph() plots a multiplicity graph defined by user inputs. The graph
#          can also be used with the **gMCPLite** package to evaluate a set of 
#          nominal p-values for the tests of the hypotheses in the graph
#-------------------------------------------------------------------------------

testthat::test_that("test : checking basic graph layout", {
  x <- hGraph() 
  save_plot_obj <- save_gg_plot(x)
  local_edition(3)
  expect_snapshot_file(save_plot_obj, "plot_hGraph_1.png")
})


testthat::test_that("test : checking note clockwise ordering", {
  x <- hGraph(5)
  save_plot_obj <- save_gg_plot(x)
  local_edition(3)
  expect_snapshot_file(save_plot_obj, "plot_hGraph_2.png")
})


testthat::test_that("test : Add colors (default is 3 gray shades)", {
  x <- hGraph(3, fill = 1:3)
  save_plot_obj <- save_gg_plot(x)
  local_edition(3)
  expect_snapshot_file(save_plot_obj, "plot_hGraph_3.png")
})


testthat::test_that("test : Use a hue palette ", {
  x <- hGraph(4, fill = factor(1:4), palette = scales::hue_pal(l = 75)(4))
  save_plot_obj <- save_gg_plot(x)
  local_edition(3)
  expect_snapshot_file(save_plot_obj, "plot_hGraph_4.png")
})


# different alpha allocation, hypothesis names and transitions
testthat::test_that("test: different alpha allocation, hypothesis names and transitions", {
  alphaHypotheses <- c(.005, .007, .013)
  nameHypotheses <- c("ORR", "PFS", "OS")
  m <- matrix(c(
    0, 1, 0,
    0, 0, 1,
    1, 0, 0
  ), nrow = 3, byrow = TRUE)
  x <- hGraph(3, alphaHypotheses = alphaHypotheses, nameHypotheses = nameHypotheses, m = m)
  save_plot_obj <- save_gg_plot(x)
  local_edition(3)
  expect_snapshot_file(save_plot_obj, "plot_hGraph_5.png")
})


# Custom position and size of ellipses, change text to multi-line text
# Adjust box width
# add legend in middle of plot
testthat::test_that("test: Custom position and size of ellipses, change text to multi-line text", {
  cbPalette <- c(
    "#999999", "#E69F00", "#56B4E9", "#009E73",
    "#F0E442", "#0072B2", "#D55E00", "#CC79A7")
  x <- hGraph(3,
    x = sqrt(0:2), y = c(1, 3, 1.5), size = 6, halfWid = .3,
    halfHgt = .3, trhw = 0.6,
    palette = cbPalette[2:4], fill = c(1, 2, 2),
    legend.position = c(.95, .45), legend.name = "Legend:",
    labels = c("Group 1", "Group 2"),
    nameHypotheses = c("H1:\n Long name", "H2:\n Longer name", "H3:\n Longest name"))
  
  save_plot_obj <- save_gg_plot(x)
  local_edition(3)
  expect_snapshot_file(save_plot_obj, "plot_hGraph_6.png")
})


testthat::test_that("test: number of digits to show for alphaHypotheses", {
    x <- hGraph(nHypotheses = 3, size = 5, halfWid = 1.25, trhw = 0.25,
               radianStart = pi/2, offset = pi/20, arrowsize = .03, digits = 3)
    save_plot_obj <- save_gg_plot(x)
    local_edition(3)
    expect_snapshot_file(save_plot_obj, "plot_hGraph_7.png")
})

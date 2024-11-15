testthat::test_that("hGraph: Basic graph layout", {
  x <- hGraph()
  vdiffr::expect_doppelganger("basic layout", x)
})

testthat::test_that("hGraph: Note clockwise ordering", {
  x <- hGraph(5)
  vdiffr::expect_doppelganger("clockwise order", x)
})

testthat::test_that("hGraph: Add colors (default is 3 gray shades)", {
  x <- hGraph(3, fill = 1:3)
  vdiffr::expect_doppelganger("gray shades", x)
})

testthat::test_that("hGraph: Use a hue palette", {
  x <- hGraph(4, fill = factor(1:4), palette = scales::hue_pal(l = 75)(4))
  vdiffr::expect_doppelganger("hue palette", x)
})

testthat::test_that("hGraph: Different alpha allocation, hypotheses names, and transitions", {
  alphaHypotheses <- c(.005, .007, .013)
  nameHypotheses <- c("ORR", "PFS", "OS")
  m <- matrix(c(
    0, 1, 0,
    0, 0, 1,
    1, 0, 0
  ), nrow = 3, byrow = TRUE)
  x <- hGraph(3, alphaHypotheses = alphaHypotheses, nameHypotheses = nameHypotheses, m = m)

  vdiffr::expect_doppelganger("alpha allocation hypotheses names transitions", x)
})

# Custom position and size of ellipses, change text to multi-line text
# Adjust box width
# add legend in middle of plot
testthat::test_that("hGraph: Custom position and size of ellipses, change text to multi-line text", {
  cbPalette <- c(
    "#999999", "#E69F00", "#56B4E9", "#009E73",
    "#F0E442", "#0072B2", "#D55E00", "#CC79A7"
  )
  x <- hGraph(3,
    x = sqrt(0:2), y = c(1, 3, 1.5), size = 6, halfWid = .3,
    halfHgt = .3, trhw = 0.6,
    palette = cbPalette[2:4], fill = c(1, 2, 2),
    legend.position = c(.95, .45), legend.name = "Legend:",
    labels = c("Group 1", "Group 2"),
    nameHypotheses = c("H1:\n Long name", "H2:\n Longer name", "H3:\n Longest name")
  )

  vdiffr::expect_doppelganger("custom ellipses multiline", x)
})

testthat::test_that("hGraph: Number of digits to show for alphaHypotheses", {
  x <- hGraph(
    nHypotheses = 3, size = 5, halfWid = 1.25, trhw = 0.25,
    radianStart = pi / 2, offset = pi / 20, arrowsize = .03, digits = 3
  )

  vdiffr::expect_doppelganger("alpha digits", x)
})

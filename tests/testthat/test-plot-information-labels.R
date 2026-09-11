test_that("information annotations retain fractional values in every bound plot", {
  x <- gsDesign(n.fix = 10, endpoint = "info")
  for (type in c(1, 3, 4, 7)) {
    indices <- seq_len(if (type == 4) x$k - 1L else x$k)
    expected <- paste0("I=", round(x$n.I[indices], 2))
    p <- plot(x, plottype = type)
    labels <- unlist(lapply(ggplot2::ggplot_build(p)$data, function(d) d$label))
    expect_true(all(expected %in% labels))
    expect_false(any(grepl("^N=", labels)))
    expect_identical(p$scales$get_scales("x")$name, "Information")
    expect_identical(plot(x, plottype = type, xlab = "Custom")$scales$get_scales("x")$name, "Custom")
    svg <- svglite::stringSVG(plot(x, plottype = type, base = TRUE))
    for (label in expected) expect_match(svg, paste0(">", label, "</text>"), fixed = TRUE)
    expect_false(grepl(">N=", svg, fixed = TRUE))
    unlabeled <- plot(x, plottype = type, nlabel = FALSE)
    labels <- unlist(lapply(ggplot2::ggplot_build(unlabeled)$data, function(d) d$label))
    expect_false(any(grepl("^I=", labels)))
  }
})

test_that("relative information, sample sizes and events keep existing labels", {
  for (x in list(gsDesign(), gsDesign(n.fix = 100), gsSurv())) {
    for (type in c(1, 3, 4, 7)) {
      p <- plot(x, plottype = type)
      labels <- unlist(lapply(ggplot2::ggplot_build(p)$data, function(d) d$label))
      indices <- seq_len(if (type == 4) x$k - 1L else x$k)
      values <- if (x$n.fix == 1) round(x$n.I[indices], 3) else if (type == 4) {
        round(x$n.I[indices])
      } else ceiling(x$n.I[indices])
      expected <- paste0(if (x$n.fix == 1) "r=" else "N=", values)
      expect_true(all(expected %in% labels))
    }
  }
  x <- gsDesign(n.fix = 1, endpoint = "info")
  p <- plot(x)
  labels <- unlist(lapply(ggplot2::ggplot_build(p)$data, function(d) d$label))
  expect_true(all(paste0("I=", round(x$n.I, 2)) %in% labels))
})

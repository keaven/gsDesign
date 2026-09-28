test_that("power curves omit skipped boundaries without changing probabilities", {
  schedules <- list(
    list(testLower = c(TRUE, FALSE, FALSE)),
    list(testLower = c(FALSE, TRUE, TRUE)),
    list(testLower = c(TRUE, FALSE, TRUE)),
    list(testUpper = c(FALSE, TRUE, TRUE)),
    list(testUpper = c(TRUE, FALSE, TRUE)),
    list(testUpper = c(FALSE, TRUE, TRUE), testLower = c(TRUE, FALSE, FALSE))
  )
  for (schedule in schedules) {
    x <- do.call(gsDesign, c(list(k = 3, test.type = 4), schedule))
    before <- x
    theta <- c(0, x$delta / 2, x$delta)
    p <- plot(x, plottype = "power", theta = theta, xval = theta)
    all <- plot(x, plottype = "power", theta = theta, xval = theta, showSkipped = TRUE)
    expected <- all$data
    i <- as.integer(as.character(expected$Analysis))
    keep <- ifelse(expected$Bound == "Upper bound", x$testUpper[i], x$testLower[i])
    expect_equal(p$data, expected[keep, ])
    expect_identical(x, before)
    # Each displayed probability is cumulative, not a per-look increment.
    reference <- gsProbability(d = x, theta = theta)
    for (j in seq_along(theta)) {
      upper <- subset(p$data, Bound == "Upper bound" & thetaidx == j)
      lower <- subset(p$data, Bound == "1-Lower bound" & thetaidx == j)
      expect_equal(upper$Probability, cumsum(reference$upper$prob[, j])[x$testUpper])
      expect_equal(lower$Probability, (1 - cumsum(reference$lower$prob[, j]))[x$testLower])
    }
    expect_no_warning(ggplot2::ggplot_build(p))
  }
})

test_that("skipped power curves retain original analysis styles and offsets", {
  x <- gsDesign(testUpper = c(FALSE, TRUE, TRUE), testLower = c(TRUE, FALSE, FALSE))
  p <- plot(x, plottype = "power", offset = 4, lty = c(3, 2, 1))
  expect_equal(unique(as.character(p$data$Analysis[p$data$Bound == "Upper bound"])), c("6", "7"))
  expect_equal(unique(as.character(p$data$Analysis[p$data$Bound == "1-Lower bound"])), "5")
  built <- ggplot2::ggplot_build(p)
  expect_equal(unname(built$plot$scales$get_scales("linetype")$map(c("5", "6", "7"))), c(3, 2, 1))
  expect_equal(p$scales$get_scales("linetype")$name, "Future Analysis")
})

test_that("harm plots use the union of futility and harm testing schedules", {
  for (type in c(7, 8)) {
    x <- gsDesign(k = 4, test.type = type,
      testUpper = c(FALSE, TRUE, TRUE, TRUE),
      testLower = c(FALSE, TRUE, FALSE, TRUE),
      testHarm = c(TRUE, FALSE, FALSE, TRUE))
    theta <- c(0, x$delta)
    p <- plot(x, plottype = "power", theta = theta, xval = theta)
    ref <- gsProbability(d = x, theta = theta)
    for (j in seq_along(theta)) {
      combined <- subset(p$data, Bound == "1-(Futility or harm)" & thetaidx == j)
      harm <- subset(p$data, Bound == "1-Harm" & thetaidx == j)
      expect_equal(as.character(combined$Analysis), c("1", "2", "4"))
      expect_equal(as.character(harm$Analysis), c("1", "4"))
      expect_equal(combined$Probability,
        (1 - cumsum(ref$lower$prob[, j] + ref$harm$prob[, j]))[c(1, 2, 4)])
      expect_equal(harm$Probability, (1 - cumsum(ref$harm$prob[, j]))[c(1, 4)])
    }
  }
})

test_that("survival and plain probability plots respect absent bounds", {
  x <- gsSurv(testUpper = c(FALSE, TRUE, TRUE), testLower = c(TRUE, FALSE, FALSE))
  p <- plot(x, plottype = "power")
  expect_equal(unique(as.character(p$data$Analysis[p$data$Bound == "Upper bound"])), c("2", "3"))
  expect_equal(p$labels$x, "Hazard ratio")
  theta <- seq(0, x$delta, length.out = 5)
  z <- gsProbability(k = x$k, theta = theta, n.I = x$n.I, a = x$lower$bound, b = x$upper$bound)
  q <- plot(z)
  expect_equal(unique(as.character(q$data$Analysis[q$data$Bound == "1-Lower bound"])), "1")
  expect_equal(unique(as.character(q$data$Analysis[q$data$Bound == "Upper bound"])), c("2", "3"))
})

test_that("alternate power layout filters curves and their annotations", {
  x <- gsDesign(testUpper = c(FALSE, TRUE, TRUE), testLower = c(TRUE, FALSE, FALSE))
  p <- suppressMessages(plot(x, plottype = "power", outtype = 2))
  for (layer in p$layers) {
    d <- layer$data
    if (!is.data.frame(d) || !all(c("interim", "bound") %in% names(d))) next
    expect_false(any(d$bound == 1 & d$interim == 1))
    expect_false(any(d$bound == 2 & d$interim > 1))
  }
  expect_no_warning(ggplot2::ggplot_build(p))
  built <- ggplot2::ggplot_build(p)
  # The only curve in the initial layer is the lower complement, still red/dashed.
  expect_equal(unique(built$data[[1]]$colour), getColor(2))
  expect_equal(unique(built$data[[1]]$linetype), 2)
})

test_that("base graphics draw only active curves and retain full returned probabilities", {
  x <- gsDesign(testUpper = c(FALSE, TRUE, TRUE), testLower = c(TRUE, FALSE, FALSE))
  curves <- list()
  labels <- list()
  initial_type <- NULL
  testthat::local_mocked_bindings(
    plot = function(x, y, ..., type) { initial_type <<- type },
    .package = "base"
  )
  testthat::local_mocked_bindings(
    lines = function(x, y, ...) { curves[[length(curves) + 1L]] <<- y },
    axis = function(...) NULL,
    text = function(x, y, ...) { labels[[length(labels) + 1L]] <<- list(...) },
    strwidth = function(x, ...) rep(1, length(x)),
    legend = function(...) list(rect = list(left = 0, w = 1), text = list(y = 1)),
    .package = "graphics"
  )
  theta <- seq(0, x$delta, length.out = 5)
  result <- plot.gsDesign(x, plottype = "power", base = TRUE, theta = theta)
  ref <- gsProbability(d = x, theta = theta)
  expect_identical(initial_type, "n")
  expect_length(curves, 3)
  expect_equal(curves[[1]], 1 - ref$lower$prob[1, ])
  expect_equal(curves[[2]], colSums(ref$upper$prob[1:2, ]))
  expect_equal(curves[[3]], colSums(ref$upper$prob))
  expect_equal(result$upper$prob, ref$upper$prob)
  expect_equal(result$lower$prob, ref$lower$prob)
  expect_equal(labels[[2]][[2]], c("Interim 2", "Final", "Interim 1"))
  curves <- list()
  plot.gsDesign(x, plottype = "power", base = TRUE, theta = theta, showSkipped = TRUE)
  expect_identical(initial_type, "l")
  expect_length(curves, 5)
})

test_that("zero spending omits absent curves even when testing flags are TRUE", {
  x <- gsDesign(k = 4, test.type = 1, sfu = sfTruncated,
    sfupar = list(sf = sfHSD, param = -4, trange = c(.4, 1)))
  expect_true(x$testUpper[1])
  expect_false(is.finite(x$upper$bound[1]))
  p <- plot(x, plottype = "power")
  expect_equal(unique(as.character(p$data$Analysis)), c("2", "3", "4"))
  built <- ggplot2::ggplot_build(p)
  expect_equal(unname(built$plot$scales$get_scales("linetype")$map(c("2", "3", "4"))), c(3, 2, 1))
})

test_that("skipped-bound examples render with original analysis labels", {
  x <- gsDesign(testLower = c(TRUE, FALSE, FALSE))
  y <- gsDesign(testUpper = c(FALSE, TRUE, TRUE), testLower = c(TRUE, FALSE, FALSE))
  vdiffr::expect_doppelganger("futility only at analysis 1", plot(x, plottype = "power"))
  vdiffr::expect_doppelganger("mixed skipped efficacy and futility", plot(y, plottype = "power"))
})

test_that("alternate layout respects harm activity without hiding active futility", {
  x <- gsDesign(k = 4, test.type = 8,
    testUpper = c(FALSE, TRUE, TRUE, TRUE),
    testLower = c(FALSE, TRUE, FALSE, TRUE),
    testHarm = c(TRUE, FALSE, FALSE, TRUE))
  p <- suppressMessages(plot(x, plottype = "power", outtype = 2))
  final_bounds <- integer()
  for (layer in p$layers) {
    d <- layer$data
    if (!is.data.frame(d) || !all(c("interim", "bound") %in% names(d))) next
    expect_false(any(d$bound == 1 & d$interim == 1))
    expect_false(any(d$bound == 2 & d$interim == 3))
    expect_false(any(d$bound == 3 & d$interim %in% c(2, 3)))
    if (inherits(layer$geom, "GeomLine")) {
      final_bounds <- c(final_bounds, d$bound[d$interim == 4])
    }
  }
  expect_setequal(final_bounds, 1:3)
  expect_no_warning(ggplot2::ggplot_build(p))
})

test_that("showSkipped does not alter fully active designs and validates its input", {
  for (type in c(1, 2, 4, 8)) {
    x <- gsDesign(test.type = type)
    expect_equal(plot(x, plottype = "power")$data,
                 plot(x, plottype = "power", showSkipped = TRUE)$data)
  }
  for (bad in list(NA, 1, c(TRUE, FALSE), NULL)) {
    expect_error(plot(gsDesign(), plottype = "power", showSkipped = bad), "showSkipped")
  }
})

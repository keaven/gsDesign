test_that("minMedianFollowUp handles uniform enrollment", {
  x <- gsSurv(
    k = 2, gamma = 10, R = 12, T = 30, minfup = 18,
    lambdaC = log(2) / 6, hr = 0.7
  )

  expect_equal(minMedianFollowUp(x, c(6, 12, 18)), c(3, 6, 12))
  expect_equal(minMedianFollowUp(x), x$T - 6)
})

test_that("minMedianFollowUp handles piecewise and stratified enrollment", {
  x <- gsSurv(
    k = 2,
    gamma = matrix(c(1, 1, 3, 1), nrow = 2, byrow = TRUE),
    R = c(4, 4), T = 16, minfup = 8,
    lambdaC = matrix(log(2) / c(6, 9), nrow = 1),
    hr = 0.7
  )

  # At time 5, 12 subjects are enrolled and the sixth entered at time 3.
  # At full enrollment (time 8), the 12th entered at time 5.
  expect_equal(minMedianFollowUp(x, c(5, 8, 12)), c(2, 3, 7))
})

test_that("minMedianFollowUp uses enrollment to date", {
  x <- gsSurv(k = 2, gamma = 10, R = 12, T = 30, minfup = 18)

  expect_equal(minMedianFollowUp(x, c(0, 5, 6)), c(NA, 2.5, 3))
})

test_that("minMedianFollowUp is continuous when enrollment completes", {
  x <- gsSurv(k = 2, gamma = 10, R = 12, T = 30, minfup = 18)
  epsilon <- 1e-6

  observed <- minMedianFollowUp(x, 12 + c(-epsilon, 0, epsilon))
  expected <- c(6 - epsilon / 2, 6, 6 + epsilon)
  expect_equal(observed, expected, tolerance = 1e-12)
})

test_that("minMedianFollowUp validates inputs", {
  expect_error(minMedianFollowUp(list(), 1), "nSurv or gsSurv object")

  x <- gsSurv(k = 2, gamma = 10, R = 12, T = 30, minfup = 18)
  expect_error(minMedianFollowUp(x, -1), "finite, nonnegative")
  expect_error(minMedianFollowUp(x, NA_real_), "finite, nonnegative")
  expect_error(minMedianFollowUp(x, Inf), "finite, nonnegative")
  expect_error(minMedianFollowUp(x, character()), "finite, nonnegative")
})

test_that("minimum median follow-up supports nSurv objects", {
  x <- nSurv(gamma = 10, R = 12, T = 30, minfup = 18)

  expect_s3_class(x, "nSurv")
  expect_equal(minMedianFollowUp(x, c(6, 12, 18)), c(3, 6, 12))
  expect_equal(minMedianFollowUp(x), x$T - 6)

  p <- plotMinMedianFollowUp(x)
  expect_s3_class(p, "ggplot")
  expect_equal(p$layers[[2]]$data$calendarTime, x$T)
  expect_equal(
    p$layers[[2]]$data$minimumMedianFollowUp,
    minMedianFollowUp(x)
  )
})

test_that("plotMinMedianFollowUp plots the trajectory and analysis times", {
  x <- gsSurv(
    k = 2, gamma = 10, R = 12, T = 30, minfup = 18,
    lambdaC = log(2) / 6, hr = 0.7
  )

  p <- plotMinMedianFollowUp(x)
  expect_s3_class(p, "ggplot")
  expect_equal(length(p$layers), 2)
  expect_equal(p$layers[[2]]$data$calendarTime, x$T)
  expect_equal(
    p$layers[[2]]$data$minimumMedianFollowUp,
    minMedianFollowUp(x)
  )

  p_line <- plotMinMedianFollowUp(
    x,
    calendarTime = seq(0, 18, by = 1),
    showAnalysisTimes = FALSE
  )
  expect_s3_class(p_line, "ggplot")
  expect_equal(length(p_line$layers), 1)
  expect_equal(max(p_line$data$calendarTime), 18)
})

test_that("plotMinMedianFollowUp validates inputs", {
  x <- gsSurv(k = 2, gamma = 10, R = 12, T = 30, minfup = 18)

  expect_error(plotMinMedianFollowUp(list()), "nSurv or gsSurv object")
  expect_error(
    plotMinMedianFollowUp(x, showAnalysisTimes = NA),
    "TRUE or FALSE"
  )
  expect_error(
    plotMinMedianFollowUp(x, calendarTime = -1),
    "finite, nonnegative"
  )
})

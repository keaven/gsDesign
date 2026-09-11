test_that("follow-up uses all planned enrollment and inverts uniform enrollment", {
  times <- c(0, 3, 6, 8, 12, 18)
  expect_equal(medianFollowUp(T = times, gamma = 10, R = 12), pmax(0, times - 6), tolerance = 1e-8)
  for (target in c(0, .1, 3, 6, 20)) {
    cutoff <- minMedianFollowUp(target = target, gamma = 10, R = 12)
    expect_equal(cutoff, if (target == 0) 0 else target + 6, tolerance = 1e-8)
    expect_lte(abs(medianFollowUp(T = cutoff, gamma = 10, R = 12) - target), 1e-8)
  }
  eps <- 1e-6
  expect_equal(medianFollowUp(T = 12 + c(-eps, 0, eps), gamma = 1, R = 12),
               6 + c(-eps, 0, eps), tolerance = 1e-8)
})

test_that("enrollment pauses use the lower median and earliest inverse cutoff", {
  expect_equal(medianFollowUp(T = c(4, 6, 8, 10, 12), gamma = c(1, 0, 1), R = c(4, 4, 4)),
               c(0, 0, 0, 2, 4), tolerance = 1e-8)
  expect_equal(minMedianFollowUp(target = 4, gamma = c(1, 0, 1), R = c(4, 4, 4)), 12, tolerance = 1e-8)
  expect_equal(minMedianFollowUp(target = 3, gamma = c(0, 1, 0), R = c(4, 4, 4)), 9, tolerance = 1e-8)
  expect_equal(medianFollowUp(T = c(5, 8, 12), gamma = c(2, 4), R = c(4, 4)),
               c(0, 3, 7), tolerance = 1e-8)
})

test_that("dropout and event stopping match independent exponential calculations", {
  expect_equal(medianFollowUp(T = 20, gamma = 10, R = 4, eta = .2), log(2) / .2, tolerance = 1e-8)
  expect_equal(medianFollowUp(T = 20, gamma = 10, R = 4, eta = .1,
    lambdaC = .2, hr = 1, stopAtEvent = TRUE), log(2) / .3, tolerance = 1e-8)
  expected <- uniroot(function(u) (.25 * exp(-.1 * u) + .75 * exp(-.3 * u)) - .5,
                       c(0, 20), tol = 1e-11)$root
  expect_equal(medianFollowUp(T = 30, gamma = 10, R = 4, eta = .1, etaE = .3, ratio = 3),
               expected, tolerance = 1e-8)
  # Before enrollment completes, S(u) = (T-u)/12 * exp(-.1*u).
  cutoff <- minMedianFollowUp(target = 2, gamma = 10, R = 12, eta = .1)
  expect_equal(cutoff, 2 + 6 * exp(.2), tolerance = 1e-8)
  expect_error(minMedianFollowUp(target = 8, gamma = 10, R = 12, eta = .1), "unattainable")
  expect_equal(minMedianFollowUp(target = log(2) / .1, gamma = 10, R = 12, eta = .1),
               12 + log(2) / .1, tolerance = 1e-8)
  # Exactly half never drops out: a tiny positive tail must not round away.
  expect_equal(medianFollowUp(T = 101, gamma = 1, R = 1, eta = 0, etaE = 1), 100, tolerance = 1e-8)
  expect_equal(medianFollowUp(T = 1001, gamma = 1, R = 1, eta = 0, etaE = 1), 1000, tolerance = 1e-8)
})

test_that("piecewise participant-time hazards and flat hazard intervals work", {
  expected <- 2 + (log(2) - .2) / .3
  expect_equal(medianFollowUp(T = 20, gamma = c(1, 2, 1), R = c(1, 1, 1),
    eta = c(.1, .3), S = 2), expected, tolerance = 1e-8)
  expect_equal(medianFollowUp(T = 20, gamma = 1, R = 1, eta = c(log(2) / 2, 0), S = 2),
               2, tolerance = 1e-8)
  expect_error(minMedianFollowUp(target = 3, gamma = 1, R = 1,
    eta = c(log(2) / 2, 0), S = 2), "unattainable")
})

test_that("stratum and arm weights follow planned enrollment and allocation", {
  # Control enrollment weights: 1 and 3; experimental: 1 and 9.
  eta <- matrix(c(.1, .2), nrow = 1)
  etaE <- matrix(c(.3, .4), nrow = 1)
  expected <- uniroot(function(u) sum(c(1, 3, 1, 9) * exp(-c(.1, .2, .3, .4) * u)) / 14 - .5,
                       c(0, 20), tol = 1e-11)$root
  expect_equal(medianFollowUp(T = 30, gamma = matrix(c(1, 3), nrow = 1), R = 4,
    eta = eta, etaE = etaE, ratio = c(1, 3)), expected, tolerance = 1e-8)
})

test_that("design defaults, explicit inputs, NULL semantics and plots agree", {
  for (make in list(nSurv, gsSurv,
                    function(T, ...) gsSurvCalendar(calendarTime = c(12, 24, T), ...))) {
    x <- make(lambdaC = c(.08, .04), hr = .7, S = 6, eta = c(.01, .02),
              etaE = c(.02, .03), gamma = 10, R = 12, T = 30, minfup = 18)
    for (events in c(FALSE, TRUE)) {
      expected <- medianFollowUp(T = x$T, gamma = x$gamma, R = x$R,
        eta = x$etaC, etaE = x$etaE, lambdaC = x$lambdaC, hr = x$hr,
        S = x$S, ratio = x$ratio, stopAtEvent = events)
      expect_equal(medianFollowUp(x, stopAtEvent = events), expected)
      p <- plotMinMedianFollowUp(x, stopAtEvent = events)
      expect_equal(p$layers[[2]]$data$minimumMedianFollowUp, expected)
      expect_equal(p$layers[[2]]$data$calendarTime, x$T)
    }
    expect_equal(medianFollowUp(x, eta = 0, etaE = 0), pmax(0, x$T - 6), tolerance = 1e-8)
    expect_equal(medianFollowUp(x, etaE = NULL), medianFollowUp(x, etaE = x$etaC))
    expect_error(medianFollowUp(x, S = NULL), "incompatible interval")
    expect_equal(medianFollowUp(x, eta = .1, etaE = NULL, S = NULL),
                 medianFollowUp(T = x$T, gamma = x$gamma, R = x$R, eta = .1))
    expect_equal(medianFollowUp(x, lambdaC = NA, hr = NA), medianFollowUp(x))
  }
})

test_that("invalid inputs and old positional inverse calls fail clearly", {
  expect_error(medianFollowUp(list(), 1), "nSurv or gsSurv")
  expect_error(minMedianFollowUp(NULL, 12, gamma = 10, R = 12), "named target")
  expect_error(minMedianFollowUp(gamma = 10, R = 12, calendarTime = 12), "named target")
  for (bad in list(-1, NA_real_, Inf, numeric(), "1")) {
    expect_error(medianFollowUp(T = bad, gamma = 10, R = 12), "finite, nonnegative")
    expect_error(minMedianFollowUp(target = bad, gamma = 10, R = 12), "finite, nonnegative")
  }
  expect_error(medianFollowUp(T = 10, gamma = 1, R = 12, stopAtEvent = TRUE), "lambdaC and hr")
  expect_error(medianFollowUp(T = 10, gamma = 1, R = 12, stopAtEvent = NA), "TRUE or FALSE")
  expect_error(medianFollowUp(T = 10, gamma = 0, R = 12), "positive, finite planned enrollment")
  expect_error(medianFollowUp(T = 10, gamma = 1:3, R = c(4, 4)), "incompatible interval")
  expect_error(medianFollowUp(T = 10, gamma = 1, R = 12, eta = c(.1, .2)), "incompatible interval")
  expect_error(medianFollowUp(T = 10, gamma = 1, R = 12, eta = -.1), "nonnegative rates")
  expect_error(medianFollowUp(T = 10, gamma = 1, R = 12, tol = 0), "positive")
  expect_error(medianFollowUp(T = 10, gamma = matrix(1, 1, 2), R = 12,
    eta = matrix(.1, 1, 3)), "stratum dimensions")
})

test_that("plots retain calendar grids and time-unit controls", {
  x <- nSurv(gamma = 10, R = 12, T = 30, minfup = 18)
  p <- plotMinMedianFollowUp(x)
  expect_s3_class(p, "ggplot")
  expect_equal(p$scales$get_scales("x")$breaks, seq(0, 30, 6))
  expect_identical(p$labels$y, "Median follow-up (Months)")
  p <- plotMinMedianFollowUp(x, calendarTime = seq(0, 18), showAnalysisTimes = FALSE)
  expect_length(p$layers, 1)
  expect_equal(max(p$data$calendarTime), 18)
  p <- plotMinMedianFollowUp(x, timename = "Weeks")
  expect_null(p$scales$get_scales("x"))
  p <- plotMinMedianFollowUp(calendarTime = c(0, 1, 2), gamma = 1, R = 1, timename = "Years")
  expect_equal(p$scales$get_scales("x")$breaks, seq(0, 2, .5))
  expect_error(plotMinMedianFollowUp(x, showAnalysisTimes = NA), "TRUE or FALSE")
  expect_error(plotMinMedianFollowUp(x, timename = ""), "nonempty character")
})

test_that("harm defaults are 0.1 and Lan-DeMets Pocock only for harm designs", {
  for (tt in 7:8) {
    x <- gsDesign(test.type = tt)
    expect_equal(x$astar, .1)
    expect_identical(x$harm$sf, sfLDPocock)
    expect_equal(cumsum(x$harm$spend), sfLDPocock(.1, x$timing)$spend)
    explicit <- gsDesign(test.type = tt, astar = .2, sfharm = sfHSD, sfharmparam = -3)
    expect_equal(explicit$astar, .2)
    expect_identical(explicit$harm$sf, sfHSD)
    expect_equal(explicit$harm$param, -3)
  }
  for (tt in 5:6) {
    x <- gsDesign(test.type = tt)
    expect_equal(x$astar, 1 - x$alpha)
  }
})

test_that("harm calibration ignores futility but actual probabilities include it", {
  for (tt in 7:8) {
    for (fun in list(sfLDPocock, sfHSD)) {
      x <- gsDesign(
        test.type = tt, timing = c(.5, .75), sfharm = fun,
        testUpper = c(FALSE, TRUE, TRUE),
        testLower = c(TRUE, FALSE, FALSE)
      )
      # Independent lower bound construction by reflecting the upper bound solver.
      reference <- gsBound1(
        theta = 0, I = x$n.I, a = -x$upper$bound,
        probhi = x$harm$spend, tol = 1e-10, r = x$r
      )
      expect_equal(x$harm$bound, -reference$b, tolerance = 2e-6)
      ignored <- gsProbability(
        k = x$k, theta = 0, n.I = x$n.I,
        a = x$harm$bound, b = x$upper$bound
      )
      expect_equal(cumsum(ignored$lower$prob[, 1]), cumsum(x$harm$spend), tolerance = 1e-6)
      expect_lt(sum(x$harm$prob[, 1]), x$astar)
      # Direct bivariate integration of an IA2 harm stop after surviving futility.
      rho <- sqrt(x$n.I[1] / x$n.I[2])
      ia2 <- integrate(function(z) {
        dnorm(z) * pnorm((x$harm$bound[2] - rho * z) / sqrt(1 - rho^2))
      }, lower = x$lower$bound[1], upper = Inf, rel.tol = 1e-10)$value
      expect_equal(x$harm$prob[2, 1], ia2, tolerance = 1e-7)
      expect_equal(sum(x$upper$prob[, 2]), .9, tolerance = 2e-6)
      if (tt == 7) {
        expect_equal(sum(x$upper$prob[, 1]), .025, tolerance = 2e-6)
      } else {
        expect_equal(sum(x$falseposnb), .025, tolerance = 2e-6)
      }
      summary <- gsBoundSummary(x, digits = 8, exclude = NULL)
      rows <- summary$Value == "P(Cross) if delta=0"
      expect_equal(summary$Harm[rows], cumsum(x$harm$prob[, 1]), tolerance = 1e-7)
      expect_equal(summary$Harm[summary$Value == "Spending"], x$harm$spend, tolerance = 1e-7)
    }
  }
})

test_that("harm spending excludes skipped looks and handles all-active designs", {
  for (tt in 7:8) {
    for (harm in list(rep(TRUE, 4), c(FALSE, TRUE, FALSE, TRUE))) {
      x <- gsDesign(k = 4, test.type = tt, testHarm = harm)
      ignored <- gsProbability(k = 4, theta = 0, n.I = x$n.I,
                               a = x$harm$bound, b = x$upper$bound)
      expect_equal(cumsum(ignored$lower$prob[, 1]), cumsum(x$harm$spend), tolerance = 2e-6)
      expect_true(all(x$harm$prob[!harm, ] == 0))
      expect_true(all(x$harm$spend[!harm] == 0))
      expect_true(all(x$harm$bound[!harm] == -Inf))
      expect_true(all(x$harm$bound <= x$lower$bound))
    }
  }
})

test_that("interim harm results do not depend on final harm monitoring", {
  sparse_efficacy <- function(alpha, t, param) {
    spending <- sfLDOF(alpha - 1e-10, t, param)
    spending$spend[1:2] <- c(1e-10, 2e-10)
    spending
  }

  for (test_type in 7:8) {
    for (harm_spending in list(sfLDPocock, sfHSD)) {
      arguments <- list(
        k = 5, test.type = test_type, alpha = .02, beta = .32,
        astar = .1, timing = c(.42, .5, .64, .83),
        sfu = sparse_efficacy, sfupar = 1, sfl = sfHSD, sflpar = -10,
        sfharm = harm_spending, sfharmparam = -2, delta1 = log(.65),
        testUpper = c(FALSE, FALSE, TRUE, TRUE, TRUE),
        testLower = c(TRUE, TRUE, TRUE, TRUE, FALSE),
        tol = .Machine$double.eps^.25
      )
      reference <- do.call(gsDesign, arguments)
      arguments$testHarm <- c(TRUE, TRUE, TRUE, TRUE, FALSE)
      resized <- do.call(gsDesign, arguments)
      arguments$n.I <- reference$n.I
      fixed <- do.call(gsDesign, arguments)
      reference_summary <- gsBoundSummary(reference, deltaname = "HR", logdelta = TRUE)
      interim_rows <- seq_len(which(reference_summary$Value == "Z")[5] - 1)

      for (design in list(fixed, resized)) {
        expect_equal(design$n.I, reference$n.I, tolerance = 2e-6)
        expect_equal(design$harm$bound[1:4], reference$harm$bound[1:4], tolerance = 2e-6)
        expect_equal(design$harm$prob[1:4, ], reference$harm$prob[1:4, ], tolerance = 2e-6)
        summary <- gsBoundSummary(design, deltaname = "HR", logdelta = TRUE)
        expect_equal(summary$Harm[interim_rows], reference_summary$Harm[interim_rows])
        expect_identical(design$harm$bound[5], -Inf)
        expect_equal(design$harm$spend[5], 0)
        expect_true(all(design$harm$prob[5, ] == 0))
      }
    }
  }
})

test_that("survival harm tables do not depend on final harm monitoring", {
  for (harm_spending in list(sfLDPocock, sfHSD)) {
    arguments <- list(
      k = 5, test.type = 8, alpha = .02, beta = .32, astar = .1,
      timing = c(.42, .5, .64, .83), sfu = sfLDOF, sfupar = 1,
      sfl = sfHSD, sflpar = -10, sfharm = harm_spending, sfharmparam = -2,
      lambdaC = log(2) / 209, hr = .65, hr0 = 1, eta = -log(.98) / 12,
      gamma = c(5, 10, 15, 20), R = c(2, 2, 2, 25),
      T = NULL, minfup = NULL, ratio = 1,
      testUpper = c(FALSE, FALSE, TRUE, TRUE, TRUE),
      testLower = c(TRUE, TRUE, TRUE, TRUE, FALSE)
    )
    reference <- do.call(gsSurv, arguments)
    arguments$testHarm <- c(TRUE, TRUE, TRUE, TRUE, FALSE)
    revised <- do.call(gsSurv, arguments)
    reference_summary <- gsBoundSummary(reference)
    revised_summary <- gsBoundSummary(revised)
    interim_rows <- seq_len(which(reference_summary$Value == "Z")[5] - 1)

    expect_equal(revised$n.I, reference$n.I, tolerance = 2e-6)
    expect_equal(revised$harm$bound[1:4], reference$harm$bound[1:4], tolerance = 2e-6)
    expect_equal(revised$harm$prob[1:4, ], reference$harm$prob[1:4, ], tolerance = 2e-6)
    expect_equal(revised_summary$Harm[interim_rows], reference_summary$Harm[interim_rows])
  }
})

test_that("changing futility alone does not reallocate uncapped harm spending", {
  x <- gsDesign(test.type = 8, timing = c(.5, .75), testLower = c(TRUE, FALSE, FALSE))
  y <- x
  y$lower$bound[1] <- 1
  y <- gsHarmBoundUpdate(y)
  expect_equal(y$harm$bound, x$harm$bound, tolerance = 1e-6)
  expect_lt(sum(gsHarmProbability(theta = 0, d = y)$harm), sum(x$harm$prob[, 1]))
})

test_that("harm capping can underspend without exceeding its target", {
  for (tt in 7:8) {
    x <- gsDesign(test.type = tt, astar = .9, sfharm = sfHSD, sfharmparam = 10)
    ignored <- gsProbability(k = x$k, theta = 0, n.I = x$n.I,
                             a = x$harm$bound, b = x$upper$bound)
    expect_true(any(abs(x$harm$bound - x$lower$bound) < 1e-6))
    expect_true(all(x$harm$bound <= x$lower$bound))
    expect_true(all(cumsum(ignored$lower$prob[, 1]) <= cumsum(x$harm$spend) + 1e-6))
  }
})

test_that("harm defaults propagate through survival interfaces and preserve references", {
  for (fun in list(gsSurv, gsSurvCalendar)) {
    x <- fun(test.type = 8)
    expect_equal(x$astar, .1)
    expect_identical(x$harm$sf, sfLDPocock)
  }
  x <- gsSurv(test.type = 8, astar = .2, sfharm = sfHSD, sfharmparam = -3)
  y <- gsSurvPower(x)
  expect_equal(y$astar, x$astar)
  expect_identical(y$harm$sf, x$harm$sf)
  expect_equal(y$harm$param, x$harm$param)
  y <- gsSurvPower(k = 3, test.type = 8, plannedCalendarTime = c(12, 24, 36))
  expect_equal(y$astar, .1)
  expect_identical(y$harm$sf, sfLDPocock)
})

test_that("sparse-event type 6 vignette has valid exact non-binding harm bounds", {
  x <- gsSurvPower(
    k = 3, test.type = 6, alpha = .025, sided = 1,
    astar = .1, sfl = sfLDPocock, targetEvents = c(6, 23, 40),
    lambdaC = .001, hr = .8, hr0 = 1,
    gamma = 100, R = 16, ratio = 1, eta = 0
  )
  event_fraction <- x$n.I / tail(x$n.I, 1)
  exact <- toBinomialExact(x, usTime = event_fraction, lsTime = event_fraction)
  expect_equal(exact$n.I, c(6, 23, 40))
  expect_equal(exact$upper$bound, c(6, 16, 26))
  expect_null(x$harm)
  expect_equal(x$astar, .1)
  expect_true(all(cumsum(exact$upper$prob[, 1]) <= sfLDPocock(.1, event_fraction)$spend))
  efficacy <- gsBinomialExact(
    k = exact$k, theta = .5, n.I = exact$n.I,
    a = exact$lower$bound, b = exact$n.I + 1L
  )
  expect_lte(sum(efficacy$lower$prob), .025)
  hr <- c(1, 1.25, 1.5, 2)
  oc <- gsBinomialExact(
    k = exact$k, theta = hr / (1 + hr), n.I = exact$n.I,
    a = exact$lower$bound, b = exact$upper$bound
  )
  expect_equal(unname(colSums(oc$upper$prob)), c(.07780192, .21005548, .38753376, .70755946),
               tolerance = 1e-7)
  expect_true(all(diff(colSums(oc$upper$prob)) > 0))
  p_upper <- binom.test(20, 40, alternative = "less", conf.level = .95)$conf.int[2]
  expect_gt(p_upper / (1 - p_upper), 1.5)
})

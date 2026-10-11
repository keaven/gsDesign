survival_spending_cp <- function(x, theta = NULL) {
  if (is.null(theta)) theta <- x$lower$bound[1] / sqrt(x$n.I[1])
  sum(gsCP(x, i = 1, zi = x$lower$bound[1], theta = theta)$upper$prob)
}

expect_survival_spending_plan <- function(x) {
  expect_s3_class(x, "gsSurv")
  expect_equal(unname(rowSums(x$eDC + x$eDE)), x$n.I, tolerance = 2e-5)
  expect_equal(unname(rowSums(x$eNC + x$eNE)), x$N, tolerance = 2e-5)
  expect_true(all(diff(x$T) > 0))
  expect_true(all(is.finite(x$gamma)))
  expect_silent(gsBoundSummary(x, exclude = c("CP", "CP H1", "PP")))
}

test_that("CP calibration accepts the rounded survival design from issue 345", {
  x <- toInteger(gsSurv(
    timing = c(.5, .75), sfu = sfLDOF, eta = .01,
    gamma = c(2.5, 5, 7.5, 10), R = c(2, 2, 2, 6),
    testLower = c(TRUE, FALSE, FALSE)
  ))
  original <- x
  fit <- gsCPFutilitySpending(x, .7, i = 1)
  expect_identical(x, original)
  expect_survival_spending_plan(fit)
  expect_equal(survival_spending_cp(fit), .7, tolerance = 1e-4)
  expect_equal(fit$cpFutilitySpending$achieved_cp, survival_spending_cp(fit))
  expect_equal(sum(fit$upper$prob[, 2]), 1 - x$beta, tolerance = 2e-5)
  expect_identical(fit$testLower, x$testLower)
  expect_equal(fit$upper$sTime, x$upper$sTime)
  expect_equal(fit$lower$sTime, x$lower$sTime)
  expect_error(gsCPFutilitySpending(x, .7, i = 3), "interim analysis indices",
               class = "gsCPFutilitySpending_input_error")
  # The fitted design is itself a usable reference, without evaluating its call.
  again <- gsCPFutilitySpending(fit, .7)
  expect_equal(again$n.I, fit$n.I, tolerance = 2e-5)
})

test_that("calendar survival calibration keeps calendar and spending clocks", {
  for (clock in c("calendar", "information")) {
    x <- local({
      rates <- matrix(c(.1, .08, .07, .05), ncol = 2)
      gsSurvCalendar(calendarTime = c(12, 24, 36), spending = clock,
        lambdaC = rates, S = 6, eta = .005, etaE = .01,
        gamma = matrix(c(1, 2, 2, 3), ncol = 2), R = c(6, 6),
        ratio = 2, alpha = .05, sided = 2)
    })
    expect_survival_spending_plan(x)
    fit <- gsCPFutilitySpending(x, .3)
    expect_survival_spending_plan(fit)
    expect_equal(fit$T, x$T, tolerance = 1e-5)
    expect_equal(fit$timing, x$timing)
    expect_equal(fit$lower$sTime, x$lower$sTime)
    expect_equal(fit$upper$sTime, x$upper$sTime)
    expect_equal(fit$lambdaC, x$lambdaC)
    expect_equal(fit$etaE, x$etaE)
    expect_equal(fit$ratio, 2)
    expect_equal(fit$alpha, .025)
    expect_equal(survival_spending_cp(fit), .3, tolerance = 1e-4)
  }
})

test_that("survival calibration respects accrual and follow-up constraints", {
  for (constraint in c("accrual", "followup")) {
    x <- gsSurv(gamma = 26, R = 12, T = NULL,
                minfup = if (constraint == "accrual") 6 else NULL)
    fit <- gsCPFutilitySpending(x, .3)
    expect_survival_spending_plan(fit)
    expect_equal(unname(fit$gamma), unname(x$gamma))
    expect_identical(fit$variable, x$variable)
    if (constraint == "accrual") expect_equal(fit$minfup, x$minfup)
    else expect_equal(fit$R, x$R)
    expect_equal(survival_spending_cp(fit), .3, tolerance = 1e-4)
  }
})

test_that("all probability calibrators return consistent survival objects", {
  for (kind in c("events", "calendar", "power")) {
    x <- switch(kind,
      events = gsSurv(k = 2, sflpar = 0),
      calendar = gsSurvCalendar(calendarTime = c(18, 36), sflpar = 0),
      power = gsSurvPower(gsSurv(k = 2, sflpar = 0)))
    prior <- list(z = c(0, x$delta / 2, x$delta), wgts = c(.1, .3, .6))
    pp <- gsPP(x, i = 1, zi = x$lower$bound[1], theta = prior$z, wgts = prior$wgts)
    cpos <- gsCPOS(1, x, prior$z, prior$wgts)
    pos <- gsPOS(x, prior$z, prior$wgts)
    fits <- list(
      pp = gsPPFutilitySpending(x, pp, prior = prior, control = list(start = 1)),
      cpos = gsCPOSFutilitySpending(x, cpos, prior = prior, control = list(start = 1)),
      pos = gsPOSFutilitySpending(x, pos, prior = prior, control = list(start = 1)),
      ca = gsCAFutilitySpending(x, cpos + .01, prior = prior),
      fixed = gsCPOSFutilitySpending(x, cpos + .01, prior = prior,
                                     mode = "fixed_information"))
    for (fit in fits) {
      expect_survival_spending_plan(fit)
      if (kind == "power") {
        expect_s3_class(fit, "gsSurvPower")
        expect_equal(fit$power, sum(fit$upper$prob[, 2]), tolerance = 1e-6)
      }
    }
    expect_equal(gsPP(fits$pp, i = 1, zi = fits$pp$lower$bound[1],
                       theta = prior$z, wgts = prior$wgts), pp, tolerance = 1e-4)
    expect_equal(gsCPOS(1, fits$cpos, prior$z, prior$wgts), cpos, tolerance = 1e-4)
    expect_equal(gsPOS(fits$pos, prior$z, prior$wgts), pos, tolerance = 1e-4)
    expect_equal(gsCPOS(1, fits$ca, prior$z, prior$wgts), cpos + .01, tolerance = 1e-4)
    for (fit in fits[c("ca", "fixed")]) {
      expect_identical(fit$n.I, x$n.I)
      expect_identical(fit$T, x$T)
      expect_identical(fit$gamma, x$gamma)
      expect_identical(fit$upper$bound, x$upper$bound)
      expect_gt(fit$beta, x$beta)
    }
  }
})

test_that("gsSurvPower calibration uses the evaluated alternative and power", {
  x <- gsSurvPower(gsSurv(), hr = .7, hr1 = .6,
                   plannedCalendarTime = c(10, 14, 20), spending = "calendar")
  fit <- gsCPFutilitySpending(x, .3, theta = x$theta[2])
  expect_survival_spending_plan(fit)
  expect_s3_class(fit, "gsSurvPower")
  expect_equal(fit$T, x$T)
  expect_equal(fit$R, x$R)
  expect_equal(fit$hr, x$hr)
  expect_equal(fit$hr1, x$hr)
  expect_equal(fit$power, x$power, tolerance = 2e-5)
  expect_equal(survival_spending_cp(fit, x$theta[2]), .3, tolerance = 1e-4)
  expect_equal(fit$lower$sTime, x$lower$sTime)
})

test_that("effect calibration supports survival HRs and harm boundaries", {
  for (kind in c("events", "calendar", "power")) {
    x <- switch(kind,
      events = gsSurv(),
      calendar = gsSurvCalendar(),
      power = gsSurvPower(gsSurv()))
    target <- gsHR(x$lower$bound[1], 1, x, ratio = x$ratio)
    fit <- gsEffectSpending(x, target, scale = "hr",
      effect = list(information = "events", ratio = x$ratio, hr0 = x$hr0, hr1 = x$hr),
      control = list(start = 0))
    expect_survival_spending_plan(fit)
    expect_equal(gsHR(fit$lower$bound[1], 1, fit, ratio = x$ratio), target,
                 tolerance = 1e-4)
    expect_equal(fit$effectSpending$targets$achieved_effect,
                 gsHR(fit$lower$bound[1], 1, fit, ratio = x$ratio))
    expect_error(gsEffectSpending(x, target, scale = "hr",
      effect = list(information = "events", ratio = 2, hr0 = x$hr0, hr1 = x$hr)),
      "inconsistent", class = "gsEffectSpending_input_error")
  }
  x <- gsSurv(test.type = 8, astar = .1, method = "Schoenfeld")
  fit <- gsCPFutilitySpending(x, .3)
  expect_survival_spending_plan(fit)
  expect_equal(fit$harm$param, x$harm$param)
  expect_equal(fit$testHarm, x$testHarm)
  expect_equal(survival_spending_cp(fit), .3, tolerance = 1e-4)
})

test_that("survival CP calibration preserves harm defaults and calibration", {
  for (type in c(7, 8)) {
    x <- gsSurv(test.type = type, timing = c(.5, .75), sfu = sfLDOF,
                testLower = c(TRUE, FALSE, FALSE))
    fit <- gsCPFutilitySpending(x, .3)
    expect_survival_spending_plan(fit)
    expect_equal(fit$astar, .1)
    expect_identical(fit$harm$sf, sfLDPocock)
    expect_identical(fit$testLower, x$testLower)
    expect_equal(survival_spending_cp(fit), .3, tolerance = 1e-4)
    harm_only <- gsProbability(k = fit$k, theta = 0, n.I = fit$n.I,
                              a = fit$harm$bound, b = fit$upper$bound)
    expect_equal(cumsum(harm_only$lower$prob[, 1]), cumsum(fit$harm$spend),
                 tolerance = 2e-5)
    expect_lte(sum(fit$harm$prob[, 1]), sum(fit$harm$spend) + 2e-5)
  }
})

test_that("multi-target and joint boundary survival fits retain their targets", {
  x <- gsSurvCalendar(sfl = sfLogistic, sflpar = c(0, 1), spending = "calendar")
  target <- vapply(1:2, function(i) sum(gsCP(x, i = i,
    zi = x$lower$bound[i], theta = x$lower$bound[i] / sqrt(x$n.I[i]))$upper$prob),
    numeric(1))
  fit <- gsCPFutilitySpending(x, target, i = 1:2,
                              control = list(start = c(-.1, 1.1)))
  expect_survival_spending_plan(fit)
  expect_lte(max(abs(fit$cpFutilitySpending$residual)), 1e-4)
  again <- gsCPFutilitySpending(fit, target, i = 1:2)
  expect_equal(again$T, x$T)
  expect_equal(again$timing, x$timing)

  x <- gsSurv(sfupar = 0, sflpar = 0)
  target <- gsHR(c(x$upper$bound[1], x$lower$bound[1]), c(1, 1), x)
  fit <- gsEffectSpending(x, target, i = c(1, 1),
    bound = c("efficacy", "futility"), scale = "hr",
    effect = list(information = "events", ratio = 1, hr0 = 1, hr1 = .6),
    control = list(start = list(efficacy = .1, futility = .1)))
  expect_survival_spending_plan(fit)
  expect_equal(gsHR(c(fit$upper$bound[1], fit$lower$bound[1]), c(1, 1), fit),
               target, tolerance = 1e-4)
})

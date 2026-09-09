test_that("natural effect targets validate boundary/analysis pairs", {
  x <- gsDesign(k = 3, test.type = 4, n.fix = 100, delta1 = .2)
  expect_equal(gsDesign:::.gsEffectTargets(x, c(.2, .05), c(1, 1),
                c("efficacy", "futility"))$i, c(1L, 1L))
  for (args in list(list(c(.1, .2), c(1, 1), "futility"),
                    list(.1, 3, "futility"), list(.1, 1, "harm"),
                    list(NA_real_, 1, "efficacy"))) {
    expect_error(do.call(gsDesign:::.gsEffectTargets, c(list(x), args)),
                 class = "gsEffectSpending_input_error")
  }
  x$testLower[1] <- FALSE
  expect_error(gsDesign:::.gsEffectTargets(x, .1, 1, "futility"), "active")
})

test_that("effect mappings use candidate information and natural ratio metadata", {
  x <- gsDesign(k = 3, test.type = 4, n.fix = 200, delta0 = .1, delta1 = .3)
  z <- x$lower$bound[1]
  effect <- gsDesign:::.gsEffectAtBound(x, 1, "futility")
  expect_equal(effect, .1 + z / sqrt(x$n.I[1]) * .2 / x$delta)
  y <- x
  y$n.I <- 4 * x$n.I
  expect_equal(gsDesign:::.gsEffectAtBound(y, 1, "futility"), .1 + (effect - .1) / 2)
  x$delta0 <- log(1.1)
  x$delta1 <- log(.7)
  expect_equal(gsDesign:::.gsEffectAtBound(x, 1, "efficacy", "rr"),
               gsRR(x$upper$bound[1], 1, x))
  expect_error(gsDesign:::.gsEffectAtBound(x, 1, "efficacy", "hr"),
               "HR metadata")
  x$n.fix <- 1
  expect_error(gsDesign:::.gsEffectAtBound(x, 1, "efficacy"), "metadata")
})

test_that("single-boundary effect calibration is feasible for all three slots", {
  x <- gsDesign(k = 3, test.type = 8,
                n.fix = nNormal(delta1 = .2, sd = 1), delta1 = .2,
                sfu = sfHSD, sfupar = 0, sflpar = 0,
                sfharm = sfHSD, sfharmparam = 0, astar = .05)
  original <- x
  for (boundary in c("efficacy", "futility", "harm")) {
    build <- function(par) gsDesign:::.gsEffectDesign(x,
      setNames(list(list(fun = sfHSD, param = par)), boundary))
    value <- function(d) gsDesign:::.gsEffectAtBound(d, 1, boundary)
    target <- value(build(1))
    parameter <- uniroot(function(par) value(build(par)) - target,
                         c(-1, 2), tol = 1e-7)$root
    fit <- build(parameter)
    expect_equal(value(fit), target, tolerance = 1e-7)
    expect_equal(parameter, 1, tolerance = 1e-4)
    expect_equal(sum(gsProbability(d = fit, theta = x$delta)$upper$prob),
                 1 - x$beta, tolerance = 2e-5)
    expect_equal(fit$timing, x$timing)
  }
  expect_identical(x, original)
})

test_that("joint candidate construction changes only requested spending slots", {
  x <- gsDesign(k = 3, test.type = 8, n.fix = 200, delta1 = .2)
  d <- gsDesign:::.gsEffectDesign(x, list(
    efficacy = list(fun = sfHSD, param = 1),
    futility = list(fun = sfPower, param = 2)))
  expect_equal(d$upper$param, 1)
  expect_equal(d$lower$param, 2)
  expect_identical(d$harm$sf, x$harm$sf)
  expect_equal(d$harm$param, x$harm$param)
  expect_equal(sum(d$upper$prob[, 2]), 1 - x$beta, tolerance = 2e-5)
})

test_that("public function jointly fits effects and replays the complete design", {
  x <- gsDesign(k = 3, test.type = 8, n.fix = 200, delta1 = .2,
                sfu = sfHSD, sfupar = 1, sflpar = 1, sfharmparam = 1)
  bound <- c("efficacy", "futility", "harm")
  target <- gsDesign:::.gsEffectAtBound(x, rep(1, 3), bound)
  fit <- gsEffectSpending(x, target, i = rep(1, 3), bound = bound,
    control = list(start = list(efficacy = 0, futility = 0, harm = 0)))
  expect_s3_class(fit, "gsEffectSpending")
  expect_lte(max(abs(fit$effectSpending$targets$residual)), 1e-4)
  replay <- do.call(gsDesign, fit$effectSpending$replay)
  expect_equal(gsDesign:::.gsEffectAtBound(replay, rep(1, 3), bound),
               target, tolerance = 1e-4)
  expect_equal(sum(gsProbability(d = replay, theta = x$delta)$upper$prob),
               1 - x$beta, tolerance = 2e-5)
  expect_equal(dim(fit$effectSpending$jacobian), c(3L, 3L))
})

test_that("public function supports two parameters and piecewise linear spending", {
  for (family in c("sfLogistic", "sfLinear")) {
    param <- if (family == "sfLinear") c(.4, .75, .2, .6) else c(0, 1)
    initial <- if (family == "sfLinear") c(.19, .59) else c(-.1, 1.1)
    x <- gsDesign(k = 3, test.type = 4, n.fix = 200, delta1 = .2,
                  timing = c(.4, .75), sfl = get(family), sflpar = param)
    target <- gsDelta(x$lower$bound[1:2], 1:2, x)
    fit <- gsEffectSpending(x, target, spending = family,
                            control = list(start = initial))
    expect_lte(max(abs(fit$effectSpending$targets$residual)), 1e-4)
    expect_equal(sum(fit$upper$prob[, 2]), .9, tolerance = 2e-5)
  }
})

test_that("HR fits use explicit events, allocation and direction", {
  for (hr1 in c(.7, 1.4)) {
    descriptor <- list(information = "events", ratio = 2, hr0 = 1.1, hr1 = hr1)
    delta <- abs(log(hr1 / 1.1)) * sqrt(2) / 3
    x <- gsDesign(k = 3, test.type = 4, delta = delta, sflpar = 1)
    z <- x$lower$bound[1]
    sign <- if (hr1 < 1.1) -1 else 1
    target <- 1.1 * exp(sign * z / sqrt(x$n.I[1] * 2 / 9))
    fit <- gsEffectSpending(x, target, scale = "hr", effect = descriptor,
                            control = list(start = 0))
    expect_equal(gsHR(fit$lower$bound[1], 1, fit, ratio = 2), target,
                 tolerance = 1e-4)
    expect_equal(fit$hr, hr1)
    bad <- descriptor
    bad$information <- "patients"
    expect_error(gsEffectSpending(x, target, scale = "hr", effect = bad),
                 class = "gsEffectSpending_input_error")
    bad <- descriptor
    bad$ratio <- 1
    expect_error(gsEffectSpending(x, target, scale = "hr", effect = bad),
                 "inconsistent")
  }
})

test_that("public effect validation and failed searches are explicit", {
  x <- gsDesign(k = 3, test.type = 4, n.fix = 200, delta1 = .2)
  expect_error(gsEffectSpending(x, -.1, scale = "rr"), "positive")
  expect_error(gsEffectSpending(x, 2, effect = list(endpoint = "risk_difference")),
               "Risk difference")
  expect_error(gsEffectSpending(x, .1, control = list(cp_tol = 1e-4)),
               "recognized")
  expect_error(gsEffectSpending(x, 10, control = list(start = 0, lower = -.01,
                                                     upper = .01)),
               class = "gsEffectSpending_convergence_error")
  x$delta0 <- log(1.1); x$delta1 <- log(.7)
  target <- gsRR(x$lower$bound[1], 1, x)
  fit <- gsEffectSpending(x, target, scale = "rr", control = list(start = 0))
  expect_equal(gsRR(fit$lower$bound[1], 1, fit), target, tolerance = 1e-4)
})

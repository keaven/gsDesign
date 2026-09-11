pp_at_futility <- function(x, i, prior) {
  vapply(i, function(j) gsPP(x, i = j, zi = x$lower$bound[j],
                            theta = prior$z, wgts = prior$wgts), numeric(1))
}

test_that("default-grid PP targets survive reconstruction and tighter tolerance", {
  x <- gsDesign(k = 3, test.type = 4, timing = c(.5, .75), sfu = sfLDOF,
                sfl = sfHSD, sflpar = 1, testLower = c(TRUE, FALSE, FALSE))
  prior <- normalGrid(mu = x$delta / 2, sigma = 10 / sqrt(x$n.fix))
  fit <- gsPPFutilitySpending(x, .3, i = 1, prior = prior,
                             control = list(pp_tol = 1e-6))
  expect_s3_class(fit, "gsPPFutilitySpending")
  expect_s3_class(fit, "gsDesign")
  expect_null(fit$cpFutilitySpending)
  expect_equal(fit$ppFutilitySpending$solver$pp_tol, 1e-6)
  expect_lte(abs(pp_at_futility(fit, 1, prior) - .3), 1e-6)
  expect_equal(sum(fit$ppFutilitySpending$prior$wgts), 1)
  expect_equal(fit$ppFutilitySpending$prior$z, prior$z)
  expect_equal(fit$call[[1]], quote(gsPPFutilitySpending))
  rebuilt <- gsDesign(k = 3, test.type = 4, timing = c(.5, .75), sfu = sfLDOF,
                      sfl = sfHSD, sflpar = fit$ppFutilitySpending$sflpar,
                      testLower = c(TRUE, FALSE, FALSE))
  expect_lte(abs(pp_at_futility(rebuilt, 1, prior) - .3), 1e-6)
  expect_equal(sum(rebuilt$upper$prob[, 2]), .9, tolerance = 2e-5)
  tab <- gsBoundSummary(rebuilt, prior = prior, exclude = "B-value", digits = 6)
  expect_equal(tab$Futility[tab$Value == "PP"][1], .3, tolerance = 1e-6)
  rounded <- suppressMessages(toInteger(fit))
  expect_equal(rounded$lower$param, fit$lower$param)
})

test_that("point priors reproduce specified-effect CP and scale invariant weights", {
  x <- gsDesign(k = 3, test.type = 4, timing = c(.4, .75), sflpar = -1)
  prior <- list(z = x$delta, wgts = 1)
  target <- pp_at_futility(x, 1, prior)
  cp <- gsCPFutilitySpending(x, target, i = 1, theta = x$delta,
                             control = list(start = 0))
  pp <- gsPPFutilitySpending(x, target, i = 1, prior = prior,
                             control = list(start = 0))
  expect_equal(pp$lower$param, cp$lower$param, tolerance = 1e-5)
  expect_equal(pp$n.I, cp$n.I, tolerance = 1e-5)
  prior$wgts <- 1e300
  scaled <- gsPPFutilitySpending(x, target, i = 1, prior = prior,
                                 control = list(start = 0))
  expect_equal(scaled$lower$param, pp$lower$param)
  zero_weight <- gsPPFutilitySpending(
    x, target, i = 1, prior = list(z = c(x$delta, 1e300), wgts = c(1, 0)),
    control = list(start = 0)
  )
  expect_equal(zero_weight$lower$param, pp$lower$param)
  expect_equal(gsDesign:::.gsPPFValidatePrior(list(z = 0:1, wgts = c(1e308, 1e308)))$wgts,
               c(.5, .5))
})

test_that("discrete priors support multiple targets and ordered output", {
  x <- gsDesign(k = 3, test.type = 4, timing = c(.4, .75),
                sfl = sfLogistic, sflpar = c(0, 1))
  prior <- list(z = c(0, x$delta / 2, x$delta), wgts = c(.1, .3, .6))
  targets <- pp_at_futility(x, 1:2, prior)
  fit <- gsPPFutilitySpending(x, rev(targets), i = 2:1, sfl = "sfLogistic",
                             prior = prior, control = list(start = c(-.1, 1.1)))
  expect_equal(fit$ppFutilitySpending$i, 1:2)
  expect_equal(fit$ppFutilitySpending$target_pp, targets)
  expect_lte(max(abs(pp_at_futility(fit, 1:2, prior) - targets)), 1e-4)
  expect_equal(fit$lower$param, c(0, 1), tolerance = 2e-3)
  expect_match(fit$ppFutilitySpending$solver$method, "latest-to-earliest")
  expect_length(fit$ppFutilitySpending$solver$backward_pp, 2)
})

test_that("piecewise-linear PP calibration supports three targets", {
  times <- c(.3, .5, .7)
  x <- gsDesign(k = 4, test.type = 4, timing = times, sfl = sfLinear,
                sflpar = c(times, .05, .25, .65))
  prior <- list(z = c(0, x$delta), wgts = c(.2, .8))
  targets <- pp_at_futility(x, 1:3, prior)
  fit <- gsPPFutilitySpending(x, targets, i = 1:3, sfl = sfLinear, prior = prior,
                             control = list(start = c(.045, .24, .64)))
  expect_lte(max(abs(pp_at_futility(fit, 1:3, prior) - targets)), 1e-4)
  expect_equal(fit$lower$param[1:3], times)
  p <- fit$ppFutilitySpending$free_parameters
  expect_true(all(diff(p) > 0) && all(p > 0 & p < 1))
})

test_that("PP calibration preserves supported design specifications", {
  for (type in c(3, 4, 7, 8)) {
    x <- gsDesign(k = 3, test.type = type, timing = c(.4, .75), sfu = sfLDOF,
                  sflpar = -1, testLower = c(TRUE, FALSE, TRUE),
                  sfharm = sfPower, sfharmparam = 2, astar = .1,
                  testHarm = c(TRUE, FALSE, TRUE))
    prior <- list(z = c(0, x$delta), wgts = c(.2, .8))
    fit <- gsPPFutilitySpending(x, pp_at_futility(x, 1, prior), i = 1, prior = prior)
    expect_equal(fit$timing, x$timing)
    expect_equal(fit$testLower, x$testLower)
    expect_equal(fit$upper$sf, x$upper$sf)
    expect_equal(sum(fit$upper$prob[, 2]), 1 - x$beta, tolerance = 2e-5)
    if (type > 6) {
      expect_equal(fit$harm$param, x$harm$param)
      expect_equal(fit$testHarm, x$testHarm)
    }
  }
})

test_that("invalid priors and controls raise PP-specific input errors", {
  x <- gsDesign(k = 3, test.type = 4)
  priors <- list(NULL, list(z = 0), list(z = NA, wgts = 1),
                 list(z = 0, wgts = -1), list(z = 0, wgts = 0),
                 list(z = 0:1, wgts = 1), list(z = 0, wgts = Inf),
                 list(z = matrix(0), wgts = 1), list(z = 1i, wgts = 1))
  for (prior in priors) {
    expect_error(gsPPFutilitySpending(x, .3, prior = prior),
                 class = "gsPPFutilitySpending_input_error")
  }
  expect_error(gsPPFutilitySpending(x, .3), "prior must be supplied",
               class = "gsPPFutilitySpending_input_error")
  prior <- list(z = x$delta, wgts = 1)
  for (ctl in list(list(cp_tol = 1e-6), list(pp_tol = 0), list(maxit = 0),
                   list(trace = NA), list(unknown = 1), list(pp_tol = .1))) {
    expect_error(gsPPFutilitySpending(x, .3, prior = prior, control = ctl),
                 class = "gsPPFutilitySpending_input_error")
  }
  expect_error(gsPPFutilitySpending(x, 1, prior = prior), "target_pp",
               class = "gsPPFutilitySpending_input_error")
  expect_error(gsPPFutilitySpending(x, c(.2, .3), sfl = sfHSD, prior = prior),
               class = "gsPPFutilitySpending_input_error")
})

test_that("failed PP searches report predictive targets and posterior failures", {
  x <- gsDesign(k = 3, test.type = 4)
  prior <- list(z = x$delta, wgts = 1)
  e <- expect_error(gsPPFutilitySpending(x, .99, prior = prior,
                                        control = list(start = -3.5, lower = -4, upper = -3)),
                    class = "gsPPFutilitySpending_infeasible_error")
  expect_match(conditionMessage(e), "Requested PP")
  expect_equal(e$target_pp, .99)
  expect_length(e$closest_pp, 1)
  expect_null(e$closest_cp)
  expect_error(gsPPFutilitySpending(x, .3, prior = list(z = 1e4, wgts = 1)),
               "posterior likelihood normalization", class = "gsPPFutilitySpending_infeasible_error")
  x2 <- gsDesign(k = 3, test.type = 4, sfl = sfLogistic, sflpar = c(0, 1))
  target <- pp_at_futility(x2, 1:2, prior)
  expect_error(gsPPFutilitySpending(x2, target, sfl = sfLogistic, prior = prior,
                                    control = list(start = c(-2, 3), maxit = 1,
                                                   backward = FALSE, pp_tol = 1e-8)),
               class = "gsPPFutilitySpending_convergence_error")
})

test_that("PP-targeted survival reconstruction uses the matching default prior", {
  reference <- gsSurv(k = 3, test.type = 4, timing = c(.5, .75), sfu = sfLDOF,
                      testLower = c(TRUE, FALSE, FALSE), ratio = 1)
  x <- gsDesign(k = 3, test.type = 4, timing = c(.5, .75), sfu = sfLDOF,
                n.fix = reference$n.fix, delta0 = reference$delta0, delta1 = reference$delta1,
                sfl = sfHSD, sflpar = 1, testLower = c(TRUE, FALSE, FALSE))
  prior <- normalGrid(mu = x$delta / 2, sigma = 10 / sqrt(x$n.fix))
  fit <- gsPPFutilitySpending(x, .3, prior = prior)
  surv <- gsSurv(k = 3, test.type = 4, timing = c(.5, .75), sfu = sfLDOF,
                 sfl = sfHSD, sflpar = fit$lower$param,
                 testLower = c(TRUE, FALSE, FALSE), ratio = 1)
  expect_equal(prior, normalGrid(mu = surv$delta / 2, sigma = 10 / sqrt(surv$n.fix)))
  expect_lte(abs(pp_at_futility(surv, 1, prior) - .3), 1e-4)
  expect_equal(sum(surv$upper$prob[, 2]), .9, tolerance = 2e-5)
  expect_error(gsPPFutilitySpending(reference, .3, prior = prior),
               class = "gsPPFutilitySpending_input_error")
})

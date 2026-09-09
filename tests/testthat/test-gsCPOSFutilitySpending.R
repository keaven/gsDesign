cpos_targets <- function(x, i, prior) {
  vapply(i, function(j) gsCPOS(i = j, x = x, theta = prior$z,
                              wgts = prior$wgts / sum(prior$wgts)), numeric(1))
}

test_that("conditional assurance fitting recovers parameters and preserves power", {
  for (type in c(3, 4)) {
    x <- gsDesign(k = 3, test.type = type, timing = c(.4, .75), sflpar = 1)
    prior <- list(z = c(0, x$delta), wgts = c(.2, .8))
    target <- cpos_targets(x, 1, prior)
    fit <- gsCPOSFutilitySpending(x, target, prior = prior,
                                  control = list(start = 0, cpos_tol = 1e-6))
    meta <- fit$cposFutilitySpending
    expect_s3_class(fit, "gsCPOSFutilitySpending")
    expect_null(fit$cpFutilitySpending)
    expect_equal(cpos_targets(fit, 1, prior), target, tolerance = 1e-6)
    expect_equal(fit$lower$param, 1, tolerance = 1e-3)
    expect_equal(sum(fit$upper$prob[, 2]), 1 - x$beta, tolerance = 2e-5)
    expect_equal(meta$joint_future_efficacy / meta$continuation_probability,
                 meta$achieved_cpos)
    expect_equal(meta$unconditional_pos, gsPOS(fit, prior$z, prior$wgts))
    expect_equal(meta$solver$cpos_tol, 1e-6)
    expect_equal(fit$call[[1]], quote(gsCPOSFutilitySpending))
    rebuilt <- gsDesign(k = 3, test.type = type, timing = c(.4, .75),
                        sflpar = meta$sflpar)
    expect_equal(cpos_targets(rebuilt, 1, prior), target, tolerance = 1e-6)
    # Earlier efficacy must be excluded from future success.
    expect_lt(meta$joint_future_efficacy, meta$unconditional_pos)
  }
})

test_that("multiple conditional assurance targets fit in analysis order", {
  x <- gsDesign(k = 3, test.type = 4, timing = c(.4, .75),
                sfl = sfLogistic, sflpar = c(0, 1))
  prior <- list(z = c(0, x$delta), wgts = c(.2, .8))
  targets <- cpos_targets(x, 1:2, prior)
  fit <- gsCPOSFutilitySpending(x, rev(targets), i = 2:1, sfl = sfLogistic,
                                prior = prior, control = list(start = c(-.1, 1.1)))
  expect_equal(fit$cposFutilitySpending$i, 1:2)
  expect_equal(fit$cposFutilitySpending$target_cpos, targets)
  expect_lte(max(abs(cpos_targets(fit, 1:2, prior) - targets)), 1e-4)
  expect_length(fit$cposFutilitySpending$solver$backward_cpos, 2)
})

test_that("piecewise linear conditional assurance supports three targets", {
  times <- c(.3, .5, .7)
  x <- gsDesign(k = 4, test.type = 4, timing = times, sfl = sfLinear,
                sflpar = c(times, .05, .25, .65))
  prior <- list(z = c(0, x$delta), wgts = c(.2, .8))
  target <- cpos_targets(x, 1:3, prior)
  fit <- gsCPOSFutilitySpending(x, target, sfl = sfLinear, prior = prior,
                                control = list(start = c(.045, .24, .64)))
  expect_lte(max(abs(cpos_targets(fit, 1:3, prior) - target)), 1e-4)
  expect_equal(fit$lower$param[1:3], times)
})

test_that("prior weights normalize and zero mass support is ignored", {
  x <- gsDesign(k = 3, test.type = 4)
  target <- cpos_targets(x, 1, list(z = x$delta, wgts = 1))
  fit <- gsCPOSFutilitySpending(x, target,
    prior = list(z = c(x$delta, 1e300), wgts = c(1e300, 0)))
  expect_equal(fit$cposFutilitySpending$prior$wgts, c(1, 0))
  expect_equal(fit$cposFutilitySpending$achieved_cpos, target)
  cp <- gsCP(x, i = 1, zi = x$lower$bound[1], theta = x$delta)
  expect_gt(abs(target - sum(cp$upper$prob)), .01)
})

test_that("CPOS inputs and controls use dedicated errors", {
  x <- gsDesign(k = 3, test.type = 4)
  prior <- list(z = x$delta, wgts = 1)
  expect_error(gsCPOSFutilitySpending(x, .8),
                class = "gsCPOSFutilitySpending_input_error")
  expect_error(gsCPOSFutilitySpending(x, .8, prior = list(z = 0, wgts = 0)),
                class = "gsCPOSFutilitySpending_input_error")
  for (control in list(list(cp_tol = 1e-5), list(pp_tol = 1e-5),
                       list(cpos_tol = 0), list(1), list(maxit = -1))) {
    expect_error(gsCPOSFutilitySpending(x, .8, prior = prior, control = control),
                  class = "gsCPOSFutilitySpending_input_error")
  }
  for (type in c(7, 8)) {
    harm <- gsDesign(k = 3, test.type = type)
    expect_error(gsCPOSFutilitySpending(harm, .8, prior = prior),
                  "harm-bound", class = "gsCPOSFutilitySpending_input_error")
  }
  expect_error(gsCPOSFutilitySpending(x, 1, prior = prior),
                "target_cpos", class = "gsCPOSFutilitySpending_input_error")
  expect_error(gsCPOSFutilitySpending(x, .01, prior = prior,
                control = list(start = 0, lower = -.01, upper = .01)),
                class = "gsCPOSFutilitySpending_error")
})

test_that("near-zero continuation is rejected explicitly", {
  x <- gsDesign(k = 2, test.type = 4)
  expect_error(gsDesign:::.gsCPOSFProbabilities(x, 1,
                 list(z = 1e4, wgts = 1)), "continuation probability")
})

test_that("conditional assurance agrees with independent bivariate integration", {
  skip_if_not_installed("mvtnorm")
  x <- gsDesign(k = 2, test.type = 4, timing = .5, r = 32)
  prior <- list(z = c(0, x$delta / 2, x$delta), wgts = c(.1, .3, .6))
  rho <- sqrt(x$n.I[1] / x$n.I[2])
  covariance <- matrix(c(1, rho, rho, 1), 2)
  continuation <- future <- numeric(3)
  for (h in seq_along(prior$z)) {
    mu <- prior$z[h] * sqrt(x$n.I)
    continuation[h] <- pnorm(x$upper$bound[1] - mu[1]) -
      pnorm(x$lower$bound[1] - mu[1])
    future[h] <- as.numeric(mvtnorm::pmvnorm(
      lower = c(x$lower$bound[1], x$upper$bound[2]),
      # Twelve standard deviations omit negligible normal tail mass.
      upper = c(x$upper$bound[1], mu[2] + 12), mean = mu, sigma = covariance,
      algorithm = mvtnorm::Miwa()
    ))
  }
  probabilities <- gsDesign:::.gsCPOSFProbabilities(x, 1, prior)
  expect_equal(probabilities$continuation, sum(continuation * prior$wgts),
               tolerance = 1e-6)
  expect_equal(probabilities$future_efficacy, sum(future * prior$wgts),
               tolerance = 1e-6)
  expect_equal(probabilities$conditional_assurance,
               sum(future * prior$wgts) / sum(continuation * prior$wgts),
               tolerance = 1e-6)
})

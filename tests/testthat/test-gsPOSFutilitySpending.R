test_that("POS calibration recovers spending and preserves frequentist power", {
  for (type in c(3, 4)) {
    x <- gsDesign(k = 3, test.type = type, sflpar = 1)
    prior <- list(z = c(0, x$delta / 2, x$delta), wgts = c(.1, .4, .5))
    target <- gsPOS(x, prior$z, prior$wgts)
    fit <- gsPOSFutilitySpending(x, target, prior = prior,
                                 control = list(start = 0, lower = 0, upper = 2,
                                                pos_tol = 1e-6))
    expect_s3_class(fit, "gsPOSFutilitySpending")
    expect_equal(gsPOS(fit, prior$z, prior$wgts), target, tolerance = 1e-6)
    expect_equal(fit$lower$param, 1, tolerance = 1e-3)
    expect_equal(sum(fit$upper$prob[, 2]), 1 - x$beta, tolerance = 2e-5)
    expect_null(fit$posFutilitySpending$i)
    expect_equal(fit$posFutilitySpending$solver$pos_tol, 1e-6)
    replay <- gsDesign(k = 3, test.type = type,
                       sflpar = fit$posFutilitySpending$sflpar)
    expect_equal(gsPOS(replay, prior$z, prior$wgts), target, tolerance = 1e-6)
    independent <- gsProbability(d = fit, theta = prior$z)
    expect_equal(sum(independent$upper$prob %*% prior$wgts), target,
                 tolerance = 1e-6)
    scaled <- gsPOSFutilitySpending(x, target,
      prior = list(z = prior$z, wgts = prior$wgts * 1e300))
    expect_equal(scaled$posFutilitySpending$prior$wgts, prior$wgts)
  }
})

test_that("POS rejects multiple constraints and underidentified families", {
  x <- gsDesign(k = 3, test.type = 4)
  prior <- list(z = x$delta / 2, wgts = 1)
  expect_error(gsPOSFutilitySpending(x, c(.5, .6), prior = prior),
                "scalar", class = "gsPOSFutilitySpending_input_error")
  expect_error(gsPOSFutilitySpending(x, .5, sfl = sfLogistic, prior = prior),
                class = "gsPOSFutilitySpending_input_error")
  expect_error(gsPOSFutilitySpending(x, .5, prior = prior,
                control = list(cpos_tol = 1e-5)),
                class = "gsPOSFutilitySpending_input_error")
  expect_error(gsPOSFutilitySpending(x, .5),
                class = "gsPOSFutilitySpending_input_error")
  expect_error(gsPOSFutilitySpending(x, 1, prior = prior),
                class = "gsPOSFutilitySpending_input_error")
})

test_that("point prior at H1 exposes the flat POS constraint", {
  x <- gsDesign(k = 3, test.type = 4)
  fit <- gsPOSFutilitySpending(x, 1 - x$beta,
                               prior = list(z = x$delta, wgts = 1),
                               control = list(start = 0))
  expect_equal(fit$lower$param, 0)
  expect_equal(fit$posFutilitySpending$achieved_pos, 1 - x$beta, tolerance = 2e-5)
})

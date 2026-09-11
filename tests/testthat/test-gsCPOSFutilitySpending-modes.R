test_that("one CPOS interface supports both constraints and legacy results", {
  x <- gsDesign(k = 2, test.type = 4, sflpar = 0)
  prior <- list(z = c(0, x$delta), wgts = c(.2, .8))
  target <- gsCPOS(1, x, prior$z, prior$wgts) + .015
  fixed <- gsCPOSFutilitySpending(x, target, prior = prior,
    mode = "fixed_information", control = list(cpos_tol = 1e-6))
  legacy <- gsCAFutilitySpending(x, target, prior = prior,
    control = list(ca_tol = 1e-6))
  powered <- gsCPOSFutilitySpending(x, target, prior = prior)
  expect_s3_class(fixed, "gsCPOSFutilitySpending")
  expect_identical(fixed$n.I, x$n.I)
  expect_identical(fixed$upper$bound, x$upper$bound)
  expect_equal(fixed$lower, legacy$lower)
  expect_equal(fixed$beta, legacy$beta)
  expect_gt(fixed$beta, x$beta)
  expect_equal(powered$beta, x$beta)
  expect_false(isTRUE(all.equal(powered$n.I, x$n.I)))
  for (fit in list(fixed, powered)) {
    expect_equal(gsCPOS(1, fit, prior$z, prior$wgts), target, tolerance = 1e-4)
    expect_equal(fit$cposFutilitySpending$achieved_beta, fit$beta)
    expect_equal(fit$cposFutilitySpending$achieved_type1, sum(fit$upper$prob[,1]))
  }
  expect_identical(fixed$cposFutilitySpending$mode, "fixed_information")
  expect_true(fixed$cposFutilitySpending$fixed_information)
  expect_identical(powered$cposFutilitySpending$mode, "preserve_power")
  expect_false(powered$cposFutilitySpending$fixed_information)
  expect_equal(fixed$cposFutilitySpending$solver$cpos_tol, 1e-6)
  replay <- gsCPOSFutilitySpending(x, target, prior = prior,
    mode = "fixed_information",
    control = list(start = fixed$cposFutilitySpending$free_parameters))
  expect_equal(replay$lower$bound, fixed$lower$bound, tolerance = 1e-5)
})

test_that("mode and controls have typed input errors", {
  x <- gsDesign(k = 2)
  prior <- list(z = x$delta, wgts = 1)
  for (mode in list(NULL, NA_character_, "fixed", TRUE,
                   c("preserve_power", "fixed_information"))) {
    expect_error(gsCPOSFutilitySpending(x, .8, prior = prior, mode = mode),
                 class = "gsCPOSFutilitySpending_input_error")
  }
  expect_error(gsCPOSFutilitySpending(x, .8, prior = prior,
    mode = "fixed_information", control = list(ca_tol = 1e-4)),
    class = "gsCPOSFutilitySpending_input_error")
  expect_error(gsCPOSFutilitySpending(x, .8, mode = "fixed_information"),
    class = "gsCPOSFutilitySpending_input_error")
})

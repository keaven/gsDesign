cp_at_futility <- function(x, i, theta = NULL) {
  vapply(seq_along(i), function(j) {
    theta_j <- if (is.null(theta)) {
      x$lower$bound[i[j]] / sqrt(x$n.I[i[j]])
    } else {
      theta[min(j, length(theta))]
    }
    sum(gsCP(
      x,
      i = i[j],
      zi = x$lower$bound[i[j]],
      theta = theta_j
    )$upper$prob)
  }, numeric(1))
}

test_that("one-parameter futility spending is recovered from conditional power", {
  x <- gsDesign(
    k = 3,
    test.type = 4,
    n.fix = 200,
    timing = c(.4, .7),
    sfu = sfHSD,
    sfupar = -4,
    sfl = sfHSD,
    sflpar = -1.5
  )
  target <- cp_at_futility(x, 1)

  fit <- gsCPFutilitySpending(
    x,
    target_cp = target,
    i = 1,
    sfl = "sfHSD",
    control = list(start = 0, lower = -8, upper = 4)
  )

  expect_s3_class(fit, "gsCPFutilitySpending")
  expect_s3_class(fit, "gsDesign")
  expect_equal(fit$lower$param, -1.5, tolerance = 1e-3)
  expect_equal(fit$cpFutilitySpending$achieved_cp, target, tolerance = 1e-4)
  expect_equal(sum(fit$upper$prob[, 2]), 1 - x$beta, tolerance = 2e-5)
  expect_equal(fit$upper$param, x$upper$param)
  expect_equal(fit$cpFutilitySpending$reference$upper$param, x$upper$param)
  expect_no_error(suppressMessages(toInteger(fit)))
})

test_that("an explicit conditional-power effect is retained", {
  x <- gsDesign(k = 3, test.type = 4, timing = c(.4, .7), sflpar = -1)
  target <- cp_at_futility(x, 1, theta = x$delta)

  fit <- gsCPFutilitySpending(
    x,
    target_cp = target,
    i = 1,
    theta = x$delta,
    control = list(start = -1)
  )

  expect_equal(fit$cpFutilitySpending$theta, x$delta)
  expect_equal(fit$cpFutilitySpending$theta_source, "specified")
  expect_equal(fit$cpFutilitySpending$achieved_cp, target)
})

test_that("supported test types preserve efficacy and harm specifications", {
  for (test_type in c(3, 4, 7, 8)) {
    x <- gsDesign(
      k = 3,
      test.type = test_type,
      timing = c(.4, .7),
      sfu = sfHSD,
      sfupar = -3,
      sfl = sfHSD,
      sflpar = -1,
      astar = .05,
      sfharm = sfPower,
      sfharmparam = 2,
      testHarm = c(TRUE, FALSE, TRUE)
    )
    target <- cp_at_futility(x, 1)
    fit <- gsCPFutilitySpending(x, target_cp = target, i = 1)

    expect_equal(fit$upper$param, x$upper$param)
    expect_equal(fit$testUpper, x$testUpper)
    expect_equal(fit$testLower, x$testLower)
    if (test_type %in% c(7, 8)) {
      expect_equal(fit$harm$param, x$harm$param)
      expect_equal(fit$harm$sTime, x$harm$sTime)
      expect_equal(fit$testHarm, x$testHarm)
      expect_equal(fit$cpFutilitySpending$reference$harm$function_name, "sfPower")
    }
  }
})

test_that("two-parameter spending uses backward initialization and joint refinement", {
  x <- gsDesign(
    k = 3,
    test.type = 4,
    timing = c(.35, .7),
    sfl = sfLogistic,
    sflpar = c(0, 1)
  )
  target <- cp_at_futility(x, 1:2)

  fit <- gsCPFutilitySpending(
    x,
    target_cp = target,
    i = 1:2,
    sfl = "sfLogistic",
    control = list(start = c(-1, 2))
  )

  expect_equal(fit$lower$param, c(0, 1), tolerance = 2e-3)
  expect_equal(fit$cpFutilitySpending$achieved_cp, target, tolerance = 1e-4)
  expect_match(fit$cpFutilitySpending$solver$method, "latest-to-earliest")
  expect_length(fit$cpFutilitySpending$solver$backward_residual, 2)
})

test_that("piecewise-linear spending remains valid while matching three targets", {
  x <- gsDesign(
    k = 4,
    test.type = 4,
    timing = c(.25, .5, .75),
    sfl = sfLinear,
    sflpar = c(.25, .5, .75, .05, .25, .65)
  )
  target <- cp_at_futility(x, 1:3)

  fit <- gsCPFutilitySpending(
    x,
    target_cp = target,
    i = 1:3,
    sfl = sfLinear,
    control = list(start = c(.045, .24, .64), cp_tol = 5e-4)
  )
  fitted_spending <- fit$cpFutilitySpending$free_parameters

  expect_true(all(fitted_spending > 0 & fitted_spending < 1))
  expect_true(all(diff(fitted_spending) > 0))
  expect_equal(fit$cpFutilitySpending$achieved_cp, target, tolerance = 5e-4)
  expect_equal(fit$lower$param[1:3], x$lower$sTime[1:3])
})

test_that("invalid inputs have a distinct condition class", {
  x <- gsDesign(k = 3, test.type = 4)

  expect_error(
    gsCPFutilitySpending(x, 0, i = 1),
    class = "gsCPFutilitySpending_input_error"
  )
  expect_error(
    gsCPFutilitySpending(x, c(.1, .2), i = c(1, 1), sfl = sfLogistic),
    class = "gsCPFutilitySpending_input_error"
  )
  expect_error(
    gsCPFutilitySpending(x, c(.1, .2), i = 1:2, sfl = sfHSD),
    class = "gsCPFutilitySpending_input_error"
  )
  expect_error(
    gsCPFutilitySpending(
      x, c(.1, .2), i = 1:2, sfl = sfLinear,
      control = list(start = c(.5, .4))
    ),
    class = "gsCPFutilitySpending_input_error"
  )
  expect_error(
    gsCPFutilitySpending(gsDesign(test.type = 1), .2, i = 1),
    class = "gsCPFutilitySpending_input_error"
  )
  inactive <- gsDesign(k = 3, test.type = 4, testLower = c(FALSE, TRUE, TRUE))
  expect_error(
    gsCPFutilitySpending(inactive, .2, i = 1),
    class = "gsCPFutilitySpending_input_error"
  )
})

test_that("unattainable targets report the closest candidate", {
  x <- gsDesign(k = 3, test.type = 4)

  error <- expect_error(
    gsCPFutilitySpending(
      x,
      target_cp = .9,
      i = 1,
      control = list(start = -3.5, lower = -4, upper = -3)
    ),
    class = "gsCPFutilitySpending_infeasible_error"
  )

  expect_match(conditionMessage(error), "Requested CP")
  expect_match(conditionMessage(error), "closest CP")
  expect_length(error$closest_cp, 1)
  expect_true(is.finite(error$max_information))
})

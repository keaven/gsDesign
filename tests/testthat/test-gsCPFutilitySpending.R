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

  rebuilt <- gsDesign(
    k = 3,
    test.type = 4,
    n.fix = 200,
    timing = c(.4, .7),
    sfu = sfHSD,
    sfupar = -4,
    sfl = sfHSD,
    sflpar = fit$cpFutilitySpending$sflpar
  )
  expect_equal(cp_at_futility(rebuilt, 1), target, tolerance = 1e-4)
})

test_that("documented solver controls retain defaults and enforce CP tolerance", {
  expect_equal(gsDesign:::.gsCPFControl(list()), list(
    start = NULL, lower = NULL, upper = NULL, cp_tol = 1e-4,
    maxit = 500L, reltol = 1e-10, backward = TRUE, trace = FALSE
  ))
  x <- gsDesign(
    k = 3, test.type = 4, timing = c(.5, .75),
    sfu = sfLDOF, sfl = sfHSD, sflpar = 1,
    testLower = c(TRUE, FALSE, FALSE)
  )
  fit <- gsCPFutilitySpending(x, .3, i = 1, control = list(cp_tol = 1e-6))
  expect_lte(abs(cp_at_futility(fit, 1) - .3), 1e-6)
})

test_that("invalid solver controls produce input errors", {
  x <- gsDesign(k = 3, test.type = 4)
  invalid_controls <- list(
    list(unknown = 1), list(cp_tol = 0), list(cp_tol = .1),
    list(maxit = 1.5), list(reltol = 0), list(backward = NA),
    list(trace = 1), list(start = c(0, 1)),
    list(start = 0, lower = 1, upper = 2)
  )
  for (ctl in invalid_controls) {
    expect_error(
      gsCPFutilitySpending(x, .3, i = 1, control = ctl),
      class = "gsCPFutilitySpending_input_error"
    )
  }
  expect_error(
    gsCPFutilitySpending(x, c(.2, .3), i = 1:2, sfl = sfLinear,
                        control = list(lower = c(0, 0))),
    class = "gsCPFutilitySpending_input_error"
  )
})

test_that("an explicit conditional power effect is retained", {
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

test_that("all two-parameter families attain explicit CP targets", {
  n_fixed <- nBinomial(.15, .10, alpha = .025, beta = .1, ratio = 1)
  x <- gsDesign(
    k = 3, test.type = 4, timing = c(.4, .75), sfu = sfLDOF,
    n.fix = n_fixed, delta1 = .05, endpoint = "Binomial",
    testLower = c(TRUE, TRUE, FALSE)
  )
  families <- c("sfLogistic", "sfBetaDist", "sfCauchy", "sfNormal",
                "sfExtremeValue", "sfExtremeValue2")
  for (family in families) {
    fit <- gsCPFutilitySpending(x, c(.3, .3), i = 1:2, sfl = family)
    rebuilt <- gsDesign(
      k = 3, test.type = 4, timing = c(.4, .75), sfu = sfLDOF,
      n.fix = n_fixed, delta1 = .05, endpoint = "Binomial",
      sfl = get(family, envir = asNamespace("gsDesign")),
      sflpar = fit$cpFutilitySpending$sflpar,
      testLower = c(TRUE, TRUE, FALSE)
    )
    expect_lte(max(abs(cp_at_futility(rebuilt, 1:2) - .3)), 1e-4)
    expect_equal(fit$delta1, .05)
    expect_equal(fit$n.fix, n_fixed)
    expect_equal(fit$endpoint, "Binomial")
    expect_equal(sum(rebuilt$upper$prob[, 2]), 1 - x$beta, tolerance = 2e-5)
  }
})

test_that("piecewise-linear spending attains equal and varying explicit targets", {
  times <- c(.3, .5, .7)
  n_fixed <- nNormal(delta1 = .5, sd = 1.1, alpha = .025, beta = .1, ratio = 1)
  x <- gsDesign(k = 4, test.type = 4, timing = times, sfu = sfLDOF,
                n.fix = n_fixed, delta1 = .5, endpoint = "Normal",
                testLower = c(TRUE, TRUE, TRUE, FALSE))
  for (target in list(rep(.3, 3), c(.2, .3, .4))) {
    fit <- gsCPFutilitySpending(
      x, target, i = 1:3, sfl = sfLinear,
      control = list(start = c(.85, .95, .98))
    )
    par <- fit$cpFutilitySpending$sflpar
    expect_equal(par[1:3], times)
    expect_true(all(par[4:6] > 0 & par[4:6] < 1))
    expect_true(all(diff(par[4:6]) > 0))
    rebuilt <- gsDesign(
      k = 4, test.type = 4, timing = times, sfu = sfLDOF,
      n.fix = n_fixed, delta1 = .5, endpoint = "Normal",
      sfl = sfLinear, sflpar = par,
      testLower = c(TRUE, TRUE, TRUE, FALSE)
    )
    expect_lte(max(abs(cp_at_futility(rebuilt, 1:3) - target)), 1e-4)
    expect_equal(fit$delta1, .5)
    expect_equal(fit$n.fix, n_fixed)
    expect_equal(fit$endpoint, "Normal")
    expect_equal(sum(rebuilt$upper$prob[, 2]), 1 - x$beta, tolerance = 2e-5)
  }
})

test_that("survival designs can replay calibrated fixed-timing spending", {
  x <- gsDesign(k = 3, test.type = 4, timing = c(.5, .75), sfu = sfLDOF,
                sfl = sfHSD, sflpar = 1, testLower = c(TRUE, FALSE, FALSE))
  fit <- gsCPFutilitySpending(x, .3, i = 1)
  surv <- gsSurv(k = 3, test.type = 4, timing = c(.5, .75), sfu = sfLDOF,
                 sfl = sfHSD, sflpar = fit$lower$param,
                 testLower = c(TRUE, FALSE, FALSE), ratio = 1)
  expect_lte(abs(cp_at_futility(surv, 1) - .3), 1e-4)
  expect_equal(sum(surv$upper$prob[, 2]), .9, tolerance = 2e-5)
  expect_error(gsCPFutilitySpending(surv, .3, i = 1),
               class = "gsCPFutilitySpending_input_error")

  args <- list(
    calendarTime = c(18, 27, 36), spending = "information",
    test.type = 4, sfu = sfLDOF, sfl = sfHSD, sflpar = 1,
    testLower = c(TRUE, FALSE, FALSE), hr = .7, lambdaC = log(2) / 12,
    R = 12, minfup = 12, ratio = 1
  )
  ref <- do.call(gsSurvCalendar, args)
  statistical <- gsDesign(
    k = ref$k, test.type = 4, alpha = ref$alpha, beta = ref$beta,
    n.fix = ref$n.fix, timing = ref$timing,
    usTime = ref$upper$sTime, lsTime = ref$lower$sTime,
    delta0 = ref$delta0, delta1 = ref$delta1,
    sfu = sfLDOF, sfl = sfHSD, sflpar = 1,
    testLower = c(TRUE, FALSE, FALSE)
  )
  fit <- gsCPFutilitySpending(statistical, .3, i = 1)
  args$sflpar <- fit$lower$param
  calendar <- do.call(gsSurvCalendar, args)
  expect_equal(calendar$timing, ref$timing, tolerance = 1e-6)
  expect_lte(abs(cp_at_futility(calendar, 1) - .3), 1e-4)
  expect_equal(sum(calendar$upper$prob[, 2]), .9, tolerance = 2e-5)
  expect_error(gsCPFutilitySpending(ref, .3, i = 1),
               class = "gsCPFutilitySpending_input_error")
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

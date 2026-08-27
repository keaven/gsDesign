test_that("gsSurvPower works with plannedCalendarTime from gsSurv design", {
  design <- gsSurv(
    k = 3, test.type = 4, alpha = 0.025, sided = 1, beta = 0.1,
    sfu = sfHSD, sfupar = -4,
    sfl = sfHSD, sflpar = -2,
    lambdaC = log(2) / 6, hr = 0.6, hr0 = 1,
    eta = 0.01, gamma = 10, R = 12, minfup = 18, T = 30
  )

  pwr <- gsSurvPower(x = design, plannedCalendarTime = design$T)
  expect_s3_class(pwr, "gsSurvPower")
  expect_s3_class(pwr, "gsSurv")
  expect_s3_class(pwr, "gsDesign")
  expect_equal(pwr$k, 3)
  expect_true(pwr$power > 0 && pwr$power < 1)
  expect_equal(pwr$T, design$T)
  expect_equal(pwr$n.I, rowSums(pwr$eDC) + rowSums(pwr$eDE))
  expect_equal(pwr$timing, pwr$n.I / max(pwr$n.I))
  expect_equal(pwr$hr, design$hr)
  expect_equal(pwr$hr1, design$hr)
  expect_equal(pwr$variable, "Power")
})

test_that("gsSurvPower retains evaluated inputs for direct reconstruction", {
  assumed_hr <- 0.7
  pwr <- gsSurvPower(
    k = 3,
    test.type = 1,
    lambdaC = matrix(log(2) / c(6, 12), ncol = 2),
    hr = assumed_hr,
    gamma = matrix(c(4, 6), ncol = 2),
    R = 12,
    plannedCalendarTime = c(12, NA, 36),
    targetEvents = c(NA, 80, NA),
    targetEventsPerStratum = matrix(
      c(NA, NA, 20, 30, NA, NA), nrow = 3, byrow = TRUE
    ),
    maxExtension = c(NA, 6, NA),
    maxCalendarTime = c(NA, 24, NA),
    minTimeFromPreviousAnalysis = c(NA, 6, NA),
    minN = c(100, NA, NA),
    minNPerStratum = matrix(
      c(40, 60, NA, NA, NA, NA), nrow = 3, byrow = TRUE
    ),
    minFollowUp = c(2, NA, NA)
  )
  rebuilt <- do.call(gsSurvPower, pwr$inputs)

  expect_s3_class(rebuilt, "gsSurvPower")
  expect_identical(pwr$inputs$hr, 0.7)
  expect_identical(pwr$inputs$plannedCalendarTime, c(12, NA, 36))
  expect_identical(
    pwr$inputs$targetEventsPerStratum,
    matrix(c(NA, NA, 20, 30, NA, NA), nrow = 3, byrow = TRUE)
  )
  expect_equal(rebuilt$T, pwr$T)
  expect_equal(rebuilt$n.I, pwr$n.I)
  expect_equal(rebuilt$upper$bound, pwr$upper$bound)
  expect_equal(rebuilt$power, pwr$power)
})

test_that("gsSurvPower reconstruction retains its reference design", {
  design <- gsSurv(
    k = 3, test.type = 4, beta = 0.15,
    lambdaC = log(2) / 12, hr = 0.7, eta = 0.01,
    gamma = 10, R = 16, minfup = 12, T = 28
  )
  pwr <- gsSurvPower(
    x = design,
    hr = 0.8,
    targetEvents = 0.9 * design$n.I,
    spending = "min_planned_actual"
  )
  rebuilt <- do.call(gsSurvPower, pwr$inputs)

  expect_identical(pwr$inputs$x, design)
  expect_identical(pwr$inputs$targetEvents, 0.9 * design$n.I)
  expect_equal(rebuilt$T, pwr$T)
  expect_equal(rebuilt$n.I, pwr$n.I)
  expect_equal(rebuilt$upper$bound, pwr$upper$bound)
  expect_equal(rebuilt$lower$bound, pwr$lower$bound)
  expect_equal(rebuilt$power, pwr$power)
})

test_that("gsSurvPower power decreases with worse HR", {
  design <- gsSurv(
    k = 3, test.type = 4, alpha = 0.025, sided = 1, beta = 0.1,
    lambdaC = log(2) / 6, hr = 0.6, hr0 = 1,
    eta = 0.01, gamma = 10, R = 12, minfup = 18, T = 30
  )

  pwr_design <- gsSurvPower(x = design, plannedCalendarTime = design$T)
  pwr_worse <- gsSurvPower(x = design, hr = 0.8, plannedCalendarTime = design$T)

  expect_true(pwr_worse$power < pwr_design$power)
  expect_equal(pwr_worse$hr, 0.8)
  expect_equal(pwr_worse$hr1, design$hr)
})

test_that("gsSurvPower works with targetEvents", {
  design <- gsSurv(
    k = 2, test.type = 1, alpha = 0.025, sided = 1, beta = 0.1,
    lambdaC = log(2) / 6, hr = 0.7, hr0 = 1,
    gamma = 10, R = 12, minfup = 18, T = 30
  )

  pwr <- gsSurvPower(
    x = design,
    targetEvents = c(50, 100)
  )
  expect_equal(pwr$k, 2)
  expect_true(pwr$T[1] < pwr$T[2])
  events <- rowSums(pwr$eDC) + rowSums(pwr$eDE)
  expect_equal(events, c(50, 100), tolerance = 1e-6)
  expect_equal(pwr$n.I, events)

  pwr_matrix <- expect_no_warning(gsSurvPower(
    x = design,
    targetEvents = matrix(c(50, 100), ncol = 1)
  ))
  expect_equal(pwr_matrix$T, pwr$T, tolerance = 1e-6)
  expect_equal(pwr_matrix$n.I, pwr$n.I, tolerance = 1e-6)
})

test_that("gsSurvPower preserves integer sample size and event targets", {
  target_events <- c(150, 200, 350)
  pwr <- gsSurvPower(
    k = 3,
    test.type = 1,
    alpha = 0.025,
    sided = 1,
    sfu = sfLDOF,
    sfupar = NULL,
    spending = "information",
    lambdaC = log(2) / 15,
    hr = 0.7,
    hr0 = 1,
    eta = 0.001,
    gamma = c(1, 2, 3, 4) * 500 /
      sum(c(1, 2, 3, 4) * c(2, 2, 2, 6)),
    R = c(2, 2, 2, 6),
    targetEvents = target_events,
    minfup = 18,
    ratio = 1.5,
    testUpper = TRUE,
    testLower = FALSE,
    testHarm = FALSE,
    method = "LachinFoulkes"
  )

  expect_identical(pwr$n.I, target_events)
  expect_equal(rowSums(pwr$eDC) + rowSums(pwr$eDE), target_events)
  expect_identical(as.vector(pwr$eNC), rep(200, 3))
  expect_identical(as.vector(pwr$eNE), rep(300, 3))

  summary_analysis <- gsBoundSummary(pwr)$Analysis
  expect_identical(
    summary_analysis[grepl("^N:", summary_analysis)],
    rep("N: 500", 3)
  )
  expect_identical(
    summary_analysis[grepl("^Events:", summary_analysis)],
    paste("Events:", target_events)
  )
})

test_that("gsSurvPower applies explicit minfup as final analysis floor", {
  target_events <- c(100, 200, 300)
  pwr <- gsSurvPower(
    k = 3,
    test.type = 1,
    alpha = 0.025,
    sided = 1,
    astar = 0,
    sfu = sfLDOF,
    sfupar = NULL,
    spending = "information",
    lambdaC = log(2) / 15,
    hr = 0.7,
    hr0 = 1,
    eta = 0.001,
    gamma = c(1, 2, 3, 4) * 500 /
      sum(c(1, 2, 3, 4) * c(2, 2, 2, 6)),
    R = c(2, 2, 2, 6),
    targetEvents = target_events,
    minfup = 25,
    ratio = 1.5,
    testUpper = TRUE,
    testLower = FALSE,
    testHarm = FALSE,
    method = "LachinFoulkes"
  )

  expect_equal(tail(pwr$T, 1), sum(c(2, 2, 2, 6)) + 25, tolerance = 1e-6)
  expect_equal(pwr$n.I[1:2], target_events[1:2], tolerance = 1e-6)
  expect_true(pwr$n.I[3] > target_events[3])
})

test_that("gsSurvPower only applies minfup floor when supplied directly", {
  design <- gsSurv(
    k = 3, test.type = 4, alpha = 0.025, sided = 1, beta = 0.1,
    lambdaC = log(2) / 12, hr = 0.7, eta = 0.01,
    gamma = 10, R = 16, minfup = 12, T = 28
  )
  target_events <- 0.8 * design$n.I

  inherited <- gsSurvPower(x = design, targetEvents = target_events)
  explicit <- gsSurvPower(
    x = design,
    targetEvents = target_events,
    minfup = design$minfup
  )

  expect_lt(tail(inherited$T, 1), sum(design$R) + design$minfup)
  expect_equal(
    tail(explicit$T, 1),
    sum(design$R) + design$minfup,
    tolerance = 1e-6
  )
})

test_that("gsSurvPower targetN works without explicit R", {
  pwr <- gsSurvPower(
    k = 2,
    test.type = 1,
    alpha = 0.025,
    sided = 1,
    lambdaC = log(2) / 15,
    hr = 0.7,
    hr0 = 1,
    eta = 0.001,
    gamma = c(10, 20, 30, 40),
    targetN = 500,
    plannedCalendarTime = c(24, 36),
    ratio = 1.5,
    testUpper = TRUE,
    testLower = FALSE,
    testHarm = FALSE,
    method = "LachinFoulkes"
  )

  expect_length(pwr$R, 4)
  expect_equal(sum(rowSums(pwr$gamma) * pwr$R), 500, tolerance = 1e-8)
  expect_equal(pwr$R, rep(5, 4), tolerance = 1e-8)
  expect_equal(pwr$T, c(24, 36))
})

test_that("gsSurvPower works without x (all parameters specified)", {
  pwr <- gsSurvPower(
    k = 2, test.type = 1, alpha = 0.025, sided = 1,
    lambdaC = log(2) / 6, hr = 0.7, hr0 = 1,
    eta = 0, gamma = 10, R = 12, ratio = 1,
    plannedCalendarTime = c(24, 36)
  )
  expect_s3_class(pwr, "gsSurv")
  expect_equal(pwr$k, 2)
  expect_equal(pwr$T, c(24, 36))
  expect_equal(pwr$variable, "Power")
  expect_true(pwr$power > 0)
})

test_that("gsSurvPower respects maxExtension", {
  pwr_capped <- gsSurvPower(
    k = 1, test.type = 1, alpha = 0.025, sided = 1,
    lambdaC = log(2) / 6, hr = 0.7, hr0 = 1,
    gamma = 10, R = 12, ratio = 1,
    targetEvents = c(80),
    maxExtension = c(3),
    plannedCalendarTime = c(18)
  )

  pwr_uncapped <- gsSurvPower(
    k = 1, test.type = 1, alpha = 0.025, sided = 1,
    lambdaC = log(2) / 6, hr = 0.7, hr0 = 1,
    gamma = 10, R = 12, ratio = 1,
    targetEvents = c(80),
    plannedCalendarTime = c(18)
  )
  expect_true(pwr_capped$T[1] <= pwr_uncapped$T[1])
})

test_that("maxCalendarTime is an absolute analysis-time cap", {
  base_args <- list(
    k = 1, test.type = 1, alpha = 0.025, sided = 1,
    lambdaC = log(2) / 6, hr = 0.7, hr0 = 1,
    gamma = 10, R = 12, ratio = 1,
    targetEvents = 100
  )

  pwr_capped <- do.call(gsSurvPower, c(base_args, list(
    maxCalendarTime = 18
  )))
  pwr_uncapped <- do.call(gsSurvPower, base_args)

  expect_equal(pwr_capped$T, 18, tolerance = 1e-6)
  expect_lt(pwr_capped$n.I, 100)
  expect_gt(pwr_uncapped$T, pwr_capped$T)

  pwr_relative_first <- do.call(gsSurvPower, c(base_args, list(
    plannedCalendarTime = 18,
    maxExtension = 2,
    maxCalendarTime = 22
  )))
  pwr_absolute_first <- do.call(gsSurvPower, c(base_args, list(
    plannedCalendarTime = 18,
    maxExtension = 10,
    maxCalendarTime = 22
  )))
  expect_equal(pwr_relative_first$T, 20, tolerance = 1e-6)
  expect_equal(pwr_absolute_first$T, 22, tolerance = 1e-6)
})

test_that("gsSurvPower requires a floor criterion when maxExtension is supplied", {
  expect_error(
    gsSurvPower(
      k = 2, test.type = 1, alpha = 0.025, sided = 1,
      lambdaC = log(2) / 12, hr = 0.7, hr0 = 1,
      gamma = 5, R = 12, ratio = 1,
      targetEvents = c(20, 40),
      maxExtension = c(0, 6)
    ),
    "maxExtension requires a floor timing criterion"
  )
})

test_that("maxExtension is a hard cap even when other criteria push later", {
  pwr <- gsSurvPower(
    k = 2, test.type = 1, alpha = 0.025, sided = 1,
    lambdaC = log(2) / 6, hr = 0.7, hr0 = 1,
    gamma = 10, R = 12, ratio = 1,
    plannedCalendarTime = c(12, 18),
    minTimeFromPreviousAnalysis = c(NA, 20),
    maxExtension = c(NA, 6)
  )
  expect_equal(pwr$T[1], 12)
  expect_true(pwr$T[1] + 20 > 18 + 6)
  expect_equal(pwr$T[2], 18 + 6, tolerance = 1e-6)
})

test_that("maxExtension caps targetEvents and minTimeFromPreviousAnalysis", {
  expect_warning(
    pwr <- gsSurvPower(
      k = 2, test.type = 1, alpha = 0.025, sided = 1,
      lambdaC = log(2) / 12, hr = 0.7, hr0 = 1,
      gamma = 5, R = 12, ratio = 1,
      plannedCalendarTime = c(12, 24),
      targetEvents = c(20, 500),
      maxExtension = c(NA, 6),
      minTimeFromPreviousAnalysis = c(NA, 18)
    ),
    "Target 500 events may not be achievable"
  )
  expect_true(pwr$T[2] <= 24 + 6 + 1e-6)
  events_2 <- sum(pwr$eDC[2, ] + pwr$eDE[2, ])
  expect_true(events_2 < 500)
})

test_that("gsSurvPower calendar spending ignores usTime and lsTime", {
  base_args <- list(
    k = 3, test.type = 4, alpha = 0.025, sided = 1,
    lambdaC = log(2) / 12, hr = 0.7, hr0 = 1,
    eta = 0.01, gamma = 10, R = 16, minfup = 12,
    plannedCalendarTime = c(12, 24, 36)
  )

  pwr_cal <- do.call(gsSurvPower, c(base_args, list(spending = "calendar")))
  pwr_cal_custom <- do.call(gsSurvPower, c(base_args, list(
    spending = "calendar",
    usTime = c(0.2, 0.6, 1),
    lsTime = c(0.3, 0.8, 1)
  )))

  expect_equal(pwr_cal$upper$bound, pwr_cal_custom$upper$bound)
  expect_equal(pwr_cal$lower$bound, pwr_cal_custom$lower$bound)
  expect_equal(pwr_cal$spending, "calendar")
})

test_that("gsSurvPower information spending respects usTime and lsTime", {
  base_args <- list(
    k = 3, test.type = 4, alpha = 0.025, sided = 1,
    lambdaC = log(2) / 12, hr = 0.7, hr0 = 1,
    eta = 0.01, gamma = 10, R = 16, minfup = 12,
    plannedCalendarTime = c(12, 24, 36)
  )

  pwr_default <- do.call(gsSurvPower, c(base_args, list(spending = "information")))
  pwr_custom <- do.call(gsSurvPower, c(base_args, list(
    spending = "information",
    usTime = c(0.2, 0.6, 1),
    lsTime = c(0.3, 0.8, 1)
  )))

  expect_false(isTRUE(all.equal(pwr_default$upper$bound, pwr_custom$upper$bound)))
  expect_false(isTRUE(all.equal(pwr_default$lower$bound, pwr_custom$lower$bound)))
})

test_that("gsSurvPower informationRates take precedence over calendar spending", {
  design <- gsSurv(
    k = 3, test.type = 4, alpha = 0.025, sided = 1, beta = 0.1,
    sfu = sfHSD, sfupar = -4, sfl = sfHSD, sflpar = -2,
    lambdaC = log(2) / 12, hr = 0.7, hr0 = 1,
    eta = 0.01, gamma = 10, R = 16, minfup = 12, T = 28
  )
  info_rates <- c(0.2, 0.6, 1)

  pwr_info <- gsSurvPower(
    x = design,
    plannedCalendarTime = design$T,
    informationRates = info_rates,
    spending = "information"
  )
  pwr_calendar <- gsSurvPower(
    x = design,
    plannedCalendarTime = design$T,
    informationRates = info_rates,
    spending = "calendar",
    usTime = c(0.3, 0.7, 1),
    lsTime = c(0.4, 0.8, 1)
  )
  pwr_min_planned_actual <- gsSurvPower(
    x = design,
    plannedCalendarTime = design$T,
    informationRates = info_rates,
    spending = "min_planned_actual"
  )

  expect_equal(pwr_info$upper$bound, pwr_calendar$upper$bound)
  expect_equal(pwr_info$lower$bound, pwr_calendar$lower$bound)
  expect_equal(pwr_info$upper$bound, pwr_min_planned_actual$upper$bound)
  expect_equal(pwr_info$lower$bound, pwr_min_planned_actual$lower$bound)
  expect_equal(pwr_info$informationRates, info_rates)
})

test_that("gsSurvPower fullSpendingAtFinal forces final spending fraction to one", {
  design <- gsSurv(
    k = 3, test.type = 4, alpha = 0.025, sided = 1, beta = 0.1,
    sfu = sfHSD, sfupar = -4, sfl = sfHSD, sflpar = -2,
    lambdaC = log(2) / 12, hr = 0.7, hr0 = 1,
    eta = 0.01, gamma = 10, R = 16, minfup = 12, T = 28
  )
  partial_final <- c(0.25, 0.6, 0.95)
  full_final <- c(0.25, 0.6, 1)

  pwr_partial <- gsSurvPower(
    x = design,
    plannedCalendarTime = design$T,
    informationRates = partial_final,
    fullSpendingAtFinal = FALSE
  )
  pwr_full <- gsSurvPower(
    x = design,
    plannedCalendarTime = design$T,
    informationRates = partial_final,
    fullSpendingAtFinal = TRUE
  )

  gs_partial <- gsDesign(
    k = design$k, test.type = design$test.type,
    alpha = design$alpha, beta = design$beta,
    n.fix = design$n.fix, timing = design$timing,
    sfu = design$upper$sf, sfupar = design$upper$param,
    sfl = design$lower$sf, sflpar = design$lower$param,
    delta1 = log(design$hr), delta0 = log(design$hr0),
    usTime = partial_final, lsTime = partial_final
  )
  gs_full <- gsDesign(
    k = design$k, test.type = design$test.type,
    alpha = design$alpha, beta = design$beta,
    n.fix = design$n.fix, timing = design$timing,
    sfu = design$upper$sf, sfupar = design$upper$param,
    sfl = design$lower$sf, sflpar = design$lower$param,
    delta1 = log(design$hr), delta0 = log(design$hr0),
    usTime = full_final, lsTime = full_final
  )

  expect_equal(pwr_partial$upper$bound, gs_partial$upper$bound, tolerance = 1e-4)
  expect_equal(pwr_partial$lower$bound, gs_partial$lower$bound, tolerance = 1e-4)
  expect_equal(pwr_full$upper$bound, gs_full$upper$bound, tolerance = 1e-4)
  expect_equal(pwr_full$lower$bound, gs_full$lower$bound, tolerance = 1e-4)
  expect_false(isTRUE(all.equal(pwr_partial$upper$bound, pwr_full$upper$bound)))
  expect_true(isTRUE(pwr_full$fullSpendingAtFinal))
})

test_that("gsSurvPower supports planned-versus-actual spending", {
  design <- gsSurv(
    k = 3, test.type = 4, alpha = 0.025, sided = 1, beta = 0.1,
    sfu = sfHSD, sfupar = -4, sfl = sfHSD, sflpar = -2,
    lambdaC = log(2) / 12, hr = 0.7, hr0 = 1,
    eta = 0.01, gamma = 10, R = 16, minfup = 12, T = 28
  )

  pwr <- gsSurvPower(
    x = design,
    lambdaC = log(2) / 24,
    plannedCalendarTime = design$T,
    spending = "min_planned_actual"
  )
  expected_spending_time <- pmin(design$n.I, pwr$n.I) /
    design$n.I[design$k]

  expect_equal(pwr$upper$sTime, expected_spending_time, tolerance = 1e-8)
  expect_equal(pwr$lower$sTime, expected_spending_time, tolerance = 1e-8)
  expect_lt(tail(expected_spending_time, 1), 1)

  pwr_full <- gsSurvPower(
    x = design,
    lambdaC = log(2) / 24,
    plannedCalendarTime = design$T,
    spending = "min_planned_actual",
    fullSpendingAtFinal = TRUE
  )
  expect_equal(tail(pwr_full$upper$sTime, 1), 1)

  expect_error(
    gsSurvPower(
      k = 2, test.type = 1, alpha = 0.025, sided = 1,
      lambdaC = log(2) / 6, hr = 0.7, hr0 = 1,
      gamma = 10, R = 12, ratio = 1,
      plannedCalendarTime = c(18, 24),
      spending = "min_planned_actual"
    ),
    "requires a reference design x"
  )
})

test_that("gsSurvPower enforces per-stratum event requirements", {
  target_matrix <- matrix(c(20, 10, 40, 20), nrow = 2, byrow = TRUE)
  base_args <- list(
    k = 2, test.type = 1, alpha = 0.025, sided = 1,
    lambdaC = matrix(log(2) / c(6, 12), ncol = 2),
    hr = 0.7, hr0 = 1,
    eta = matrix(c(0.01, 0.02), ncol = 2),
    gamma = matrix(c(5, 5), ncol = 2),
    R = 12, ratio = 1
  )

  pwr_per_stratum <- do.call(gsSurvPower, c(base_args, list(
    targetEventsPerStratum = target_matrix
  )))
  events_per_stratum <- pwr_per_stratum$eDC + pwr_per_stratum$eDE

  expect_true(all(events_per_stratum >= target_matrix - 1e-4))
  expect_true(all(apply(
    abs(events_per_stratum - target_matrix) < 1e-4,
    1,
    any
  )))
  expect_false(isTRUE(all.equal(
    pwr_per_stratum$n.I,
    rowSums(target_matrix),
    tolerance = 1e-4
  )))

  expect_warning(
    pwr_alias <- do.call(gsSurvPower, c(base_args, list(
      targetEvents = target_matrix
    ))),
    "matrix targetEvents is deprecated"
  )
  expect_equal(pwr_alias$T, pwr_per_stratum$T, tolerance = 1e-6)
  expect_equal(pwr_alias$n.I, pwr_per_stratum$n.I, tolerance = 1e-6)
})

test_that("gsSurvPower combines overall and per-stratum event requirements", {
  target_matrix <- matrix(c(20, 10, 40, 20), nrow = 2, byrow = TRUE)
  overall_targets <- c(35, 70)

  pwr <- gsSurvPower(
    k = 2, test.type = 1, alpha = 0.025, sided = 1,
    lambdaC = matrix(log(2) / c(6, 12), ncol = 2),
    hr = 0.7, hr0 = 1,
    eta = matrix(c(0.01, 0.02), ncol = 2),
    gamma = matrix(c(5, 5), ncol = 2),
    R = 12, ratio = 1,
    targetEvents = overall_targets,
    targetEventsPerStratum = target_matrix
  )

  events_per_stratum <- pwr$eDC + pwr$eDE
  expect_true(all(events_per_stratum >= target_matrix - 1e-4))
  expect_equal(pwr$n.I, overall_targets, tolerance = 1e-4)
})

test_that("gsSurvPower uses etaE separately from eta", {
  pwr_equal_dropout <- gsSurvPower(
    k = 2, test.type = 1, alpha = 0.025, sided = 1,
    lambdaC = log(2) / 6, hr = 0.7, hr0 = 1,
    eta = 0.01, etaE = 0.01,
    gamma = 10, R = 12, ratio = 1,
    plannedCalendarTime = c(24, 36)
  )
  pwr_high_exp_dropout <- gsSurvPower(
    k = 2, test.type = 1, alpha = 0.025, sided = 1,
    lambdaC = log(2) / 6, hr = 0.7, hr0 = 1,
    eta = 0.01, etaE = 0.05,
    gamma = 10, R = 12, ratio = 1,
    plannedCalendarTime = c(24, 36)
  )

  expect_true(all(pwr_high_exp_dropout$etaE == 0.05))
  expect_true(tail(pwr_high_exp_dropout$n.I, 1) < tail(pwr_equal_dropout$n.I, 1))
})

test_that("gsSurvPower supports piecewise failure periods", {
  pwr_piecewise <- gsSurvPower(
    k = 2, test.type = 1, alpha = 0.025, sided = 1,
    lambdaC = c(log(2) / 6, log(2) / 12), hr = 0.7, hr0 = 1,
    eta = 0.01, gamma = 10, R = 12, S = 6, ratio = 1,
    plannedCalendarTime = c(12, 24)
  )

  expect_equal(pwr_piecewise$S, 6)
  expect_equal(nrow(pwr_piecewise$lambdaC), 2)
  expect_true(all(pwr_piecewise$n.I > 0))
})

test_that("gsSurvPower preserves testUpper and testLower flags on output", {
  pwr <- gsSurvPower(
    k = 3, test.type = 4, alpha = 0.025, sided = 1,
    lambdaC = log(2) / 12, hr = 0.7, hr0 = 1,
    eta = 0.01, gamma = 10, R = 16, minfup = 12,
    plannedCalendarTime = c(12, 24, 36),
    testUpper = c(FALSE, TRUE, TRUE),
    testLower = c(TRUE, FALSE, FALSE)
  )

  expect_equal(pwr$testUpper, c(FALSE, TRUE, TRUE))
  expect_equal(pwr$testLower, c(TRUE, FALSE, FALSE))
})

test_that("gsSurvPower minTimeFromPreviousAnalysis works", {
  pwr <- gsSurvPower(
    k = 2, test.type = 1, alpha = 0.025, sided = 1,
    lambdaC = log(2) / 6, hr = 0.7, hr0 = 1,
    gamma = 10, R = 12, ratio = 1,
    plannedCalendarTime = c(12, 24),
    minTimeFromPreviousAnalysis = c(NA, 6)
  )
  expect_true(pwr$T[2] - pwr$T[1] >= 6 - 1e-6)
})

test_that("gsSurvPower supports minN and minFollowUp timing", {
  pwr <- gsSurvPower(
    k = 3,
    test.type = 1,
    alpha = 0.025,
    sided = 1,
    lambdaC = log(2) / 15,
    hr = 0.7,
    hr0 = 1,
    eta = 0.001,
    gamma = c(1, 2, 3, 4) * 500 /
      sum(c(1, 2, 3, 4) * c(2, 2, 2, 6)),
    R = c(2, 2, 2, 6),
    minN = c(100, 300, 500),
    minFollowUp = c(6, 6, 6),
    ratio = 1.5,
    testUpper = TRUE,
    testLower = FALSE,
    testHarm = FALSE,
    method = "LachinFoulkes"
  )

  expect_true(all(diff(pwr$T) > 0))
  expect_true(all(pwr$N >= c(100, 300, 500)))

  expect_error(
    gsSurvPower(
      k = 3,
      test.type = 1,
      alpha = 0.025,
      sided = 1,
      lambdaC = log(2) / 15,
      hr = 0.7,
      hr0 = 1,
      eta = 0.001,
      gamma = c(1, 2, 3, 4) * 500 /
        sum(c(1, 2, 3, 4) * c(2, 2, 2, 6)),
      R = c(2, 2, 2, 6),
      minN = c(300, 500, 500),
      minFollowUp = c(6, 6, 6),
      ratio = 1.5,
      testUpper = TRUE,
      testLower = FALSE,
      testHarm = FALSE,
      method = "LachinFoulkes"
    ),
    "Analysis times must be strictly increasing"
  )
})

test_that("gsSurvPower supports per-stratum enrollment and follow-up gates", {
  enrollment_targets <- matrix(
    c(20, 30, 40, 60),
    nrow = 2,
    byrow = TRUE
  )
  pwr <- gsSurvPower(
    k = 2,
    test.type = 1,
    alpha = 0.025,
    sided = 1,
    lambdaC = matrix(log(2) / c(6, 12), ncol = 2),
    hr = 0.7,
    hr0 = 1,
    eta = 0,
    gamma = matrix(c(4, 6), ncol = 2),
    R = 12,
    minNPerStratum = enrollment_targets,
    minFollowUp = c(2, 2),
    ratio = 1
  )

  expect_equal(pwr$T, c(7, 12), tolerance = 1e-3)
  expect_true(all(pwr$eNC + pwr$eNE >= enrollment_targets))
})

test_that("gsSurvPower supports mixed NA across analysis timing rules", {
  pwr <- gsSurvPower(
    k = 3,
    test.type = 1,
    alpha = 0.025,
    sided = 1,
    lambdaC = log(2) / 6,
    hr = 0.7,
    hr0 = 1,
    gamma = 10,
    R = 12,
    ratio = 1,
    plannedCalendarTime = c(12, NA, 36),
    targetEvents = c(NA, 80, NA),
    targetEventsPerStratum = matrix(c(NA, 50, NA), ncol = 1),
    maxExtension = c(NA, 6, NA),
    maxCalendarTime = c(NA, 24, NA),
    minTimeFromPreviousAnalysis = c(NA, 6, NA),
    minN = c(100, NA, NA),
    minNPerStratum = matrix(c(40, NA, NA), ncol = 1),
    minFollowUp = c(2, NA, NA)
  )

  expect_equal(pwr$T, c(12, 18, 36), tolerance = 1e-3)
  expect_true(pwr$N[1] >= 100)
  expect_true(all(diff(pwr$n.I) > 0))
})

test_that("gsSurvPower print method works for power output", {
  design <- gsSurv(
    k = 2, test.type = 4, alpha = 0.025, sided = 1, beta = 0.1,
    lambdaC = log(2) / 6, hr = 0.7, hr0 = 1,
    gamma = 10, R = 12, minfup = 18, T = 30
  )
  pwr <- gsSurvPower(x = design, hr = 0.8, plannedCalendarTime = design$T)

  out <- capture.output(print(pwr))
  expect_true(any(grepl("Power computation", out)))
  expect_true(any(grepl("Assumed HR", out)))
  expect_true(any(grepl("Design HR", out)))
})

test_that("gsSurvPower infers sided from test.type when x does not store it", {
  design <- gsSurv(
    k = 3, test.type = 4, alpha = 0.05, sided = 2, beta = 0.1,
    sfu = sfHSD, sfupar = -4, sfl = sfHSD, sflpar = -2,
    lambdaC = log(2) / 12, hr = 0.7, hr0 = 1,
    eta = 0.01, gamma = 10, R = 16, minfup = 12, T = 28
  )
  pwr <- gsSurvPower(x = design, plannedCalendarTime = design$T)

  expect_null(design$sided)
  expect_equal(pwr$sided, 2)
  expect_equal(pwr$alpha * pwr$sided, 0.05, tolerance = 1e-8)

  out <- capture.output(print(pwr))
  expect_true(any(grepl("alpha=0.0500 \\(sided=2\\)", out)))
})

test_that("gsSurvPower validates inputs", {
  expect_error(
    gsSurvPower(x = "not_a_design"),
    "x must be a gsSurv"
  )
  expect_error(
    gsSurvPower(
      k = 2, lambdaC = log(2) / 6, gamma = 10, R = 12,
      plannedCalendarTime = c(12, 24, 36)
    ),
    "must have length 1 or"
  )

  expect_error(
    gsSurvPower(
      k = 3, lambdaC = log(2) / 6, gamma = 10, R = 12,
      plannedCalendarTime = c(12, 24, 36),
      minN = c(100, NA, NA),
      minFollowUp = c(2, 5, NA)
    ),
    "minFollowUp at analysis 2 requires minN or minNPerStratum"
  )

  expect_error(
    gsSurvPower(
      k = 3, lambdaC = log(2) / 6, gamma = 10, R = 12,
      plannedCalendarTime = c(12, 24, 36),
      informationRates = c(0.3, NA, 1)
    ),
    "informationRates.*without NA"
  )

  expect_error(
    gsSurvPower(
      k = 3, lambdaC = log(2) / 6, gamma = 10, R = 12,
      plannedCalendarTime = c(12, 24, 36),
      testUpper = c(FALSE, NA, TRUE)
    ),
    "testUpper.*without NA"
  )

  expect_error(
    gsSurvPower(
      k = 3, lambdaC = log(2) / 6, gamma = 10, R = 12,
      plannedCalendarTime = c(12, 24, 36),
      usTime = c(0.3, NA, 1)
    ),
    "usTime.*without NA"
  )

  expect_error(
    gsSurvPower(
      k = 2, lambdaC = log(2) / 6, gamma = 10, R = 12,
      plannedCalendarTime = c(12, Inf)
    ),
    "plannedCalendarTime values must be non-negative finite numbers or NA"
  )

  expect_error(
    gsSurvPower(
      k = 3, lambdaC = log(2) / 6, gamma = 10, R = 12,
      plannedCalendarTime = c(12, NA, 36)
    ),
    "Analysis 2 has no active timing criterion"
  )
})

test_that("gsSurvPower preserves the legacy positional argument order", {
  legacy_formals <- c(
    "x", "k", "test.type", "alpha", "sided", "astar",
    "sfu", "sfupar", "sfl", "sflpar", "sfharm", "sfharmparam",
    "r", "usTime", "lsTime", "testUpper", "testLower", "testHarm",
    "lambdaC", "hr", "hr0", "hr1", "eta", "etaE", "gamma", "R",
    "targetN", "S", "ratio", "minfup", "method", "spending",
    "plannedCalendarTime", "targetEvents", "maxExtension",
    "minTimeFromPreviousAnalysis", "minN", "minFollowUp",
    "informationRates", "fullSpendingAtFinal", "tol"
  )

  expect_identical(
    names(formals(gsSurvPower))[seq_along(legacy_formals)],
    legacy_formals
  )
})

test_that("gsSurvPower with Schoenfeld method", {
  pwr <- gsSurvPower(
    k = 2, test.type = 1, alpha = 0.025, sided = 1,
    lambdaC = log(2) / 6, hr = 0.7, hr0 = 1,
    gamma = 10, R = 12, ratio = 1, method = "Schoenfeld",
    plannedCalendarTime = c(24, 36)
  )
  expect_equal(pwr$method, "Schoenfeld")
  expect_true(pwr$power > 0)
})

test_that("gsSurvPower with ratio != 1", {
  pwr_r1 <- gsSurvPower(
    k = 2, test.type = 1, alpha = 0.025, sided = 1,
    lambdaC = log(2) / 6, hr = 0.7, hr0 = 1,
    gamma = 10, R = 12, ratio = 1,
    plannedCalendarTime = c(24, 36)
  )
  pwr_r2 <- gsSurvPower(
    k = 2, test.type = 1, alpha = 0.025, sided = 1,
    lambdaC = log(2) / 6, hr = 0.7, hr0 = 1,
    gamma = 10, R = 12, ratio = 2,
    plannedCalendarTime = c(24, 36)
  )
  expect_equal(pwr_r2$ratio, 2)
  expect_true(pwr_r1$power != pwr_r2$power)
})

test_that("gsSurvPower exactly reproduces design power for all methods", {
  base_args <- list(
    k = 3, test.type = 4, alpha = 0.025, sided = 1, beta = 0.1,
    sfu = sfHSD, sfupar = -4, sfl = sfHSD, sflpar = -2,
    lambdaC = log(2) / 12, hr = 0.7, hr0 = 1,
    eta = 0.01, gamma = 10, R = 16, minfup = 12, T = 28
  )

  for (m in c("LachinFoulkes", "Schoenfeld", "Freedman")) {
    args <- c(base_args, list(method = m))
    design <- do.call(gsSurv, args)
    pwr <- gsSurvPower(x = design, plannedCalendarTime = design$T)
    expect_equal(pwr$power, 1 - design$beta, tolerance = 1e-6,
      label = paste("method =", m))
  }
})

test_that("gsSurvPower reproduces design power with ratio = 2", {
  for (m in c("LachinFoulkes", "Schoenfeld")) {
    design <- gsSurv(
      k = 3, test.type = 4, alpha = 0.025, sided = 1, beta = 0.1,
      lambdaC = log(2) / 12, hr = 0.7, hr0 = 1,
      eta = 0.01, gamma = 10, R = 16, minfup = 12, T = 28,
      ratio = 2, method = m
    )
    pwr <- gsSurvPower(x = design, plannedCalendarTime = design$T)
    expect_equal(pwr$power, 1 - design$beta, tolerance = 1e-6,
      label = paste("method =", m, "ratio = 2"))
  }
})

test_that("gsSurvPower reproduces design power for BernsteinLagakos stratified", {
  design <- gsSurv(
    k = 3, test.type = 4, alpha = 0.025, sided = 1, beta = 0.1,
    lambdaC = matrix(log(2) / c(6, 12), ncol = 2), hr = 0.7, hr0 = 1,
    eta = 0.01, gamma = matrix(c(5, 5), ncol = 2), R = 16, minfup = 12, T = 28,
    method = "BernsteinLagakos"
  )
  pwr <- gsSurvPower(x = design, plannedCalendarTime = design$T)
  expect_equal(pwr$power, 1 - design$beta, tolerance = 1e-6)
})

test_that("gsSurvPower Schoenfeld matches rpact getPowerSurvival", {
  skip_if_not_installed("rpact")

  design <- gsSurv(
    k = 3, test.type = 4, alpha = 0.025, sided = 1, beta = 0.1,
    sfu = sfHSD, sfupar = -4, sfl = sfHSD, sflpar = -2,
    lambdaC = log(2) / 12, hr = 0.7, hr0 = 1,
    eta = 0.01, gamma = 10, R = 16, minfup = 12, T = 28,
    method = "Schoenfeld"
  )
  design_events <- rowSums(design$eDC) + rowSums(design$eDE)

  d_rpact <- rpact::getDesignGroupSequential(
    kMax = 3, typeOfDesign = "asHSD", gammaA = -4,
    sided = 1, alpha = 0.025, beta = 0.1,
    typeBetaSpending = "bsHSD", gammaB = -2
  )

  for (h in c(0.6, 0.7, 0.8)) {
    pwr_gs <- gsSurvPower(
      x = design, hr = h, targetEvents = design_events
    )$power

    pwr_rp <- rpact::getPowerSurvival(
      d_rpact, hazardRatio = h, directionUpper = FALSE,
      lambda2 = log(2) / 12,
      accrualTime = c(0, 16), accrualIntensity = c(40),
      maxNumberOfEvents = round(design_events[3]),
      dropoutRate1 = 0.01, dropoutRate2 = 0.01,
      typeOfComputation = "Schoenfeld"
    )$overallReject

    expect_equal(pwr_gs, pwr_rp, tolerance = 0.005,
      label = paste("Schoenfeld HR =", h))
  }
})

test_that("gsSurvPower Schoenfeld ratio=2 matches rpact", {
  skip_if_not_installed("rpact")

  design <- gsSurv(
    k = 3, test.type = 4, alpha = 0.025, sided = 1, beta = 0.1,
    sfu = sfHSD, sfupar = -4, sfl = sfHSD, sflpar = -2,
    lambdaC = log(2) / 12, hr = 0.7, hr0 = 1,
    eta = 0.01, gamma = 10, R = 16, minfup = 12, T = 28,
    ratio = 2, method = "Schoenfeld"
  )
  design_events <- rowSums(design$eDC) + rowSums(design$eDE)

  d_rpact <- rpact::getDesignGroupSequential(
    kMax = 3, typeOfDesign = "asHSD", gammaA = -4,
    sided = 1, alpha = 0.025, beta = 0.1,
    typeBetaSpending = "bsHSD", gammaB = -2
  )

  for (h in c(0.6, 0.7, 0.8)) {
    pwr_gs <- gsSurvPower(
      x = design, hr = h, targetEvents = design_events
    )$power

    pwr_rp <- rpact::getPowerSurvival(
      d_rpact, hazardRatio = h, directionUpper = FALSE,
      lambda2 = log(2) / 12, allocationRatioPlanned = 2,
      accrualTime = c(0, 16), accrualIntensity = c(40),
      maxNumberOfEvents = round(design_events[3]),
      dropoutRate1 = 0.01, dropoutRate2 = 0.01,
      typeOfComputation = "Schoenfeld"
    )$overallReject

    expect_equal(pwr_gs, pwr_rp, tolerance = 0.005,
      label = paste("Schoenfeld ratio=2 HR =", h))
  }
})

test_that("gsSurvPower Freedman matches rpact getPowerSurvival", {
  skip_if_not_installed("rpact")

  design <- gsSurv(
    k = 3, test.type = 4, alpha = 0.025, sided = 1, beta = 0.1,
    sfu = sfHSD, sfupar = -4, sfl = sfHSD, sflpar = -2,
    lambdaC = log(2) / 12, hr = 0.7, hr0 = 1,
    eta = 0.01, gamma = 10, R = 16, minfup = 12, T = 28,
    method = "Freedman"
  )
  design_events <- rowSums(design$eDC) + rowSums(design$eDE)

  d_rpact <- rpact::getDesignGroupSequential(
    kMax = 3, typeOfDesign = "asHSD", gammaA = -4,
    sided = 1, alpha = 0.025, beta = 0.1,
    typeBetaSpending = "bsHSD", gammaB = -2
  )

  for (h in c(0.6, 0.7, 0.8)) {
    pwr_gs <- gsSurvPower(
      x = design, hr = h, targetEvents = design_events
    )$power

    pwr_rp <- rpact::getPowerSurvival(
      d_rpact, hazardRatio = h, directionUpper = FALSE,
      lambda2 = log(2) / 12,
      accrualTime = c(0, 16), accrualIntensity = c(40),
      maxNumberOfEvents = round(design_events[3]),
      dropoutRate1 = 0.01, dropoutRate2 = 0.01,
      typeOfComputation = "Freedman"
    )$overallReject

    expect_equal(pwr_gs, pwr_rp, tolerance = 0.005,
      label = paste("Freedman HR =", h))
  }
})

# ---- Tests for bound recalculation when parameters change ----
# When gsSurvPower uses targetEvents that match the design's information
# fractions, bounds must still be recomputed if alpha or spending parameters
# differ from the original design.

test_that("gsSurvPower recalculates bounds when alpha changes (test.type 4, non-binding)", {
  design <- gsSurv(
    k = 3, test.type = 4, alpha = 0.025, sided = 1, beta = 0.1,
    sfu = sfHSD, sfupar = -4, sfl = sfHSD, sflpar = -2,
    lambdaC = log(2) / 12, hr = 0.7, eta = 0.01,
    gamma = 10, R = 16, minfup = 12, T = 28
  )
  events <- rowSums(design$eDC) + rowSums(design$eDE)

  pwr_orig <- gsSurvPower(x = design, targetEvents = events)
  pwr_new <- gsSurvPower(x = design, alpha = 0.05, targetEvents = events)

  # Bounds must differ

  expect_false(isTRUE(all.equal(pwr_orig$upper$bound, pwr_new$upper$bound)))
  # More alpha -> less stringent efficacy bound
  expect_true(all(pwr_new$upper$bound < pwr_orig$upper$bound))
  # Cross-check: efficacy bounds match gsDesign with test.type = 1
  gs_ref <- gsDesign(
    k = 3, test.type = 1, alpha = 0.05, beta = 0.1,
    n.fix = design$n.fix, timing = design$timing,
    sfu = sfHSD, sfupar = -4,
    delta1 = log(0.7), delta0 = log(1)
  )
  expect_equal(pwr_new$upper$bound, gs_ref$upper$bound, tolerance = 1e-4)
  # Lower bounds are kept from original, clipped where they would exceed upper
  expect_equal(pwr_new$lower$bound, pmin(design$lower$bound, pwr_new$upper$bound))
})

test_that("gsSurvPower recalculates bounds when alpha changes (test.type 3, binding)", {
  design <- gsSurv(
    k = 3, test.type = 3, alpha = 0.025, sided = 1, beta = 0.1,
    sfu = sfHSD, sfupar = -4, sfl = sfHSD, sflpar = -2,
    lambdaC = log(2) / 12, hr = 0.7, eta = 0.01,
    gamma = 10, R = 16, minfup = 12, T = 28
  )
  events <- rowSums(design$eDC) + rowSums(design$eDE)

  pwr_orig <- gsSurvPower(x = design, targetEvents = events)
  pwr_new <- gsSurvPower(x = design, alpha = 0.05, targetEvents = events)

  # Efficacy bounds must differ
  expect_false(isTRUE(all.equal(pwr_orig$upper$bound, pwr_new$upper$bound)))
  # Lower bounds preserved from original (clipped where needed)
  expect_equal(pwr_new$lower$bound,
    pmin(design$lower$bound, pwr_new$upper$bound))
  # Cross-check efficacy bounds with gsDesign test.type = 1
  gs_ref <- gsDesign(
    k = 3, test.type = 1, alpha = 0.05, beta = 0.1,
    n.fix = design$n.fix, timing = design$timing,
    sfu = sfHSD, sfupar = -4,
    delta1 = log(0.7), delta0 = log(1)
  )
  expect_equal(pwr_new$upper$bound, gs_ref$upper$bound, tolerance = 1e-4)
})

test_that("gsSurvPower recalculates bounds when alpha changes (test.type 1, one-sided)", {
  design <- gsSurv(
    k = 3, test.type = 1, alpha = 0.025, sided = 1, beta = 0.1,
    sfu = sfHSD, sfupar = -4,
    lambdaC = log(2) / 12, hr = 0.7, eta = 0.01,
    gamma = 10, R = 16, minfup = 12, T = 28
  )
  events <- rowSums(design$eDC) + rowSums(design$eDE)

  pwr_orig <- gsSurvPower(x = design, targetEvents = events)
  pwr_new <- gsSurvPower(x = design, alpha = 0.05, targetEvents = events)

  expect_false(isTRUE(all.equal(pwr_orig$upper$bound, pwr_new$upper$bound)))
  expect_true(all(pwr_new$upper$bound < pwr_orig$upper$bound))
  expect_true(pwr_new$power > pwr_orig$power)
})

test_that("gsSurvPower recalculates bounds when alpha changes (test.type 5, binding alpha-spending lower)", {
  # Default gsSurv test.type 5 sets astar = 1 - alpha (= 0.975).
  # gsSurvPower now uses test.type = 1 for efficacy, avoiding astar issues.
  design <- gsSurv(
    k = 3, test.type = 5, alpha = 0.025, sided = 1, beta = 0.1,
    sfu = sfHSD, sfupar = -4, sfl = sfHSD, sflpar = -2,
    lambdaC = log(2) / 12, hr = 0.7, eta = 0.01,
    gamma = 10, R = 16, minfup = 12, T = 28
  )
  events <- rowSums(design$eDC) + rowSums(design$eDE)

  pwr_orig <- gsSurvPower(x = design, targetEvents = events)
  pwr_new <- gsSurvPower(x = design, alpha = 0.05, targetEvents = events)

  expect_false(isTRUE(all.equal(pwr_orig$upper$bound, pwr_new$upper$bound)))
  # Lower bounds preserved from original (clipped where needed)
  expect_equal(pwr_new$lower$bound,
    pmin(design$lower$bound, pwr_new$upper$bound))
  # Cross-check efficacy with gsDesign test.type = 1
  gs_ref <- gsDesign(
    k = 3, test.type = 1, alpha = 0.05, beta = 0.1,
    n.fix = design$n.fix, timing = design$timing,
    sfu = sfHSD, sfupar = -4,
    delta1 = log(0.7), delta0 = log(1)
  )
  expect_equal(pwr_new$upper$bound, gs_ref$upper$bound, tolerance = 1e-4)
})

test_that("gsSurvPower preserves test.type and alpha in output when alpha changes", {
  for (tt in c(3, 4, 5)) {
    design <- gsSurv(
      k = 3, test.type = tt, alpha = 0.025, sided = 1, beta = 0.1,
      sfu = sfHSD, sfupar = -4, sfl = sfHSD, sflpar = -2,
      lambdaC = log(2) / 12, hr = 0.7, eta = 0.01,
      gamma = 10, R = 16, minfup = 12, T = 28
    )
    events <- rowSums(design$eDC) + rowSums(design$eDE)

    pwr <- gsSurvPower(x = design, alpha = 0.05, targetEvents = events)

    expect_equal(pwr$test.type, tt, label = paste("test.type preserved for tt =", tt))
    expect_equal(pwr$alpha, 0.05, label = paste("alpha updated for tt =", tt))
  }
})

test_that("gsSurvPower recalculates bounds when sfupar changes", {
  design <- gsSurv(
    k = 3, test.type = 4, alpha = 0.025, sided = 1, beta = 0.1,
    sfu = sfHSD, sfupar = -4, sfl = sfHSD, sflpar = -2,
    lambdaC = log(2) / 12, hr = 0.7, eta = 0.01,
    gamma = 10, R = 16, minfup = 12, T = 28
  )
  events <- rowSums(design$eDC) + rowSums(design$eDE)

  pwr_orig <- gsSurvPower(x = design, targetEvents = events)
  # Different upper spending parameter (less conservative)
  pwr_new <- gsSurvPower(x = design, sfupar = -2, targetEvents = events)

  expect_false(isTRUE(all.equal(pwr_orig$upper$bound, pwr_new$upper$bound)))
})

test_that("gsSurvPower keeps lower bounds when sflpar changes (x provided)", {
  design <- gsSurv(
    k = 3, test.type = 3, alpha = 0.025, sided = 1, beta = 0.1,
    sfu = sfHSD, sfupar = -4, sfl = sfHSD, sflpar = -2,
    lambdaC = log(2) / 12, hr = 0.7, eta = 0.01,
    gamma = 10, R = 16, minfup = 12, T = 28
  )
  events <- rowSums(design$eDC) + rowSums(design$eDE)

  pwr_orig <- gsSurvPower(x = design, targetEvents = events)
  # Changing sflpar triggers recalculation, but lower bounds are
  # kept from original design (gsBoundSummary approach).
  pwr_new <- gsSurvPower(x = design, sflpar = -4, targetEvents = events)

  # Lower bounds unchanged (from original design)
  expect_equal(pwr_new$lower$bound, design$lower$bound)
  # Upper bounds also unchanged (same alpha + sfu + sfupar)
  expect_equal(pwr_new$upper$bound, design$upper$bound)
})

test_that("gsSurvPower recalculates bounds when sfu changes", {
  design <- gsSurv(
    k = 3, test.type = 4, alpha = 0.025, sided = 1, beta = 0.1,
    sfu = sfHSD, sfupar = -4, sfl = sfHSD, sflpar = -2,
    lambdaC = log(2) / 12, hr = 0.7, eta = 0.01,
    gamma = 10, R = 16, minfup = 12, T = 28
  )
  events <- rowSums(design$eDC) + rowSums(design$eDE)

  pwr_orig <- gsSurvPower(x = design, targetEvents = events)
  # Switch from HSD to O'Brien-Fleming
  pwr_new <- gsSurvPower(x = design, sfu = sfLDOF, targetEvents = events)

  expect_false(isTRUE(all.equal(pwr_orig$upper$bound, pwr_new$upper$bound)))
})

test_that("gsSurvPower reuses bounds when no design parameters change", {
  design <- gsSurv(
    k = 3, test.type = 4, alpha = 0.025, sided = 1, beta = 0.1,
    sfu = sfHSD, sfupar = -4, sfl = sfHSD, sflpar = -2,
    lambdaC = log(2) / 12, hr = 0.7, eta = 0.01,
    gamma = 10, R = 16, minfup = 12, T = 28
  )
  events <- rowSums(design$eDC) + rowSums(design$eDE)

  # Same alpha, same everything -- bounds should be reused exactly
  pwr <- gsSurvPower(x = design, targetEvents = events)
  expect_equal(pwr$upper$bound, design$upper$bound)
  expect_equal(pwr$lower$bound, design$lower$bound)

  # Different HR doesn't affect bounds when timing matches
  pwr_hr <- gsSurvPower(x = design, hr = 0.8, targetEvents = events)
  expect_equal(pwr_hr$upper$bound, design$upper$bound)
  expect_equal(pwr_hr$lower$bound, design$lower$bound)
  # But power differs
  expect_false(isTRUE(all.equal(pwr$power, pwr_hr$power)))
})

test_that("gsSurvPower alpha change with plannedCalendarTime works same as targetEvents", {
  design <- gsSurv(
    k = 3, test.type = 4, alpha = 0.025, sided = 1, beta = 0.1,
    sfu = sfHSD, sfupar = -4, sfl = sfHSD, sflpar = -2,
    lambdaC = log(2) / 12, hr = 0.7, eta = 0.01,
    gamma = 10, R = 16, minfup = 12, T = 28
  )

  # Use plannedCalendarTime (timing will match design)
  pwr <- gsSurvPower(x = design, alpha = 0.05, plannedCalendarTime = design$T)

  # Bounds must differ from original
  expect_false(isTRUE(all.equal(pwr$upper$bound, design$upper$bound)))
  expect_true(all(pwr$upper$bound < design$upper$bound))
})

test_that("gsSurvPower alpha matches gsBoundSummary approach for binding type 3", {
  design <- gsSurv(
    k = 3, test.type = 3, alpha = 0.025, sided = 1, beta = 0.1,
    sfu = sfHSD, sfupar = -4, sfl = sfHSD, sflpar = -2,
    lambdaC = log(2) / 12, hr = 0.7, eta = 0.01,
    gamma = 10, R = 16, minfup = 12, T = 28
  )
  events <- rowSums(design$eDC) + rowSums(design$eDE)

  pwr <- gsSurvPower(x = design, alpha = 0.05, targetEvents = events)

  # gsBoundSummary computes efficacy at alternate alpha via gsDesign
  # with test.type = 1, then keeps original lower bounds.
  # gsSurvPower now follows the same approach.
  gs_ref <- gsDesign(
    k = 3, test.type = 1, alpha = 0.05, beta = 0.1,
    n.fix = design$n.fix, timing = design$timing,
    sfu = sfHSD, sfupar = -4,
    delta1 = log(0.7), delta0 = log(1)
  )
  expect_equal(pwr$upper$bound, gs_ref$upper$bound, tolerance = 1e-4)
  # Lower bounds preserved from original (clipped at final where lower = upper)
  expect_equal(pwr$lower$bound,
    pmin(design$lower$bound, pwr$upper$bound))
})

test_that("gsSurvPower recalculates both bounds when timing changes", {
  design <- gsSurv(
    k = 3, test.type = 4, alpha = 0.025, sided = 1, beta = 0.1,
    sfu = sfHSD, sfupar = -4, sfl = sfHSD, sflpar = -2,
    lambdaC = log(2) / 12, hr = 0.7, eta = 0.01,
    gamma = 10, R = 16, minfup = 12, T = 28
  )

  # Use different targetEvents so timing changes
  design_events <- rowSums(design$eDC) + rowSums(design$eDE)
  new_events <- design_events * c(0.5, 0.8, 1)

  pwr <- gsSurvPower(x = design, targetEvents = new_events)

  # Timing has changed, so both bounds should be recomputed
  expect_false(isTRUE(all.equal(pwr$timing, design$timing)))
  expect_false(isTRUE(all.equal(pwr$upper$bound, design$upper$bound)))
  expect_false(isTRUE(all.equal(pwr$lower$bound, design$lower$bound)))

  # Cross-check: bounds should match gsDesign at the new timing
  gs_ref <- gsDesign(
    k = 3, test.type = 4, alpha = 0.025, beta = 0.1,
    n.fix = design$n.fix, timing = pwr$timing,
    sfu = sfHSD, sfupar = -4, sfl = sfHSD, sflpar = -2,
    delta1 = log(0.7), delta0 = log(1)
  )
  expect_equal(pwr$upper$bound, gs_ref$upper$bound, tolerance = 1e-3)
  expect_equal(pwr$lower$bound, gs_ref$lower$bound, tolerance = 1e-3)
})

test_that("gsSurvPower recalculates both bounds when timing changes (binding type 3)", {
  design <- gsSurv(
    k = 3, test.type = 3, alpha = 0.025, sided = 1, beta = 0.1,
    sfu = sfHSD, sfupar = -4, sfl = sfHSD, sflpar = -2,
    lambdaC = log(2) / 12, hr = 0.7, eta = 0.01,
    gamma = 10, R = 16, minfup = 12, T = 28
  )

  # Different target events -> different timing -> full recalculation
  design_events <- rowSums(design$eDC) + rowSums(design$eDE)
  new_events <- design_events * c(0.5, 0.8, 1)

  pwr <- gsSurvPower(x = design, targetEvents = new_events)

  expect_false(isTRUE(all.equal(pwr$timing, design$timing)))
  # Both bounds should differ from original
  expect_false(isTRUE(all.equal(pwr$upper$bound, design$upper$bound)))
  expect_false(isTRUE(all.equal(pwr$lower$bound, design$lower$bound)))
})

# ---- test.type 7 and 8 (harm bounds) ----

test_that("gsSurvPower works with test.type = 7 (binding futility + harm)", {
  design7 <- gsSurv(
    k = 3, test.type = 7, alpha = 0.025, sided = 1, beta = 0.1,
    sfu = sfHSD, sfupar = -4, sfl = sfHSD, sflpar = -2,
    sfharm = sfHSD, sfharmparam = -2,
    lambdaC = log(2) / 12, hr = 0.7, eta = 0.01,
    gamma = 10, R = 16, minfup = 12, T = 28
  )

  pwr <- gsSurvPower(x = design7, plannedCalendarTime = design7$T)
  expect_s3_class(pwr, "gsSurv")
  expect_equal(pwr$test.type, 7)
  expect_true(pwr$power > 0 && pwr$power < 1)
  # Harm bounds should be present
  expect_false(is.null(pwr$harm))
  expect_equal(length(pwr$harm$bound), 3)
})

test_that("gsSurvPower works with test.type = 8 (non-binding futility + harm)", {
  design8 <- gsSurv(
    k = 3, test.type = 8, alpha = 0.025, sided = 1, beta = 0.1,
    sfu = sfHSD, sfupar = -4, sfl = sfHSD, sflpar = -2,
    sfharm = sfHSD, sfharmparam = -2,
    lambdaC = log(2) / 12, hr = 0.7, eta = 0.01,
    gamma = 10, R = 16, minfup = 12, T = 28
  )

  pwr <- gsSurvPower(x = design8, plannedCalendarTime = design8$T)
  expect_s3_class(pwr, "gsSurv")
  expect_equal(pwr$test.type, 8)
  expect_true(pwr$power > 0 && pwr$power < 1)
  expect_false(is.null(pwr$harm))
})

test_that("gsSurvPower test.type 7: reuses bounds when params match", {
  design7 <- gsSurv(
    k = 3, test.type = 7, alpha = 0.025, sided = 1, beta = 0.1,
    sfu = sfHSD, sfupar = -4, sfl = sfHSD, sflpar = -2,
    sfharm = sfHSD, sfharmparam = -2,
    lambdaC = log(2) / 12, hr = 0.7, eta = 0.01,
    gamma = 10, R = 16, minfup = 12, T = 28
  )
  design_events <- rowSums(design7$eDC) + rowSums(design7$eDE)
  pwr <- gsSurvPower(x = design7, targetEvents = design_events)
  expect_identical(pwr$upper$bound, design7$upper$bound)
  expect_identical(pwr$lower$bound, design7$lower$bound)
  expect_identical(pwr$harm$bound, design7$harm$bound)
})

test_that("gsSurvPower test.type 7: alpha change preserves futility and harm", {
  design7 <- gsSurv(
    k = 3, test.type = 7, alpha = 0.025, sided = 1, beta = 0.1,
    sfu = sfHSD, sfupar = -4, sfl = sfHSD, sflpar = -2,
    sfharm = sfHSD, sfharmparam = -2,
    lambdaC = log(2) / 12, hr = 0.7, eta = 0.01,
    gamma = 10, R = 16, minfup = 12, T = 28
  )
  design_events <- rowSums(design7$eDC) + rowSums(design7$eDE)
  pwr <- gsSurvPower(x = design7, alpha = 0.05, targetEvents = design_events)
  # Efficacy bounds should change
  expect_false(isTRUE(all.equal(pwr$upper$bound, design7$upper$bound)))
  # Futility bounds preserved (clipped if needed)
  expect_true(all(pwr$lower$bound <= pwr$upper$bound))
  # Harm bounds preserved from original
  expect_equal(pwr$harm$bound, design7$harm$bound)
})

test_that("gsSurvPower test.type 8: timing changed recomputes all bounds", {
  design8 <- gsSurv(
    k = 3, test.type = 8, alpha = 0.025, sided = 1, beta = 0.1,
    sfu = sfHSD, sfupar = -4, sfl = sfHSD, sflpar = -2,
    sfharm = sfHSD, sfharmparam = -2,
    lambdaC = log(2) / 12, hr = 0.7, eta = 0.01,
    gamma = 10, R = 16, minfup = 12, T = 28
  )
  design_events <- rowSums(design8$eDC) + rowSums(design8$eDE)
  new_events <- design_events * c(0.5, 0.8, 1)

  pwr <- gsSurvPower(x = design8, targetEvents = new_events)
  expect_false(isTRUE(all.equal(pwr$timing, design8$timing)))
  # All bounds recomputed
  expect_false(isTRUE(all.equal(pwr$upper$bound, design8$upper$bound)))
  expect_false(is.null(pwr$harm))
})

test_that("gsSurvPower test.type 7 without x reference design", {
  pwr <- gsSurvPower(
    k = 3, test.type = 7, alpha = 0.025, sided = 1,
    sfu = sfHSD, sfupar = -4, sfl = sfHSD, sflpar = -2,
    sfharm = sfHSD, sfharmparam = -2,
    lambdaC = log(2) / 12, hr = 0.7, eta = 0.01,
    gamma = 10, R = 16, ratio = 1,
    plannedCalendarTime = c(12, 24, 36)
  )
  expect_s3_class(pwr, "gsSurv")
  expect_equal(pwr$test.type, 7)
  expect_false(is.null(pwr$harm))
  expect_true(pwr$power > 0 && pwr$power < 1)
})

test_that("gsSurvPower preserves testHarm on output for test.type 7/8", {
  design7 <- gsSurv(
    k = 3, test.type = 7, alpha = 0.025, sided = 1, beta = 0.1,
    sfu = sfHSD, sfupar = -4, sfl = sfHSD, sflpar = -2,
    sfharm = sfHSD, sfharmparam = -2,
    lambdaC = log(2) / 12, hr = 0.7, eta = 0.01,
    gamma = 10, R = 16, minfup = 12, T = 28,
    testHarm = c(TRUE, TRUE, FALSE)
  )
  pwr <- gsSurvPower(x = design7, plannedCalendarTime = design7$T)
  expect_equal(pwr$testHarm, c(TRUE, TRUE, FALSE))
})

# --- alpha / sided convention tests ---

test_that("gsSurvPower inherits one-sided alpha from x without conversion", {
  design <- gsSurv(
    k = 3, test.type = 4, alpha = 0.025, sided = 1, beta = 0.1,
    lambdaC = log(2) / 6, hr = 0.6, eta = 0.01,
    gamma = 10, R = 12, minfup = 18, T = 30
  )
  pwr <- gsSurvPower(x = design, plannedCalendarTime = design$T)
  # Stored alpha should match the one-sided alpha from design
  expect_equal(pwr$alpha, design$alpha)
  # Power should reproduce the design
  expect_equal(pwr$power, 1 - design$beta, tolerance = 1e-4)
})

test_that("user-provided alpha is divided by sided (sided=1)", {
  design <- gsSurv(
    k = 3, test.type = 4, alpha = 0.025, sided = 1, beta = 0.1,
    lambdaC = log(2) / 6, hr = 0.6, eta = 0.01,
    gamma = 10, R = 12, minfup = 18, T = 30
  )
  # alpha=0.05 with sided=1 → one-sided alpha = 0.05
  pwr <- gsSurvPower(
    x = design, alpha = 0.05,
    plannedCalendarTime = design$T
  )
  expect_equal(pwr$alpha, 0.05)
  # Efficacy bounds should be less strict than the original
  pwr_orig <- gsSurvPower(x = design, plannedCalendarTime = design$T)
  expect_true(all(pwr$upper$bound < pwr_orig$upper$bound))
})

test_that("user-provided alpha is divided by sided (sided=2)", {
  design <- gsSurv(
    k = 3, test.type = 4, alpha = 0.025, sided = 1, beta = 0.1,
    lambdaC = log(2) / 6, hr = 0.6, eta = 0.01,
    gamma = 10, R = 12, minfup = 18, T = 30
  )
  # alpha=0.05, sided=2 → one-sided alpha = 0.025 (same as design)
  pwr <- gsSurvPower(
    x = design, alpha = 0.05, sided = 2,
    plannedCalendarTime = design$T
  )
  expect_equal(pwr$alpha, 0.025)
  expect_equal(pwr$sided, 2)
  # Should match the original design power
  expect_equal(pwr$power, 1 - design$beta, tolerance = 1e-4)
})

test_that("standalone alpha follows gsSurv convention", {
  pwr1 <- gsSurvPower(
    k = 2, test.type = 1, alpha = 0.025, sided = 1,
    lambdaC = log(2) / 6, hr = 0.65, eta = 0.01,
    gamma = 8, R = 18, ratio = 1,
    plannedCalendarTime = c(24, 36)
  )
  # alpha=0.05, sided=2 should give same one-sided alpha=0.025
  pwr2 <- gsSurvPower(
    k = 2, test.type = 1, alpha = 0.05, sided = 2,
    lambdaC = log(2) / 6, hr = 0.65, eta = 0.01,
    gamma = 8, R = 18, ratio = 1,
    plannedCalendarTime = c(24, 36)
  )
  expect_equal(pwr1$alpha, 0.025)
  expect_equal(pwr2$alpha, 0.025)
  expect_equal(pwr1$power, pwr2$power, tolerance = 1e-6)
})

test_that("gsSurvPower matches gsBoundSummary for alternate alpha", {
  design <- gsSurv(
    k = 3, test.type = 4, alpha = 0.025, sided = 1, beta = 0.1,
    lambdaC = log(2) / 6, hr = 0.6, eta = 0.01,
    gamma = 10, R = 12, minfup = 18, T = 30
  )
  # gsBoundSummary uses one-sided alpha directly;
  # gsSurvPower with sided=1 (default from x) should match
  pwr_a05 <- gsSurvPower(
    x = design, alpha = 0.05,
    targetEvents = design$n.I
  )
  # Cross-check: gsDesign with test.type=1 at same alpha
  gs_check <- gsDesign(
    k = design$k, test.type = 1, alpha = 0.05, beta = design$beta,
    n.fix = design$n.fix, timing = design$timing,
    sfu = design$upper$sf, sfupar = design$upper$param, r = design$r,
    delta1 = log(design$hr), delta0 = log(design$hr0)
  )
  expect_equal(pwr_a05$upper$bound, gs_check$upper$bound, tolerance = 1e-3)
})

test_that("alternate alpha preserves a selective efficacy schedule", {
  design <- gsSurv(
    k = 3, test.type = 4, alpha = 0.025, sided = 1, beta = 0.1,
    lambdaC = log(2) / 6, hr = 0.6, eta = 0.01,
    gamma = 10, R = 12, minfup = 18, T = 30,
    testUpper = c(FALSE, TRUE, TRUE)
  )
  pwr_a05 <- gsSurvPower(
    x = design, alpha = 0.05,
    targetEvents = design$n.I
  )

  summary_a05 <- gsBoundSummary(design, alpha = 0.05, digits = 8)
  z_rows <- which(summary_a05$Value == "Z")

  expect_equal(pwr_a05$testUpper, c(FALSE, TRUE, TRUE))
  expect_equal(pwr_a05$upper$bound[1], 20)
  expect_lt(max(pwr_a05$upper$prob[1, ]), 1e-20)
  expect_true(is.na(summary_a05[["\u03b1=0.05"]][z_rows[1]]))
  expect_equal(
    pwr_a05$upper$bound[2:3],
    summary_a05[["\u03b1=0.05"]][z_rows[2:3]],
    tolerance = 1e-3
  )
})

test_that("sided defaults to x$sided when stored on gsSurvPower output", {
  pwr1 <- gsSurvPower(
    k = 2, test.type = 4, alpha = 0.05, sided = 2,
    lambdaC = log(2) / 6, hr = 0.65, eta = 0.01,
    gamma = 8, R = 18, ratio = 1,
    plannedCalendarTime = c(24, 36)
  )
  # pwr1 stores sided=2 and one-sided alpha=0.025
  expect_equal(pwr1$sided, 2)
  expect_equal(pwr1$alpha, 0.025)

  # When re-passed as x, sided=2 should be inherited
  pwr2 <- gsSurvPower(x = pwr1, plannedCalendarTime = pwr1$T)
  expect_equal(pwr2$sided, 2)
  expect_equal(pwr2$alpha, pwr1$alpha)
})

# ---- targetN ----

test_that("targetN rescales R to match target sample size", {
  design <- gsSurv(
    k = 3, test.type = 4, alpha = 0.025, sided = 1, beta = 0.1,
    lambdaC = log(2) / 12, hr = 0.7, eta = 0.01,
    gamma = 10, R = 16, minfup = 12, T = 28
  )
  total_N <- sum(as.numeric(design$gamma) * design$R)

  pwr_targetN <- gsSurvPower(
    x = design,
    gamma = design$gamma / 2,
    targetN = total_N,
    targetEvents = design$n.I
  )
  pwr_manual <- gsSurvPower(
    x = design,
    gamma = design$gamma / 2,
    R = 2 * design$R,
    targetEvents = design$n.I
  )

  expect_equal(pwr_targetN$R, 2 * design$R, tolerance = 1e-10)
  expect_equal(pwr_targetN$power, pwr_manual$power, tolerance = 1e-10)
  expect_equal(pwr_targetN$T, pwr_manual$T, tolerance = 1e-6)
  expect_equal(pwr_targetN$n.I, pwr_manual$n.I, tolerance = 1e-6)
})

test_that("targetN errors when R is also specified", {
  design <- gsSurv(
    k = 3, test.type = 4, alpha = 0.025, sided = 1, beta = 0.1,
    lambdaC = log(2) / 12, hr = 0.7, eta = 0.01,
    gamma = 10, R = 16, minfup = 12, T = 28
  )

  expect_error(
    gsSurvPower(x = design, R = 32, targetN = 160, targetEvents = design$n.I),
    "Cannot specify both R and targetN"
  )
})

test_that("targetN works with multi-period enrollment", {
  design <- gsSurv(
    k = 2, test.type = 4, alpha = 0.025, sided = 1, beta = 0.1,
    lambdaC = log(2) / 12, hr = 0.7, eta = 0.01,
    gamma = c(5, 10), R = c(4, 12), minfup = 12, T = 28
  )
  total_N <- sum(design$gamma * design$R)

  # Triple the enrollment rate, keep sample size
  pwr <- gsSurvPower(
    x = design,
    gamma = design$gamma * 3,
    targetN = total_N,
    targetEvents = design$n.I
  )

  # R should be uniformly scaled by 1/3
  expect_equal(pwr$R, design$R / 3, tolerance = 1e-10)
  # Total enrollment should match
  expect_equal(sum(as.numeric(pwr$gamma) * pwr$R), total_N, tolerance = 1e-6)
})

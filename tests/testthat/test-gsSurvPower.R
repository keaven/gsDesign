test_that("gsSurvPower works with plannedCalendarTime from gsSurv design", {
  design <- gsSurv(
    k = 3, test.type = 4, alpha = 0.025, sided = 1, beta = 0.1,
    sfu = sfHSD, sfupar = -4,
    sfl = sfHSD, sflpar = -2,
    lambdaC = log(2) / 6, hr = 0.6, hr0 = 1,
    eta = 0.01, gamma = 10, R = 12, minfup = 18, T = 30
  )

  pwr <- gsSurvPower(x = design, plannedCalendarTime = design$T)
  expect_s3_class(pwr, "gsSurv")
  expect_s3_class(pwr, "gsDesign")
  expect_equal(pwr$k, 3)
  expect_true(pwr$power > 0 && pwr$power < 1)
  expect_equal(pwr$hr, design$hr)
  expect_equal(pwr$hr1, design$hr)
  expect_equal(pwr$variable, "Power")
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
  expect_true(all(events > 0))
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
  suppressWarnings({
    pwr <- gsSurvPower(
      k = 2, test.type = 1, alpha = 0.025, sided = 1,
      lambdaC = log(2) / 12, hr = 0.7, hr0 = 1,
      gamma = 5, R = 12, ratio = 1,
      plannedCalendarTime = c(12, 24),
      targetEvents = c(20, 500),
      maxExtension = c(NA, 6),
      minTimeFromPreviousAnalysis = c(NA, 18)
    )
  })
  expect_true(pwr$T[2] <= 24 + 6 + 1e-6)
  events_2 <- sum(pwr$eDC[2, ] + pwr$eDE[2, ])
  expect_true(events_2 < 500)
})

test_that("gsSurvPower with calendar spending", {
  pwr_info <- gsSurvPower(
    k = 2, test.type = 1, alpha = 0.025, sided = 1,
    lambdaC = log(2) / 6, hr = 0.7, hr0 = 1,
    gamma = 10, R = 12, ratio = 1,
    plannedCalendarTime = c(24, 36),
    spending = "information"
  )
  pwr_cal <- gsSurvPower(
    k = 2, test.type = 1, alpha = 0.025, sided = 1,
    lambdaC = log(2) / 6, hr = 0.7, hr0 = 1,
    gamma = 10, R = 12, ratio = 1,
    plannedCalendarTime = c(24, 36),
    spending = "calendar"
  )
  expect_s3_class(pwr_info, "gsSurv")
  expect_s3_class(pwr_cal, "gsSurv")
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

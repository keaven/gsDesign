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

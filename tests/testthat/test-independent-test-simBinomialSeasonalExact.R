seasonal_design_for_sim <- function(test.type = 4) {
  gsSurv(
    k = 3,
    test.type = test.type,
    alpha = 0.025,
    beta = 0.1,
    timing = c(1 / 3, 2 / 3),
    sfu = sfHSD,
    sfupar = 1,
    sfl = sfHSD,
    sflpar = -2,
    lambdaC = -log(1 - 0.003) / 0.5,
    hr = 0.2,
    hr0 = 0.7,
    eta = -log(1 - 0.1) / 0.5,
    gamma = c(1, 0, 1, 0, 1, 0),
    R = c(2, 10, 2, 10, 2, 10),
    T = 42,
    minfup = 6,
    ratio = 3
  ) |>
    toInteger()
}

one_sided_design_for_sim <- function() {
  gsSurv(
    k = 3,
    test.type = 1,
    alpha = 0.025,
    beta = 0.1,
    timing = c(0.45, 0.7),
    sfu = sfHSD,
    sfupar = -4,
    lambdaC = 0.001,
    hr = 0.3,
    hr0 = 0.7,
    eta = 5e-04,
    gamma = 10,
    R = 16,
    T = 24,
    minfup = 8,
    ratio = 3
  ) |>
    toInteger()
}

planned_total_enrollment_by_season <- function(design) {
  period_total <- as.numeric(rowSums(as.matrix(design$gamma))) * as.numeric(design$R)
  periods_per_look <- length(period_total) / design$k
  groups <- rep(seq_len(design$k), each = periods_per_look)
  as.integer(round(tapply(period_total, groups, sum)))
}

test_that("simBinomialSeasonalExact validates core inputs", {
  design <- seasonal_design_for_sim()

  expect_error(
    simBinomialSeasonalExact(gsD = list()),
    "object of class gsSurv"
  )

  expect_error(
    simBinomialSeasonalExact(gsD = design, ve = c(0.3, 1)),
    "finite values less than 1"
  )
  expect_no_error(
    simBinomialSeasonalExact(gsD = design, ve = c(0, 0.3), nsim = c(1, 1))
  )
  expect_no_error(
    simBinomialSeasonalExact(
      gsD = design,
      ve = c(-0.1, 0, 0.3),
      nsim = c(1, 1, 1),
      control_event_rate = 0.003
    )
  )
  expect_error(
    simBinomialSeasonalExact(gsD = design, ve = -10, nsim = 1, control_event_rate = 0.5),
    "experimental event rates outside"
  )

  expect_error(
    simBinomialSeasonalExact(gsD = design, nsim = c(10, 10, 10)),
    "one value per ve scenario"
  )

  expect_error(
    simBinomialSeasonalExact(gsD = design, planned_counts = c(20, 20, 30)),
    "increasing vector of positive integers"
  )

  expect_error(
    simBinomialSeasonalExact(gsD = design, final_full_spending = c(TRUE, FALSE)),
    "TRUE or FALSE"
  )
  expect_error(
    simBinomialSeasonalExact(gsD = design, usTime = c(0.4, 0.3, 1)),
    "strictly increasing and positive"
  )
  expect_error(
    simBinomialSeasonalExact(gsD = design, usTime = 0.3),
    "must have length k or k-1"
  )
  expect_error(
    simBinomialSeasonalExact(
      gsD = one_sided_design_for_sim(),
      lsTime = c(0.2, 0.6, 1)
    ),
    "test.type = 4"
  )
})

test_that("simBinomialSeasonalExact returns expected structure", {
  design <- seasonal_design_for_sim()
  x <- simBinomialSeasonalExact(
    gsD = design,
    ve = c(`H0 (VE=30%)` = 0.3, `H1 (VE=80%)` = 0.8),
    nsim = c(20, 20),
    control_event_rate = c(0.003, 0.003),
    adaptive = c(FALSE, TRUE),
    seed = 123
  )

  expect_type(x, "list")
  expect_true(all(c("summary", "planned", "inputs", "trials") %in% names(x)))
  expect_true(is.data.frame(x$summary))
  expect_equal(nrow(x$summary), 4)
  expect_true(all(c(
    "scenario", "ve", "control_event_rate", "adaptive", "nsim",
    "rejection_rate", "mc_se", "futility_stop_rate", "futility_mc_se", "mean_total_events",
    "mean_total_enrolled", "mean_looks"
  ) %in% colnames(x$summary)))
  expect_true(all(x$summary$futility_stop_rate >= 0))
  expect_true(all(x$summary$futility_stop_rate <= 1))
  expect_true("usTime" %in% names(x$inputs))
  expect_true("lsTime" %in% names(x$inputs))
  expect_null(x$trials)
})

test_that("simBinomialSeasonalExact defaults to the design seasonal enrollment plan", {
  design <- seasonal_design_for_sim()
  x <- simBinomialSeasonalExact(
    gsD = design,
    ve = c(`H1 (VE=80%)` = 0.8),
    nsim = 5,
    control_event_rate = 0.003,
    adaptive = FALSE,
    seed = 123
  )
  planned_total <- planned_total_enrollment_by_season(design)

  expect_equal(
    x$planned$enroll_control_per_look + x$planned$enroll_experimental_per_look,
    planned_total
  )
  expect_lte(x$summary$mean_total_enrolled[1], sum(planned_total))
})

test_that("simBinomialSeasonalExact reports stopping totals at first crossed bound", {
  design <- gsSurv(
    k = 2,
    test.type = 4,
    alpha = 0.025,
    beta = 0.1,
    timing = 0.5,
    sfu = sfHSD,
    sfupar = 1,
    sfl = sfHSD,
    sflpar = -2,
    lambdaC = -log(1 - 0.2) / 0.5,
    hr = 0.5,
    hr0 = 0.9,
    eta = 0,
    gamma = c(10, 10),
    R = c(1, 1),
    T = 3,
    minfup = 1,
    ratio = 1
  ) |>
    toInteger()

  x <- simBinomialSeasonalExact(
    gsD = design,
    ve = 0.01,
    nsim = 5,
    control_event_rate = 0.2,
    season_length = 0.5,
    dropout_rate = 0,
    adaptive = FALSE,
    seed = 2,
    return_trials = TRUE
  )

  full_enrollment <- sum(x$planned$enroll_control_per_look + x$planned$enroll_experimental_per_look)
  first_look_enrollment <- x$planned$enroll_control_per_look[1] + x$planned$enroll_experimental_per_look[1]

  expect_true(any(x$trials$futility_stop))
  expect_lte(max(x$trials$looks), design$k)
  expect_lte(max(x$trials$total_enrolled), full_enrollment)
  expect_true(any(x$trials$total_enrolled == first_look_enrollment))
})

test_that("simBinomialSeasonalExact is reproducible with seed", {
  design <- seasonal_design_for_sim()
  x1 <- simBinomialSeasonalExact(
    gsD = design,
    ve = c(0.3, 0.8),
    nsim = c(20, 20),
    seed = 999
  )
  x2 <- simBinomialSeasonalExact(
    gsD = design,
    ve = c(0.3, 0.8),
    nsim = c(20, 20),
    seed = 999
  )
  expect_equal(x1$summary, x2$summary)
})

test_that("adaptive simulation can increase enrollment in low-event scenarios", {
  design <- seasonal_design_for_sim()
  x <- simBinomialSeasonalExact(
    gsD = design,
    ve = c(`H1 (VE=80%)` = 0.8),
    nsim = 80,
    control_event_rate = 0.0015,
    adaptive = c(FALSE, TRUE),
    seed = 321
  )
  fixed <- subset(x$summary, !adaptive)
  adapt <- subset(x$summary, adaptive)

  expect_true(nrow(fixed) == 1 && nrow(adapt) == 1)
  expect_gte(adapt$mean_total_enrolled, fixed$mean_total_enrolled)
})

test_that("final_full_spending can increase rejection in final under-run settings", {
  design <- seasonal_design_for_sim()
  planned <- toInteger(design)$n.I
  under_run <- c(planned[1], planned[2], planned[3] - 5L)

  no_full <- simBinomialSeasonalExact(
    gsD = design,
    ve = c(`H1 (VE=80%)` = 0.8),
    nsim = 80,
    control_event_rate = 0.003,
    planned_counts = under_run,
    adaptive = FALSE,
    final_full_spending = FALSE,
    seed = 777
  )
  with_full <- simBinomialSeasonalExact(
    gsD = design,
    ve = c(`H1 (VE=80%)` = 0.8),
    nsim = 80,
    control_event_rate = 0.003,
    planned_counts = under_run,
    adaptive = FALSE,
    final_full_spending = TRUE,
    seed = 777
  )

  expect_gte(
    with_full$summary$rejection_rate[1],
    no_full$summary$rejection_rate[1]
  )
})

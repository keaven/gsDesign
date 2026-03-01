testthat::context("Survival endpoint sample size")

testthat::test_that("Testing nSurv vs nSurvival and nEvents", {
  # consider a trial with 2 year maximum follow-up,
  # 6 month uniform enrollment
  # Treatment/placebo hazards = 0.14/0.2 per 1 person-year
  # HR = 0.7
  # drop out hazard 0.1 per 1 person-year
  # alpha = 0.025 (1-sided)
  # power = 0.9 (default beta=.1)
  ss <- nSurvival(
    lambda1 = .2, lambda2 = .14, eta = .1, Ts = 2, Tr = .5,
    sided = 1, alpha = .025
  )
  ns <- nSurv(lambdaC = .2, hr = .7, eta = .1, T=2, minfup=1.5)
  nsg <- nSurv(lambdaC = .2, hr = .7, eta = .1, R = 0.5, T = NULL, minfup = NULL, gamma = ns$gamma)
  ne <- nEvents(hr = .7)
  testthat::expect_equal(ss$n, ns$n, info = "Checking sample size")
  testthat::expect_equal(round(ns$n,3), round(nsg$n,3), info = "Checking sample size")
  testthat::expect_equal(ss$nEvents, ns$d, info = "Checking event count")
  testthat::expect_lt(abs(ns$d - ne),3)
})

testthat::test_that("Checking consistency of Schoenfeld approximations", {
  z <- hrn2z(hr = .7, n = 100, ratio = 1.5)
  hr <- zn2hr(z = z, n = 100, ratio = 1.5)
  n <- hrz2n(z = z, hr = .7, ratio = 1.5)
  testthat::expect_equal(hr, .7, info = "Checking zn2hr vs hrn2z")
  testthat::expect_equal(n, 100, info = "Checking hrz2n vs hrn2z")
})

testthat::test_that("Checking consistency nEvents power vs sample size", {
  ss <- nEvents(hr = .7, tbl = TRUE)
  ne <- nEvents(hr = .7)
  pwr <- nEvents(hr = .7, n = ne, tbl = TRUE)
  testthat::expect_equal(ss$n, ceiling(ne), info = "Checking tabular output")
  testthat::expect_equal(pwr$Power, .9, info = "Checking power calculation")
})

testthat::test_that("nSurv matches rpact for Schoenfeld and Freedman", {
  getDesignGroupSequential <- tryCatch(
    utils::getFromNamespace("getDesignGroupSequential", "rpact"),
    error = function(e) NULL
  )
  getSampleSizeSurvival <- tryCatch(
    utils::getFromNamespace("getSampleSizeSurvival", "rpact"),
    error = function(e) NULL
  )
  testthat::skip_if_not(!is.null(getDesignGroupSequential) && !is.null(getSampleSizeSurvival))

  design <- getDesignGroupSequential(
    kMax = 1, alpha = 0.025, beta = 0.1, sided = 1
  )
  lambdaC <- log(2) / 6
  hr <- 0.6
  R <- 24
  minfup <- 12
  T <- R + minfup

  for (ratio in c(0.5, 1, 2)) {
    rp_schoen <- getSampleSizeSurvival(
      design = design,
      lambda2 = lambdaC,
      hazardRatio = hr,
      accrualTime = R,
      followUpTime = minfup,
      dropoutRate1 = 0,
      dropoutRate2 = 0,
      allocationRatioPlanned = ratio
    )
    ns_schoen <- nSurv(
      lambdaC = lambdaC, hr = hr, eta = 0,
      R = R, T = T, minfup = minfup, ratio = ratio,
      method = "Schoenfeld"
    )
    testthat::expect_equal(
      ns_schoen$n, rp_schoen$maxNumberOfSubjects[1],
      tolerance = 1e-6
    )
    testthat::expect_equal(
      ns_schoen$d, rp_schoen$maxNumberOfEvents[1],
      tolerance = 1e-6
    )
  }

  for (ratio in c(0.5, 1, 2)) {
    rp_freed <- getSampleSizeSurvival(
      design = design,
      lambda2 = lambdaC,
      hazardRatio = hr,
      accrualTime = R,
      followUpTime = minfup,
      dropoutRate1 = 0,
      dropoutRate2 = 0,
      allocationRatioPlanned = ratio,
      typeOfComputation = "Freedman"
    )
    ns_freed <- nSurv(
      lambdaC = lambdaC, hr = hr, eta = 0,
      R = R, T = T, minfup = minfup, ratio = ratio,
      method = "Freedman"
    )

    testthat::expect_equal(
      ns_freed$d, rp_freed$maxNumberOfEvents[1],
      tolerance = 1e-6
    )
    testthat::expect_equal(
      ns_freed$n, rp_freed$maxNumberOfSubjects[1],
      tolerance = 1e-6
    )
  }
})

testthat::test_that("nSurv handles T/minfup NULL for Schoenfeld and Freedman", {
  # minfup = NULL, T specified
  sch_minfup_null <- nSurv(
    lambdaC = log(2) / 6, hr = 0.5, eta = 0.001,
    gamma = 6, R = 25, T = 36, minfup = NULL,
    method = "Schoenfeld"
  )
  testthat::expect_s3_class(sch_minfup_null, "nSurv")
  testthat::expect_true(is.numeric(sch_minfup_null$minfup))

  fr_minfup_null <- nSurv(
    lambdaC = log(2) / 6, hr = 0.5, eta = 0.001,
    gamma = 6, R = 25, T = 36, minfup = NULL,
    method = "Freedman"
  )
  testthat::expect_s3_class(fr_minfup_null, "nSurv")
  testthat::expect_true(is.numeric(fr_minfup_null$minfup))

  # minfup specified, T = NULL
  sch_t_null <- nSurv(
    lambdaC = log(2) / 6, hr = 0.5, eta = 0.001,
    gamma = 6, R = 12, T = NULL, minfup = 12,
    method = "Schoenfeld"
  )
  testthat::expect_s3_class(sch_t_null, "nSurv")
  testthat::expect_true(is.numeric(sch_t_null$T))

  fr_t_null <- nSurv(
    lambdaC = log(2) / 6, hr = 0.5, eta = 0.001,
    gamma = 6, R = 12, T = NULL, minfup = 12,
    method = "Freedman"
  )
  testthat::expect_s3_class(fr_t_null, "nSurv")
  testthat::expect_true(is.numeric(fr_t_null$T))
})

testthat::test_that("nSurv validates S is positive", {
  testthat::expect_error(
    nSurv(lambdaC = 0.2, hr = 0.7, eta = 0.1, S = c(1, -1), T = 2, minfup = 1),
    "S must be a numeric vector of positive values"
  )
  testthat::expect_error(
    nSurv(lambdaC = 0.2, hr = 0.7, eta = 0.1, S = 0, T = 2, minfup = 1),
    "S must be a numeric vector of positive values"
  )
})

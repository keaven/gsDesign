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

testthat::test_that("nSurv and gsSurv validate fixed survival timing inputs", {
  testthat::expect_error(
    nSurv(lambdaC = .2, hr = .7, eta = .1, T = "a", minfup = 1.5),
    "nSurv: T must be NULL or a single positive finite numeric value"
  )
  testthat::expect_error(
    gsSurv(lambdaC = .2, hr = .7, eta = .1, T = "a", minfup = 1.5),
    "gsSurv: T must be NULL or a single positive finite numeric value"
  )
  testthat::expect_error(
    nSurv(lambdaC = .2, hr = .7, eta = .1, T = 2, R = "a", minfup = 1.5),
    "nSurv: R must be a numeric vector of positive finite values"
  )
  testthat::expect_error(
    gsSurv(lambdaC = .2, hr = .7, eta = .1, T = 2, R = 0, minfup = 1.5),
    "gsSurv: R must be a numeric vector of positive finite values"
  )
  testthat::expect_error(
    nSurv(
      lambdaC = log(2) / 20, hr = 0.65, hr0 = 1,
      eta = -log(1 - 0.02) / 18,
      gamma = c(1, 6, 10, 20, 30), R = rep(1, 5),
      T = 12, minfup = 8, ratio = 1
    ),
    "nSurv: enrollment duration from R \\(5\\) exceeds T - minfup \\(4\\)"
  )
  testthat::expect_error(
    gsSurv(
      k = 2, test.type = 4, alpha = 0.025, beta = 0.1,
      astar = 0, timing = 0.75, sfu = sfLDOF, sfupar = 0,
      sfl = sfHSD, sflpar = 0,
      lambdaC = log(2) / 20, hr = 0.65, hr0 = 1,
      eta = -log(1 - 0.02) / 18,
      gamma = c(1, 6, 10, 20, 30), R = rep(1, 5),
      S = NULL, T = 12, minfup = 8, ratio = 1
    ),
    "gsSurv: enrollment duration from R \\(5\\) exceeds T - minfup \\(4\\)"
  )
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
  testthat::expect_false(isTRUE(all.equal(sch_t_null$T, fr_t_null$T)))
})

testthat::test_that("non-Lachin-Foulkes methods cover allowed T/minfup combinations", {
  methods <- c("Schoenfeld", "Freedman", "BernsteinLagakos")
  timing_cases <- list(
    fixed = list(T = 36, minfup = 12, variable = "Accrual rate"),
    t_null = list(T = NULL, minfup = 12, variable = "Accrual duration"),
    minfup_null = list(T = 36, minfup = NULL, variable = "Follow-up duration"),
    both_null = list(T = NULL, minfup = NULL, variable = "Follow-up duration")
  )

  for (case in timing_cases) {
    ns <- lapply(
      methods,
      function(method) {
        nSurv(
          lambdaC = log(2) / 6, hr = 0.5, eta = 0.001,
          gamma = 4, R = 25, T = case$T, minfup = case$minfup,
          ratio = 1, alpha = 0.025, beta = 0.1, method = method
        )
      }
    )
    for (i in seq_along(methods)) {
      testthat::expect_s3_class(ns[[i]], "nSurv")
      testthat::expect_identical(ns[[i]]$method, methods[i])
      testthat::expect_identical(ns[[i]]$variable, case$variable)
      testthat::expect_true(all(is.finite(c(ns[[i]]$T, ns[[i]]$minfup, ns[[i]]$n, ns[[i]]$d))))
    }
    ns_metric <- vapply(
      ns,
      function(x) {
        switch(case$variable,
          "Accrual rate" = x$d,
          "Accrual duration" = sum(x$R),
          "Follow-up duration" = x$minfup
        )
      },
      numeric(1)
    )
    testthat::expect_equal(length(unique(round(ns_metric, 4))), length(methods))

    gs <- lapply(
      methods,
      function(method) {
        gsSurv(
          k = 3, test.type = 2, alpha = 0.025, beta = 0.1,
          sfu = sfLDOF, timing = c(0.5, 0.75, 1),
          lambdaC = log(2) / 6, hr = 0.5, eta = 0.001,
          gamma = 4, R = 25, T = case$T, minfup = case$minfup,
          ratio = 1, method = method
        )
      }
    )
    for (i in seq_along(methods)) {
      testthat::expect_s3_class(gs[[i]], "gsSurv")
      testthat::expect_identical(gs[[i]]$method, methods[i])
      testthat::expect_identical(gs[[i]]$variable, case$variable)
      testthat::expect_true(all(is.finite(c(
        gs[[i]]$T[gs[[i]]$k],
        gs[[i]]$minfup,
        sum(gs[[i]]$R),
        gs[[i]]$n.I[gs[[i]]$k]
      ))))
    }
    gs_events <- vapply(gs, function(x) x$n.I[x$k], numeric(1))
    testthat::expect_equal(length(unique(round(gs_events, 4))), length(methods))
  }
})

testthat::test_that("gsSurv solves follow-up duration with fixed accrual", {
  des <- gsSurv(
    k = 4, test.type = 2, alpha = 0.025, beta = 0.1,
    sfu = sfLDOF, timing = c(0.25, 0.5, 0.75, 1),
    lambdaC = 0.03466, hr = 0.5, eta = 0,
    gamma = 15, R = 18, T = NULL, minfup = NULL,
    ratio = 1, method = "Schoenfeld"
  )

  testthat::expect_equal(des$T[des$k], 25.13323, tolerance = 1e-4)
  testthat::expect_equal(des$minfup, 7.13323, tolerance = 1e-4)
  testthat::expect_equal(des$n.I[des$k], 89.07847, tolerance = 1e-4)
  testthat::expect_equal(
    sum(des$eNC[des$k, ] + des$eNE[des$k, ]),
    270,
    tolerance = 1e-3
  )
  testthat::expect_identical(des$variable, "Follow-up duration")
})

testthat::test_that("gsSurv solves accrual duration with fixed follow-up", {
  des <- gsSurv(
    k = 4, test.type = 2, alpha = 0.025, beta = 0.1,
    sfu = sfLDOF, timing = c(0.25, 0.5, 0.75, 1),
    lambdaC = 0.03466, hr = 0.5, eta = 0,
    gamma = 15, R = 18, T = NULL, minfup = 7.13323,
    ratio = 1, method = "Schoenfeld"
  )

  testthat::expect_equal(des$T[des$k], 25.13323, tolerance = 1e-4)
  testthat::expect_equal(des$R, 18, tolerance = 1e-4)
  testthat::expect_equal(des$n.I[des$k], 89.07847, tolerance = 1e-4)
  testthat::expect_equal(
    sum(des$eNC[des$k, ] + des$eNE[des$k, ]),
    270,
    tolerance = 1e-3
  )
  testthat::expect_identical(des$variable, "Accrual duration")
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

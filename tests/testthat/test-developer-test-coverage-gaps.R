test_that("nameperiod formats single and multiple periods", {
  expect_equal(nameperiod(3), "0-3")
  expect_equal(nameperiod(c(1, 2, 3)), c("0-1", "1-2", "2-3"))
})

test_that("periods builds period endpoints and names", {
  out <- periods(S = c(1, 2), T = 10, minfup = 3, digits = 1)
  expect_equal(out[[1]], c(1, 3, 7))
  expect_equal(out[[2]], c("0-1", "1-3", "3-7"))

  out_empty <- periods(S = numeric(0), T = 5, minfup = 2, digits = 1)
  expect_equal(out_empty[[1]], 3)
  expect_equal(out_empty[[2]], c("0-3", "3-3"))
})

test_that("eEvents1 returns detailed output when simple = FALSE", {
  res <- eEvents1(
    lambda = c(0.2, 0.1), eta = 0.05, gamma = c(1, 1),
    R = c(1, 1), S = 1, T = 2, minfup = 0, simple = FALSE
  )
  expect_true(all(c("d", "n", "q", "Q", "p", "P", "A") %in% names(res)))
  expect_true(is.numeric(res$d))
  expect_true(is.numeric(res$n))
})

test_that("KT and KTZ validate inputs and return numeric results", {
  expect_error(
    KT(R = Inf, minfup = NULL),
    "Enrollment duration must be specified as finite"
  )
  expect_error(
    KTZ(x = 1, minfup = NULL, R = Inf),
    "If minimum follow-up is sought, enrollment duration must be finite"
  )

  val <- KTZ(x = 2, minfup = 1, R = 1, simple = TRUE)
  expect_true(is.numeric(val))
})

test_that("LFPWE validates method constraints", {
  expect_error(
    LFPWE(method = "Schoenfeld", hr0 = 1.2),
    "Schoenfeld method only supports superiority testing"
  )
  expect_error(
    LFPWE(method = "Freedman", lambdaC = matrix(c(0.1, 0.2), ncol = 2)),
    "Stratified method not available for Freedman method"
  )
})

test_that("gsnSurv scales outputs based on variable type", {
  base_design <- nSurv(lambdaC = 0.2, hr = 0.7, eta = 0.1, T = 2, minfup = 1)
  gs_scaled <- gsnSurv(base_design, nEvents = base_design$d * 1.1)
  expect_s3_class(gs_scaled, "gsSize")
  expect_equal(gs_scaled$d, base_design$d * 1.1)
  expect_true(gs_scaled$n > base_design$n)

  dur_design <- nSurv(lambdaC = 0.2, hr = 0.7, eta = 0.1, R = 1, T = NULL, minfup = 1)
  gs_dur <- gsnSurv(dur_design, nEvents = dur_design$d * 1.05)
  expect_s3_class(gs_dur, "gsSize")
  expect_equal(gs_dur$d, dur_design$d * 1.05)

  pwr_design <- nSurv(lambdaC = 0.2, hr = 0.7, eta = 0.1, T = 2, minfup = 1, beta = NULL)
  pwr_design$tol <- .Machine$double.eps^0.25
  gs_pwr <- gsnSurv(pwr_design, nEvents = pwr_design$d * 1.05)
  expect_s3_class(gs_pwr, "gsSize")
  expect_equal(gs_pwr$d, pwr_design$d * 1.05)
})

test_that("LFPWE runs across supported methods", {
  lf_power <- LFPWE(beta = NULL, T = 6, minfup = 2, R = 2)
  expect_true(is.list(lf_power))
  expect_true(is.numeric(lf_power$power))

  lf_ss <- LFPWE(beta = 0.2, T = 6, minfup = 2, R = 2)
  expect_true(is.list(lf_ss))

  freed <- LFPWE(method = "Freedman", lambdaC = 0.2, hr = 0.7, hr0 = 1, R = 2, T = 6)
  expect_true(is.list(freed))

  strat <- LFPWE(
    method = "Schoenfeld",
    lambdaC = matrix(c(0.2, 0.1), ncol = 2),
    hr = 0.7, hr0 = 1, R = 2, T = 6
  )
  expect_true(is.list(strat))

  bl <- LFPWE(method = "BernsteinLagakos", hr0 = 1.2, R = c(1, 1, 1), T = 5, minfup = 1)
  expect_true(is.list(bl))

  bl_sup <- LFPWE(method = "BernsteinLagakos", hr0 = 1, R = c(3, 3), T = 4, minfup = 1)
  expect_true(is.list(bl_sup))

  r_adjust <- LFPWE(
    T = 4, minfup = 1, R = c(3, 3),
    gamma = c(1, 2)
  )
  expect_true(is.list(r_adjust))

  r_single <- LFPWE(T = 4, minfup = 1, R = 1, gamma = 2)
  expect_true(is.list(r_single))

  r_matrix <- LFPWE(
    T = 5, minfup = 1, R = c(2, 2, 2),
    gamma = matrix(c(1, 2, 3, 4), nrow = 2)
  )
  expect_true(is.list(r_matrix))

  strat_power <- LFPWE(
    method = "Schoenfeld",
    lambdaC = matrix(c(0.2, 0.1), ncol = 2),
    hr = 0.7, hr0 = 1, R = 2, T = 6, beta = NULL
  )
  expect_true(is.list(strat_power))

  freed_power <- LFPWE(
    method = "Freedman",
    lambdaC = 0.2, hr = 0.7, hr0 = 1, R = 2, T = 6, beta = NULL
  )
  expect_true(is.list(freed_power))
})

test_that("KTZ and KT cover additional branches", {
  ktz_val <- KTZ(minfup = 1, R = 1, beta = NULL, simple = TRUE)
  expect_true(is.numeric(ktz_val))

  ktz_target <- KTZ(minfup = 1, R = 1, n1Target = 1, simple = TRUE)
  expect_true(is.numeric(ktz_target))

  ktz_ratio <- KTZ(
    minfup = 1, R = 1, simple = TRUE,
    ratio = c(1, 2),
    lambdaC = matrix(c(0.2, 0.1), ncol = 2),
    gamma = matrix(1, nrow = 1, ncol = 2),
    etaC = 0, etaE = 0
  )
  expect_true(is.numeric(ktz_ratio))

  ktz_full <- KTZ(minfup = 1, R = 1, beta = .2, simple = FALSE)
  expect_true(is.list(ktz_full))
  expect_true(all(c("n", "d", "T") %in% names(ktz_full)))

  ktz_accrual <- KTZ(
    x = 5, minfup = 1, R = c(1, 2, 3),
    gamma = matrix(c(1, 2, 3), ncol = 1),
    beta = 0.2, simple = FALSE
  )
  expect_true(is.list(ktz_accrual))

  kt_full <- KT(minfup = 1, R = 1, n1Target = 10)
  expect_true(is.list(kt_full))

  expect_error(
    KT(minfup = NULL, R = 2, gamma = 1, beta = 0.2),
    "With minfup = NULL, trial is under-powered for any follow-up duration"
  )

  expect_error(
    KT(minfup = 1, R = 0.5, gamma = 1e6, beta = 0.2),
    "With T = NULL, trial is over-powered for any accrual duration"
  )
})

test_that("nEventsIA and print methods are exercised", {
  design <- nSurv(lambdaC = 0.2, hr = 0.7, eta = 0.1, T = 2, minfup = 1)
  ia <- nEventsIA(tIA = 1, x = design, simple = FALSE)
  expect_true(all(c("eDC", "eDE", "eNC", "eNE") %in% names(ia)))

  ia_simple <- nEventsIA(tIA = 1, x = design, target = 0.5, simple = TRUE)
  expect_true(is.numeric(ia_simple))

  strat_design <- gsSurv(
    k = 3,
    lambdaC = matrix(c(0.2, 0.1), ncol = 2),
    gamma = matrix(1, ncol = 2),
    hr = 0.7, eta = 0.1, T = 2, minfup = 1
  )
  ia_matrix <- nEventsIA(tIA = 1, x = strat_design, target = 0.5, simple = TRUE)
  expect_true(is.numeric(ia_matrix))

  gs_size <- gsnSurv(design, nEvents = design$d * 1.1)
  ia_gs <- nEventsIA(tIA = 1, x = gs_size, target = 0.5, simple = TRUE)
  expect_true(is.numeric(ia_gs))

  expect_silent(capture.output(print.nSurv(design)))
  expect_silent(capture.output(print.nSurv(design, show_strata = FALSE)))
  expect_error(print.nSurv(list()), "Primary argument must have class nSurv")

  strat_nsurv <- nSurv(
    lambdaC = matrix(c(0.2, 0.1), ncol = 2),
    gamma = matrix(1, ncol = 2),
    R = 1, hr = 0.7, eta = 0.1, T = 2, minfup = 1
  )
  expect_silent(capture.output(print.nSurv(strat_nsurv)))

  no_call <- strat_nsurv
  no_call$call <- NULL
  expect_silent(capture.output(print.nSurv(no_call)))

  gs_design <- gsSurv(k = 3, lambdaC = 0.2, hr = 0.7, eta = 0.1, T = 2, minfup = 1)
  expect_silent(capture.output(print.gsSurv(gs_design)))
  expect_silent(capture.output(print.gsSurv(gs_design, show_gsDesign = TRUE)))
  expect_error(print.gsSurv(list()), "Primary argument must have class gsSurv")

  multi_strata <- gsSurv(
    k = 3,
    lambdaC = matrix(c(0.2, 0.1), ncol = 2),
    gamma = matrix(1, ncol = 2),
    hr = 0.7, eta = 0.1, T = 2, minfup = 1
  )
  expect_silent(capture.output(print.gsSurv(multi_strata, show_strata = TRUE)))

  power_design <- nSurv(
    lambdaC = 0.2, hr = 0.7, eta = 0.1,
    T = 2, minfup = 1, beta = NULL
  )
  expect_silent(capture.output(print.nSurv(power_design)))
})

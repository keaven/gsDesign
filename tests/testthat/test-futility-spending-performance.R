test_that("one-parameter search stops after finding a nearby accurate root", {
  calls <- 0L
  evaluate <- function(p) {
    calls <<- calls + 1L
    list(valid = TRUE, residual = p - .17, par = p)
  }
  objective <- function(p) sum(evaluate(p)$residual^2)
  ctl <- gsDesign:::.gsCPFControl(list(cp_tol = 1e-9))
  fit <- gsDesign:::.gsCPFOneParameterSolve(evaluate, objective, 0, -40, 40, ctl)
  expect_lt(calls, 15L)
  expect_lte(abs(fit$best$residual), ctl$cp_tol)
})

test_that("joint search skips unnecessary coordinate sweeps but retains fallback", {
  for (needs_fallback in c(FALSE, TRUE)) {
    sweeps <- 0L
    evaluate <- function(p) {
      residual <- if (needs_fallback) p^2 - 4 else p - c(.3, -.2)
      list(valid = TRUE, residual = residual, achieved = residual, par = p)
    }
    objective <- function(p, target_index = NULL) {
      r <- evaluate(p)$residual
      if (!is.null(target_index)) {
        sweeps <<- sweeps + 1L
        r <- r[target_index]
      }
      sum(r^2)
    }
    ctl <- gsDesign:::.gsCPFControl(list(cp_tol = 1e-6))
    fit <- gsDesign:::.gsCPFMultipleSolve(evaluate, objective,
      c(0, 0), c(-3, -3), c(3, 3), ctl, 2:1, TRUE)
    expect_identical(fit$solver$backward_used, needs_fallback)
    if (needs_fallback) expect_gt(sweeps, 0L) else expect_equal(sweeps, 0L)
    expect_lte(max(abs(fit$best$residual)), ctl$cp_tol)
  }
})

test_that("survival reconstruction is deferred and final targets are rechecked", {
  x <- gsSurv(timing = c(.4, .8), sfu = sfLDOF,
              sfl = sfLogistic, sflpar = c(0, 1), hr = .7)
  rebuild <- gsDesign:::.gsSpendingSurvival
  calls <- 0L
  local_mocked_bindings(.gsSpendingSurvival = function(x, candidate) {
    calls <<- calls + 1L
    rebuild(x, candidate)
  }, .package = "gsDesign")
  fit <- gsPPFutilitySpending(x, c(.15, .2), control = list(pp_tol = 1e-6))
  expect_equal(calls, 1L)
  expect_s3_class(fit, "gsSurv")
  prior <- fit$ppFutilitySpending$prior
  achieved <- vapply(1:2, function(i) gsPP(fit, i = i,
    zi = fit$lower$bound[i], theta = prior$z, wgts = prior$wgts), numeric(1))
  expect_equal(achieved, fit$ppFutilitySpending$achieved_pp)
  expect_lte(max(abs(achieved - c(.15, .2))), 1e-6)
  expect_equal(unname(rowSums(fit$eDC + fit$eDE)), fit$n.I, tolerance = 2e-5)
})

test_that("a failed final survival reconstruction retries the full builder", {
  x <- gsSurv(sfl = sfHSD, sflpar = 1)
  rebuild <- gsDesign:::.gsSpendingSurvival
  calls <- 0L
  local_mocked_bindings(.gsSpendingSurvival = function(x, candidate) {
    calls <<- calls + 1L
    if (calls == 1L) stop("Synthetic reconstruction failure")
    rebuild(x, candidate)
  }, .package = "gsDesign")
  fit <- gsCPFutilitySpending(x, .15, control = list(cp_tol = 1e-6))
  expect_gt(calls, 1L)
  expect_s3_class(fit, "gsSurv")
  achieved <- sum(gsCP(fit, i = 1, zi = fit$lower$bound[1],
    theta = fit$lower$bound[1] / sqrt(fit$n.I[1]))$upper$prob)
  expect_equal(achieved, fit$cpFutilitySpending$achieved_cp)
  expect_lte(abs(achieved - .15), 1e-6)
})

test_that("a changed final survival probability cannot bypass the target tolerance", {
  x <- gsSurv(sfl = sfHSD, sflpar = 1)
  rebuild <- gsDesign:::.gsSpendingSurvival
  calls <- 0L
  local_mocked_bindings(.gsSpendingSurvival = function(x, candidate) {
    calls <<- calls + 1L
    result <- rebuild(x, candidate)
    if (calls == 1L) result$lower$bound[1] <- result$lower$bound[1] + .5
    result
  }, .package = "gsDesign")
  fit <- gsCPFutilitySpending(x, .15, control = list(cp_tol = 1e-6))
  expect_gt(calls, 1L)
  expect_lte(abs(fit$cpFutilitySpending$achieved_cp - .15), 1e-6)
})

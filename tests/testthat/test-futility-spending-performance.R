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

test_that("one-parameter search brackets across invalid grid points", {
  evaluate <- function(p) {
    list(valid = p != 0, residual = if (p == 0) NA_real_ else p - .17, par = p)
  }
  minimizations <- 0L
  objective <- function(p) {
    minimizations <<- minimizations + 1L
    z <- evaluate(p)
    if (z$valid) sum(z$residual^2) else 1e6
  }
  ctl <- gsDesign:::.gsCPFControl(list(cp_tol = 1e-9))
  fit <- gsDesign:::.gsCPFOneParameterSolve(evaluate, objective, -2, -40, 40, ctl)
  expect_lte(abs(fit$best$residual), ctl$cp_tol)
  expect_equal(minimizations, 0L)
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
    backward <- evaluate(fit$solver$backward)
    expect_equal(fit$solver$backward_cp, backward$achieved)
    expect_equal(fit$solver$backward_residual, backward$residual)
  }
})

test_that("disabling backward search retains starting diagnostics and failure detail", {
  x <- gsSurv(k = 3, timing = c(.4, .7), sfl = sfHSD, sflpar = 1,
              lambdaC = log(2) / 12, T = 36, minfup = 12, hr = .7)
  start <- gsDesign:::.gsCPFDesign(x, sfLogistic, c(0, 1))
  cp <- vapply(1:2, function(i) sum(gsCP(start, i = i,
    zi = start$lower$bound[i], theta = start$lower$bound[i] / sqrt(start$n.I[i]))$upper$prob), numeric(1))
  fit <- gsCPFutilitySpending(x, c(.1, .2), sfl = sfLogistic,
                              control = list(backward = FALSE))
  solver <- fit$cpFutilitySpending$solver
  expect_false(solver$backward_used)
  expect_equal(solver$backward, c(0, 1))
  expect_equal(solver$backward_cp, cp)
  expect_equal(solver$backward_residual, cp - c(.1, .2))
  err <- expect_error(gsCPFutilitySpending(x, c(.1, .2), sfl = sfLogistic,
    control = list(backward = FALSE, lower = c(0, .99), upper = c(.01, 1.01), cp_tol = 1e-8)),
    class = "gsCPFutilitySpending_error")
  expect_match(conditionMessage(err), "backward-pass maximum absolute residual")
  # The full-reconstruction retry starts from the best deferred candidate.
  retry_start <- gsDesign:::.gsCPFDesign(x, sfLogistic, err$solver$backward)
  retry_cp <- vapply(1:2, function(i) sum(gsCP(retry_start, i = i,
    zi = retry_start$lower$bound[i],
    theta = retry_start$lower$bound[i] / sqrt(retry_start$n.I[i]))$upper$prob), numeric(1))
  expect_equal(err$solver$backward_cp, retry_cp)
  expect_equal(err$solver$backward_residual, retry_cp - c(.1, .2))
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

test_that("sfLinear survival retries preserve internal warm starts near one", {
  check_restart <- function(last_logit) {
    x <- gsSurv(k = 3, timing = c(.4, .7), sfl = sfHSD, sflpar = 1,
                lambdaC = log(2) / 12, T = 36, minfup = 12, hr = .7)
    par <- c(qlogis(.7 / plogis(last_logit)), last_logit)
    spec <- gsDesign:::.gsCPFResolveSpending(sfLinear, quote(sfLinear), 2L,
      x, 1:2, gsDesign:::.gsCPFControl(list()))
    candidate <- gsDesign:::.gsCPFDesign(x, sfLinear, spec$decode(par), rebuild_survival = FALSE)
    target <- vapply(1:2, function(i) sum(gsCP(candidate, i = i,
      zi = candidate$lower$bound[i],
      theta = candidate$lower$bound[i] / sqrt(candidate$n.I[i]))$upper$prob), numeric(1))
    rebuild <- gsDesign:::.gsSpendingSurvival
    rebuild_parameters <- list()
    solves <- 0L
    local_mocked_bindings(
      .gsCPFMultipleSolve = function(evaluate, ...) {
        solves <<- solves + 1L
        list(best = evaluate(par), solver = list(convergence = 0L))
      },
      .gsSpendingSurvival = function(x, candidate) {
        rebuild_parameters[[length(rebuild_parameters) + 1L]] <<- candidate$lower$param
        if (length(rebuild_parameters) == 1L) stop("Synthetic reconstruction failure")
        rebuild(x, candidate)
      }, .package = "gsDesign")
    fit <- gsCPFutilitySpending(x, target, sfl = sfLinear, control = list(cp_tol = 1e-8))
    expect_equal(solves, 1L)
    expect_length(rebuild_parameters, 2L)
    expect_identical(rebuild_parameters[[2L]], rebuild_parameters[[1L]])
    expect_identical(fit$cpFutilitySpending$solver$backward, par)
    expect_s3_class(fit, "gsSurv")
    expect_lte(max(abs(fit$cpFutilitySpending$residual)), 1e-8)
  }
  check_restart(qlogis(.999992151941278))
  check_restart(37) # plogis(37) rounds to exactly one in double precision.
})

test_that("unsuccessful deferred searches retry with full survival reconstruction", {
  check_retry <- function(no_candidate) {
    x <- gsSurv(sfl = sfHSD, sflpar = 1)
    solve <- gsDesign:::.gsCPFOneParameterSolve
    rebuild <- gsDesign:::.gsSpendingSurvival
    solves <- 0L
    rebuilds <- 0L
    local_mocked_bindings(
      .gsCPFOneParameterSolve = function(evaluate, objective, start, lower, upper, control) {
        solves <<- solves + 1L
        if (solves == 1L) return(list(
          best = if (no_candidate) NULL else evaluate(start),
          solver = list(convergence = 1L, message = "Synthetic deferred search failure")
        ))
        solve(evaluate, objective, start, lower, upper, control)
      },
      .gsSpendingSurvival = function(x, candidate) {
        rebuilds <<- rebuilds + 1L
        rebuild(x, candidate)
      }, .package = "gsDesign")
    fit <- gsCPFutilitySpending(x, .15, control = list(cp_tol = 1e-6))
    expect_equal(solves, 2L)
    expect_gt(rebuilds, 0L)
    expect_s3_class(fit, "gsSurv")
    expect_lte(abs(fit$cpFutilitySpending$residual), 1e-6)
  }
  check_retry(FALSE)
  check_retry(TRUE)
})

test_that("failed full retries report rebuilt diagnostics without further retries", {
  x <- gsSurv(sfl = sfHSD, sflpar = 1)
  rebuild <- gsDesign:::.gsSpendingSurvival
  solves <- 0L
  rebuilds <- 0L
  full_candidate <- NULL
  local_mocked_bindings(
    .gsCPFOneParameterSolve = function(evaluate, objective, start, lower, upper, control) {
      solves <<- solves + 1L
      best <- evaluate(start)
      if (solves == 2L) full_candidate <<- best
      list(best = best, solver = list(convergence = 1L, message = "Synthetic search failure"))
    },
    .gsSpendingSurvival = function(x, candidate) {
      rebuilds <<- rebuilds + 1L
      result <- rebuild(x, candidate)
      result$lower$bound[1] <- result$lower$bound[1] + .5
      result
    }, .package = "gsDesign")
  err <- expect_error(gsCPFutilitySpending(x, .15),
    class = "gsCPFutilitySpending_convergence_error")
  expect_equal(solves, 2L)
  expect_equal(rebuilds, 1L)
  expect_s3_class(full_candidate$design, "gsSurv")
  expect_equal(err$closest_cp, full_candidate$achieved)
  expect_equal(err$sflpar, full_candidate$sflpar)
  expect_equal(err$max_information, tail(full_candidate$design$n.I, 1L))
})

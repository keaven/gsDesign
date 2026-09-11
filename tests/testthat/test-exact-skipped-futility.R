skipped_futility_design <- function(testLower = c(TRUE, FALSE, FALSE)) {
  gsSurv(
    k = 3, test.type = 4, alpha = .025, beta = .1251133,
    timing = c(.46, .76), sfu = sfHSD, sfupar = 3.25,
    sfl = sfHSD, sflpar = -2.8, lambdaC = c(.002, 0), S = 12,
    eta = 0, hr = .3, hr0 = .8, R = 12, T = 24, minfup = 12,
    ratio = 1, testLower = testLower
  )
}

check_exact_skipped_futility <- function(x, out) {
  expect_true(all(diff(out$upper$bound) >= 0))
  expect_true(all(diff(out$n.I - out$upper$bound) >= 0))
  expect_true(all(out$upper$bound > out$lower$bound))
  expect_identical(out$testLower, x$testLower)
  inactive <- which(!out$testLower)
  expect_true(all(abs(out$upper$prob[inactive, , drop = FALSE]) < 1e-12))
  for (j in inactive) {
    expected <- if (j == 1) out$n.I[j] + 1 else {
      out$n.I[j] - out$n.I[j - 1] + out$upper$bound[j - 1]
    }
    expect_equal(out$upper$bound[j], expected)
  }
  nb <- gsBinomialExact(
    k = out$k, theta = out$theta[1], n.I = out$n.I,
    a = out$lower$bound, b = out$n.I + 1
  )
  alpha_target <- x$upper$sf(out$alpha, out$usTime, x$upper$param)$spend
  expect_true(all(cumsum(nb$lower$prob[, 1]) <= alpha_target + 1e-10))
  beta_target <- x$lower$sf(x$beta, out$lsTime, x$lower$param)$spend
  for (j in seq_len(out$k)) if (!out$testLower[j]) {
    beta_target[j] <- if (j == 1) 0 else beta_target[j - 1]
  }
  expect_true(all(cumsum(out$upper$prob[, 2]) <= beta_target + 1e-10))
}

test_that("the reported Type 4 skipped-futility example converts successfully", {
  x <- skipped_futility_design()
  out <- toBinomialExact(x)
  check_exact_skipped_futility(x, out)
  expect_equal(out$n.I, c(29, 47, 62))
  expect_equal(out$upper$bound, c(12, 30, 45))
  target <- x$lower$sf(x$beta, out$lsTime[1], x$lower$param)$spend
  expect_gt(pbinom(10, 29, out$theta[2], lower.tail = FALSE), target)
})

test_that("all patterns of skipped Type 4 looks preserve exact spending", {
  patterns <- expand.grid(rep(list(c(FALSE, TRUE)), 3))
  for (i in seq_len(nrow(patterns))) {
    flags <- as.logical(patterns[i, ])
    if (!any(flags)) next # Type 4 requires at least one lower-bound test.
    x <- skipped_futility_design(flags)
    out <- toBinomialExact(x)
    check_exact_skipped_futility(x, out)
    # Same information and efficacy spending, with futility enabled everywhere.
    all_active <- x
    all_active$testLower <- rep(TRUE, x$k)
    ref <- toBinomialExact(all_active)
    expect_equal(out$lower$bound, ref$lower$bound)
  }
})

test_that("skipped futility is retained with actual-event and spending overrides", {
  x <- skipped_futility_design()
  for (alpha in c(.025, .01)) {
    out <- toBinomialExact(x, observedEvents = c(25, 45, 60), alpha = alpha,
      usTime = c(.4, .7, .95), lsTime = c(.4, .7, .95), maxSpend = TRUE)
    check_exact_skipped_futility(x, out)
    expect_equal(out$n.I, c(25, 45, 60))
    expect_equal(out$usTime, c(.4, .7, 1))
    expect_equal(out$lsTime, c(.4, .7, 1))
  }
})

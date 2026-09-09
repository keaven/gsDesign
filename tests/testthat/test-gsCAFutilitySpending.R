test_that("fixed-information CA recovers spending and changes power for new targets", {
  x <- gsDesign(k = 2, test.type = 4, sflpar = 0)
  prior <- list(z = c(0, x$delta), wgts = c(.2, .8))
  target <- gsCPOS(1, x, prior$z, prior$wgts)
  fit <- gsCAFutilitySpending(x, target, prior = prior, control = list(start = 1))
  expect_s3_class(fit, "gsCAFutilitySpending")
  expect_equal(fit$lower$param, 0, tolerance = 1e-3)
  expect_identical(fit$n.I, x$n.I)
  expect_identical(fit$upper$bound, x$upper$bound)
  changed <- gsCAFutilitySpending(x, target + .015, prior = prior)
  expect_identical(changed$n.I, x$n.I)
  expect_identical(changed$upper$bound, x$upper$bound)
  expect_gt(changed$beta, x$beta)
  expect_equal(gsCPOS(1, changed, prior$z, prior$wgts), target + .015,
               tolerance = 1e-4)
  expect_equal(sum(changed$lower$prob[, 2]), changed$beta, tolerance = 1e-6)
  expect_equal(sum(changed$upper$prob[, 2]), 1 - changed$beta, tolerance = 1e-6)
  desired <- changed$lower$sf(changed$beta, changed$lower$sTime,
                            changed$lower$param)$spend
  expect_equal(cumsum(changed$lower$prob[, 2]), desired, tolerance = 1e-5)
  replay <- gsCAFutilitySpending(x, target + .015, prior = prior,
    control = list(start = changed$caFutilitySpending$free_parameters))
  expect_equal(replay$lower$bound, changed$lower$bound)
})

test_that("fixed CA supports two parameters and preserves inactive bounds", {
  x <- gsDesign(k = 3, test.type = 4, timing = c(.4, .75),
                sfl = sfLogistic, sflpar = c(0, 1))
  prior <- list(z = c(0, x$delta), wgts = c(.2, .8))
  target <- vapply(1:2, function(i) gsCPOS(i, x, prior$z, prior$wgts), numeric(1))
  fit <- gsCAFutilitySpending(x, target, sfl = sfLogistic, prior = prior,
                              control = list(start = c(-.1, 1.1)))
  expect_lte(max(abs(fit$caFutilitySpending$residual)), 1e-4)
  expect_identical(fit$n.I, x$n.I)
  expect_identical(fit$upper$bound, x$upper$bound)
  x <- gsDesign(k = 3, test.type = 4, testLower = c(TRUE, FALSE, TRUE))
  target <- gsCPOS(1, x, prior$z, prior$wgts)
  fit <- gsCAFutilitySpending(x, target, prior = prior)
  expect_equal(fit$lower$bound[2], -20)
  expect_equal(fit$lower$spend[2], 0)
})

test_that("fixed CA rejects bad input and reports its own control tolerance", {
  x <- gsDesign(k = 2, test.type = 4)
  prior <- list(z = x$delta, wgts = 1)
  expect_error(gsCAFutilitySpending(x, .8), class = "gsCAFutilitySpending_input_error")
  expect_error(gsCAFutilitySpending(x, .8, prior = prior,
    control = list(cpos_tol = 1e-4)), class = "gsCAFutilitySpending_input_error")
  expect_error(gsCAFutilitySpending(x, .8, prior = list(z = 0, wgts = 0)),
    class = "gsCAFutilitySpending_input_error")
  target <- gsCPOS(1, x, prior$z, prior$wgts)
  fit <- gsCAFutilitySpending(x, target, prior = prior, control = list(ca_tol = 1e-6))
  expect_equal(fit$caFutilitySpending$solver$ca_tol, 1e-6)
})

test_that("fixed CA supports linear spending and binding reference boundaries", {
  times <- c(.3, .5, .7)
  x <- gsDesign(k = 4, test.type = 4, timing = times, sfl = sfLinear,
                sflpar = c(times, .05, .25, .65))
  prior <- list(z = c(0, x$delta), wgts = c(.2, .8))
  target <- vapply(1:3, function(i) gsCPOS(i, x, prior$z, prior$wgts), numeric(1))
  fit <- gsCAFutilitySpending(x, target, sfl = sfLinear, prior = prior,
                              control = list(start = c(.045, .24, .64)))
  expect_lte(max(abs(fit$caFutilitySpending$residual)), 1e-4)
  expect_identical(fit$n.I, x$n.I)
  expect_equal(fit$lower$param[1:3], times)
  x <- gsDesign(k = 3, test.type = 3, sflpar = 0)
  prior <- list(z = c(0, x$delta), wgts = c(.2, .8))
  fit <- gsCAFutilitySpending(x, gsCPOS(1, x, prior$z, prior$wgts),
                              prior = prior, control = list(start = 1))
  expect_identical(fit$upper$bound, x$upper$bound)
  expect_equal(fit$caFutilitySpending$achieved_type1, sum(fit$upper$prob[, 1]))
  expect_equal(fit$beta, x$beta, tolerance = 1e-5)
})

test_that("Dragalin fixed-information benchmark gives the expected effect boundary", {
  x <- gsDesign(k = 2, test.type = 4, delta = 33 / 140,
                n.I = c(72, 144), maxn.IPlan = 144,
                testUpper = c(FALSE, TRUE), sflpar = 0, r = 32)
  prior <- normalGrid(mu = 33 / 140, sigma = 16 / 140)
  prior$wgts <- prior$wgts / sum(prior$wgts)
  benchmark <- gsProbability(k = 1, theta = prior$z, n.I = 230,
                             a = qnorm(.975), b = qnorm(.975), r = 32)
  target <- sum(benchmark$upper$prob %*% prior$wgts)
  fit <- gsCAFutilitySpending(x, target, prior = prior)
  expect_equal(target, .7901662, tolerance = 1e-5)
  expect_equal(fit$lower$bound[1] * 140 / sqrt(72), 7.273984, tolerance = .02)
  expect_identical(fit$n.I, c(72, 144))
  expect_equal(fit$upper$bound[2], qnorm(.975), tolerance = 1e-5)
  expect_equal(gsCPOS(1, fit, prior$z, prior$wgts), target, tolerance = 1e-4)
})

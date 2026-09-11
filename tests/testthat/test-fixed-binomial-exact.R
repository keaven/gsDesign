test_that("one-look binomial probabilities match direct tails", {
  p <- c(.1, .3, .7)
  out <- gsBinomialExact(k = 1, theta = p, n.I = 20, a = 3, b = 12)
  expect_equal(as.vector(out$lower$prob), pbinom(3, 20, p))
  expect_equal(as.vector(out$upper$prob), pbinom(11, 20, p, lower.tail = FALSE))
  expect_equal(out$en, rep(20, length(p)))
  expect_equal(dim(out$lower$prob), c(1L, 3L))
  expect_no_error(as_table(out))
  for (type in c(1, 2, 3, 6)) expect_s3_class(plot(out, plottype = type), "ggplot")
})

test_that("fixed survival conversion controls alpha at the exact integer cutoff", {
  for (ratio in c(1, 3)) {
    x <- gsSurv(k = 1, hr = .3, hr0 = .7, ratio = ratio)
    plan <- toInteger(x)$n.I
    for (count in c(1, floor(.8 * plan), plan, plan + 10)) {
      for (full in c(FALSE, TRUE)) {
        out <- toBinomialExact(x, observedEvents = count, alpha = .01, maxSpend = full)
        time <- if (full) 1 else min(count / plan, 1)
        allowed <- x$upper$sf(.01, time, x$upper$param)$spend
        expect_equal(out$usTime, time)
        expect_equal(out$maxn.IPlan, plan)
        expect_equal(out$en, rep(count, 2))
        expect_lte(out$lower$prob[1, 1], allowed + 1e-14)
        expect_gt(pbinom(out$lower$bound + 1, count, out$theta[1]), allowed)
        expect_equal(as.vector(out$lower$prob), pbinom(out$lower$bound, count, out$theta))
        expect_equal(out$upper$prob[1, ], setNames(c(0, 0), colnames(out$upper$prob)))
        expect_equal(out$ratio, ratio)
      }
    }
    expect_equal(toBinomialExact(x)$n.I, plan)
    expect_no_error(as_table(toBinomialExact(x)))
  }
})

test_that("fixed conversions respect explicit spending and validate schedules", {
  x <- gsSurv(k = 1, hr = .3, hr0 = .7)
  out <- toBinomialExact(x, observedEvents = 20, usTime = .8)
  expect_equal(out$usTime, .8)
  expect_equal(toBinomialExact(x, observedEvents = 20, usTime = .8, maxSpend = TRUE)$usTime, 1)
  expect_error(toBinomialExact(x, observedEvents = numeric()), "increasing positive integers")
  expect_error(toBinomialExact(x, observedEvents = c(10, 20)), "one observed event count")
  expect_error(toBinomialExact(x, lsTime = .5), "lsTime can only")
})

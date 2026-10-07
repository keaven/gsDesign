test_that("reconstructed survival summaries preserve HR origin and direction", {
  for (hr0 in c(1, 1.2)) {
    for (hr in c(.6, 1.5)) {
      x <- gsSurv(
        k = 3, test.type = 4, alpha = .025, beta = .1,
        timing = c(.5, .75), sfu = sfLDOF, sfl = sfHSD, sflpar = -2,
        testLower = c(TRUE, FALSE, FALSE), hr = hr, hr0 = hr0,
        eta = .01, gamma = c(2.5, 5, 7.5, 10), R = c(2, 2, 2, 6),
        T = 18, minfup = 6, ratio = 1, method = "LachinFoulkes", lambdaC = log(2) / 6
      ) |> toInteger()
      y <- gsDesign(
        k = x$k, test.type = x$test.type, alpha = x$alpha, beta = x$beta,
        astar = x$astar, delta = x$delta, delta0 = x$delta0, delta1 = x$delta1,
        timing = x$timing, n.I = x$n.I,
        sfu = x$upper$sf, sfupar = x$upper$param,
        sfl = x$lower$sf, sflpar = x$lower$param,
        testUpper = x$testUpper, testLower = x$testLower, testHarm = x$testHarm
      )
      before <- y
      out <- expect_no_warning(gsBoundSummary(
        y, deltaname = "HR", logdelta = TRUE, digits = 6, ddigits = 6,
        Nname = "Events", alpha = .01
      ))
      expect_identical(y, before)
      rows <- out$Value == "~HR at bound"
      for (a in c(y$alpha, .01)) {
        ref <- if (a == y$alpha) y else gsDesign:::gsAlternateAlphaDesign(y, a, r = 18)
        sign <- if (hr > hr0) 1 else -1
        expected <- hr0 * exp(sign * 2 * ref$upper$bound / sqrt(ref$n.I))
        expect_equal(out[rows, paste0("\u03b1=", a)], round(expected, 6))
      }
      expected <- hr0 * exp(sign * 2 * y$lower$bound / sqrt(y$n.I))
      expected[!y$testLower] <- NA
      expect_equal(out$Futility[rows], round(expected, 6))
    }
  }
})

test_that("explicit HR fields take precedence, including at alternate alpha", {
  x <- gsDesign(k = 2, delta0 = log(1.2), delta1 = log(.8))
  x$hr0 <- 1.1
  x$hr <- 1.5
  out <- expect_no_warning(gsBoundSummary(
    x, deltaname = "HR", logdelta = TRUE, digits = 6, ddigits = 6, alpha = .01
  ))
  rows <- out$Value == "~HR at bound"
  for (a in c(x$alpha, .01)) {
    ref <- if (a == x$alpha) x else gsDesign:::gsAlternateAlphaDesign(x, a, r = 18)
    expected <- x$hr0 * exp(2 * ref$upper$bound / sqrt(ref$n.I))
    expect_equal(out[rows, paste0("\u03b1=", a)], round(expected, 6))
  }
  x$hr <- NULL
  out <- expect_no_warning(gsBoundSummary(x, deltaname = "HR", logdelta = TRUE, digits = 6, ddigits = 6))
  expected <- x$hr0 * exp(-2 * x$upper$bound / sqrt(x$n.I))
  expect_equal(out$Efficacy[out$Value == "~HR at bound"], round(expected, 6))
})

test_that("HR summaries retain fallback warnings without usable log parameters", {
  x <- gsDesign(k = 2, delta0 = log(1.2), delta1 = log(.8))
  expect_warning(gsBoundSummary(x, deltaname = "HR"), "hr0 is not present")
  for (delta0 in c(NA_real_, Inf, -Inf, 1000, -1000)) {
    x$delta0 <- delta0
    expect_warning(
      gsBoundSummary(x, deltaname = "HR", logdelta = TRUE),
      "hr0 is not present"
    )
  }
})

test_that("log scale non-HR summaries keep their existing transformations", {
  for (label in c("RR", "OR")) {
    x <- gsDesign(k = 2, delta0 = log(1.2), delta1 = log(.8), endpoint = "Binomial")
    out <- expect_no_warning(gsBoundSummary(x, deltaname = label, logdelta = TRUE))
    x$hr0 <- 3
    x$hr <- 4
    expect_equal(gsBoundSummary(x, deltaname = label, logdelta = TRUE), out)
  }
})

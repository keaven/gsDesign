testthat::context("base tests")

### Utility functions for gsDesign stress tests

"alpha.beta.range.util" <- function(alpha, beta, type, sf) {
  no.err <- TRUE

  for (a in alpha)
  {
    for (b in beta)
    {
      # sfLDPocock, test.type=3: errors with alpha >= .5 and beta close to 1 - alpha
      if (b < 1 - a - 0.1) {
        # cat("a = ", a, "b = ", b, "\n")
        res <- try(gsDesign(test.type = type, alpha = a, beta = b, sfu = sf))

        if (is(res, "try-error")) {
          no.err <- FALSE
        }
      }
    }
  }

  no.err
}

"param.range.util" <- function(param, type, sf) {
  no.err <- TRUE

  for (p in param)
  {
    res <- try(gsDesign(test.type = type, sfu = sf, sfupar = p))

    if (is(res, "try-error")) {
      no.err <- FALSE
    }
  }

  no.err
}

a1 <- round(seq(from = 0.05, to = 0.95, by = 0.05), 2)
a2 <- round(seq(from = 0.05, to = 0.45, by = 0.05), 2)
b <- round(seq(from = 0.05, to = 0.95, by = 0.05), 2)

# nu: sfExponential parameter
nu <- round(seq(from = 0.1, to = 1.5, by = 0.1), 1)

# rho: sfPower parameter
rho <- round(seq(from = 1, to = 15, by = 1), 0)

# gamma: sfHSD parameter
gamma <- round(seq(from = -5, to = 5, by = 1), 0)


testthat::test_that("test.ciBinomial.adj", {
  testthat::expect_error(gsDesign::ciBinomial(
    adj = "abc", x1 = 2, x2 = 2, n1 = 2,
    n2 = 2
  ), info = "Checking for incorrect variable type")
  testthat::expect_error(gsDesign::ciBinomial(
    adj = c(-1), x1 = 2, x2 = 2, n1 = 2,
    n2 = 2
  ), info = "Checking for out-of-range variable value")
  testthat::expect_error(gsDesign::ciBinomial(
    adj = 2, x1 = 2, x2 = 2, n1 = 2,
    n2 = 2
  ), info = "Checking for out-of-range variable value")
  testthat::expect_error(gsDesign::ciBinomial(
    adj = rep(1, 2), x1 = 2, x2 = 2,
    n1 = 2, n2 = 2
  ), info = "Checking for incorrect variable length")
})

testthat::test_that("test.ciBinomial.alpha", {
  testthat::expect_error(gsDesign::ciBinomial(
    alpha = "abc", x1 = 2, x2 = 2, n1 = 2,
    n2 = 2
  ), info = "Checking for incorrect variable type")
  testthat::expect_error(gsDesign::ciBinomial(
    alpha = 1, x1 = 2, x2 = 2, n1 = 2,
    n2 = 2
  ), info = "Checking for out-of-range variable value")
  testthat::expect_error(gsDesign::ciBinomial(
    alpha = 0, x1 = 2, x2 = 2, n1 = 2,
    n2 = 2
  ), info = "Checking for out-of-range variable value")
  testthat::expect_error(gsDesign::ciBinomial(
    alpha = rep(0.1, 2), x1 = 2, x2 = 2,
    n1 = 2, n2 = 2
  ), info = "Checking for incorrect variable length")
})

testthat::test_that("test.ciBinomial.n1", {
  testthat::expect_error(gsDesign::ciBinomial(n1 = "abc", x1 = 2, x2 = 2, n2 = 2),
    info = "Checking for incorrect variable type"
  )
  testthat::expect_error(gsDesign::ciBinomial(n1 = 0, x1 = 0, x2 = 2, n2 = 2),
    info = "Checking for out-of-range variable value"
  )
  testthat::expect_error(gsDesign::ciBinomial(n1 = rep(2, 2), x1 = 2, x2 = 2, n2 = 2),
    info = "Checking for incorrect variable length"
  )
})

testthat::test_that("test.ciBinomial.n2", {
  testthat::expect_error(gsDesign::ciBinomial(n2 = "abc", x1 = 2, x2 = 2, n1 = 2),
    info = "Checking for incorrect variable type"
  )
  testthat::expect_error(gsDesign::ciBinomial(n2 = 0, x1 = 2, x2 = 0, n1 = 2),
    info = "Checking for out-of-range variable value"
  )
  testthat::expect_error(gsDesign::ciBinomial(n2 = rep(2, 2), x1 = 2, x2 = 2, n1 = 2),
    info = "Checking for incorrect variable length"
  )
})

testthat::test_that("test.ciBinomial.scale", {
  testthat::expect_error(gsDesign::ciBinomial(
    scale = 1, x1 = 2, x2 = 2, n1 = 2,
    n2 = 2
  ), info = "Checking for incorrect variable type")
  testthat::expect_error(gsDesign::ciBinomial(
    scale = "abc", x1 = 2, x2 = 2, n1 = 2,
    n2 = 2
  ), info = "Checking for out-of-range variable value")
  testthat::expect_error(gsDesign::ciBinomial(
    scale = rep("Difference", 2), x1 = 2,
    x2 = 2, n1 = 2, n2 = 2
  ), info = "Checking for incorrect variable length")
})

testthat::test_that("test.ciBinomial.tol", {
  testthat::expect_error(gsDesign::ciBinomial(
    tol = "abc", x1 = 2, x2 = 2, n1 = 2,
    n2 = 2
  ), info = "Checking for incorrect variable type")
  testthat::expect_error(gsDesign::ciBinomial(
    tol = 0, x1 = 2, x2 = 2, n1 = 2,
    n2 = 2
  ), info = "Checking for out-of-range variable value")
})

testthat::test_that("test.ciBinomial.x1", {
  testthat::expect_error(gsDesign::ciBinomial(x1 = "abc", x2 = 2, n1 = 2, n2 = 2),
    info = "Checking for incorrect variable type"
  )
  testthat::expect_error(gsDesign::ciBinomial(x1 = 3, x2 = 2, n1 = 2, n2 = 2),
    info = "Checking for out-of-range variable value"
  )
  testthat::expect_error(gsDesign::ciBinomial(x1 = c(-1), x2 = 2, n1 = 2, n2 = 2),
    info = "Checking for out-of-range variable value"
  )
  testthat::expect_error(gsDesign::ciBinomial(x1 = rep(2, 2), x2 = 2, n1 = 2, n2 = 2),
    info = "Checking for incorrect variable length"
  )
})

testthat::test_that("test.ciBinomial.x2", {
  testthat::expect_error(gsDesign::ciBinomial(x2 = "abc", x1 = 2, n1 = 2, n2 = 2),
    info = "Checking for incorrect variable type"
  )
  testthat::expect_error(gsDesign::ciBinomial(x2 = 3, x1 = 2, n1 = 2, n2 = 2),
    info = "Checking for out-of-range variable value"
  )
  testthat::expect_error(gsDesign::ciBinomial(x2 = c(-1), x1 = 2, n1 = 2, n2 = 2),
    info = "Checking for out-of-range variable value"
  )
  testthat::expect_error(gsDesign::ciBinomial(x2 = rep(2, 2), x1 = 2, n1 = 2, n2 = 2),
    info = "Checking for incorrect variable length"
  )
})

testthat::test_that("test.gsbound.falsepos", {
  testthat::expect_error(gsbound(falsepos = "abc", I = 1, trueneg = 0.5),
    info = "Checking for incorrect variable type"
  )
  testthat::expect_error(gsbound(falsepos = 0, I = 1, trueneg = 0.5),
    info = "Checking for out-of-range variable value"
  )
  testthat::expect_error(gsbound(falsepos = 1, I = 1, trueneg = 0.5),
    info = "Checking for out-of-range variable value"
  )
  testthat::expect_error(gsbound(falsepos = rep(0.5, 2), I = 1, trueneg = 0.5),
    info = "Checking for incorrect variable length"
  )
})

testthat::test_that("test.gsbound.I", {
  testthat::expect_error(gsbound(I = "abc", trueneg = 0.5, falsepos = 0.5),
    info = "Checking for incorrect variable type"
  )
  testthat::expect_error(gsbound(I = 0, trueneg = 0.5, falsepos = 0.5),
    info = "Checking for out-of-range variable value"
  )
  testthat::expect_error(gsbound(I = rep(1, 2), trueneg = 0.5, falsepos = 0.5),
    info = "Checking for incorrect variable length"
  )
})

testthat::test_that("test.gsbound.r", {
  testthat::expect_error(gsbound(r = "abc", I = 1, trueneg = 0.5, falsepos = 0.5),
    info = "Checking for incorrect variable type"
  )
  testthat::expect_error(gsbound(r = 0, I = 1, trueneg = 0.5, falsepos = 0.5),
    info = "Checking for out-of-range variable value"
  )
  testthat::expect_error(gsbound(r = 81, I = 1, trueneg = 0.5, falsepos = 0.5),
    info = "Checking for out-of-range variable value"
  )
  testthat::expect_error(gsbound(
    r = rep(1, 2), I = 1, trueneg = 0.5,
    falsepos = 0.5
  ), info = "Checking for incorrect variable length")
})

testthat::test_that("test.gsbound.tol", {
  testthat::expect_error(gsbound(tol = "abc", I = 1, trueneg = 0.5, falsepos = 0.5),
    info = "Checking for incorrect variable type"
  )
  testthat::expect_error(gsbound(tol = 0, I = 1, trueneg = 0.5, falsepos = 0.5),
    info = "Checking for out-of-range variable value"
  )
})

testthat::test_that("test.gsbound.trueneg", {
  testthat::expect_error(gsbound(trueneg = "abc", I = 1, falsepos = 0.5),
    info = "Checking for incorrect variable type"
  )
  testthat::expect_error(gsbound(trueneg = 0, I = 1, falsepos = 0.5),
    info = "Checking for out-of-range variable value"
  )
  testthat::expect_error(gsbound(trueneg = 1, I = 1, falsepos = 0.5),
    info = "Checking for out-of-range variable value"
  )
  testthat::expect_error(gsbound(trueneg = rep(0.5, 2), I = 1, falsepos = 0.5),
    info = "Checking for incorrect variable length"
  )
})

testthat::test_that("test.gsbound1.a", {
  testthat::expect_error(gsbound1(a = "abc", theta = 1, I = 1, probhi = 0.5),
    info = "Checking for incorrect variable type"
  )
  testthat::expect_error(gsbound1(
    a = rep(0.5, 2), theta = 1, I = 1,
    probhi = 0.5
  ), info = "Checking for incorrect variable length")
})

testthat::test_that("test.gsbound1.I", {
  testthat::expect_error(gsbound1(I = "abc", theta = 1, a = 0, probhi = 0.5),
    info = "Checking for incorrect variable type"
  )
  testthat::expect_error(gsbound1(I = 0, theta = 1, a = 0, probhi = 0.5),
    info = "Checking for out-of-range variable value"
  )
  testthat::expect_error(gsbound1(I = rep(1, 2), theta = 1, a = 0, probhi = 0.5),
    info = "Checking for incorrect variable length"
  )
})

testthat::test_that("test.gsbound1.probhi", {
  testthat::expect_error(gsbound1(probhi = "abc", I = 1, a = 0, theta = 1),
    info = "Checking for incorrect variable type"
  )
  testthat::expect_error(gsbound1(probhi = 0, I = 1, a = 0, theta = 1),
    info = "Checking for out-of-range variable value"
  )
  testthat::expect_error(gsbound1(probhi = 1, I = 1, a = 0, theta = 1),
    info = "Checking for out-of-range variable value"
  )
  testthat::expect_error(gsbound1(
    probhi = rep(0.5, 2), I = 1, a = 0,
    theta = 1
  ), info = "Checking for incorrect variable length")
})

testthat::test_that("test.gsbound1.r", {
  testthat::expect_error(gsbound1(
    r = "abc", I = 1, a = 0, probhi = 0.5,
    theta = 1
  ), info = "Checking for incorrect variable type")
  testthat::expect_error(gsbound1(
    r = 0, I = 1, a = 0, probhi = 0.5,
    theta = 1
  ), info = "Checking for out-of-range variable value")
  testthat::expect_error(gsbound1(
    r = 81, I = 1, a = 0, probhi = 0.5,
    theta = 1
  ), info = "Checking for out-of-range variable value")
  testthat::expect_error(gsbound1(
    r = rep(1, 2), I = 1, a = 0, probhi = 0.5,
    theta = 1
  ), info = "Checking for incorrect variable length")
})

testthat::test_that("test.gsbound1.theta", {
  testthat::expect_error(gsbound1(theta = "abc", I = 1, a = 0, probhi = 0.5),
    info = "Checking for incorrect variable type"
  )
  testthat::expect_error(gsbound1(theta = rep(1, 2), I = 1, a = 0, probhi = 0.5),
    info = "Checking for incorrect variable length"
  )
})

testthat::test_that("test.gsbound1.tol", {
  testthat::expect_error(gsbound1(
    tol = "abc", I = 1, a = 0, probhi = 0.5,
    theta = 1
  ), info = "Checking for incorrect variable type")
  testthat::expect_error(gsbound1(
    tol = 0, I = 1, a = 0, probhi = 0.5,
    theta = 1
  ), info = "Checking for out-of-range variable value")
})

testthat::test_that("test.gsBoundCP.r", {
  testthat::expect_error(gsDesign::gsBoundCP(r = "abc"), info = "Checking for incorrect variable type")
  testthat::expect_error(gsDesign::gsBoundCP(r = 0), info = "Checking for out-of-range variable value")
  testthat::expect_error(gsDesign::gsBoundCP(r = 81), info = "Checking for out-of-range variable value")
  testthat::expect_error(gsDesign::gsBoundCP(r = rep(1, 2)), info = "Checking for incorrect variable length")
})

testthat::test_that("test.gsBoundCP.theta", {
  testthat::expect_error(gsDesign::gsBoundCP(theta = "abc"), info = "Checking for incorrect variable type")
  testthat::expect_error(gsDesign::gsBoundCP(theta = rep(1, 2)), info = "Checking for incorrect variable length")
})

testthat::test_that("test.gsBoundCP.x", {
  testthat::expect_error(gsDesign::gsBoundCP(x = "abc"), info = "Checking for incorrect variable type")
})

testthat::test_that("test.gsCP.r", {
  testthat::expect_error(gsDesign::gsCP(r = "abc"), info = "Checking for incorrect variable type")
  testthat::expect_error(gsDesign::gsCP(r = 0), info = "Checking for out-of-range variable value")
  testthat::expect_error(gsDesign::gsCP(r = 81), info = "Checking for out-of-range variable value")
  testthat::expect_error(gsDesign::gsCP(r = rep(1, 2)), info = "Checking for incorrect variable length")
})

testthat::test_that("test.gsCP.x", {
  testthat::expect_error(gsDesign::gsCP(x = "abc"), info = "Checking for incorrect variable type")
})

testthat::test_that("test.gsDesign.alpha", {
  testthat::expect_error(gsDesign::gsDesign(alpha = "abc", test.type = 1), info = "Checking for incorrect variable type")
  testthat::expect_error(gsDesign::gsDesign(alpha = 0, test.type = 1), info = "Checking for out-of-range variable value")
  testthat::expect_error(gsDesign::gsDesign(alpha = 1, test.type = 1), info = "Checking for out-of-range variable value")
  testthat::expect_error(gsDesign::gsDesign(alpha = 0.51, test.type = 2), info = "Checking for out-of-range variable value")
  testthat::expect_error(gsDesign::gsDesign(alpha = rep(0.5, 2), test.type = 1),
    info = "Checking for incorrect variable length"
  )
})

testthat::test_that("test.gsDesign.astar", {
  testthat::expect_error(gsDesign::gsDesign(astar = "abc", test.type = 5), info = "Checking for incorrect variable type")
  testthat::expect_error(gsDesign::gsDesign(astar = 0.51, alpha = 0.5, test.type = 5),
    info = "Checking for out-of-range variable value"
  )
  testthat::expect_error(gsDesign::gsDesign(astar = 1, alpha = 0, test.type = 5),
    info = "Checking for out-of-range variable value"
  )
  testthat::expect_error(gsDesign::gsDesign(astar = -1, test.type = 6), info = "Checking for out-of-range variable value")
  testthat::expect_error(gsDesign::gsDesign(astar = rep(0.1, 2), alpha = 0.5, test.type = 5),
    info = "Checking for incorrect variable length"
  )
})

testthat::test_that("test.gsDesign.beta", {
  testthat::expect_error(gsDesign::gsDesign(beta = "abc", test.type = 3), info = "Checking for incorrect variable type")
  testthat::expect_error(gsDesign::gsDesign(beta = 0.5, alpha = 0.5, test.type = 3),
    info = "Checking for out-of-range variable value"
  )
  testthat::expect_error(gsDesign::gsDesign(beta = 1, alpha = 0, test.type = 3),
    info = "Checking for out-of-range variable value"
  )
  testthat::expect_error(gsDesign::gsDesign(beta = 0, test.type = 3), info = "Checking for out-of-range variable value")
  testthat::expect_error(gsDesign::gsDesign(beta = rep(0.1, 2), alpha = 0.5, test.type = 3),
    info = "Checking for incorrect variable length"
  )
})

testthat::test_that("test.gsDesign.delta", {
  testthat::expect_error(gsDesign::gsDesign(delta = "abc"), info = "Checking for incorrect variable type")
  testthat::expect_error(gsDesign::gsDesign(delta = -1), info = "Checking for out-of-range variable value")
  testthat::expect_error(gsDesign::gsDesign(delta = rep(0.1, 2)), info = "Checking for incorrect variable length")
})

testthat::test_that("test.gsDesign.k", {
  testthat::expect_error(gsDesign::gsDesign(k = "abc"), info = "Checking for incorrect variable type")
  testthat::expect_error(gsDesign::gsDesign(k = 1.2), info = "Checking for incorrect variable type")
  testthat::expect_error(gsDesign::gsDesign(k = 0), info = "Checking for out-of-range variable value")
  testthat::expect_error(gsDesign::gsDesign(k = 24, test.type = 4), info = "Checking for out-of-range variable value")
  testthat::expect_error(gsDesign::gsDesign(k = seq(2)), info = "Checking for incorrect variable length")
  testthat::expect_error(gsDesign::gsDesign(k = 3, sfu = sfpoints, sfupar = c(
    0.05,
    0.1, 0.15, 0.2, 1
  )), info = "Checking for incorrect variable length")
})

testthat::test_that("test.gsDesign.maxn.I", {
  testthat::expect_error(gsDesign::gsDesign(maxn.I = "abc"), info = "Checking for incorrect variable type")
})

testthat::test_that("test.gsDesign.n.fix", {
  testthat::expect_error(gsDesign::gsDesign(n.fix = "abc", delta = 0), info = "Checking for incorrect variable type")
  testthat::expect_error(gsDesign::gsDesign(n.fix = -1, delta = 0), info = "Checking for out-of-range variable value")
  testthat::expect_error(gsDesign::gsDesign(n.fix = rep(2, 2), delta = 0), info = "Checking for incorrect variable length")
})

testthat::test_that("test.gsDesign.n.I", {
  testthat::expect_error(gsDesign::gsDesign(n.I = "abc"), info = "Checking for incorrect variable type")
})

testthat::test_that("test.gsDesign.r", {
  testthat::expect_error(gsDesign::gsDesign(r = "abc"), info = "Checking for incorrect variable type")
  testthat::expect_error(gsDesign::gsDesign(r = 0), info = "Checking for out-of-range variable value")
  testthat::expect_error(gsDesign::gsDesign(r = 81), info = "Checking for out-of-range variable value")
  testthat::expect_error(gsDesign::gsDesign(r = rep(1, 2)), info = "Checking for incorrect variable length")
})

testthat::test_that("test.gsDesign.sfl", {
  testthat::expect_error(gsDesign::gsDesign(sfl = "abc"), info = "Checking for incorrect variable type")
  testthat::expect_error(gsDesign::gsDesign(sfl = rep(sfHSD, 2)), info = "Checking for incorrect variable length")
})

testthat::test_that("test.gsDesign.sflpar", {
  testthat::expect_error(gsDesign::gsDesign(sflpar = "abc"), info = "Checking for incorrect variable type")
  testthat::expect_error(gsDesign::gsDesign(sflpar = rep(-2, 2)), info = "Checking for incorrect variable length")
})

testthat::test_that("test.gsDesign.sfu", {
  testthat::expect_error(gsDesign::gsDesign(sfu = "abc"), info = "Checking for incorrect variable type")
  testthat::expect_error(gsDesign::gsDesign(sfu = rep(sfHSD, 2)), info = "Checking for incorrect variable length")
})

testthat::test_that("test.gsDesign.sfupar", {
  testthat::expect_error(gsDesign::gsDesign(sfupar = "abc"), info = "Checking for incorrect variable type")
  testthat::expect_error(gsDesign::gsDesign(sfupar = rep(-4, 2)), info = "Checking for incorrect variable length")
})

testthat::test_that("test.gsDesign.test.type", {
  testthat::expect_error(gsDesign::gsDesign(test.type = "abc"), info = "Checking for incorrect variable type")
  testthat::expect_error(gsDesign::gsDesign(test.type = 1.2), info = "Checking for incorrect variable type")
  testthat::expect_error(gsDesign::gsDesign(test.type = 0), info = "Checking for out-of-range variable value")
  testthat::expect_error(gsDesign::gsDesign(test.type = 7), info = "Checking for out-of-range variable value")
  testthat::expect_error(gsDesign::gsDesign(test.type = seq(2)), info = "Checking for incorrect variable length")
  testthat::expect_error(gsDesign::gsDesign(test.type = 3, sfu = "WT"), info = "Checking for out-of-range variable value")
  testthat::expect_error(gsDesign::gsDesign(test.type = 4, sfu = "WT"), info = "Checking for out-of-range variable value")
  testthat::expect_error(gsDesign::gsDesign(test.type = 5, sfu = "WT"), info = "Checking for out-of-range variable value")
  testthat::expect_error(gsDesign::gsDesign(test.type = 6, sfu = "WT"), info = "Checking for out-of-range variable value")
})

testthat::test_that("test.gsDesign.timing", {
  testthat::expect_error(gsDesign::gsDesign(timing = "abc", k = 1), info = "Checking for incorrect variable type")
  testthat::expect_error(gsDesign::gsDesign(timing = -1, k = 1), info = "Checking for out-of-range variable value")
  testthat::expect_error(gsDesign::gsDesign(timing = 2, k = 1), info = "Checking for out-of-range variable value")
  testthat::expect_error(gsDesign::gsDesign(timing = c(0.1, 1.1), k = 2), info = "Checking for out-of-range variable value")
  testthat::expect_error(gsDesign::gsDesign(timing = c(0.5, 0.1), k = 2), info = "NA")
  testthat::expect_error(gsDesign::gsDesign(timing = c(0.1, 0.5, 1), k = 2), info = "Checking for incorrect variable length")
})

testthat::test_that("test.gsDesign.tol", {
  testthat::expect_error(gsDesign::gsDesign(tol = "abc"), info = "Checking for incorrect variable type")
  testthat::expect_error(gsDesign::gsDesign(tol = 0), info = "Checking for out-of-range variable value")
  testthat::expect_error(gsDesign::gsDesign(tol = 0.10000001), info = "Checking for out-of-range variable value")
  testthat::expect_error(gsDesign::gsDesign(tol = rep(0.1, 2)), info = "Checking for incorrect variable length")
})

testthat::test_that("test.stress.sfExp.type1", {
  no.errors <- param.range.util(param = nu, type = 1, sf = sfExponential)
  testthat::expect_true(no.errors, info = "Type 1 sfExponential stress test")
})

testthat::test_that("test.stress.sfExp.type2", {
  no.errors <- param.range.util(param = nu, type = 2, sf = sfExponential)
  testthat::expect_true(no.errors, info = "Type 2 sfExponential stress test")
})

testthat::test_that("test.stress.sfExp.type3", {
  no.errors <- param.range.util(param = nu, type = 3, sf = sfExponential)
  testthat::expect_true(no.errors, info = "Type 3 sfExponential stress test")
})

testthat::test_that("test.stress.sfExp.type4", {
  no.errors <- param.range.util(param = nu, type = 4, sf = sfExponential)
  testthat::expect_true(no.errors, info = "Type 4 sfExponential stress test")
})

testthat::test_that("test.stress.sfExp.type5", {
  no.errors <- param.range.util(param = nu, type = 5, sf = sfExponential)
  testthat::expect_true(no.errors, info = "Type 5 sfExponential stress test")
})

testthat::test_that("test.stress.sfExp.type6", {
  no.errors <- param.range.util(param = nu, type = 6, sf = sfExponential)
  testthat::expect_true(no.errors, info = "Type 6 sfExponential stress test")
})

testthat::test_that("test.stress.sfHSD.type1", {
  no.errors <- param.range.util(param = gamma, type = 1, sf = sfHSD)
  testthat::expect_true(no.errors, info = "Type 1 sfHSD stress test")
})

testthat::test_that("test.stress.sfHSD.type2", {
  no.errors <- param.range.util(param = gamma, type = 2, sf = sfHSD)
  testthat::expect_true(no.errors, info = "Type 2 sfHSD stress test")
})

testthat::test_that("test.stress.sfHSD.type3", {
  no.errors <- param.range.util(param = gamma, type = 3, sf = sfHSD)
  testthat::expect_true(no.errors, info = "Type 3 sfHSD stress test")
})

testthat::test_that("test.stress.sfHSD.type4", {
  no.errors <- param.range.util(param = gamma, type = 4, sf = sfHSD)
  testthat::expect_true(no.errors, info = "Type 4 sfHSD stress test")
})

testthat::test_that("test.stress.sfHSD.type5", {
  no.errors <- param.range.util(param = gamma, type = 5, sf = sfHSD)
  testthat::expect_true(no.errors, info = "Type 5 sfHSD stress test")
})

testthat::test_that("test.stress.sfHSD.type6", {
  no.errors <- param.range.util(param = gamma, type = 6, sf = sfHSD)
  testthat::expect_true(no.errors, info = "Type 6 sfHSD stress test")
})

testthat::test_that("test.stress.sfLDOF.type1", {
  no.errors <- alpha.beta.range.util(
    alpha = a1, beta = b,
    type = 1, sf = sfLDOF
  )
  testthat::expect_true(no.errors, info = "Type 1 LDOF stress test")
})

testthat::test_that("test.stress.sfLDOF.type2", {
  no.errors <- alpha.beta.range.util(
    alpha = a2, beta = b,
    type = 2, sf = sfLDOF
  )
  testthat::expect_true(no.errors, info = "Type 2 LDOF stress test")
})

testthat::test_that("test.stress.sfLDOF.type3", {
  no.errors <- alpha.beta.range.util(
    alpha = a1, beta = b,
    type = 3, sf = sfLDOF
  )
  testthat::expect_true(no.errors, info = "Type 3 LDOF stress test")
})

testthat::test_that("test.stress.sfLDOF.type4", {
  no.errors <- alpha.beta.range.util(
    alpha = a1, beta = b,
    type = 4, sf = sfLDOF
  )
  testthat::expect_true(no.errors, info = "Type 4 LDOF stress test")
})

testthat::test_that("test.stress.sfLDOF.type5", {
  no.errors <- alpha.beta.range.util(
    alpha = a1, beta = b,
    type = 5, sf = sfLDOF
  )
  testthat::expect_true(no.errors, info = "Type 5 LDOF stress test")
})

testthat::test_that("test.stress.sfLDOF.type6", {
  no.errors <- alpha.beta.range.util(
    alpha = a1, beta = b,
    type = 6, sf = sfLDOF
  )
  testthat::expect_true(no.errors, info = "Type 6 LDOF stress test")
})

testthat::test_that("test.stress.sfLDPocock.type1", {
  no.errors <- alpha.beta.range.util(
    alpha = a1, beta = b,
    type = 1, sf = sfLDPocock
  )
  testthat::expect_true(no.errors, info = "Type 1 LDPocock stress test")
})

testthat::test_that("test.stress.sfLDPocock.type2", {
  no.errors <- alpha.beta.range.util(
    alpha = a2, beta = b,
    type = 2, sf = sfLDPocock
  )
  testthat::expect_true(no.errors, info = "Type 2 LDPocock stress test")
})

testthat::test_that("test.stress.sfLDPocock.type3", {
  no.errors <- alpha.beta.range.util(
    alpha = a1, beta = b,
    type = 3, sf = sfLDPocock
  )
  testthat::expect_true(no.errors, info = "Type 3 LDPocock stress test")
})

testthat::test_that("test.stress.sfLDPocock.type4", {
  no.errors <- alpha.beta.range.util(
    alpha = a1, beta = b,
    type = 4, sf = sfLDPocock
  )
  testthat::expect_true(no.errors, info = "Type 4 LDPocock stress test")
})

testthat::test_that("test.stress.sfLDPocock.type5", {
  no.errors <- alpha.beta.range.util(
    alpha = a1, beta = b,
    type = 5, sf = sfLDPocock
  )
  testthat::expect_true(no.errors, info = "Type 5 LDPocock stress test")
})

testthat::test_that("test.stress.sfLDPocock.type6", {
  no.errors <- alpha.beta.range.util(
    alpha = a1, beta = b,
    type = 6, sf = sfLDPocock
  )
  testthat::expect_true(no.errors, info = "Type 6 LDPocock stress test")
})

testthat::test_that("test.stress.sfPower.type1", {
  no.errors <- param.range.util(param = rho, type = 1, sf = sfPower)
  testthat::expect_true(no.errors, info = "Type 1 sfPower stress test")
})

testthat::test_that("test.stress.sfPower.type2", {
  no.errors <- param.range.util(param = rho, type = 2, sf = sfPower)
  testthat::expect_true(no.errors, info = "Type 2 sfPower stress test")
})

testthat::test_that("test.stress.sfPower.type3", {
  no.errors <- param.range.util(param = rho, type = 3, sf = sfPower)
  testthat::expect_true(no.errors, info = "Type 3 sfPower stress test")
})

testthat::test_that("test.stress.sfPower.type4", {
  no.errors <- param.range.util(param = rho, type = 4, sf = sfPower)
  testthat::expect_true(no.errors, info = "Type 4 sfPower stress test")
})

testthat::test_that("test.stress.sfPower.type5", {
  no.errors <- param.range.util(param = rho, type = 5, sf = sfPower)
  testthat::expect_true(no.errors, info = "Type 5 sfPower stress test")
})

testthat::test_that("test.stress.sfPower.type6", {
  no.errors <- param.range.util(param = rho, type = 6, sf = sfPower)
  testthat::expect_true(no.errors, info = "Type 6 sfPower stress test")
})

testthat::test_that("test.gsProbability.a", {
  testthat::expect_error(gsDesign::gsProbability(a = "abc"), info = "Checking for incorrect variable type")
  testthat::expect_error(gsDesign::gsProbability(a = c(1, 2), k = 3), info = "Checking for incorrect variable length")
})

testthat::test_that("test.gsProbability.b", {
  testthat::expect_error(gsDesign::gsProbability(b = "abc"), info = "Checking for incorrect variable type")
  testthat::expect_error(gsDesign::gsProbability(b = c(1, 2), k = 3), info = "Checking for incorrect variable length")
})

testthat::test_that("test.gsProbability.k", {
  testthat::expect_error(gsDesign::gsProbability(k = "abc"), info = "Checking for incorrect variable type")
  testthat::expect_error(gsDesign::gsProbability(k = -1), info = "Checking for out-of-range variable value")
  testthat::expect_error(gsDesign::gsProbability(k = 1, d = gsDesign::gsDesign()), info = "Checking for out-of-range variable value")
  testthat::expect_error(gsDesign::gsProbability(k = 31), info = "Checking for out-of-range variable value")
  testthat::expect_error(gsDesign::gsProbability(k = seq(2)), info = "Checking for incorrect variable length")
})

testthat::test_that("test.gsProbability.n.I", {
  testthat::expect_error(gsDesign::gsProbability(n.I = "abc"), info = "Checking for incorrect variable type")
  testthat::expect_error(gsDesign::gsProbability(n.I = 0), info = "Checking for out-of-range variable value")
  testthat::expect_error(gsDesign::gsProbability(n.I = c(2, 1)), info = "Checking for out-of-order input sequence")
  testthat::expect_error(gsDesign::gsProbability(n.I = c(1, 2), k = 3), info = "Checking for incorrect variable length")
})

testthat::test_that("test.gsProbability.r", {
  testthat::expect_error(gsDesign::gsProbability(r = "abc"), info = "Checking for incorrect variable type")
  testthat::expect_error(gsDesign::gsProbability(r = 0), info = "Checking for out-of-range variable value")
  testthat::expect_error(gsDesign::gsProbability(r = 81), info = "Checking for out-of-range variable value")
  testthat::expect_error(gsDesign::gsProbability(r = rep(1, 2)), info = "Checking for incorrect variable length")
})

testthat::test_that("test.gsProbability.theta", {
  testthat::expect_error(gsDesign::gsProbability(theta = "abc"), info = "Checking for incorrect variable type")
})

testthat::test_that("test.nBinomial.alpha", {
  testthat::expect_error(gsDesign::nBinomial(alpha = "abc", p1 = 0.1, p2 = 0.2),
    info = "Checking for incorrect variable type"
  )
  testthat::expect_error(gsDesign::nBinomial(alpha = 1, p1 = 0.1, p2 = 0.2, sided = 1),
    info = "Checking for out-of-range variable value"
  )
  testthat::expect_error(gsDesign::nBinomial(alpha = 0.5, p1 = 0.1, p2 = 0.2, sided = 2),
    info = "Checking for out-of-range variable value"
  )
  testthat::expect_error(gsDesign::nBinomial(alpha = 0, p1 = 0.1, p2 = 0.2, sided = 2),
    info = "Checking for out-of-range variable value"
  )
  testthat::expect_error(gsDesign::nBinomial(alpha = rep(0.1, 2), p1 = 0.1, p2 = 0.2),
    info = "Checking for incorrect variable length"
  )
})

testthat::test_that("test.nBinomial.beta", {
  testthat::expect_error(gsDesign::nBinomial(beta = "abc", p1 = 0.1, p2 = 0.2),
    info = "Checking for incorrect variable type"
  )
  testthat::expect_error(gsDesign::nBinomial(
    beta = 0.7, p1 = 0.1, p2 = 0.2, sided = 1,
    alpha = 0.3
  ), info = "Checking for out-of-range variable value")
  testthat::expect_error(gsDesign::nBinomial(beta = 0, p1 = 0.1, p2 = 0.2), info = "Checking for out-of-range variable value")
  testthat::expect_error(gsDesign::nBinomial(beta = rep(0.1, 2), p1 = 0.1, p2 = rep(
    0.2,
    3
  )), info = "Checking for incorrect variable length")
})

testthat::test_that("test.nBinomial.delta0", {
  testthat::expect_error(gsDesign::nBinomial(delta0 = "abc", p1 = 0.1, p2 = 0.2),
    info = "Checking for incorrect variable type"
  )
  testthat::expect_error(gsDesign::nBinomial(delta0 = 0, p1 = 0.1, p2 = 0.1), info = "Checking for out-of-range variable value")
  testthat::expect_error(gsDesign::nBinomial(delta0 = 0.1, p1 = 0.2, p2 = 0.1),
    info = "Checking for out-of-range variable value"
  )
})

testthat::test_that("test.nBinomial.outtype", {
  testthat::expect_error(gsDesign::nBinomial(outtype = "abc", p1 = 0.1, p2 = 0.2),
    info = "Checking for incorrect variable type"
  )
  testthat::expect_error(gsDesign::nBinomial(outtype = 0, p1 = 0.1, p2 = 0.2),
    info = "Checking for out-of-range variable value"
  )
  testthat::expect_error(gsDesign::nBinomial(outtype = 4, p1 = 0.1, p2 = 0.2),
    info = "Checking for out-of-range variable value"
  )
  testthat::expect_error(gsDesign::nBinomial(outtype = rep(1, 2), p1 = 0.1, p2 = 0.2),
    info = "Checking for incorrect variable length"
  )
})

testthat::test_that("test.nBinomial.p1", {
  testthat::expect_error(gsDesign::nBinomial(p1 = "abc", p2 = 0.1), info = "Checking for incorrect variable type")
  testthat::expect_error(gsDesign::nBinomial(p1 = 0, p2 = 0.1), info = "Checking for out-of-range variable value")
  testthat::expect_error(gsDesign::nBinomial(p1 = 1, p2 = 0.1), info = "Checking for out-of-range variable value")
})

testthat::test_that("test.nBinomial.p2", {
  testthat::expect_error(gsDesign::nBinomial(p2 = "abc", p1 = 0.1), info = "Checking for incorrect variable type")
  testthat::expect_error(gsDesign::nBinomial(p2 = 0, p1 = 0.1), info = "Checking for out-of-range variable value")
  testthat::expect_error(gsDesign::nBinomial(p2 = 1, p1 = 0.1), info = "Checking for out-of-range variable value")
})

testthat::test_that("test.nBinomial.ratio", {
  testthat::expect_error(gsDesign::nBinomial(ratio = "abc", p1 = 0.1, p2 = 0.2),
    info = "Checking for incorrect variable type"
  )
  testthat::expect_error(gsDesign::nBinomial(ratio = 0, p1 = 0.1, p2 = 0.2), info = "Checking for out-of-range variable value")
  testthat::expect_error(gsDesign::nBinomial(ratio = rep(0.5, 2), p1 = 0.1, p2 = rep(
    0.2,
    3
  )), info = "Checking for incorrect variable length")
})

testthat::test_that("test.nBinomial.scale", {
  testthat::expect_error(gsDesign::nBinomial(scale = 1, p1 = 0.1, p2 = 0.2), info = "Checking for incorrect variable type")
  testthat::expect_error(gsDesign::nBinomial(scale = "abc", p1 = 0.1, p2 = 0.2),
    info = "Checking for out-of-range variable value"
  )
  testthat::expect_error(gsDesign::nBinomial(scale = rep("RR", 2), p1 = 0.1, p2 = 0.2),
    info = "Checking for incorrect variable length"
  )
})

testthat::test_that("test.nBinomial.sided", {
  testthat::expect_error(gsDesign::nBinomial(sided = "abc", p1 = 0.1, p2 = 0.2),
    info = "Checking for incorrect variable type"
  )
  testthat::expect_error(gsDesign::nBinomial(sided = 0, p1 = 0.1, p2 = 0.2), info = "Checking for out-of-range variable value")
  testthat::expect_error(gsDesign::nBinomial(sided = 3, p1 = 0.1, p2 = 0.2), info = "Checking for out-of-range variable value")
  testthat::expect_error(gsDesign::nBinomial(sided = rep(1, 2), p1 = 0.1, p2 = 0.2),
    info = "Checking for incorrect variable length"
  )
})

testthat::test_that("test.normalGrid.bounds", {
  testthat::expect_error(gsDesign::normalGrid(bounds = "abc"), info = "Checking for incorrect variable type")
  testthat::expect_error(gsDesign::normalGrid(bounds = 0), info = "Checking for out-of-range variable value")
  testthat::expect_error(gsDesign::normalGrid(bounds = c(2)), info = "Checking for incorrect variable length")
})

testthat::test_that("test.normalGrid.mu", {
  testthat::expect_error(gsDesign::normalGrid(mu = "abc"), info = "Checking for incorrect variable type")
  testthat::expect_error(gsDesign::normalGrid(mu = rep(1, 2)), info = "Checking for incorrect variable length")
})

testthat::test_that("test.normalGrid.r", {
  testthat::expect_error(gsDesign::normalGrid(r = "abc"), info = "Checking for incorrect variable type")
  testthat::expect_error(gsDesign::normalGrid(r = 0), info = "Checking for out-of-range variable value")
  testthat::expect_error(gsDesign::normalGrid(r = 81), info = "Checking for out-of-range variable value")
  testthat::expect_error(gsDesign::normalGrid(r = rep(1, 2)), info = "Checking for incorrect variable length")
})

testthat::test_that("test.normalGrid.sigma", {
  testthat::expect_error(gsDesign::normalGrid(sigma = "abc"), info = "Checking for incorrect variable type")
  testthat::expect_error(gsDesign::normalGrid(sigma = 0), info = "Checking for out-of-range variable value")
  testthat::expect_error(gsDesign::normalGrid(sigma = rep(1, 2)), info = "Checking for incorrect variable length")
})

testthat::test_that("test.Deming.gsProb", {
  w <- sum(gsDesign::gsProbability(k = 2, theta = 0, n.I = 1:2, a = stats::qnorm(0.025) *
    c(1, 1), b = stats::qnorm(0.975) * c(1, 1))$upper$prob)
  x <- sum(gsDesign::gsProbability(k = 4, theta = 0, n.I = 1:4, a = stats::qnorm(0.025) *
    c(1, 1, 1, 1), b = stats::qnorm(0.975) * c(1, 1, 1, 1))$upper$prob)
  y <- sum(gsDesign::gsProbability(k = 10, theta = 0, n.I = 1:10, a = stats::qnorm(0.025) *
    array(1, 10), b = stats::qnorm(0.975) * array(1, 10))$upper$prob)
  z <- sum(gsDesign::gsProbability(k = 20, theta = 0, n.I = 1:20, a = stats::qnorm(0.025) *
    array(1, 20), b = stats::qnorm(0.975) * array(1, 20))$upper$prob)
  testthat::expect_equal(0.042, round(w, 3), info = "Checking Type I error, k = 2")
  testthat::expect_equal(0.063, round(x, 3), info = "Checking Type I error, k = 4")
  testthat::expect_equal(0.097, round(y, 3), info = "Checking Type I error, k = 10")
  testthat::expect_equal(0.124, round(z, 3), info = "Checking Type I error, k = 20")
})

testthat::test_that("test.Deming.OFbound", {
  x <- gsDesign::gsDesign(
    k = 4, test.type = 2, sfu = "OF", n.fix = 1372,
    beta = 0.2
  )
  testthat::expect_equal(c(4.05, 2.86, 2.34, 2.02), round(
    x$upper$bound,
    2
  ), info = "Checking O'Brien-Fleming bounds")
})

testthat::test_that("test.JT.OFss", {
  x <- gsDesign::gsDesign(k = 5, test.type = 2, sfu = "OF", beta = 0.2)
  testthat::expect_equal(102.8, round(x$n.I[5] * 100, 1), info = "Checking 2-sided OF (gsDesign n.I), k=4, beta=0.2")
  testthat::expect_equal(102.1, round(x$en[1] * 100, 1), info = "Checking 2-sided Pocock (gsDesign en), k=4, beta=0.2")
  x <- gsDesign::gsDesign(k = 20, test.type = 2, sfu = "OF", beta = 0.1)
  testthat::expect_equal(104.5, round(x$n.I[20] * 100, 1), info = "Checking 2-sided OF (gsDesign n.I), k=20, beta=0.1")
  testthat::expect_equal(103.4, round(x$en[1] * 100, 1), info = "Checking 2-sided Pocock (gsDesign en), k=20, beta=0.1")
})

testthat::test_that("test.JT.Pocock", {
  x <- gsDesign::gsDesign(k = 4, test.type = 2, sfu = "Pocock", beta = 0.2)
  testthat::expect_equal(120.2, round(x$n.I[4] * 100, 1), info = "Checking 2-sided Pocock (gsDesign n.I), k=4, beta=0.2")
  testthat::expect_equal(117.5, round(x$en[1] * 100, 1), info = "Checking 2-sided Pocock (gsDesign en), k=4, beta=0.2")
  y <- gsDesign::gsProbability(theta = x$delta * c(0, 0.5, 1, 1.5), d = x)
  testthat::expect_equal(c(117.5, 108.8, 80.5, 52.2), round(
    y$en * 100,
    1
  ), info = "Checking 2-sided Pocock (gsProb), k=4, beta=0.2")
  x <- gsDesign::gsDesign(k = 15, test.type = 2, sfu = "Pocock", beta = 0.1)
  testthat::expect_equal(130.5, round(x$n.I[15] * 100, 1), info = "Checking 2-sided Pocock (gsDesign n.I), k=15, beta=0.1")
  testthat::expect_equal(126.4, round(x$en[1] * 100, 1), info = "Checking 2-sided Pocock (gsDesign en), k=15, beta=0.1")
  y <- gsDesign::gsProbability(theta = x$delta * c(0, 0.5, 1, 1.5), d = x)
  testthat::expect_equal(c(126.4, 111.2, 66.4, 35.4), round(
    y$en * 100,
    1
  ), info = "Checking 2-sided Pocock (gsProb), k=15, beta=0.1")
})

testthat::test_that("test.JT.Power.symm", {
  x <- gsDesign::gsDesign(
    k = 3, test.type = 2, sfu = sfPower, sfupar = 1,
    beta = 0.2
  )
  testthat::expect_equal(111.7, round(x$n.I[3] * 100, 1), info = "Checking symm 2-sided sfPower (gsDesign n.I), k=3, rho=1")
  testthat::expect_equal(109.9, round(x$en[1] * 100, 1), info = "Checking symm 2-sided sfPower (gsDesign en), k=3, rho=1")
  y <- gsDesign::gsProbability(theta = x$delta * c(0, 0.5, 1, 1.5), d = x)
  testthat::expect_equal(c(109.9, 103.4, 81.2, 56.5), round(
    y$en * 100,
    1
  ), info = "Checking symm 2-sided sfPower (gsProb), k=3, rho=1")
  x <- gsDesign::gsDesign(
    k = 10, test.type = 2, sfu = sfPower, sfupar = 2,
    beta = 0.2
  )
  testthat::expect_equal(108.1, round(x$n.I[10] * 100, 1), info = "Checking symm 2-sided sfPower (gsDesign), k=10, rho=2")
  testthat::expect_equal(106.6, round(x$en[1] * 100, 1), info = "Checking symm 2-sided sfPower (gsDesign en), k=10, rho=2")
  y <- gsDesign::gsProbability(theta = x$delta * c(0, 0.5, 1, 1.5), d = x)
  testthat::expect_equal(c(106.6, 99.7, 76.2, 51), round(
    y$en * 100,
    1
  ), info = "Checking symm 2-sided sfPower (gsProb), k=10, rho=2")
  x <- gsDesign::gsDesign(
    k = 2, test.type = 2, sfu = sfPower, sfupar = 3,
    beta = 0.2
  )
  testthat::expect_equal(101, round(x$n.I[2] * 100, 1), info = "Checking symm 2-sided sfPower (gsDesign), k=2, rho=3")
  testthat::expect_equal(100.7, round(x$en[1] * 100, 1), info = "Checking symm 2-sided sfPower (gsDesign en), k=2, rho=3")
  y <- gsDesign::gsProbability(theta = x$delta * c(0, 0.5, 1, 1.5), d = x)
  testthat::expect_equal(c(100.7, 98.9, 89.5, 70.7), round(
    y$en * 100,
    1
  ), info = "Checking symm 2-sided sfPower (gsProb), k=2, rho=3")
})

testthat::test_that("test.JT.Power.type3", {
  x <- gsDesign::gsDesign(
    k = 5, test.type = 3, alpha = 0.05, beta = 0.05,
    sfu = sfPower, sfupar = 2, sfl = sfPower, sflpar = 2
  )
  testthat::expect_equal(110.1, round(x$n.I[5] * 100, 1), info = "Checking type3 sfPower (gsDesign n.I), k=5, rho=2, beta=0.05")
  testthat::expect_equal(63.4, round(x$en[1] * 100, 1), info = "Checking type3 sfPower (gsDesign en), k=5, rho=2, beta=0.05")
  y <- gsDesign::gsProbability(theta = x$delta * c(0, 0.5, 1), d = x)
  testthat::expect_equal(c(63.4, 80.3, 63.4), round(y$en * 100, 1), info = "Checking type3 sfPower (gsProb), k=5, rho=2, beta=0.05")
  x <- gsDesign::gsDesign(
    k = 10, test.type = 3, alpha = 0.05, beta = 0.05,
    sfu = sfPower, sfupar = 3, sfl = sfPower, sflpar = 3
  )
  testthat::expect_equal(106.9, round(x$n.I[10] * 100, 1), info = "Checking type3 sfPower (gsDesign n.I), k=10, rho=3, beta=0.05")
  testthat::expect_equal(63.1, round(x$en[1] * 100, 1), info = "Checking type3 sfPower (gsDesign en), k=10, rho=3, beta=0.05")
  y <- gsDesign::gsProbability(theta = x$delta * c(0, 0.5, 1), d = x)
  testthat::expect_equal(c(63.1, 79.5, 63.1), round(y$en * 100, 1), info = "Checking type3 sfPower (gsProb), k=10, rho=3, beta=0.05")
  x <- gsDesign::gsDesign(
    test.type = 3, alpha = 0.05, sfu = sfPower,
    sfupar = 2, sfl = sfPower, sflpar = 2
  )
  testthat::expect_equal(107.2, round(x$n.I[3] * 100, 1), info = "Checking type3 sfPower (gsDesign n.I), k=3, rho=2, beta=0.1")
  testthat::expect_equal(68.1, round(x$en[1] * 100, 1), info = "Checking type3 sfPower (gsDesign en), k=3, rho=2, beta=0.1")
  y <- gsDesign::gsProbability(theta = x$delta * c(0, 0.5, 1), d = x)
  testthat::expect_equal(c(68.1, 83.9, 73.8), round(y$en * 100, 1), info = "Checking type3 sfPower (gsProb), k=3, rho=2, beta=0.1")
  x <- gsDesign::gsDesign(
    k = 4, test.type = 3, alpha = 0.05, sfu = sfPower,
    sfupar = 3, sfl = sfPower, sflpar = 3
  )
  testthat::expect_equal(104, round(x$n.I[4] * 100, 1), info = "Checking type3 sfPower (gsDesign n.I), k=4, rho=3, beta=0.1")
  testthat::expect_equal(69.2, round(x$en[1] * 100, 1), info = "Checking type3 sfPower (gsDesign en), k=4, rho=3, beta=0.1")
  y <- gsDesign::gsProbability(theta = x$delta * c(0, 0.5, 1), d = x)
  testthat::expect_equal(c(69.2, 84.2, 74.2), round(y$en * 100, 1), info = "Checking type3 sfPower (gsProb), k=3, rho=3, beta=0.1")
  x <- gsDesign::gsDesign(
    k = 2, test.type = 3, alpha = 0.05, beta = 0.2,
    sfu = sfPower, sfupar = 2, sfl = sfPower, sflpar = 2
  )
  testthat::expect_equal(104.3, round(x$n.I[2] * 100, 1), info = "Checking type3 sfPower (gsDesign n.I), k=2, rho=2, beta=0.2")
  testthat::expect_equal(74.5, round(x$en[1] * 100, 1), info = "Checking type3 sfPower (gsDesign en), k=2, rho=2, beta=0.2")
  y <- gsDesign::gsProbability(theta = x$delta * c(0, 0.5, 1), d = x)
  testthat::expect_equal(c(74.5, 87.8, 84.6), round(y$en * 100, 1), info = "Checking type3 sfPower (gsProb), k=2, rho=2, beta=0.2")
  x <- gsDesign::gsDesign(
    k = 15, test.type = 3, alpha = 0.05, beta = 0.2,
    sfu = sfPower, sfupar = 3, sfl = sfPower, sflpar = 3
  )
  testthat::expect_equal(106.9, round(x$n.I[15] * 100, 1), info = "Checking type3 sfPower (gsDesign n.I), k=15, rho=3, beta=0.2")
  testthat::expect_equal(62.2, round(x$en[1] * 100, 1), info = "Checking type3 sfPower (gsDesign en), k=15, rho=3, beta=0.2")
  y <- gsDesign::gsProbability(theta = x$delta * c(0, 0.5, 1), d = x)
  testthat::expect_equal(c(62.2, 77.3, 73), round(y$en * 100, 1), info = "Checking type3 sfPower (gsProb), k=15, rho=3, beta=0.2")
})

testthat::test_that("test.JT.WT", {
  x <- gsDesign::gsDesign(
    k = 9, test.type = 2, sfu = "WT", sfupar = 0.1,
    beta = 0.1
  )
  testthat::expect_equal(1.048, round(x$n.I[9], 3), info = "Checking 2-sided WT max SS, Delta=0.1, k=9, beta=0.1")
  testthat::expect_equal(2.113, round(x$upper$bound[9], 3), info = "Checking 2-sided WT bound, Delta=0.1, k=9, beta=0.1")
  x <- gsDesign::gsDesign(
    k = 6, test.type = 2, sfu = "WT", sfupar = 0.25,
    beta = 0.2
  )
  testthat::expect_equal(1.077, round(x$n.I[6], 3), info = "Checking 2-sided WT max SS, Delta=0.25, k=6, beta=0.2")
  testthat::expect_equal(2.154, round(x$upper$bound[6], 3), info = "Checking 2-sided WT bound, Delta=0.25, k=6, beta=0.2")
  x <- gsDesign::gsDesign(
    k = 7, test.type = 2, sfu = "WT", sfupar = 0.4,
    beta = 0.2
  )
  testthat::expect_equal(1.159, round(x$n.I[7], 3), info = "Checking 2-sided WT max SS, Delta=0.4, k=7, beta=0.2")
  testthat::expect_equal(2.313, round(x$upper$bound[7], 3), info = "Checking 2-sided WT bound, Delta=0.4, k=7, beta=0.2")
})

testthat::test_that("test.plot.gsDesign.plottype", {
  testthat::expect_error(gsDesign::plot.gsDesign(plottype = "abc"), info = "Checking for incorrect variable type")
  testthat::expect_error(gsDesign::plot.gsDesign(plottype = 0), info = "Checking for out-of-range variable value")
  testthat::expect_error(gsDesign::plot.gsDesign(plottype = 8), info = "Checking for out-of-range variable value")
  testthat::expect_error(gsDesign::plot.gsDesign(plottype = rep(2, 2)), info = "Checking for incorrect variable length")
})

testthat::test_that("test.plot.gsProbability.plottype", {
  testthat::expect_error(gsDesign::plot.gsProbability(plottype = "abc"), info = "Checking for incorrect variable type")
  testthat::expect_error(gsDesign::plot.gsProbability(plottype = 0), info = "Checking for out-of-range variable value")
  testthat::expect_error(gsDesign::plot.gsProbability(plottype = 8), info = "Checking for out-of-range variable value")
  testthat::expect_error(gsDesign::plot.gsProbability(plottype = rep(2, 2)), info = "Checking for incorrect variable length")
})

testthat::test_that("test.sfcauchy.param", {
  testthat::expect_error(sfcauchy(param = rep(1, 3)), info = "Checking for incorrect variable length")
  testthat::expect_error(sfcauchy(
    param = c(0.1, 0.6, 0.2, 0.05), k = 5,
    timing = c(0.1, 0.25, 0.4, 0.6)
  ), info = "Checking for out-of-order input sequence")
})

testthat::test_that("test.sfcauchy.param ", {
  testthat::expect_error(sfcauchy(param = "abc"), info = "Checking for incorrect variable type")
  testthat::expect_error(sfcauchy(param = c(1, 0)), info = "Checking for out-of-range variable value")
})

testthat::test_that("test.sfexp.param", {
  testthat::expect_error(sfexp(param = "abc"), info = "Checking for incorrect variable type")
  testthat::expect_error(sfexp(param = rep(1, 2)), info = "Checking for incorrect variable length")
  testthat::expect_error(sfexp(param = 0), info = "Checking for out-of-range variable value")
  testthat::expect_error(sfexp(param = 11), info = "Checking for out-of-range variable value")
})

testthat::test_that("test.sfHSD.param", {
  testthat::expect_error(gsDesign::sfHSD(param = "abc"), info = "Checking for incorrect variable type")
  testthat::expect_error(gsDesign::sfHSD(param = rep(1, 2)), info = "Checking for incorrect variable length")
  testthat::expect_error(gsDesign::sfHSD(param = -41), info = "Checking for out-of-range variable value")
  testthat::expect_error(gsDesign::sfHSD(param = 41), info = "Checking for out-of-range variable value")
})

testthat::test_that("test.sflogistic.param", {
  testthat::expect_error(sflogistic(param = rep(1, 3)), info = "Checking for incorrect variable length")
  testthat::expect_error(sflogistic(
    param = c(0.1, 0.6, 0.2, 0.05), k = 5,
    timing = c(0.1, 0.25, 0.4, 0.6)
  ), info = "Checking for out-of-order input sequence")
})

testthat::test_that("test.sflogistic.param ", {
  testthat::expect_error(sflogistic(param = "abc"), info = "Checking for incorrect variable type")
  testthat::expect_error(sflogistic(param = c(1, 0)), info = "Checking for out-of-range variable value")
})


testthat::test_that("test.sfnorm.param", {
  testthat::expect_error(sfnorm(param = rep(1, 3)), info = "Checking for incorrect variable length")
  testthat::expect_error(sfnorm(
    param = c(0.1, 0.6, 0.2, 0.05), k = 5,
    timing = c(0.1, 0.25, 0.4, 0.6)
  ), info = "Checking for out-of-order input sequence")
})

testthat::test_that("test.sfnorm.param ", {
  testthat::expect_error(sfnorm(param = "abc"), info = "Checking for incorrect variable type")
  testthat::expect_error(sfnorm(param = c(1, 0)), info = "Checking for out-of-range variable value")
})

testthat::test_that("test.sfpower.param", {
  testthat::expect_error(sfpower(param = "abc"), info = "Checking for incorrect variable type")
  testthat::expect_error(sfpower(param = rep(1, 2)), info = "Checking for incorrect variable length")
  testthat::expect_error(sfpower(param = -1), info = "Checking for out-of-range variable value")
})

testthat::test_that("test.sfTDist.param", {
  testthat::expect_error(gsDesign::sfTDist(param = rep(1, 4)), info = "Checking for incorrect variable length")
  testthat::expect_error(gsDesign::sfTDist(param = c(1, 0, 1)), info = "Checking for out-of-range variable value")
  testthat::expect_error(gsDesign::sfTDist(param = c(1, 1, 0.5)), info = "Checking for out-of-range variable value")
  testthat::expect_error(gsDesign::sfTDist(param = 1, 1:3 / 4, c(
    0.25, 0.5, 0.75,
    0.1, 0.2, 0.3
  )), info = "Checking for out-of-range variable value")
})

testthat::test_that("test.sfTDist.param ", {
  testthat::expect_error(gsDesign::sfTDist(param = "abc"), info = "Checking for incorrect variable type")
})

testthat::test_that("test.simBinomial.adj", {
  testthat::expect_error(gsDesign::simBinomial(
    adj = "abc", p1 = 0.1, p2 = 0.2,
    n1 = 1, n2 = 1
  ), info = "Checking for incorrect variable type")
  testthat::expect_error(gsDesign::simBinomial(
    adj = c(-1), p1 = 0.1, p2 = 0.2,
    n1 = 1, n2 = 1
  ), info = "Checking for out-of-range variable value")
  testthat::expect_error(gsDesign::simBinomial(
    adj = 2, p1 = 0.1, p2 = 0.2, n1 = 1,
    n2 = 1
  ), info = "Checking for out-of-range variable value")
  testthat::expect_error(gsDesign::simBinomial(
    adj = rep(1, 2), p1 = 0.1, p2 = 0.2,
    n1 = rep(1, 3), n2 = 1
  ), info = "Checking for incorrect variable length")
})

testthat::test_that("test.simBinomial.chisq", {
  testthat::expect_error(gsDesign::simBinomial(
    chisq = "abc", p1 = 0.1, p2 = 0.2,
    n1 = 1, n2 = 1
  ), info = "Checking for incorrect variable type")
  testthat::expect_error(gsDesign::simBinomial(
    chisq = c(-1), p1 = 0.1, p2 = 0.2,
    n1 = 1, n2 = 1
  ), info = "Checking for out-of-range variable value")
  testthat::expect_error(gsDesign::simBinomial(
    chisq = 2, p1 = 0.1, p2 = 0.2, n1 = 1,
    n2 = 1
  ), info = "Checking for out-of-range variable value")
  testthat::expect_error(gsDesign::simBinomial(
    chisq = rep(1, 2), p1 = 0.1, p2 = 0.2,
    n1 = 1, n2 = 1
  ), info = "Checking for incorrect variable length")
})

testthat::test_that("test.simBinomial.delta0", {
  testthat::expect_error(gsDesign::simBinomial(
    delta0 = "abc", p1 = 0.1, p2 = 0.2,
    n1 = 1, n2 = 1
  ), info = "Checking for incorrect variable type")
  testthat::expect_error(gsDesign::simBinomial(
    delta0 = c(-1), p1 = 0.1, p2 = 0.2,
    n1 = 1, n2 = 1
  ), info = "Checking for out-of-range variable value")
  testthat::expect_error(gsDesign::simBinomial(
    delta0 = 1, p1 = 0.1, p2 = 0.2,
    n1 = 1, n2 = 1
  ), info = "Checking for out-of-range variable value")
  testthat::expect_error(gsDesign::simBinomial(
    delta0 = rep(0.1, 2), p1 = 0.1,
    p2 = 0.2, n1 = 1, n2 = 1
  ), info = "Checking for incorrect variable length")
})

testthat::test_that("test.simBinomial.n1", {
  testthat::expect_error(gsDesign::simBinomial(
    n1 = "abc", p1 = 0.1, p2 = 0.2,
    n2 = 2
  ), info = "Checking for incorrect variable type")
  testthat::expect_error(gsDesign::simBinomial(n1 = 0, p1 = 0.1, p2 = 0.2, n2 = 2),
    info = "Checking for out-of-range variable value"
  )
  testthat::expect_error(gsDesign::simBinomial(
    n1 = rep(2, 2), p1 = 0.1, p2 = 0.2,
    n2 = 2
  ), info = "Checking for incorrect variable length")
})

testthat::test_that("test.simBinomial.n2", {
  testthat::expect_error(gsDesign::simBinomial(
    n2 = "abc", p1 = 0.1, p2 = 0.2,
    n1 = 2
  ), info = "Checking for incorrect variable type")
  testthat::expect_error(gsDesign::simBinomial(n2 = 0, p1 = 0.1, p2 = 0.2, n1 = 2),
    info = "Checking for out-of-range variable value"
  )
  testthat::expect_error(gsDesign::simBinomial(
    n2 = rep(2, 2), p1 = 0.1, p2 = 0.2,
    n1 = 2
  ), info = "Checking for incorrect variable length")
})

testthat::test_that("test.simBinomial.p1", {
  testthat::expect_error(gsDesign::simBinomial(p1 = "abc", p2 = 0.1, n1 = 1, n2 = 1),
    info = "Checking for incorrect variable type"
  )
  testthat::expect_error(gsDesign::simBinomial(p1 = 0, p2 = 0.1, n1 = 1, n2 = 1),
    info = "Checking for out-of-range variable value"
  )
  testthat::expect_error(gsDesign::simBinomial(p1 = 1, p2 = 0.1, n1 = 1, n2 = 1),
    info = "Checking for out-of-range variable value"
  )
  testthat::expect_error(gsDesign::simBinomial(
    p1 = rep(0.1, 2), p2 = 0.1, n1 = 1,
    n2 = 1
  ), info = "Checking for incorrect variable length")
})

testthat::test_that("test.simBinomial.p2", {
  testthat::expect_error(gsDesign::simBinomial(p2 = "abc", p1 = 0.1, n1 = 1, n2 = 1),
    info = "Checking for incorrect variable type"
  )
  testthat::expect_error(gsDesign::simBinomial(p2 = 0, p1 = 0.1, n1 = 1, n2 = 1),
    info = "Checking for out-of-range variable value"
  )
  testthat::expect_error(gsDesign::simBinomial(p2 = 1, p1 = 0.1, n1 = 1, n2 = 1),
    info = "Checking for out-of-range variable value"
  )
  testthat::expect_error(gsDesign::simBinomial(
    p2 = rep(0.2, 2), p1 = 0.1, n1 = 1,
    n2 = 1
  ), info = "Checking for incorrect variable length")
})

testthat::test_that("test.simBinomial.scale", {
  testthat::expect_error(gsDesign::simBinomial(
    scale = 1, p1 = 0.1, p2 = 0.2, n1 = 1,
    n2 = 1
  ), info = "Checking for incorrect variable type")
  testthat::expect_error(gsDesign::simBinomial(
    scale = "abc", p1 = 0.1, p2 = 0.2,
    n1 = 1, n2 = 1
  ), info = "Checking for out-of-range variable value")
  testthat::expect_error(gsDesign::simBinomial(
    scale = rep("RR", 2), p1 = 0.1,
    p2 = 0.2, n1 = 1, n2 = 1
  ), info = "Checking for incorrect variable length")
})

testthat::test_that("test.testBinomial.adj", {
  testthat::expect_error(gsDesign::testBinomial(
    adj = "abc", x1 = 2, x2 = 2, n1 = 2,
    n2 = 2
  ), info = "Checking for incorrect variable type")
  testthat::expect_error(gsDesign::testBinomial(
    adj = c(-1), x1 = 2, x2 = 2, n1 = 2,
    n2 = 2
  ), info = "Checking for out-of-range variable value")
  testthat::expect_error(gsDesign::testBinomial(
    adj = 2, x1 = 2, x2 = 2, n1 = 2,
    n2 = 2
  ), info = "Checking for out-of-range variable value")
  testthat::expect_error(gsDesign::testBinomial(
    adj = rep(1, 2), x1 = 2, x2 = 2,
    n1 = rep(2, 3), n2 = 2
  ), info = "Checking for incorrect variable length")
})

testthat::test_that("test.testBinomial.chisq", {
  testthat::expect_error(gsDesign::testBinomial(
    chisq = "abc", x1 = 2, x2 = 2,
    n1 = 2, n2 = 2
  ), info = "Checking for incorrect variable type")
  testthat::expect_error(gsDesign::testBinomial(
    chisq = c(-1), x1 = 2, x2 = 2,
    n1 = 2, n2 = 2
  ), info = "Checking for out-of-range variable value")
  testthat::expect_error(gsDesign::testBinomial(
    chisq = 2, x1 = 2, x2 = 2, n1 = 2,
    n2 = 2
  ), info = "Checking for out-of-range variable value")
  testthat::expect_error(gsDesign::testBinomial(
    chisq = rep(1, 2), x1 = 2, x2 = 2,
    n1 = rep(2, 3), n2 = 2
  ), info = "Checking for incorrect variable length")
})

testthat::test_that("test.testBinomial.delta0", {
  testthat::expect_error(gsDesign::testBinomial(
    delta0 = "abc", x1 = 2, x2 = 2,
    n1 = 2, n2 = 2
  ), info = "Checking for incorrect variable type")
  testthat::expect_error(gsDesign::testBinomial(
    delta0 = c(-1), x1 = 2, x2 = 2,
    n1 = 2, n2 = 2
  ), info = "Checking for out-of-range variable value")
  testthat::expect_error(gsDesign::testBinomial(
    delta0 = 1, x1 = 2, x2 = 2, n1 = 2,
    n2 = 2
  ), info = "Checking for out-of-range variable value")
  testthat::expect_error(gsDesign::testBinomial(
    delta0 = rep(0.1, 2), x1 = 2, x2 = 2,
    n1 = rep(2, 3), n2 = 2
  ), info = "Checking for incorrect variable length")
})

testthat::test_that("test.testBinomial.n1", {
  testthat::expect_error(gsDesign::testBinomial(n1 = "abc", x1 = 2, x2 = 2, n2 = 2),
    info = "Checking for incorrect variable type"
  )
  testthat::expect_error(gsDesign::testBinomial(n1 = 0, x1 = 0, x2 = 2, n2 = 2),
    info = "Checking for out-of-range variable value"
  )
})

testthat::test_that("test.testBinomial.n2", {
  testthat::expect_error(gsDesign::testBinomial(n2 = "abc", x1 = 2, x2 = 2, n1 = 2),
    info = "Checking for incorrect variable type"
  )
  testthat::expect_error(gsDesign::testBinomial(n2 = 0, x1 = 2, x2 = 0, n1 = 2),
    info = "Checking for out-of-range variable value"
  )
})

testthat::test_that("test.testBinomial.scale", {
  testthat::expect_error(gsDesign::testBinomial(
    scale = 1, x1 = 2, x2 = 2, n1 = 2,
    n2 = 2
  ), info = "Checking for incorrect variable type")
  testthat::expect_error(gsDesign::testBinomial(
    scale = "abc", x1 = 2, x2 = 2,
    n1 = 2, n2 = 2
  ), info = "Checking for out-of-range variable value")
  testthat::expect_error(gsDesign::testBinomial(
    scale = rep("RR", 2), x1 = 2, x2 = 2,
    n1 = 2, n2 = 2
  ), info = "Checking for incorrect variable length")
})

testthat::test_that("test.testBinomial.tol", {
  testthat::expect_error(gsDesign::testBinomial(
    tol = "abc", x1 = 2, x2 = 2, n1 = 2,
    n2 = 2
  ), info = "Checking for incorrect variable type")
  testthat::expect_error(gsDesign::testBinomial(
    tol = 0, x1 = 2, x2 = 2, n1 = 2,
    n2 = 2
  ), info = "Checking for out-of-range variable value")
})

testthat::test_that("test.testBinomial.x1", {
  testthat::expect_error(gsDesign::testBinomial(x1 = "abc", x2 = 2, n1 = 2, n2 = 2),
    info = "Checking for incorrect variable type"
  )
  testthat::expect_error(gsDesign::testBinomial(x1 = 3, x2 = 2, n1 = 2, n2 = 2),
    info = "Checking for out-of-range variable value"
  )
  testthat::expect_error(gsDesign::testBinomial(x1 = c(-1), x2 = 2, n1 = 2, n2 = 2),
    info = "Checking for out-of-range variable value"
  )
  testthat::expect_error(gsDesign::testBinomial(x1 = rep(2, 2), x2 = 2, n1 = rep(
    2,
    3
  ), n2 = 2), info = "Checking for incorrect variable length")
})

testthat::test_that("test.testBinomial.x2", {
  testthat::expect_error(gsDesign::testBinomial(x2 = "abc", x1 = 2, n1 = 2, n2 = 2),
    info = "Checking for incorrect variable type"
  )
  testthat::expect_error(gsDesign::testBinomial(x2 = 3, x1 = 2, n1 = 2, n2 = 2),
    info = "Checking for out-of-range variable value"
  )
  testthat::expect_error(gsDesign::testBinomial(x2 = c(-1), x1 = 2, n1 = 2, n2 = 2),
    info = "Checking for out-of-range variable value"
  )
  testthat::expect_error(gsDesign::testBinomial(x2 = rep(2, 2), x1 = 2, n1 = rep(
    2,
    3
  ), n2 = 2), info = "Checking for incorrect variable length")
})

testthat::test_that("test.ciBinomial.misc", {
  testthat::expect_equal(as.numeric(gsDesign::ciBinomial(
    x1 = 0, x2 = 0, n1 = 10,
    n2 = 20, adj = 1, scale = "difference"
  )), c(
    -0.1658,
    0.2843608
  ), info = "ciBinomial numeric check #1 failed (M&N example 4", tolerance = 0.0001)
  testthat::expect_equal(as.numeric(gsDesign::ciBinomial(
    x1 = 72, x2 = 20, n1 = 756,
    n2 = 573, adj = 1, scale = "difference"
  )), c(
    0.0344,
    0.0868
  ), info = "ciBinomial numeric check #2 failed", tolerance = 0.0001)
  testthat::expect_equal(as.numeric(gsDesign::ciBinomial(
    x1 = 10, x2 = 20, n1 = 10,
    n2 = 20, adj = 1, scale = "rr"
  )), c(0.7156205, 1.198696),
  info = "ciBinomial numeric check #3 failed (M&N example 6", tolerance = 0.0001
  )
})

testthat::test_that("test.ciBinomial.ORscale.Infinity", {
  testthat::expect_equal(gsDesign::ciBinomial(
    scale = "OR", x1 = 0, x2 = 4, n1 = 100,
    n2 = 100
  )$lower, -Inf, info = "ciBinomial infinity check #1 failed")
  testthat::expect_equal(gsDesign::ciBinomial(
    scale = "OR", x1 = 4, x2 = 0, n1 = 100,
    n2 = 100
  )$upper, Inf, info = "ciBinomial infinity check #2 failed")
  testthat::expect_equal(gsDesign::ciBinomial(
    scale = "OR", x1 = 100, x2 = 96,
    n1 = 100, n2 = 100
  )$upper, Inf, info = "ciBinomial infinity check #3 failed")
  testthat::expect_equal(gsDesign::ciBinomial(
    scale = "OR", x1 = 96, x2 = 100,
    n1 = 100, n2 = 100
  )$lower, -Inf, info = "ciBinomial infinity check #4 failed")
  testthat::expect_equal(gsDesign::ciBinomial(
    scale = "OR", x1 = 0, x2 = 0, n1 = 100,
    n2 = 100
  ), data.frame(lower = -Inf, upper = Inf), info = "ciBinomial infinity check #5 failed")
  testthat::expect_equal(gsDesign::ciBinomial(
    scale = "OR", x1 = 100, x2 = 100,
    n1 = 100, n2 = 100
  ), data.frame(lower = -Inf, upper = Inf),
  info = "ciBinomial infinity check #6 failed"
  )
})

testthat::test_that("test.ciBinomial.RRscale.Infinity", {
  testthat::expect_equal(gsDesign::ciBinomial(
    scale = "RR", x1 = 4, x2 = 0, n1 = 100,
    n2 = 100
  )$upper, Inf, info = "ciBinomial infinity check #7 failed")
  testthat::expect_equal(gsDesign::ciBinomial(
    scale = "RR", x1 = 0, x2 = 0, n1 = 100,
    n2 = 100
  )$upper, Inf, info = "ciBinomial infinity check #8 failed")
})

testthat::test_that("test.nBinomial.misc", {
  testthat::expect_equal(gsDesign::nBinomial(
    p1 = 0.4, p2 = 0.05, alpha = 0.05,
    beta = 0.2, delta0 = 0.2, scale = "difference"
  ), 159.6876,
  info = "nBinomial check #1 failed (F&M, bottom p 1451)", tolerance = 0.0001
  )
  testthat::expect_equal(as.numeric(gsDesign::nBinomial(
    p1 = 0.1, p2 = 0.1, alpha = 0.05,
    delta0 = -0.2, ratio = 2 / 3, scale = "difference", outtype = 2
  )),
  c(62.88, 41.92),
  info = "nBinomial check #2 failed (F&M, Table 1)", tolerance = 0.0001
  )
  testthat::expect_equal(as.numeric(gsDesign::nBinomial(
    p1 = 0.25, p2 = 0.05, delta0 = 0.1,
    alpha = 0.05, ratio = 3 / 2, scale = "difference", outtype = 2
  )),
  c(173.2214, 259.8322),
  info = "nBinomial check #3 failed (F&M, Table 1)", tolerance = 0.0001
  )
  testthat::expect_equal(as.numeric(gsDesign::nBinomial(
    p1 = 0.25, p2 = 0.05, delta0 = log(2),
    alpha = 0.05, ratio = 3 / 2, scale = "rr", outtype = 2
  )),
  c(133.9289, 200.8933),
  info = "nBinomial check #4 failed (F&M, Table 1)", tolerance = 0.0001
  )
  testthat::expect_equal(gsDesign::nBinomial(p1 = 0.15, p2 = 0.1, beta = 0.2, scale = "or"),
    1355.84,
    info = "nBinomial check #5 failed (OR scale)"
  )
  testthat::expect_equal(as.numeric(gsDesign::nBinomial(
    p1 = 0.15, p2 = 0.1, beta = 0.2,
    delta0 = log(1.1), ratio = 3 / 2, scale = "or", outtype = 2
  )),
  c(900.57, 1350.85),
  info = "nBinomial check #6 failed (OR scale)", tolerance = 0.0001
  )
})

## these simulations are stochastic, hence must loosen the tolerance so will not invalidated
testthat::test_that("test.simBinomial.misc", {
  testthat::expect_equal(sum(-stats::qnorm(0.05) < gsDesign::simBinomial(
    p1 = 0.4, p2 = 0.05,
    delta0 = 0.2, n1 = 80, n2 = 80, nsim = 1e+05
  )) / 1e+05,
  0.813,
  info = "simBinomial check #1 failed (F&M bottom p 1451)", tolerance = 0.01
  )
  testthat::expect_equal(sum(-stats::qnorm(0.05) < gsDesign::simBinomial(
    p1 = 0.1, p2 = 0.1,
    delta0 = -0.2, n1 = 63, n2 = 42, nsim = 1e+05
  )) / 1e+05,
  0.916,
  info = "simBinomial check #2 failed (F&M Table 1)", tolerance = 0.01
  )
  testthat::expect_equal(sum(-stats::qnorm(0.05) < gsDesign::simBinomial(
    p1 = 0.25, p2 = 0.05,
    delta0 = 0.1, n1 = 173, n2 = 260, nsim = 1e+05
  )) / 1e+05,
  0.906,
  info = "simBinomial check #3 failed (F&M Table 1)", tolerance = 0.01
  )
  testthat::expect_equal(sum(-stats::qnorm(0.025) < gsDesign::simBinomial(
    p1 = 0.15, p2 = 0.1,
    delta0 = log(1.1), n1 = 901, n2 = 1351, scale = "lnor",
    nsim = 1e+05
  )) / 1e+05, 0.79875, info = "simBinomial check #4 failed", tolerance = 0.01)
  testthat::expect_equal(sum(-stats::qnorm(0.025) < gsDesign::simBinomial(
    p1 = 0.15, p2 = 0.1,
    delta0 = log(1.1), n1 = 901, n2 = 1351, scale = "or",
    nsim = 1e+05
  )) / 1e+05, 0.8056, info = "simBinomial check #5 failed", tolerance = 0.01)
  testthat::expect_equal(sum(-stats::qnorm(0.05) < gsDesign::simBinomial(
    p1 = 0.25, p2 = 0.05,
    delta0 = log(2), n1 = 134, n2 = 201, scale = "rr", nsim = 1e+05
  )) / 1e+05,
  0.9078,
  info = "simBinomial check #6 failed (F&M Table 1)", tolerance = 0.01
  )
})

testthat::test_that("test.testBinomial.numerics", {
  testthat::expect_equal(gsDesign::testBinomial(
    x1 = 0, x2 = 0, n1 = 10, n2 = 20,
    adj = 1, scale = "difference", delta = c(-0.1658, 0.2843608)
  ),
  c(1.959962, -1.959865),
  info = "Error in testBinomial example 1 (M&N example 4)", tolerance = 0.0001
  )
  testthat::expect_equal(gsDesign::testBinomial(
    x1 = 10, x2 = 20, n1 = 10, n2 = 20,
    adj = 1, scale = "rr", delta = log(c(0.715615, 1.198703))
  ),
  c(1.96, -1.96),
  info = "Error in testBinomial example 2 (M&N example 6)", tolerance = 0.0001
  )
  testthat::expect_equal(gsDesign::testBinomial(
    x1 = 53, x2 = 40, n1 = 100, n2 = 100,
    scale = "LNOR", delta = c(-0.03152, 1.104)
  ), c(
    1.964856,
    -1.963414
  ), info = "Error in testBinomial example 3 (p 27, Lachin)", tolerance = 0.0001)
  testthat::expect_equal(gsDesign::testBinomial(
    x1 = 53, x2 = 40, n1 = 100, n2 = 100,
    scale = "OR", delta = c(-0.03463, 1.085673)
  ), c(
    1.965205,
    -1.96461
  ), info = "Error in testBinomial example 4 (p 27, Lachin)", tolerance = 0.0001)
})

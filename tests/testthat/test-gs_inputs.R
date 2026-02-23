testthat::context("gs inputs")

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
  testthat::expect_error(gsDesign::gsDesign(test.type = 9), info = "Checking for out-of-range variable value")
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

# Regression tests for the numerical integration layer (gsbound, gsbound1,
# probrej, gsdensity, stdnorpts and their R wrappers).
#
# The fixture file pins the outputs of gsDesign 3.11.0 (Jennison & Turnbull
# grid, r = 18 unless stated) to 13 significant digits. Any change to the C
# integration code that is meant to be behavior-preserving must keep these
# tests passing; an intentional algorithm change must regenerate the fixtures
# (see the header of the fixture file) and document the differences.

fx <- local({
  source(testthat::test_path("fixtures", "numint-fixtures.R"), local = TRUE)
  numint_fixtures
})
tol <- 1e-10

testthat::test_that("gsDesign() bounds, information and crossing probabilities are unchanged", {
  for (nm in names(fx$gsDesign)) {
    case <- fx$gsDesign[[nm]]
    x <- eval(parse(text = case$call))
    testthat::expect_equal(x$k, case$k, info = nm)
    testthat::expect_equal(x$n.I, case$n.I, tolerance = tol, info = nm)
    testthat::expect_equal(x$upper$bound, case$upper, tolerance = tol, info = nm)
    testthat::expect_equal(unname(x$upper$prob), unname(case$upper_prob), tolerance = tol, info = nm)
    testthat::expect_equal(x$en, case$en, tolerance = tol, info = nm)
    testthat::expect_equal(x$theta, case$theta, tolerance = tol, info = nm)
    if (!is.null(case$lower)) {
      testthat::expect_equal(x$lower$bound, case$lower, tolerance = tol, info = nm)
      testthat::expect_equal(unname(x$lower$prob), unname(case$lower_prob), tolerance = tol, info = nm)
    }
    if (!is.null(case$harm)) {
      testthat::expect_equal(x$harm$bound, case$harm, tolerance = tol, info = nm)
      testthat::expect_equal(unname(x$harm$prob), unname(case$harm_prob), tolerance = tol, info = nm)
    }
    if (!is.null(case$falseposnb)) {
      testthat::expect_equal(x$falseposnb, case$falseposnb, tolerance = tol, info = nm)
    }
  }
})

testthat::test_that("gsProbability() crossing probabilities and expected information are unchanged", {
  for (nm in names(fx$gsProbability)) {
    case <- fx$gsProbability[[nm]]
    z <- do.call(gsProbability, case$args)
    testthat::expect_equal(unname(z$upper$prob), unname(case$upper), tolerance = tol, info = nm)
    testthat::expect_equal(unname(z$lower$prob), unname(case$lower), tolerance = tol, info = nm)
    testthat::expect_equal(z$en, case$en, tolerance = tol, info = nm)
  }
})

testthat::test_that("gsBound() and gsBound1() boundaries are unchanged", {
  for (nm in names(fx$gsBound)) {
    case <- fx$gsBound[[nm]]
    y <- eval(parse(text = case$call))
    testthat::expect_equal(y$a, case$a, tolerance = tol, info = nm)
    testthat::expect_equal(y$b, case$b, tolerance = tol, info = nm)
    testthat::expect_equal(y$error, case$error, info = nm)
    if (!is.null(case$problo)) {
      testthat::expect_equal(y$problo, case$problo, tolerance = tol, info = nm)
    }
  }
})

testthat::test_that("gsDensity() sub-densities are unchanged", {
  xd <- gsDesign(k = 4, test.type = 4)
  d <- gsDensity(xd, theta = c(0, xd$delta), i = 2, zi = seq(-3, 4, 0.5))
  testthat::expect_equal(d$density, fx$gsDensity$i2$density, tolerance = tol)
  d <- gsDensity(xd, theta = c(0, xd$delta, 2 * xd$delta), i = 4, zi = c(-2, 0, 1.5, 2.5, 3.5), r = 10)
  testthat::expect_equal(d$density, fx$gsDensity$i4_r10$density, tolerance = tol)
  d <- gsDensity(xd, theta = 0.1, i = 1, zi = c(-1, 0, 1))
  testthat::expect_equal(d$density, fx$gsDensity$i1$density, tolerance = tol)
})

testthat::test_that("normalGrid() points and weights are unchanged", {
  g <- normalGrid()
  testthat::expect_equal(g$z, fx$normalGrid$default$z, tolerance = tol)
  testthat::expect_equal(g$gridwgts, fx$normalGrid$default$gridwgts, tolerance = tol)
  testthat::expect_equal(sum(g$wgts), fx$normalGrid$default$wgts_sum, tolerance = tol)
  g <- normalGrid(r = 3, mu = 2, sigma = 3)
  testthat::expect_equal(g$z, fx$normalGrid$r3$z, tolerance = tol)
  testthat::expect_equal(g$gridwgts, fx$normalGrid$r3$gridwgts, tolerance = tol)
  g <- normalGrid(bounds = c(-1, 1))
  testthat::expect_equal(length(g$z), fx$normalGrid$bounds$n)
  testthat::expect_equal(sum(g$wgts), fx$normalGrid$bounds$wgts_sum, tolerance = tol)
})

testthat::test_that("conditional and predictive power helpers built on the integration layer are unchanged", {
  xd <- gsDesign(k = 4, test.type = 4)
  y <- gsCP(xd, i = 2, zi = 1.2, theta = c(0, xd$delta))
  testthat::expect_equal(unname(y$upper$prob), unname(fx$gsCP$gsCP$upper), tolerance = tol)
  testthat::expect_equal(unname(y$lower$prob), unname(fx$gsCP$gsCP$lower), tolerance = tol)
  testthat::expect_equal(y$n.I, fx$gsCP$gsCP$n.I, tolerance = tol)
  testthat::expect_equal(gsPP(xd, i = 2, zi = 1.2), fx$gsCP$gsPP, tolerance = tol)
  testthat::expect_equal(gsPI(xd, i = 2, zi = 1.2, j = 3), fx$gsCP$gsPI, tolerance = 1e-6)
  testthat::expect_equal(gsPOS(xd, theta = c(0, xd$delta), wgts = c(.5, .5)), fx$gsCP$gsPOS, tolerance = tol)
  testthat::expect_equal(gsCPOS(i = 2, xd, theta = c(0, xd$delta), wgts = c(.5, .5)), fx$gsCP$gsCPOS, tolerance = tol)
  testthat::expect_equal(unname(as.matrix(gsBoundCP(xd))), unname(fx$gsCP$gsBoundCP), tolerance = tol)
  testthat::expect_equal(gsBoundCP(gsDesign(k = 3, test.type = 1)), fx$gsCP$gsBoundCP1, tolerance = tol)
  testthat::expect_equal(
    sequentialPValue(gsD = xd, n.I = c(100, 200, 300, 400), Z = c(1, 2, 2.5, 3), usTime = c(.25, .5, .75, 1)),
    fx$sequentialPValue, tolerance = 1e-6
  )
})

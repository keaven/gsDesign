# Tests for the Gauss-Legendre quadrature option
# (options(gsDesign.quadrature = "gl")) of the recursive integration.

fx <- local({
  source(testthat::test_path("fixtures", "numint-fixtures.R"), local = TRUE)
  numint_fixtures
})

with_gl <- function(expr) {
  old <- options(gsDesign.quadrature = "gl")
  on.exit(options(old), add = TRUE)
  force(expr)
}

testthat::test_that("the quadrature option is validated", {
  testthat::expect_equal(gsQuadratureMethod(), 0L)
  testthat::expect_equal(with_gl(gsQuadratureMethod()), 1L)
  old <- options(gsDesign.quadrature = "simpson")
  on.exit(options(old), add = TRUE)
  testthat::expect_error(gsQuadratureMethod(), "gsDesign.quadrature")
})

testthat::test_that("Gauss-Legendre quadrature matches exact multivariate normal probabilities", {
  for (nm in names(fx$exact)) {
    p <- fx$exact[[nm]]$args
    z <- with_gl(gsProbability(k = p$k, theta = p$theta, n.I = p$n.I, a = p$a, b = p$b))
    # reference accuracy is about 1e-10; the JT grid with r = 18 is about 1e-7
    testthat::expect_lt(max(abs(z$upper$prob - fx$exact[[nm]]$upper)), 2e-9, label = paste(nm, "upper"))
    testthat::expect_lt(max(abs(z$lower$prob - fx$exact[[nm]]$lower)), 2e-9, label = paste(nm, "lower"))
  }
})

testthat::test_that("Gauss-Legendre results agree with the default grid within its accuracy", {
  # Excluded: "r6" (the default grid with r = 6 is only accurate to about 1e-5)
  # and "crossed" (bounds with a > b at an analysis: the default grid then
  # carries negative Simpson weights, whereas Gauss-Legendre treats the empty
  # continuation region as having no mass, so later probabilities are 0).
  for (nm in setdiff(names(fx$gsProbability), c("r6", "crossed"))) {
    case <- fx$gsProbability[[nm]]
    z <- with_gl(do.call(gsProbability, case$args))
    testthat::expect_lt(max(abs(z$upper$prob - case$upper)), 5e-7, label = paste(nm, "upper"))
    testthat::expect_lt(max(abs(z$lower$prob - case$lower)), 5e-7, label = paste(nm, "lower"))
  }
  for (nm in names(fx$gsDesign)) {
    case <- fx$gsDesign[[nm]]
    x <- with_gl(eval(parse(text = case$call)))
    testthat::expect_equal(x$n.I, case$n.I, tolerance = 1e-5, info = nm)
    testthat::expect_equal(x$upper$bound, case$upper, tolerance = 1e-5, info = nm)
    if (!is.null(case$lower)) testthat::expect_equal(x$lower$bound, case$lower, tolerance = 1e-5, info = nm)
  }
})

testthat::test_that("Gauss-Legendre is self-consistent and stable for demanding designs", {
  designs <- list(
    list(k = 20, test.type = 4),
    list(k = 20, test.type = 1, sfu = sfLDPocock),
    list(k = 4, test.type = 4, timing = c(0.1, 0.2, 0.9)),
    list(k = 3, test.type = 4, timing = c(0.5, 0.98))
  )
  for (d in designs) {
    x <- with_gl(do.call(gsDesign, d))
    a <- if (x$test.type == 1) rep(-Inf, x$k) else x$lower$bound
    theta <- x$delta * c(0, 1, 2, 5, -1)
    p18 <- with_gl(gsProbability(k = x$k, theta = theta, n.I = x$n.I, a = a, b = x$upper$bound, r = 18))
    p60 <- with_gl(gsProbability(k = x$k, theta = theta, n.I = x$n.I, a = a, b = x$upper$bound, r = 60))
    testthat::expect_lt(max(abs(p18$upper$prob - p60$upper$prob)), 1e-9)
    testthat::expect_lt(max(abs(p18$lower$prob - p60$lower$prob)), 1e-9)
    # the design attains its error rates under its own bounds
    testthat::expect_lt(abs(sum(x$upper$prob[, 2]) - (1 - x$beta)), 2 * x$tol)
    if (x$test.type == 4) testthat::expect_lt(abs(sum(x$falseposnb) - x$alpha), 2 * x$tol)
  }
})

testthat::test_that("Gauss-Legendre resolves a narrow information increment followed by a wide one", {
  # An analysis with (almost) no new information and no bound must not change
  # the design: the final bound equals that of the two-analysis design.
  ref <- with_gl(gsBound1(theta = 0, I = c(1, 3), a = rep(-Inf, 2), probhi = c(0.001, 0.024)))$b[2]
  # (resolution is capped at 992 nodes, so accuracy degrades gradually below
  # an information increment of 1e-3 relative to the previous analysis)
  for (eps in c(1e-2, 1e-3, 1e-4)) {
    y <- with_gl(gsBound1(theta = 0, I = c(1, 1 + eps, 3), a = rep(-Inf, 3), probhi = c(0.001, 0, 0.024)))
    testthat::expect_equal(y$b[3], ref, tolerance = if (eps < 1e-3) 1e-5 else 1e-6, info = paste("eps", eps))
  }
  x <- gsDesign(k = 3, test.type = 4, timing = c(0.5, 0.9))
  I <- x$n.I[3] * c(0.5, 0.505, 1)
  p18 <- with_gl(gsProbability(k = 3, theta = c(0, x$delta), n.I = I, a = x$lower$bound, b = x$upper$bound, r = 18))
  p60 <- with_gl(gsProbability(k = 3, theta = c(0, x$delta), n.I = I, a = x$lower$bound, b = x$upper$bound, r = 60))
  testthat::expect_lt(max(abs(p18$upper$prob - p60$upper$prob), abs(p18$lower$prob - p60$lower$prob)), 1e-9)
})

testthat::test_that("Gauss-Legendre handles infinite bounds and empty continuation regions", {
  # crossed bounds at analysis 2: no continuation, so nothing can cross later
  cr <- with_gl(gsProbability(k = 3, theta = c(0, 1), n.I = 1:3, a = c(0, 2.5, 1.9), b = c(2.5, 2.2, 1.9)))
  testthat::expect_equal(unname(cr$upper$prob[3, ]), c(0, 0))
  testthat::expect_equal(unname(cr$lower$prob[3, ]), c(0, 0))
  p <- with_gl(gsProbability(k = 3, theta = c(0, 1, 5), n.I = 1:3, a = rep(-Inf, 3), b = c(Inf, Inf, 1.96)))
  testthat::expect_equal(p$upper$prob[1:2, ], matrix(0, 2, 3))
  testthat::expect_equal(p$upper$prob[3, ], pnorm(1.96 - c(0, 1, 5) * sqrt(3), lower.tail = FALSE), tolerance = 1e-9)
  # bounds crossed at analysis 1: nothing continues
  q <- with_gl(gsProbability(k = 3, theta = 0, n.I = 1:3, a = c(1, 0, 0), b = c(1, 2, 2)))
  testthat::expect_equal(sum(q$upper$prob) + sum(q$lower$prob), 1, tolerance = 1e-12)
  testthat::expect_equal(q$upper$prob[2:3, 1], c(0, 0))
  # zero spending at an interim gives an infinite bound with either method
  y <- with_gl(gsBound1(theta = 0, I = c(1, 2, 3), a = rep(-Inf, 3), probhi = c(0.001, 0, 0.024)))
  testthat::expect_equal(y$b[2], Inf)
  testthat::expect_equal(y$b, gsBound1(theta = 0, I = c(1, 2, 3), a = rep(-Inf, 3), probhi = c(0.001, 0, 0.024))$b, tolerance = 1e-6)
})

testthat::test_that("gsDensity() integrates to the continuation probability under Gauss-Legendre", {
  x <- with_gl(gsDesign(k = 3, test.type = 4))
  g <- normalGrid(r = 40, bounds = c(-8, 8))
  for (i in 2:3) {
    d <- with_gl(gsDensity(x, theta = c(0, x$delta), i = i, zi = g$z))
    cont <- 1 - colSums(x$upper$prob[1:(i - 1), , drop = FALSE]) - colSums(x$lower$prob[1:(i - 1), , drop = FALSE])
    testthat::expect_equal(as.numeric(g$gridwgts %*% d$density), cont, tolerance = 1e-6)
  }
})

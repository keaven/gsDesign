# Correctness tests for the numerical integration layer against exact
# multivariate normal probabilities.
#
# Reference values were computed with mvtnorm::pmvnorm(algorithm = Miwa(steps
# = 4096)) (deterministic, accurate to about 1e-10) for the canonical joint
# distribution of Jennison & Turnbull (2000), equation (3.1), and stored in the
# fixture file so that mvtnorm is not needed at test time. These tests hold for
# any correct integration scheme; the tolerance reflects the accuracy of the
# default Jennison & Turnbull grid with r = 18 (about 1e-7).

fx <- local({
  source(testthat::test_path("fixtures", "numint-fixtures.R"), local = TRUE)
  numint_fixtures
})

testthat::test_that("gsProbability() matches exact multivariate normal probabilities", {
  for (nm in names(fx$exact)) {
    case <- fx$exact[[nm]]
    p <- case$args
    z <- gsProbability(k = p$k, theta = p$theta, n.I = p$n.I, a = p$a, b = p$b)
    testthat::expect_lt(max(abs(z$upper$prob - case$upper)), 5e-7, label = paste(nm, "upper"))
    testthat::expect_lt(max(abs(z$lower$prob - case$lower)), 5e-7, label = paste(nm, "lower"))
  }
})

testthat::test_that("gsProbability() is consistent with a finer integration grid", {
  for (nm in names(fx$exact)) {
    p <- fx$exact[[nm]]$args
    z18 <- gsProbability(k = p$k, theta = p$theta, n.I = p$n.I, a = p$a, b = p$b, r = 18)
    z80 <- gsProbability(k = p$k, theta = p$theta, n.I = p$n.I, a = p$a, b = p$b, r = 80)
    testthat::expect_lt(max(abs(z18$upper$prob - z80$upper$prob)), 5e-7, label = paste(nm, "upper"))
    testthat::expect_lt(max(abs(z18$lower$prob - z80$lower$prob)), 5e-7, label = paste(nm, "lower"))
    testthat::expect_lt(max(abs(z80$upper$prob - fx$exact[[nm]]$upper)), 2e-9, label = paste(nm, "upper r=80"))
  }
})

testthat::test_that("boundaries derived by gsBound1() reproduce their target crossing probabilities exactly", {
  for (K in c(2, 3, 5)) {
    x <- gsDesign(k = K, test.type = 1, sfu = sfLDOF)
    fp <- x$upper$spend
    y <- gsBound1(theta = 0, I = x$n.I, a = rep(-20, K), probhi = fp, tol = 1e-9)
    p <- gsProbability(k = K, theta = 0, n.I = x$n.I, a = rep(-20, K), b = y$b, r = 80)
    # r = 80 evaluation of r = 18 boundaries: agreement limited by the r = 18 error
    testthat::expect_lt(max(abs(as.numeric(p$upper$prob) - fp)), 5e-7)
  }
})

testthat::test_that("gsDensity() integrates to the continuation probability", {
  x <- gsDesign(k = 3, test.type = 4)
  g <- normalGrid(r = 40, bounds = c(-8, 8))
  for (i in 2:3) {
    d <- gsDensity(x, theta = c(0, x$delta), i = i, zi = g$z, r = 40)
    cont <- 1 - colSums(x$upper$prob[1:(i - 1), , drop = FALSE]) - colSums(x$lower$prob[1:(i - 1), , drop = FALSE])
    testthat::expect_equal(as.numeric(g$gridwgts %*% d$density), cont, tolerance = 1e-6)
  }
})

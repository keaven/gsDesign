testthat::context("binomial sim inputs")

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

testthat::context("ci binomial inputs")

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

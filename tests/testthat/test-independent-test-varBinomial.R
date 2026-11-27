testthat::test_that(
  desc = "Test : out of range x",
  code = {
    expect_error(varBinomial(
      x = -1, n = 100, delta0 = 0, ratio = 1,
      scale = "Difference"
    ))
  }
)



testthat::test_that(
  desc = "Test : out of range delta0",
  code = {
    expect_error(varBinomial(
      x = 50, n = 100, delta0 = 10, ratio = 1,
      scale = "Difference"
    ))
  }
)


testthat::test_that(
  desc = "Test : out of range delta0",
  code = {
    expect_error(varBinomial(
      x = 50, n = 100, delta0 = 0, ratio = -1,
      scale = "Difference"
    ))
  }
)



testthat::test_that(
  desc = "Test : out of range delta0",
  code = {
    expect_error(varBinomial(
      x = 50, n = 0, delta0 = 0, ratio = 1,
      scale = "Difference"
    ))
  }
)


testthat::test_that(
  desc = "Test : out of range delta0",
  code = {
    expect_error(varBinomial(
      x = 50, n = 100, delta0 = Inf, ratio = 1,
      scale = "rr"
    ))
  }
)


testthat::test_that(
  desc = "Test : output Validation scale = 'rr' 
                    source : independent R Program helper.R",
  code = {
    x <- 50
    n <- 100
    delta0 <- 0.5
    ratio <- 1
    scale <- "rr"

    res <- varBinomial(x, n, delta0, ratio, scale)
    expected_res <- validate_varBinom_rr(x, n, delta = delta0, ratio, scale)
    expect_equal(res, expected_res)
  }
)


testthat::test_that(
  desc = "Test : output Validation scale = 'RR' 
                    source : independent R Program helper.R",
  code = {
    x <- 36
    n <- 300
    delta0 <- 0.2
    ratio <- 2
    scale <- "RR"

    res <- varBinomial(x, n, delta0, ratio, scale)
    expected_res <- validate_varBinom_rr(x, n, delta = delta0, ratio, scale)
    expect_equal(res, expected_res)
  }
)


testthat::test_that(
  desc = "Test : output Validation scale = 'OR' 
                    source : independent R Program helper.R",
  code = {
    x <- 36
    n <- 300
    delta0 <- 0.2
    ratio <- 2
    scale <- "OR"

    res <- varBinomial(x, n, delta0, ratio, scale)
    expected_res <- validate_varBinom_or(x, n, delta = delta0, ratio)
    expect_equal(res, expected_res)
  }
)


testthat::test_that(
  desc = "Test : output Validation scale = 'RR' 
                    source : independent R Program helper.R",
  code = {
    x <- 36
    n <- 300
    delta0 <- 0
    ratio <- 2
    scale <- "RR"

    res <- varBinomial(x, n, delta0, ratio, scale)
    expected_res <- validate_varBinom_rr(x, n, delta = delta0, ratio)
    expect_equal(res, expected_res)
  }
)


testthat::test_that(
  desc = "Test : output Validation scale = 'OR'
                    source : independent R Program helper.R",
  code = {
    x <- 36
    n <- 300
    delta0 <- 0
    ratio <- 2
    scale <- "OR"

    res <- varBinomial(x, n, delta0, ratio, scale)
    expected_res <- validate_varBinom_or(x, n, delta = delta0, ratio)
    expect_equal(res, expected_res)
  }
)


testthat::test_that(
  desc = "Test : output Validation scale = 'Difference'
                    source : independent R Program helper.R",
  code = {
    x <- 50
    n <- 300
    delta0 <- 0
    ratio <- 3
    scale <- "Difference"

    res <- varBinomial(x, n, delta0, ratio, scale)
    expected_res <- validate_varBinom_Diff(x, n, delta = delta0, ratio)
    expect_equal(res, expected_res)
  }
)

testthat::test_that(
  desc = "Test : output Validation scale = 'Difference' with non-zero delta0",
  code = {
    for (ratio in c(1, 2)) {
      for (delta0 in c(0.1, -0.1)) {
        x <- 60
        n <- 300
        p <- x / n
        p1 <- p + ratio * delta0 / (ratio + 1)
        p2 <- p1 - delta0
        n1 <- n / (1 + ratio)
        n2 <- n - n1
        expected <- p1 * (1 - p1) / n1 + p2 * (1 - p2) / n2

        res <- varBinomial(x = x, n = n, delta0 = delta0, ratio = ratio, scale = "Difference")
        expect_equal(res, expected, tolerance = 1e-10)
      }
    }
  }
)

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

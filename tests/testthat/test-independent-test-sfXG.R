# Generalized test template for Xi-Gallo spending functions
test_sfXG_function <- function(fun, name, compute_expected, valid_param, param_bounds, alpha = 0.025) {
  t_vals <- c(0.25, 0.5, 1)

  # Tests to check that the correct structure is returned
  test_that(paste0(name, " returns correct structure"), {
    res <- fun(alpha, t_vals, valid_param)
    expect_s3_class(res, "spendfn")
    expect_named(res, c("name", "param", "parname", "sf", "spend", "bound", "prob"))
    expect_equal(res$name, name)
    expect_equal(res$param, valid_param)
    expect_equal(res$parname, "gamma")
    expect_identical(res$sf, fun)
  })

  # Tests for Spending values
  test_that(paste0(name, " computes expected spending values"), {
    res <- fun(alpha, t_vals, valid_param)
    expected <- compute_expected(alpha, t_vals, valid_param)
    expect_equal(res$spend, expected)
  })

  # tests for t > 1
  test_that(paste0(name, " caps t > 1 at 1"), {
    spend_at_1 <- fun(alpha, 1, valid_param)$spend
    spend_over_1 <- fun(alpha, c(2, 3, 10), valid_param)$spend
    expect_equal(spend_over_1, rep(spend_at_1, length(spend_over_1)))
  })

  # tests for spending < 1
  test_that(paste0(name, " spending is always < 1"), {
    res1 <- fun(alpha, 1, valid_param)$spend
    res2 <- fun(alpha, 2, valid_param)$spend
    expect_true(all(res1 < 1))
    expect_true(all(res2 < 1))
  })

  # test for invalid parameter handling
  test_that(paste0(name, " rejects invalid gamma"), {
    lower_bound <- param_bounds[1]
    upper_bound <- param_bounds[2]

    # Below lower bound
    expect_error(fun(alpha, 0.5, lower_bound - 0.001))

    # At upper bound (exclusive)
    expect_error(fun(alpha, 0.5, upper_bound))

    # Above upper bound
    expect_error(fun(alpha, 0.5, upper_bound + 0.001))

    # Wrong type
    expect_error(fun(alpha, 0.5, "bad"))
  })
}


# Define expected spending functions
expected_sfXG1 <- function(alpha, t, gamma) {
  2 - 2 * pnorm((qnorm(1 - alpha / 2) -
    qnorm(1 - gamma) * sqrt(1 - pmin(t, 1))) /
    sqrt(pmin(t, 1)))
}

expected_sfXG2 <- function(alpha, t, gamma) {
  2 - 2 * pnorm((qnorm(1 - alpha / 2) -
    qnorm(1 - gamma) * (1 - pmin(t, 1))) /
    sqrt(pmin(t, 1)))
}

expected_sfXG3 <- function(alpha, t, gamma) {
  2 - 2 * pnorm((qnorm(1 - alpha / 2) -
    qnorm(1 - gamma) * (1 - sqrt(pmin(t, 1)))) /
    sqrt(pmin(t, 1)))
}

# Define test configurations
sfXG_specs <- list(
  list(
    fun = sfXG1,
    name = "Xi-Gallo, method 1",
    expected = expected_sfXG1,
    valid_param = 0.6, # Note: For sfXG1, valid_param must be in [0.5, 1)
    param_bounds = c(0.5, 1) # lower inclusive, upper exclusive
  ),
  list(
    fun = sfXG2,
    name = "Xi-Gallo, method 2",
    expected = expected_sfXG2,
    valid_param = 0.8, # Note: For sfXG2, valid_param must be in [1 - pnorm(qnorm(1 - 0.025 / 2)), 1)
    param_bounds = c(1 - pnorm(qnorm(1 - 0.025 / 2)), 1)
  ),
  list(
    fun = sfXG3,
    name = "Xi-Gallo, method 1",
    expected = expected_sfXG3,
    valid_param = 0.6, # Note: For sfXG3, valid_param must be in (0.025 / 2, 1)
    param_bounds = c(0.025 / 2, 1)
  )
)

# Iteratively run parameterized tests
for (spec in sfXG_specs) {
  test_sfXG_function(
    fun = spec$fun,
    name = spec$name,
    compute_expected = spec$expected,
    valid_param = spec$valid_param,
    param_bounds = spec$param_bounds
  )
}

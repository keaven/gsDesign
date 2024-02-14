#-----------------------------------
# Test binomialSPRT function
#-----------------------------------
## For comparing floating-point numbers, an exact match cannot be expected.
## For such test cases,the tolerance is set to 1e-6 (= 0.000001), a sufficiently
## low value.

validate_vd <- Validate_comp_sprt_bnd(
  alpha = 0.1, beta = 0.15, p0 = 0.05, p1 = 0.25,
  nmin = 10, nmax = 35
)

exct_des <- gsBinomialExact(
  k = nrow(validate_vd$bounds), theta <- c(0.05, 0.25),
  n.I = validate_vd$bounds$n,
  a = validate_vd$bounds$lbrnd, b = validate_vd$bounds$ubrnd
)




testthat::test_that(desc = "Test binomialSPRT function
                    source : independent R Program-helper.R", code = {
  binSPRT <- binomialSPRT(
    p0 = 0.05,
    p1 = 0.25,
    alpha = 0.1,
    beta = 0.15,
    minn = 10,
    maxn = 35
  )

  testthat::expect_equal(
    object = binSPRT$k,
    expected = exct_des$k,
    info = "Validate value of K - Number of planned analysis"
  )


  testthat::expect_true(
    object = all(binSPRT$n.I == exct_des$n.I),
    info = "Validate value of n.I - Sample Size"
  )


  testthat::expect_true(
    object = all(binSPRT$lower$bound == exct_des$lower$bound),
    info = "Validate value of binomialSPRT lower bound"
  )


  testthat::expect_true(
    object = all(binSPRT$upper$bound == exct_des$upper$bound),
    info = "Validate value of binomialSPRT upper bound "
  )

  testthat::expect_lte(
    object = (abs(binSPRT$slope - validate_vd$slope)),
    expected = 1e-6
  )

  # Test for y-intercept of lower boundary
  testthat::expect_lte(
    object = (abs(binSPRT$intercept[1] - validate_vd$upint)),
    expected = 1e-6
  )

  # Test for y-intercept of upper boundary
  testthat::expect_lte(
    object = (abs(binSPRT$intercept[2] - validate_vd$lowint)),
    expected = 1e-6
  )

  # Test for expected sample size under H0 : p0 = 0.05
  testthat::expect_lte(
    object = abs(binSPRT$en[1] - exct_des$en[1]),
    expected = 1e-6
  )


  # Test for expected sample size under H1 : p1 = 0.25
  testthat::expect_lte(
    object = abs(binSPRT$en[2] - exct_des$en[2]),
    expected = 1e-6
  )

  # Validate lower probability for analysis 15 under H0 : p0 = 0.05
  testthat::expect_lte(
    object = abs(binSPRT$lower$prob[15, 1] - exct_des$lower$prob[15, 1]),
    expected = 1e-6
  )

  # Validate lower probability for analysis 15 under H1 : p1 = 0.25
  testthat::expect_lte(
    object = abs(binSPRT$lower$prob[15, 2] - exct_des$lower$prob[15, 2]),
    expected = 1e-6
  )

  # Validate lower probability for analysis 23 under H0 : p0 = 0.05
  actual_output <- c(binSPRT$lower$prob[23, 1], binSPRT$lower$prob[23, 2])
  testthat::expect_lte(
    object = abs(actual_output[1] - exct_des$lower$prob[23, 1]),
    expected = 1e-6
  )

  # Validate lower probability for analysis 23 under H1 : p1 = 0.25
  testthat::expect_lte(
    object = abs(actual_output[2] - exct_des$lower$prob[23, 2]),
    expected = 1e-6
  )

  # Validate upper probability for analysis 15 under H0 : p0 = 0.05
  actual_output <- c(binSPRT$upper$prob[15, 1], binSPRT$upper$prob[15, 2])
  testthat::expect_lte(
    object = abs(actual_output[1] - exct_des$upper$prob[15, 1]),
    expected = 1e-6
  )

  # Validate upper probability for analysis 15 under H1 : p1 = 0.25
  testthat::expect_lte(
    object = abs(actual_output[2] - exct_des$upper$prob[15, 2]),
    expected = 1e-6
  )


  # Validate upper probability for analysis 23 under H0 : p0 = 0.05
  actual_output <- c(binSPRT$upper$prob[23, 1], binSPRT$upper$prob[23, 2])
  testthat::expect_lte(
    object = abs(actual_output[1] - exct_des$upper$prob[23, 1]),
    expected = 1e-6
  )

  # Validate upper probability for analysis 23 under H1 : p1 = 0.25
  testthat::expect_lte(
    object = abs(actual_output[2] - exct_des$upper$prob[23, 2]),
    expected = 1e-6
  )
})

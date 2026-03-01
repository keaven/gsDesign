testthat::context("testUpper/testLower/testHarm selective bound testing")

EXTREMEZ <- 20

# ---- Validation tests ----

testthat::test_that("testUpper must be TRUE at the final analysis", {
  testthat::expect_error(
    gsDesign(k = 3, test.type = 3, testUpper = c(TRUE, TRUE, FALSE)),
    "testUpper must be TRUE at the final analysis"
  )
})

testthat::test_that("testLower must be logical scalar or vector of length k", {
  testthat::expect_error(
    gsDesign(k = 3, test.type = 3, testLower = c(TRUE, FALSE)),
    "testLower must be a logical scalar or vector of length k"
  )
  testthat::expect_error(
    gsDesign(k = 3, test.type = 3, testLower = "yes"),
    "testLower must be a logical scalar or vector of length k"
  )
})

testthat::test_that("testUpper must be logical scalar or vector of length k", {
  testthat::expect_error(
    gsDesign(k = 3, test.type = 3, testUpper = c(TRUE, TRUE)),
    "testUpper must be a logical scalar or vector of length k"
  )
  testthat::expect_error(
    gsDesign(k = 3, test.type = 3, testUpper = 1),
    "testUpper must be a logical scalar or vector of length k"
  )
})

testthat::test_that("testHarm must be logical scalar or vector of length k", {
  testthat::expect_error(
    gsDesign(k = 3, test.type = 7, testHarm = c(TRUE, FALSE)),
    "testHarm must be a logical scalar or vector of length k"
  )
})

testthat::test_that("testLower must be TRUE for at least one analysis (test.type > 2)", {
  testthat::expect_error(
    gsDesign(k = 3, test.type = 3, testLower = FALSE),
    "testLower must be TRUE for at least one analysis"
  )
})

testthat::test_that("testHarm must be TRUE for at least one analysis (test.type 7/8)", {
  testthat::expect_error(
    gsDesign(k = 3, test.type = 7, testHarm = FALSE),
    "testHarm must be TRUE for at least one analysis"
  )
  testthat::expect_error(
    gsDesign(k = 3, test.type = 8, testHarm = FALSE),
    "testHarm must be TRUE for at least one analysis"
  )
})

testthat::test_that("At least one bound must be active at each analysis", {
  testthat::expect_error(
    gsDesign(k = 3, test.type = 4,
      testUpper = c(FALSE, TRUE, TRUE),
      testLower = c(FALSE, TRUE, TRUE)
    ),
    "at least one of testUpper, testLower, or testHarm must be TRUE"
  )
})

# ---- Default behavior unchanged ----

testthat::test_that("Default testUpper/testLower/testHarm returns same design as before", {
  x_default <- gsDesign(k = 3, test.type = 4, alpha = 0.025, beta = 0.1)
  x_explicit <- gsDesign(k = 3, test.type = 4, alpha = 0.025, beta = 0.1,
    testUpper = TRUE, testLower = TRUE
  )
  testthat::expect_equal(x_default$upper$bound, x_explicit$upper$bound)
  testthat::expect_equal(x_default$lower$bound, x_explicit$lower$bound)
  testthat::expect_equal(x_default$upper$prob, x_explicit$upper$prob)
  testthat::expect_equal(x_default$lower$prob, x_explicit$lower$prob)
  testthat::expect_equal(x_default$en, x_explicit$en)
})

testthat::test_that("Default testHarm for test.type 7/8 returns same design", {
  x_default <- gsDesign(k = 3, test.type = 7, alpha = 0.025, beta = 0.1)
  x_explicit <- gsDesign(k = 3, test.type = 7, alpha = 0.025, beta = 0.1,
    testUpper = TRUE, testLower = TRUE, testHarm = TRUE
  )
  testthat::expect_equal(x_default$upper$bound, x_explicit$upper$bound)
  testthat::expect_equal(x_default$lower$bound, x_explicit$lower$bound)
  testthat::expect_equal(x_default$harm$bound, x_explicit$harm$bound)
})

# ---- test.type 1 and 2 overrides ----

testthat::test_that("test.type 1 overrides testLower to FALSE", {
  x <- gsDesign(k = 3, test.type = 1, testLower = TRUE)
  testthat::expect_equal(x$testLower, rep(FALSE, 3))
})

testthat::test_that("test.type 2 overrides testUpper and testLower to TRUE", {
  x <- gsDesign(k = 3, test.type = 2, testUpper = FALSE, testLower = FALSE)
  testthat::expect_equal(x$testUpper, rep(TRUE, 3))
  testthat::expect_equal(x$testLower, rep(TRUE, 3))
})

testthat::test_that("test.type 1 overrides testUpper to TRUE", {
  x <- gsDesign(k = 3, test.type = 1)
  testthat::expect_equal(x$testUpper, rep(TRUE, 3))
})

# ---- Selective testLower ----

testthat::test_that("testLower = c(TRUE, FALSE, FALSE) sets inactive lower bounds to -EXTREMEZ", {
  x <- gsDesign(k = 3, test.type = 4, testLower = c(TRUE, FALSE, FALSE))
  testthat::expect_true(abs(x$lower$bound[1]) < EXTREMEZ) # active

  testthat::expect_equal(x$lower$bound[2], -EXTREMEZ)
  testthat::expect_equal(x$lower$bound[3], -EXTREMEZ)
  testthat::expect_equal(x$testLower, c(TRUE, FALSE, FALSE))
})

testthat::test_that("testLower selective: upper bounds unchanged from full design", {
  x_full <- gsDesign(k = 3, test.type = 4, alpha = 0.025, beta = 0.1)
  x_sel <- gsDesign(k = 3, test.type = 4, alpha = 0.025, beta = 0.1,
    testLower = c(TRUE, FALSE, FALSE)
  )
  # Upper bounds should be identical since they are computed before applying testLower
  testthat::expect_equal(x_full$upper$bound, x_sel$upper$bound)
})

testthat::test_that("testLower selective: cumulative futility prob does not increase at inactive analyses", {
  x <- gsDesign(k = 3, test.type = 4, testLower = c(TRUE, FALSE, FALSE))
  # Cumulative futility probability under H1
  cum_fut_h1 <- cumsum(x$lower$prob[, 2])
  # Should not increase after IA1 since lower bound is -20
  testthat::expect_equal(cum_fut_h1[1], cum_fut_h1[2], tolerance = 1e-8)
  testthat::expect_equal(cum_fut_h1[1], cum_fut_h1[3], tolerance = 1e-8)
})

testthat::test_that("testLower = c(FALSE, TRUE, FALSE) with test.type 3", {
  x <- gsDesign(k = 3, test.type = 3, testLower = c(FALSE, TRUE, FALSE))
  testthat::expect_equal(x$lower$bound[1], -EXTREMEZ)
  testthat::expect_true(abs(x$lower$bound[2]) < EXTREMEZ) # active
  testthat::expect_equal(x$lower$bound[3], -EXTREMEZ)
})

# ---- Selective testUpper ----

testthat::test_that("testUpper = c(FALSE, TRUE, TRUE) sets inactive upper bound to +EXTREMEZ", {
  x <- gsDesign(k = 3, test.type = 4, testUpper = c(FALSE, TRUE, TRUE))
  testthat::expect_equal(x$upper$bound[1], EXTREMEZ)
  testthat::expect_true(x$upper$bound[2] < EXTREMEZ) # active
  testthat::expect_true(x$upper$bound[3] < EXTREMEZ) # active (final)
  testthat::expect_equal(x$testUpper, c(FALSE, TRUE, TRUE))
})

testthat::test_that("testUpper selective: cumulative efficacy prob is 0 at inactive IA", {
  x <- gsDesign(k = 3, test.type = 4, testUpper = c(FALSE, TRUE, TRUE))
  # Crossing probability under H0 at IA1 should be essentially 0
  testthat::expect_true(x$upper$prob[1, 1] < 1e-10)
})

# ---- Selective testHarm (test.type 7/8) ----

testthat::test_that("testHarm = c(TRUE, TRUE, FALSE) sets inactive harm bound to -EXTREMEZ", {
  x <- gsDesign(k = 3, test.type = 8, alpha = 0.025, beta = 0.1, astar = 0.05,
    testHarm = c(TRUE, TRUE, FALSE)
  )
  testthat::expect_true(x$harm$bound[1] > -EXTREMEZ) # active
  testthat::expect_true(x$harm$bound[2] > -EXTREMEZ) # active
  testthat::expect_equal(x$harm$bound[3], -EXTREMEZ)
  testthat::expect_equal(x$testHarm, c(TRUE, TRUE, FALSE))
})

testthat::test_that("testHarm = c(TRUE, FALSE, FALSE) with test.type 7", {
  x <- gsDesign(k = 3, test.type = 7, alpha = 0.025, beta = 0.1,
    testHarm = c(TRUE, FALSE, FALSE)
  )
  testthat::expect_true(x$harm$bound[1] > -EXTREMEZ)
  testthat::expect_equal(x$harm$bound[2], -EXTREMEZ)
  testthat::expect_equal(x$harm$bound[3], -EXTREMEZ)
})

# ---- Combining testUpper and testLower ----

testthat::test_that("Combined: futility only at IA1, efficacy only at IA2 and final", {
  x <- gsDesign(k = 3, test.type = 4,
    testUpper = c(FALSE, TRUE, TRUE),
    testLower = c(TRUE, FALSE, FALSE)
  )
  testthat::expect_equal(x$upper$bound[1], EXTREMEZ)
  testthat::expect_true(x$upper$bound[2] < EXTREMEZ)
  testthat::expect_true(x$upper$bound[3] < EXTREMEZ)
  testthat::expect_true(x$lower$bound[1] > -EXTREMEZ)
  testthat::expect_equal(x$lower$bound[2], -EXTREMEZ)
  testthat::expect_equal(x$lower$bound[3], -EXTREMEZ)
})

# ---- Scalar input recycling ----

testthat::test_that("Scalar TRUE testLower is recycled to vector of length k", {
  x <- gsDesign(k = 4, test.type = 4, testLower = TRUE)
  testthat::expect_equal(x$testLower, rep(TRUE, 4))
})

testthat::test_that("Scalar TRUE testUpper is recycled to vector of length k", {
  x <- gsDesign(k = 4, test.type = 3, testUpper = TRUE)
  testthat::expect_equal(x$testUpper, rep(TRUE, 4))
})

# ---- Stored flags ----

testthat::test_that("testUpper/testLower/testHarm stored on returned object", {
  x <- gsDesign(k = 3, test.type = 4, testLower = c(TRUE, FALSE, FALSE))
  testthat::expect_equal(x$testUpper, rep(TRUE, 3))
  testthat::expect_equal(x$testLower, c(TRUE, FALSE, FALSE))
  testthat::expect_equal(x$testHarm, rep(FALSE, 3))
})

testthat::test_that("testHarm flags stored for test.type 7", {
  x <- gsDesign(k = 3, test.type = 7, testHarm = c(TRUE, TRUE, FALSE))
  testthat::expect_equal(x$testHarm, c(TRUE, TRUE, FALSE))
})

# ---- gsBoundSummary NA masking ----

testthat::test_that("gsBoundSummary shows NA for inactive futility bounds", {
  x <- gsDesign(k = 3, test.type = 4, testLower = c(TRUE, FALSE, FALSE))
  r <- gsBoundSummary(x)
  # Use Z-value rows to identify each analysis
  z_rows <- which(r$Value == "Z")
  fut_vals <- r$Futility
  # IA1 futility should not be NA (active)
  testthat::expect_false(is.na(fut_vals[z_rows[1]]))
  # IA2 and Final futility should be NA (inactive)
  testthat::expect_true(is.na(fut_vals[z_rows[2]]))
  testthat::expect_true(is.na(fut_vals[z_rows[3]]))
})

testthat::test_that("gsBoundSummary shows NA for inactive efficacy bounds", {
  x <- gsDesign(k = 3, test.type = 4, testUpper = c(FALSE, TRUE, TRUE))
  r <- gsBoundSummary(x)
  z_rows <- which(r$Value == "Z")
  eff_vals <- r$Efficacy
  # IA1 efficacy should be NA (inactive)
  testthat::expect_true(is.na(eff_vals[z_rows[1]]))
  # IA2 and Final efficacy should NOT be NA
  testthat::expect_false(is.na(eff_vals[z_rows[2]]))
  testthat::expect_false(is.na(eff_vals[z_rows[3]]))
})

testthat::test_that("gsBoundSummary works with exclude = NULL", {
  x <- gsDesign(k = 3, test.type = 4, testLower = c(TRUE, FALSE, FALSE))
  r <- gsBoundSummary(x, exclude = NULL)
  testthat::expect_s3_class(r, "gsBoundSummary")
  # Should have more rows than default (includes B-value, Spending, CP, etc.)
  r_default <- gsBoundSummary(x)
  testthat::expect_true(nrow(r) > nrow(r_default))
})

testthat::test_that("gsBoundSummary shows NA for inactive harm bounds", {
  x <- gsDesign(k = 3, test.type = 8, alpha = 0.025, beta = 0.1, astar = 0.05,
    testHarm = c(TRUE, TRUE, FALSE)
  )
  r <- gsBoundSummary(x)
  testthat::expect_true("Harm" %in% names(r))
  z_rows <- which(r$Value == "Z")
  harm_vals <- r$Harm
  # IA1 and IA2 harm should not be NA (active)
  testthat::expect_false(is.na(harm_vals[z_rows[1]]))
  testthat::expect_false(is.na(harm_vals[z_rows[2]]))
  # Final harm should be NA (inactive)
  testthat::expect_true(is.na(harm_vals[z_rows[3]]))
})

# ---- print.gsDesign NA masking ----

testthat::test_that("print.gsDesign shows NA for inactive lower bounds", {
  x <- gsDesign(k = 3, test.type = 4, testLower = c(TRUE, FALSE, FALSE))
  output <- capture.output(print(x))
  output_text <- paste(output, collapse = "\n")
  # Should contain NA in the lower bounds section
  testthat::expect_true(grepl("NA", output_text))
})

# ---- gsSurv passthrough ----

testthat::test_that("gsSurv passes testLower through to gsDesign", {
  x <- gsSurv(
    k = 3, test.type = 4,
    alpha = 0.025, beta = 0.1,
    hr = 0.7, timing = c(0.5, 0.75),
    sfu = sfHSD, sfupar = -4,
    sfl = sfHSD, sflpar = -2,
    lambdaC = log(2) / 12,
    eta = 0.01, gamma = 10,
    R = 12, T = 36, minfup = 24,
    testLower = c(TRUE, FALSE, FALSE)
  )
  testthat::expect_equal(x$testLower, c(TRUE, FALSE, FALSE))
  testthat::expect_equal(x$lower$bound[2], -EXTREMEZ)
  testthat::expect_equal(x$lower$bound[3], -EXTREMEZ)
})

testthat::test_that("gsSurv passes testUpper through to gsDesign", {
  x <- gsSurv(
    k = 3, test.type = 4,
    alpha = 0.025, beta = 0.1,
    hr = 0.7, timing = c(0.5, 0.75),
    sfu = sfHSD, sfupar = -4,
    sfl = sfHSD, sflpar = -2,
    lambdaC = log(2) / 12,
    eta = 0.01, gamma = 10,
    R = 12, T = 36, minfup = 24,
    testUpper = c(FALSE, TRUE, TRUE)
  )
  testthat::expect_equal(x$testUpper, c(FALSE, TRUE, TRUE))
  testthat::expect_equal(x$upper$bound[1], EXTREMEZ)
})

# ---- Type I error control ----

testthat::test_that("Type I error controlled when lower bounds are selectively removed (non-binding)", {
  x <- gsDesign(k = 3, test.type = 4, alpha = 0.025, beta = 0.1,
    testLower = c(TRUE, FALSE, FALSE)
  )
  # For non-binding futility (test.type 4), actual alpha <= nominal alpha
  type_I <- sum(x$upper$prob[, 1])
  testthat::expect_true(type_I <= x$alpha + 1e-6)
  testthat::expect_true(type_I > 0) # should still have some alpha spent
})

testthat::test_that("Type I error controlled when upper bounds are selectively removed (non-binding)", {
  x <- gsDesign(k = 3, test.type = 4, alpha = 0.025, beta = 0.1,
    testUpper = c(FALSE, TRUE, TRUE)
  )
  # For non-binding futility (test.type 4), actual alpha <= nominal alpha
  type_I <- sum(x$upper$prob[, 1])
  testthat::expect_true(type_I <= x$alpha + 1e-6)
  testthat::expect_true(type_I > 0)
})

# ---- k = 2 designs ----

testthat::test_that("k = 2 with testLower = c(TRUE, FALSE)", {
  x <- gsDesign(k = 2, test.type = 4, testLower = c(TRUE, FALSE))
  testthat::expect_equal(x$lower$bound[2], -EXTREMEZ)
  testthat::expect_true(x$lower$bound[1] > -EXTREMEZ)
})

testthat::test_that("k = 2 with testUpper = c(FALSE, TRUE)", {
  x <- gsDesign(k = 2, test.type = 3, testUpper = c(FALSE, TRUE))
  testthat::expect_equal(x$upper$bound[1], EXTREMEZ)
  testthat::expect_true(x$upper$bound[2] < EXTREMEZ)
})

# ---- Multiple test.types ----

testthat::test_that("testLower works with test.type 3 (binding futility)", {
  x <- gsDesign(k = 3, test.type = 3, testLower = c(TRUE, TRUE, FALSE))
  testthat::expect_equal(x$lower$bound[3], -EXTREMEZ)
  testthat::expect_true(x$lower$bound[1] > -EXTREMEZ)
  testthat::expect_true(x$lower$bound[2] > -EXTREMEZ)
})

testthat::test_that("testLower works with test.type 5", {
  x <- gsDesign(k = 3, test.type = 5, testLower = c(TRUE, FALSE, FALSE))
  testthat::expect_equal(x$lower$bound[2], -EXTREMEZ)
  testthat::expect_equal(x$lower$bound[3], -EXTREMEZ)
})

testthat::test_that("testLower works with test.type 6", {
  x <- gsDesign(k = 3, test.type = 6, testLower = c(TRUE, FALSE, FALSE))
  testthat::expect_equal(x$lower$bound[2], -EXTREMEZ)
  testthat::expect_equal(x$lower$bound[3], -EXTREMEZ)
})

# ---- gsSurvCalendar passthrough ----

testthat::test_that("gsSurvCalendar passes testLower through to gsDesign", {
  cal <- gsSurvCalendar(
    test.type = 4,
    alpha = 0.025,
    beta = 0.2,
    hr = 0.7,
    calendarTime = c(12, 24, 36),
    spending = c(0.25, 0.5, 1),
    lambdaC = log(2) / 12,
    eta = 0.01,
    gamma = 10,
    R = 12,
    minfup = 24,
    testLower = c(TRUE, FALSE, FALSE)
  )
  testthat::expect_equal(cal$testLower, c(TRUE, FALSE, FALSE))
  testthat::expect_equal(cal$lower$bound[2], -EXTREMEZ)
  testthat::expect_equal(cal$lower$bound[3], -EXTREMEZ)
})

# ---- Alpha preservation tests ----

testthat::test_that("Binding test.type 3: alpha preserved when skipping lower bounds", {
  d_base <- gsDesign(k = 3, test.type = 3, alpha = 0.025, beta = 0.1,
                     sfu = sfHSD, sfupar = -4, sfl = sfHSD, sflpar = -2)
  d_sel <- gsDesign(k = 3, test.type = 3, alpha = 0.025, beta = 0.1,
                    sfu = sfHSD, sfupar = -4, sfl = sfHSD, sflpar = -2,
                    testLower = c(TRUE, FALSE, FALSE))
  # Sample size must be identical
  testthat::expect_equal(d_sel$n.I, d_base$n.I)
  # Alpha must be exactly 0.025 for binding design
  alpha_sel <- sum(d_sel$upper$prob[, 1])
  testthat::expect_equal(alpha_sel, 0.025, tolerance = 1e-6)
})

testthat::test_that("Binding test.type 3: alpha preserved when skipping upper bounds", {
  d_base <- gsDesign(k = 3, test.type = 3, alpha = 0.025, beta = 0.1,
                     sfu = sfHSD, sfupar = -4, sfl = sfHSD, sflpar = -2)
  d_sel <- gsDesign(k = 3, test.type = 3, alpha = 0.025, beta = 0.1,
                    sfu = sfHSD, sfupar = -4, sfl = sfHSD, sflpar = -2,
                    testUpper = c(FALSE, TRUE, TRUE))
  testthat::expect_equal(d_sel$n.I, d_base$n.I)
  alpha_sel <- sum(d_sel$upper$prob[, 1])
  testthat::expect_equal(alpha_sel, 0.025, tolerance = 1e-6)
})

testthat::test_that("Binding test.type 3: alpha preserved with mixed skips", {
  d_base <- gsDesign(k = 3, test.type = 3, alpha = 0.025, beta = 0.1,
                     sfu = sfHSD, sfupar = -4, sfl = sfHSD, sflpar = -2)
  d_sel <- gsDesign(k = 3, test.type = 3, alpha = 0.025, beta = 0.1,
                    sfu = sfHSD, sfupar = -4, sfl = sfHSD, sflpar = -2,
                    testUpper = c(FALSE, TRUE, TRUE),
                    testLower = c(TRUE, FALSE, TRUE))
  testthat::expect_equal(d_sel$n.I, d_base$n.I)
  alpha_sel <- sum(d_sel$upper$prob[, 1])
  testthat::expect_equal(alpha_sel, 0.025, tolerance = 1e-6)
})

testthat::test_that("Non-binding test.type 4: non-binding alpha preserved when skipping lower", {
  d_base <- gsDesign(k = 3, test.type = 4, alpha = 0.025, beta = 0.1,
                     sfu = sfHSD, sfupar = -4, sfl = sfHSD, sflpar = -2)
  d_sel <- gsDesign(k = 3, test.type = 4, alpha = 0.025, beta = 0.1,
                    sfu = sfHSD, sfupar = -4, sfl = sfHSD, sflpar = -2,
                    testLower = c(TRUE, FALSE, FALSE))
  testthat::expect_equal(d_sel$n.I, d_base$n.I)
  # Non-binding alpha (computed with lower = -20) must equal 0.025
  nb_alpha <- sum(gsprob(0, d_sel$n.I, rep(-20, 3), d_sel$upper$bound, r = d_sel$r)$probhi)
  testthat::expect_equal(nb_alpha, 0.025, tolerance = 1e-6)
  # Upper bounds must be identical to baseline (non-binding upper doesn't depend on lower)
  testthat::expect_equal(d_sel$upper$bound, d_base$upper$bound)
})

testthat::test_that("Non-binding test.type 4: non-binding alpha preserved when skipping upper", {
  d_base <- gsDesign(k = 3, test.type = 4, alpha = 0.025, beta = 0.1,
                     sfu = sfHSD, sfupar = -4, sfl = sfHSD, sflpar = -2)
  d_sel <- gsDesign(k = 3, test.type = 4, alpha = 0.025, beta = 0.1,
                    sfu = sfHSD, sfupar = -4, sfl = sfHSD, sflpar = -2,
                    testUpper = c(FALSE, TRUE, TRUE))
  testthat::expect_equal(d_sel$n.I, d_base$n.I)
  nb_alpha <- sum(gsprob(0, d_sel$n.I, rep(-20, 3), d_sel$upper$bound, r = d_sel$r)$probhi)
  testthat::expect_equal(nb_alpha, 0.025, tolerance = 1e-6)
})

testthat::test_that("Binding test.type 7: alpha preserved with selective harm", {
  d_base <- gsDesign(k = 3, test.type = 7, alpha = 0.025, beta = 0.1,
                     sfu = sfHSD, sfupar = -4, sfl = sfHSD, sflpar = -2,
                     sfharm = sfHSD, sfharmparam = -2)
  d_sel <- gsDesign(k = 3, test.type = 7, alpha = 0.025, beta = 0.1,
                    sfu = sfHSD, sfupar = -4, sfl = sfHSD, sflpar = -2,
                    sfharm = sfHSD, sfharmparam = -2,
                    testHarm = c(TRUE, FALSE, TRUE))
  testthat::expect_equal(d_sel$n.I, d_base$n.I)
  alpha_sel <- sum(d_sel$upper$prob[, 1])
  testthat::expect_equal(alpha_sel, 0.025, tolerance = 1e-6)
})

testthat::test_that("Non-binding test.type 8: non-binding alpha preserved with selective harm", {
  d_base <- gsDesign(k = 3, test.type = 8, alpha = 0.025, beta = 0.1,
                     sfu = sfHSD, sfupar = -4, sfl = sfHSD, sflpar = -2,
                     sfharm = sfHSD, sfharmparam = -2)
  d_sel <- gsDesign(k = 3, test.type = 8, alpha = 0.025, beta = 0.1,
                    sfu = sfHSD, sfupar = -4, sfl = sfHSD, sflpar = -2,
                    sfharm = sfHSD, sfharmparam = -2,
                    testHarm = c(TRUE, FALSE, TRUE))
  testthat::expect_equal(d_sel$n.I, d_base$n.I)
  nb_alpha <- sum(gsprob(0, d_sel$n.I, rep(-20, 3), d_sel$upper$bound, r = d_sel$r)$probhi)
  testthat::expect_equal(nb_alpha, 0.025, tolerance = 1e-6)
})

testthat::test_that("Binding test.type 5: alpha preserved when skipping lower", {
  d_base <- gsDesign(k = 3, test.type = 5, alpha = 0.025, beta = 0.1,
                     sfu = sfHSD, sfupar = -4, sfl = sfHSD, sflpar = -2)
  d_sel <- gsDesign(k = 3, test.type = 5, alpha = 0.025, beta = 0.1,
                    sfu = sfHSD, sfupar = -4, sfl = sfHSD, sflpar = -2,
                    testLower = c(TRUE, FALSE, FALSE))
  testthat::expect_equal(d_sel$n.I, d_base$n.I)
  alpha_sel <- sum(d_sel$upper$prob[, 1])
  testthat::expect_equal(alpha_sel, 0.025, tolerance = 1e-6)
})

testthat::test_that("Upper spending is unchanged when only lower bounds are skipped", {
  d_base <- gsDesign(k = 3, test.type = 4, alpha = 0.025, beta = 0.1,
                     sfu = sfHSD, sfupar = -4, sfl = sfHSD, sflpar = -2)
  d_sel <- gsDesign(k = 3, test.type = 4, alpha = 0.025, beta = 0.1,
                    sfu = sfHSD, sfupar = -4, sfl = sfHSD, sflpar = -2,
                    testLower = c(TRUE, FALSE, FALSE))
  # Incremental upper spending must be identical
  testthat::expect_equal(d_sel$upper$spend, d_base$upper$spend)
})

testthat::test_that("Lower spending is zeroed at inactive analyses", {
  d_sel <- gsDesign(k = 3, test.type = 4, alpha = 0.025, beta = 0.1,
                    sfu = sfHSD, sfupar = -4, sfl = sfHSD, sflpar = -2,
                    testLower = c(TRUE, FALSE, FALSE))
  testthat::expect_true(d_sel$lower$spend[1] > 0)
  testthat::expect_equal(d_sel$lower$spend[2], 0)
  testthat::expect_equal(d_sel$lower$spend[3], 0)
})

testthat::test_that("Active upper bounds differ from baseline when upper skips cause spending redistribution", {
  d_base <- gsDesign(k = 3, test.type = 3, alpha = 0.025, beta = 0.1,
                     sfu = sfHSD, sfupar = -4, sfl = sfHSD, sflpar = -2)
  d_sel <- gsDesign(k = 3, test.type = 3, alpha = 0.025, beta = 0.1,
                    sfu = sfHSD, sfupar = -4, sfl = sfHSD, sflpar = -2,
                    testUpper = c(FALSE, TRUE, TRUE))
  # Upper bounds at active analyses should differ from baseline
  # because the IA1 spending is redistributed to IA2 and final
  testthat::expect_false(isTRUE(all.equal(d_sel$upper$bound[2], d_base$upper$bound[2])))
})

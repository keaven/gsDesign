# -----------------------------------
# Test gsBoundSummary function
#-----------------------------------


testthat::test_that(desc = "Test gsBoundSummary for gsDesign Object", code = {
  x <- gsDesign(nFixSurv = 0, k = 5, test.type = 1, n.fix = 1)

  local_edition(3) # use 3rd edition of testthat for this testcase
  expect_snapshot_output(x = gsBoundSummary(x, Nname = NULL))
})


testthat::test_that(desc = "Test gsBoundSummary for gsDesign Object with Nname set", code = {
  x <- gsDesign(nFixSurv = 0, k = 5, test.type = 1, n.fix = 1)

  local_edition(3) # use 3rd edition of testthat for this testcase
  expect_snapshot_output(x = gsBoundSummary(x, Nname = "samplesize"))
})


testthat::test_that(desc = "Test gsBoundSummary for gsSurv Object", code = {
  xgs <- gsSurv(lambdaC = .2, hr = .5, eta = .1, T = 2, minfup = 1.5)

  local_edition(3) # use 3rd edition of testthat for this testcase
  expect_snapshot_output(x = gsBoundSummary(xgs))
})


testthat::test_that(desc = "Test gsBoundSummary for gsDesign Object, test.type > 1", 
                    code = {
  x <- gsDesign(nFixSurv = 3, k = 5, test.type = 4, n.fix = 1)

  local_edition(3) # use 3rd edition of testthat for this testcase
  expect_snapshot_output(x = gsBoundSummary(x, Nname = NULL))
})


testthat::test_that(desc = "Test gsBoundSummary for gsDesign Object, when nFixSurv is set", 
                    code = {
  x <- gsDesign(nFixSurv = 0.8, k = 5, test.type = 4, n.fix = 1)

  local_edition(3) # use 3rd edition of testthat for this testcase
  expect_snapshot_output(x = gsBoundSummary(x, deltaname = "RR", ratio = .3))
})


testthat::test_that(desc = "Test with Probability Of Success(POS) set to TRUE", 
                    code = {
  x <- gsDesign(nFixSurv = 0, delta = .3, delta1 = .3)

  local_edition(3) # use 3rd edition of testthat for this testcase
  expect_snapshot_output(x = gsBoundSummary(x, Nname = "Information", POS = TRUE))
})


testthat::test_that(desc = 'Test gsBoundSummary with "Spending" in exclude"', 
                    code = {
  n.fix <- nBinomial(p1 = .3, p2 = .15, scale = "RR")
  xrr <- gsDesign(k = 2, n.fix = n.fix, delta1 = log(.15 / .3), endpoint = "Binomial")

  local_edition(3) # use 3rd edition of testthat for this testcase
  expect_snapshot_output(x = gsBoundSummary(xrr, exclude = c("Spending")))
})

testthat::test_that(desc = "Test gsBoundSummary fails appropriately with invalid alpha inputs", code = {
  x <- gsDesign(k = 3, test.type = 1)
  
  # Test with character input
  expect_error(
    gsBoundSummary(x, alpha = "0.025"),
    "alpha must be NULL or a numeric vector"
  )
  
  # Test with matrix input
  expect_error(
    gsBoundSummary(x, alpha = matrix(c(0.025, 0.05), nrow = 1)),
    "alpha must be NULL or a numeric vector"
  )
  
  # Test with list input
  expect_error(
    gsBoundSummary(x, alpha = list(0.025, 0.05)),
    "alpha must be NULL or a numeric vector"
  )
  
  # Test with non-finite values
  expect_error(
    gsBoundSummary(x, alpha = c(0.025, Inf)),
    "alpha values must be finite"
  )
  
  # Test with negative values
  expect_error(
    gsBoundSummary(x, alpha = c(0.025, -0.05)),
    "alpha values must be positive"
  )
  
  # Test with values > 1
  expect_error(
    gsBoundSummary(x, alpha = c(0.025, 1.5)),
    "alpha values must be less than 1"
  )
})

testthat::test_that(desc = "Test gsBoundSummary correctly handles valid alpha vectors", code = {
  # Test for test.type = 1 (one-sided)
  x1 <- gsDesign(k = 3, test.type = 1, alpha = 0.025)
  alpha_vec <- c(0.025, 0.05, 0.1)
  out1 <- gsBoundSummary(x1, alpha = alpha_vec)
  
  # Check that original alpha bounds exist
  expect_true(paste0("Efficacy\n(α=", x1$alpha, ")") %in% names(out1))
  
  # Check that new alpha bounds exist
  for (a in setdiff(alpha_vec, x1$alpha)) {
    expect_true(paste0("Efficacy\n(α=", a, ")") %in% names(out1))
  }
  
  # Verify column order for test.type = 1: Analysis, Bounds, then Efficacy columns
  expect_true(all(grepl("Efficacy", names(out1)[3:ncol(out1)])))
  expect_false("Futility" %in% names(out1))
  
  # Test for test.type = 4 (asymmetric two-sided)
  x4 <- gsDesign(k = 3, test.type = 4, alpha = 0.025)
  alpha_vec <- c(0.025, 0.05, 0.1)
  out4 <- gsBoundSummary(x4, alpha = alpha_vec)
  
  # Check that original alpha bounds exist
  expect_true(paste0("Efficacy (α=", x4$alpha, ")") %in% names(out4))
  
  # Check that new alpha bounds exist
  for (a in setdiff(alpha_vec, x4$alpha)) {
    expect_true(paste0("Efficacy (α=", a, ")") %in% names(out4))
  }
  
  # Verify column order for test.type = 4: Analysis, Bounds, Efficacy columns, then Futility
  expect_true(all(grepl("Efficacy", names(out4)[3:(ncol(out4)-1)])))
  expect_equal(names(out4)[ncol(out4)], "Futility")
  
  # Test for test.type = 2 (symmetric two-sided)
  x2 <- gsDesign(k = 3, test.type = 2, alpha = 0.025)
  alpha_vec <- c(0.025, 0.05, 0.1)
  out2 <- gsBoundSummary(x2, alpha = alpha_vec)
  
  # Check that original alpha bounds exist for both efficacy and futility
  expect_true(paste0("Efficacy\n(α=", x2$alpha, ")") %in% names(out2))
  expect_true(paste0("Futility\n(α=", x2$alpha, ")") %in% names(out2))
  
  # Check that new alpha bounds exist for both efficacy and futility
  for (a in setdiff(alpha_vec, x2$alpha)) {
    expect_true(paste0("Efficacy\n(α=", a, ")") %in% names(out2))
    expect_true(paste0("Futility\n(α=", a, ")") %in% names(out2))
  }
  
  # Verify column order for test.type = 2: Analysis, Bounds, alternating Efficacy/Futility pairs
  efficacy_cols <- grep("Efficacy", names(out2))
  futility_cols <- grep("Futility", names(out2))
  expect_equal(length(efficacy_cols), length(futility_cols))
  for (i in seq_along(efficacy_cols)) {
    expect_equal(futility_cols[i], efficacy_cols[i] + 1)
  }
  
  # Verify no duplicate columns are created when alpha value matches design
  x_dup <- gsDesign(k = 3, test.type = 1, alpha = 0.025)
  out_dup <- gsBoundSummary(x_dup, alpha = c(0.025, 0.025))
  expect_equal(sum(grepl("α=0.025", names(out_dup))), 1)
  
  # Test for test.type = 6 (asymmetric two-sided with non-binding futility)
  x6 <- gsDesign(k = 3, test.type = 6, alpha = 0.025)
  alpha_vec <- c(0.025, 0.05, 0.1)
  out6 <- gsBoundSummary(x6, alpha = alpha_vec)
  
  # Check that original alpha bounds exist
  expect_true(paste0("Efficacy (α=", x6$alpha, ")") %in% names(out6))
  expect_true("Futility" %in% names(out6))  # Futility bound should not have alpha label
  
  # Check that new alpha bounds exist
  for (a in setdiff(alpha_vec, x6$alpha)) {
    expect_true(paste0("Efficacy (α=", a, ")") %in% names(out6))
  }
  
  # Verify Futility column is at the end for test.type = 6
  expect_equal(names(out6)[ncol(out6)], "Futility")
  
  # Verify column order: Analysis, Bounds, Efficacy columns, then Futility
  expect_true(all(grepl("Efficacy", names(out6)[3:(ncol(out6)-1)])))
})

testthat::test_that(desc = "Test CP, CP H1, and PP computations with multiple alpha values", code = {
  # Test for test.type = 1 (one-sided)
  x1 <- gsDesign(k = 3, test.type = 1, alpha = 0.025, beta = 0.1)
  alpha_vec <- c(0.025, 0.05)
  out1 <- gsBoundSummary(x1, alpha = alpha_vec, POS = TRUE)
  
  # Check CP, CP H1, and PP columns exist
  expect_true("CP" %in% names(out1))
  expect_true("CP H1" %in% names(out1))
  expect_true("PP" %in% names(out1))
  
  # Check values are between 0 and 1
  expect_true(all(out1$CP >= 0 & out1$CP <= 1))
  expect_true(all(out1$`CP H1` >= 0 & out1$`CP H1` <= 1))
  expect_true(all(out1$PP >= 0 & out1$PP <= 1))
  
  # Test for test.type = 2 (symmetric two-sided)
  x2 <- gsDesign(k = 3, test.type = 2, alpha = 0.025, beta = 0.1)
  out2 <- gsBoundSummary(x2, alpha = alpha_vec, POS = TRUE)
  
  # Check CP, CP H1, and PP columns exist
  expect_true("CP" %in% names(out2))
  expect_true("CP H1" %in% names(out2))
  expect_true("PP" %in% names(out2))
  
  # Check values are between 0 and 1
  expect_true(all(out2$CP >= 0 & out2$CP <= 1))
  expect_true(all(out2$`CP H1` >= 0 & out2$`CP H1` <= 1))
  expect_true(all(out2$PP >= 0 & out2$PP <= 1))
  
  # Test for test.type = 4 (asymmetric two-sided)
  x4 <- gsDesign(k = 3, test.type = 4, alpha = 0.025, beta = 0.1)
  out4 <- gsBoundSummary(x4, alpha = alpha_vec, POS = TRUE)
  
  # Check CP, CP H1, and PP columns exist
  expect_true("CP" %in% names(out4))
  expect_true("CP H1" %in% names(out4))
  expect_true("PP" %in% names(out4))
  
  # Check values are between 0 and 1
  expect_true(all(out4$CP >= 0 & out4$CP <= 1))
  expect_true(all(out4$`CP H1` >= 0 & out4$`CP H1` <= 1))
  expect_true(all(out4$PP >= 0 & out4$PP <= 1))
  
  # Test for test.type = 6 (asymmetric two-sided with non-binding futility)
  x6 <- gsDesign(k = 3, test.type = 6, alpha = 0.025, beta = 0.1)
  out6 <- gsBoundSummary(x6, alpha = alpha_vec, POS = TRUE)
  
  # Check CP, CP H1, and PP columns exist
  expect_true("CP" %in% names(out6))
  expect_true("CP H1" %in% names(out6))
  expect_true("PP" %in% names(out6))
  
  # Check values are between 0 and 1
  expect_true(all(out6$CP >= 0 & out6$CP <= 1))
  expect_true(all(out6$`CP H1` >= 0 & out6$`CP H1` <= 1))
  expect_true(all(out6$PP >= 0 & out6$PP <= 1))
  
  # Verify CP, CP H1, and PP appear in correct order (at the end, before any Futility column)
  for (out in list(out1, out2, out4, out6)) {
    power_cols <- which(names(out) %in% c("CP", "CP H1", "PP"))
    expect_equal(diff(power_cols), c(1, 1))  # Should be consecutive
    if ("Futility" %in% names(out)) {
      expect_true(max(power_cols) < which(names(out) == "Futility"))
    }
  }
  
  # Test that CP values are consistent with different alpha values
  # Higher alpha should generally lead to higher CP
  x_low <- gsDesign(k = 3, test.type = 1, alpha = 0.025, beta = 0.1)
  x_high <- gsDesign(k = 3, test.type = 1, alpha = 0.05, beta = 0.1)
  out_low <- gsBoundSummary(x_low, POS = TRUE)
  out_high <- gsBoundSummary(x_high, POS = TRUE)
  expect_true(all(out_low$CP <= out_high$CP))
})
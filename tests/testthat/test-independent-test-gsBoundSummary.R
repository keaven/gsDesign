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
    "alpha must be NULL or a numeric vector with values strictly between 0 and 1 - x$beta"
  )
  
  # Test with matrix input
  expect_error(
    gsBoundSummary(x, alpha = matrix(c(0.025, 0.05), nrow = 1)),
    "alpha must be NULL or a numeric vector with values strictly between 0 and 1 - x$beta"
  )
  
  # Test with list input
  expect_error(
    gsBoundSummary(x, alpha = list(0.025, 0.05)),
    "alpha must be NULL or a numeric vector with values strictly between 0 and 1 - x$beta"
  )
  
  # Test with non-finite values
  expect_error(
    gsBoundSummary(x, alpha = c(0.025, Inf)),
    "alpha must be NULL or a numeric vector with values strictly between 0 and 1 - x$beta"
  )
  
  # Test with negative values
  expect_error(
    gsBoundSummary(x, alpha = c(0.025, -0.05)),
    "alpha must be NULL or a numeric vector with values strictly between 0 and 1 - x$beta"
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
  expect_true(paste0("α=", x1$alpha, sep = '') %in% names(out1))
  
  # Check that new alpha bounds exist
  for (a in setdiff(alpha_vec, x1$alpha)) {
    expect_true(paste0("α=", a, sep = '') %in% names(out1))
  }
  
  # Test for test.type = 4 (asymmetric two-sided)
  x4 <- gsDesign(k = 3, test.type = 4, alpha = 0.025)
  alpha_vec <- c(0.025, 0.05, 0.1)
  out4 <- gsBoundSummary(x4, alpha = alpha_vec)
  
  # Check that original alpha bounds exist
  expect_true(paste0("α=", x4$alpha, sep = '') %in% names(out4))
  
  # Check that new alpha bounds exist
  for (a in setdiff(alpha_vec, x4$alpha)) {
    expect_true(paste0("α=", a, sep = '') %in% names(out4))
  }
  
  # Verify column order for test.type = 4: Analysis, Bounds, Efficacy columns, then Futility
  expect_true(all(grepl("α=", names(out4)[3:(ncol(out4)-1)])))
  expect_equal(names(out4)[ncol(out4)], "Futility")
  
  # Test for test.type = 2 (symmetric two-sided)
  x2 <- gsDesign(k = 3, test.type = 2, alpha = 0.025)
  alpha_vec <- c(0.025, 0.05, 0.1)
  out2 <- gsBoundSummary(x2, alpha = alpha_vec)
  
  # Verify no duplicate columns are created when alpha value matches design
  x_dup <- gsDesign(k = 3, test.type = 1, alpha = 0.025)
  out_dup <- gsBoundSummary(x_dup, alpha = c(0.025, 0.025))
  expect_equal(sum(grepl("α=0.025", names(out_dup))), 1)
  
  # Test for test.type = 6 (asymmetric two-sided with non-binding futility)
  x6 <- gsDesign(k = 3, test.type = 6, alpha = 0.025)
  alpha_vec <- c(0.025, 0.05, 0.1)
  out6 <- gsBoundSummary(x6, alpha = alpha_vec)
  
  # Check that original alpha bounds exist
  expect_true(paste0("α=", x6$alpha, sep = '') %in% names(out6))
  expect_true("Futility" %in% names(out6))  # Futility bound should not have alpha label
  
  # Check that new alpha bounds exist
  for (a in setdiff(alpha_vec, x6$alpha)) {
    expect_true(paste0("α=", a, sep = '') %in% names(out6))
  }
  
  # Verify Futility column is at the end for test.type = 6
  expect_equal(names(out6)[ncol(out6)], "Futility")
  
  # Verify column order: Analysis, Bounds, Efficacy columns, then Futility
  expect_true(all(grepl("α=", names(out6)[3:(ncol(out6)-1)])))
})

testthat::test_that(desc = "Test CP, CP H1, and PP computations with multiple alpha values", code = {
  # Test for test.type = 4 (asymmetric, non-binding futility)
  x4 <- gsDesign(k = 3, test.type = 4, alpha = 0.01, beta = 0.1, n.fix = 300)
  alpha_vec <- c(0.025, 0.05)
  prior <- normalGrid(mu = x4$delta / 2, sigma = 10 / sqrt(x4$n.fix))
  out4 <- gsBoundSummary(x4, alpha = alpha_vec, prior = prior, POS = FALSE, exclude = NULL)
  # Test that CP and PP values are consistent with different alpha values
  for (a in seq_along(alpha_vec)) {
    # Get 1-sided upper bound for alpha_vec[a]
    x4_1s <- gsDesign(k = x4$k, delta = x4$theta[2], n.I = x4$n.I, alpha = alpha_vec[a], test.type = 1)
    # Compute design characteristics for alternate alpha with gsProbability
    # Use 1-sided upper bound with original alpha futility bound
    # Input theta does not matter, this is just to get the gsProbability data structure
    x4p <- gsProbability(k = x4$k, theta = 0, n.I = x4$n.I, a = x4$lower$bound, b = x4_1s$upper$bound)
    # Check conditional power with observed treatment effect from gsBoundSummary vs gsBoundCP
    cp <- out4[out4$Value == "CP", 3 + a]
    CP <- round(gsBoundCP(x = x4p, theta = "thetahat"), 4)
    expect_equal(CP[,2], cp, label = "CP at estimated effect size is incorrect")
    # Check conditional power with H1 treatment effect from gsBoundSummary vs gsBoundCP
    cph1 <- out4[out4$Value == "CP H1", 3 + a]
    CPH1 <- round(gsBoundCP(x = x4p, theta = x4$delta), 4)
    expect_equal(CPH1[,2], cph1, label = "CP at H1 effect size is incorrect")
    # Check PP for updated alpha
    pp <- out4[out4$Value == "PP", 3 + a]
    PP <- rep(0, 2)
    for(i in 1:2){
      PP[i] <- gsPP(z = x4p$upper$bound[i], i = i, x = x4p, theta = prior$z, wgts = prior$wgts)
    }
    expect_equal(round(PP, 4), pp, label = "PP is incorrect")
  }
})

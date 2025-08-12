test_that("binomialPowerTable works in analytical mode", {
  # Basic run (simulation = FALSE)
  x <- binomialPowerTable(
    pC = c(0.8, 0.9),
    delta = c(-0.05, 0, 0.05),
    n = 70,
    simulation = FALSE
  )
  
  # Structure checks
  expect_s3_class(x, "data.frame")
  expect_true(all(c("pC", "delta", "pE", "Power") %in% names(x)))
  
  # Probability bounds check
  expect_true(all(x$pE > 0 & x$pE < 1))
  
  # Special case: pE == pC & delta0 == 0 returns alpha
  alpha_val <- 0.025
  subset_equal <- x[x$pE == x$pC, ]
  expect_true(all(abs(subset_equal$Power - alpha_val) < 1e-8))
})

test_that("binomialPowerTable works in simulation mode", {
  set.seed(123) # For reproducibility due to using simulation 
  result_sim <- binomialPowerTable(
    pC = c(0.8, 0.9),
    delta = c(-0.05, 0.05),
    n = 20,             
    simulation = TRUE,
    nsim = 5000       
  )
  
  # checks for output
  expect_s3_class(result_sim, "data.frame")
  expect_true(all(c("pC", "delta", "pE", "Power") %in% names(result_sim)))
  
  # Probability range check
  expect_true(all(result_sim$Power >= 0 & result_sim$Power <= 1))
})

test_that("binomialPowerTable filters out-of-range pE values", {
  # Inlcude some invalid pE values
  x <- binomialPowerTable(
    pC = c(0.99, 0.01),
    delta = c(-0.1, 0.1), # will produce some pE >= 1 or <= 0
    simulation = FALSE
  )
  
  expect_true(all(x$pE > 0 & x$pE < 1))
})

test_that("binomialPowerTable handles failureEndpoint = FALSE", {
  x <- binomialPowerTable(
    pC = c(0.8),
    delta = c(0.05),
    failureEndpoint = FALSE,
    simulation = FALSE
  )
  
  expect_true(all(c("pC", "delta", "pE", "Power") %in% names(x)))
  expect_true(x$Power[1] >= 0 && x$Power[1] <= 1)
})
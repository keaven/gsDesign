context("Support functions")

# Accrual times
samplesize <- 20
acc_period <- 3 
t_recruit <- get_recruittimes(accrual_period = acc_period, n = samplesize, accrual_exponent = 1.2)
  
test_that("Number of recruitment times corresponds target sample size", 
          {expect_equal(length(t_recruit), samplesize)})

test_that("Recruitment starts at 0", 
          {expect_equal(t_recruit[1], 0)})

test_that("Last subject recruited at end of accrual period", 
          {expect_equal(t_recruit[samplesize], acc_period)})

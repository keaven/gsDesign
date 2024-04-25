testthat::context("toInteger function")

# check input data types #


testthat::test_that("test_input_data_types", {
  
  x = gsDesign::gsSurv(
    k = 3,                 # 3 analyses
    test.type = 4,         # Non-binding futility bound 1 (no futility bound) and 4 are allowable
    alpha = .025,          # 1-sided Type I error
    beta = .1,             # Type II error (1 - power)
    timing = c(0.45, 0.7), # Proportion of final planned events at interims
    sfu = gsDesign::sfHSD, # Efficacy spending function
    sfupar = -4,           # Parameter for efficacy spending function
    sfl = gsDesign::sfLDOF,# Futility spending function; not needed for test.type = 1
    sflpar = 0,            # Parameter for futility spending function
    lambdaC = .001,        # Exponential failure rate
    hr = 0.3,              # Assumed proportional hazard ratio (1 - vaccine efficacy = 1 - VE)
    hr0 = 0.7,             # Null hypothesis VE
    eta = 5e-04,           # Exponential dropout rate
    gamma = 10,            # Piecewise exponential enrollment rates
    R = 16,                # Time period durations for enrollment rates in gamma
    T = 24,                # Planned trial duration
    minfup = 8,            # Planned minimum follow-up
    ratio = 3              # Randomization ratio (experimental:control)
  )
  
  ## check x ##
  testthat::expect_error(gsDesign::toInteger(x = "abc", ratio = 0, roundUpFinal = T),
                         info = "Checking for incorrect variable type for the argument `x`") 
  
  testthat::expect_error(gsDesign::toInteger(x = 4, ratio = 0, roundUpFinal = T),
                         info = "Checking for incorrect variable type for the argument `x`") 
  
  ## check ratio ##
  testthat::expect_error(gsDesign::toInteger(x = x, ratio = "ab", roundUpFinal = T),
                         info = "Checking for incorrect variable type for the argument `ratio`") 
  
  testthat::expect_error(gsDesign::toInteger(x = x, ratio = -2, roundUpFinal = T),
                         info = "Checking for incorrect variable type for the argument `ratio`") 
  
  testthat::expect_error(gsDesign::toInteger(x = x, ratio = 1.5, roundUpFinal = T),
                         info = "Checking for incorrect variable type for the argument `ratio`") 
  
  ## check roundUpFinal ##
  testthat::expect_error(gsDesign::toInteger(x = x, ratio = 1, roundUpFinal = "a"),
                         info = "Checking for incorrect variable type for the argument `roundUpFinal`") 
  
  testthat::expect_error(gsDesign::toInteger(x = x, ratio = -2, roundUpFinal = 2),
                         info = "Checking for incorrect variable type for the argument `roundUpFinal`") 
  
  
}
)

# output check #

testthat::test_that("test_input_data_types", {
  
 
  
}
)

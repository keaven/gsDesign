# Developer testing for toBinomialExact()

# Run code in help example to get a gsSurv object with rare events
 x <- gsSurv(
   k = 3,                 # 3 analyses
   test.type = 4,         # Non-binding futility bound 1 (no futility bound) and 4 are allowable
   alpha = .025,          # 1-sided Type I error
   beta = .1,             # Type II error (1 - power)
   timing = c(0.45, 0.7), # Proportion of final planned events at interims
   sfu = sfHSD,           # Efficacy spending function
   sfupar = -4,           # Parameter for efficacy spending function
   sfl = sfLDOF,          # Futility spending function; not needed for test.type = 1
   sflpar = 0,            # Parameter for futility spending function
   lambdaC = .001,        # Exponential failure rate to ensure low probability of event per observation
   hr = 0.3,              # Assumed proportional hazard ratio (1 - vaccine efficacy = 1 - VE)
   hr0 = 0.7,             # Null hypothesis VE
   eta = 5e-04,           # Exponential dropout rate
   gamma = 10,            # Piecewise exponential enrollment rates
   R = 16,                # Time period durations for enrollment rates in gamma
   T = 24,                # Planned trial duration
   minfup = 8,            # Planned minimum follow-up
   ratio = 3              # Randomization ratio (experimental:control)
 )
 
# Convert to exact binomial

# Round up final event count (default)
xx <- toBinomialExact(x)
# Do the same in 2 steps
yy <- toInteger(x) %>% toBinomialExact()
# Check xx and yy are the same
testthat::test_that("test.toBinomialExact.toInteger",{
  expect_equal(xx, yy, info = "Checking toBinomialExact works whether or not toInteger is called before toBinomialExact")
})


# Now change rounding for yy and check it
yy <- toInteger(x, roundUpFinal = FALSE) %>% toBinomialExact()

# Check events at analyses
events <- round(x$n.I)

testthat::test_that("test.toBinomialExact.Integer", {
  expect_equal(yy$n.I, events)
  events[x$k] <- ceiling(x$n.I[x$k])
  expect_equal(xx$n.I, events)
})

# Check alpha spending is controlled 
testthat::test_that("test.toBinomialExact.alpha",{
  target_spend <- x$upper$sf(alpha = x$alpha, t = xx$n.I /xx$n.I[x$k], param = x$upper$param)$spend
  # Non-binding spend must be computed without an upper bound
  actual_spend <- cumsum(gsBinomialExact(k = x$k, theta = xx$theta[1], a = xx$lower$bound, 
                                         b = xx$n.I + 1, n.I = xx$n.I)$lower$prob)
  expect_lte(max(actual_spend - target_spend), 0)
})

# Check that increasing bound would not control alpha
testthat::test_that("test.toBinomialExact.alpha.spend",{
  for(i in 1:x$k){
    a_alt <- xx$lower$bound
    a_alt[i] <- a_alt[i] + 1
    actual_spend <- cumsum(gsBinomialExact(k = x$k, theta = xx$theta[1], a = a_alt, 
                                           b = xx$n.I + 1, n.I = xx$n.I)$lower$prob)
    expect_gt(actual_spend[i], target_spend[i])
  }
})

target_beta_spend <- x$lower$sf(alpha = x$beta, t = xx$n.I /xx$n.I[x$k], param = x$lower$param)$spend
# Check beta spending is controlled
testthat::test_that("test.toBinomialExact.beta",{
  # Non-binding spend must be computed without an upper bound
  actual_spend <- cumsum(gsBinomialExact(k = x$k, theta = xx$theta[2], a = xx$lower$bound, 
                                         b = xx$upper$bound, n.I = xx$n.I)$upper$prob)
  expect_lte(max(actual_spend - target_beta_spend), 0)
})

# Check that decreasing bound would not control beta
testthat::test_that("test.toBinomialExact.alpha.spend",{
  for(i in 1:(x$k - 1)){
    b_alt <- xx$upper$bound
    b_alt[i] <- b_alt[i] - 1
    actual_spend <- cumsum(gsBinomialExact(k = x$k, theta = xx$theta[2], a = xx$lower$bound, 
                                           b = b_alt, n.I = xx$n.I)$upper$prob)
    expect_gt(actual_spend[i], target_beta_spend[i])
  }
})

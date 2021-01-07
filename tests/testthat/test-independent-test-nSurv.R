

testthat::test_that("Testing nSurv vs nSurvival and nEvents", {
  # consider a trial with 2 year maximum follow-up,
  # 6 month uniform enrollment
  # Treatment/placebo hazards = 0.14/0.2 per 1 person-year
  # HR = 0.7
  # drop out hazard 0.1 per 1 person-year
  # alpha = 0.025 (1-sided)
  # power = 0.9 (default beta=.1)
  ss <- nSurvival(
    lambda1 = .2, lambda2 = .14, eta = .1, Ts = 2, Tr = .5,
    sided = 1, alpha = .025
  )
  ns <- nSurv(lambdaC = .2, hr = .7, eta = .1, T=2, minfup=1.5)
  nsg <- nSurv(lambdaC = .2, hr = .7, eta = .1, R = 0.5, gamma = ns$gamma)
  ne <- nEvents(hr=.7)
  testthat::expect_equal(ss$n, ns$n, info = "Checking sample size")
  testthat::expect_equal(round(ns$n,3), round(nsg$n,3), info = "Checking sample size")
  testthat::expect_equal(ss$nEvents, ns$d, info = "Checking event count")
  testthat::expect_lt(abs(ns$d - ne),3)
})

testthat::test_that("Checking consistency of Schoenfeld approximations", {
  z <- hrn2z(hr = .7, n = 100, ratio = 1.5)
  hr <- zn2hr(z = -z, n = 100, ratio = 1.5)
  n <- hrz2n(z = -z, hr = .7, ratio = 1.5)
  testthat::expect_equal(hr, .7, info = "Checking zn2hr vs hrn2z")
  testthat::expect_equal(n, 100, info = "Checking hrz2n vs hrn2z")
})

testthat::test_that("Checking consistency nEvents power vs sample size", {
  ss <- nEvents(hr = .7, tbl = TRUE)
  ne <- nEvents(hr = .7)
  pwr <- nEvents(hr = .7, n = ne, tbl = TRUE)
  testthat::expect_equal(ss$n, ceiling(ne), info = "Checking tabular output")
  testthat::expect_equal(pwr$Power, .9, info = "Checking power calculation")
})

################################################################################
## ADDITIONAL TEST SCENARIOs

## We use nSurvival() from the gsDesign package to validate the nSurv().
## This is done keeping in mind that nSurvival has been programmed
## independently and can be used for limited validations of nSurv()
testthat::test_that(
  desc = "Test nSurv() using nSurvival() from the gsDesign package : ",
  code = {
    ss2 <- nSurv(
      lambdaC = log(2) / 6, hr = .5, eta = log(2) / 40,
      T = 36, minfup = 12
    )
    
    ss1 <- nSurvival(
      lambda1 = log(2) / 6, lambda2 = log(2) / 12, eta = log(2) / 40,
      Ts = 36, Tr = 24
    )
    
    ## Compare ss2$n with ss1$n with tolerance of 1e-6
    testthat::expect_lte(
      object = abs(ss2$n - ss1$n),
      expected = 1e-6
    )
    
    ## Compare ss2$d with ss1$nEvents with tolerance of 1e-6
    testthat::expect_lte(
      object = abs(ss2$d - ss1$nEvents),
      expected = 1e-6
    )
  }
)



# vary accrual rate to obtain expected events and sample size
# The benchmark values have been obtained by creating an
# equivalent design in SAS 9.4 - Proc Seqdesign : SAS_nsurv_01.html
test_that(
  desc = "check expected # of events and expected sample size",
  code = {
    x <- nSurv(
      lambdaC = log(2) / 20, hr = .5, gamma = 1,
      T = 36, minfup = 12
    )
    # check expected # of events
    expect_lte(abs(x$d - 87.4793), 2)
    
    # check expected sample size
    expect_lte(abs(x$n - 197.1152), 2)
  }
)

# vary accrual duration to obtain expected events and sample size
# The benchmark values have been obtained by creating an
# equivalent design in SAS 9.4 - Proc Seqdesign : SAS_nsurv_01.html
test_that(
  desc = "check expected # of events and expected sample size",
  code = {
    x <- nSurv(
      lambdaC = log(2) / 20, hr = .5, gamma = 6,
      minfup = 12
    )
    # check expected # of events
    expect_lte(abs(x$d - 87.4793), 2)
    
    # check expected sample size
    expect_lte(abs(x$n - 182.1759), 2)
  }
)

# vary follow-up duration to obtain expected events and sample size
# The benchmark values have been obtained by creating an
# equivalent design in SAS 9.4- Proc Seqdesign : SAS_nsurv_01.html
test_that(
  desc = "check expected # of events and expected sample size",
  code = {
    x <- nSurv(
      lambdaC = log(2) / 20, hr = .5, gamma = 6,
      R = 25
    )
    # check expected # of events
    expect_lte(abs(x$d - 89.07848), 2)
    
    # check expected sample size
    expect_lte(abs(x$n - 149.861), 2)
  }
)

# vary follow-up duration to obtain power
# the benchmark values have been obtained by creating an
# equivalent design in East 6.5. The sample size used to
# create the design in East is taken from the output of
# nSurv() : TestnSurv_EastData_Des1.html
test_that(
  desc = "check computed events and power",
  code = {
    x <- nSurv(
      lambdaC = log(2) / 10, hr = .5, gamma = 4, T = 50,
      minfup = 30, beta = NULL
    )
    
    ## compare the expected # of events
    expect_lte(abs(x$d - 39.02121789), 2)
    
    ## compare the power x$power
    ## tolerance is high as the power computation depends 
    ## upon # of events which have differences between different gsDesign and East 6.5.
    expect_lte(abs(x$power - 0.58120457), 0.02)
  }
)

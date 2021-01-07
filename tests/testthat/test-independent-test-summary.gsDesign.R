# Testing summary.gsDesign function for different functions and test.types.
# local_edition(3) # use 3rd edition of testthat for this testcase


testthat::test_that(desc = "Test - gsSurv", code = {
  xgs <- gsSurv(lambdaC = .2, hr = .4, eta = .2, T = 2, minfup = 1.5)
  local_edition(3) # use 3rd edition of testthat for this testcase
  expect_snapshot_output(x = summary.gsDesign(xgs))
})


testthat::test_that(desc = "Test - gsSurv change in snapshot", {
  xgs <- gsSurv(lambdaC = .2, hr = .56, eta = .1, T = 2, minfup = 1.5)
  local_edition(3) # use 3rd edition of testthat for this testcase
  expect_snapshot_output(x = summary.gsDesign(xgs))
})


testthat::test_that(
  desc = "Test - gsSurv - test.type = 1",
  code = {
    xgs <- gsSurv(lambdaC = .2, test.type = 1, hr = .4, eta = .2, T = 2, minfup = 1.5)
    local_edition(3) # use 3rd edition of testthat for this testcase
    expect_snapshot_output(x = summary.gsDesign(xgs))
  }
)


testthat::test_that(
  desc = "Test - gsSurv - test.type = 2",
  code = {
    xgs <- gsSurv(lambdaC = .2, test.type = 2, hr = .4, eta = .2, T = 2, minfup = 1.5)
    local_edition(3) # use 3rd edition of testthat for this testcase
    expect_snapshot_output(x = summary.gsDesign(xgs))
  }
)


testthat::test_that(
  desc = "Test - gsSurv - test.type = 3",
  code = {
    xgs <- gsSurv(lambdaC = .2, test.type = 3, hr = .4, eta = .2, T = 2, minfup = 1.5)
    local_edition(3) # use 3rd edition of testthat for this testcase
    expect_snapshot_output(x = summary.gsDesign(xgs))
  }
)


testthat::test_that(
  desc = "Test for gsSurv - hr0 < 1",
  code = {
    xgs <- gsSurv(lambdaC = .2, hr0 = .4, eta = .2, T = 2, minfup = 1.5)
    local_edition(3) # use 3rd edition of testthat for this testcase
    expect_snapshot_output(x = summary.gsDesign(xgs))
  }
)

#checking non numeric value in minfup
testthat::test_that(desc = "Test gsDesign summary for gsSurv - error", code = {
  local_edition(3) # use 3rd edition of testthat for this testcase
  expect_error(summary.gsDesign(gsSurv(
    lambdaC = .2, hr = .4, eta = .2,
    T = 2, minfup = "a"
  )))
})


# checking error for lambdaC = NULL.
testthat::test_that(
  desc = "Test gsDesign summary for gsSurv - error - nlambda ",
  code = {
    local_edition(3) # use 3rd edition of testthat for this testcase
    expect_error(summary.gsDesign(gsSurv(
      lambdaC = NULL, hr = .4, eta = .2,
      T = 2, minfup = 1.5
    )))
  }
)



testthat::test_that(desc = "Test:  nSurvival object", code = {
  ss <- nSurvival(
    lambda1 = .2, lambda2 = .1, eta = .1, Ts = 2, Tr = .5,
    sided = 1, alpha = .025, ratio = 2
  )
  xs <- gsDesign(
    nFixSurv = ss$n, n.fix = ss$nEvents,
    delta1 = log(ss$lambda2 / ss$lambda1)
  )
  local_edition(3) # use 3rd edition of testthat for this testcase
  expect_snapshot_output(x = summary.gsDesign(xs))
})



testthat::test_that(desc = "Test gsDesign summary for nSurvival", code = {
  ss <- nSurvival(
    lambda1 = .2, lambda2 = .1, eta = .1, Ts = 2, Tr = .5,
    sided = 1, alpha = 0.05, ratio = 2
  )
  xs <- gsDesign(
    nFixSurv = ss$n, n.fix = ss$nEvents,
    delta1 = log(ss$lambda2 / ss$lambda1)
  )
  local_edition(3) # use 3rd edition of testthat for this testcase
  expect_snapshot_output(x = summary.gsDesign(xs))
})



testthat::test_that(desc = "Test:  nBinomial object", code = {
  np <- nBinomial(p1 = .15, p2 = .10)
  xp <- gsDesign(n.fix = np, endpoint = "Binomial", delta1 = .05)
  local_edition(3) # use 3rd edition of testthat for this testcase
  expect_snapshot_output(x = summary.gsDesign(xp))
})


testthat::test_that(
  desc = "Test gsDesign summary -test.type = 2",
  code = {
    xgs <- gsDesign(k = 4, test.type = 2, sfu = "Pocock")
    local_edition(3) # use 3rd edition of testthat for this testcase
    expect_snapshot_output(x = summary.gsDesign(xgs))
  }
)
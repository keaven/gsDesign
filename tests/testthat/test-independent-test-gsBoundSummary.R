
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
# -----------------------------------
# Test print.gsDesign function
#-----------------------------------


testthat::test_that(desc = "Test: checking for test.type=1, n.fix=1 ", code = {
  x <- gsDesign(k = 5, test.type = 1, n.fix = 1)
  local_edition(3) # use 3rd edition of testthat for this testcase
  expect_snapshot_output(x = print.gsDesign(x))
})


testthat::test_that(desc = "Test: checking for nFixSurv >1 ", code = {
  x <- gsDesign(nFixSurv = 20, k = 5, test.type = 2, n.fix = 1)
  local_edition(3) # use 3rd edition of testthat for this testcase
  expect_snapshot_output(x = print.gsDesign(x))
})


testthat::test_that(desc = "Test: checking for test.type=2,n.fix=1 ", code = {
  x <- gsDesign(k = 5, test.type = 2, n.fix = 1)
  local_edition(3) # use 3rd edition of testthat for this testcase
  expect_snapshot_output(x = print.gsDesign(x))
})


testthat::test_that(desc = "Test: checking for test.type=3,n.fix=1 ", code = {
  x <- gsDesign(k = 5, test.type = 3, n.fix = 1)
  local_edition(3) # use 3rd edition of testthat for this testcase
  expect_snapshot_output(x = print.gsDesign(x))
})


testthat::test_that(desc = "Test: checking for test.type=4,n.fix=1 ", code = {
  x <- gsDesign(k = 5, test.type = 4, n.fix = 800)
  local_edition(3) # use 3rd edition of testthat for this testcase
  expect_snapshot_output(x = print.gsDesign(x))
})


testthat::test_that(desc = "Test: checking for test.type=5,n.fix=1 ", code = {
  x <- gsDesign(k = 5, test.type = 5, n.fix = 1)
  local_edition(3) # use 3rd edition of testthat for this testcase
  expect_snapshot_output(x = print.gsDesign(x))
})


testthat::test_that(desc = "Test: checking for test.type=6,n.fix=1", code = {
  x <- gsDesign(k = 5, test.type = 6, n.fix = 1)
  local_edition(3) # use 3rd edition of testthat for this testcase
  expect_snapshot_output(x = print.gsDesign(x))
})


testthat::test_that(desc = "Test: checking for n.fix > 1", code = {
  x <- gsDesign(k = 5, test.type = 1, n.fix = 12)
  local_edition(3) # use 3rd edition of testthat for this testcase
  expect_snapshot_output(x = print.gsDesign(x))
})


testthat::test_that(desc = "Test: checking with alpha, beta, n.I set", code = {
  x <- gsDesign(alpha = 0.05, beta = .015, k = 3, n.I = c(300, 600, 860), test.type = 2)
  local_edition(3) # use 3rd edition of testthat for this testcase
  expect_snapshot_output(x = print.gsDesign(x))
})

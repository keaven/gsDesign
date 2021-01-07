# -----------------------------------
# Test print.gsBoundSummary function
#-----------------------------------

### Test print.gsBoundSummary function
testthat::test_that(desc = "Test print.gsBoundSummary", code = {
  x <- gsDesign(nFixSurv = -1, k = 5, test.type = 4, n.fix = 1)
  gsb <- gsBoundSummary(x, deltaname = "RR", ratio = .3)

  local_edition(3) # use 3rd edition of testthat for this testcase
  expect_snapshot_output(x = print.gsBoundSummary(gsb, row.names = FALSE, digits = 4))
})
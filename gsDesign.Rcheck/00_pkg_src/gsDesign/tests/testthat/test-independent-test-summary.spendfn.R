
# -----------------------------------
# Test summary.spendfn function
#-----------------------------------


testthat::test_that(desc = "Test: invalid object ", code = {
  x <- 5
  testthat::expect_error(summary.spendfn(x),
    info = "Tests summary.spendfn(x) - invalid-object"
  )
})


testthat::test_that(desc = "Test: upper bound is - O'Brien-Fleming", code = {
  res <- gsDesign(k = 5, test.type = 2, n.fix = 800, sfu = "OF")
  local_edition(3)
  expect_snapshot_output(x = summary.spendfn(res$upper))
})


testthat::test_that(desc = "Test: upper bound is - Pocock", code = {
  res <- gsDesign(k = 5, test.type = 2, n.fix = 800, sfu = "Pocock")
  local_edition(3)
  expect_snapshot_output(x = summary.spendfn(res$upper))
})


testthat::test_that(desc = "Test: upper bound is - WT", code = {
  res <- gsDesign(k = 5, test.type = 2, sfupar = .25, sfu = "WT")
  local_edition(3)
  expect_snapshot_output(x = summary.spendfn(res$upper))
})



testthat::test_that(desc = "Test: Truncated object ", code = {
  tx <- (0:100) / 100
  param <- list(trange = c(.2, .8), sf = gsDesign::sfHSD, param = 1)
  sf <- sfTruncated(alpha = .025, t = c(.1, .4), param)
  local_edition(3) # use 3rd edition of testthat for this testcase
  expect_snapshot_output(x = summary.spendfn(sf))
})


testthat::test_that(desc = "Test: Trimmed object", code = {
  tx <- (0:100) / 100
  param <- list(trange = c(.2, .8), sf = gsDesign::sfHSD, param = 1)
  sf <- sfTrimmed(alpha = .025, t = c(.1, .4), param)
  local_edition(3) # use 3rd edition of testthat for this testcase
  expect_snapshot_output(x = summary.spendfn(sf))
})


testthat::test_that(desc = "Test: for Gapped object", code = {
  tx <- (0:100) / 100
  param <- list(trange = c(.2, .8), sf = gsDesign::sfHSD, param = 1)
  sf <- sfGapped(alpha = .025, t = c(.1, .4), param)
  local_edition(3) # use 3rd edition of testthat for this testcase
  expect_snapshot_output(x = summary.spendfn(sf))
})
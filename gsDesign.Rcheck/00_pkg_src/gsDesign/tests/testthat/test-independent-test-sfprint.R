# Testing sfprint for different spending functions like 'Pocock', 'Wang-Tsiatis'
# and truncated etc.
# local_edition(3)  #use the 3rd edition of the testthat package



# checking for O'Brien-Fleming spending functions.
testthat::test_that("Test - name - O'Brien-Fleming",
  code = {
    res <- gsDesign(k = 4, test.type = 2, sfu = "OF")$upper
    local_edition(3) # use the 3rd edition of the testthat package
    expect_snapshot_output(x = sfprint(res))
})


# checking for Pocock spending functions.
testthat::test_that("Test - name - 'Pocock'", code = {
  res <- gsDesign(k = 4, test.type = 2, sfu = "Pocock")$upper
  local_edition(3)
  expect_snapshot_output(x = sfprint(res))
})


# checking for Wang-Tsiatis spending functions.
testthat::test_that("Test - name - Wang-Tsiatis", code = {
  res <- gsDesign(test.type = 1, sfu = "WT", sfupar = .25)$upper
  local_edition(3)
  expect_snapshot_output(x = sfprint(res))
})


# checking for Truncated spending functions.
testthat::test_that("Test - Truncated", code = {
  tx <- (0:100) / 100
  param <- list(trange = c(.2, .8), sf = gsDesign::sfHSD, param = 1)
  sf <- sfTruncated(alpha = .025, t = c(.1, .4), param)
  local_edition(3)
  expect_snapshot_output(x = sfprint(sf))
})


# checking for Trimmed spending functions.
testthat::test_that("Test - Trimmed", code = {
  tx <- (0:100) / 100
  param <- list(trange = c(.2, .8), sf = gsDesign::sfHSD, param = 1)
  sf <- sfTrimmed(alpha = .025, t = c(.1, .4), param)
  local_edition(3)
  expect_snapshot_output(x = sfprint(sf))
})


# this is an error check spending functions.
testthat::test_that("Test - spending function", code = {
  tx <- (0:100) / 100
  param <- list(trange = c(.2, .8), sf = gsDesign::sfHSD, param = 1)
  sf <- spendingFunction(alpha = .025, t = c(.1, .4), param)
  local_edition(3)
  expect_snapshot_error(x = sfprint(sf))
})

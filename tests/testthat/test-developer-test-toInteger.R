# Test toInteger
test_that("Test: toInteger with invalid input", {
  M <- "a"

  expect_error(
    toInteger(x = M),
    info = "Test toInteger with invalid input"
  )
})

test_that("Test: toInteger for fractional and negative values", {
  x <- gsDesign(n.fix = 100)
  M <- 55.9

  expect_message(
    toInteger(x, ratio = M),
    info = "Test toInteger for floating values"
  )
  M <- -1
  expect_message(
    toInteger(x, ratio = M),
    info = "Test toInteger for negative value of ratio"
  )
  # Note that x$ratio = NULL
  expect_message(
    toInteger(x),
    info = "Test toInteger for NULL value of ratio"
  )
})

test_that("Test: toInteger for even sample size", {
  x <- gsDesign(n.fix = 100)

  expect_true(
    max(toInteger(x, ratio = 1)$n.I) %% 2 == 0,
    info = "Test toInteger for floating value with decimal value 0"
  )
})

test_that("Test: toInteger for multiple of 5", {
  x <- gsDesign(n.fix = 100)

  expect_true(
    max(toInteger(x, ratio = 4)$n.I) %% 5 == 0,
    info = "Test toInteger for floating value with decimal value 0"
  )
})

# Now test survival endpoint
test_that("Test: toInteger for survival endpoint event count works properly", {
  # This gives 252.1852 as sample size, 227.1393 as final event count
  x <- gsSurvCalendar(hr = 0.64)
  # Should round event counts (up for final) and
  # round up final event count final sample size only as well
  y <- toInteger(x)

  # Interim event counts rounded
  expect_equal(min(abs(round(x$n.I[1:x$k - 1]) - y$n.I[1:x$k - 1])), 0)
  # Final event count round up
  expect_true(
    (y$n.I - x$n.I)[x$k] >= 0,
    info = "Test toInteger of gsSurv rounds up final event count"
  )
  # Final sample size rounds to even
  expect_true((y$eNC + y$eNE)[x$k] %% 2 == 0)
  # Final event count rounds up
  expect_gte((y$eNC + y$eNE - x$eNC - x$eNE)[x$k], 0)
})

test_that("binomialPowerTable computes analytic power grid", {
  tbl <- binomialPowerTable(
    pC = 0.2,
    delta = 0,
    n = 10,
    alpha = 0.05,
    failureEndpoint = TRUE,
    simulation = FALSE
  )
  expect_equal(nrow(tbl), 1)
  expect_equal(tbl$Power, 0.05)

  tbl <- binomialPowerTable(
    pC = 0.2,
    delta = 0.05,
    n = 12,
    ratio = 2,
    alpha = 0.05,
    failureEndpoint = FALSE,
    simulation = FALSE
  )
  expect_true(all(tbl$Power > 0 & tbl$Power < 1))
})

test_that("binomialPowerTable simulation branch runs", {
  set.seed(123)
  tbl <- binomialPowerTable(
    pC = c(0.2, 0.3),
    delta = c(-0.02, 0.02),
    n = 12,
    alpha = 0.05,
    simulation = TRUE,
    nsim = 200
  )
  expect_true(all(tbl$Power >= 0 & tbl$Power <= 1))
  expect_equal(nrow(tbl), 4)

  set.seed(456)
  tbl <- binomialPowerTable(
    pC = 0.25,
    delta = 0.05,
    n = 12,
    ratio = 2,
    alpha = 0.05,
    failureEndpoint = FALSE,
    simulation = TRUE,
    nsim = 200
  )
  expect_true(all(tbl$Power >= 0 & tbl$Power <= 1))
  expect_equal(nrow(tbl), 1)
})

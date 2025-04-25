# -----------------------------------
# Test print.nSurvival function
#-----------------------------------

testthat::test_that(desc = "Test: checking invalid-object", code = {
  gs <- gsDesign(k = 5, test.type = 1, n.fix = 1)
  testthat::expect_error(print.nSurvival(gs),
    info = "Tests print.nSurvival - invalid-object"
  )
})


testthat::test_that(desc = 'Test: checking entry set to "unif"', code = {
  ss <- nSurvival(
    lambda1 = .2, lambda2 = .1, eta = .1, Ts = 2, Tr = .5,
    sided = 1, alpha = .025, entry = "unif"
  )
  local_edition(3) # use 3rd edition of testthat for this testcase
  expect_snapshot_output(x = print.nSurvival(ss))
})


testthat::test_that(desc = 'Test: checking entry set to "expo"', code = {
  ss <- nSurvival(
    lambda1 = .2, lambda2 = .1, eta = .1, Ts = 2, Tr = .5,
    sided = 1, alpha = .025, entry = "expo", gamma = 1
  )
  local_edition(3) # use 3rd edition of testthat for this testcase
  expect_snapshot_output(x = print.nSurvival(ss))
})


testthat::test_that(desc = 'Test: checking entry - "expo", eta = 0 and ratio set', 
                    code = {
  ss <- nSurvival(
    lambda1 = .2, lambda2 = .1, eta = 0, Ts = 2, Tr = .5,
    sided = 1, alpha = .025, entry = "expo", gamma = 1, ratio = 1.25,
  )
  local_edition(3) # use 3rd edition of testthat for this testcase
  expect_snapshot_output(x = print.nSurvival(ss))
})


testthat::test_that(desc = 'Test: checking entry set to "expo",eta = 0,ratio != 1', 
                    code = {
  ss <- nSurvival(
    lambda1 = .2, lambda2 = .1, eta = 0, Ts = 2, Tr = .5,
    sided = 1, alpha = .025, entry = "expo", gamma = 1, ratio = 0.8,
  )
  local_edition(3) # use 3rd edition of testthat for this testcase
  expect_snapshot_output(x = print.nSurvival(ss))
})


testthat::test_that(desc = "Test: checking type of sample size calculation: risk ratio (type = rr) with approximate computation", 
                    code = {
  ss <- nSurvival(
    lambda1 = .2, lambda2 = .1, eta = 6.9, Ts = 2, Tr = .5,
    sided = 1, alpha = .025, entry = "unif", type = "rr", approx = TRUE
  )
  local_edition(3) # use 3rd edition of testthat for this testcase
  expect_snapshot_output(x = print.nSurvival(ss))
})


testthat::test_that(desc = "Test: checking type of sample size calculation: risk difference (type = rd) with approximate computation",
                    code = {
  ss <- nSurvival(
    lambda1 = .2, lambda2 = .1, eta = 0, Ts = 2, Tr = .5,
    sided = 1, alpha = .025, entry = "unif", type = "rd", approx = TRUE
  )
  local_edition(3) # use 3rd edition of testthat for this testcase
  expect_snapshot_output(x = print.nSurvival(ss))
})


testthat::test_that(desc = "Test: checking type of sample size calculation: risk difference (type = rd) with approx set to FALSE", 
                    code = {
  ss <- nSurvival(
    lambda1 = .2, lambda2 = .1, eta = 0, Ts = 2, Tr = .5,
    sided = 1, alpha = .025, entry = "unif", type = "rd", approx = FALSE
  )
  local_edition(3) # use 3rd edition of testthat for this testcase
  expect_snapshot_output(x = print.nSurvival(ss))
})
testthat::context("gs stress")
### Utility functions for gsDesign stress tests

"alpha.beta.range.util" <- function(alpha, beta, type, sf) {
  no.err <- TRUE
  
  for (a in alpha)
  {
    for (b in beta)
    {
      # sfLDPocock, test.type=3: errors with alpha >= .5 and beta close to 1 - alpha
      if (b < 1 - a - 0.1) {
        # cat("a = ", a, "b = ", b, "\n")
        res <- try(gsDesign(test.type = type, alpha = a, beta = b, sfu = sf))
        
        if (inherits(res, "try-error")) {
          no.err <- FALSE
        }
      }
    }
  }
  
  no.err
}

"param.range.util" <- function(param, type, sf) {
  no.err <- TRUE
  
  for (p in param)
  {
    res <- try(gsDesign(test.type = type, sfu = sf, sfupar = p))
    
    if (inherits(res, "try-error")) {
      no.err <- FALSE
    }
  }
  
  no.err
}

a1 <- round(seq(from = 0.05, to = 0.95, by = 0.05), 2)
a2 <- round(seq(from = 0.05, to = 0.45, by = 0.05), 2)
b <- round(seq(from = 0.05, to = 0.95, by = 0.05), 2)

# nu: sfExponential parameter
nu <- round(seq(from = 0.1, to = 1.5, by = 0.1), 1)

# rho: sfPower parameter
rho <- round(seq(from = 1, to = 15, by = 1), 0)

# gamma: sfHSD parameter
gamma <- round(seq(from = -5, to = 5, by = 1), 0)


testthat::test_that("test.stress.sfExp.type1", {
  no.errors <- param.range.util(param = nu, type = 1, sf = sfExponential)
  testthat::expect_true(no.errors, info = "Type 1 sfExponential stress test")
})

testthat::test_that("test.stress.sfExp.type2", {
  no.errors <- param.range.util(param = nu, type = 2, sf = sfExponential)
  testthat::expect_true(no.errors, info = "Type 2 sfExponential stress test")
})

testthat::test_that("test.stress.sfExp.type3", {
  no.errors <- param.range.util(param = nu, type = 3, sf = sfExponential)
  testthat::expect_true(no.errors, info = "Type 3 sfExponential stress test")
})

testthat::test_that("test.stress.sfExp.type4", {
  no.errors <- param.range.util(param = nu, type = 4, sf = sfExponential)
  testthat::expect_true(no.errors, info = "Type 4 sfExponential stress test")
})

testthat::test_that("test.stress.sfExp.type5", {
  no.errors <- param.range.util(param = nu, type = 5, sf = sfExponential)
  testthat::expect_true(no.errors, info = "Type 5 sfExponential stress test")
})

testthat::test_that("test.stress.sfExp.type6", {
  no.errors <- param.range.util(param = nu, type = 6, sf = sfExponential)
  testthat::expect_true(no.errors, info = "Type 6 sfExponential stress test")
})

testthat::test_that("test.stress.sfHSD.type1", {
  no.errors <- param.range.util(param = gamma, type = 1, sf = sfHSD)
  testthat::expect_true(no.errors, info = "Type 1 sfHSD stress test")
})

testthat::test_that("test.stress.sfHSD.type2", {
  no.errors <- param.range.util(param = gamma, type = 2, sf = sfHSD)
  testthat::expect_true(no.errors, info = "Type 2 sfHSD stress test")
})

testthat::test_that("test.stress.sfHSD.type3", {
  no.errors <- param.range.util(param = gamma, type = 3, sf = sfHSD)
  testthat::expect_true(no.errors, info = "Type 3 sfHSD stress test")
})

testthat::test_that("test.stress.sfHSD.type4", {
  no.errors <- param.range.util(param = gamma, type = 4, sf = sfHSD)
  testthat::expect_true(no.errors, info = "Type 4 sfHSD stress test")
})

testthat::test_that("test.stress.sfHSD.type5", {
  no.errors <- param.range.util(param = gamma, type = 5, sf = sfHSD)
  testthat::expect_true(no.errors, info = "Type 5 sfHSD stress test")
})

testthat::test_that("test.stress.sfHSD.type6", {
  no.errors <- param.range.util(param = gamma, type = 6, sf = sfHSD)
  testthat::expect_true(no.errors, info = "Type 6 sfHSD stress test")
})

testthat::test_that("test.stress.sfLDOF.type1", {
  no.errors <- alpha.beta.range.util(
    alpha = a1, beta = b,
    type = 1, sf = sfLDOF
  )
  testthat::expect_true(no.errors, info = "Type 1 LDOF stress test")
})

testthat::test_that("test.stress.sfLDOF.type2", {
  no.errors <- alpha.beta.range.util(
    alpha = a2, beta = b,
    type = 2, sf = sfLDOF
  )
  testthat::expect_true(no.errors, info = "Type 2 LDOF stress test")
})

testthat::test_that("test.stress.sfLDOF.type3", {
  no.errors <- alpha.beta.range.util(
    alpha = a1, beta = b,
    type = 3, sf = sfLDOF
  )
  testthat::expect_true(no.errors, info = "Type 3 LDOF stress test")
})

testthat::test_that("test.stress.sfLDOF.type4", {
  no.errors <- alpha.beta.range.util(
    alpha = a1, beta = b,
    type = 4, sf = sfLDOF
  )
  testthat::expect_true(no.errors, info = "Type 4 LDOF stress test")
})

testthat::test_that("test.stress.sfLDOF.type5", {
  no.errors <- alpha.beta.range.util(
    alpha = a1, beta = b,
    type = 5, sf = sfLDOF
  )
  testthat::expect_true(no.errors, info = "Type 5 LDOF stress test")
})

testthat::test_that("test.stress.sfLDOF.type6", {
  no.errors <- alpha.beta.range.util(
    alpha = a1, beta = b,
    type = 6, sf = sfLDOF
  )
  testthat::expect_true(no.errors, info = "Type 6 LDOF stress test")
})

testthat::test_that("test.stress.sfLDPocock.type1", {
  no.errors <- alpha.beta.range.util(
    alpha = a1, beta = b,
    type = 1, sf = sfLDPocock
  )
  testthat::expect_true(no.errors, info = "Type 1 LDPocock stress test")
})

testthat::test_that("test.stress.sfLDPocock.type2", {
  no.errors <- alpha.beta.range.util(
    alpha = a2, beta = b,
    type = 2, sf = sfLDPocock
  )
  testthat::expect_true(no.errors, info = "Type 2 LDPocock stress test")
})

testthat::test_that("test.stress.sfLDPocock.type3", {
  no.errors <- alpha.beta.range.util(
    alpha = a1, beta = b,
    type = 3, sf = sfLDPocock
  )
  testthat::expect_true(no.errors, info = "Type 3 LDPocock stress test")
})

testthat::test_that("test.stress.sfLDPocock.type4", {
  no.errors <- alpha.beta.range.util(
    alpha = a1, beta = b,
    type = 4, sf = sfLDPocock
  )
  testthat::expect_true(no.errors, info = "Type 4 LDPocock stress test")
})

testthat::test_that("test.stress.sfLDPocock.type5", {
  no.errors <- alpha.beta.range.util(
    alpha = a1, beta = b,
    type = 5, sf = sfLDPocock
  )
  testthat::expect_true(no.errors, info = "Type 5 LDPocock stress test")
})

testthat::test_that("test.stress.sfLDPocock.type6", {
  no.errors <- alpha.beta.range.util(
    alpha = a1, beta = b,
    type = 6, sf = sfLDPocock
  )
  testthat::expect_true(no.errors, info = "Type 6 LDPocock stress test")
})

testthat::test_that("test.stress.sfPower.type1", {
  no.errors <- param.range.util(param = rho, type = 1, sf = sfPower)
  testthat::expect_true(no.errors, info = "Type 1 sfPower stress test")
})

testthat::test_that("test.stress.sfPower.type2", {
  no.errors <- param.range.util(param = rho, type = 2, sf = sfPower)
  testthat::expect_true(no.errors, info = "Type 2 sfPower stress test")
})

testthat::test_that("test.stress.sfPower.type3", {
  no.errors <- param.range.util(param = rho, type = 3, sf = sfPower)
  testthat::expect_true(no.errors, info = "Type 3 sfPower stress test")
})

testthat::test_that("test.stress.sfPower.type4", {
  no.errors <- param.range.util(param = rho, type = 4, sf = sfPower)
  testthat::expect_true(no.errors, info = "Type 4 sfPower stress test")
})

testthat::test_that("test.stress.sfPower.type5", {
  no.errors <- param.range.util(param = rho, type = 5, sf = sfPower)
  testthat::expect_true(no.errors, info = "Type 5 sfPower stress test")
})

testthat::test_that("test.stress.sfPower.type6", {
  no.errors <- param.range.util(param = rho, type = 6, sf = sfPower)
  testthat::expect_true(no.errors, info = "Type 6 sfPower stress test")
})

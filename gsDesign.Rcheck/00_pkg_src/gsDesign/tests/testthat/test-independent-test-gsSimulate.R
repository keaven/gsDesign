
# Fucntion returns a controlled simulated trial object for testing.
# This function mimics the output of IniSim() with fixed values to ensure consistent and reproducible behavior during unit testing of gsAdaptSim().
# It sets up baseline event counts, sample sizes, and a constant z-value for easy comparison and controlled test conditions.

testIniSim <- function(TrialPar, SimPar) {
  list(
    gsx = TrialPar$gsx,
    outcome = rep(0, TrialPar$nsim),
    nc = rep(50, TrialPar$nsim),
    ne = rep(50, TrialPar$nsim),
    xc = rep(25, TrialPar$nsim),
    xe = rep(30, TrialPar$nsim),
    ratio = 1,
    pc = 0.5,
    pe = 0.6,
    pcsim = 0.5,
    pesim = 0.6,
    nsim = TrialPar$nsim,
    xadd = NULL,
    nadd = NULL,
    z = rep(1.5, TrialPar$nsim),
    zStat = function(y) {
      y$z <- (y$xe / y$ne - y$xc / y$nc) /
        sqrt((y$xe / y$ne * (1 - y$xe / y$ne) + y$xc / y$nc * (1 - y$xc / y$nc)) / 2)
      y
    }
  )
}

# testSimStage: Adds small random noise to the current z-statistics to simulate
# changes across stages in the test simulation. Mimics a simplified version of
# the real SimStage() function to test the sequential behavior of gsSimulate()

testSimStage <- function(nI, x) {
  x$z <- x$z + rnorm(length(x$z), 0, 0.1)
  x
}

# testTrialPar: Provides predefined trial design parameters used during testing, including number of simulations (nsim), number of stages (k),
# information levels (n.I), and decision boundaries (upper/lower).

testTrialPar <- list(
  nsim = 5,
  gsx = list(
    k = 3,
    n.I = c(100, 200, 300),
    upper = list(bound = c(2.5, 2.5, 2.5)),
    lower = list(bound = c(-2.5, -2.5, -2.5)),
    beta = 0.2
  )
)

testSimPar <- list() #Placeholder for simulation parameters passed into testIniSim()

testTrialPar <- list(
  nsim = 5,
  gsx = list(
    k = 3,
    n.I = c(50, 100, 150),
    upper = list(bound = c(2, 2.5, 3)),
    lower = list(bound = c(-2, -2.5, -3)),
    beta = 0.1
  )
)

test_that("gsAdaptSim returns expected structure", {
  result <- gsAdaptSim(SimStage = testSimStage, IniSim = testIniSim,
                       TrialPar = testTrialPar, SimPar = testSimPar)
  expect_type(result, "list")
  expect_true(all(c("outcome", "gsx", "y", "nc", "ne", "xe", "xc") %in% names(result)))
  expect_true("outcome" %in% names(result))
  expect_equal(length(result$outcome), testTrialPar$nsim)
  expect_true(all(result$outcome >= 0))
  expect_true("y" %in% names(result))
  expect_true("z" %in% names(result$y))
  expect_equal(length(result$y$z), testTrialPar$nsim)
})

test_that("cp default is correctly set from beta", {
  result <- gsAdaptSim(SimStage = testSimStage, IniSim = testIniSim,
                       TrialPar = testTrialPar, SimPar = testSimPar, cp = 0)
  expect_equal(result$gsx$beta, testTrialPar$gsx$beta, tolerance = 0.1)
})

test_that("thetacp default is estimated at interim", {
  result <- gsAdaptSim(SimStage = testSimStage, IniSim = testIniSim,
                       TrialPar = testTrialPar, SimPar = testSimPar, thetacp = -100)
  expect_true(!any(is.na(result$y$z)))
})

test_that("Adaptation happens when delta > pdeltamin", {
  result <- gsAdaptSim(SimStage = testSimStage, IniSim = testIniSim,
                       TrialPar = testTrialPar, SimPar = testSimPar, pdeltamin = 0.05)
  adapted <- result$ne > 50 
  expect_true(any(adapted))
})

test_that("Adaptation is capped by maxn", {
  result <- gsAdaptSim(SimStage = testSimStage, IniSim = testIniSim,
                       TrialPar = testTrialPar, SimPar = testSimPar, maxn = 100000)
  expect_true(all(result$ne + result$nc <= 100000))
})

test_that("Function handles no adaptation (tight maxn)", {
  result <- gsAdaptSim(SimStage = testSimStage, IniSim = testIniSim,
                       TrialPar = testTrialPar, SimPar = testSimPar, maxn = 100)
  expect_true(all(result$ne >= 50))
})

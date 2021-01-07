## Benchmark values have been obtained from East 6.5,
## This is from the Sample Size/Events vs Time chart from the East design.
## : gsSurv.cywx
#-------------------------------------------------------------------------------

testthat::test_that(
  desc = "Test: checking output validation",
  code = {
    x <- gsSurv(
      k = 4, sfl = sfPower, sflpar = .5, lambdaC = log(2) / 6,
      hr = .5, eta = log(2) / 40, gamma = 1, T = 36, minfup = 12
    )

    testthat::expect_lte(
      object = abs(nEventsIA(tIA = 30, x) - 103.258),
      expected = 2
    )
  }
)
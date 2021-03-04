##tEventsIA checked using nEventsIA

testthat::test_that(
  desc = "Test: output validation ",
  code = {
    x <- gsSurv(
      k = 4, sfl = sfPower, sflpar = .5, lambdaC = log(2) / 6,
      hr = .5, eta = log(2) / 40, gamma = 1, T = 36, minfup = 12
    )
    nevent <- nEventsIA(tIA = 30.0, x)
    timing1 = (nevent / (x$eDC + x$eDE)[4]) 

    testthat::expect_lte(abs(tEventsIA(x,timing = timing1)$T - 30.0), 1e-6) 
  }
)
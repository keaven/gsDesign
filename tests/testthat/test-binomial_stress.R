testthat::context("binomial stress")

testthat::test_that("test.simBinomial.misc", {
  testthat::expect_equal(sum(-stats::qnorm(0.05) < gsDesign::simBinomial(
    p1 = 0.4, p2 = 0.05,
    delta0 = 0.2, n1 = 80, n2 = 80, nsim = 1e+05
  )) / 1e+05,
  0.813,
  info = "simBinomial check #1 failed (F&M bottom p 1451)", tolerance = 0.01
  )
  testthat::expect_equal(sum(-stats::qnorm(0.05) < gsDesign::simBinomial(
    p1 = 0.1, p2 = 0.1,
    delta0 = -0.2, n1 = 63, n2 = 42, nsim = 1e+05
  )) / 1e+05,
  0.916,
  info = "simBinomial check #2 failed (F&M Table 1)", tolerance = 0.01
  )
  testthat::expect_equal(sum(-stats::qnorm(0.05) < gsDesign::simBinomial(
    p1 = 0.25, p2 = 0.05,
    delta0 = 0.1, n1 = 173, n2 = 260, nsim = 1e+05
  )) / 1e+05,
  0.906,
  info = "simBinomial check #3 failed (F&M Table 1)", tolerance = 0.01
  )
  testthat::expect_equal(sum(-stats::qnorm(0.025) < gsDesign::simBinomial(
    p1 = 0.15, p2 = 0.1,
    delta0 = log(1.1), n1 = 901, n2 = 1351, scale = "lnor",
    nsim = 1e+05
  )) / 1e+05, 0.79875, info = "simBinomial check #4 failed", tolerance = 0.01)
  testthat::expect_equal(sum(-stats::qnorm(0.025) < gsDesign::simBinomial(
    p1 = 0.15, p2 = 0.1,
    delta0 = log(1.1), n1 = 901, n2 = 1351, scale = "or",
    nsim = 1e+05
  )) / 1e+05, 0.8056, info = "simBinomial check #5 failed", tolerance = 0.01)
  testthat::expect_equal(sum(-stats::qnorm(0.05) < gsDesign::simBinomial(
    p1 = 0.25, p2 = 0.05,
    delta0 = log(2), n1 = 134, n2 = 201, scale = "rr", nsim = 1e+05
  )) / 1e+05,
  0.9078,
  info = "simBinomial check #6 failed (F&M Table 1)", tolerance = 0.01
  )
})

testthat::test_that("test.testBinomial.numerics", {
  testthat::expect_equal(gsDesign::testBinomial(
    x1 = 0, x2 = 0, n1 = 10, n2 = 20,
    adj = 1, scale = "difference", delta = c(-0.1658, 0.2843608)
  ),
  c(1.959962, -1.959865),
  info = "Error in testBinomial example 1 (M&N example 4)", tolerance = 0.01
  )
  testthat::expect_equal(gsDesign::testBinomial(
    x1 = 10, x2 = 20, n1 = 10, n2 = 20,
    adj = 1, scale = "rr", delta = log(c(0.715615, 1.198703))
  ),
  c(1.96, -1.96),
  info = "Error in testBinomial example 2 (M&N example 6)", tolerance = 0.0001
  )
  testthat::expect_equal(gsDesign::testBinomial(
    x1 = 53, x2 = 40, n1 = 100, n2 = 100,
    scale = "LNOR", delta = c(-0.03152, 1.104)
  ), c(
    1.964856,
    -1.963414
  ), info = "Error in testBinomial example 3 (p 27, Lachin)", tolerance = 0.0001)
  testthat::expect_equal(gsDesign::testBinomial(
    x1 = 53, x2 = 40, n1 = 100, n2 = 100,
    scale = "OR", delta = c(-0.03463, 1.085673)
  ), c(
    1.965205,
    -1.96461
  ), info = "Error in testBinomial example 4 (p 27, Lachin)", tolerance = 0.0001)
})

testthat::test_that("test.nBinomial.misc", {
  testthat::expect_equal(gsDesign::nBinomial(
    p1 = 0.4, p2 = 0.05, alpha = 0.05,
    beta = 0.2, delta0 = 0.2, scale = "difference"
  ), 159.6876,
  info = "nBinomial check #1 failed (F&M, bottom p 1451)", tolerance = 0.0001
  )
  testthat::expect_equal(as.numeric(gsDesign::nBinomial(
    p1 = 0.1, p2 = 0.1, alpha = 0.05,
    delta0 = -0.2, ratio = 2 / 3, scale = "difference", outtype = 2
  )),
  c(62.88, 41.92),
  info = "nBinomial check #2 failed (F&M, Table 1)", tolerance = 0.0001
  )
  testthat::expect_equal(as.numeric(gsDesign::nBinomial(
    p1 = 0.25, p2 = 0.05, delta0 = 0.1,
    alpha = 0.05, ratio = 3 / 2, scale = "difference", outtype = 2
  )),
  c(173.2214, 259.8322),
  info = "nBinomial check #3 failed (F&M, Table 1)", tolerance = 0.0001
  )
  testthat::expect_equal(as.numeric(gsDesign::nBinomial(
    p1 = 0.25, p2 = 0.05, delta0 = log(2),
    alpha = 0.05, ratio = 3 / 2, scale = "rr", outtype = 2
  )),
  c(133.9289, 200.8933),
  info = "nBinomial check #4 failed (F&M, Table 1)", tolerance = 0.0001
  )
  testthat::expect_equal(gsDesign::nBinomial(p1 = 0.15, p2 = 0.1, beta = 0.2, scale = "or"),
    1355.84,
    info = "nBinomial check #5 failed (OR scale)", tolerance = 0.0001
  )
  testthat::expect_equal(as.numeric(gsDesign::nBinomial(
    p1 = 0.15, p2 = 0.1, beta = 0.2,
    delta0 = log(1.1), ratio = 3 / 2, scale = "or", outtype = 2
  )),
  c(900.57, 1350.85),
  info = "nBinomial check #6 failed (OR scale)", tolerance = 0.0001
  )
})

testthat::test_that("test.ciBinomial.RRscale.Infinity", {
  testthat::expect_equal(gsDesign::ciBinomial(
    scale = "RR", x1 = 4, x2 = 0, n1 = 100,
    n2 = 100
  )$upper, Inf, info = "ciBinomial infinity check #7 failed", tolerance = 0.0001)
  testthat::expect_equal(gsDesign::ciBinomial(
    scale = "RR", x1 = 0, x2 = 0, n1 = 100,
    n2 = 100
  )$upper, Inf, info = "ciBinomial infinity check #8 failed", tolerance = 0.0001)
})

testthat::test_that("test.ciBinomial.ORscale.Infinity", {
  testthat::expect_equal(gsDesign::ciBinomial(
    scale = "OR", x1 = 0, x2 = 4, n1 = 100,
    n2 = 100
  )$lower, -Inf, info = "ciBinomial infinity check #1 failed")
  testthat::expect_equal(gsDesign::ciBinomial(
    scale = "OR", x1 = 4, x2 = 0, n1 = 100,
    n2 = 100
  )$upper, Inf, info = "ciBinomial infinity check #2 failed", tolerance = 0.0001)
  testthat::expect_equal(gsDesign::ciBinomial(
    scale = "OR", x1 = 100, x2 = 96,
    n1 = 100, n2 = 100
  )$upper, Inf, info = "ciBinomial infinity check #3 failed", tolerance = 0.0001)
  testthat::expect_equal(gsDesign::ciBinomial(
    scale = "OR", x1 = 96, x2 = 100,
    n1 = 100, n2 = 100
  )$lower, -Inf, info = "ciBinomial infinity check #4 failed", tolerance = 0.0001)
  testthat::expect_equal(gsDesign::ciBinomial(
    scale = "OR", x1 = 0, x2 = 0, n1 = 100,
    n2 = 100
  ), data.frame(lower = -Inf, upper = Inf), info = "ciBinomial infinity check #5 failed", tolerance = 0.0001)
  testthat::expect_equal(gsDesign::ciBinomial(
    scale = "OR", x1 = 100, x2 = 100,
    n1 = 100, n2 = 100
  ), data.frame(lower = -Inf, upper = Inf),
  info = "ciBinomial infinity check #6 failed", tolerance = 0.0001
  )
})

testthat::test_that("test.ciBinomial.misc", {
  testthat::expect_equal(as.numeric(gsDesign::ciBinomial(
    x1 = 0, x2 = 0, n1 = 10,
    n2 = 20, adj = 1, scale = "difference"
  )), c(
    -0.1658,
    0.2843608
  ), info = "ciBinomial numeric check #1 failed (M&N example 4", tolerance = 0.0001)
  testthat::expect_equal(as.numeric(gsDesign::ciBinomial(
    x1 = 72, x2 = 20, n1 = 756,
    n2 = 573, adj = 1, scale = "difference"
  )), c(
    0.0344,
    0.0868
  ), info = "ciBinomial numeric check #2 failed", tolerance = 0.0001)
  testthat::expect_equal(as.numeric(gsDesign::ciBinomial(
    x1 = 10, x2 = 20, n1 = 10,
    n2 = 20, adj = 1, scale = "rr"
  )), c(0.7156205, 1.198696),
  info = "ciBinomial numeric check #3 failed (M&N example 6", tolerance = 0.0001
  )
})

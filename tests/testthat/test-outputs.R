testthat::context("outputs")

testthat::test_that("test.Deming.gsProb", {
  w <- sum(gsDesign::gsProbability(k = 2, theta = 0, n.I = 1:2, a = stats::qnorm(0.025) *
    c(1, 1), b = stats::qnorm(0.975) * c(1, 1))$upper$prob)
  x <- sum(gsDesign::gsProbability(k = 4, theta = 0, n.I = 1:4, a = stats::qnorm(0.025) *
    c(1, 1, 1, 1), b = stats::qnorm(0.975) * c(1, 1, 1, 1))$upper$prob)
  y <- sum(gsDesign::gsProbability(k = 10, theta = 0, n.I = 1:10, a = stats::qnorm(0.025) *
    array(1, 10), b = stats::qnorm(0.975) * array(1, 10))$upper$prob)
  z <- sum(gsDesign::gsProbability(k = 20, theta = 0, n.I = 1:20, a = stats::qnorm(0.025) *
    array(1, 20), b = stats::qnorm(0.975) * array(1, 20))$upper$prob)
  testthat::expect_equal(0.042, round(w, 3), info = "Checking Type I error, k = 2")
  testthat::expect_equal(0.063, round(x, 3), info = "Checking Type I error, k = 4")
  testthat::expect_equal(0.097, round(y, 3), info = "Checking Type I error, k = 10")
  testthat::expect_equal(0.124, round(z, 3), info = "Checking Type I error, k = 20")
})

testthat::test_that("test.Deming.OFbound", {
  x <- gsDesign::gsDesign(
    k = 4, test.type = 2, sfu = "OF", n.fix = 1372,
    beta = 0.2
  )
  testthat::expect_equal(c(4.05, 2.86, 2.34, 2.02), round(
    x$upper$bound,
    2
  ), info = "Checking O'Brien-Fleming bounds")
})

testthat::test_that("test.JT.OFss", {
  x <- gsDesign::gsDesign(k = 5, test.type = 2, sfu = "OF", beta = 0.2)
  testthat::expect_equal(102.8, round(x$n.I[5] * 100, 1), info = "Checking 2-sided OF (gsDesign n.I), k=4, beta=0.2")
  testthat::expect_equal(102.1, round(x$en[1] * 100, 1), info = "Checking 2-sided Pocock (gsDesign en), k=4, beta=0.2")
  x <- gsDesign::gsDesign(k = 20, test.type = 2, sfu = "OF", beta = 0.1)
  testthat::expect_equal(104.5, round(x$n.I[20] * 100, 1), info = "Checking 2-sided OF (gsDesign n.I), k=20, beta=0.1")
  testthat::expect_equal(103.4, round(x$en[1] * 100, 1), info = "Checking 2-sided Pocock (gsDesign en), k=20, beta=0.1")
})

testthat::test_that("test.JT.Pocock", {
  x <- gsDesign::gsDesign(k = 4, test.type = 2, sfu = "Pocock", beta = 0.2)
  testthat::expect_equal(120.2, round(x$n.I[4] * 100, 1), info = "Checking 2-sided Pocock (gsDesign n.I), k=4, beta=0.2")
  testthat::expect_equal(117.5, round(x$en[1] * 100, 1), info = "Checking 2-sided Pocock (gsDesign en), k=4, beta=0.2")
  y <- gsDesign::gsProbability(theta = x$delta * c(0, 0.5, 1, 1.5), d = x)
  testthat::expect_equal(c(117.5, 108.8, 80.5, 52.2), round(
    y$en * 100,
    1
  ), info = "Checking 2-sided Pocock (gsProb), k=4, beta=0.2")
  x <- gsDesign::gsDesign(k = 15, test.type = 2, sfu = "Pocock", beta = 0.1)
  testthat::expect_equal(130.5, round(x$n.I[15] * 100, 1), info = "Checking 2-sided Pocock (gsDesign n.I), k=15, beta=0.1")
  testthat::expect_equal(126.4, round(x$en[1] * 100, 1), info = "Checking 2-sided Pocock (gsDesign en), k=15, beta=0.1")
  y <- gsDesign::gsProbability(theta = x$delta * c(0, 0.5, 1, 1.5), d = x)
  testthat::expect_equal(c(126.4, 111.2, 66.4, 35.4), round(
    y$en * 100,
    1
  ), info = "Checking 2-sided Pocock (gsProb), k=15, beta=0.1")
})

testthat::test_that("test.JT.Power.symm", {
  x <- gsDesign::gsDesign(
    k = 3, test.type = 2, sfu = sfPower, sfupar = 1,
    beta = 0.2
  )
  testthat::expect_equal(111.7, round(x$n.I[3] * 100, 1), info = "Checking symm 2-sided sfPower (gsDesign n.I), k=3, rho=1")
  testthat::expect_equal(109.9, round(x$en[1] * 100, 1), info = "Checking symm 2-sided sfPower (gsDesign en), k=3, rho=1")
  y <- gsDesign::gsProbability(theta = x$delta * c(0, 0.5, 1, 1.5), d = x)
  testthat::expect_equal(c(109.9, 103.4, 81.2, 56.5), round(
    y$en * 100,
    1
  ), info = "Checking symm 2-sided sfPower (gsProb), k=3, rho=1")
  x <- gsDesign::gsDesign(
    k = 10, test.type = 2, sfu = sfPower, sfupar = 2,
    beta = 0.2
  )
  testthat::expect_equal(108.1, round(x$n.I[10] * 100, 1), info = "Checking symm 2-sided sfPower (gsDesign), k=10, rho=2")
  testthat::expect_equal(106.6, round(x$en[1] * 100, 1), info = "Checking symm 2-sided sfPower (gsDesign en), k=10, rho=2")
  y <- gsDesign::gsProbability(theta = x$delta * c(0, 0.5, 1, 1.5), d = x)
  testthat::expect_equal(c(106.6, 99.7, 76.2, 51), round(
    y$en * 100,
    1
  ), info = "Checking symm 2-sided sfPower (gsProb), k=10, rho=2")
  x <- gsDesign::gsDesign(
    k = 2, test.type = 2, sfu = sfPower, sfupar = 3,
    beta = 0.2
  )
  testthat::expect_equal(101, round(x$n.I[2] * 100, 1), info = "Checking symm 2-sided sfPower (gsDesign), k=2, rho=3")
  testthat::expect_equal(100.7, round(x$en[1] * 100, 1), info = "Checking symm 2-sided sfPower (gsDesign en), k=2, rho=3")
  y <- gsDesign::gsProbability(theta = x$delta * c(0, 0.5, 1, 1.5), d = x)
  testthat::expect_equal(c(100.7, 98.9, 89.5, 70.7), round(
    y$en * 100,
    1
  ), info = "Checking symm 2-sided sfPower (gsProb), k=2, rho=3")
})

testthat::test_that("test.JT.Power.type3", {
  x <- gsDesign::gsDesign(
    k = 5, test.type = 3, alpha = 0.05, beta = 0.05,
    sfu = sfPower, sfupar = 2, sfl = sfPower, sflpar = 2
  )
  testthat::expect_equal(110.1, round(x$n.I[5] * 100, 1), info = "Checking type3 sfPower (gsDesign n.I), k=5, rho=2, beta=0.05")
  testthat::expect_equal(63.4, round(x$en[1] * 100, 1), info = "Checking type3 sfPower (gsDesign en), k=5, rho=2, beta=0.05")
  y <- gsDesign::gsProbability(theta = x$delta * c(0, 0.5, 1), d = x)
  testthat::expect_equal(c(63.4, 80.3, 63.4), round(y$en * 100, 1), info = "Checking type3 sfPower (gsProb), k=5, rho=2, beta=0.05")
  x <- gsDesign::gsDesign(
    k = 10, test.type = 3, alpha = 0.05, beta = 0.05,
    sfu = sfPower, sfupar = 3, sfl = sfPower, sflpar = 3
  )
  testthat::expect_equal(106.9, round(x$n.I[10] * 100, 1), info = "Checking type3 sfPower (gsDesign n.I), k=10, rho=3, beta=0.05")
  testthat::expect_equal(63.1, round(x$en[1] * 100, 1), info = "Checking type3 sfPower (gsDesign en), k=10, rho=3, beta=0.05")
  y <- gsDesign::gsProbability(theta = x$delta * c(0, 0.5, 1), d = x)
  testthat::expect_equal(c(63.1, 79.5, 63.1), round(y$en * 100, 1), info = "Checking type3 sfPower (gsProb), k=10, rho=3, beta=0.05")
  x <- gsDesign::gsDesign(
    test.type = 3, alpha = 0.05, sfu = sfPower,
    sfupar = 2, sfl = sfPower, sflpar = 2
  )
  testthat::expect_equal(107.2, round(x$n.I[3] * 100, 1), info = "Checking type3 sfPower (gsDesign n.I), k=3, rho=2, beta=0.1")
  testthat::expect_equal(68.1, round(x$en[1] * 100, 1), info = "Checking type3 sfPower (gsDesign en), k=3, rho=2, beta=0.1")
  y <- gsDesign::gsProbability(theta = x$delta * c(0, 0.5, 1), d = x)
  testthat::expect_equal(c(68.1, 83.9, 73.8), round(y$en * 100, 1), info = "Checking type3 sfPower (gsProb), k=3, rho=2, beta=0.1")
  x <- gsDesign::gsDesign(
    k = 4, test.type = 3, alpha = 0.05, sfu = sfPower,
    sfupar = 3, sfl = sfPower, sflpar = 3
  )
  testthat::expect_equal(104, round(x$n.I[4] * 100, 1), info = "Checking type3 sfPower (gsDesign n.I), k=4, rho=3, beta=0.1")
  testthat::expect_equal(69.2, round(x$en[1] * 100, 1), info = "Checking type3 sfPower (gsDesign en), k=4, rho=3, beta=0.1")
  y <- gsDesign::gsProbability(theta = x$delta * c(0, 0.5, 1), d = x)
  testthat::expect_equal(c(69.2, 84.2, 74.2), round(y$en * 100, 1), info = "Checking type3 sfPower (gsProb), k=3, rho=3, beta=0.1")
  x <- gsDesign::gsDesign(
    k = 2, test.type = 3, alpha = 0.05, beta = 0.2,
    sfu = sfPower, sfupar = 2, sfl = sfPower, sflpar = 2
  )
  testthat::expect_equal(104.3, round(x$n.I[2] * 100, 1), info = "Checking type3 sfPower (gsDesign n.I), k=2, rho=2, beta=0.2")
  testthat::expect_equal(74.5, round(x$en[1] * 100, 1), info = "Checking type3 sfPower (gsDesign en), k=2, rho=2, beta=0.2")
  y <- gsDesign::gsProbability(theta = x$delta * c(0, 0.5, 1), d = x)
  testthat::expect_equal(c(74.5, 87.8, 84.6), round(y$en * 100, 1), info = "Checking type3 sfPower (gsProb), k=2, rho=2, beta=0.2")
  x <- gsDesign::gsDesign(
    k = 15, test.type = 3, alpha = 0.05, beta = 0.2,
    sfu = sfPower, sfupar = 3, sfl = sfPower, sflpar = 3
  )
  testthat::expect_equal(106.9, round(x$n.I[15] * 100, 1), info = "Checking type3 sfPower (gsDesign n.I), k=15, rho=3, beta=0.2")
  testthat::expect_equal(62.2, round(x$en[1] * 100, 1), info = "Checking type3 sfPower (gsDesign en), k=15, rho=3, beta=0.2")
  y <- gsDesign::gsProbability(theta = x$delta * c(0, 0.5, 1), d = x)
  testthat::expect_equal(c(62.2, 77.3, 73), round(y$en * 100, 1), info = "Checking type3 sfPower (gsProb), k=15, rho=3, beta=0.2")
})

testthat::test_that("test.JT.WT", {
  x <- gsDesign::gsDesign(
    k = 9, test.type = 2, sfu = "WT", sfupar = 0.1,
    beta = 0.1
  )
  testthat::expect_equal(1.048, round(x$n.I[9], 3), info = "Checking 2-sided WT max SS, Delta=0.1, k=9, beta=0.1")
  testthat::expect_equal(2.113, round(x$upper$bound[9], 3), info = "Checking 2-sided WT bound, Delta=0.1, k=9, beta=0.1")
  x <- gsDesign::gsDesign(
    k = 6, test.type = 2, sfu = "WT", sfupar = 0.25,
    beta = 0.2
  )
  testthat::expect_equal(1.077, round(x$n.I[6], 3), info = "Checking 2-sided WT max SS, Delta=0.25, k=6, beta=0.2")
  testthat::expect_equal(2.154, round(x$upper$bound[6], 3), info = "Checking 2-sided WT bound, Delta=0.25, k=6, beta=0.2")
  x <- gsDesign::gsDesign(
    k = 7, test.type = 2, sfu = "WT", sfupar = 0.4,
    beta = 0.2
  )
  testthat::expect_equal(1.159, round(x$n.I[7], 3), info = "Checking 2-sided WT max SS, Delta=0.4, k=7, beta=0.2")
  testthat::expect_equal(2.313, round(x$upper$bound[7], 3), info = "Checking 2-sided WT bound, Delta=0.4, k=7, beta=0.2")
})

testthat::context("C numerics regression")

testthat::test_that("C refactor preserves key numerics", {
  expected <- list(
    gsBound = list(
      a = c(-2.05374891063182, -1.91418286953087, -1.78920626107788),
      b = c(2.32634787404084, 2.21929929409811, 2.12012742952919)
    ),
    gsBound1 = list(
      b = c(3.09023230616781, 2.34482438570837, 2.03950136608231),
      problo = c(2.75362411860623e-89, 1.67599416467376e-89, 6.64369561756751e-92)
    ),
    gsProbability = list(
      lower = structure(
        c(
          0.358276535928559, 0.0804375200442274, 0.0379541059065421,
          0.308537538725987, 0.0658271483061993, 0.0281699654253188,
          0.26208501204865, 0.052087603770101, 0.0197314332763651
        ),
        dim = c(3L, 3L)
      ),
      upper = structure(
        c(
          0.0041829967861875, 0.00596407884275666, 0.00854522426818119,
          0.00620966532577613, 0.00996166709538417, 0.0156648014320317,
          0.00906213856022171, 0.0160735550179362, 0.0271031723267736
        ),
        dim = c(3L, 3L)
      )
    ),
    gsDensity = list(
      i1 = structure(
        c(
          0.00662091556833086, 0.274890375874209, 0.395219673449451,
          0.209036965815118, 0.0123309843433532, 0.0044318484112856,
          0.241970724483523, 0.398942280342705, 0.241970724483523,
          0.0175283004909882, 0.00291144589087607, 0.209036965815118,
          0.395219673449451, 0.274890375874209, 0.0244533774665262
        ),
        dim = c(5L, 3L)
      ),
      i2 = structure(
        c(
          0.00765088840573946, 0.0363569774446269, 0.110905859017932,
          0.221544370982169, 0.297582375374173, 0.277602986515003,
          0.185979187206163, 0.0917832716286008, 0.0336088466679076,
          0.00529240840379474, 0.027706370932669, 0.0931100906860682,
          0.204905380000237, 0.303214683041555, 0.311614413410619,
          0.229989564624082, 0.12504251559541, 0.0504426807919902,
          0.00352621519919253, 0.0203369339034892, 0.0752927152265086,
          0.182540801847995, 0.297582375281782, 0.336918531722689,
          0.273946575203526, 0.164083846520298, 0.0729216803979529
        ),
        dim = c(9L, 3L)
      )
    )
  )

  x1 <- gsDesign::gsBound(
    I = c(1, 2, 3) / 3,
    trueneg = rep(0.02, 3),
    falsepos = rep(0.01, 3),
    tol = 1e-6,
    r = 18
  )
  testthat::expect_equal(x1$a, expected$gsBound$a, tolerance = 1e-12)
  testthat::expect_equal(x1$b, expected$gsBound$b, tolerance = 1e-12)

  x2 <- gsDesign::gsBound1(
    theta = 0,
    I = c(1, 2, 3) / 3,
    a = rep(-20, 3),
    probhi = c(0.001, 0.009, 0.015),
    tol = 1e-6,
    r = 18
  )
  testthat::expect_equal(x2$b, expected$gsBound1$b, tolerance = 1e-12)
  testthat::expect_equal(x2$problo, expected$gsBound1$problo, tolerance = 1e-12)

  p <- gsDesign::gsProbability(
    k = 3,
    theta = c(-0.25, 0, 0.25),
    n.I = c(0.3, 0.6, 1.0),
    a = c(-0.5, -0.75, -1.0),
    b = c(2.5, 2.25, 2.0),
    r = 18
  )
  testthat::expect_equal(p$lower$prob, expected$gsProbability$lower, tolerance = 1e-12)
  testthat::expect_equal(p$upper$prob, expected$gsProbability$upper, tolerance = 1e-12)

  d1 <- gsDesign::gsDensity(
    x = p,
    theta = c(-0.25, 0, 0.25),
    i = 1L,
    zi = c(-3, -1, 0, 1, 2.5),
    r = 18
  )
  testthat::expect_equal(d1$density, expected$gsDensity$i1, tolerance = 1e-12)

  d2 <- gsDesign::gsDensity(
    x = p,
    theta = c(-0.25, 0, 0.25),
    i = 2L,
    zi = seq(-2, 2, by = 0.5),
    r = 18
  )
  testthat::expect_equal(d2$density, expected$gsDensity$i2, tolerance = 1e-12)
})


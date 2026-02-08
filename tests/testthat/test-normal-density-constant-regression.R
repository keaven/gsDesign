testthat::test_that("gsBound is stable for representative inputs", {
  x <- gsDesign::gsBound(
    I = c(0.25, 0.5, 0.75, 1),
    trueneg = c(0.01, 0.02, 0.03, 0.04),
    falsepos = c(0.005, 0.01, 0.015, 0.02),
    tol = 1e-8,
    r = 18
  )

  testthat::expect_equal(x$error, 0L)
  testthat::expect_equal(
    x$a,
    c(-2.32634787404084, -1.96818185313167, -1.67671154533665, -1.41871200118752),
    tolerance = 1e-8
  )
  testthat::expect_equal(
    x$b,
    c(2.5758293035489, 2.25986082564025, 2.00956238688048, 1.79397591800809),
    tolerance = 1e-8
  )
})

testthat::test_that("gsBound1 is stable for representative inputs", {
  x <- gsDesign::gsBound1(
    theta = 0.35,
    I = c(0.25, 0.5, 0.75, 1),
    a = c(-2.8, -2.4, -2.1, -1.96),
    probhi = c(0.002, 0.006, 0.012, 0.02),
    tol = 1e-8,
    r = 18
  )

  testthat::expect_equal(x$error, 0L)
  testthat::expect_equal(
    x$b,
    c(3.05316173909548, 2.71771590385463, 2.4436403142931, 2.19873543003778),
    tolerance = 1e-8
  )
  testthat::expect_equal(
    x$problo,
    c(0.00146494273922955, 0.00358821454505199, 0.00597577248693223, 0.00579998523854975),
    tolerance = 1e-8
  )
})

testthat::test_that("gsDensity is stable at first and later analyses", {
  d <- gsDesign::gsDesign(k = 4, test.type = 2, sfu = "OF", alpha = 0.025, beta = 0.2)

  den1 <- gsDesign::gsDensity(
    x = d,
    theta = c(-0.2, 0, 0.3),
    i = 1,
    zi = c(-1.5, -0.25, 0, 1.25)
  )$density
  den3 <- gsDesign::gsDensity(
    x = d,
    theta = c(-0.2, 0, 0.3),
    i = 3,
    zi = c(-2.5, -1, 0, 1, 2.5)
  )$density

  testthat::expect_equal(
    den1,
    structure(
      c(
        0.149976025630557, 0.394549195919026, 0.396905220923099,
        0.160126783568876, 0.129517595646825, 0.386668116745928,
        0.398942280342705, 0.182649085362134, 0.101965198817964,
        0.368007747082996, 0.394373517573607, 0.218278309393156
      ),
      dim = c(4L, 3L)
    ),
    tolerance = 1e-9
  )
  testthat::expect_equal(
    den3,
    structure(
      c(
        0.0246750805539103, 0.283868325719495, 0.392861731743116,
        0.199935428769518, 0.0102728391182201, 0.0161675545893474,
        0.241920745139233, 0.398941749191519, 0.241920745139233,
        0.0161675545893474, 0.00809489540955571, 0.179678354438577,
        0.385391850092692, 0.303974064378235, 0.0301344580501573
      ),
      dim = c(5L, 3L)
    ),
    tolerance = 1e-9
  )
})

testthat::test_that("gsProbability remains stable for representative bounds", {
  d <- gsDesign::gsDesign(k = 4, test.type = 2, sfu = "OF", alpha = 0.025, beta = 0.2)
  p <- gsDesign::gsProbability(
    k = d$k,
    theta = c(-0.2, 0, 0.3),
    n.I = d$n.I,
    a = d$lower$bound,
    b = d$upper$bound,
    r = 18
  )

  testthat::expect_equal(
    p$upper$prob,
    structure(
      c(
        1.66400022856292e-05, 0.00131497939619109, 0.00518530133766029,
        0.00895618146440017, 2.57634255827315e-05, 0.00208457724169985,
        0.00834554793644277, 0.0145441105183363, 4.87333522297357e-05,
        0.0040153716903915, 0.0161524792689938, 0.0279995912619114
      ),
      dim = c(4L, 3L)
    ),
    tolerance = 1e-9
  )
  testthat::expect_equal(
    p$lower$prob,
    structure(
      c(
        3.95012721949405e-05, 0.00324246173719493, 0.0130536432925157,
        0.0227249203543359, 2.57634255827315e-05, 0.00208457724169985,
        0.00834554793644276, 0.0145441105183363, 1.33240065689145e-05,
        0.00103696987534739, 0.00404355061406175, 0.0069268941635626
      ),
      dim = c(4L, 3L)
    ),
    tolerance = 1e-9
  )
  testthat::expect_equal(
    p$en,
    c(1.01680169602634, 1.01740020212267, 1.01604286351769),
    tolerance = 1e-9
  )
})

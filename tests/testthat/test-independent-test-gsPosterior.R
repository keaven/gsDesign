source("../benchmarks/gsDesign_independent_code.R")
#--------------------------------------------
### Testing gsPosterior:
#---------------------------------------------


testthat::test_that(
  desc = "Test: checking lengths of inputs for prior variable.",
  code = {
    x <- gsDesign(k = 4, test.type = 1, n.fix = 800)
    local_edition(3)
    expect_error(gsPosterior(x, i = 2, zi = NULL,
      prior = list(
        z = seq(0, 0.5, 0.01), density = seq(0, 1, 0.01),
        gridwgts = seq(0.2, 0.8, 0.01), wgts = seq(0.2, 0.8, 0.001)
      ), r = 18
    ))
  }
)


testthat::test_that(desc = "Test: checking prior$density out of range.", code = {
  x <- gsDesign(k = 4, test.type = 1, n.fix = 800)
  local_edition(3)
  expect_error(gsPosterior(x, i = 2, zi = NULL,
    prior = list(
      z = seq(0, 1, 0.01), density = seq(-0.1, 0.9, 0.01),
      gridwgts = seq(0, 1, 0.01), wgts = seq(0, 1, 0.01)
    ), r = 18
  ))
})


testthat::test_that(
  desc = "Test: checking prior$gridwgts out of range.",
  code = {
    x <- gsDesign(k = 4, test.type = 1, n.fix = 800)
    local_edition(3)
    expect_error(gsPosterior(x, i = 2, zi = NULL,
      prior = list(
        z = seq(0, 1, 0.01), density = seq(0, 1, 0.01),
        gridwgts = seq(-0.1, 0.9, 0.01), wgts = seq(0, 1, 0.01)
      ), r = 18
    ))
  }
)



testthat::test_that(desc = "Test: checking variable i data types.", code = {
  x <- gsDesign(k = 4, test.type = 1, n.fix = 800)
  local_edition(3)
  expect_error(gsPosterior(x, i = 0.2, zi = NULL, prior = normalGrid(), r = 18))
})



testthat::test_that(desc = "Test: checking out of range i.", code = {
  x <- gsDesign(k = 2, test.type = 1, n.fix = 800)
  local_edition(3)
  expect_error(gsPosterior(x,
    i = 3, zi = NULL,
    prior = normalGrid(r = 2, bounds = c(0, 0), mu = 0, sigma = 1), r = 18
  ))
})


testthat::test_that(desc = "Test: checking checking x class object.", code = {
  x <- seq(1, 2, 0.5)
  local_edition(3)
  expect_error(gsPosterior(x, i = 2, zi = NULL, prior = normalGrid(), r = 18))
})



testthat::test_that(desc = "Test: checking length zi .", code = {
  x <- gsDesign(k = 4, test.type = 1, n.fix = 800)
  local_edition(3)
  expect_error(gsPosterior(x, i = 2, zi = rep(1, 3), prior = normalGrid(), r = 18))
})



testthat::test_that(desc = "Test: checking z parameter value", code = {
  x <- gsDesign(k = 4, test.type = 1, n.fix = 800)
  local_edition(3)
  expect_error(gsPosterior(x, i = 2, zi = c(0.5, 0.2),
    prior = normalGrid(), r = 18
  ))
})



testthat::test_that(desc = "Test: checking z variable types.", code = {
  x <- gsDesign(k = 4, test.type = 1, n.fix = 800)
  local_edition(3)
  expect_error(gsPosterior(x, i = 2, zi = c(0.5, "a"), prior = normalGrid(), r = 18))
})



testthat::test_that(
  desc = "Test: checking Output validation, 
          source: /tests/cytel/gsDesign_independent_code.R",
  code = {
    x <- gsDesign(k = 3, test.type = 1, n.fix = 800)
    theta <- seq(-3, 3, 0.75)
    i <- 1
    zi <- 0.5
    pr <- list(
      z = seq(-3, 3, 0.75),
      density = c(
        0.0044, 0.0317, 0.1295, 0.3011, 0.3989, 0.3011,
        0.1295, 0.0317, 0.0044
      ),
      gridwgts = rep(0.25, 9),
      wgts = c(
        0.001100, 0.007925, 0.032375, 0.075275, 0.099725,
        0.075275, 0.032375, 0.007925, 0.001100
      )
    )

    z <- gsPosterior(x = x, i = 1, zi = 0.5, prior = pr, r = 18)
    expected_res <- validate_gsPosterior(x, theta, pr$density, pr$gridwgts, pr$wgts, i, zi)
    local_edition(3)
    expect_equal(z$density, c(expected_res))
  }
)
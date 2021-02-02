source('../gsDesign_independent_code.R')
#---------------
### Testing gsZ:
#---------------


testthat::test_that(
  desc = "test: checking output validation density = 0, 
                    source independent R Program gsDesign_independent_code.R",
  code = {
    x <- gsDesign(k = 3, test.type = 1, n.fix = 800)
    theta <- c(0, 0.5)
    i <- 2
    zi <- Inf

    local_edition(3)
    z <- gsZ(x, theta, i, zi)
    expected_gsz <- validate_gsZ(x, theta, i, zi)
    expect_equal(z$density[1], expected_gsz[1])
    expect_equal(z$density[2], expected_gsz[2])
  }
)



testthat::test_that(desc = "test: checking error x$n.I", code = {
  x <- seq(0, 2, 0.5)
  local_edition(3)
  expect_error(gsZ(x, theta = c(0, 0.5), i = 2, zi = 1.6))
})



testthat::test_that(
  desc = "test : checking output validation,
                    source : independent R Program gsDesign_independent_code.R",
  code = {
    x <- gsDesign(k = 3, test.type = 1, n.fix = 800)
    theta <- c(0, 2, 0.5)
    i <- 1
    zi <- 0.5
    z <- gsZ(x, theta = c(0, 2, 0.5), i = 1, zi = 0.5)
    expected_z <- validate_gsZ(x, theta, i, zi)

    local_edition(3)
    expect_equal(z$density[1], expected_z[1])
    expect_equal(z$density[2], expected_z[2])
    expect_equal(z$density[3], expected_z[3])
  }
)


testthat::test_that(
  desc = "test : checking output validation, 
  source : independent R Program gsDesign_independent_code.R",
  code = {
    x <- gsDesign(k = 4, test.type = 2, n.fix = 800)
    theta <- c(0, 0.1, 0.05)
    i <- 2
    zi <- c(0.1, 0.175, 0.22)

    z <- gsZ(x, theta = c(0, 0.1, 0.05), i = 2, zi = c(0.1, 0.175, 0.22))
    expected_res <- validate_gsZ(x, theta, i, zi)
    local_edition(3)
    expect_equal(z$density[1], expected_res[1])
  }
)


testthat::test_that(
  desc = "test : checking output validation : expected output is NA ",
  code = {
    x <- gsDesign(k = 4, test.type = 2, n.fix = 800)
    z <- gsZ(x, theta = c(0, 0.1, 0.05), i = 5, zi = c(0.1, 0.175, 0.22))

    fze <- matrix(rep(NA, 9), nrow = 3, ncol = 3)
    local_edition(3)
    expect_setequal(z$density, fze)
  }
)

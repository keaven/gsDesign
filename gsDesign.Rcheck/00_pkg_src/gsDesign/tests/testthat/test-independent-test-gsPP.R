#---------------
### Testing gsPP:
#---------------

# testing TestCase1_gsPP test.type = 2
testthat::test_that(desc = "Test: checking output validation,
                    source: helper.R", 
                    code = {
  x <- gsDesign(k = 4, test.type = 2, n.fix = 800)
  zi <- 1
  theta <- c( 0.00, 0.05, 0.10)
  i=2
  wgts = c(0.4,0.5,0.2)
  r <- 18
  total <- TRUE
  PP <- gsPP(x = x, wgts = c(0.4, 0.5, 0.2), i = 2, theta = c(0.00, 0.05, 0.10), 
             r = 18, zi = 1, total = TRUE)
  expected_PP <- validate_gsPP(x, i, zi , theta , wgts , r , total = total)
  local_edition(3)
  expect_equal(PP,expected_PP)
})



# testing TestCase1_gsPP test.type = 1
testthat::test_that(desc = "Test: checking output validation,
                    source: helper.R", 
                    code = {
  x <- gsDesign(k = 4, test.type = 1, n.fix = 800)
  zi <- 0
  theta <- c(0.00, 0.5)
  i = 2
  wgts = c(0.4,0.5)
  r <- 18
  total <- TRUE
  
  PP1 <- gsPP(x = x, wgts = c(0.4, 0.5), i = 2,
             theta = c(0.00, 0.5), r = 18, zi = 0, total = TRUE)
  expected_PP1 <- validate_gsPP(x, i, zi , theta , wgts , r , total = total)
  local_edition(3)
  expect_equal(PP1 , expected_PP1)
})



testthat::test_that(desc = "Test: checking out of range i", 
                    code = {
  x <- gsDesign(k = 3, test.type = 1, n.fix = 800)
  local_edition(3)
  expect_error(gsPP(x = x, wgts = c(0.5, 0.5), i = 4, theta = c(0, 3),
                    r = 18, zi = 0, total = TRUE))
})


testthat::test_that(desc = "Test: zi is not a scalar", 
                    code = {
  x <- gsDesign(k = 3, test.type = 1, n.fix = 800)
  local_edition(3)
  expect_error(gsPP(x = x, wgts = c(0.5, 0.5), i = 1, theta = c(0, 3),
                    r = 18, zi = c(2, 3), total = TRUE))
})


testthat::test_that(desc = "Test: checking out of range zi", 
                    code = {
  x <- gsDesign(k = 3, test.type = 1, n.fix = 800)
  local_edition(3)
  expect_error(gsPP(x = x, wgts = c(0.5, 0.5), i = 1, theta = c(0, 3),
                    r = 18, zi = Inf, total = TRUE))
})



testthat::test_that(desc = "Test: checking out of range zi", code = {
  x <- gsDesign(k = 3, test.type = 1, n.fix = 800)
  local_edition(3)
  expect_error(gsPP(x = x, wgts = c(-1, 1), i = 1, theta = c(0, 3),
                    r = 18, zi = 1, total = TRUE))
})



testthat::test_that(desc = "Test: checking input length", code = {
  x <- gsDesign(k = 3, test.type = 1, n.fix = 800)
  local_edition(3)
  expect_error(gsPP(x = x, wgts = c(0.5, 0.5), i = 1, theta = c(0, 1.5, 3),
                    r = 18, zi = 1, total = TRUE))
})



testthat::test_that(desc = "Test: checking out of range i", code = {
  x <- gsDesign(k = 3, test.type = 1, n.fix = 800)
  local_edition(3)
  expect_error(gsPP(x = x, wgts = c(0.5, 0.5), i = 4, theta = c(0, 3),
                    r = 18, zi = 1, total = TRUE))
})



testthat::test_that(desc = "Test: checking out of range R", 
                    code = {
  x <- gsDesign(k = 3, test.type = 1, n.fix = 800)
  local_edition(3)
  expect_error(gsPP(x = x, wgts = c(0.5, 0.5), i = 2, theta = c(0, 3),
                    r = 81, zi = 1, total = TRUE))
})



testthat::test_that(desc = "Test: class object gsProbability or gsDesign", code = {
  x <- seq(1, 2, 0.5)
  local_edition(3)
  expect_error(gsPP(x,wgts = c(0.4, 0.5, 0.2), i = 2,
                    theta = c(0.00, 0.05, 0.10), r = 18, zi = 1, total = TRUE))
})


# gsPP: total = FALSE.
testthat::test_that(desc = "Test: checking output Validation", code = {
  x <- gsDesign(k = 4, test.type = 2, n.fix = 800)
  zi <- 1
  theta <- c(0.00, 0.05, 0.10)
  i=2
  wgts = c(0.4,0.5,0.2)
  r <- 18
  total <- FALSE
  
  PP <- gsPP(x = x, wgts = c(0.4, 0.5, 0.2), i = 2,
             theta = c(0.00, 0.05, 0.10), r = 18, zi = 1, total = FALSE)

  expected_PP <- validate_gsPP(x, i, zi , theta , wgts , r , total = total)
  local_edition(3)
  expect_equal(PP[1],expected_PP[1])
  expect_equal(PP[2],expected_PP[2])
})

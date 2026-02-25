#------------
## gsCPOS
#------------

testthat::test_that(desc = "Test: checking class object gsDesign or gsProbability", 
                    code = {
  x <- seq(1, 2, 0.5)
  local_edition(3)
  expect_error(gsCPOS(x,i = 1, theta = c(-1.50, -0.75, 0.00, 0.75, 1.50),
    wgts = c(0.064758798, 0.301137432, 0.199471140, 0.301137432, 0.064758798)
  ))
})


testthat::test_that(desc = "Test: checking lengths of input", code = {
  x <- gsDesign(k = 3, test.type = 2, n.fix = 800)
  local_edition(3)
  expect_error(gsCPOS(x, i = 1, theta = c(-1.50, -0.75, 0.75, 1.50),
    wgts = c(0.064758798, 0.301137432, 0.199471140, 0.301137432, 0.064758798)
  ))
})



testthat::test_that(desc = "Test: checking out of range i ", code = {
  x <- gsDesign(k = 3, test.type = 1, n.fix = 800)
  local_edition(3)
  expect_error(gsCPOS(x, i = 4, theta = c(-1.50, -0.75, 0.75, 1.50),
    wgts = c(0.064758798, 0.01137432, 0.199471140, 0.301137432)
  ))
})


testthat::test_that(desc = "Test: output validation 
                    source: helper.R", code = {
  x <- gsDesign(k = 3, test.type = 2, n.fix = 800)
  theta = c(-1.50, -0.75, 0.00, 0.75, 1.50)
  wgts = c(0.064758798, 0.301137432, 0.199471140, 0.301137432, 0.064758798)
  i <- 2
  local_edition(3)
  
  CPOS <- gsCPOS(x, i = 2, theta = theta, wgts = wgts)
  expected_CPOS <- validate_gsCPOS(x, theta, wgts, i)
  expect_equal(CPOS , expected_CPOS[1])
})

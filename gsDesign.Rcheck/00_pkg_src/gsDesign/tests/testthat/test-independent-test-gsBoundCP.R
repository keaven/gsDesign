#---------------
##gsBoundCP
#--------------

# gsBoundCP: class(x) must be gsProbability or gsDesign.
testthat::test_that(desc = "Test: gsBoundCP checking of class x", code = {
  x = seq(1,2,0.5)
  local_edition(3)
  expect_error(gsBoundCP(x,theta = 3.241516, r = 18))
})

# checking for out of range for r.
testthat::test_that(desc = "Test: out of range r", code = {
  x = gsDesign(k =3, test.type=1, delta = 0.22)
  local_edition(3)
  expect_error(gsBoundCP(x,theta = "thetahat", r = 71))
})


testthat::test_that(desc = "Test: invalide data type", code = {
  x = gsDesign(k = 3, test.type = 2, n.fix = 800)
  local_edition(3)
  expect_error(gsBoundCP(x,theta ='a', r = 18))
})


testthat::test_that(desc = "Test: out of range theta", code = {
  x = gsDesign(k = 3, test.type = 2, n.fix = 800)
  local_edition(3)
  expect_error(gsBoundCP(x,theta = Inf, r = 18))
})


testthat::test_that(desc = "Test: output validation
                          source: helper.R", 
                    code = {
  x = gsDesign(k =3, test.type=1, delta = 0.22)
  local_edition(3)
  BCP <- gsBoundCP(x,theta = 0.22, r = 18)
  expected_BCP <- validate_gsBoundCP(x)
  expect_equal(BCP,expected_BCP)
})

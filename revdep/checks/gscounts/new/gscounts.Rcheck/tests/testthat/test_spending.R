context("Spending functions")


test_that("Pocock spending function matches gsdesign", 
          {expect_equal(pocock(t = c(0.4, 0.75, 1), sig_level = 0.05),
                        gsDesign::sfLDPocock(alpha = 0.05, t = c(0.4, 0.75, 1))$spend)})


test_that("OBF spending function matches gsdesign", 
          {expect_equal(obrien(t = c(0.1, 0.4, 0.75, 1), sig_level = 0.1),
                        gsDesign::sfLDOF(alpha = 0.1, t = c(0.1, 0.4, 0.75, 1))$spend)})

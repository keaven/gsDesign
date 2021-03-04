## Tested by creating equivalent designs in East 6.5 and with internal benchmarks
## (type II error, beta, should be 1 - power)

testthat::test_that("Testing nBinomial1Sample output, 
                    Source=East 6.5 output-One Sample Single Proportion design: nBin1S_01.html", {
  res1 <- gsDesign::nBinomial1Sample(
    p0 = 0.05, p1 = 0.2, alpha = 0.025, beta = NULL,
    n = 25, outtype = 1, conservative = FALSE
  )
  testthat::expect_equal(res1$Power, 0.57932569, info = "Checking for power")
  testthat::expect_equal((1 - 0.57932569), res1$beta, info = "Checking for beta")
})


testthat::test_that("Testing nBinomial1Sample output, 
                    Source=East 6.5 output-One Sample Single Proportion design: nBin1S_02.html", {
  res2 <- gsDesign::nBinomial1Sample(
    p0 = 0.05, p1 = 0.2, alpha = 0.025, beta = NULL,
    n = 28, outtype = 1, conservative = FALSE
  )
  testthat::expect_equal(res2$Power, 0.6851126, info = "Checking for power")
  testthat::expect_equal(1 - 0.6851126, res2$beta, info = "Checking for beta")
})


testthat::test_that("Testing nBinomial1Sample output, 
                    Source=East 6.5 output-One Sample Single Proportion design: nBin1S_03.html", {
  res3 <- gsDesign::nBinomial1Sample(
    p0 = 0.05, p1 = 0.2, alpha = 0.025, beta = NULL,
    n = 30, outtype = 1, conservative = FALSE
  )
  testthat::expect_equal(res3$Power, 0.74476675, info = "Checking for power")
  testthat::expect_equal(1 - 0.74476675, res3$beta, info = "Checking for beta")
})


testthat::test_that("Testing nBinomial1Sample output, 
                    Source=East 6.5 output-One Sample Single Proportion design: nBin1S_04.html", {
  res4 <- gsDesign::nBinomial1Sample(
    p0 = 0.05, p1 = 0.2, alpha = 0.025, beta = NULL,
    n = 33, outtype = 1, conservative = FALSE
  )
  testthat::expect_equal(res4$Power, 0.81787426, info = "Checking for power")
  testthat::expect_equal(1 - 0.81787426, res4$beta, info = "Checking for beta")
})


testthat::test_that("Testing nBinomial1Sample output, 
                    Source=East 6.5 output-One Sample Single Proportion design: nBin1S_05.html", {
  res5 <- gsDesign::nBinomial1Sample(
    p0 = 0.05, p1 = 0.2, alpha = 0.025, beta = NULL,
    n = 35, outtype = 1, conservative = FALSE
  )
  testthat::expect_equal(res5$Power, 0.72790831, info = "Checking for power")
  testthat::expect_equal(1 - 0.72790831, res5$beta, info = "Checking for beta")
})


testthat::test_that("Testing nBinomial1Sample output, 
                    Source=East 6.5 output-One Sample Single Proportion design: nBin1S_06.html", {
  res6 <- gsDesign::nBinomial1Sample(
    p0 = 0.05, p1 = 0.2, alpha = 0.01, beta = NULL,
    n = 33, outtype = 1, conservative = FALSE
  )
  testthat::expect_equal(res6$Power, 0.67097039, info = "Checking for power")
  testthat::expect_equal(1 - 0.67097039, res6$beta, info = "Checking for beta")
})


testthat::test_that("Testing nBinomial1Sample :testing sample size range", {
  testthat::expect_error(gsDesign::nBinomial1Sample(
    p0 = 0.05, p1 = 0.2,
    alpha = 0.025, beta = 0.2, n = 12, outtype = 1, conservative = FALSE
  ),
  info = "Error in gsDesign::nBinomial1Sample(p0 = 0.05, p1 = 0.2, alpha = 0.025,  
  : Input sample size insufficient to power trial"
  )
})

testthat::test_that("Testing nBinomial1Sample output, 
                    Source=East 6.5 output-One Sample Single Proportion design: nBin1S_08.html", {
  res8 <- gsDesign::nBinomial1Sample(
    p0 = 0.05, p1 = 0.2, alpha = 0.05, beta = NULL,
    n = 33, outtype = 1, conservative = FALSE
  )
  testthat::expect_equal(res8$Power, 0.81787426, info = "Checking for power")
  testthat::expect_equal(1 - 0.81787426, res8$beta, info = "Checking for beta")
})


testthat::test_that("Testing nBinomial1Sample output, 
                    Source=East 6.5 output-One Sample Single Proportion design: nBin1S_09.html", {
  res9 <- gsDesign::nBinomial1Sample(
    p0 = 0.05, p1 = 0.25, alpha = 0.025, beta = NULL,
    n = 33, outtype = 1, conservative = FALSE
  )
  testthat::expect_equal(res9$Power, 0.94139159, info = "Checking for power")
  testthat::expect_equal(1 - 0.94139159, res9$beta, info = "Checking for beta")
})


testthat::test_that("Testing nBinomial1Sample output, 
                    Source=East 6.5 output-One Sample Single Proportion design: nBin1S_10.html", {
  res10 <- gsDesign::nBinomial1Sample(
    p0 = 0.15, p1 = 0.35, alpha = 0.025, beta = NULL,
    n = 33, outtype = 1, conservative = FALSE
  )
  testthat::expect_equal(res10$Power, 0.77005342, info = "Checking for power")
  testthat::expect_equal((1 - 0.77005342), res10$beta, info = "Checking for beta")
})


testthat::test_that("Testing nBinomial1Sample :testing sample size range", {
  
  testthat::expect_error(gsDesign::nBinomial1Sample(
    p0 = 0.15, p1 = 0.35, alpha = 0.025,
    beta = 0.2, n = 33, outtype = 1, conservative = FALSE
  ),
  info = "Checking for sample size insufficient"
  )
})


testthat::test_that("Testing nBinomial1Sample :testing sample size range", {
  
  testthat::expect_error(gsDesign::nBinomial1Sample(
    p0 = 0.15, p1 = 0.35, alpha = 0.025,
    beta = 0.5, n = 33, outtype = 2, conservative = FALSE
  ),
  info = "Checking for sample size insufficient"
  )
})


testthat::test_that("Testing nBinomial1Sample :testing sample size range 
                    and outtype == 2", {
                      
  testthat::expect_error(gsDesign::nBinomial1Sample(
    p0 = 0.05, p1 = 0.2, alpha = 0.025,
    beta = .5, n = 25:40, outtype = 2, conservative = FALSE
  ), info = "Checking for outtype == 2")
  
  testthat::expect_equal(is.data.frame(gsDesign::nBinomial1Sample(
    p0 = 0.05, p1 = 0.2,
    alpha = 0.025, beta = .2, n = 25:40, outtype = 2, conservative = FALSE
  )), TRUE, info = "Checking for outtype == 2")
})

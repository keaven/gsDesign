context("Key features of 'design_gsnb' - no futility")

# Given accrual period and maximum follow-up assuming uniformal accrual
gscount_2looks <- design_gsnb(rate1 = 0.0875, rate2 = 0.125, dispersion = 5,
                              power = 0.8, timing = c(0.5, 1), esf = obrien,
                              ratio_H0 = 1, sig_level = 0.025, 
                              followup_max = 0.5, random_ratio = 1)
# Comparison: gsDesign
gdesign_2looks <- gsDesign::gsDesign(k = 2, timing = c(0.5, 1),
                                     delta = -log(0.0875/0.125),
                                     test.type = 1, 
                                     sfu = gsDesign::sfLDOF, 
                                     alpha = 0.025, 
                                     beta = 0.2)

test_that("critical values match gsdesign",
          {expect_equal(gscount_2looks$efficacy$critical, 
                        as.numeric(-gdesign_2looks$upper$bound), tolerance = 1e-6)})

test_that("efficacy spending matches gsdesign",
          {expect_equal(gscount_2looks$efficacy$spend, 
                        as.numeric(gdesign_2looks$upper$spend), tolerance = 1e-6)})

test_that("power is equal to 0.8",
          {expect_equal(1 - mvtnorm::pmvnorm(lower = gscount_2looks$efficacy$critical, 
                                             upper = c(Inf, Inf), 
                                             mean = log(0.0875/0.125) * sqrt(c(0.5, 1) * gscount_2looks$max_info),
                                             corr = matrix(sqrt(c(1, 0.5, 0.5, 1)), nrow = 2))[1],
                        0.8, tolerance = 1e-4)
          })
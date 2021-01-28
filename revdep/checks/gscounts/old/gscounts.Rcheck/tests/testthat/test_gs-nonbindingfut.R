context("Key features of 'design_gsnb' - nonbinding futility")

# Given accrual period and study duration assuming uniformal accrual
gscount_3looks <- design_gsnb(rate1 = 0.0875, rate2 = 0.125, dispersion = 5,
                              power = 0.85, timing = c(0.5, 0.75, 1), esf = obrien,
                              ratio_H0 = 1, sig_level = 0.025,
                              followup_max = 0.5, random_ratio = 1, 
                              futility = "nonbinding", 
                              esf_futility = pocock)

gdesign_3looks <- gsDesign::gsDesign(timing = c(0.5, 0.75, 1),
                                     delta = -log(0.0875/0.125),
                                     test.type = 4, 
                                     sfu = gsDesign::sfLDOF, 
                                     sfl = gsDesign::sfLDPocock,
                                     alpha = 0.025, 
                                     beta = 0.15)

test_that("Efficacy critical values match gsdesign",
          {expect_equal(gscount_3looks$efficacy$critical, 
                        as.numeric(-gdesign_3looks$upper$bound), tolerance = 1e-6)})

test_that("Nonbinding futility critical values match gsdesign",
          {expect_equal(gscount_3looks$futility$critical, 
                        as.numeric(-gdesign_3looks$lower$bound), tolerance = 1e-6)})

test_that("Efficacy spending matches gsdesign",
          {expect_equal(gscount_3looks$efficacy$spend, 
                        as.numeric(gdesign_3looks$upper$spend), tolerance = 1e-6)})

test_that("Nonbinding futility spending matches gsdesign",
          {expect_equal(gscount_3looks$futility$spend, 
                        as.numeric(gdesign_3looks$lower$spend), tolerance = 1e-6)})

# Power of nonbinding futility
p_nbf <- 1 - mvtnorm::pmvnorm(lower = gscount_3looks$futility$critical[1], 
                              upper = Inf, 
                              mean = log(0.0875/0.125) * sqrt(0.5 * gscount_3looks$max_info),
                              sigma = 1, abseps = 1e-15)[1] -
  mvtnorm::pmvnorm(lower = c(gscount_3looks$efficacy$critical[1], gscount_3looks$futility$critical[2]), 
                   upper = c(gscount_3looks$futility$critical[1], Inf), 
                   mean = log(0.0875/0.125) * sqrt(c(0.5, 0.75) * gscount_3looks$max_info),
                   corr = get_covar(c(0.5, 0.75)), abseps = 1e-5)[1] -
  mvtnorm::pmvnorm(lower = gscount_3looks$efficacy$critical, 
                   upper = c(gscount_3looks$futility$critical[1:2], Inf), 
                   mean = log(0.0875/0.125) * sqrt(c(0.5, 0.75, 1) * gscount_3looks$max_info),
                   corr = get_covar(c(0.5, 0.75, 1)), abseps = 1e-15)[1]
test_that("Power is equal to 0.85",
          {expect_equal(as.numeric(p_nbf), 0.85, tolerance = 1e-4)
          })


context("Key features of 'design_gsnb' - binding futility")

# Given accrual period and study duration assuming uniformal accrual
gscount_2looks <- design_gsnb(rate1 = 0.0875, rate2 = 0.125, dispersion = 5,
                              power = 0.8, timing = c(0.5, 1), esf = obrien,
                              ratio_H0 = 1, sig_level = 0.025, study_period = 3.5,
                              accrual_period = 1.25, random_ratio = 1, futility = "binding",
                              esf_futility = obrien)

gdesign_2looks <- gsDesign::gsDesign(k = 2, timing = c(0.5, 1),
                                     delta = -log(0.0875/0.125),
                                     test.type = 3,
                                     sfu = gsDesign::sfLDOF,
                                     sfl = gsDesign::sfLDOF,
                                     alpha = 0.025,
                                     beta = 0.2)

test_that("Efficacy critical values match gsdesign",
          {expect_equal(gscount_2looks$efficacy$critical,
                        as.numeric(-gdesign_2looks$upper$bound), tolerance = 1e-5)})

test_that("Nonbinding futility critical values match gsdesign",
          {expect_equal(gscount_2looks$futility$critical,
                        as.numeric(-gdesign_2looks$lower$bound), tolerance = 1e-5)})

test_that("Efficacy spending matches gsdesign",
          {expect_equal(gscount_2looks$efficacy$spend,
                        as.numeric(gdesign_2looks$upper$spend), tolerance = 1e-6)})

test_that("Nonbinding futility spending matches gsdesign",
          {expect_equal(gscount_2looks$futility$spend,
                        as.numeric(gdesign_2looks$lower$spend), tolerance = 1e-6)})

# Power of nonbinding futility
p_nbf <- 1 - mvtnorm::pmvnorm(lower = gscount_2looks$futility$critical[1],
                              upper = Inf,
                              mean = log(0.0875/0.125) * sqrt(0.5 * gscount_2looks$max_info),
                              sigma = 1, abseps = 1e-15)[1] -
  mvtnorm::pmvnorm(lower = gscount_2looks$efficacy$critical,
                   upper = c(gscount_2looks$futility$critical[1], Inf),
                   mean = log(0.0875/0.125) * sqrt(c(0.5, 1) * gscount_2looks$max_info),
                   corr = get_covar(c(0.5, 1)), abseps = 1e-5)[1]

test_that("Power is equal to 0.80",
          {expect_equal(as.numeric(p_nbf), 0.80, tolerance = 1e-4)
          })


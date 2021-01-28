context("Key features of 'design_gsnb' - fixed followup")

# Results from gsDesign as benchmark
gdesign_3looks <- gsDesign::gsDesign(k = 3, timing = c(0.33, 0.66, 1),
                                     delta = -log(1/2),
                                     test.type = 3,
                                     sfu = gsDesign::sfLDOF,
                                     sfl = gsDesign::sfLDPocock,
                                     alpha = 0.025,
                                     beta = 0.3)

gscounts_3looks <- design_gsnb(rate1 = 1, rate2 = 2, dispersion = 0.5, 
                    ratio_H0 = 1, power = 0.7, sig_level = 0.025, 
                    timing = c(0.33, 0.66, 1), 
                    esf = obrien, 
                    followup_max =  3, accrual_period = 1.25, 
                    random_ratio = 1, 
                    futility = "binding", 
                    esf_futility = pocock)

# Information at different looks
info_look <- numeric(3)
for(i in seq_along(info_look)) {
  info_look[i] <- get_info_gsnb(rate1 = 1, 
                              rate2 = 2, 
                              dispersion = 0.5, 
                              followup1 = pmin(pmax(gscounts_3looks$calendar[i] - gscounts_3looks$t_recruit1, 0), 3),
                              followup2 = pmin(pmax(gscounts_3looks$calendar[i] - gscounts_3looks$t_recruit2, 0), 3))
  
}


test_that("Efficacy critical values match gsDesign",
          {expect_equal(gscounts_3looks$efficacy$critical,
                        as.numeric(-gdesign_3looks$upper$bound), tolerance = 1e-5)})

test_that("Binding futility critical values match gsDesign",
          {expect_equal(gscounts_3looks$futility$critical,
                        as.numeric(-gdesign_3looks$lower$bound), tolerance = 1e-5)})

test_that("Efficacy spending matches gsDesign",
          {expect_equal(gscounts_3looks$efficacy$spend,
                        as.numeric(gdesign_3looks$upper$spend), tolerance = 1e-6)})

test_that("Binding futility spending matches gsDesign",
          {expect_equal(gscounts_3looks$futility$spend,
                        as.numeric(gdesign_3looks$lower$spend), tolerance = 1e-6)})

test_that("Information at first data look is 0.33",
          {expect_equal(info_look[1],
                        0.33*gscounts_3looks$max_info, tolerance = 1e-6)})

test_that("Information at second data look is 0.66",
          {expect_equal(info_look[2],
                        0.66*gscounts_3looks$max_info, tolerance = 1e-6)})

test_that("Information at last data look is 1",
          {expect_equal(info_look[3],
                        gscounts_3looks$max_info, tolerance = 1e-6)})


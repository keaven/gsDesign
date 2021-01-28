context("Recruitment speed for unequal follow-up times")

# Accrual over one year period; study ends after two years
design1 <- design_gsnb(rate1 = 1, rate2 = 1.5, dispersion = 3,
                   power = 0.8, timing = c(0.5, 0.75, 1), esf = pocock,
                   ratio_H0 = 1, sig_level = 0.025,
                   study_period = 2,
                   accrual_period = 1, 
                   random_ratio = 1)

# Accrual over one year period; study ends after two years
# Increased recruitment speed
design2 <- design_gsnb(rate1 = 1, rate2 = 1.5, dispersion = 3,
                       power = 0.8, 
                       timing = c(0.5, 0.75, 1),
                       esf = pocock,
                       ratio_H0 = 1, sig_level = 0.025,
                       study_period = 2,
                       accrual_period = 1,
                       accrual_speed = 2,
                       random_ratio = 1)
# Information of design2 at first data look
design2_info_l1 <- get_info_gsnb(rate1 = 1, 
                               rate2 = 1.5, 
                               dispersion = 3, 
                               followup1 = pmax(design2$calendar[1] - design2$t_recruit1, 0), 
                               followup2 = pmax(design2$calendar[1] - design2$t_recruit2, 0))



test_that("Maximum information is similar between designs with different recruitment speed",
          {expect_equal(design1$max_info, design2$max_info, tolerance = 0.01)
          })

test_that("Information at first look of design2 is half the maximum information",
          {expect_equal(design2_info_l1, design2$max_info*design2$timing[1], tolerance = 0.0001)
          })

test_that("Power of design with fast recruitment is approximately 80%",
          {expect_equal(design2$stop_prob$efficacy[2, "Total"], 0.8, tolerance = 0.001)})



context("Recruitment speed for equal follow-up times")


# Accrual over one year period; each subject has a follow-up time of 1.5 years
design3 <- design_gsnb(rate1 = 2, rate2 = 4, dispersion = 3,
                       power = 0.8, timing = c(0.5, 0.75, 1), esf = pocock,
                       ratio_H0 = 1, sig_level = 0.025,
                       accrual_period = 1, 
                       followup_max = 1.5,
                       random_ratio = 1)

# Accrual over one year period; each subject has a follow-up time of 1.5 years
# Increased recruitment speed
design4 <- design_gsnb(rate1 = 2, rate2 = 4, dispersion = 3,
                       power = 0.8, 
                       timing = c(0.5, 0.75, 1),
                       esf = pocock,
                       ratio_H0 = 1, sig_level = 0.025,
                       followup_max = 1.5,
                       accrual_period = 1,
                       accrual_speed = 2,
                       random_ratio = 1)

# Accrual over one year period; each subject has a follow-up time of 1.5 years
# Increased recruitment speed
design4 <- design_gsnb(rate1 = 2, rate2 = 4, dispersion = 3,
                       power = 0.8, 
                       timing = c(0.5, 0.75, 1),
                       esf = pocock,
                       ratio_H0 = 1, sig_level = 0.025,
                       followup_max = 1.5,
                       accrual_period = 1,
                       accrual_speed = 2,
                       random_ratio = 1)

# Information of design4 at first data look
design4_info_l1 <- get_info_gsnb(rate1 = 2, rate2 = 4, 
                                 dispersion = 3,
                                 followup1 = pmin(pmax(design4$calendar[1] - design4$t_recruit1, 0), 1.5), 
                                 followup2 = pmin(pmax(design4$calendar[1] - design4$t_recruit2, 0), 1.5))
design4_info_l2 <- get_info_gsnb(rate1 = 2, rate2 = 4, 
                                 dispersion = 3,
                                 followup1 = pmin(pmax(design4$calendar[2] - design4$t_recruit1, 0), 1.5), 
                                 followup2 = pmin(pmax(design4$calendar[2] - design4$t_recruit2, 0), 1.5))



test_that("Maximum information is similar between designs with different recruitment speed",
          {expect_equal(design3$max_info, design3$max_info, tolerance = 0.001)
          })

test_that("Information at first look of design2 is half the maximum information",
          {expect_equal(design4_info_l1, design4$max_info*design4$timing[1], tolerance = 0.0001)
          })

test_that("Information at first look of design4 is 3/4 of the maximum information",
          {expect_equal(design4_info_l2, design4$max_info*design4$timing[2], tolerance = 0.0001)
          })

test_that("Power of design with fast recruitment is approximately 80%",
          {expect_equal(design4$stop_prob$efficacy[2, "Total"], 0.8, tolerance = 0.001)})




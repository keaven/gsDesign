context("Futility and efficacy analyses are conducted at different times")


test_that("a warning is issued when both timing and timing_eff are specified",
          {expect_warning(design_gsnb(rate1 = 0.0875, rate2 = 0.125, dispersion = 5,
                                      power = 0.8, timing = c(0.5, 1), ratio_H0 = 1, 
                                      sig_level = 0.025, study_period = 3.5,
                                      accrual_period = 1.25, random_ratio = 1, 
                                      futility = "binding",
                                      esf_futility = obrien, 
                                      timing_eff = c(0.1)),
                          "Argument 'timing' is specified; 'timing_eff' and 'timing_fut' will be overwritten.")})

test_that("a warning is issued when both timing and timing_fut are specified",
          {expect_warning(design_gsnb(rate1 = 0.0875, rate2 = 0.125, dispersion = 5,
                                      power = 0.8, timing = c(0.5, 1), ratio_H0 = 1, 
                                      sig_level = 0.025, study_period = 3.5,
                                      accrual_period = 1.25, random_ratio = 1, 
                                      futility = "binding",
                                      esf_futility = obrien, 
                                      timing_fut = c(0.1)),
                          "Argument 'timing' is specified; 'timing_eff' and 'timing_fut' will be overwritten.")})


test_that("an error is returned when timing, timing_fut, and timing_eff are missing",
          {expect_error(design_gsnb(rate1 = 0.0875, rate2 = 0.125, dispersion = 5,
                                    power = 0.8, ratio_H0 = 1, 
                                    sig_level = 0.025, study_period = 3.5,
                                    accrual_period = 1.25, random_ratio = 1, 
                                    futility = "binding",
                                    esf_futility = obrien),
                        "Argument 'timing' is missing and 'timing_eff' or 'timing_fut' is missing, too.")})


# Group sequential designs with different timing for binding futility and efficacy testing
gs_bind <- design_gsnb(rate1 = 1, rate2 = 2, dispersion = 5,
                       power = 0.8, esf = obrien,
                       ratio_H0 = 1, sig_level = 0.025, study_period = 3.5,
                       accrual_period = 1.25, random_ratio = 1, futility = "binding",
                       esf_futility = pocock, 
                       timing_eff = c(0.8, 1), 
                       timing_fut = c(0.2, 0.5, 1))
# Critical values form East
east_fut <- c(0.224846, -0.789085, Inf, -1.930040)
east_eff <- c(-Inf, -Inf, -2.224821, -1.930040)

test_that("binding futility boundaries from design_gsnb match values from east",
          expect_equal(gs_bind$futility$critical, east_fut, tolerance = 1e-5))

test_that("binding futility boundaries from design_gsnb match values from east",
          expect_equal(gs_bind$efficacy$critical, east_eff, tolerance = 1e-5))



# Group sequential designs with different timing for nonbinding futility and efficacy testing
gs_nonbind <- design_gsnb(rate1 = 1, rate2 = 2, dispersion = 5,
                       power = 0.9, esf = obrien,
                       ratio_H0 = 1, sig_level = 0.025, study_period = 3.5,
                       accrual_period = 1.25, random_ratio = 1, futility = "nonbinding",
                       esf_futility = obrien, 
                       timing_eff = c(0.75, 1), 
                       timing_fut = c(0.3, 0.6, 1))
# Critical values form East
east_eff <- c(-Inf, -Inf, -2.3397113, -2.0117769)
east_fut <- c(0.9637902, -0.7357626, Inf, -2.01177687)

test_that("nonbinding futility boundaries from design_gsnb match values from east",
          expect_equal(gs_nonbind$futility$critical, east_fut, tolerance = 1e-5))

test_that("nonbinding futility boundaries from design_gsnb match values from east",
          expect_equal(gs_nonbind$efficacy$critical, east_eff, tolerance = 1e-5))


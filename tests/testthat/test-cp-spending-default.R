test_that("CP calibration inherits spending and permits explicit overrides", {
  for (spec in list(
    list(sf = sfPower, par = 2, timing = c(.5, .75), i = 1),
    list(sf = sfCauchy, par = c(0, 1), timing = c(.4, .75), i = 1:2),
    list(sf = sfLinear, par = c(.3, .5, .7, .05, .2, .5),
         timing = c(.3, .5, .7), i = 1:3)
  )) {
    x <- gsDesign(k = length(spec$timing) + 1, test.type = 4,
      timing = spec$timing, sfl = spec$sf, sflpar = spec$par)
    target <- gsBoundCP(x, theta = "thetahat")[spec$i, 1]
    fit <- gsCPFutilitySpending(x, target, i = spec$i)
    explicit <- gsCPFutilitySpending(x, target, i = spec$i, sfl = spec$sf)
    expect_identical(fit$lower$sf, spec$sf)
    expect_equal(fit$lower$param, explicit$lower$param)
    expect_equal(unname(fit$cpFutilitySpending$achieved_cp), unname(target), tolerance = 1e-4)
  }
  x <- gsDesign(k = 3, test.type = 4, timing = c(.5, .75), sfl = sfPower, sflpar = 2)
  fit <- gsCPFutilitySpending(x, .2, i = 1, sfl = "sfHSD")
  expect_identical(fit$lower$sf, sfHSD)
  expect_equal(fit$cpFutilitySpending$achieved_cp, .2, tolerance = 1e-4)
  expect_error(gsCPFutilitySpending(1, .2), class = "gsCPFutilitySpending_input_error")
})

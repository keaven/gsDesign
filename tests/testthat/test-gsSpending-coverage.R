test_that("two-parameter spending functions return spendfn objects", {
  t <- seq(0, 1, length.out = 5)
  funcs <- list(sfLogistic, sfNormal, sfExtremeValue, sfExtremeValue2, sfCauchy, sfBetaDist)
  params <- list(c(0, 1), c(0, 1), c(0, 1), c(0, 1), c(0, 1), c(1, 1))
  for (i in seq_along(funcs)) {
    x <- funcs[[i]](0.025, t, params[[i]])
    expect_s3_class(x, "spendfn")
    expect_equal(length(x$spend), length(t))
  }
})

test_that("four-parameter spending functions are supported", {
  t <- seq(0, 1, length.out = 5)
  param4 <- c(0.1, 0.5, 0.01, 0.1)
  funcs <- list(sfLogistic, sfNormal, sfExtremeValue, sfExtremeValue2, sfCauchy)
  for (f in funcs) {
    x <- f(0.025, t, param4)
    expect_s3_class(x, "spendfn")
  }
})

test_that("one-parameter spending functions return expected structure", {
  t <- seq(0, 1, length.out = 5)
  x <- sfPower(0.025, t, 2)
  expect_s3_class(x, "spendfn")
  x <- sfHSD(0.025, t, -4)
  expect_s3_class(x, "spendfn")
  x <- sfLinear(0.025, t, c(0.3, 0.7, 0.1, 0.5))
  expect_s3_class(x, "spendfn")
  x <- sfStep(0.025, t, c(0.3, 0.7, 0.1, 0.5))
  expect_s3_class(x, "spendfn")
  x <- sfPoints(0.025, t, c(0.1, 0.3, 0.6, 0.9))
  expect_s3_class(x, "spendfn")
})

test_that("other spending helpers execute", {
  t <- seq(0, 1, length.out = 5)
  trimmed_param <- list(trange = c(0.2, 0.7), sf = sfHSD, param = -4)
  x <- sfTrimmed(0.025, t, trimmed_param)
  expect_s3_class(x, "spendfn")
  truncated_param <- list(trange = c(0.2, 0.7), sf = sfHSD, param = -4)
  x <- sfTruncated(0.025, t, truncated_param)
  expect_s3_class(x, "spendfn")
  gapped_param <- list(trange = c(0.2, 0.7), sf = sfHSD, param = -4)
  x <- sfGapped(0.025, t, gapped_param)
  expect_s3_class(x, "spendfn")
})

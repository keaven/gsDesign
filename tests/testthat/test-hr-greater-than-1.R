# Tests for hazard ratio > 1 support (#251)

test_that("nEvents: hr > hr0 gives same sample size as reciprocal hr < hr0", {
  n_low <- nEvents(hr = 0.6, hr0 = 1)
  n_high <- nEvents(hr = 1 / 0.6, hr0 = 1)
  expect_equal(ceiling(n_low), ceiling(n_high))
})

test_that("nEvents: power calculation works for hr > hr0", {
  # Fixed n, compute power
  pwr <- nEvents(hr = 1.5, hr0 = 1, n = 200)
  expect_true(pwr > 0 && pwr < 1)
  # Power should match reciprocal direction
  pwr_recip <- nEvents(hr = 1 / 1.5, hr0 = 1, n = 200)
  expect_equal(pwr, pwr_recip, tolerance = 1e-10)
})

test_that("nEvents: tbl output works for hr > hr0", {
  res <- nEvents(hr = 1.5, hr0 = 1, tbl = TRUE)
  expect_s3_class(res, "data.frame")
  expect_true(res$Power > 0.8)
  expect_true(res$n > 0)
})

test_that("nEvents: hr > hr0 with non-unity null", {
  # hr0 = 0.8, hr = 1.2 (experimental has higher hazard than null)
  n <- nEvents(hr = 1.2, hr0 = 0.8)
  expect_true(is.finite(n) && n > 0)
})

test_that("gsSurv: hr > hr0 produces valid design", {
  x <- gsSurv(
    k = 3, test.type = 4, hr = 1.5, hr0 = 1,
    lambdaC = log(2) / 12, gamma = 1, R = 12, T = 36, minfup = 12
  )
  expect_s3_class(x, "gsSurv")
  expect_true(max(x$n.I) > 0)
  expect_equal(x$hr, 1.5)
  expect_equal(x$hr0, 1)
})

test_that("gsSurv: hr > hr0 gives same events as reciprocal", {
  x_high <- gsSurv(
    k = 3, test.type = 4, hr = 1.5, hr0 = 1,
    lambdaC = log(2) / 12, gamma = 1, R = 12, T = 36, minfup = 12
  )
  x_low <- gsSurv(
    k = 3, test.type = 4, hr = 1 / 1.5, hr0 = 1,
    lambdaC = log(2) / 12, gamma = 1, R = 12, T = 36, minfup = 12
  )
  expect_equal(ceiling(max(x_high$n.I)), ceiling(max(x_low$n.I)))
})

test_that("gsHR: efficacy HR > hr0 when hr > hr0", {
  x <- gsSurv(
    k = 3, test.type = 4, hr = 1.5, hr0 = 1,
    lambdaC = log(2) / 12, gamma = 1, R = 12, T = 36, minfup = 12
  )
  hr_eff <- gsHR(z = x$upper$bound, i = 1:3, x = x)
  expect_true(all(hr_eff > 1))
})

test_that("gsHR: efficacy HR < hr0 when hr < hr0 (backward compat)", {
  x <- gsSurv(
    k = 3, test.type = 4, hr = 0.6, hr0 = 1,
    lambdaC = log(2) / 12, gamma = 1, R = 12, T = 36, minfup = 12
  )
  hr_eff <- gsHR(z = x$upper$bound, i = 1:3, x = x)
  expect_true(all(hr_eff < 1))
})

test_that("gsBoundSummary: works for hr > hr0", {
  x <- gsSurv(
    k = 2, test.type = 4, hr = 1.5, hr0 = 1,
    lambdaC = log(2) / 12, gamma = 1, R = 12, T = 36, minfup = 12
  )
  tbl <- gsBoundSummary(x, deltaname = "HR", logdelta = TRUE, Nname = "Events")
  expect_true(nrow(tbl) > 0)
  # Check that ~HR at bound rows show HR > 1 for efficacy
  hr_rows <- grepl("~HR at bound", tbl$Value)
  if (any(hr_rows)) {
    hr_vals <- as.numeric(tbl$Efficacy[hr_rows])
    expect_true(all(hr_vals > 1))
  }
})

test_that("gsSurvCalendar: hr > hr0 produces valid design", {
  x <- gsSurvCalendar(
    calendarTime = c(12, 24, 36),
    hr = 1.5, hr0 = 1,
    lambdaC = log(2) / 12, gamma = 1, R = 12, minfup = 12
  )
  expect_s3_class(x, "gsSurv")
  expect_true(max(x$n.I) > 0)
  expect_equal(x$hr, 1.5)
})

test_that("hrn2z and zn2hr: round-trip for hr1 > hr0", {
  z <- hrn2z(hr = 1.3, n = 200, hr0 = 1, hr1 = 1.5)
  hr_back <- zn2hr(z = z, n = 200, hr0 = 1, hr1 = 1.5)
  expect_equal(hr_back, 1.3, tolerance = 1e-10)
})

test_that("hrz2n: works for hr > hr0", {
  n <- hrz2n(hr = 1.3, z = 2, hr0 = 1)
  expect_true(is.finite(n) && n > 0)
})

test_that("nSurv: hr > hr0 gives positive events", {
  x <- nSurv(
    lambdaC = log(2) / 12, hr = 1.5, hr0 = 1,
    T = 36, minfup = 12
  )
  expect_true(x$d > 0)
})

test_that("nSurv: hr > hr0 events similar to reciprocal", {
  x1 <- nSurv(lambdaC = log(2) / 12, hr = 1.5, hr0 = 1, T = 36, minfup = 12)
  x2 <- nSurv(lambdaC = log(2) / 12, hr = 1 / 1.5, hr0 = 1, T = 36, minfup = 12)
  # Events should be similar (not exactly equal due to Lachin-Foulkes asymmetry)
  expect_equal(x1$d, x2$d, tolerance = 0.05)
})

test_that("plot.gsDesign: no error for gsSurv with hr > hr0", {
  x <- gsSurv(
    k = 3, test.type = 4, hr = 1.5, hr0 = 1,
    lambdaC = log(2) / 12, gamma = 1, R = 12, T = 36, minfup = 12
  )
  expect_no_error(plot(x, plottype = 1))
  expect_no_error(plot(x, plottype = 2))
  expect_no_error(plot(x, plottype = 3))
  expect_no_error(plot(x, plottype = 4))
  expect_no_error(plot(x, plottype = 5))
  expect_no_error(plot(x, plottype = 6))
})

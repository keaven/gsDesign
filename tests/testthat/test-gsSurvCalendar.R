test_that("gsSurvCalendar basic functionality works", {
  # Test default parameters
  x <- gsSurvCalendar()
  expect_s3_class(x, c("gsSurv", "gsDesign"))
  expect_equal(x$k, 3)  # Default number of analyses
  expect_equal(x$test.type, 4)  # Default test type
  
  # Test calendar time input validation
  expect_error(
    gsSurvCalendar(calendarTime = c(24, 12, 36)),
    "calendarTime must be an increasing vector"
  )
  
  # Test spending type options
  x_info <- gsSurvCalendar(spending = "information")
  x_cal <- gsSurvCalendar(spending = "calendar")
  expect_false(identical(x_info$n.I, x_cal$n.I))
  
  # Test minimum follow-up validation
  expect_error(
    gsSurvCalendar(calendarTime = c(12, 24), minfup = 25),
    "Minimum follow-up greater than study duration."
  )
})

test_that("gsSurvCalendar matches gsSurv under specific conditions", {
  # Create comparable designs
  cal_design <- gsSurvCalendar(
    test.type = 4,
    calendarTime = c(12, 24, 36),
    spending = "information",
    minfup = 6
  )
  
  # Get event counts for timing
  nevents <- sapply(cal_design$T, function(x) {
    xx <- nEventsIA(tIA = x, x = cal_design, simple = FALSE)
    sum(xx$eDC) + sum(xx$eDE)
  })
  timing <- nevents / max(nevents)
  
  # Create matching gsSurv design
  surv_design <- gsSurv(
    k = 3,
    test.type = 4,
    timing = timing,
    T = max(cal_design$T),
    minfup = 6
  )
  
  # Compare key outputs
  expect_equal(cal_design$n.I, surv_design$n.I, tolerance = 1e-4)
  expect_equal(cal_design$lower$bound, surv_design$lower$bound, tolerance = 1e-4)
  expect_equal(cal_design$upper$bound, surv_design$upper$bound, tolerance = 1e-4)
})

test_that("gsSurvCalendar handles different spending functions", {
  # Test with O'Brien-Fleming spending
  x_of <- gsSurvCalendar(
    sfu = gsDesign::sfLDOF,
    sfl = gsDesign::sfLDOF,
    calendarTime = c(12, 24, 36),
    spending = "information"
  )
  expect_s3_class(x_of, c("gsSurv", "gsDesign"))
  
  # Test with Pocock spending
  x_pocock <- gsSurvCalendar(
    sfu = gsDesign::sfLDPocock,
    sfl = gsDesign::sfLDPocock,
    calendarTime = c(12, 24, 36),
    spending = "information"
  )
  # Do Pocock spending with calendar time
  x_pocock_cal <- gsSurvCalendar(
    sfu = gsDesign::sfLDPocock,
    sfl = gsDesign::sfLDPocock,
    calendarTime = c(12, 24, 36),
    spending = "calendar"
  )
  expect_s3_class(x_pocock_cal, c("gsSurv", "gsDesign"))
  
  # Verify different spending functions produce different bounds
  expect_false(identical(x_of$upper$bound, x_pocock$upper$bound))
  expect_false(identical(x_pocock$upper$bound, x_pocock_cal$upper$bound))
  # Verify cumulative spending matches spending function for information spending
  expect_equal(
    cumsum(x_pocock$upper$spend), 
    gsDesign::sfLDPocock(
      alpha = x_pocock$alpha, 
      t = x_pocock$upper$sTime
    )$spend,
    tolerance = 1e-4
  )
  # Verify cumulative spending matches spending function for calendar time
  expect_equal(
    cumsum(x_pocock_cal$upper$spend), 
    gsDesign::sfLDPocock(
      alpha = x_pocock_cal$alpha, 
      t = x_pocock_cal$upper$sTime
    )$spend,
    tolerance = 1e-4
  )
  # Verify spending time is proportion of full T
  expect_equal(x_pocock_cal$upper$sTime, x_pocock_cal$T/max(x_pocock_cal$T))
})

test_that("gsSurvCalendar output structure is correct", {
  x <- gsSurvCalendar()
  
  # Check essential components
  expected_names <- c("k", "test.type", "alpha", "beta", "astar",
                      "delta", "n.fix", "timing", "tol", "r",
                      "n.I", "maxn.IPlan", "nFixSurv", "nSurv", "endpoint",
                      "delta1", "delta0", "overrun", "usTime", "lsTime",
                      "upper", "lower", "theta", "falseposnb", "en",
                      "hr", "hr0", "R", "minfup", "gamma",
                      "eDC", "eDE", "eNC", "eNE", "ratio",
                      "lambdaC", "etaC", "etaE", "variable", "T")
  
  expect_true(all(expected_names %in% names(x)))
  
  # Check dimensions of key components
  expect_equal(length(x$n.I), x$k)
  expect_equal(length(x$upper$bound), x$k)
  expect_equal(length(x$lower$bound), x$k)
  
  # Check class attributes
  expect_true(inherits(x$upper, "spendfn"))
  expect_true(inherits(x$lower, "spendfn"))
}) 

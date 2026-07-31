test_that("gsSurv k=1 uses fixed nSurv sizing", {
  args <- list(
    lambdaC = log(2) / 8,
    hr = 0.7,
    eta = 0.01,
    gamma = 12,
    R = 10,
    T = 22,
    minfup = 12,
    ratio = 1.5,
    alpha = 0.025,
    beta = 0.1
  )

  fixed <- do.call(nSurv, args)
  design <- do.call(gsSurv, c(list(k = 1, sfu = sfPower, sfupar = 3), args))

  expect_s3_class(design, "gsSurv")
  expect_s3_class(design, "gsDesign")
  expect_equal(design$k, 1)
  expect_equal(design$test.type, 1)
  expect_equal(design$n.I, fixed$d)
  expect_equal(design$n.fix, fixed$d)
  expect_equal(design$beta, fixed$beta)
  expect_equal(design$upper$spend, args$alpha)
  expect_equal(design$upper$prob[1, ], c(0.025, fixed$power))
  expect_null(design$lower)
  expect_equal(dim(design$eDC), c(1, ncol(fixed$lambdaC)))
  expect_match(summary(design), "fixed design with 1 analysis")
  expect_false(grepl("spending function", summary(design), fixed = TRUE))
})

test_that("gsSurv k=1 supports fixed power calculations", {
  args <- list(
    lambdaC = log(2) / 8,
    hr = 0.7,
    gamma = 12,
    R = 10,
    T = 22,
    minfup = 12,
    beta = NULL
  )

  fixed <- do.call(nSurv, args)
  design <- do.call(gsSurv, c(list(k = 1), args))

  expect_equal(design$power, fixed$power)
  expect_equal(design$beta, 1 - fixed$power)
  expect_equal(design$n.I, fixed$d)
})

test_that("gsSurvPower k=1 agrees with nSurv fixed power", {
  power_design <- gsSurvPower(
    k = 1,
    lambdaC = log(2) / 8,
    hr = 0.7,
    eta = 0.01,
    gamma = 12,
    R = 10,
    ratio = 1.5,
    plannedCalendarTime = 22,
    minfup = 12
  )
  fixed <- nSurv(
    lambdaC = log(2) / 8,
    hr = 0.7,
    eta = 0.01,
    gamma = 12,
    R = 10,
    T = 22,
    minfup = 12,
    ratio = 1.5,
    beta = NULL
  )

  expect_s3_class(power_design, "gsSurv")
  expect_equal(power_design$test.type, 1)
  expect_equal(power_design$n.I, fixed$d)
  expect_equal(power_design$power, fixed$power)
  expect_equal(power_design$beta, 1 - fixed$power)
  expect_null(power_design$lower)
  expect_false(power_design$testLower)
})

test_that("gsSurvPower k=1 has usable defaults", {
  design <- gsSurvPower(k = 1, plannedCalendarTime = 18)

  expect_s3_class(design, "gsSurv")
  expect_equal(unname(design$gamma), matrix(1))
  expect_equal(design$minfup, 6)
  expect_true(design$power > 0 && design$power < 1)
})

test_that("toInteger supports single-analysis survival designs", {
  designs <- list(
    gsSurv(k = 1),
    gsSurvPower(k = 1, gamma = 10, R = 12, plannedCalendarTime = 18)
  )

  for (design in designs) {
    integer_design <- toInteger(design)

    expect_s3_class(integer_design, "gsSurv")
    expect_equal(integer_design$k, 1)
    expect_equal(integer_design$test.type, 1)
    expect_equal(integer_design$n.I, round(integer_design$n.I))
    expect_true(integer_design$n.I >= round(design$n.I))
    expect_equal(nrow(integer_design$eDC), 1)
    expect_true(inherits(gsBoundSummary(integer_design), "gsBoundSummary"))
  }
})

test_that("gsBoundSummary omits interim-only rows for k=1", {
  design <- gsSurv(k = 1)

  summary_default <- gsBoundSummary(design)
  summary_full <- gsBoundSummary(design, exclude = NULL)
  summary_alpha <- gsBoundSummary(design, alpha = c(0.01, 0.05))
  summary_pos <- gsBoundSummary(design, POS = TRUE)

  expect_s3_class(summary_default, "gsBoundSummary")
  expect_s3_class(summary_pos, "gsBoundSummary")
  expect_true(any(grepl("Trial POS:", summary_pos$Analysis, fixed = TRUE)))
  expect_false(any(c("CP", "CP H1", "PP") %in% summary_full$Value))
  expect_equal(
    names(summary_alpha),
    c("Analysis", "Value", "\u03b1=0.025", "\u03b1=0.01", "\u03b1=0.05")
  )
  expect_equal(
    unname(as.numeric(summary_alpha[summary_alpha$Value == "Z", 3:5])),
    qnorm(1 - c(0.025, 0.01, 0.05)),
    tolerance = 1e-4
  )
})

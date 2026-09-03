ve_design <- function() {
  tte <- gsSurv(
    k = 2,
    test.type = 4,
    alpha = .025,
    beta = .1,
    timing = .6,
    sfu = sfHSD,
    sfupar = -3,
    sfl = sfHSD,
    sflpar = -3,
    lambdaC = .002,
    eta = .0001,
    gamma = 10,
    R = 8,
    T = 24,
    minfup = 16,
    hr = .3,
    hr0 = .7,
    ratio = 3
  )
  list(tte = tte, exact = toBinomialExact(tte))
}

test_that("VEtable summarizes planned vaccine efficacy designs", {
  design <- ve_design()
  result <- VEtable(design$exact, ve = c(.5, .7), tteDesign = design$tte)

  expect_s3_class(result, "gsVETable")
  expect_s3_class(result, "tbl_df")
  expect_s3_class(design$exact, "gsBinomialExactSpending")
  expect_named(result, c(
    "Analysis", "Time", "N", "Cases", "Success", "Futility",
    "ve_efficacy", "ve_futility", "alpha", "beta", "50%", "70%"
  ))
  expect_equal(result$Analysis, seq_len(design$exact$k))
  expect_equal(result$Time, design$tte$T)
  expect_equal(result$Cases, design$exact$n.I)
  expect_equal(tail(result$alpha, 1), sum(gsBinomialExact(
    k = design$exact$k,
    theta = design$exact$theta[1],
    n.I = design$exact$n.I,
    a = design$exact$lower$bound,
    b = design$exact$n.I + 1
  )$lower$prob))
  expect_true(all(diff(result$`70%`) >= 0))
  expect_equal(attr(result, "ve"), c(.5, .7))
  expect_equal(attr(result, "alpha"), design$exact$alpha)
})

test_that("VEtable supports observed-event tables without timing columns", {
  design <- ve_design()
  updated <- toBinomialExact(design$tte, observedEvents = c(20, 78))
  result <- VEtable(updated, ve = .7)

  expect_false(any(c("Time", "N") %in% names(result)))
  expect_named(result, c(
    "Analysis", "Cases", "Success", "Futility", "ve_efficacy",
    "ve_futility", "alpha", "beta", "70%"
  ))
  expect_equal(updated$ratio, design$tte$ratio)
})

test_that("lt formats VE tables with standard annotations", {
  design <- ve_design()
  result <- VEtable(design$exact, ve = c(.5, .7), tteDesign = design$tte) |>
    lt(efficacy_label = "PE")

  expect_s3_class(result, "lt_tbl")
  expect_equal(result$header$title, "Design Bounds and Operating Characteristics")
  expect_equal(
    vapply(result$spanners, `[[`, character(1), "label"),
    c(
      "Experimental Cases at Bound",
      "Power by Prevention Efficacy",
      "Error Spending",
      "Prevention Efficacy at Bound"
    )
  )
  expect_equal(length(result$footnotes), 5)
  expect_match(result$footnotes[[5]]$text, "final value < 0.025 due to discreteness")
  expect_true(any(vapply(
    result$ops,
    function(op) identical(op$type, "fmt_number") && "Time" %in% op$columns,
    logical(1)
  )))
})

test_that("lt formats observed-event VE tables without requiring timing", {
  design <- ve_design()
  updated <- toBinomialExact(design$tte, observedEvents = c(20, 78))
  result <- VEtable(updated, ve = .7) |>
    lt(title = "Updated design")

  expect_equal(result$header$title, "Updated design")
  expect_false(any(vapply(
    result$ops,
    function(op) identical(op$type, "fmt_number") && "Time" %in% op$columns,
    logical(1)
  )))
})

test_that("VEtable validates inputs", {
  design <- ve_design()

  expect_error(VEtable(list(), .7), "class gsBinomialExact")
  expect_error(VEtable(design$exact, c(.7, .7)), "unique finite values")
  expect_error(VEtable(design$exact, 1), "strictly between 0 and 1")
  expect_error(VEtable(design$exact, .7, tteDesign = list()), "class gsSurv")
  expect_error(
    VEtable(design$exact, .7, tteDesign = gsSurv(k = 3)),
    "same number of analyses"
  )

  no_ratio <- design$exact
  no_ratio$ratio <- NULL
  expect_error(VEtable(no_ratio, .7), "ratio must be a finite positive scalar")
  expect_s3_class(VEtable(no_ratio, .7, ratio = 3), "tbl_df")
})

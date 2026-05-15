surv_design_exact_p <- function(test.type = 4) {
  gsSurv(
    k = 3,
    test.type = test.type,
    alpha = 0.025,
    beta = 0.1,
    timing = c(0.45, 0.7),
    sfu = sfHSD,
    sfupar = -4,
    sfl = sfLDOF,
    sflpar = 0,
    lambdaC = 0.001,
    hr = 0.3,
    hr0 = 0.7,
    eta = 5e-04,
    gamma = 10,
    R = 16,
    T = 24,
    minfup = 8,
    ratio = 3
  )
}

test_that("binomialExactLowerBound validates inputs", {
  design <- surv_design_exact_p()

  expect_error(
    gsDesign:::binomialExactLowerBound(list(), c(10, 20), 0.025),
    "class gsSurv"
  )

  bad_design <- design
  bad_design$test.type <- 2
  expect_error(
    gsDesign:::binomialExactLowerBound(bad_design, c(10, 20), 0.025),
    "test.type must be 1 or 4"
  )

  expect_error(
    gsDesign:::binomialExactLowerBound(design, c(10.5, 20), 0.025),
    "increasing positive integers"
  )
  expect_error(
    gsDesign:::binomialExactLowerBound(design, c(10, 10), 0.025),
    "increasing vector of positive integers"
  )
  expect_error(
    gsDesign:::binomialExactLowerBound(design, c(10, 20), 1),
    "strictly between 0 and 1"
  )
  expect_error(
    gsDesign:::binomialExactLowerBound(design, c(10, 20), 0.025, fullSpendFinal = c(TRUE, FALSE)),
    "TRUE or FALSE"
  )
  expect_error(
    gsDesign:::binomialExactLowerBound(
      design, c(10, 20), 0.025, spendingTime = c(0.5)
    ),
    "same length as n.I"
  )
  expect_error(
    gsDesign:::binomialExactLowerBound(
      design, c(10, 20), 0.025, spendingTime = c(0.6, 0.4)
    ),
    "strictly increasing and positive"
  )
  planned_final <- if (!is.null(design$maxn.IPlan)) design$maxn.IPlan else max(design$n.I)
  if (!is.finite(planned_final) || planned_final <= 0) planned_final <- max(design$n.I)
  expect_error(
    gsDesign:::binomialExactLowerBound(design, c(ceiling(planned_final), ceiling(planned_final) + 1), 0.025),
    "at most 1 value >= planned final events"
  )
})

test_that("repeatedPValueBinomialExact validates inputs", {
  design <- surv_design_exact_p()
  counts <- toBinomialExact(design)$n.I

  expect_error(
    repeatedPValueBinomialExact(gsD = list(), n.I = counts, x = c(1, 2, 3)),
    "class gsSurv"
  )

  bad_design <- design
  bad_design$test.type <- 2
  expect_error(
    repeatedPValueBinomialExact(gsD = bad_design, n.I = counts, x = c(1, 2, 3)),
    "test.type must be 1 or 4"
  )

  expect_error(
    repeatedPValueBinomialExact(gsD = design, n.I = counts, x = NULL),
    "x must contain observed experimental-arm event counts"
  )
  expect_error(
    repeatedPValueBinomialExact(gsD = design, n.I = counts, x = c(1.5, 2, 3)),
    "non-negative integers"
  )
  expect_error(
    repeatedPValueBinomialExact(gsD = design, n.I = counts, x = c(-1, 2, 3)),
    "non-negative"
  )

  expect_error(
    repeatedPValueBinomialExact(gsD = design, n.I = c(20, 55), x = c(1, 2, 3)),
    "same length"
  )
  expect_error(
    repeatedPValueBinomialExact(gsD = design, n.I = c(20, 20, 55), x = c(1, 2, 3)),
    "increasing vector of positive integers"
  )
  expect_error(
    repeatedPValueBinomialExact(gsD = design, n.I = counts, x = counts + 1L),
    "x cannot exceed n.I"
  )

  expect_error(
    repeatedPValueBinomialExact(gsD = design, n.I = counts, x = c(1, 2, 3), interval = c(0, 0.9)),
    "strictly between 0 and 1"
  )
  expect_error(
    repeatedPValueBinomialExact(gsD = design, n.I = counts, x = c(1, 2, 3), tol = 0),
    "positive scalar"
  )
  expect_error(
    repeatedPValueBinomialExact(gsD = design, n.I = counts, x = c(1, 2, 3), maxiter = 1.5),
    "positive integer"
  )
  planned_final <- if (!is.null(design$maxn.IPlan)) design$maxn.IPlan else max(design$n.I)
  if (!is.finite(planned_final) || planned_final <= 0) planned_final <- max(design$n.I)
  n_over <- c(ceiling(planned_final), ceiling(planned_final) + 1, ceiling(planned_final) + 2)
  expect_error(
    repeatedPValueBinomialExact(gsD = design, n.I = n_over, x = c(1, 2, 3)),
    "at most 1 value >= planned final events"
  )
})

test_that("repeated and sequential exact p-values are coherent", {
  design <- surv_design_exact_p()
  counts <- toBinomialExact(design)$n.I
  bound_at_design_alpha <- gsDesign:::binomialExactLowerBound(
    gsD = design,
    n.I = counts,
    alpha = design$alpha
  )

  repeated_at_bound <- repeatedPValueBinomialExact(
    gsD = design,
    n.I = counts,
    x = bound_at_design_alpha,
    check = TRUE
  )

  expect_equal(repeated_at_bound$n.I, counts)
  expect_equal(repeated_at_bound$x, bound_at_design_alpha)
  expect_true(all(repeated_at_bound$repeated_p_value <= design$alpha * (1 + 1e-6)))
  expect_true(all(repeated_at_bound$bound_at_repeated_p_value >= repeated_at_bound$x))

  harder_counts <- pmin(counts, bound_at_design_alpha + 1L)
  repeated_harder <- repeatedPValueBinomialExact(gsD = design, n.I = counts, x = harder_counts)
  expect_true(all(repeated_harder$repeated_p_value >= repeated_at_bound$repeated_p_value))

  repeated_default_ni <- repeatedPValueBinomialExact(gsD = design, x = bound_at_design_alpha)
  expect_equal(repeated_default_ni$n.I, counts)

  seq_p <- sequentialPValueBinomialExact(gsD = design, n.I = counts, x = harder_counts)
  expect_equal(seq_p, min(repeated_harder$repeated_p_value))
})

exact_cp_design <- function(test.type = 4) {
  gsSurv(
    k = 2, test.type = test.type, alpha = .025, beta = .1, timing = .5,
    sfu = sfHSD, sfupar = -3, sfl = sfHSD, sflpar = -3,
    ratio = 3, hr = .3, hr0 = .7
  ) |>
    toBinomialExact()
}

test_that("exact conditional power agrees with a direct one-look calculation", {
  design <- exact_cp_design()
  i <- 1
  observed <- design$lower$bound[i] + 1L
  p <- .3
  result <- gsCPBinomialExact(design, i = i, x.i = observed, theta = p)
  increment <- design$n.I[2] - design$n.I[1]

  expected_efficacy <- stats::pbinom(design$lower$bound[2] - observed, increment, p)
  expected_futility <- stats::pbinom(
    design$upper$bound[2] - observed - 1L, increment, p,
    lower.tail = FALSE
  )
  expect_equal(result$lower$prob[1, 1], expected_efficacy)
  expect_equal(result$upper$prob[1, 1], expected_futility)
  expect_equal(
    result$continuation[1, 1],
    1 - expected_efficacy - expected_futility
  )
  expect_equal(result$conditional_power, expected_efficacy)
})

test_that("VE assumptions are converted using the retained randomization ratio", {
  design <- exact_cp_design()
  observed <- design$lower$bound[1] + 1L
  result <- gsCPBinomialExact(design, x.i = observed, ve = c(.5, .7))

  expect_equal(result$theta, 3 * (1 - c(.5, .7)) / (1 + 3 * (1 - c(.5, .7))))
  expect_equal(result$efficacy, c(.5, .7))
  expect_true(result$conditional_power[2] > result$conditional_power[1])
})

test_that("non-binding conditional power ignores future futility", {
  design <- exact_cp_design()
  observed <- design$lower$bound[1] + 1L
  binding <- gsCPBinomialExact(design, x.i = observed, ve = .7)
  nonbinding <- gsCPBinomialExact(design, x.i = observed, ve = .7, binding = FALSE)

  expect_equal(nonbinding$upper$bound, design$n.I[2] + 1L)
  expect_equal(nonbinding$conditional_futility, 0)
  expect_gte(nonbinding$conditional_power, binding$conditional_power)
})

test_that("default assumptions include observed, null, and alternative probabilities", {
  design <- exact_cp_design(test.type = 1)
  observed <- design$lower$bound[1] + 1L
  result <- gsCPBinomialExact(design, x.i = observed)

  expect_equal(result$theta, unique(c(observed / design$n.I[1], design$theta)))
  expect_length(result$conditional_power, length(result$theta))
})

test_that("exact conditional power validates inputs", {
  design <- exact_cp_design()
  observed <- design$lower$bound[1] + 1L

  expect_error(gsCPBinomialExact(list(), x.i = observed), "toBinomialExact")
  expect_error(gsCPBinomialExact(design, i = 2, x.i = observed), "x\\$k - 1")
  expect_error(gsCPBinomialExact(design, x.i = 1.5), "integer")
  expect_error(gsCPBinomialExact(design, x.i = observed, theta = .3, ve = .7), "at most one")
  expect_error(gsCPBinomialExact(design, x.i = observed, theta = -.1), "between 0 and 1")
  expect_error(gsCPBinomialExact(design, x.i = design$lower$bound[1]), "continuation")
  expect_error(gsCPBinomialExact(design, x.i = observed, binding = NA), "TRUE or FALSE")
})

test_that("updated observed-event designs have stable activity flags", {
  scaffold <- gsSurv(
    k = 3, test.type = 4, alpha = .025, beta = .1, timing = c(.45, .7),
    ratio = 3, hr = .3, hr0 = .7
  )
  design <- toBinomialExact(scaffold, observedEvents = c(20, 78))
  observed <- design$lower$bound[1] + 1L

  expect_no_warning(
    result <- gsCPBinomialExact(design, x.i = observed, ve = c(.3, .7))
  )
  expect_equal(dim(result$lower$prob), c(1, 2))
})

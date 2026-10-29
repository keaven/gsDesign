# Regression tests for forwarding the numerical integration grid parameter r
# from the survival design interfaces and design conversions to gsDesign()
# (#369). The checks record the r received by every internal gsDesign() call
# and replay the group sequential calculation directly at that r.

with_quadrature <- function(method, expr) {
  old <- options(gsDesign.quadrature = method)
  on.exit(options(old), add = TRUE)
  force(expr)
}

# Evaluate expr while recording the r supplied to each gsDesign() call
record_gsDesign_r <- function(expr) {
  seen <- integer()
  real_gsDesign <- gsDesign
  testthat::local_mocked_bindings(
    gsDesign = function(..., r = 18) {
      seen <<- c(seen, r)
      real_gsDesign(..., r = r)
    },
    .package = "gsDesign"
  )
  list(value = force(expr), r = seen)
}

# Direct gsDesign() call with the inputs stored in a survival design
replay_gsDesign <- function(x, r) {
  gsDesign(
    k = x$k, test.type = x$test.type, alpha = x$alpha, beta = x$beta,
    astar = x$astar, n.fix = x$n.fix, timing = x$timing,
    sfu = x$upper$sf, sfupar = x$upper$param,
    sfl = if (is.null(x$lower$sf)) sfHSD else x$lower$sf,
    sflpar = if (is.null(x$lower$param)) -2 else x$lower$param,
    tol = x$tol, r = r, delta1 = x$delta1, delta0 = x$delta0
  )
}

expect_bounds_equal <- function(x, y) {
  expect_equal(x$n.I, y$n.I, tolerance = 1e-12)
  expect_equal(x$upper$bound, y$upper$bound, tolerance = 1e-12)
  expect_equal(x$lower$bound, y$lower$bound, tolerance = 1e-12)
}

# Fixed accrual example that solves the follow-up duration
followup_args <- list(
  k = 4, test.type = 2, alpha = 0.025, beta = 0.1,
  sfu = sfLDOF, timing = c(0.25, 0.5, 0.75, 1),
  lambdaC = 0.03466, hr = 0.5, eta = 0,
  gamma = 15, R = 18, T = NULL, minfup = NULL,
  ratio = 1, method = "Schoenfeld"
)

for (method in c("jt", "gl")) {
  test_that(paste("gsSurv() forwards r to gsDesign() for multi-look designs:", method), {
    for (r in c(4L, 40L)) {
      rec <- with_quadrature(method, record_gsDesign_r(gsSurv(k = 3, r = r)))
      design <- rec$value
      expect_identical(design$r, r)
      expect_gte(length(rec$r), 1)
      expect_true(all(rec$r == r))
      expect_bounds_equal(design, with_quadrature(method, replay_gsDesign(design, r)))
    }
  })

  test_that(paste("gsSurv() forwards r when solving the follow-up duration:", method), {
    rec <- with_quadrature(
      method,
      record_gsDesign_r(do.call(gsSurv, c(followup_args, list(r = 4L))))
    )
    design <- rec$value
    expect_identical(design$r, 4L)
    expect_identical(design$variable, "Follow-up duration")
    # the bracketing calls, the root search, and the final design
    expect_gt(length(rec$r), 3)
    expect_true(all(rec$r == 4L))
    expect_bounds_equal(design, with_quadrature(method, replay_gsDesign(design, 4L)))
  })

  test_that(paste("gsSurvCalendar() forwards r to gsDesign():", method), {
    rec <- with_quadrature(method, record_gsDesign_r(gsSurvCalendar(r = 4L)))
    design <- rec$value
    expect_identical(design$r, 4L)
    expect_gte(length(rec$r), 1)
    expect_true(all(rec$r == 4L))
    expect_bounds_equal(design, with_quadrature(method, replay_gsDesign(design, 4L)))
  })
}

test_that("a coarse grid changes multi-look survival bounds", {
  # a grid parameter well below the default is numerically distinguishable
  expect_false(isTRUE(all.equal(
    gsSurv(k = 3, r = 4)$upper$bound, gsSurv(k = 3)$upper$bound
  )))
  expect_false(isTRUE(all.equal(
    gsSurvCalendar(r = 4)$upper$bound, gsSurvCalendar()$upper$bound
  )))
})

test_that("the default r = 18 is unchanged", {
  design <- gsSurv(k = 3)
  expect_identical(design$r, 18L)
  expect_bounds_equal(design, gsSurv(k = 3, r = 18))
  expect_identical(gsSurvCalendar()$r, 18L)
  expect_identical(gsSurv(k = 1)$r, 18L)
})

test_that("toInteger() retains the r of the input design", {
  x <- gsSurv(k = 3, r = 4L)
  rec <- record_gsDesign_r(toInteger(x))
  expect_identical(rec$value$r, 4L)
  expect_gte(length(rec$r), 1)
  expect_true(all(rec$r == 4L))

  y <- gsDesign(k = 3, n.fix = 100, r = 40L)
  rec <- record_gsDesign_r(toInteger(y, ratio = 1))
  expect_identical(rec$value$r, 40L)
  expect_true(all(rec$r == 40L))

  expect_identical(toInteger(gsSurv(k = 1, r = 40L))$r, 40L)
})

test_that("toBinomialExact() retains the r of the input design when rebuilding", {
  x <- gsSurv(
    k = 3, test.type = 1, timing = c(0.45, 0.7), lambdaC = 0.001,
    hr = 0.3, hr0 = 0.7, eta = 5e-04, gamma = 10, R = 16, T = 24,
    minfup = 8, ratio = 3, r = 4L
  )
  rec <- record_gsDesign_r(toBinomialExact(x, alpha = 0.02))
  expect_s3_class(rec$value, "gsBinomialExact")
  expect_gte(length(rec$r), 1)
  expect_true(all(rec$r == 4L))
})

test_that("single-look gsSurv() validates and retains r", {
  expect_identical(gsSurv(k = 1, r = 40)$r, 40L)
  expect_error(gsSurv(k = 1, r = 0), "interval")
  expect_error(gsSurv(k = 1, r = 81), "interval")
  expect_error(gsSurv(k = 1, r = 2.5), "integer")
})

test_that("out-of-range r is rejected by the multi-look survival interfaces", {
  expect_error(gsSurv(k = 3, r = 0), "interval")
  expect_error(gsSurv(k = 3, r = 81), "interval")
  expect_error(gsSurv(k = 3, r = 2.5), "integer")
  expect_error(gsSurvCalendar(r = 81), "interval")
  expect_error(do.call(gsSurv, c(followup_args, list(r = 81))), "interval")
})

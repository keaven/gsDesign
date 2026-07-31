expect_gsSurv_N <- function(x) {
  expect_s3_class(x, "gsSurv")
  expect_equal(x$N, rowSums(x$eNC) + rowSums(x$eNE))
  expect_length(x$N, x$k)
}

test_that("nSurv returns identical scalar n and N values", {
  designs <- list(
    nSurv(),
    nSurv(
      lambdaC = matrix(log(2) / c(10, 16), nrow = 1),
      gamma = matrix(c(0.6, 0.4), nrow = 1)
    )
  )

  for (design in designs) {
    expect_length(design$n, 1)
    expect_length(design$N, 1)
    expect_identical(design$N, design$n)
    expect_equal(design$N, sum(design$eNC + design$eNE))

    integer <- toInteger(design)
    expect_identical(integer$N, integer$n)
  }
})

test_that("all gsSurv construction paths return cumulative total N", {
  fixed <- gsSurv(k = 1)
  sequential <- gsSurv(k = 2)
  calendar <- gsSurvCalendar(calendarTime = c(12, 24))
  power <- gsSurvPower(
    k = 2,
    plannedCalendarTime = c(12, 24)
  )
  integer <- toInteger(sequential)

  lapply(
    list(fixed, sequential, calendar, power, integer),
    expect_gsSurv_N
  )
  expect_equal(tail(integer$N, 1), round(tail(integer$N, 1)))
})

test_that("gsSurv with fixed rates and follow-up solves enrollment duration", {
  gamma <- 1:4
  R <- rep(1, 4)
  minfup <- 12

  design <- gsSurv(
    k = 2,
    lambdaC = log(2) / 12,
    hr = 0.7,
    T = NULL,
    minfup = minfup,
    gamma = gamma,
    R = R
  )

  expect_identical(design$variable, "Accrual duration")
  expect_equal(as.vector(design$gamma), gamma)
  expect_equal(design$R[seq_len(3)], R[seq_len(3)])
  expect_gt(design$R[4], R[4])
  expect_equal(max(design$T), sum(design$R) + minfup)
})

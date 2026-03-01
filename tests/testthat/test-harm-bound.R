testthat::context("test.type 7 and 8 - harm bounds")

# ---- gsDesign with test.type 7 (binding harm bound) ----

testthat::test_that("gsDesign test.type=7 creates valid design", {
  x <- gsDesign(k = 3, test.type = 7, alpha = 0.025, beta = 0.1)
  testthat::expect_s3_class(x, "gsDesign")
  testthat::expect_equal(x$test.type, 7L)
  testthat::expect_equal(x$k, 3L)
  # Should have harm component

  testthat::expect_true(!is.null(x$harm))
  testthat::expect_true(!is.null(x$harm$bound))
  testthat::expect_true(!is.null(x$harm$prob))
  testthat::expect_true(!is.null(x$harm$spend))
  # Harm bound should be below futility bound
  testthat::expect_true(all(x$harm$bound <= x$lower$bound))
  # Should have lower (futility) bound
  testthat::expect_true(!is.null(x$lower))
  testthat::expect_true(!is.null(x$lower$bound))
  # Upper bound should exist
  testthat::expect_true(!is.null(x$upper))
  testthat::expect_true(!is.null(x$upper$bound))
  # Prob matrices should have correct dimensions
  testthat::expect_equal(nrow(x$harm$prob), x$k)
  testthat::expect_equal(nrow(x$upper$prob), x$k)
  testthat::expect_equal(nrow(x$lower$prob), x$k)
})

testthat::test_that("gsDesign test.type=7 has correct alpha", {
  x <- gsDesign(k = 3, test.type = 7, alpha = 0.025, beta = 0.1)
  # Type I error should be controlled
  testthat::expect_equal(sum(x$upper$prob[, 1]), x$alpha, tolerance = x$tol)
})

testthat::test_that("gsDesign test.type=7 with custom spending functions", {
  x <- gsDesign(
    k = 4, test.type = 7, alpha = 0.025, beta = 0.1,
    sfu = sfHSD, sfupar = -4,
    sfl = sfHSD, sflpar = -2,
    sfharm = sfHSD, sfharmparam = -3
  )
  testthat::expect_s3_class(x, "gsDesign")
  testthat::expect_equal(x$test.type, 7L)
  testthat::expect_true(!is.null(x$harm))
  testthat::expect_true(all(x$harm$bound <= x$lower$bound))
})

testthat::test_that("gsDesign test.type=7 with n.fix", {
  x <- gsDesign(k = 3, test.type = 7, alpha = 0.025, beta = 0.1, n.fix = 800)
  testthat::expect_s3_class(x, "gsDesign")
  testthat::expect_true(max(x$n.I) > 0)
  testthat::expect_true(!is.null(x$harm$bound))
})

testthat::test_that("gsDesign test.type=7 with fixed n.I (via timing)", {
  x0 <- gsDesign(k = 3, test.type = 7, alpha = 0.025, beta = 0.1, n.fix = 800)
  # Verify the design created with n.fix is valid
  testthat::expect_s3_class(x0, "gsDesign")
  testthat::expect_true(!is.null(x0$harm$bound))
  testthat::expect_true(all(x0$harm$bound <= x0$lower$bound))
  testthat::expect_equal(length(x0$n.I), 3)
})

# ---- gsDesign with test.type 8 (non-binding harm bound) ----

testthat::test_that("gsDesign test.type=8 creates valid design", {
  x <- gsDesign(k = 3, test.type = 8, alpha = 0.025, beta = 0.1)
  testthat::expect_s3_class(x, "gsDesign")
  testthat::expect_equal(x$test.type, 8L)
  # Should have harm component
  testthat::expect_true(!is.null(x$harm))
  testthat::expect_true(!is.null(x$harm$bound))
  testthat::expect_true(!is.null(x$harm$prob))
  testthat::expect_true(!is.null(x$harm$spend))
  # Harm bound should be below futility bound
  testthat::expect_true(all(x$harm$bound <= x$lower$bound))
  # Should have lower and upper
  testthat::expect_true(!is.null(x$lower))
  testthat::expect_true(!is.null(x$upper))
})

testthat::test_that("gsDesign test.type=8 has correct alpha (non-binding)", {
  x <- gsDesign(k = 3, test.type = 8, alpha = 0.025, beta = 0.1)
  # For non-binding (test.type=8), falseposnb gives alpha under non-binding assumption
  testthat::expect_equal(sum(x$falseposnb), x$alpha, tolerance = x$tol)
})

testthat::test_that("gsDesign test.type=8 with custom spending functions", {
  x <- gsDesign(
    k = 4, test.type = 8, alpha = 0.025, beta = 0.1,
    sfu = sfHSD, sfupar = -4,
    sfl = sfHSD, sflpar = -2,
    sfharm = sfHSD, sfharmparam = -4
  )
  testthat::expect_s3_class(x, "gsDesign")
  testthat::expect_equal(x$test.type, 8L)
  testthat::expect_true(!is.null(x$harm))
  testthat::expect_true(all(x$harm$bound <= x$lower$bound))
})

testthat::test_that("gsDesign test.type=8 with n.fix", {
  x <- gsDesign(k = 3, test.type = 8, alpha = 0.025, beta = 0.1, n.fix = 800)
  testthat::expect_s3_class(x, "gsDesign")
  testthat::expect_true(max(x$n.I) > 0)
  testthat::expect_true(!is.null(x$harm$bound))
})

testthat::test_that("gsDesign test.type=8 with n.fix produces valid harm bounds", {
  x0 <- gsDesign(k = 3, test.type = 8, alpha = 0.025, beta = 0.1, n.fix = 800)
  testthat::expect_s3_class(x0, "gsDesign")
  testthat::expect_true(!is.null(x0$harm$bound))
  testthat::expect_true(all(x0$harm$bound <= x0$lower$bound))
  testthat::expect_equal(length(x0$harm$bound), 3)
})

# ---- Error handling for harm bound ----

testthat::test_that("gsDesign test.type=7 errors with non-function sfharm", {
  testthat::expect_error(
    gsDesign(k = 3, test.type = 7, sfharm = "not_a_function"),
    "Harm spending function must return object with class spendfn"
  )
})

testthat::test_that("gsDesign test.type=8 errors with non-function sfharm", {
  testthat::expect_error(
    gsDesign(k = 3, test.type = 8, sfharm = "not_a_function"),
    "Harm spending function must return object with class spendfn"
  )
})

# ---- summary.gsDesign for test.type 7 and 8 ----

testthat::test_that("summary.gsDesign for test.type=7", {
  x <- gsDesign(k = 3, test.type = 7, alpha = 0.025, beta = 0.1)
  s <- summary(x)
  testthat::expect_true(grepl("binding futility and harm bounds", s))
  testthat::expect_true(grepl("Harm bounds derived using a", s))
  testthat::expect_true(grepl("Futility bounds derived using a", s))
})

testthat::test_that("summary.gsDesign for test.type=8", {
  x <- gsDesign(k = 3, test.type = 8, alpha = 0.025, beta = 0.1)
  s <- summary(x)
  testthat::expect_true(grepl("non-binding futility and harm bounds", s))
  testthat::expect_true(grepl("Harm bounds derived using a", s))
})

# ---- print.gsDesign for test.type 7 and 8 ----

testthat::test_that("print.gsDesign for test.type=7", {
  x <- gsDesign(k = 3, test.type = 7, alpha = 0.025, beta = 0.1)
  output <- capture.output(print(x))
  testthat::expect_true(any(grepl("Asymmetric two-sided", output)))
  testthat::expect_true(any(grepl("Harm bounds", output) | grepl("Harm bound", output)))
  testthat::expect_true(any(grepl("Futility bound", output) | grepl("Futility bounds", output)))
  testthat::expect_true(any(grepl("harm bound spending", output)))
  testthat::expect_true(any(grepl("futility bound beta spending", output)))
  testthat::expect_true(any(grepl("Harm boundary", output)))
  testthat::expect_true(any(grepl("Futility boundary", output)))
  testthat::expect_true(any(grepl("Spending", output) | grepl("Spend", output)))
})

testthat::test_that("print.gsDesign for test.type=8", {
  x <- gsDesign(k = 3, test.type = 8, alpha = 0.025, beta = 0.1)
  output <- capture.output(print(x))
  testthat::expect_true(any(grepl("Asymmetric two-sided", output)))
  testthat::expect_true(any(grepl("trial continues if lower bound is crossed", output)))
  testthat::expect_true(any(grepl("Harm boundary", output)))
  testthat::expect_true(any(grepl("Futility boundary", output)))
})

# ---- gsBoundSummary for test.type 7 and 8 ----

testthat::test_that("gsBoundSummary for test.type=7", {
  x <- gsDesign(k = 3, test.type = 7, alpha = 0.025, beta = 0.1)
  bs <- gsBoundSummary(x)
  testthat::expect_s3_class(bs, "gsBoundSummary")
  # Should have Harm column
  testthat::expect_true("Harm" %in% names(bs))
  testthat::expect_true("Futility" %in% names(bs))
  testthat::expect_true("Efficacy" %in% names(bs))
  # Should contain expected rows (default exclude removes B-value, Spending, CP, CP H1, PP)
  testthat::expect_true(any(bs$Value == "Z"))
  testthat::expect_true(any(bs$Value == "p (1-sided)"))
  testthat::expect_true(any(grepl("P\\(Cross\\)", bs$Value)))
  testthat::expect_true(any(grepl("~delta at bound", bs$Value)))
})

testthat::test_that("gsBoundSummary for test.type=7 with no exclusions", {
  x <- gsDesign(k = 3, test.type = 7, alpha = 0.025, beta = 0.1)
  bs <- gsBoundSummary(x, exclude = c())
  testthat::expect_s3_class(bs, "gsBoundSummary")
  testthat::expect_true("Harm" %in% names(bs))
  # With no exclusions, should contain all rows
  testthat::expect_true(any(bs$Value == "Z"))
  testthat::expect_true(any(bs$Value == "Spending"))
  testthat::expect_true(any(bs$Value == "B-value"))
  testthat::expect_true(any(bs$Value == "CP"))
  testthat::expect_true(any(bs$Value == "CP H1"))
  testthat::expect_true(any(bs$Value == "PP"))
  testthat::expect_true(any(grepl("P\\(Cross\\)", bs$Value)))
  testthat::expect_true(any(grepl("~delta at bound", bs$Value)))
})

testthat::test_that("gsBoundSummary for test.type=8", {
  x <- gsDesign(k = 3, test.type = 8, alpha = 0.025, beta = 0.1)
  bs <- gsBoundSummary(x)
  testthat::expect_s3_class(bs, "gsBoundSummary")
  testthat::expect_true("Harm" %in% names(bs))
  testthat::expect_true("Futility" %in% names(bs))
  testthat::expect_true("Efficacy" %in% names(bs))
})

testthat::test_that("gsBoundSummary for test.type=7 with exclude", {
  x <- gsDesign(k = 3, test.type = 7, alpha = 0.025, beta = 0.1)
  bs <- gsBoundSummary(x, exclude = c("Spending", "B-value", "PP"))
  testthat::expect_s3_class(bs, "gsBoundSummary")
  testthat::expect_false(any(bs$Value == "Spending"))
  testthat::expect_false(any(bs$Value == "B-value"))
  testthat::expect_false(any(bs$Value == "PP"))
})

testthat::test_that("print.gsBoundSummary for test.type=7", {
  x <- gsDesign(k = 3, test.type = 7, alpha = 0.025, beta = 0.1)
  bs <- gsBoundSummary(x)
  output <- capture.output(print(bs))
  testthat::expect_true(length(output) > 0)
})

# ---- gsProbability for test.type 7 and 8 ----

testthat::test_that("gsProbability works with test.type=7 design", {
  x <- gsDesign(k = 3, test.type = 7, alpha = 0.025, beta = 0.1)
  y <- gsProbability(d = x, theta = x$delta * seq(0, 2, 0.5))
  testthat::expect_s3_class(y, "gsDesign")
  testthat::expect_true(!is.null(y$harm))
  testthat::expect_true(!is.null(y$harm$prob))
  # Harm prob should have correct dimensions
  testthat::expect_equal(nrow(y$harm$prob), y$k)
  testthat::expect_equal(ncol(y$harm$prob), length(y$theta))
})

testthat::test_that("gsProbability works with test.type=8 design", {
  x <- gsDesign(k = 3, test.type = 8, alpha = 0.025, beta = 0.1)
  y <- gsProbability(d = x, theta = x$delta * seq(0, 2, 0.5))
  testthat::expect_s3_class(y, "gsDesign")
  testthat::expect_true(!is.null(y$harm))
  testthat::expect_true(!is.null(y$harm$prob))
})

# ---- gsLegendText for test.type 7 and 8 ----

testthat::test_that("gsLegendText for test.type=7", {
  lt <- gsDesign:::gsLegendText(7)
  testthat::expect_equal(length(lt), 4)
  testthat::expect_equal(lt[[3]], "Futility")
  testthat::expect_equal(lt[[4]], "Harm")
})

testthat::test_that("gsLegendText for test.type=8", {
  lt <- gsDesign:::gsLegendText(8)
  testthat::expect_equal(length(lt), 4)
  testthat::expect_equal(lt[[3]], "Futility")
  testthat::expect_equal(lt[[4]], "Harm")
})

# ---- gsDErrorCheck for test.type 7 and 8 ----

testthat::test_that("gsDErrorCheck sets astar for test.type=7", {
  x <- gsDesign(k = 3, test.type = 7, alpha = 0.025, beta = 0.1, astar = 0)
  # astar should be set to 1 - alpha when input as 0
  testthat::expect_equal(x$astar, 1 - x$alpha)
})

testthat::test_that("gsDErrorCheck sets astar for test.type=8", {
  x <- gsDesign(k = 3, test.type = 8, alpha = 0.025, beta = 0.1, astar = 0)
  testthat::expect_equal(x$astar, 1 - x$alpha)
})

# ---- Test with different k values ----

testthat::test_that("gsDesign test.type=7 with k=2", {
  x <- gsDesign(k = 2, test.type = 7, alpha = 0.025, beta = 0.1)
  testthat::expect_s3_class(x, "gsDesign")
  testthat::expect_true(!is.null(x$harm$bound))
  testthat::expect_equal(length(x$harm$bound), 2)
})

testthat::test_that("gsDesign test.type=8 with k=5", {
  x <- gsDesign(k = 5, test.type = 8, alpha = 0.025, beta = 0.1)
  testthat::expect_s3_class(x, "gsDesign")
  testthat::expect_true(!is.null(x$harm$bound))
  testthat::expect_equal(length(x$harm$bound), 5)
})

# ---- gsBoundSummary with test.type 7/8 and Nname/Information ----

testthat::test_that("gsBoundSummary for test.type=7 with Nname=Information", {
  x <- gsDesign(k = 3, test.type = 7, alpha = 0.025, beta = 0.1)
  bs <- gsBoundSummary(x, Nname = "Information")
  testthat::expect_s3_class(bs, "gsBoundSummary")
  testthat::expect_true("Harm" %in% names(bs))
})

# ---- gsBound/gsBound1 with 0 final spend (produces EXTREMEZ bounds) ----

testthat::test_that("gsBound handles 0 final futility spend (returns EXTREMEZ)", {
  # With 0 final futility spend, the C code returns -EXTREMEZ lower bound
  result <- gsBound(
    I = c(1, 2, 3),
    trueneg = c(0.1, 0.1, 0),
    falsepos = c(0.01, 0.01, 0.005)
  )
  testthat::expect_true(result$a[3] <= -19)  # near -EXTREMEZ
})

testthat::test_that("gsBound handles 0 final efficacy spend (returns EXTREMEZ)", {
  result <- gsBound(
    I = c(1, 2, 3),
    trueneg = c(0.1, 0.1, 0.1),
    falsepos = c(0.01, 0.01, 0)
  )
  testthat::expect_true(result$b[3] >= 19)  # near +EXTREMEZ
})

testthat::test_that("gsBound1 handles 0 final spend (returns EXTREMEZ)", {
  result <- gsBound1(
    theta = 0,
    I = c(1, 2, 3),
    a = c(-3, -3, -3),
    probhi = c(0.01, 0.01, 0)
  )
  testthat::expect_true(result$b[3] >= 19)  # near +EXTREMEZ
})


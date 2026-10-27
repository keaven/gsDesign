test_that("optional no-futility rows retain their explanation in RTF and LaTeX", {
  design <- gsDesign(test.type = 8, delta1 = log(.65))
  summary <- gsBoundSummary(
    design, deltaname = "HR", logdelta = TRUE,
    exclude = c("B-value", "Spending", "CP", "CP H1", "PP")
  )
  path <- tempfile(fileext = ".rtf")
  as_rtf(summary, file = path)
  rtf <- paste(readLines(path, warn = FALSE), collapse = "\n")
  expect_match(rtf, "No-futility rows", fixed = TRUE)
  expect_match(rtf, "Actual cumulative stopping probability under the null", fixed = TRUE)
  expect_match(rtf, "Actual cumulative stopping probability under the alternative", fixed = TRUE)
  latex <- paste(capture.output(xprint(xtable::xtable(summary), comment = FALSE)), collapse = "\n")
  expect_match(latex, "No-futility rows", fixed = TRUE)
  expect_match(latex, "must not be added", fixed = TRUE)
})

test_that("Snapshot test for gsSurv gsBoundSummary as_rtf", {
  skip_on_cran()

  path <- tempfile(fileext = ".rtf")
  xgs <- gsSurv(lambdaC = 0.2, hr = 0.5, eta = 0.1, T = 2, minfup = 1.5)
  tbl <- gsBoundSummary(xgs, timename = "Year", tdigits = 1)
  as_rtf(tbl, file = path)

  local_edition(3)
  expect_snapshot_file(path, "gsBoundSummary-gsSurv.rtf")
})

test_that("Snapshot test for gsDesign gsBoundSummary as_rtf", {
  skip_on_cran()

  path <- tempfile(fileext = ".rtf")

  ss <- nSurvival(lambda1 = 0.2, lambda2 = 0.1, eta = 0.1, Ts = 2, Tr = 0.5, sided = 1, alpha = 0.025, ratio = 2)
  xs <- gsDesign(nFixSurv = ss$n, n.fix = ss$nEvents, delta1 = log(ss$lambda2 / ss$lambda1))
  expect_no_warning(
    tbl <- gsBoundSummary(xs, logdelta = TRUE, ratio = ss$ratio)
  )
  as_rtf(tbl, file = path)

  local_edition(3)
  expect_snapshot_file(path, "gsBoundSummary-gsDesign.rtf")
})

test_that("Snapshot test for gsDesign gsBoundSummary as_rtf with custom footnote", {
  skip_on_cran()

  path <- tempfile(fileext = ".rtf")
  ss <- nSurvival(lambda1 = 0.2, lambda2 = 0.1, eta = 0.1, Ts = 2, Tr = 0.5, sided = 1, alpha = 0.025, ratio = 2)
  xs <- gsDesign(nFixSurv = ss$n, n.fix = ss$nEvents, delta1 = log(ss$lambda2 / ss$lambda1))
  expect_no_warning(
    tbl <- gsBoundSummary(xs, logdelta = TRUE, ratio = ss$ratio)
  )
  as_rtf(tbl, file = path, footnote_specify = "Z", footnote_text = "Z-Score")

  local_edition(3)
  expect_snapshot_file(path, "gsBoundSummary-footnote.rtf")
})

test_that("Snapshot test for gsBinomialExact as_table as_rtf", {
  skip_on_cran()

  path <- tempfile(fileext = ".rtf")
  zz <- gsBinomialExact(k = 3, theta = seq(0.1, 0.9, 0.1), n.I = c(12, 24, 36), a = c(-1, 0, 11), b = c(5, 9, 12))
  tbl <- as_table(zz)
  as_rtf(tbl, file = path, title = "Power/type I error and expected sample size for a group sequential design")

  local_edition(3)
  expect_snapshot_file(path, "gsBinomialExact.rtf")
})

test_that("Snapshot test for binomialSPRT gsBinomialExact safety design with custom labels", {
  skip_on_cran()

  path <- tempfile(fileext = ".rtf")
  safety_design <- binomialSPRT(p0 = 0.04, p1 = 0.1, alpha = 0.04, beta = 0.2, minn = 4, maxn = 75)
  safety_power <- gsBinomialExact(
    k = length(safety_design$n.I),
    theta = seq(0.02, 0.16, 0.02),
    n.I = safety_design$n.I,
    a = safety_design$lower$bound,
    b = safety_design$upper$bound
  )

  tbl <- as_table(safety_power)
  as_rtf(tbl, file = path, theta_label = "Underlying\nAE Rate", prob_decimals = 3, bound_label = c("Low Rate", "High Rate"))

  local_edition(3)
  expect_snapshot_file(path, "gsBinomialExact-safety.rtf")
})

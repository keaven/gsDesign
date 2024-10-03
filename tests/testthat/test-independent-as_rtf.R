
test_that("Snapshot test for gsBoundSummary", {
  skip_on_cran()
  
  # Create a temporary file path for the RTF output
  path <- tempfile(fileext = ".rtf")
  
  # Generate example data for gsBoundSummary
  xgs <- gsSurv(lambdaC = .2, hr = .5, eta = .1, T = 2, minfup = 1.5)
  
  # Save the summary as RTF
  gsBoundSummary(xgs, timename = "Year", tdigits = 1) %>% 
    as_rtf(file = path)
  
  # Test that the generated RTF file matches the snapshot
  local_edition(3)
  expect_snapshot_file(path, "gsBoundSummary.rtf")
})

test_that("Snapshot test for gsBoundSummary with design data", {
  skip_on_cran()
  
  # Create a temporary file path for the RTF output
  path <- tempfile(fileext = ".rtf")
  
  # Generate survival design data
  ss <- nSurvival(
    lambda1 = .2, lambda2 = .1, eta = .1, Ts = 2, Tr = .5,
    sided = 1, alpha = .025, ratio = 2
  )
  xs <- gsDesign(nFixSurv = ss$n, n.fix = ss$nEvents, delta1 = log(ss$lambda2 / ss$lambda1))
  
  # Save the design summary as RTF
  gsBoundSummary(xs, logdelta = TRUE, ratio = ss$ratio) %>% 
    as_rtf(file = path)
  
  # Test that the generated RTF file matches the snapshot
  local_edition(3)
  expect_snapshot_file(path, "gsBoundSummary_design.rtf")
})

test_that("Snapshot test for gsBoundSummary with custom footnote", {
  skip_on_cran()
  
  # Create a temporary file path for the RTF output
  path <- tempfile(fileext = ".rtf")
  
  # Generate survival design data
  ss <- nSurvival(
    lambda1 = .2, lambda2 = .1, eta = .1, Ts = 2, Tr = .5,
    sided = 1, alpha = .025, ratio = 2
  )
  xs <- gsDesign(nFixSurv = ss$n, n.fix = ss$nEvents, delta1 = log(ss$lambda2 / ss$lambda1))
  
  # Save the design summary with custom footnote as RTF
  gsBoundSummary(xs, logdelta = TRUE, ratio = ss$ratio) %>%
    as_rtf(file = path,  
           footnote_specify = "Z",
           footnote_text = "Z-Score")
  
  # Test that the generated RTF file matches the snapshot
  local_edition(3)
  expect_snapshot_file(path, "gsBoundSummary_footnote.rtf")
})

test_that("Snapshot test for gsBinomialExact", {
  skip_on_cran()
  
  # Create a temporary file path for the RTF output
  path <- tempfile(fileext = ".rtf")
  
  # Generate example data for gsBinomialExact
  zz <- gsBinomialExact(
    k = 3, theta = seq(0.1, 0.9, 0.1), n.I = c(12, 24, 36),
    a = c(-1, 0, 11), b = c(5, 9, 12)
  )
  
  # Save the binomial exact summary as RTF
  zz %>%
    as_table() %>%
    as_rtf(
      file = path,
      title = "Power/Type I Error and Expected Sample Size for a Group Sequential Design"
    )
  
  # Test that the generated RTF file matches the snapshot
  local_edition(3)
  expect_snapshot_file(path, "gsBinomialExact.rtf")
})

test_that("Snapshot test for gsBinomialExact for safety design with custom labels", {
  skip_on_cran()
  
  # Create a temporary file path for the RTF output
  path <- tempfile(fileext = ".rtf")
  
  # Generate safety design data
  safety_design <- binomialSPRT(
    p0 = .04, p1 = .1, alpha = .04, beta = .2, minn = 4, maxn = 75
  )
  
  safety_power <- gsBinomialExact(
    k = length(safety_design$n.I),
    theta = seq(.02, .16, .02),
    n.I = safety_design$n.I,
    a = safety_design$lower$bound,
    b = safety_design$upper$bound
  )
  
  # Save the safety power summary with custom labels as RTF
  safety_power %>%
    as_table() %>%
    as_rtf(
      file = path,
      theta_label = "Underlying\nAE Rate",
      prob_decimals = 3,
      bound_label = c("Low Rate", "High Rate")
    )
  
  # Test that the generated RTF file matches the snapshot
  local_edition(3)
  expect_snapshot_file(path, "gsBinomialExact_safety.rtf")
})

test_that("as_rtf validates gsBoundSummary footnote inputs", {
  xgs <- gsSurv(
    k = 2, test.type = 4, alpha = 0.025, beta = 0.1,
    timing = 1, sfu = sfHSD, sfupar = -4, sfl = sfLDOF, sflpar = 0,
    lambdaC = 0.1, hr = 0.5, hr0 = 1, eta = 0.01,
    gamma = 5, R = 6, T = 12, minfup = 6
  )
  summary_tbl <- gsBoundSummary(xgs)

  expect_error(
    as_rtf(summary_tbl, file = tempfile(fileext = ".rtf"), footnote_text = "X"),
    "Footnote location is not defined"
  )
  expect_error(
    as_rtf(summary_tbl, file = tempfile(fileext = ".rtf"), footnote_specify = "Z"),
    "Footnote text is not defined"
  )
  expect_error(
    as_rtf(summary_tbl, file = tempfile(fileext = ".rtf"),
           footnote_specify = c("Z", "X"), footnote_text = "Only one"),
    "Length of footnote_specify"
  )
  expect_error(
    as_rtf(summary_tbl, file = tempfile(fileext = ".rtf"),
           footnote_specify = "Not present", footnote_text = "Missing"),
    "Footnote location not found"
  )
})

test_that("as_rtf writes RTF output for supported tables", {
  skip_if_not_installed("r2rtf")

  zz <- gsBinomialExact(
    k = 2, theta = c(0.1, 0.2), n.I = c(6, 12),
    a = c(-1, 0), b = c(3, 5)
  )
  table_obj <- as_table(zz)
  out_file <- tempfile(fileext = ".rtf")
  out <- as_rtf(table_obj, file = out_file, response_outcome = FALSE)
  expect_true(file.exists(out_file))
  expect_identical(out, table_obj)

  xgs <- gsSurv(
    k = 2, test.type = 4, alpha = 0.025, beta = 0.1,
    timing = 1, sfu = sfHSD, sfupar = -4, sfl = sfLDOF, sflpar = 0,
    lambdaC = 0.1, hr = 0.5, hr0 = 1, eta = 0.01,
    gamma = 5, R = 6, T = 12, minfup = 6
  )
  summary_tbl <- gsBoundSummary(xgs)
  out_file <- tempfile(fileext = ".rtf")
  out <- as_rtf(summary_tbl, file = out_file)
  expect_true(file.exists(out_file))
  expect_identical(out, summary_tbl)
})

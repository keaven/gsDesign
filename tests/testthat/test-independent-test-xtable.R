test_that("xtable returns xtable object correctly", {
  # Example
  x <- gsDesign(
    k = 2,
    alpha = 0.025,
    beta = 0.1,
    timing = c(0.5),
    sfu = sfHSD,
    sfl = sfLDOF
  )

  # Expect a warning for .Deprecated
  expect_warning(
    xtab <- xtable.gsDesign(x, caption = "Test gsDesign Table", Nname = "N"),
    regexp = "Deprecated"
  )

  # xtable returned
  expect_s3_class(xtab, "xtable")

  # Check columns exist
  expect_true(all(c("Analysis", "Value", "Futility", "Efficacy") %in% colnames(xtab)))

  # Check some values are non-empty
  expect_true(all(nchar(as.character(xtab$Analysis)) > 0))
  expect_true(all(nchar(as.character(xtab$Futility)) > 0))
  expect_true(all(nchar(as.character(xtab$Efficacy)) > 0))

  # Extract numeric futility and efficacy bounds from xtable
  fut_vals <- as.numeric(xtab$Futility[seq(1, nrow(xtab), 5)])
  eff_vals <- as.numeric(xtab$Efficacy[seq(1, nrow(xtab), 5)])

  # Compare with lower and upper bounds in gsDesign object
  expect_equal(fut_vals, round(x$lower$bound, 2))
  expect_equal(eff_vals, round(x$upper$bound, 2))
})

test_that("xtable summaries align with gsDesign bounds", {
  design <- gsDesign(
    k = 2,
    alpha = 0.025,
    beta = 0.1,
    timing = 0.5,
    sfu = sfHSD,
    sfl = sfLDOF
  )

  xtab <- expect_warning(
    xtable(design, caption = "Test gsDesign Table", Nname = "N"),
    "Deprecated"
  )

  expect_s3_class(xtab, "xtable")

  tab_df <- as.data.frame(xtab)
  bound_rows <- seq(1, by = 5, length.out = design$k)

  expect_equal(nrow(tab_df), design$k * 5)
  expect_equal(colnames(tab_df), c("Analysis", "Value", "Futility", "Efficacy"))

  expect_match(tab_df$Analysis[bound_rows[1]], "IA 1")
  expect_match(tab_df$Analysis[bound_rows[length(bound_rows)]], "Final analysis")

  expect_equal(
    as.numeric(tab_df$Futility[bound_rows]),
    round(design$lower$bound, 2)
  )
  expect_equal(
    as.numeric(tab_df$Efficacy[bound_rows]),
    round(design$upper$bound, 2)
  )
})

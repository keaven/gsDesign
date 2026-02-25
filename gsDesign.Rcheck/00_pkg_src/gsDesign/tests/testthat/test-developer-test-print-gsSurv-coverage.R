test_that("print.gsSurv covers optional branches", {
  expect_error(print.gsSurv(1), "Primary argument must have class gsSurv")

  x <- gsSurv(
    k = 2, test.type = 4, alpha = 0.025, beta = 0.1,
    timing = 1, sfu = sfHSD, sfupar = -4, sfl = sfLDOF, sflpar = 0,
    lambdaC = matrix(c(0.1, 0.2), ncol = 2),
    gamma = matrix(c(5, 5), ncol = 2),
    hr = 0.5, hr0 = 1, eta = 0.01, R = 6, T = 12, minfup = 6
  )
  expect_silent(capture.output(print(x, show_gsDesign = TRUE, show_strata = TRUE)))
  expect_silent(capture.output(print(x, show_gsDesign = FALSE, show_strata = FALSE)))
})

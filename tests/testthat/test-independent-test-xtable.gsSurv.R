#----------------------------------
### Testing  LaTeX output for gsSurv
#----------------------------------

test_that(
  desc = "test: Checking LaTeX output for gsSurv", code = {
    x <- gsSurv(
      k = 4, sfl = gsDesign::sfPower, sflpar = .5, lambdaC = log(2) / 6, hr = .5,
      eta = log(2) / 40, gamma = 1, T = 36, minfup = 12
    )
    local_edition(3) # use the 3rd edition of the testthat package
    expect_snapshot_output(x = gsDesign::xprint(xtable::xtable(x), comment = FALSE))
  }
)

test_that(
  desc = "test: Checking LaTeX output for gsSurv for footnote not NULL", code = {
    x <- gsSurv(
      k = 4, sfl = gsDesign::sfPower, sflpar = .5, lambdaC = log(2) / 6, hr = .5,
      eta = log(2) / 40, gamma = 1, T = 36, minfup = 12
    )
    local_edition(3) # use the 3rd edition of the testthat package
    expect_snapshot_output(x = gsDesign::xprint(xtable::xtable(x,
      footnote = "This is a footnote; note that it can be wide.",
      caption = "Caption example."
    ), comment = FALSE))
  }
)

test_that(
  desc = "Check LaTeX output for gsSurv for testtype = 1", code = {
    x <- gsSurv(
      k = 4, sfl = gsDesign::sfPower, sflpar = .5, lambdaC = log(2) / 6, hr = .5,
      eta = log(2) / 40, gamma = 1, T = 36, minfup = 12, test.type = 1
    )
    local_edition(3) # use the 3rd edition of the testthat package
    expect_snapshot_output(x = gsDesign::xprint(xtable::xtable(x,
      footnote = "This is a footnote; note that it can be wide.",
      caption = "Caption example."
    ), comment = FALSE))
  }
)

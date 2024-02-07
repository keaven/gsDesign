source('../gsDesign_independent_code.R')
#-------------------------------------------------------------------------------
# Probability Calculations done using East 6.5', 
# source : tests/benchmarks/gsqplot.cywx

# The tolerance in these tests is higher (1e-3) than what is used in other
# comparisons because computations in the different softwares are
# expected to be slightly different.
#-------------------------------------------------------------------------------

test_that(desc = 'check plot data values,
                 source: Probability Calculations done using East 6.5', 
          code = {
  x <- gsDesign(k = 3, test.type = 1, alpha = 0.025,beta = 0.1, 
                delta1 = 0.3, sfu = sfLDOF)
  plotobj <- plotgsPower(x)
  
  res <- subset(plotobj$data, delta == .225)
  expect_lte(abs(res$Probability[3] - 0.68020089), 1e-3)
})


test_that(desc = 'check plot data values,
                 source: Probability Calculations done using East 6.5', 
 code = {
   x <- gsDesign(k = 3, test.type = 1, alpha = 0.025,beta = 0.1, 
                 delta1 = 0.3, sfu = sfLDOF)
   plotobj <- plotgsPower(x)
   
   res <- subset(plotobj$data, delta == .075)
   expect_lte(abs(res$Probability[3] - 0.12486698), 1e-3)
 })



test_that(desc = 'Test: plotgsPower graphs are correctly rendered,test.type = 1', 
          code = {
      x <- gsDesign(k = 3, test.type = 1, alpha = 0.025,beta = 0.1, 
                    delta1 = 0.3, sfu = sfLDOF)
      
      save_plot_obj <- save_gg_plot( plotgsPower(x = x))
      
      local_edition(3)
      
      expect_snapshot_file(save_plot_obj, "plotgsPower_1.png")
})


test_that(desc = 'check plot data values,
                 source: Probability Calculations done using East 6.5', 
          code = {
  x <- gsDesign(k = 3, test.type = 2, alpha = 0.025, 
                beta = 0.1, delta1 = 0.3, sfu = sfLDOF)
  plotobj <- plotgsPower(x)
  
  res_upper <- subset(plotobj$data, delta == 0 & Analysis == 3 &
                  Bound == 'Upper bound')$Probability
  res_lower <- subset(plotobj$data, delta == 0 & Analysis == 3 &
                  Bound == '1-Lower bound')$Probability
  res <- 1 - res_lower + res_upper
  expect_lte(abs(res - 0.05000001), 1e-6)
})

test_that(desc = 'check plot data values,
                 source: Probability Calculations done using East 6.5', 
          code = {
  x <- gsDesign(k = 3, test.type = 2, alpha = 0.025, 
                beta = 0.1, delta1 = 0.3, sfu = sfLDOF)
  plotobj <- plotgsPower(x)
  
  res_upper <- subset(plotobj$data, delta == .15 & Analysis == 3 &
                        Bound == 'Upper bound')$Probability
  res_lower <- subset(plotobj$data, delta == .15 & Analysis == 3 &
                        Bound == '1-Lower bound')$Probability
  res <- 1 - res_lower + res_upper
  expect_lte(abs(res - 0.36688393), 1e-3)
})

test_that(desc = 'check plot data values,
                 source: Probability Calculations done using East 6.5', 
          code = {
   x <- gsDesign(k = 3, test.type = 2, alpha = 0.025, 
                 beta = 0.1, delta1 = 0.3, sfu = sfLDOF)
   plotobj <- plotgsPower(x)
   
   res_upper <- subset(plotobj$data, delta == .45 & Analysis == 3 &
                         Bound == 'Upper bound')$Probability
   res_lower <- subset(plotobj$data, delta == .45 & Analysis == 3 &
                         Bound == '1-Lower bound')$Probability
   res <- 1 - res_lower + res_upper
   expect_lte(abs(res - 0.99808417), 1e-3)
 })


test_that(desc = 'Test: plotgsPower graphs are correctly rendered,test.type = 1', 
          code = {
  x <- gsDesign(k = 3, test.type = 2, alpha = 0.025, 
                beta = 0.1, delta1 = 0.3, sfu = sfLDOF)
  
  save_plot_obj <- save_gg_plot(plotgsPower(x = x))
  
  local_edition(3)
  
  expect_snapshot_file(save_plot_obj, "plotgsPower_2.png")
})

test_that(desc = 'Test: plotgsPower graphs can use offset arg for Future Analysis legend',
          code = {
  x <- gsDesign(k = 3, test.type = 1, alpha = 0.025, beta = 0.1,
                delta1 = 0.3, sfu = sfLDOF)

  # Without offset
  plotobj <- plotgsPower(x)

  expect_equal(
    levels(plotobj$data$Analysis),
    as.character(1:3)
  )

  expect_equal(
    plotobj[["plot_env"]][["titleAnalysis"]],
    "Analysis"
  )

  # With offset
  plotobj <- plotgsPower(x, offset = 1)

  expect_equal(
    levels(plotobj$data$Analysis),
    as.character(2:4)
  )

  expect_equal(
    plotobj[["plot_env"]][["titleAnalysis"]],
    "Future Analysis"
  )
})

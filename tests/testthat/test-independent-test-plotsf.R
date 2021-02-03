source('../gsDesign_independent_code.R')
#------------
## plotsf
#-----------
# spend Calculations done using East 6.5
# source file : tests/benchmark/gsqplot.cywx

# The tolerance in these tests is higher (1e-4) than what is used in other
# comparisons because the CP computations in the different softwares are
# expected to be slightly different.
#-------------------------------------------------------------------------------

test_that(desc = 'check plot data values,
                 source: spend Calculations done using East 6.5', 
          code = {
     x <- gsDesign(k = 3, test.type = 1, alpha = 0.025,beta = 0.1, 
                   delta1 = 0.3, sfu = sfLDOF)
     plotobj <- plotsf(x)
     
     res <- subset(plotobj$data, t == .5)
     expect_lte(abs(res$spend - 0.00152532), 1e-4)
})

test_that(desc = 'check plot data values,
                 source: spend Calculations done using East 6.5', 
          code = {
   x <- gsDesign(k = 3, test.type = 1, alpha = 0.025,beta = 0.1, 
                 delta1 = 0.3, sfu = sfLDOF)
   plotobj <- plotsf(x)
   
   res <- subset(plotobj$data, t == .75)
   expect_lte(abs(res$spend - 0.00965528), 1e-4)
})


test_that(desc = "Test plotsf graphs are correctly rendered,test.type = 1",
          code = {
    x <- gsDesign(k = 3, test.type = 1, alpha = 0.025, beta = 0.1,
                  delta1 = 0.3, sfu = sfLDOF)

    save_plot_obj <- save_gg_plot(plotsf(x = x))
    local_edition(3)
    expect_snapshot_file(save_plot_obj, "plotsf_1.png")

})

test_that(desc = "Test plotsf graphs are correctly rendered,test.type = 5",
          code = {
  x <- gsDesign(k = 3, test.type = 5, alpha = 0.025, beta = 0.1,
                delta1 = 0.3, sfu = sfLDOF)
  
  save_plot_obj <- save_gg_plot(plotsf(x = x, base = TRUE))
  local_edition(3)
  expect_snapshot_file(save_plot_obj, "plotsf_2.png")
  
})

test_that(desc = "Test plotgsCP graphs are correctly rendered,test.type = 4",
          code = {
  x <- gsDesign(k = 3, test.type = 4, alpha = 0.025, beta = 0.1,
                delta1 = 0.3, sfu = sfLDOF)
  
  save_plot_obj <- save_gg_plot(plotsf(x = x, base = FALSE))
  local_edition(3)
  expect_snapshot_file(save_plot_obj, "plotsf_3.png")
  
})

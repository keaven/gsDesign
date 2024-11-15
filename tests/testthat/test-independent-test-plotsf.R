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

test_that("plotsf: plots are correctly rendered, test.type = 1", {
  x <- gsDesign(
    k = 3, test.type = 1, alpha = 0.025, beta = 0.1,
    delta1 = 0.3, sfu = sfLDOF
  )

  vdiffr::expect_doppelganger(
    "plotsf test type 1",
    plotsf(x = x)
  )
})

test_that("plotsf: plots are correctly rendered, test.type = 5", {
  x <- gsDesign(
    k = 3, test.type = 5, alpha = 0.025, beta = 0.1,
    delta1 = 0.3, sfu = sfLDOF
  )

  vdiffr::expect_doppelganger(
    "plotsf test type 5",
    plotsf(x = x, base = TRUE)
  )
})

test_that("plotgsCP: plots are correctly rendered, test.type = 4", {
  x <- gsDesign(
    k = 3, test.type = 4, alpha = 0.025, beta = 0.1,
    delta1 = 0.3, sfu = sfLDOF
  )

  vdiffr::expect_doppelganger(
    "plotgsCP test type 4",
    plotsf(x = x, base = FALSE)
  )
})

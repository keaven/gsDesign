#################################################
# Test plotASN function
#################################################

## The benchmark values for testing plotASN() are obtained from  East 6.5
## chart in the East 6.5 workbook - benchmarks/gsDelta.cywx


## Validate gsDesign benchmrk data from plotASN function.
xx <- gsDesign(k = 2, test.type = 1, alpha = 0.025,beta = 0.1, delta1 = 0.3, 
               sfu = sfLDOF,n.fix = 466.9965809)
pltob <- plotASN(xx)


test_that( desc = "check the sample size", code = {
    ## at delta = 0.06
    obs <- subset(pltob$data, x == 0.06)$y
    exptd <- 467.1517045

    ## The tolerance is high (=1e-2)
    ## because such differences are expected from the different softwares.

    expect_lte(abs(obs - exptd), 1e-2)

    ## at delta = 0.24
    obs <- subset(pltob$data, x == 0.24)$y
    exptd <- 438.103876
    expect_lte(abs(obs - exptd), 1e-2)

    ## at delta = 0.3
    obs <- subset(pltob$data, x == 0.3)$y
    exptd <- 409.427932
    expect_lte(abs(obs - exptd), 1e-2)
  }
)


## Validate gsSurv benchmrk data from plotASN function.
## expected sample size vs treatment effect chart

x <- gsSurv(k = 4, sfl = sfPower, sflpar = .5, lambdaC = log(2) / 6, hr = .5,
            eta = log(2) / 40, gamma = 1, T = 36, minfup = 12)
pltobj <- plotASN(x)

## check plot data values
test_that( desc = "check expected sample sizes", code = {
    ## at HR = 1
    obs <- subset(pltobj$data, x == 1.0)$y
    exptd <- 47.143
    expect_lte(abs(obs - exptd), 2)
    ## at delta = 0.75785828
    obs <- subset(pltobj$data, x > 0.74 & x < 0.78)$y
    exptd <- 69.732

    ## The tolerance is high (= 2) as the computations for survival design
    ## are based on slightly different formulae in East and gsDesign.

    expect_lte(abs(obs - exptd), 2)
    ## at delta = 0.5
    obs <- subset(pltobj$data, x == 0.5)$y
    exptd <- 72.2
    expect_lte(abs(obs - exptd), 2)
  }
)


# save_gg_plot() will be used when storing plot objects created with graphics package.

test_that("Test plotASN graphs for gSurv are correctly rendered ", {
  save_plot_obj <- save_gg_plot(plotASN(x))
  local_edition(3)
  expect_snapshot_file(save_plot_obj, "plot_plotastn_1.png")
})

test_that("Test plotASN graphs for gsDesign are correctly rendered ", {
  save_plot_obj <- save_gg_plot(plotASN(xx))
  local_edition(3)
  expect_snapshot_file(save_plot_obj, "plot_plotastn_3.png")
})

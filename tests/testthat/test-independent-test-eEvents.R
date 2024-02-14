# #----------------------------------
# ### Testing eEvents function 
# For comparing floating-point numbers, an exact match cannot be expected. 
# For such test cases, the tolerance is set to 1e-6 (= 0.000001), 
# a sufficiently low value
# #----------------------------------

test_that(
  desc = "test: checking number of events on a single arm
          source : helper.R",
  code = {
    nEv <- eEvents(
      lambda = 0.2, eta = 0.1, gamma = 1,
      R = 12, S = NULL, T = 24, Tfinal = NULL,
      minfup = 0
    )

    ## Compute # of events from independently coded validator.
    ## the sample size is taken as the one that is output from
    ## eEvents().
    ## sample sizes are validated separately using nSurvival()
    
    vldEv <- expect_ev_arm(
      lambda = .2, drprate = 0.1,
      maxstudy = 24, accdur = 12,
      totalSS = nEv$n, rndprop = 1
    )

    expect_lte(
      object = abs(nEv$d - vldEv),
      expected = 1e-6
    )
  }
)
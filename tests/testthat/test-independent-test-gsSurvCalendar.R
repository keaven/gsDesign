####################################################################################
###
###   Author: Myeongjong Kang (myeongjong.kang@merck.com)
###
###   Overview: Testing gsSurvCalendar function
###
###   Contents: Testing functions and unit testings
###
####################################################################################

#-----------------------------------------------------------------------------------
### Testing functions
#-----------------------------------------------------------------------------------

#' @title Comparing names of outputs of \code{gsSurv()} and \code{gsSurvCalendar()}
#'
#' @param dsgn1 Output of \code{gsSurv()}
#' @param dsgn2 Output of \code{gsSurvCalendar()}
comparison_names <- function(dsgn1, dsgn2)
{
  # Motivation: The list of gsSurvCalendar()'s outputs is supposed to include every element of the list of the gsSurv()'s outputs.
  testthat::expect_contains(names(dsgn2), names(dsgn1))
}

#' @title Comparing inputs of \code{gsSurv()} and \code{gsSurvCalendar()}
#'
#' @param dsgn1 Output of \code{gsSurv()}
#' @param dsgn2 Output of \code{gsSurvCalendar()}
#' @param tolerance A numerical tolerance used when comparing numerical values at \code{1e-6} by default
comparison_inputs <- function(dsgn1, dsgn2, tolerance = 1e-6)
{
  # Motivation: For fair comparison, inputs of gsSurvCalendar() are assumed to be equivalent to corresponding inputs of gsSurv().
  testthat::expect_identical(dsgn1$k, dsgn2$k)
  
  # Motivation: The following comparisons can be useful for future unit testing development, 
  #             since default values of the inputs are different for gsSurv() and gsSurvCalendar().
  testthat::expect_equal(dsgn1$minfup, dsgn2$minfup, tolerance = tolerance)
  testthat::expect_equal(dsgn1$tol, dsgn2$tol, tolerance = tolerance)
}

#' @title Comparing names of outputs of \code{gsSurv()} and \code{gsSurvCalendar()}
#'
#' @param dsgn1 Output of \code{gsSurv()}
#' @param dsgn2 Output of \code{gsSurvCalendar()}
#' @param tolerance A numerical tolerance used when comparing numerical values at \code{1e-6} by default
comparison_outputs <- function(dsgn1, dsgn2, tolerance = 1e-6)
{
  # Motivation: For direct comparison, outputs of gsSurvCalendar() are compared to corresponding outputs of gsSurv(). 
  #             The list is inspired by gsBoundSummary().
  testthat::expect_equal(dsgn1$delta, dsgn2$delta, tolerance = tolerance)
  testthat::expect_equal(dsgn1$delta0, dsgn2$delta0, tolerance = tolerance)
  testthat::expect_equal(dsgn1$delta1, dsgn2$delta1, tolerance = tolerance)
  testthat::expect_equal(dsgn1$theta, dsgn2$theta, tolerance = tolerance)
  testthat::expect_equal(dsgn1$ratio, dsgn2$ratio, tolerance = tolerance)
  
  testthat::expect_equal(dsgn1$lower$bound, dsgn2$lower$bound, tolerance = tolerance)
  testthat::expect_equal(dsgn1$upper$bound, dsgn2$upper$bound, tolerance = tolerance)
  
  testthat::expect_equal(dsgn1$n.fix, dsgn2$n.fix, tolerance = tolerance)
  testthat::expect_equal(dsgn1$n.I, dsgn2$n.I, tolerance = tolerance)
  testthat::expect_equal(dsgn1$nFixSurv, dsgn2$nFixSurv, tolerance = tolerance)
  
  testthat::expect_equal(dsgn1$eNE, dsgn2$eNE, tolerance = tolerance)
  testthat::expect_equal(dsgn1$eNC, dsgn2$eNC, tolerance = tolerance)
  
  testthat::expect_equal(dsgn1$T, dsgn2$T, tolerance = tolerance)
}

#-----------------------------------------------------------------------------------
### Unit testings
#-----------------------------------------------------------------------------------

testthat::test_that(
  desc = "From information timing to calendar timing",
  code = {
    dsgn01 <- gsSurv(k = 3, 
                     test.type = 4, alpha = 0.025, sided = 1, beta = 0.1, astar = 0, timing = 1, 
                     sfu = gsDesign::sfHSD, sfupar = -4, sfl = gsDesign::sfHSD, sflpar = -2,
                     r = 18, lambdaC = log(2)/6, hr = 0.6, hr0 = 1, eta = 0, etaE = NULL,
                     gamma = 1, R = 12, S = NULL, T = 18, minfup = 6, ratio = 1,
                     tol = .Machine$double.eps^0.25, usTime = NULL, lsTime = NULL)
    
    dsgn02 <- gsSurvCalendar(spending = "information", calendarTime = dsgn01$T, minfup = 6, tol = .Machine$double.eps^0.25, # These arguments' values are different from their default values.
                             test.type = 4, alpha = 0.025, sided = 1, beta = 0.1, astar = 0,
                             sfu = gsDesign::sfHSD, sfupar = -4, sfl = gsDesign::sfHSD, sflpar = -2,
                             r = 18, lambdaC = log(2)/6, hr = 0.6, hr0 = 1, eta = 0, etaE = NULL, 
                             gamma = 1, R = 12, S = NULL, ratio = 1)
    
    # dsgn02 is supposed to be the same as dsgn01.
    comparison_names(dsgn01, dsgn02)
    comparison_inputs(dsgn01, dsgn02)
    comparison_outputs(dsgn01, dsgn02)
  }
)

testthat::test_that(
  desc = "From calendar timing to information timing",
  code = {
    dsgn03 <- gsSurvCalendar(spending = "information",
                             test.type = 4, alpha = 0.025, sided = 1, beta = 0.1, astar = 0,
                             sfu = gsDesign::sfHSD, sfupar = -4, sfl = gsDesign::sfHSD, sflpar = -2,
                             calendarTime = c(12, 24, 36), 
                             lambdaC = log(2)/6, hr = 0.6, hr0 = 1, eta = 0, etaE = NULL,
                             gamma = 1, R = 12, S = NULL, minfup = 18, ratio = 1, r = 18,
                             tol = 1e-06)
    
    # Calculate the expected numbers of events for time points
    nevents <- sapply(dsgn03$T, 
                      function(x) nEventsIA(x = dsgn03, tIA = x, simple = FALSE)[[2]] + 
                        nEventsIA(x = dsgn03, tIA = x, simple = FALSE)[[3]])
    
    dsgn04 <- gsSurv(k = 3, timing = nevents / tail(nevents, 1), T = tail(dsgn03$T, 1), minfup = 18, tol = 1e-06, # These arguments' values are different from their default values.
                     test.type = 4, alpha = 0.025, sided = 1, beta = 0.1, astar = 0,
                     sfu = sfHSD, sfupar = -4, sfl = sfHSD, sflpar = -2, 
                     lambdaC = log(2)/6, hr = 0.6, hr0 = 1, eta = 0, etaE = NULL,
                     gamma = 1, R = 12, S = NULL, ratio = 1, r = 18, 
                     usTime = NULL, lsTime = NULL)
    
    # dsgn04 is supposed to be the same as dsgn03.
    comparison_names(dsgn04, dsgn03)
    comparison_inputs(dsgn04, dsgn03)
    comparison_outputs(dsgn04, dsgn03)
  }
)

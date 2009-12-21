##################################################################################
#  Survival functionality for the gsDesign package
#
#  Exported Functions:
#                   
#    nSurvival
#
#  Hidden Functions:
#
#    pe
#
#  Author(s): Keaven Anderson, PhD., Shanhong Guan
# 
#  Reviewer(s): REvolution Computing 19DEC2008 v.2.0 - William Constantine, Kellie Wills 
#
#  R Version: 2.7.2
#
##################################################################################

############################################################
## Name: nSurvival.R                                       #
## Purpose: Calculate sample size for clinical trials      #
##          with time-to-event endpoint using LF method    # 
## Date: 09/28/2007                                        #
## Author: Shanhong Guan                                   #
## Note: 1) allow risk ratio (RR) and risk difference (RD) #
##       2) allow unif and exponential entry               #
##       3) allow exponential loss-to-follow-up            #
##                                                         #
## Update: 1/14/2008                                       #
## Reason: add an "sided" argument to indicate one or      #
##         two-sided test                                  #
## Upate: 12/20/2009                                       #
## Reason: Changed so that output list is consistent with  #
##         inputs. Also changed lambda.0 to lambda1,       #
##         lambda.1 to lambda2, and rand.ratio to ratio    #
##         to be consistent with nBinomial naming          #
##         conventions.                                    #
##         Added "nSurvival" as class name for nSurvival   #
##         output and created print.nSurvival to print it  #
############################################################

###
# Exported Functions
###

"nSurvival" <- function(lambda1=1/12, lambda2=1/24, Ts=24, Tr=12,
        eta = 0, ratio = 1,
        alpha = 0.025, beta = 0.10, sided = 1,
        approx = FALSE, type = c("rr", "rd"),
        entry = c("unif", "expo"), gamma = NA)
{
    ############################################################
    ##                                                         #
    ## calculate sample size                                   #
    ## lambda1 -- hazard rate for placebo group                #
    ## lambda2 -- hazard rate for treatment group              #
    ## Ts -- study duration                                    #
    ## Tr -- accrual duration                                  #
    ## eta -- exponential dropout rate                         #
    ## ratio -- randomization ratio (T/P)                      #
    ## alpha -- type I error rate                              #
    ## beta -- type II error rate                              #
    ## sided -- one or two-sided test                          #
    ## approx -- for rd, should approximation be used?         #
    ##           Default = F                                   #
    ## type -- risk ratio or risk difference                   #
    ## entry -- uniform or exponential                         #
    ## gamma -- exponential entry rate                         #
    ##         = NA if uniform entry                           #
    ##                                                         #
    ############################################################
    
    type <- match.arg(type)
    entry <- match.arg(entry)
    
    method <- match(type, c("rr", "rd"))
    accrual <- match(entry, c("unif", "expo")) == 1
    
    xi0 <- 1 / (1 + ratio)
    xi1 <- 1 - xi0 
    
    if (is.na(method))
    {
        stop("Only rr (risk ratio) or rd (risk difference) is valid!")
    }
    
    # average hazard rate under H_1
    ave.haz <- lambda1 * xi0 + lambda2 * xi1
    
    # vector of hazards: placebo, test, and average 
    haz <- c(lambda1, lambda2, ave.haz)
    
    prob.e <- sapply(haz, pe, eta = eta, Ts = Ts, Tr = Tr,
            gamma = gamma, unif = accrual)
    
    zalpha <- qnorm(1 - alpha / sided)
    zbeta <- qnorm(1 - beta)
    
    haz.ratio <- log(lambda1 / lambda2)
    haz.diff <- lambda1 - lambda2
    
    if (method == 1){  # risk ratio
        power <- zalpha/sqrt(prob.e[3]*xi0*xi1) +
                zbeta*sqrt((xi0*prob.e[1])^(-1) + 
                                (xi1*prob.e[2])^(-1))
        N <- (power / haz.ratio)^2
        E <- N * (xi0 * prob.e[1] + xi1 * prob.e[2])
    }
    else
    { # risk difference
        if (approx)
        { # use approximation
            power <- (zalpha + zbeta) * sqrt((lambda1^2 * (xi0 * prob.e[1])^(-1) +
                                lambda2^2 * (xi1 * prob.e[2])^(-1)))
        }
        else
        { # use variance under H_0 and H_a
            power <- zalpha * (xi0 * xi1 * prob.e[3] / ave.haz^2)^(-1/2) +
                    zbeta * sqrt((lambda1^2 * (xi0 * prob.e[1])^(-1) +
                                        lambda2^2 * (xi1 * prob.e[2])^(-1)))
        }
        N <- (power / haz.diff)^2
        E <- N * (xi0 * prob.e[1] + xi1 * prob.e[2])
    }
    
    # output all the input parameters, including entry type and
    # method, and sample size
    outd <- list(type = type, entry = entry, n = N,
            nEvents = E, 
            lambda1 = lambda1, lambda2 = lambda2,
            eta = eta, ratio=ratio, 
            gamma = gamma, alpha = alpha, beta = beta, sided = sided,
            Ts = Ts, Tr = Tr, approx=approx)
    class(outd) <- "nSurvival"
    outd
}

###
# Hidden Functions
###

"pe" <- function(lam, eta = 0, Ts, Tr, unif = TRUE, gamma)
{
    ###########################################################
    #                                                         #
    # calculate prob. of event                                #
    #                                                         #
    ###########################################################
    
    q1 <- lam / (lam + eta)
    
    if (unif)
    {    
        q2 <- exp(-(lam + eta) * (Ts - Tr)) - exp(-(lam+eta) * Ts)
        q3 <- (lam + eta) * Tr    
        resu <- q1 * (1 - q2 / q3)
    }
    else
    {
        if (is.na(gamma))
        {
            stop("Exponential entry! gamma cannot be misssing")            
        }
        
        t2 <- lam * gamma * exp(-(lam + eta) * Ts) * (1 - exp((lam + eta - gamma) * Tr))
        t3 <- (1 - exp(-gamma * Tr)) * (lam + eta) * (lam + eta - gamma)
        resu <- q1 + t2 / t3
    }
    
    resu                        
}

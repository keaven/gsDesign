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
## Name: nSurvival.R                                         #
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
############################################################

###
# Exported Functions
###

"nSurvival" <- function(lambda.0, lambda.1, Ts, Tr,
        eta = 0, rand.ratio = 1,
        alpha = 0.05, beta = 0.10, sided = 2,
        approx = FALSE, type = c("rr", "rd"),
        entry = c("unif", "expo"), gamma = NA)
{
    ############################################################
    ##                                                         #
    ## calculate sample size                                   #
    ## lambda.0 -- hazard rate for placebo group               #
    ## lambda.1 -- hazard rate for treatment group             #
    ## Ts -- study duration                                    #
    ## Tr -- accrual duration                                  #
    ## eta -- exponential dropout rate                         #
    ## rand.ratio -- randomization ratio (T/P)                 #
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
    
    xi0 <- 1 / (1 + rand.ratio)
    xi1 <- 1 - xi0 
    
    if (is.na(method))
    {
        stop("Only risk ratio or risk difference is valid!")
    }
    
    # average hazard rate under H_1
    ave.haz <- lambda.0 * xi0 + lambda.1 * xi1
    
    # vector of hazards: placebo, test, and average 
    haz <- c(lambda.0, lambda.1, ave.haz)
    
    prob.e <- sapply(haz, pe, eta = eta, Ts = Ts, Tr = Tr,
            gamma = gamma, unif = accrual)
    
    zalpha <- qnorm(1 - alpha / sided)
    zbeta <- qnorm(1 - beta)
    
    haz.ratio <- log(lambda.0 / lambda.1)
    haz.diff <- lambda.0 - lambda.1
    
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
            power <- (zalpha + zbeta) * sqrt((lambda.0^2 * (xi0 * prob.e[1])^(-1) +
                                lambda.1^2 * (xi1 * prob.e[2])^(-1)))
        }
        else
        { # use variance under H_0 and H_a
            power <- zalpha * (xi0 * xi1 * prob.e[3] / ave.haz^2)^(-1/2) +
                    zbeta * sqrt((lambda.0^2 * (xi0 * prob.e[1])^(-1) +
                                        lambda.1^2 * (xi1 * prob.e[2])^(-1)))
        }
        N <- (power / haz.diff)^2
        E <- N * (xi0 * prob.e[1] + xi1 * prob.e[2])
    }
    
    # output all the input parameters, including entry type and
    # method, and sample size
    outd <- list(Method = type, Entry = entry, Sample.size = N,
            Num.events = E, 
            Hazard.p = lambda.0, Hazard.t = lambda.1,
            Dropout = eta, Frac.p = xi0, Frac.t = xi1,
            Gamma = gamma, Alpha = alpha, Beta = beta, Sided = sided,
            Study.dura = Ts, Accrual = Tr)
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

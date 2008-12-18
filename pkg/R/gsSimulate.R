##################################################################################
#  Simulation functionality for the gsDesign package
#
#  Exported Functions:
#                   
#    (none)
#
#  Hidden Functions:
#
#    gsAdaptSim
#    gsSimulate
#
#  Author(s): Keaven Anderson, PhD.
# 
#  Reviewer(s): REvolution Computing 19DEC2008 v.2.0 - William Constantine, Kellie Wills 
#
#  R Version: 2.7.2
#
##################################################################################

###
# Exported Functions
###

###
# Hidden Functions
###

"gsAdaptSim" <- function(SimStage, IniSim, TrialPar, SimPar, cp=0, thetacp=-100, maxn=100000, pdeltamin=0, ...)
{
    # simulate 1st k-1 stages of trial
    x <- gsSimulate(nstage=TrialPar$gsx$k-1, SimStage, IniSim, TrialPar, SimPar)
    
    # for default,  set conditional power to be used
    if (cp == 0)
    {
        cp <- 1 - x$gsx$beta
    }
    
    # compute planned information between final interim and final analysisp
    Inew <- x$gsx$n.I[x$gsx$k] - x$gsx$n.I[x$gsx$k - 1]
    
    # compute final n per group assuming no adaptation
    nnewe <- ceiling(x$gsx$n.I[x$gsx$k] * x$ratio / (1 + x$ratio) - x$ne)
    
    if (length(nnewe) == 1) 
    {
        nnewe <- array(nnewe, TrialPar$nsim)
    }
    
    nnewc <- ceiling(x$gsx$n.I[x$gsx$k] / (1 + x$ratio) - x$nc)
    
    if (length(nnewc) == 1)
    {
        nnewc <- array(nnewc, TrialPar$nsim)
    }
    
    # compute bounds for each simulation for z based on data between final interim and final analysis
    bnew <- (x$gsx$upper$bound[x$gsx$k] - x$z * sqrt(x$gsx$n.I[x$gsx$k-1] / x$gsx$n.I[x$gsx$k])) / sqrt(Inew / x$gsx$n.I[x$gsx$k])
    lnew <- (x$gsx$lower$bound[x$gsx$k] - x$z * sqrt(x$gsx$n.I[x$gsx$k-1] / x$gsx$n.I[x$gsx$k])) / sqrt(Inew / x$gsx$n.I[x$gsx$k])
    
    # compute estimated standardized treatment effect
    thetahat <- x$z / sqrt(x$gsx$n.I[x$gsx$k - 1])
    
    # for default,  set theta parameter for which conditional power is to be adjusted
    # to estimated value at interim
    if (thetacp == -100)
    {
        thetacp <- thetahat
    }
    
    # compute sample size to achieve desired conditional power
    ncp <- array(maxn, TrialPar$nsim)-x$nc-x$ne
    ncp[thetacp > 0] <- as.integer(ceiling(((bnew[thetacp > 0] + qnorm(cp)) / thetacp[thetacp > 0])^2))
    
    if (maxn > 0)
    {    
        maxn <- maxn - x$nc - x$ne
        if (length(maxn) == 1)
        {
            maxn <- array(maxn, x$nsim)
        }
        ncp[ncp > maxn] <- maxn[ncp > maxn]
    }
    
    # set flag for adapting sample size at final analysis based on conditional power, 
    # min desired sample size,  and min observed delta 
    flag <- 1 * (x$outcome == 0)
    flag <- flag * (x$xc / x$nc - x$xe / x$ne >= pdeltamin)
    flag <- flag * (ncp > ceiling(Inew))
    
    # compute updated sample sizes for final analysis
    ncpe <- as.integer(ceiling(ncp * x$ratio / (1 + x$ratio)))
    ncpc <- ncp - ncpe
    nnewc[flag == 1] <- ncpc[flag == 1]
    nnewe[flag == 1] <- ncpe[flag == 1]
    
    # set up analysis object for final stage
    zero <- array(0, x$nsim)
    y <- list(xc=zero, xe=zero, nc=nnewc, ne=nnewe, xadd=x$xadd, nadd=x$nadd)
    
    # simulate data for final stage
    for (j in 1:x$nsim)
    {    
        if (x$outcome[j] == 0)
        {    
            y$xc[j] <- rbinom(1, nnewc[j], x$pcsim)
            y$xe[j] <- rbinom(1, nnewe[j], x$pesim)
            x$xc[j] <- x$xc[j] + y$xc[j]
            x$xe[j] <- x$xe[j] + y$xe[j]
        }
        # this is just to avoid 0 divide in zStat later
        else
        {    
            y$xc[j] <- y$nc[j] / 2
            y$xe[j] <- y$ne[j] / 2
        }    
    }
    
    if (length(x$nc) == 1)
    {
        x$nc <- array(x$nc, TrialPar$nsim)
    }
    x$nc[x$outcome == 0] <- x$nc[x$outcome == 0] + nnewc[x$outcome == 0]
    
    if (length(x$ne) == 1) 
    {
        x$ne <- array(x$ne, TrialPar$nsim)
    }
    x$ne[x$outcome == 0] <- x$ne[x$outcome == 0] + nnewe[x$outcome == 0]
    
    # compute final z statistics
    y <- x$zStat(y)
    x$y <- y
    
    # update final outcome
    x$outcome <- x$outcome + (x$outcome == 0) * x$gsx$k * ((y$z >= bnew) - (y$z < lnew))
    
    x
}

"gsSimulate" <- function(nstage=0, SimStage, IniSim, TrialPar, SimPar)
{    
    if (nstage == 0) 
    {
        nstage <- TrialPar$gsx$k
    }
    x <- IniSim(TrialPar, SimPar)
    nim1 <- 0
    for (i in 1:nstage)
    {    
        x <- SimStage(x$gsx$n.I[i], x)
        x$outcome <- x$outcome + (x$outcome == 0) * i *
                ((x$z >= x$gsx$upper$bound[i]) - (x$z < x$gsx$lower$bound[i]))
    }
    
    x
}


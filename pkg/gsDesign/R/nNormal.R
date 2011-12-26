# sample size for fixed design with 2-arms, normal endpoint, 
# ratio = randomization ratio
nNormal<-function(delta1=1,sigma=1.7,sigalt=NULL,alpha=.025,beta=.1,ratio=1,delta0=0)
{   xi <- ratio/(1+ratio)
    if(is.null(sigalt)) sigalt <- sigma
    v <- sigalt^2/xi + sigma^2/(1-xi)
    theta1 <- (delta1-delta0)/sqrt(v)
    n <- ((qnorm(alpha)+qnorm(beta))/theta1)^2
    n
}

# EXAMPLES
# equal variances
n.fix <- nNormal(delta1=.5,sigma=1.1,alpha=.025,beta=.2)

# unequal variances


# unequal sample sizes 


# non-inferiority
n.fix <- nNormal(delta1=0,delta0=.5,sigma=1.2)

"nNormal" <- function(delta1=1, sigma=1.7, sigalt=NULL, alpha=.025,
               beta=.1, ratio=1, sided=1, n=NULL, delta0=0)
{  xi <- ratio/(1+ratio)
   if (is.null(sigalt)) sigalt <- sigma
   v <- sigalt^2/xi + sigma^2/(1-xi)
   theta1 <- (delta1-delta0)/sqrt(v)
   if (is.null(n))
      return(((qnorm(alpha/sided)+qnorm(beta))/theta1)^2)
   else
      return(pnorm(sqrt(n)*theta1-qnorm(1-alpha/sided)))
}

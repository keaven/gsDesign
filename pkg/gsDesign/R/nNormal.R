"nNormal" <- function(delta1=1, sd=1.7, sd2=NULL, alpha=.025,
               beta=.1, ratio=1, sided=1, n=NULL, delta0=0, outtype=1)
{ # check input arguments
  checkVector(delta1, "numeric", c(-Inf, Inf), c(FALSE, FALSE))
  checkVector(sd, "numeric", c(0, Inf), c(FALSE, FALSE))    
  checkScalar(sided, "integer", c(1, 2))    
  checkScalar(alpha, "numeric", c(0, 1 / sided), c(FALSE, FALSE))
  checkVector(beta, "numeric", c(0, 1 - alpha / sided), c(FALSE, FALSE))
  checkVector(delta0, "numeric", c(-Inf, Inf), c(FALSE, FALSE))
  checkVector(ratio, "numeric", c(0, Inf), c(FALSE, FALSE))
  checkScalar(outtype, "integer", c(1, 3))
  checkLengths(delta1, delta0, sd, sd2, alpha, beta, ratio, allowSingle=TRUE)
  
   xi <- ratio/(1+ratio)
   if (is.null(sd2)) sd2 <- sd
   se <- sqrt(sd2^2/xi + sd^2/(1-xi))
   theta1 <- (delta1-delta0)/se
   if (max(abs(theta1) == 0)) stop("delta1 may not equal delta0")
   if (is.null(n)){
      n <-((qnorm(alpha/sided)+qnorm(beta))/theta1)^2
      if (outtype == 2)
      {
        return(data.frame(cbind(n1=n / (ratio + 1),  n2=ratio * n / (ratio + 1))))
      }
      else if (outtype == 3) 
      {   
        return(data.frame(cbind(n=n, n1=n / (ratio + 1), n2=ratio * n / (ratio + 1),
                    alpha = alpha, sided=sided, beta = beta, Power = 1-beta,
                    sd=sd, sd2=sd2, delta1=delta1, delta0=delta0, se=se/sqrt(n))))
      }
      else return(n=n)
   }else{
      powr <- pnorm(sqrt(n)*theta1-qnorm(1-alpha/sided))
      if (outtype == 2) return(data.frame(cbind(n1=n / (ratio + 1),  n2=ratio * n / (ratio + 1), Power=powr)))
      else if (outtype == 3){
        return(data.frame(cbind(n=n, n1=n / (ratio + 1), n2=ratio * n / (ratio + 1),
               alpha = alpha, sided=sided, beta = 1-powr, Power = powr,
               sd=sd, sd2=sd2, delta1=delta1, delta0=delta0, se=se/sqrt(n))))
      }
      else(return(Power=powr))
    }
}

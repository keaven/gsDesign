#####
# global variables used to eliminate warnings in R CMD check
#####
globalVariables(c("N","EN","Bound","rr","Percent","Outcome"))

gsBinomialExact <- function(k=2, theta=c(.1, .2), n.I=c(50, 100), a=c(3, 7), b=c(20,30))
{
    checkScalar(k, "integer", c(2,Inf), inclusion=c(TRUE, FALSE))
    checkVector(theta, "numeric", interval=0:1, inclusion=c(TRUE, TRUE))
    checkVector(n.I, "integer", interval=c(1, Inf), inclusion=c(TRUE, FALSE))
    checkVector(a, "integer", interval=c(-Inf, Inf), inclusion=c(FALSE, FALSE))
    checkVector(b, "integer", interval=c(1, Inf), inclusion=c(FALSE, FALSE))
    ntheta <- as.integer(length(theta))
    theta <- as.double(theta)
    if (k != length(n.I) || k!=length(a) || k != length(b))
        stop("Lengths of n.I, a, and b must equal k on input")
    m <- c(n.I[1], diff(n.I))
    if (min(m) < 1) stop("n.I must must contain an increasing sequence of positive integers")
    if (min(n.I-a) < 0) stop("Input a-vector must be less than n.I")
    if (min(b-a) <= 0) stop("Input b-vector must be strictly greater than a")
    if (min(diff(a)) < 0) stop("a must contain a non-decreasing sequence of integers")
    if (min(diff(b)) < 0) stop("b must contain a non-decreasing sequence of integers")
    if (min(diff(n.I-b)) < 0)  stop("n.I - b must be non-decreasing")
      
    plo <- matrix(nrow=k, ncol = ntheta)
    rownames(plo) <- paste(array("Analysis ", k), 1:k)
    colnames(plo) <- theta
    phi <- plo
    en <- numeric(ntheta)

    for(h in 1:length(theta))
    {
        p <- theta[h]

        ### c.mat is the recursive function defined in (12.5)
        ### plo and phi are the probabilities of crossing the lower and upper boundaries defined in (12.6)
        c.mat <- matrix(0, ncol=k, nrow=n.I[k]+1)
        for(i in 1:k)
        {
            if(i==1)
            {
                c.mat[,1] <- dbinom(0:n.I[k], m[1], p)
            }
            else
            {
                no.stop <- (a[i-1]+1):(b[i-1]-1)
                no.stop.mat <- matrix(no.stop, byrow=T, nrow=n.I[k]+1, ncol=length(no.stop))
                succ.mat <- matrix(0:n.I[k], byrow=F, ncol=length(no.stop), nrow=n.I[k]+1)
                bin.mat <- matrix(dbinom(succ.mat-no.stop.mat, m[i], p),byrow=F,ncol=length(no.stop), nrow=n.I[k]+1)
                c.mat[,i] <- bin.mat %*% c.mat[no.stop+1,(i-1)] 
            }
            plo[i,h] <- sum(c.mat[(0:n.I[k]) <= a[i], i])
            phi[i,h] <- sum(c.mat[(0:n.I[k]) >= b[i], i])
        }
    }
  
    powr <-   array(1, k) %*% phi
    futile <- array(1, k) %*% plo
    en <- as.vector(n.I %*% (plo + phi) + n.I[k] * (t(array(1,ntheta)) - powr - futile))

    x <- list(k = k, theta = theta, n.I = n.I, 
         lower = list(bound = a, prob = plo ),
         upper = list(bound = b, prob = phi ), en=en)

    class(x) <- c("gsBinomialExact", "gsProbability")
    return(x)
}
# see http://theriac.org/DeskReference/viewDocument.php?id=65&SectionsList=3
binomialSPRT<-function(p0=.05,p1=.25,alpha=.1,beta=.15,minn=10,maxn=35){
  lnA <- log((1-beta)/alpha)
  lnB <- log(beta/(1-alpha))
  a <- log((1-p1)/(1-p0))
  b <- log(p1/p0)-a
  slope <- -a / b
  intercept <- c(lnA,lnB)/b
  upper <- ceiling(slope*(minn:maxn)+intercept[1])
  lower <- floor(slope*(minn:maxn)+intercept[2])
  lower[lower< -1] <- -1
  indx <- (minn:maxn >= upper)|(lower>=0)
  # compute exact boundary crossing probabilities
  y <- gsBinomialExact(k=sum(indx),n.I=(minn:maxn)[indx],
                       theta=c(p0,p1),a=lower[indx],b=upper[indx])
  y$intercept <- intercept
  y$slope <- slope
  y$alpha <- alpha
  y$beta <- beta
  y$p0 <- p0
  y$p1 <- p1
  class(y) <- c("binomialSPRT","gsBinomialExact","gsProbability")
  return(y)
}
plot.gsBinomialExact <- function(x,plottype=1,...){
  if (plottype==6){
    theta<-(max(x$theta)-min(x$theta))*(0:50)/50+min(x$theta)
    y <- gsBinomialExact(k=x$k,theta=theta,n.I=x$n.I,a=x$lower$bound,b=x$upper$bound)
    xx <- data.frame(p=theta,EN=y$en)
    p<-ggplot(data=xx,aes(x=p,y=EN)) + geom_line() + ylab("Expected sample size")
  }else if(plottype==3){
    xx <- data.frame(N=x$n.I,p=x$upper$bound/x$n.I,Bound="Upper")
    xx <- rbind(xx, data.frame(N=x$n.I,p=x$lower$bound/x$n.I,Bound="Lower"))
    p<-ggplot(data=xx,aes(x=N,y=p,group=Bound))+
      geom_point() +
      ylab("Rate at bound")
  }else if (plottype==2){
    theta<-(max(x$theta)-min(x$theta))*(0:50)/50+min(x$theta)
    # compute exact boundary crossing probabilities
    y <- gsBinomialExact(k=x$k,n.I=x$n.I,
                         theta=theta,a=x$lower$bound,b=x$upper$bound)
    # compute probability of crossing upper bound for each theta
    Power <- data.frame(rr=theta,
                        Percent=100*as.vector(matrix(1,ncol=length(y$n.I),nrow=1)%*%
                                          y$upper$prob),
                        Outcome="Reject H0")
    # compute probability of crossing lower bound
    futility <- data.frame(rr=theta,
                           Percent=100*as.vector(matrix(1,ncol=length(y$n.I),nrow=1)%*%
                                             y$lower$prob),
                           Outcome="Reject H1")
    # probability of no boundary crossing
    indeterminate <- data.frame(rr=theta,Percent=100-Power$Percent-futility$Percent,
                                Outcome="Indeterminate")
    #combine and plot
    outcome <- rbind(Power,futility,indeterminate)
    p <- ggplot(data=outcome,aes(x=rr,y=Percent,lty=Outcome))+
      geom_line()+
      xlab("Underlying response rate")
  }else{
    xx <- data.frame(N=x$n.I,x=x$upper$bound,Bound="Upper")
    xx <- rbind(xx, data.frame(N=x$n.I,x=x$lower$bound,Bound="Lower"))
    p<-ggplot(data=xx,aes(x=N,y=x,group=Bound))+
      geom_point() +
      ylab("Number of responses")
  }  
  return(p)
}
plot.binomialSPRT <- function(x,plottype=1,...){
  p <- plot.gsBinomialExact(x,plottype=plottype,...)
  if (plottype==1){
    p <- p + geom_abline(intercept=x$intercept[1], 
                slope=x$slope) +
    geom_abline(intercept=x$intercept[2], 
                slope=x$slope)
  }
  return(p)
}

# predictive probability bound
binomialPP <- function(a=.2, b=.8, theta=c(.2,.4), p1=.4, PP=c(.025,.95), nIA){
  # initiate bounds outside of range of possibility
  upper <- nIA + 1
  lower <- array(-1,length(nIA))
  j <- 1
  # set bounds for each analysis sample size specified
  for(i in nIA){
    q <- 0:i
    # compute posterior probability for value > p1
    # for each possible outcome at analysis i
    post <- pbeta(p1, a + q, b + i - q, lower.tail=F)
    # set upper bound where posterior probability is > PP[2]
    # that response rate is > p1
    upper[j] <- sum(post < PP[2])
    # set lower bound were posterior probability is <= PP[1]
    # that response rate is < p1
    lower[j] <- sum(post <= PP[1])
    j <- j+1
  }
  # compute boundary crossing probabilities under 
  # response rates input in theta
  y <- gsBinomialExact(k=length(nIA),n.I=nIA,
                        theta=theta,a=lower,b=upper)
  # add beta prior parameters to return value
  y$abeta <- a
  y$bbeta <- b
  # add input predictive probability bounds to return value
  y$PP <- PP
  # define class for output
  class(y) <- c("binomialPP","gsBinomialExact","gsProbability")
  return(y)
}


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

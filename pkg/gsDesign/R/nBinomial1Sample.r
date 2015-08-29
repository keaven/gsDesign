# based on code from Marc Schwartz marc_schwartz@me.com 
# The possible sample size vector n needs to be selected in such a fashion
# that it covers the possible range of values that include the true
# minima. My example here does with a finite range and makes the 
# plot easier to visualize.
# NOTE: this is more conservative than using a 2-sided exact test in binom.test
nBinomial1Sample <- function(p0 = 0.90, p1=0.95, 
                             alpha = 0.025, beta=NULL, 
                             n = 200:250, outtype=1, conservative=FALSE){
  Pow = 1-beta
  # Required number of events, given a vector of sample sizes (n)
  # to be considered at the null proportion, for the given alpha
  CritVal <- qbinom(p = 1 - alpha, size = n, prob = p0) + 1
  Alpha <- pbinom(q = CritVal - 1, size=n, prob=p0, lower.tail=FALSE)
  # Get the Power for each n at the alternate hypothesis
  # proportion
  Power <- pbinom(CritVal - 1, n, p1, lower.tail=FALSE)
  bta <- 1 - Power
  if (is.null(beta)) beta <- bta
  if (outtype==3 || is.null(beta)) return(data.frame(p0=p0, p1=p1, alpha=alpha, beta=beta, 
                                                     n=n, b=CritVal,
                                                     alphaR=Alpha, Power=Power))
  if (max(Power)<Pow) return(NULL)
  if (is.null(beta)) beta <- 1-Power
  # Find the smallest sample size yielding at least the required power
  if (!conservative){SampSize <- min(which(Power >= Pow))
  }else if (min(Power >= Pow)==1){SampSize=1
  }else SampSize <- max(which(Power < Pow)) + 1

  if (outtype==2) return(data.frame(p0=p0, p1=p1, alpha=alpha, beta=beta,
                                    n=n[SampSize], b=CritVal[SampSize],
                                    alphaR=Alpha[SampSize], Power=Power[SampSize]))
  return(n[SampSize])
}

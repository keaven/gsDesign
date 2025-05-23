binomialPowerTable <- function(
    pC = c(.8, .9, .95), 
    delta = seq(-.05, .05, .025), 
    n = 70, 
    ratio = 1, 
    alpha = .025, 
    delta0 = -.2,
    scale = "Difference",
    failureEndpoint = TRUE,
    simulation = FALSE,
    exact = FALSE,
    nsim = 1000000) {
  # Create a grid of all combinations of pC and delta
  pC_grid <- expand.grid(pC = pC, delta = delta)
  # Compute the experimental group response rate
  pC_grid <- pC_grid |>
    mutate(pE = pC + delta) |>
    filter(pE < 1) |> # Filter out experimental rate >= 1
    select(pC, delta, pE)
  
  # Compute the probability of non-inferiority using the nBinomial function
  if(!simulation){
    pC_grid$Power <- with(pC_grid, 
                          if(failureEndpoint) {
                            gsDesign::nBinomial(p1 = pE, p2 = pC, delta0 = delta0, 
                                                n = n, alpha = alpha, scale = scale, 
                                                ratio = ratio, sided = 1)
                          }else{
                            gsDesign::nBinomial(p1 = pC, p2 = pE, delta0 = delta0, 
                                                n = n, alpha = alpha, scale = scale, 
                                                ratio = 1 / ratio, sided = 1)
                          }
    )
    return(pC_grid)
  }else{
    simPower()
}


# For each row in long, add a column with power by simulation
# using simBinomial()
# This is a simulation of 10000 trials

# simBinomial(
#   p1,
#   p2,
#   n1,
#   n2,
#   delta0 = 0,
#   nsim = 10000,
#   chisq = 0,
#   adj = 0,
#   scale = "Difference"
# )
# Same arguments as binomialPowerTable above
# Adding number of simulations (nsim) 
# and replacing pC and delta with longTable 
# result from above
simPower <- function(
    longTable,
    n = 70, 
    ratio = 1, 
    alpha = .025, 
    delta0 = -.2,
    scale = "Difference",
    failureEndpoint = TRUE,
    nsim = 10000) {
  # Get sample size per arm
  nC <- round(n / (1 + ratio))
  nE <- n - nC
  # Get pC and pE from longTable
  # and do simulation for each row in the table
  # using the future package and foreach
  # library(future)
  longTable$simPower <-
    foreach(i = 1:nrow(longTable), .combine = "c") %do% {
      pC <- longTable$pC[i]
      pE <- longTable$pE[i]
      if(failureEndpoint) {
        sim <- gsDesign::simBinomial(
          n1 = nE, n2 = nC, p1 = pE, p2 = pC,
          delta0 = delta0, nsim = nsim,
          scale = scale)
        retval <- mean(sim >= qnorm(.975))
      }else{
        sim <- gsDesign::simBinomial(
          n1 = nC, n2 = nE, p1 = pC, p2 = pE,
          delta0 = delta0, nsim = nsim,
          scale = scale)
        retval <- mean(sim >= qnorm(.975))
      }
    }
  return(longTable)
}
}


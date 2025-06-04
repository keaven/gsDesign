#' Power Table for Binomial Tests
#' 
#' @description
#' Creates a power table for binomial tests with various control group response rates and treatment effects.
#' The function can compute power and Type I error either analytically or through simulation.
#' With large simulations, the function is still fast and can produce exact power values to within
#' simulation error.
#' 
#' 
#' @param pC Vector of control group response rates
#' @param delta Vector of treatment effects (differences in response rates)
#' @param n Total sample size
#' @param ratio Ratio of experimental to control sample size
#' @param alpha Type I error rate
#' @param delta0 Non-inferiority margin
#' @param scale Scale for the test ("Difference", "RR", or "OR")
#' @param failureEndpoint Logical indicating if the endpoint is a failure (TRUE) or success (FALSE)
#' @param simulation Logical indicating whether to use simulation (TRUE) or analytical (FALSE) power calculation
#' @param nsim Number of simulations to run when simulation=TRUE
#' @param adj Use continuity correction for the testing (default is 0; only used if simulation=TRUE)
#' @param chisq Chi-squared value for the test (default is 0; only used if simulation=TRUE)
#' 
#' @return A data frame containing:
#' \itemize{
#'   \item pC: Control group response or failure rate
#'   \item delta: Treatment effect
#'   \item pE: Experimental group response or failure rate
#'   \item Power: Power for the test (asymptotic or simulated)
#' }
#' 
#' @details
#' The function binomialPowerTable() creates a grid of all combinations of control group response rates and treatment effects.
#' All out of range values (i.e., where the experimental group response rate is not between 0 and 1) are filtered out.
#' For each combination, it computes the power either analytically using \code{nBinomial} or through
#' simulation using \code{simBinomial}. 
#' When using simulation, the \code{simPowerBinomial} function (not exported) is called
#' internally to perform the simulations.
#' Assuming p is the true probability of a positive test, the simulation standard error is
#' \deqn{SE = \sqrt{p(1-p)/nsim}}.
#' For example, when approximating an underlying Type I error rate of 0.025, the simulation standard error is
#' 0.000156 with 1000000 simulations and the approximated power 95% confidence interval 
#' is 0.025 +/- 1.96 * SE = 0.025 +/- 0.000306.
#' 
#' @examples
#' # Create a power table with analytical power calculation
#' power_table <- binomialPowerTable(
#'   pC = c(0.8, 0.9),
#'   delta = seq(-0.05, 0.05, 0.025),
#'   n = 70
#' )
#' 
#' # Create a power table with simulation
#' power_table_sim <- binomialPowerTable(
#'   pC = c(0.8, 0.9),
#'   delta = seq(-0.05, 0.05, 0.025),
#'   n = 70,
#'   simulation = TRUE,
#'   nsim = 10000
#' )
#' 
#' @seealso \code{\link{nBinomial}}, \code{\link{simBinomial}}
#' 
#' @rdname binomialPowerTable
#' @export
binomialPowerTable <- function(
    pC = c(.8, .9, .95),
    delta = seq(-.05, .05, .025),
    n = 70,
    ratio = 1,
    alpha = .025,
    delta0 = 0,
    scale = "Difference",
    failureEndpoint = TRUE,
    simulation = FALSE,
    nsim = 1000000,  
    adj = 0,
    chisq = 0
) {
  # Create a grid of all combinations of pC and delta
  pC_grid <- expand.grid(pC = pC, delta = delta)
  # Compute the experimental group response rate
  pC_grid <- pC_grid %>%
    mutate(pE = pC + delta) %>%
    filter(pE < 1 & pE > 0 & pC < 1 & pC > 0) %>% # Filter out of range values
    select(pC, delta, pE)

  # Compute the probability of non-inferiority using the nBinomial function
  if (!simulation) {
    pC_grid$Power <- mapply(function(pC, pE, delta) {
      if (n > 0 && pE == pC && delta0 == 0) {
        return(alpha)
      }
      if (failureEndpoint) {
        gsDesign::nBinomial(
          p1 = pE, p2 = pC, delta0 = delta0,
          n = n, alpha = alpha, scale = scale,
          ratio = ratio, sided = 1
        )
      } else {
        gsDesign::nBinomial(
          p1 = pC, p2 = pE, delta0 = delta0,
          n = n, alpha = alpha, scale = scale,
          ratio = 1 / ratio, sided = 1
        )
      }
    }, pC_grid$pC, pC_grid$pE, pC_grid$delta)
    return(pC_grid)
  } else {
    simPowerBinomial(pC_grid, n, ratio, alpha, delta0, scale, failureEndpoint, nsim)
  }
}

simPowerBinomial <- function(
    longTable,
    n = 70,
    ratio = 1,
    alpha = .025,
    delta0 = 0,
    scale = "Difference",
    failureEndpoint = TRUE,
    nsim = 10000) {
  # Get sample size per arm
  nC <- round(n / (1 + ratio))
  nE <- n - nC

  # Initialize vector for simulation results
  Power <- numeric(nrow(longTable))

  # Loop through each row in the table
  for (i in 1:nrow(longTable)) {
    pC <- longTable$pC[i]
    pE <- longTable$pE[i]
    if (failureEndpoint) {
      sim <- gsDesign::simBinomial(
        n1 = nE, n2 = nC, p1 = pE, p2 = pC,
        delta0 = delta0, nsim = nsim,
        scale = scale
      )
      Power[i] <- mean(sim >= qnorm(1 - alpha))
    } else {
      sim <- gsDesign::simBinomial(
        n1 = nC, n2 = nE, p1 = pC, p2 = pE,
        delta0 = delta0, nsim = nsim,
        scale = scale
      )
      Power[i] <- mean(sim >= qnorm(1 - alpha))
    }
  }

  # Add simulation results to the table
  longTable$Power <- Power
  return(longTable)
}


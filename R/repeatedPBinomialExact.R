repeatedPDiff <- function(x = .025, # Input repeated p-value guess
                          experimental_events = c(10, 15, 23), # Experimental group events observed (scalar)
                          analysis = 1, # Analysis being considered 
                          max_events_planned = 100,
                          observed_events = c(16, 50, 110),
                          sf = sfLDOF,  # Spending 
                          # Spending function parameter
                          param = NULL){
  probhi <- gsD$upper$sf(alpha=alpha, t=usTime, param=gsD$upper$param)$spend
  if (length(Z)>1) probhi <- probhi - c(0,probhi[1:(length(Z)-1)])
  # Compute nominal event count bounds for alpha = x (from input)
  
  # Compute difference from targeted crossing probability for targeted analysis 
  return(min(gsBound1(I=n.I, theta=0, a=rep(-20,length(Z)),
                      probhi=probhi)$b-Z))
}
# From the repository root:
# Rscript tests/benchmarks/futility-spending.R installed
# Rscript tests/benchmarks/futility-spending.R source
# Use separate R processes to compare an installed baseline with local edits.
mode <- commandArgs(TRUE)
if (length(mode) && mode[1] == "source") {
  pkgload::load_all(".", quiet = TRUE)
} else {
  library(gsDesign)
}

x <- gsSurv(timing = c(.4, .8), sfu = sfLDOF, sfl = sfLogistic,
            sflpar = c(0, 1), lambdaC = log(2) / 12, T = 36, minfup = 12, hr = .7)
y <- gsSurv(timing = c(.4, .8), sfu = sfLDOF, sfl = sfHSD,
            sflpar = 1, lambdaC = log(2) / 12, T = 36, minfup = 12, hr = .7)
prior <- list(z = c(0, x$delta / 2, x$delta), wgts = c(.1, .3, .6))
cpos <- vapply(1:2, function(i) gsCPOS(i, x, prior$z, prior$wgts), numeric(1))
pos <- gsPOS(y, prior$z, prior$wgts)
cases <- list(
  CP1 = function() gsCPFutilitySpending(y, .15),
  PP1 = function() gsPPFutilitySpending(y, .15),
  CP2 = function() gsCPFutilitySpending(x, c(.15, .2)),
  PP2 = function() gsPPFutilitySpending(x, c(.15, .2)),
  CPOS2 = function() gsCPOSFutilitySpending(x, cpos, prior = prior,
    control = list(start = c(-.2, 1.1))),
  CA2 = function() gsCAFutilitySpending(x, cpos, prior = prior,
    control = list(start = c(-.2, 1.1))),
  POS1 = function() gsPOSFutilitySpending(y, pos, prior = prior,
    control = list(start = 0))
)
results <- lapply(names(cases), function(nm) {
  cases[[nm]]() # warm up
  elapsed <- replicate(3L, system.time(fit <- cases[[nm]]())["elapsed"])
  # Record accuracy from an untimed fit.
  fit <- cases[[nm]]()
  meta <- fit[[switch(nm, CP1 = "cpFutilitySpending", CP2 = "cpFutilitySpending",
    PP1 = "ppFutilitySpending", PP2 = "ppFutilitySpending", CPOS2 = "cposFutilitySpending",
    CA2 = "caFutilitySpending", POS1 = "posFutilitySpending")]]
  stopifnot(max(abs(meta$residual)) <= 1e-4)
  data.frame(case = nm, median_seconds = median(elapsed),
             max_residual = max(abs(meta$residual)))
})
cat("gsDesign", as.character(packageVersion("gsDesign")), "\n")
print(do.call(rbind, results), row.names = FALSE)

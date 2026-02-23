devtools::load_all(".")

# Test 1: gsSurvCalendar with astar=0.1 (now default)
x8 <- gsSurvCalendar(
  test.type = 8, alpha = 0.025, beta = 0.1, astar = 0.1,
  calendarTime = c(12, 24, 36, 48, 60),
  sfu = sfLDOF, sfl = sfHSD, sflpar = -2, sfharm = sfLDPocock,
  lambdaC = log(2) / 36, hr = 0.75, R = 18, minfup = 42
)
cat("=== test.type=8, astar=0.1 ===\n")
cat("Harm spending total (astar):", x8$astar, "\n")
cat("Efficacy:", round(x8$upper$bound, 3), "\n")
cat("Futility:", round(x8$lower$bound, 3), "\n")
cat("Harm:    ", round(x8$harm$bound, 3), "\n")
cat("Final fut == final eff?", abs(x8$lower$bound[x8$k] - x8$upper$bound[x8$k]) < 0.001, "\n")
cat("Final harm != final eff?", abs(x8$harm$bound[x8$k] - x8$upper$bound[x8$k]) > 0.001, "\n")
cat("Harm <= Futility?", all(x8$harm$bound <= x8$lower$bound + 0.001), "\n")
cat("P(harm|H0):", round(sum(x8$harm$prob[, 1]), 4), "\n")

# Test 2: type 4 vs type 8 futility
x4 <- gsSurvCalendar(
  test.type = 4, alpha = 0.025, beta = 0.1,
  calendarTime = c(12, 24, 36, 48, 60),
  sfu = sfLDOF, sfl = sfHSD, sflpar = -2,
  lambdaC = log(2) / 36, hr = 0.75, R = 18, minfup = 42
)
cat("\n=== type 4 vs type 8 futility ===\n")
cat("Type 4:", round(x4$lower$bound, 3), "\n")
cat("Type 8:", round(x8$lower$bound, 3), "\n")
cat("Match?", all(abs(x4$lower$bound - x8$lower$bound) < 0.001), "\n")

# Test 3: type 7
x7 <- gsSurvCalendar(
  test.type = 7, alpha = 0.025, beta = 0.1, astar = 0.1,
  calendarTime = c(12, 24, 36, 48, 60),
  sfu = sfLDOF, sfl = sfHSD, sflpar = -2, sfharm = sfLDPocock,
  lambdaC = log(2) / 36, hr = 0.75, R = 18, minfup = 42
)
cat("\n=== test.type=7 ===\n")
cat("Efficacy:", round(x7$upper$bound, 3), "\n")
cat("Futility:", round(x7$lower$bound, 3), "\n")
cat("Harm:    ", round(x7$harm$bound, 3), "\n")

# Test 4: default astar is 0.1
xd <- gsDesign(k = 4, test.type = 8, delta = 0.3)
cat("\n=== gsDesign default astar ===\n")
cat("astar:", xd$astar, "\n")

# Test 5: all plots
for (pt in c(1, 2, 3, 4, 5, 7)) {
  p <- plot(x8, plottype = pt)
  if (inherits(p, "gg")) print(p)
  cat("plottype", pt, "OK\n")
}
cat("\nAll tests passed!\n")

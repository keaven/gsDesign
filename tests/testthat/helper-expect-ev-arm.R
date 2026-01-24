expect_ev_arm <- function(lambda, drprate, maxstudy, accdur, totalSS, rndprop = 1) {
  if (accdur <= 0 || maxstudy <= 0) {
    return(0)
  }
  if (accdur > maxstudy) {
    accdur <- maxstudy
  }
  rate_total <- lambda + drprate
  if (rate_total <= 0) {
    return(0)
  }
  accrual_rate <- totalSS * rndprop / accdur
  exp_term <- exp(-rate_total * maxstudy)
  integral <- accdur - exp_term * (exp(rate_total * accdur) - 1) / rate_total
  accrual_rate * (lambda / rate_total) * integral
}

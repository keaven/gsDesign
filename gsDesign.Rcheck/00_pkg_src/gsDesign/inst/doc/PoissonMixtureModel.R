## ----include=FALSE--------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  dev = "svg",
  fig.ext = "svg",
  fig.width = 7.2916667,
  fig.asp = 0.618,
  fig.align = "center",
  out.width = "80%"
)

## ----echo=FALSE, message=FALSE, warning=FALSE-----------
library(gsDesign)
library(dplyr)
library(tibble)
library(ggplot2)
library(gt)

## -------------------------------------------------------
# Poisson mixture survival
pPM <- function(x = 0:20, cure_rate = .5, t1 = 10, s1 = .6) {
  theta <- -log(cure_rate)
  lambda <- -log(1 + log(s1) / theta) / t1
  return(exp(-theta * (1 - exp(-lambda * x))))
}
# Poisson mixture hazard rate
hPM <- function(x = 0:20, cure_rate = .5, t1 = 10, s1 = .6) {
  theta <- -log(cure_rate)
  lambda <- -log(1 + log(s1) / theta) / t1
  return(theta * lambda * exp(-lambda * x))
}

## -------------------------------------------------------
# Control group assumptions for three Poisson mixture cure models
cure_rate <- c(.5, .35, .55)
# Second time point for respective models
t1 <- c(24, 24, 24)
# Survival rate at 2nd time point for respective models
s1 <- c(.65, .5, .68)
time_unit <- "month"
# Hazard ratio for experimental versus control for respective models
hr <- c(.7, .75, .7)
# Total study duration
study_duration <- c(48, 48, 56)
# Number of bins for piecewise approximation of Poisson mixture rates
bins <- 5

## -------------------------------------------------------
# This code should be updated by user for their scenario
# Enrollment duration by scenario
enroll_duration <- c(12, 12, 20)
# Dropout rate (exponential failure rate per time unit) by scenario
dropout_rate <- c(.002, .001, .001)

## ----warning=FALSE, message=FALSE, echo=FALSE-----------
t <- seq(0, study_duration[1] + 12, (study_duration[1] + 12) / bins)
survival <- NULL
for (scenario in 1:length(cure_rate)) {
  survival <- rbind(
    survival,
    tibble(
      Scenario = scenario, Treatment = "Control", Time = t,
      Survival = pPM(
        x = t, cure_rate = cure_rate[scenario],
        t1 = t1[scenario], s1 = s1[scenario]
      )
    ),
    tibble(
      Scenario = scenario, Treatment = "Experimental", Time = t,
      Survival = pPM(
        x = t, cure_rate = cure_rate[scenario]^hr[scenario],
        t1 = t1[scenario], s1 = s1[scenario]^hr[scenario]
      )
    )
  )
}
survival <- survival |> mutate(Scenario = as.factor(Scenario))
ggplot(survival, aes(x = Time, y = Survival, lty = Treatment, col = Scenario)) +
  geom_point() +
  scale_x_continuous(breaks = seq(0, study_duration[1] + 12, (study_duration[1] + 12) / bins)) +
  geom_line() +
  ggtitle("Poisson Mixture Model with Proportional Hazards") +
  theme(legend.position = "bottom")

## ----echo = FALSE---------------------------------------
hazard <- survival |>
  filter(Time > 0) |>
  group_by(Scenario, Treatment) |>
  mutate(
    cumulative_hazard = -log(Survival),
    time_lagged = lag(Time, default = 0),
    hazard_rate = (cumulative_hazard - lag(cumulative_hazard, default = 0)) /
      (Time - time_lagged),
  ) |>
  ungroup()
hazardC1 <- tibble(time_lagged = seq(0, study_duration[1] + 12, .5)) |>
  mutate(hazard_rate = hPM(time_lagged, cure_rate = cure_rate[1], t1 = t1[1], s1 = s1[1]))
ggplot() +
  geom_step(
    data = hazard |> filter(Treatment == "Control", Scenario == 1),
    aes(x = time_lagged, y = hazard_rate)
  ) +
  ylab("Hazard rate") +
  xlab("Time") +
  ggtitle("Step Function Approximated Hazard Rate for Design Cure Model",
    subtitle = "Control Group, Scenario 1"
  ) +
  geom_line(data = hazardC1, aes(x = time_lagged, y = hazard_rate), lty = 2) +
  annotate(geom = "text", x = 35, y = .02, label = "Dashed line shows actual hazard rate")

## ----echo=FALSE, echo=FALSE-----------------------------
# DO NOT ALTER CODE
event_accrual <- NULL
for (scenario in 1:length(cure_rate)) {
  control_accrual <- tibble(Time = 0, Events = 0, Treatment = "Control")
  experimental_accrual <- control_accrual |> mutate(Treatment = "Experimental")
  control <- hazard |> filter(Scenario == scenario, Treatment == "Control")
  for (T in 1:(study_duration[1] + 12)) {
    xc <- eEvents(
      lambda = control$hazard_rate, S = (control$Time - control$time_lagged)[1:(bins - 1)],
      gamma = 100 / enroll_duration[scenario], R = enroll_duration[scenario], eta = dropout_rate[scenario],
      T = T, Tfinal = study_duration[1]
    )
    control_accrual <- rbind(control_accrual, tibble(Time = xc$T, Events = xc$d, Treatment = "Control"))
    xe <- eEvents(
      lambda = control$hazard_rate * hr[scenario], S = (control$Time - control$time_lagged)[1:(bins - 1)],
      gamma = 100 / enroll_duration[scenario], R = enroll_duration[scenario], eta = dropout_rate[scenario],
      T = T, Tfinal = study_duration[1]
    )
    experimental_accrual <- rbind(experimental_accrual, tibble(Time = xe$T, Events = xe$d, Treatment = "Experimental"))
  }
  overall_accrual <- rbind(control_accrual, experimental_accrual) |>
    group_by(Time) |>
    summarize(Events = sum(Events), Scenario = scenario, Hypothesis = "H1")
  # Get max planned events for enrollment rates for scenario 1 under H1
  # This will be modified for the design, but relative accrual will remain the same
  if (scenario == 1) max_events_planned <- overall_accrual$Events[study_duration[1] + 1]
  overallH0_accrual <- rbind(control_accrual, control_accrual) |>
    group_by(Time) |>
    summarize(Events = sum(Events), Scenario = scenario, Hypothesis = "H0") |>
    ungroup()
  # Combine for all scenarios
  event_accrual <- rbind(
    event_accrual,
    overall_accrual,
    overallH0_accrual
  )
}
event_accrual <- event_accrual |> mutate(EF = Events / max_events_planned, Scenario = as.factor(Scenario))
ggplot(event_accrual, aes(x = Time, y = EF, color = Scenario, lty = Hypothesis)) +
  geom_line() +
  scale_y_continuous(breaks = seq(0, 2, .2)) +
  scale_x_continuous(breaks = seq(0, study_duration[1] + 12, 12)) +
  ylab("Fraction of planned events") +
  ggtitle(
    "Fraction of planned events expected over time by scenario",
    subtitle = "Fraction based on planned final events for scenario 1"
  ) +
  theme(legend.position = "bottom")

## -------------------------------------------------------
# Calendar time from start of randomization until each analysis time
calendarTime <- c(14, 24, 36, 48)

## -------------------------------------------------------
# Get hazard rate info for Scenario 1 control group
control <- hazard |> filter(Scenario == 1, Treatment == "Control")
# Failure rates
lambdaC <- control$hazard_rate
# Interval durations
S <- (control$Time - control$time_lagged)[1:(bins - 1)]
# 1-sided Type I error
alpha <- 0.025
# Type II error (1 - power)
beta <- .1
# Test type 6: asymmetric 2-sided design, non-binding futility bound
test.type <- 6
# 1-sided Type I error used for safety (for asymmetric 2-sided design)
astar <- .2
# Spending functions (sfu, sfl) and parameters (sfupar, sflpar)
sfu <- sfHSD 
sfupar <- -3 
sfl <- sfLDPocock # Near-equal Z-values for each analysis
sflpar <- NULL # Not needed for Pocock spending
# Dropout rate (exponential parameter per unit of time)
dropout_rate <- 0.002
# Experimental / control randomization ratio
ratio <- 1

## -------------------------------------------------------
design_calendar <-
  gsSurvCalendar(
    calendarTime = calendarTime,
    spending = "calendar",
    alpha = alpha,
    beta = beta,
    astar = astar,
    test.type = test.type,
    hr = hr[1],
    R = enroll_duration[1],
    gamma = 1,
    minfup = study_duration[1] - enroll_duration[1],
    ratio = ratio,
    sfu = sfu,
    sfupar = sfupar,
    sfl = sfl,
    sflpar = sflpar,
    lambdaC = lambdaC,
    S = S
  )
design_calendar |>
  gsBoundSummary(exclude = c("B-value", "CP", "CP H1", "PP")) |>
  gt() |>
  tab_header(
    title = "Calendar-Based Design",
    subtitle = "Calendar Spending"
  )


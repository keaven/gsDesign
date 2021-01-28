pkgname <- "gscounts"
source(file.path(R.home("share"), "R", "examples-header.R"))
options(warn = 1)
library('gscounts')

base::assign(".oldSearch", base::search(), pos = 'CheckExEnv')
base::assign(".old_wd", base::getwd(), pos = 'CheckExEnv')
cleanEx()
nameEx("design_gsnb")
### * design_gsnb

flush(stderr()); flush(stdout())

### Name: design_gsnb
### Title: Group sequential design with negative binomial outcomes
### Aliases: design_gsnb

### ** Examples

# Calculate the sample sizes for a given accrual period and study period (without futility)
out <- design_gsnb(rate1 = 0.0875, rate2 = 0.125, dispersion = 5, 
                   power = 0.8, timing = c(0.5, 1), esf = obrien,
                   ratio_H0 = 1, sig_level = 0.025,
                   study_period = 3.5, accrual_period = 1.25, random_ratio = 1)
out

# Calculate the sample sizes for a given accrual period and study period with binding futility
out <- design_gsnb(rate1 = 0.0875, rate2 = 0.125, dispersion = 5, 
                   power = 0.8, timing = c(0.5, 1), esf = obrien,
                   ratio_H0 = 1, sig_level = 0.025, study_period = 3.5, 
                   accrual_period = 1.25, random_ratio = 1, futility = "binding", 
                   esf_futility = obrien)
out


# Calculate study period for given recruitment times
expose <- seq(0, 1.25, length.out = 1042)
out <- design_gsnb(rate1 = 0.0875, rate2 = 0.125, dispersion = 5, 
                   power = 0.8, timing = c(0.5, 1), esf = obrien,
                   ratio_H0 = 1, sig_level = 0.025, t_recruit1 = expose, 
                   t_recruit2 = expose, random_ratio = 1)
out

# Calculate sample size for a fixed exposure time
out <- design_gsnb(rate1 = 0.0875, rate2 = 0.125, dispersion = 5, 
                   power = 0.8, timing = c(0.5, 1), esf = obrien,
                   ratio_H0 = 1, sig_level = 0.025,
                   followup_max = 0.5, random_ratio = 1)
                   
# Different timing for efficacy and futility analyses
 design_gsnb(rate1 = 1, rate2 = 2, dispersion = 5,
             power = 0.8, esf = obrien,
             ratio_H0 = 1, sig_level = 0.025, study_period = 3.5,
             accrual_period = 1.25, random_ratio = 1, futility = "binding",
             esf_futility = pocock, 
             timing_eff = c(0.8, 1),
             timing_fut = c(0.2, 0.5, 1))                    



cleanEx()
nameEx("design_nb")
### * design_nb

flush(stderr()); flush(stdout())

### Name: design_nb
### Title: Clinical trials with negative binomial outcomes
### Aliases: design_nb

### ** Examples

# Calculate sample size for given accrual period and study duration assuming uniformal accrual
out <- design_nb(rate1 = 0.0875, rate2 = 0.125, dispersion = 5, power = 0.8,
                 ratio_H0 = 1, sig_level = 0.025,
                 study_period = 4, accrual_period = 1, random_ratio = 2)
out

# Calculate sample size for a fixed exposure time of 0.5 years
out <- design_nb(rate1 = 4.2, rate2 = 8.4, dispersion = 3, power = 0.8,
                 ratio_H0 = 1, sig_level = 0.025,
                 followup_max = 0.5, random_ratio = 2)
out

# Calculate study period for given recruitment time
t_recruit1 <- seq(0, 1.25, length.out = 1200)
t_recruit2 <- seq(0, 1.25, length.out = 800)
out <- design_nb(rate1 = 0.0875, rate2 = 0.125, dispersion = 5, power = 0.8,
                 ratio_H0 = 1, sig_level = 0.025,
                 t_recruit1 = t_recruit1, t_recruit2 = t_recruit2)



cleanEx()
nameEx("get_calendartime_gsnb")
### * get_calendartime_gsnb

flush(stderr()); flush(stdout())

### Name: get_calendartime_gsnb
### Title: Calendar time of data looks
### Aliases: get_calendartime_gsnb

### ** Examples

# Calendar time at which 50%, 75%, and 100% of the maximum information is attained
# 100 subjects in each group are recruited uniformly over 1.5 years
# Study ends after two years, i.e. follow-up times vary between 2 and 0.5 years 
get_calendartime_gsnb(rate1 = 0.1, 
                      rate2 = 0.125, 
                      dispersion = 5, 
                      t_recruit1 = seq(0, 1.5, length.out = 100), 
                      t_recruit2 = seq(0, 1.5, length.out = 100),
                      timing = c(0.5, 0.75, 1),
                      followup1 = seq(2, 0.5, length.out = 100),
                      followup2 = seq(2, 0.5, length.out = 100)) 



cleanEx()
nameEx("get_info_gsnb")
### * get_info_gsnb

flush(stderr()); flush(stdout())

### Name: get_info_gsnb
### Title: Information level for log rate ratio
### Aliases: get_info_gsnb

### ** Examples

# Calculates information level for case of 10 subjects per group
# Follow-up times of subjects in each group range from 1 to 3
get_info_gsnb(rate1 = 0.1,
              rate2 = 0.125,
              dispersion = 4, 
              followup1 = seq(1, 3, length.out = 10), 
              followup2 = seq(1, 3, length.out = 10))



cleanEx()
nameEx("obrien")
### * obrien

flush(stderr()); flush(stdout())

### Name: obrien
### Title: obrien
### Aliases: obrien

### ** Examples

# O'Brien-Fleming-type error spending function
obrien(t = c(0.5, 1), sig_level = 0.025)



cleanEx()
nameEx("pocock")
### * pocock

flush(stderr()); flush(stdout())

### Name: pocock
### Title: pocock
### Aliases: pocock

### ** Examples

# Pocock-type error spending function
pocock(t = c(0.5, 1), sig_level = 0.025)



### * <FOOTER>
###
cleanEx()
options(digits = 7L)
base::cat("Time elapsed: ", proc.time() - base::get("ptime", pos = 'CheckExEnv'),"\n")
grDevices::dev.off()
###
### Local variables: ***
### mode: outline-minor ***
### outline-regexp: "\\(> \\)?### [*]+" ***
### End: ***
quit('no')

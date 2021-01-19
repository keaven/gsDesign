pkgname <- "coprimary"
source(file.path(R.home("share"), "R", "examples-header.R"))
options(warn = 1)
library('coprimary')

base::assign(".oldSearch", base::search(), pos = 'CheckExEnv')
base::assign(".old_wd", base::getwd(), pos = 'CheckExEnv')
cleanEx()
nameEx("coprimary-package")
### * coprimary-package

flush(stderr()); flush(stdout())

### Name: coprimary-package
### Title: Sample size calculation for two primary time-to-event endpoints
###   in phase III clinical trials
### Aliases: coprimary-package coprimary
### Keywords: sample size multiple endpoints co-primary clinical trial

### ** Examples


#####################################################################################
############ Design superiority: two-sided with two co-primary endpoints ############
#####################################################################################
## - For endpoint 1: 2 target variables for the health related quality of life with 3-year 
## rate without HRQoL deterioration Se=0.75 and Sc=0.67, alpha1=c(0.01,0.01)
## - For endpoint 2: 4-year survival rates Se=0.86 and Sc=0.80, alpha2=c(0.015,0.015)
## - with accrual duration of 3 years, study duration of 6 years, power=0.90, 
## look=c(2,c(1,1),0.5), and default values i.e  pe=0.5, fup=0, dropout=0

nc1 <- ncoprimary(design=c(1,2),Survhyp1=c(1,5,0.75,0.67),Survhyp2=c(1,5,0.86,0.80),
alpha1=c(0.01,0.01),alpha2=c(0.015,0.015),duraccrual=3,durstudy=6,power=0.90,
look=c(2,c(1,1),0.5),dqol=2)


#####################################################################################
############ Design superiority: one-sided with two co-primary endpoints ############
#####################################################################################
## - For endpoint 1: 2-year hazard ratio hype=0.86 and Sc=0.62, alpha1=0.05
## - For endpoint 2: 3-year survival rates hype=0.81 and Sc=0.57, alpha2=0.05
## - with accrual duration of 2 years, study duration of 10 years and default values i.e
## power=0.90, pe=0.5, look=1, fup=0, dropout=0, dqol=0


nc2 <- ncoprimary(design=c(1,1),Survhyp1=c(2,2,0.86,0.62),Survhyp2=c(2,3,0.81,0.57),
alpha1=0.05,alpha2=0.05,duraccrual=2,durstudy=10)

#####################################################################################
###############   Design non-inferiority with one primary endpoint ##################
#####################################################################################
## 5-year rate without HRQoL deterioration are equal under the alternative hypothesis, 
## i.e Se=0.60 and Sc=SeA=0.70, with alpha=0.05, accrual duration of 4 years,study duration 
## of 8 years, two interim analysis after the occurence 1/3 and 2/3 of the events, 3 target 
## variables for the health related quality of life and default values i.e power=0.80, pe=0.5, 
## fup=0, dropout=0

ns <- nsurvival(design=c(2),Survhyp=c(1,5,0.60,0.70, 0.70),alpha=0.05,duraccrual=4,
durstudy=8,look=c(3,c(1,1),c(1/3,2/3)), dqol=3)




cleanEx()
nameEx("ncoprimary")
### * ncoprimary

flush(stderr()); flush(stdout())

### Name: ncoprimary
### Title: Sample size calculation in clinical trials with two co-primary
###   time-to-event endpoints
### Aliases: ncoprimary

### ** Examples


####################################################################################
############ Design superiority:one-sided with two co-primary endpoints ############
####################################################################################
## - For endpoint 1: 3-year survival rates Se=0.75 and Sc=0.65, alpha1=0.02
## - For endpoint 2: 4-year survival rates Se=0.70 and Sc=0.59, alpha2=0.03
## with accrual duration of 2 years, study duration of 4 years and default values i.e 
## power=0.80, pe=0.5, look=1, fup=0, dropout=0, dqol=0 

nc1 <- ncoprimary(design=c(1,1),Survhyp1=c(1,3,0.75,0.65),Survhyp2=c(1,4,0.70,0.59),
alpha1=0.02,alpha2=0.03,duraccrual=2,durstudy=4)


#####################################################################################
 ############ Design superiority:two-sided with two co-primary endpoints ############
#####################################################################################
## - For endpoint 1: 2 target variables for the health related quality of life with 3-year 
## rate without HRQoL deterioration Se=0.75 and Sc=0.67, alpha1=c(0.01,0.01)
## - For endpoint 2: 4-year survival rates Se=0.86 and Sc=0.80, alpha2=c(0.015,0.015)
## with accrual duration of 3 years, study duration of 6 years, power=0.90, look=c(2,c(1,1),0.5), 
## and default values i.e  pe=0.5, fup=0, dropout=0

nc2 <- ncoprimary(design=c(1,2),Survhyp1=c(1,5,0.75,0.67),Survhyp2=c(1,5,0.86,0.80),
alpha1=c(0.01,0.01),alpha2=c(0.015,0.015),duraccrual=3,durstudy=6, power=0.90,
look=c(2,c(1,1),0.5),dqol=2)


#####################################################################################
##############  Design non-inferiority with two co-primary endpoints ################
#####################################################################################
## - For endpoint 1: 3-year survival rates Se=0.75 and Sc=SeA=0.75, alpha1=0.01
## - For endpoint 2: 4-year survival rates Se=0.67 and Sc=SeA=0.80, alpha2=0.04
## with accrual duration of 2 years, study duration of 6 years, power=0.95, pe=0.60 and 
## default values i.e look=1, fup=0, dropout=0, dqol=0

nc3 <- ncoprimary(design=c(2),Survhyp1=c(1,4,0.65,0.75,0.75),Survhyp2=c(1,5,0.67,0.80,0.80),
alpha1=0.01,alpha2=0.04,duraccrual=2,durstudy=6,power=0.95,pe=0.60)

####################################################################################
################  Design superiority with two co-primary endpoints ################# 
####################################################################################

## - For endpoint 1: 2-year survival rate Sc=0.65 and log hazard equivalence margin delta=0.15 
## and alpha1=0.025
## - For endpoint 2: 1-year survival rate Sc=0.70 and log hazard equivalence margin delta=0.10 
## and alpha2=0.025
## with accrual duration of 3 years, study duration of 5 years, drop out hazard rate of 0.025 
## per arm and default values i.e power=0.80, pe=0.5, look=1, fup=0, dqol=0 

nc4 <- ncoprimary(design=c(3),Survhyp1=c(2,0.15,0.65),Survhyp2=c(1,0.10,0.70),alpha1=0.025,
alpha2=0.025,duraccrual=3,durstudy=5,dropout=c(1,0.025,0.025))





cleanEx()
nameEx("nsurvival")
### * nsurvival

flush(stderr()); flush(stdout())

### Name: nsurvival
### Title: Sample size calculation in clinical trials with one primary
###   survival endpoint
### Aliases: nsurvival

### ** Examples

#############################################################
###############  Design superiority:one-sided ###############
#############################################################
## 7-year survival rates Se=0.57 and Sc=0.53, alpha=0.05, accrual duration of 4 years, 
## study duration of 8 years and default values i.e power=0.80, pe=0.5, look=1, fup=0, 
## dropout=0, dqol=0
 
ns1 <- nsurvival(design=c(1,1),Survhyp=c(1,7,0.57,0.53),alpha=0.05,duraccrual=4,durstudy=8)

############################################################
############### Design superiority:two-sided ###############
############################################################
## 5-year rate without HRQoL deterioration Se=0.75 and Sc=0.65, alpha=c(0.04,0.01), accrual 
## duration of 2 years, study duration of 6 years, power=0.90, pe=0.55, follow-up 5 years, 
## 3 target variables for health related quality of life and default values i.e look=1, dropout=0

ns2 <- nsurvival(design=c(1,2),Survhyp=c(1,5,0.75,0.65),alpha=c(0.04,0.01),duraccrual=2,
durstudy=6,power=0.90,pe=0.55,fup=c(1,5),dqol=3)  

###########################################################
###############   Design non-inferiority ##################
###########################################################
## 5-year survival rates are equal under the alternative hypothesis, i.e Se=0.60 and Sc=SeA=0.70, 
## with alpha=0.05, accrual duration of 4 years, study duration of 8 years, two interim analysis 
## after the occurence 1/3 and 2/3 of the events and default values i.e power=0.80, pe=0.5, fup=0, 
## dropout=0, dqol=0 

ns3 <- nsurvival(design=c(2),Survhyp=c(1,5,0.60,0.70, 0.70),alpha=0.05,duraccrual=4,
durstudy=8,look=c(3,c(1,1),c(1/3,2/3)))

##########################################################
###############    Design superiority   ##################
##########################################################
## 3-year rate without HRQoL deterioration Sc=0.80 and log hazard equivalence margin delta=0.1 
## with alpha=0.10, accrual duration of 3 years, study duration of 5 years, drop out hazard rate 
## of 0.05 per arm, 2 target variables for health related quality of life and default values i.e 
## power=0.80, pe=0.5, look=1, fup=0

ns4 <- nsurvival(design=c(3),Survhyp=c(3,0.10,0.80),alpha=0.10,duraccrual=3,durstudy=5,
dropout=c(1,0.05,0.05),dqol=2)




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

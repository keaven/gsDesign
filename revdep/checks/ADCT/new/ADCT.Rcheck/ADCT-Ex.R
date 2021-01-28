pkgname <- "ADCT"
source(file.path(R.home("share"), "R", "examples-header.R"))
options(warn = 1)
library('ADCT')

base::assign(".oldSearch", base::search(), pos = 'CheckExEnv')
base::assign(".old_wd", base::getwd(), pos = 'CheckExEnv')
cleanEx()
nameEx("BioInfo.Power")
### * BioInfo.Power

flush(stderr()); flush(stdout())

### Name: BioInfo.Power
### Title: Power calculation for Biomarker-Informed Design with
###   Hierarchical Model
### Aliases: BioInfo.Power

### ** Examples

## Determine critical value Zalpha for alpha (power) =0.025
u0y=c(0,0,0); u0x=c(0,0,0)
BioInfo.Power(uCtl=0, u0y, u0x, rhou=1, suy=0, sux=0, rho=1, sy=4, sx=4,
 Zalpha=2.772, N1=100, N=300, nArms=3, nSims=1000)
## Power simulation
u0y=c(1,0.5,0.2)
u0x=c(2,1,0.5)
BioInfo.Power(uCtl=0, u0y, u0x, rhou=0.2, suy=0.2, sux=0.2, rho=0.2, sy=4, sx=4,
 Zalpha=2.772, N1=100, N=300, nArms=3, nSims=500)




cleanEx()
nameEx("CopriEndpt.Power")
### * CopriEndpt.Power

flush(stderr()); flush(stdout())

### Name: CopriEndpt.Power
### Title: Power Calculation for Two Coprimary Endpoints.
### Aliases: CopriEndpt.Power

### ** Examples

# Example in Chang (2014) page  272
CopriEndpt.Power(n=197, tau=0.5, mu1=0.2, mu2=0.2, rho=0.5,
alpha1=0.0025, alpha2=0.024, alternative="one.sided")
 sapply(c(-0.8,-0.5,-0.2,0,0.2,0.5,0.8),CopriEndpt.Power,
n=197, tau=0.5, mu1=0.2, mu2=0.2, alpha1=0.0025, alpha2=0.024, alternative="one.sided")



cleanEx()
nameEx("OneArm.CondPower")
### * OneArm.CondPower

flush(stderr()); flush(stdout())

### Name: OneArm.CondPower
### Title: Conditional power for one-arm, two-stage design with two primary
###   endpoints
### Aliases: OneArm.CondPower

### ** Examples

# Example in Chang (2014) page  277
OneArm.CondPower(mu1=0.1333, mu2=0.1605, n1=130, n2=130, rho=0.35,
 tau=0.5, alpha2=0.024, alternative = "one.sided")
OneArm.CondPower(mu1=0.1333, mu2=0.1605, n1=130, n2=414, rho=0.35,
 tau=0.5, alpha2=0.024, alternative = "one.sided")



cleanEx()
nameEx("TwoArms.CondPower")
### * TwoArms.CondPower

flush(stderr()); flush(stdout())

### Name: TwoArms.CondPower
### Title: Conditional power for two-group design, two-stage design with
###   two primary endpoints
### Aliases: TwoArms.CondPower

### ** Examples

# Example in Chang (2014) page  278
TwoArms.CondPower(mu1=0.28, sigma1=1.9, mu2=0.35, sigma2=2.2, n1=340, n2=340,
rho=0.3, tau=0.5, alpha2=0.024, alternative = "one.sided")
TwoArms.CondPower(mu1=0.28, sigma1=1.9, mu2=0.35, sigma2=2.2, n1=340, n2=482,
rho=0.3, tau=0.5, alpha2=0.024, alternative = "one.sided")
TwoArms.CondPower(mu1=0.32, sigma1=2, mu2=0.4, sigma2=1.8, n1=340, n2=340,
rho=0.3, tau=0.5, alpha2=0.024, alternative = "one.sided")



cleanEx()
nameEx("TwoGrpCopriEndpt.SimPower")
### * TwoGrpCopriEndpt.SimPower

flush(stderr()); flush(stdout())

### Name: TwoGrpCopriEndpt.SimPower
### Title: Power Simulation for Two Group Two Coprimary Endpoints Group
###   Sequential Design.
### Aliases: TwoGrpCopriEndpt.SimPower

### ** Examples

# Example in Chang (2014) page  275
TwoGrpCopriEndpt.SimPower(mu11=0.2,mu12=0.25, mu21=0.005, mu22=0.015, rho=0.25,
tau=0.5, alpha1=0.0025, alpha2=0.024, alternative = "two.sided",Nmax=584, B=10000)



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

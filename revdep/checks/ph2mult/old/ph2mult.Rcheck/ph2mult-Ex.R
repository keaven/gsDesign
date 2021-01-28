pkgname <- "ph2mult"
source(file.path(R.home("share"), "R", "examples-header.R"))
options(warn = 1)
library('ph2mult')

base::assign(".oldSearch", base::search(), pos = 'CheckExEnv')
base::assign(".old_wd", base::getwd(), pos = 'CheckExEnv')
cleanEx()
nameEx("IUT.design")
### * IUT.design

flush(stderr()); flush(stdout())

### Name: IUT.design
### Title: The design function for multinomial designs under
###   intersection-union test (IUT)
### Aliases: IUT.design

### ** Examples

p01=0.1; p02=0.9
## Calculate type I error for single-stage design
IUT.design(method="s1",s1.rej=18, t1.rej = 12, n1=80,
s1.rej.delta = 1, t1.rej.delta = 1, n1.delta=1,
p0.s = 0.15, p0.t = 0.25, p1.s = 0.3, p1.t= 0.1, output = "minimax")

## Designs for two-stage design, output PET and EN under null hypothesis
IUT.design(method="s2",s1.rej = 11, t1.rej = 4, s1.acc=8, t1.acc = 5, n1=40,
s2.rej=18, t2.rej = 11, n2=40, p0.s = 0.15, p0.t = 0.25, p1.s = 0.3, p1.t= 0.1, output = "minimax")
IUT.design(method="s2",s1.rej = 11, t1.rej = 4, s1.acc=8, t1.acc = 5, n1=40,
s2.rej=18, t2.rej = 11, n2=40, p0.s = 0.15, p0.t = 0.25, p1.s = 0.3, p1.t= 0.1, output = "optimal")




cleanEx()
nameEx("IUT.power")
### * IUT.power

flush(stderr()); flush(stdout())

### Name: IUT.power
### Title: The power function for multinomial designs under
###   intersection-union test (IUT)
### Aliases: IUT.power

### ** Examples

p01=0.1; p02=0.9
## Calculate type I error for single-stage design
max(IUT.power(method="s1", s1.rej=6, t1.rej=19, n1=25, p.s=p01, p.t=0),
IUT.power(method="s1", s1.rej=6, t1.rej=19, n1=25, p.s=1-p02, p.t=p02))
## Calculate power for single-stage design
IUT.power(method="s1", s1.rej=6, t1.rej=19, n1=25, p.s=p01+0.2, p.t=p02-0.2)

## Calculate type I error for two-stage design
max(IUT.power(method="s2", s1.rej=4, t1.rej=9, s1.acc=0, t1.acc=13, n1=13,
s2.rej=6, t2.rej=18, n2=11, p.s=p01, p.t=0),
IUT.power(method="s2", s1.rej=4, t1.rej=9, s1.acc=0, t1.acc=13, n1=13,
s2.rej=6, t2.rej=18, n2=11, p.s=1-p02, p.t=p02))
## Output PET and EN under null hypothesis
IUT.power(method="s2", s1.rej=4, t1.rej=9, s1.acc=0, t1.acc=13, n1=13,
s2.rej=6, t2.rej=18, n2=11, p.s=p01, p.t=p02, output.all=TRUE)[-1]
## Calculate power for two-stage design
IUT.power(method="s2", s1.rej=4, t1.rej=9, s1.acc=0, t1.acc=13, n1=13,
s2.rej=6, t2.rej=18, n2=11, p.s=p01+0.2, p.t=p02-0.2)

## Calculate type I error for two-stage design stopping for futility only,
## output PET and EN under null hypothesis
max(IUT.power(method="s2.f", s1.acc=0, t1.acc=13, n1=13,
s2.rej=6, t2.rej=18, n2=11, p.s=p01, p.t=0),
IUT.power(method="s2.f", s1.acc=0, t1.acc=13, n1=13,
s2.rej=6, t2.rej=18, n2=11, p.s=1-p02, p.t=p02))
## Output PET and EN under null hypothesis
IUT.power(method="s2.f", s1.acc=0, t1.acc=13, n1=13,
s2.rej=6, t2.rej=18, n2=11, p.s=p01, p.t=p02, output.all=TRUE)[-1]
## Calculate power for two-stage design
IUT.power(method="s2.f", s1.acc=0, t1.acc=13, n1=13,
s2.rej=6, t2.rej=18, n2=11, p.s=p01+0.2, p.t=p02-0.2)



cleanEx()
nameEx("UIT.design")
### * UIT.design

flush(stderr()); flush(stdout())

### Name: UIT.design
### Title: The design function for multinomial designs under
###   union-intersection test (UIT)
### Aliases: UIT.design

### ** Examples


## Calculate type I error for single-stage design
UIT.design(method="s1",s1.rej=18, t1.rej = 12, n1=80,
p0.s = 0.15, p0.t = 0.25, p1.s = 0.3, p1.t= 0.1)

## Designs for two-stage design, output PET and EN under null hypothesis
UIT.design(method="s2",s1.rej = 11, t1.rej = 4, s1.acc=8, t1.acc = 5, n1=40,
s2.rej=18, t2.rej = 11, n2=40, p0.s = 0.15, p0.t = 0.25, p1.s = 0.3, p1.t= 0.1, output.all=TRUE)




cleanEx()
nameEx("UIT.power")
### * UIT.power

flush(stderr()); flush(stdout())

### Name: UIT.power
### Title: The power function for multinomial designs under
###   union-intersection test (UIT)
### Aliases: UIT.power

### ** Examples

p01=0.1; p02=0.9
## Calculate type I error for single-stage design
UIT.power(method="s1", s1.rej=6, t1.rej=19, n1=25, p.s=p01, p.t=p02)
## Calculate power for single-stage design
UIT.power(method="s1", s1.rej=6, t1.rej=19, n1=25, p.s=p01+0.2, p.t=p02-0.2)

## Calculate type I error for two-stage design, output PET and EN under null hypothesis
UIT.power(method="s2", s1.rej=4, t1.rej=9, s1.acc=0, t1.acc=13, n1=13,
s2.rej=6, t2.rej=18, n2=11, p.s=p01, p.t=p02, output.all=TRUE)
## Calculate power for two-stage design
UIT.power(method="s2", s1.rej=4, t1.rej=9, s1.acc=0, t1.acc=13, n1=13,
s2.rej=6, t2.rej=18, n2=11, p.s=p01+0.2, p.t=p02-0.2)

## Calculate type I error for two-stage design stopping for futility only,
## output PET and EN under null hypothesis
UIT.power(method="s2.f", s1.acc=0, t1.acc=13, n1=13,
s2.rej=6, t2.rej=18, n2=11, p.s=p01, p.t=p02, output.all=TRUE)
## Calculate power for two-stage design
UIT.power(method="s2.f", s1.acc=0, t1.acc=13, n1=13,
s2.rej=6, t2.rej=18, n2=11, p.s=p01+0.2, p.t=p02-0.2)



cleanEx()
nameEx("binom.design")
### * binom.design

flush(stderr()); flush(stdout())

### Name: binom.design
### Title: The design function for Simon (admissible) two-stage design
### Aliases: binom.design

### ** Examples

binom.design(type = "admissible", p0 = 0.15, p1 = 0.3, signif.level = 0.05, power.level = 0.9,
plot.out = TRUE)



cleanEx()
nameEx("binom.power")
### * binom.power

flush(stderr()); flush(stdout())

### Name: binom.power
### Title: The power function for Simon (admissible) two-stage design
### Aliases: binom.power

### ** Examples

## Calculate type I error
binom.power(5, 31, 16, 76, 0.15)
binom.power(5, 31, 16, 76, 0.3)




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

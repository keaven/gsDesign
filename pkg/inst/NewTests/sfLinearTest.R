# specifying spending using just 1 point should work 
length(sfLinear(1,0:100/100,c(.2,.6))$spend == 101)


# odd lengths for param should produce error
sfLinear(1,1,1)
sfLinear(1,1,c(.1,.2,.3))

# non-numeric input for param should produce error
sfLinear(1,1,"xxxx")

# timepoints not in order should produce error
sfLinear(1,1,c(.6,.4,.2,.3))

# cumulative spending not in order should produce error
sfLinear(1,1,c(.4,.5,.3,.2))

# try some numeric results
t <- c(.1, .3, .7, .9)
p <- c(.01, .05, .3, .7)
t0 <- c(0, t, 1)
p0 <- c(0, p, 1)
testts <- c(-1,0,t,1,2)

# test for points used to specify spending
# this should be a vector of 0's
alpha <- .03
if (max(sfLinear(alpha, testts, c(t, p))$spend - c(0, p0, 1) * alpha) > 0)
   print("sfLinear test for specified points failed")


# try points intermediate points between the specified points
testts <- c(.03, .21, .54, .79, .93)
testps <- c(0, p) + (testts - c(0, t))/(c(t, 1) - c(0, t)) * (c(p, 1) - c(0, p))
alpha <- .03
if (max(abs(alpha * testps - sfLinear(alpha, testts, c(t, p))$spend))>0)
   print("sfLinear test for intermediate test points failed")

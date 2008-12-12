## Checks of gsDesign output

# test.Deming.gsProb 
# from Keaven Anderson 2008 Deming presentation, slide 19
# Examine Type I error for 2-sided symmetric design with repeated
# testing (2, 4 and 10 times) at the (unadjusted) alpha=.025 (1-sided) level

"test.Deming.gsProb" <- function()
{
	w <- sum(gsProbability(k=2,theta=0,n.I=1:2,a=qnorm(.025)*c(1,1),b=qnorm(.975)*c(1,1))$upper$prob)
	x <- sum(gsProbability(k=4,theta=0,n.I=1:4,a=qnorm(.025)*c(1,1,1,1),b=qnorm(.975)*c(1,1,1,1))$upper$prob)
	y <- sum(gsProbability(k=10,theta=0,n.I=1:10,a=qnorm(.025)*array(1,10),b=qnorm(.975)*array(1,10))$upper$prob)
	z <- sum(gsProbability(k=20,theta=0,n.I=1:20,a=qnorm(.025)*array(1,20),b=qnorm(.975)*array(1,20))$upper$prob)
	
	checkEquals(round(w, 3), 0.042, msg="Checking Type I error, k = 2") 
	checkEquals(round(x, 3), 0.063, msg="Checking Type I error, k = 4")
	checkEquals(round(y, 3), 0.097, msg="Checking Type I error, k = 10")
	checkEquals(round(z, 3), 0.124, msg="Checking Type I error, k = 20")
}

# test.Deming.OFbound 
# from Keaven Anderson 2008 Deming presentation, slides 23-24

"test.Deming.OFbound" <- function()
{
	x <- gsDesign(k=4, test.type=2, sfu="OF", n.fix=1372, beta=.2)
	checkEquals(round(x$upper$bound, 2), c(4.05, 2.86, 2.34, 2.02), msg="Checking O'Brien-Fleming bounds")
}

# "JT" = Jennison & Turnbull (2000),
# Group Sequential Methods & Applications to Clinical Trials

# test.JT.OFss
# JT Table 2.8 p. 38

"test.JT.OFss" <- function()
{
	x <- gsDesign(k=5, test.type=2, sfu="OF", beta=0.2)
	checkEquals(round(x$n.I[5]*100, 1), 102.8, msg="Checking 2-sided OF (gsDesign n.I), k=4, beta=0.2")
	checkEquals(round(x$en[1]*100, 1), 102.1, msg="Checking 2-sided Pocock (gsDesign en), k=4, beta=0.2")
	
	x <- gsDesign(k=20, test.type=2, sfu="OF", beta=0.1)
	checkEquals(round(x$n.I[20]*100, 1), 104.5, msg="Checking 2-sided OF (gsDesign n.I), k=20, beta=0.1")
	checkEquals(round(x$en[1]*100, 1), 103.4, msg="Checking 2-sided Pocock (gsDesign en), k=20, beta=0.1")
}

# test.JT.Pocock
# JT Table 2.7 p. 37

"test.JT.Pocock" <- function()
{
	x <- gsDesign(k=4, test.type=2, sfu="Pocock", beta=0.2)
	checkEquals(round(x$n.I[4]*100, 1), 120.2, msg="Checking 2-sided Pocock (gsDesign n.I), k=4, beta=0.2")
	checkEquals(round(x$en[1]*100, 1), 117.5, msg="Checking 2-sided Pocock (gsDesign en), k=4, beta=0.2")
	y <- gsProbability(theta=x$delta*c(0, 0.5, 1, 1.5), d=x)
	checkEquals(round(y$en*100, 1), c(117.5, 108.8, 80.5, 52.2), msg="Checking 2-sided Pocock (gsProb), k=4, beta=0.2")
	
	x <- gsDesign(k=15, test.type=2, sfu="Pocock", beta=0.1)
	checkEquals(round(x$n.I[15]*100, 1), 130.5, msg="Checking 2-sided Pocock (gsDesign n.I), k=15, beta=0.1")
	checkEquals(round(x$en[1]*100, 1), 126.4, msg="Checking 2-sided Pocock (gsDesign en), k=15, beta=0.1")
	y <- gsProbability(theta=x$delta*c(0, 0.5, 1, 1.5), d=x)
	checkEquals(round(y$en*100, 1), c(126.4, 111.2, 66.4, 35.4), msg="Checking 2-sided Pocock (gsProb), k=15, beta=0.1")
}

# test.JT.WT
# JT Table 2.9 p. 40
# JT Table 2.10 p. 41

"test.JT.WT" <- function()
{
	x <- gsDesign(k=9, test.type=2, sfu="WT", sfupar=0.1, beta=0.1)
	checkEquals(round(x$n.I[9], 3), 1.048, msg="Checking 2-sided WT max SS, Delta=0.1, k=9, beta=0.1")
	checkEquals(round(x$upper$bound[9], 3), 2.113, msg="Checking 2-sided WT bound, Delta=0.1, k=9, beta=0.1")
	
	x <- gsDesign(k=6, test.type=2, sfu="WT", sfupar=0.25, beta=0.2)
	checkEquals(round(x$n.I[6], 3), 1.077, msg="Checking 2-sided WT max SS, Delta=0.25, k=6, beta=0.2")
	checkEquals(round(x$upper$bound[6], 3), 2.154, msg="Checking 2-sided WT bound, Delta=0.25, k=6, beta=0.2")
	
	x <- gsDesign(k=7, test.type=2, sfu="WT", sfupar=0.4, beta=0.2)
	checkEquals(round(x$n.I[7], 3), 1.159, msg="Checking 2-sided WT max SS, Delta=0.4, k=7, beta=0.2")
	checkEquals(round(x$upper$bound[7], 3), 2.313, msg="Checking 2-sided WT bound, Delta=0.4, k=7, beta=0.2")	
}

# test.JT.Power.symm
# JT Table 7.2 p. 151

"test.JT.Power.symm" <- function()
{
	x <- gsDesign(k=3, test.type=2, sfu=sfPower, sfupar=1, beta=0.2)
	checkEquals(round(x$n.I[3]*100, 1), 111.7, msg="Checking symm 2-sided sfPower (gsDesign n.I), k=3, rho=1")
	checkEquals(round(x$en[1]*100, 1), 109.9, msg="Checking symm 2-sided sfPower (gsDesign en), k=3, rho=1")
	y <- gsProbability(theta=x$delta*c(0, 0.5, 1, 1.5), d=x)
	checkEquals(round(y$en*100, 1), c(109.9, 103.4, 81.2, 56.5), msg="Checking symm 2-sided sfPower (gsProb), k=3, rho=1")
	
	x <- gsDesign(k=10, test.type=2, sfu=sfPower, sfupar=2, beta=0.2)
	checkEquals(round(x$n.I[10]*100, 1), 108.1, msg="Checking symm 2-sided sfPower (gsDesign), k=10, rho=2")
	checkEquals(round(x$en[1]*100, 1), 106.6, msg="Checking symm 2-sided sfPower (gsDesign en), k=10, rho=2")
	y <- gsProbability(theta=x$delta*c(0, 0.5, 1, 1.5), d=x)
	checkEquals(round(y$en*100, 1), c(106.6, 99.7, 76.2, 51.0), msg="Checking symm 2-sided sfPower (gsProb), k=10, rho=2")
	
	x <- gsDesign(k=2, test.type=2, sfu=sfPower, sfupar=3, beta=0.2)
	checkEquals(round(x$n.I[2]*100, 1), 101.0, msg="Checking symm 2-sided sfPower (gsDesign), k=2, rho=3")
	checkEquals(round(x$en[1]*100, 1), 100.7, msg="Checking symm 2-sided sfPower (gsDesign en), k=2, rho=3")
	y <- gsProbability(theta=x$delta*c(0, 0.5, 1, 1.5), d=x)
	checkEquals(round(y$en*100, 1), c(100.7, 98.9, 89.5, 70.7), msg="Checking symm 2-sided sfPower (gsProb), k=2, rho=3")
}

# test.JT.Power.type3
# JT Table 7.7 p. 165
# JT Table 7.8 p. 166
# JT Table 7.9 p. 167

"test.JT.Power.type3" <- function()
{
	x <- gsDesign(k=5, test.type=3, alpha=0.05, beta=0.05, sfu=sfPower, sfupar=2, sfl=sfPower, sflpar=2)
	checkEquals(round(x$n.I[5]*100, 1), 110.1, msg="Checking type3 sfPower (gsDesign n.I), k=5, rho=2, beta=0.05")
	checkEquals(round(x$en[1]*100, 1), 63.4, msg="Checking type3 sfPower (gsDesign en), k=5, rho=2, beta=0.05")
	y <- gsProbability(theta=x$delta*c(0, 0.5, 1), d=x)
	checkEquals(round(y$en*100, 1), c(63.4, 80.3, 63.4), msg="Checking type3 sfPower (gsProb), k=5, rho=2, beta=0.05")
	
	x <- gsDesign(k=10, test.type=3, alpha=0.05, beta=0.05, sfu=sfPower, sfupar=3, sfl=sfPower, sflpar=3)
	checkEquals(round(x$n.I[10]*100, 1), 106.9, msg="Checking type3 sfPower (gsDesign n.I), k=10, rho=3, beta=0.05")
	checkEquals(round(x$en[1]*100, 1), 63.1, msg="Checking type3 sfPower (gsDesign en), k=10, rho=3, beta=0.05")
	y <- gsProbability(theta=x$delta*c(0, 0.5, 1), d=x)
	checkEquals(round(y$en*100, 1), c(63.1, 79.5, 63.1), msg="Checking type3 sfPower (gsProb), k=10, rho=3, beta=0.05")
	
	x <- gsDesign(test.type=3, alpha=0.05, sfu=sfPower, sfupar=2, sfl=sfPower, sflpar=2)
	checkEquals(round(x$n.I[3]*100, 1), 107.2, msg="Checking type3 sfPower (gsDesign n.I), k=3, rho=2, beta=0.1")
	checkEquals(round(x$en[1]*100, 1), 68.1, msg="Checking type3 sfPower (gsDesign en), k=3, rho=2, beta=0.1")
	y <- gsProbability(theta=x$delta*c(0, 0.5, 1), d=x)
	checkEquals(round(y$en*100, 1), c(68.1, 83.9, 73.8), msg="Checking type3 sfPower (gsProb), k=3, rho=2, beta=0.1")
	
	x <- gsDesign(k=4, test.type=3, alpha=0.05, sfu=sfPower, sfupar=3, sfl=sfPower, sflpar=3)
	checkEquals(round(x$n.I[4]*100, 1), 104.0, msg="Checking type3 sfPower (gsDesign n.I), k=4, rho=3, beta=0.1")
	checkEquals(round(x$en[1]*100, 1), 69.2, msg="Checking type3 sfPower (gsDesign en), k=4, rho=3, beta=0.1")
	y <- gsProbability(theta=x$delta*c(0, 0.5, 1), d=x)
	checkEquals(round(y$en*100, 1), c(69.2, 84.2, 74.2), msg="Checking type3 sfPower (gsProb), k=3, rho=3, beta=0.1")
	
	x <- gsDesign(k=2, test.type=3, alpha=0.05, beta=0.2, sfu=sfPower, sfupar=2, sfl=sfPower, sflpar=2)
	checkEquals(round(x$n.I[2]*100, 1), 104.3, msg="Checking type3 sfPower (gsDesign n.I), k=2, rho=2, beta=0.2")
	checkEquals(round(x$en[1]*100, 1), 74.5, msg="Checking type3 sfPower (gsDesign en), k=2, rho=2, beta=0.2")
	y <- gsProbability(theta=x$delta*c(0, 0.5, 1), d=x)
	checkEquals(round(y$en*100, 1), c(74.5, 87.8, 84.6), msg="Checking type3 sfPower (gsProb), k=2, rho=2, beta=0.2")
	
	x <- gsDesign(k=15, test.type=3, alpha=0.05, beta=0.2, sfu=sfPower, sfupar=3, sfl=sfPower, sflpar=3)
	checkEquals(round(x$n.I[15]*100, 1), 106.9, msg="Checking type3 sfPower (gsDesign n.I), k=15, rho=3, beta=0.2")
	checkEquals(round(x$en[1]*100, 1), 62.2, msg="Checking type3 sfPower (gsDesign en), k=15, rho=3, beta=0.2")
	y <- gsProbability(theta=x$delta*c(0, 0.5, 1), d=x)
	checkEquals(round(y$en*100, 1), c(62.2, 77.3, 73.0), msg="Checking type3 sfPower (gsProb), k=15, rho=3, beta=0.2")
}	
	


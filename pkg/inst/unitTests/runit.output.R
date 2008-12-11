## Checks of gsDesign output

# "JT" = Jennison & Turnbull (2000),
# Group Sequential Methods & Applications to Clinical Trials

# test.Deming.OFbound 
# from Deming presentation slides 23-24
# (presentation says EAST gives same answer)

test.Deming.OFbound <- function()
{
	x <- gsDesign(k=4, test.type=2, sfu="OF", n.fix=1372, beta=.2)
	checkEquals(round(x$upper$bound), c(4.05, 2.86, 2.34, 2.02), msg="Checking O'Brien-Fleming bounds")
}




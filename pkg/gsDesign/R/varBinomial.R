# blinded estimate of variance for 2-sample binomial
varBinomial<-function(x,n,delta0=0,ratio=1,scale="Difference")
{	# check input arguments 
  checkVector(x, "integer", c(1, Inf))
  checkScalar(n, "integer", c(1, Inf))
  checkScalar(ratio, "numeric", c(0, Inf), c(FALSE,FALSE))
  scale <- match.arg(tolower(scale), c("difference", "rr", "or"))
  # risk difference test - from Miettinen and Nurminen eqn (9)
	p<-x/n
	phi<-array(0,max(length(delta0),length(x),length(ratio),length(n)))
	if (scale=="difference")
	{	checkScalar(delta0, "numeric", c(-1, 1),c(FALSE,FALSE))
    p1<-p+ratio*delta0/(ratio+1)
		p2<-p1-delta0
		a<-1+ratio
		b<- -(a+p1+ratio*p2-delta0*(ratio+2))
		c<- delta0^2-delta0*(2*p1+a)+p1+ratio*p2
		d<- p1*delta0*(1-delta0)
		v<-(b/(3*a))^3-b*c/6/a^2+d/2/a
		u<-sign(v)*sqrt((b/3/a)^2-c/3/a)
		w<-(pi+acos(v/u^3))/3
		p10<-2*u*cos(w)-b/3/a
		p20<-p10+delta0
		phi <- (p10*(1-p10)+p20*(1-p20)/ratio)*(ratio+1)
		phi[delta0==0]<-p*(1-p)/ratio*(1+ratio)^2
	}
	else if (scale=="rr") # log(p2/p1)
	{	checkScalar(delta0, "numeric", c(-Inf, Inf),c(FALSE,FALSE))
	  RR<-exp(delta0)
		if (delta0==0) phi<-(1-p)/p/ratio*(1+ratio)^2
		else
		{	p1<-p*(ratio+1)/(ratio*RR+1)
			p2<-RR*p1
			a<-(1+ratio)*RR
			b<- -(RR*ratio+p2*ratio+1+p1*RR)
			c<- ratio*p2+p1
			p10<-(-b-sqrt(b^2-4*a*c))/2/a
			p20<-RR*p10
			phi<-(ratio+1)*((1-p10)/p10+(1-p20)/ratio/p20)
	}	}	
	# log-odds ratio - based on asymptotic distribution of log-odds
	# see vignette
	else
	{	checkScalar(delta0, "numeric", c(-Inf, Inf),c(FALSE,FALSE))
	  OR<-exp(delta0)
		a<-OR-1
		c<- -p*(ratio+1)
		b<- 1+ratio*OR+(OR-1)*c
		p10<-(-b+sqrt(b^2-4*a*c))/2/a
		p20<-OR*p10/(1+p10*(OR-1))
		phi<-(ratio+1)*(1/p10/(1-p10)+1/p20/(1-p20)/ratio)
		phi[delta0==0]<-1/p/(1-p)*(1+1/ratio)*(1+ratio)
	}
	return(phi/n)
}

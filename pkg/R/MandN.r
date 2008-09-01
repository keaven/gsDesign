MandNsim<-function(p1, p2, n1, n2, alpha = 0.05, delta0=0, nsim = 10000, testtype="Chisq", adj=1)
{	x1<-rbinom(p=p1,size=n1,n=nsim)
	x2<-rbinom(p=p2,size=n2,n=nsim)
	Z<-MandNtest(x1=x1,x2=x2,n1=n1,n2=n2,delta0=delta0,adj=adj,testtype=testtype)
}
MandNtest<-function(x1,x2,n1,n2,delta0=0,testtype="Chisq",adj=1)
{	ntot<-n1+n2
	xtot<-x1+x2
	L2<-(n2+2*n1)*delta0-ntot-xtot
	L1<-(n1*delta0-ntot-2*x1)*delta0+xtot
	L0<-x1*delta0*(1-delta0)
	p<-sqrt((L2/(3*ntot))^2-L1/(3*ntot))
	q<-(L2/(3*ntot))^3-L1*L2/6/ntot^2+L0/2/ntot
	a<-(pi+acos(q/p^3))/3
	R0<-2*p*cos(a)-L2/3/ntot
	R1<-R0+delta0
	V<-(R1*(1-R1)/n2+R0*(1-R0)/n1)
	if (adj==1) V<-V*ntot/(ntot-1)
	if (testtype=="Chisq")
		return((x2/n2-x1/n1-delta0)^2/V)
	else return((x2/n2-x1/n1-delta0)/sqrt(V))
}
FarrMannSS<-function(p1, p2, fraction = 0.5, alpha = 0.05, power = 0.8, beta=0, delta0=0, ratio=0, sided=2, outtype=2) 
{   if (beta!=0) power<-1-beta
    z.beta  <- qnorm(power)    
    if (sided != 2) sided<-1
    z.alpha <- qnorm(1 - alpha/sided)
    if (ratio != 0) fraction<-1/(1+ratio) else ratio <- (1 - fraction)/fraction
    if (delta0==0)
    {   p<-(p1+ratio*p2)/(1+ratio)
        sigma0<-sqrt(p*(1-p)/ratio)*(1+ratio)
    }
    else
    {   a<-1+ratio
        b<- -(a+p1+ratio*p2-delta0*(ratio+2))
        c<- delta0^2-delta0*(2*p1+a)+p1+ratio*p2
        d<- p1*delta0*(1-delta0)
        v<-(b/(3*a))^3-b*c/6/a^2+d/2/a
        u<-sign(v)*sqrt((b/3/a)^2-c/3/a)
        w<-(pi+acos(v/u^3))/3
        p10<-2*u*cos(w)-b/3/a
        p20<-p10+delta0
        sigma0 <- sqrt((p10*(1-p10)+p20*(1-p20)/ratio)*(ratio+1))
    }
    sigma1 <- sqrt((p1*(1-p1)+p2*(1-p2)/ratio)*(ratio+1))
    n<-((z.alpha*sigma0+z.beta*sigma1)/(p2-p1-delta0))^2
    if (outtype==2) return(list(n1=n/(ratio+1),n2=ratio*n/(ratio+1)))
    else if (outtype==3) 
    {   if( delta0 != 0) return(list(n=n,n1=n/(ratio+1),n2=ratio*n/(ratio+1),sigma0=sigma0,sigma1=sigma1,p1=p1,p2=p2,delta0=delta0,p10=p10,p20=p20))
        else return(list(n=n,n1=n/(ratio+1),n2=ratio*n/(ratio+1),sigma0=sigma0,sigma1=sigma1,p1=p1,p2=p2,pbar=p))
    }
    else return(n=n)
}

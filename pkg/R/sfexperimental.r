# this is not exported in NAMESPACE since sfbetadist appears just as fast and flexible - while this has numerical problems in
# extreme cases
sf2power<-function(alpha,t,param)
{  x<-list(name="2-power",param=param,parname=c("a","b"),spend=NULL,
           bound=NULL,prob=NULL,errcode=0,errmsg="No error")  
   class(x)<-"spendfn"
   if (length(param)!=2 && length(param) != 4) return(gsReturnError(x,errcode=.3,"2-power spending function parameter must be of length 2 or 4"))
   if (!is.numeric(param)) return(gsReturnError(x,errcode=.1,errmsg="2-power spending function parameter must be numeric"))
   if (length(param)==2)
   {   if (param[1]<=0.) return(gsReturnError(x,errcode=.12,errmsg="1st 2-power spending function parameter must be > 0."))
       if (param[2]<=0.) return(gsReturnError(x,errcode=.13,errmsg="2nd 2-power spending function parameter must be > 0."))
   }
   else
   {   if (min(param)<=0. || max(param)>=1.)
           return(gsReturnError(x,errcode=.14,errmsg="4-parameter specification of 2-power spending function must have all values >0 and < 1."))
       tem<-nlminb(c(1,1),diff2power,lower=c(0,0),xval=param[1:2],uval=param[3:4])
       if (tem$convergence!=0)
	     return(gsReturnError(x,errcode=.15,errmsg="Solution to 4-parameter specification of 2-power spending function not found."))
       x$param<-tem$par
   }
   x$spend<-alpha*(1-(1-t^x$param[1])^x$param[2])
   return(x)
}
diff2power<-function(aval,xval,uval)
{   diff<-1-uval-(1-xval^aval[1])^aval[2]
    return(sum(diff^2))
}
sfchisq<-function(alpha,t,param)
{  x<-list(name="Chi-square",param=param,parname=c("nu","df"),spend=NULL,
           bound=NULL,prob=NULL,errcode=0,errmsg="No error")  
   class(x)<-"spendfn"
   if (length(param)!=2 || !is.numeric(param)) return(gsReturnError(x,errcode=.1,errmsg="Chi-square spending function parameter must have 2 positive values"))
   if (param[1]<=0. || param[1] >10) return(gsReturnError(x,errcode=.12,errmsg="1st Chi-square spending function parameter must be > 0 and <= 10"))
   if (param[2]<=0.) return(gsReturnError(x,errcode=.13,errmsg="2nd Chi-square spending function parameter must be > 0."))
   x$spend<-1-pchisq(qchisq(1-alpha,param[2])/t^param[1],param[2])
   return(x)
}

gsReturnError<-function(x,errcode,errmsg)
{	x$errcode<-errcode
	x$errmsg<-errmsg
	return(x)
}
gsDErrorCheck<-function(x)
{	
# check input value of k, test.type, alpha, beta, astar
	if (x$k<2) return(gsReturnError(x,errcode=1,errmsg="input value for k must be integer > 1"))
	if (x$test.type < 1 || x$test.type > 6) return(gsReturnError(x,errcode=2,errmsg="input value for test.type must be integer from 1 to 6, inclusive"))
	if (x$alpha <= 0 || x$alpha>=1) return(gsReturnError(x,errcode=3,errmsg="input value for alpha must enter 0<alpha<1"))
      if (x$test.type==2 && x$alpha > .5) return(gsReturnError(x,errcode=3,errmsg="for test.type=2, alpha must be <=0.5"))
	if (x$beta <= 0 || x$beta >= 1-x$alpha) return(gsReturnError(x,errcode=4,errmsg="input value for beta must be: 0<beta<1-alpha"))
      if (x$test.type>4)
      {   if(x$astar<0.||x$astar>1.-x$alpha) return(gsReturnError(x,errcode=4.1,errmsg="when test.type=5 or 6, must have 0<=astar<=1-alpha"))
          else if (x$astar==0) x$astar<-1-x$alpha
      }
# check delta, n.fix
	if(x$delta<0) return(gsReturnError(x,errcode=5,errmsg="input value for delta must be >= 0"))
	else if(x$delta==0)
	{	if(x$n.fix<=0) return(gsReturnError(x,errcode=6,errmsg="if delta = 0, input for n.fix must be > 0"))
		x$delta=abs(qnorm(x$alpha)+qnorm(x$beta))/sqrt(x$n.fix)
	}
      else x$n.fix<-((qnorm(x$alpha)+qnorm(x$beta))/x$delta)^2
	
# check n.I, maxn.IPlan
      if (!is.real(x$n.I)) return(gsReturnError(x,errcode=11.1,errmsg="n.I must be a real vector"))
	if (!is.real(x$maxn.IPlan)) return(gsReturnError(x,errcode=12.1,errmsg="maxn.IPlan must be a non-negative real number"))
      if (length(x$maxn.IPlan)>1) return(gsReturnError(x,errcode=12.1,errmsg="maxn.IPlan must be a non-negative real number"))
	if (max(abs(x$n.I))>0)
	{	if (length(x$n.I)!=x$k) return(gsReturnError(x,errcode=11.2,errmsg="n.I must be 0 or have length k"))
		if (min(x$n.I-c(0,x$n.I[1:(x$k-1)]))<=0) return(gsReturnError(x,errcode=11.3,errmsg="n.I must be an increasing, positive sequence"))
		if (x$maxn.IPlan<=0) x$maxn.IPlan<-x$n.I[x$k]
		x$timing<-x$n.I[1:(x$k-1)]/x$maxn.IPlan
		if (max(x$timing)>=1) return(gsReturnError(x,errcode=12,errmsg="maxn.IPlan must be > n.I[k-1]"))
	}
	else if (x$maxn.IPlan>0)
	{	if (length(x$n.I)==1) return(gsReturnError(x,errcode=11.4,errmsg="If maxn.IPlan is specified, n.I must be specified"))
	}

# check input for timing of interim analyses
	# if timing not specified, make it equal spacing
	if (length(x$timing)<1 || (length(x$timing)==1 && (x$k>2||(x$k==2 && (x$timing[1]<=0 || x$timing[1]>=1))))) x$timing<-seq(1:x$k)/x$k
	# if timing specified, make sure it is done correctly
	else if (length(x$timing)==x$k-1 || length(x$timing)==x$k) 
	{	if (length(x$timing)==x$k-1) x$timing<-c(x$timing,1)
		else if (x$timing[x$k]!=1)
			return(gsReturnError(x,errcode=8,errmsg="if analysis timing for final analysis is input, it must be 1"))
		if (min(x$timing-c(0,x$timing[1:x$k-1]))<=0)
			return(gsReturnError(x,errcode=8.1,errmsg="input timing of interim analyses must be increasing strictly between 0 and 1"))
	}
	else return(gsReturnError(x,errcode=8.2,errmsg="value input for timing must be length 1, k-1 or k"))

# check input values for tol, r
	if (x$tol <= 0 || x$tol > .1) return(gsReturnError(x,errcode=10,errmsg="Input value for tol must be: 0<tol<=.1"))
	if (x$r<1 || x$r>80) return(gsReturnError(x,errcode=11,errmsg="Input value for r must be integer from 1 to 80, inclusive"))


#if you get here, no error found
	return(gsReturnError(x,errcode=0,errmsg="No errors detected"))
}
gsCheckSpend<-function(x)
{   if (class(x)!="spend")
    {   x<-gsReturnError(x,errcode=1,errmsg="Spending function must return a value of class 'spend'")
        return(x)
    }
    return(x)
}

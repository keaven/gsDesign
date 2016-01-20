###################################################
### code chunk number 2: eEvents1
###################################################
eEvents1<-function(lambda=1, eta=0, gamma=1, R=1, S=NULL, 
                   T=2, Tfinal=NULL, minfup=0, simple=TRUE)
{  
  if (is.null(Tfinal))
  {   Tfinal <- T
      minfupia <- minfup
  }
  else minfupia <- max(0, minfup-(Tfinal - T))
  
  nlambda <- length(lambda)
  if (length(eta)==1 & nlambda > 1) 
    eta <- array(eta,nlambda)
  T1 <- cumsum(S)
  T1 <- c(T1[T1<T],T)
  T2 <- T - cumsum(R)
  T2[T2 < minfupia] <- minfupia
  i <- 1:length(gamma)
  gamma[i>length(unique(T2))] <- 0
  T2 <- unique(c(T,T2[T2 > 0]))
  T3 <- sort(unique(c(T1,T2)))
  if (sum(R) >= T) T2 <- c(T2,0)
  nperiod <- length(T3)
  s <- T3-c(0,T3[1:(nperiod-1)])
  
  lam <- array(lambda[nlambda],nperiod)
  et <- array(eta[nlambda],nperiod)
  gam <- array(0,nperiod)
  
  for(i in length(T1):1)
  {  indx <- T3<=T1[i]
     lam[indx]<-lambda[i]
     et[indx]<-eta[i]
  }
  for(i in min(length(gamma)+1,length(T2)):2) 
    gam[T3>T2[i]]<-gamma[i-1]
  q <- exp(-(lam+et)*s)
  Q <- cumprod(q)
  indx<-1:(nperiod-1)
  Qm1 <- c(1,Q[indx])
  p <- lam/(lam+et)*Qm1*(1-q)
  p[is.nan(p)] <- 0 
  P <- cumsum(p)
  B <- gam/(lam+et)*lam*(s-(1-q)/(lam+et))
  B[is.nan(B)]<-0
  A <- c(0,P[indx])*gam*s+Qm1*B
  if (!simple)
    return(list(lambda=lambda, eta=eta, gamma=gamma, R=R, S=S,
                T=T, Tfinal=Tfinal, minfup=minfup, d=sum(A), 
                n=sum(gam*s), q=q,Q=Q,p=p,P=P,B=B,A=A,T1=T1,
                T2=T2,T3=T3,lam=lam,et=et,gam=gam))
  else
    return(list(lambda=lambda, eta=eta, gamma=gamma, R=R, S=S,  
                T=T, Tfinal=Tfinal, minfup=minfup, d=sum(A), 
                n=sum(gam*s)))
}
###################################################
### code chunk number 4: eEvents
###################################################
eEvents<-function(lambda=1, eta=0, gamma=1, R=1, S=NULL, T=2,
                  Tfinal=NULL, minfup=0, digits=4)
{  if (is.null(Tfinal))
	{	if (minfup >= T)
      stop("Minimum follow-up greater than study duration.")
		Tfinal <- T
		minfupia <- minfup
	}
	else minfupia <- max(0, minfup-(Tfinal - T))

	if (!is.matrix(lambda)) 
    lambda <- matrix(lambda, nrow=length(lambda))
	if (!is.matrix(eta)) 
    eta <- matrix(eta,nrow=nrow(lambda),ncol=ncol(lambda))
	if (!is.matrix(gamma))
    gamma<-matrix(gamma,nrow=length(R),ncol=ncol(lambda)) 
	n <- array(0,ncol(lambda))
	d <- n 
	for(i in 1:ncol(lambda))
	{	a <- eEvents1(lambda=lambda[,i],eta=eta[,i],
                    gamma=gamma[,i],R=R,S=S,T=T,
                    Tfinal=Tfinal, minfup=minfup)
		n[i]<-a$n
		d[i]<-a$d
	}
	T1 <- cumsum(S)
	T1 <- unique(c(0,T1[T1<T],T))
	nper <- length(T1)-1
	names1 <- round(T1[1:nper],digits)
	namesper <- paste("-",round(T1[2:(nper+1)],digits),sep="")
	namesper <- paste(names1,namesper,sep="")
	if (nper < dim(lambda)[1])
    lambda <- matrix(lambda[1:nper,],nrow=nper)
	if (nper < dim(eta)[1]) 
    eta <- matrix(eta[1:nper,],nrow=nper)
	rownames(lambda) <- namesper
	rownames(eta) <- namesper
	colnames(lambda) <- paste("Stratum",1:ncol(lambda))
	colnames(eta) <- paste("Stratum",1:ncol(eta))
	T2 <- cumsum(R)
	T2[T - T2 < minfupia] <- T - minfupia
	T2 <- unique(c(0,T2))
	nper <- length(T2)-1
	names1 <- round(c(T2[1:nper]),digits)
	namesper <- paste("-",round(T2[2:(nper+1)],digits),sep="")
	namesper <- paste(names1,namesper,sep="")
	if (nper < length(gamma)) 
    gamma <- matrix(gamma[1:nper,],nrow=nper)
	rownames(gamma) <- namesper
	colnames(gamma) <- paste("Stratum",1:ncol(gamma))
	x <- list(lambda=lambda, eta=eta, gamma=gamma, R=R, 
            S=S, T=T, Tfinal=Tfinal,
            minfup=minfup, d=d, n=n, digits=digits)
	class(x) <- "eEvents"
	return(x)
}
###################################################
### code chunk number 5: periods
###################################################
periods <- function(S, T, minfup, digits)
{  periods <- cumsum(S)
	if (length(periods)==0) periods <- max(0, T - minfup)
	else
	{	maxT <- max(0,min(T - minfup, max(periods)))
		periods <- periods[periods <= maxT]
		if (max(periods) < T - minfup)
      periods <- c(periods, T - minfup)
	}
	nper <- length(periods)
	names1 <- c(0, round(periods[1:(nper-1)],digits))
	names <- paste("-",periods,sep="")
	names <- paste(names1,names,sep="")
	return(list(periods,names))
}
###################################################
### code chunk number 6: print.eEvents
###################################################
print.eEvents <- function(x,digits=4,...){
  if (class(x) != "eEvents") 
    stop("print.eEvents: primary argument must have class eEvents")
	cat("Study duration:              Tfinal=", 
      round(x$Tfinal,digits), "\n", sep="")
	cat("Analysis time:                    T=", 
      round(x$T,digits), "\n", sep="")
	cat("Accrual duration:                   ", 
			round(min(x$T - max(0, x$minfup-(x$Tfinal - x$T)), 
        sum(x$R)),digits), "\n", sep="")
	cat("Min. end-of-study follow-up: minfup=", 
      round(x$minfup,digits), "\n", sep="")
  cat("Expected events (total):            ", 
     round(sum(x$d),digits), "\n",sep="")
  if (length(x$d)>1)
  {  cat("Expected events by stratum:       d=",
         round(x$d[1],digits))
     for(i in 2:length(x$d)) 
       cat(paste("",round(x$d[i],digits)))
     cat("\n")
  }
  cat("Expected sample size (total):       ", 
     round(sum(x$n),digits), "\n", sep="")
  if (length(x$n)>1)
  {  cat("Sample size by stratum:           n=",
         round(x$n[1],digits))
     for(i in 2:length(x$n)) 
       cat(paste("",round(x$n[i],digits)))
     cat("\n")
  }
	nstrata <- dim(x$lambda)[2]
	cat("Number of strata:                   ", 
      nstrata, "\n", sep="")
	cat("Accrual rates:\n")
	print(round(x$gamma,digits))
	cat("Event rates:\n")
	print(round(x$lambda,digits))
	cat("Censoring rates:\n")
	print(round(x$eta,digits))
  return(x)
}
###################################################
### code chunk number 12: nameperiod
###################################################
"nameperiod" <- function(R, digits=2)
{   if (length(R)==1) return(paste("0-",round(R,digits),sep=""))
    R0 <- c(0,R[1:(length(R)-1)])
    return(paste(round(R0,digits),"-",round(R,digits),sep=""))
}
###################################################
### code chunk number 14: LFPWE
###################################################
LFPWE <- function(alpha=.025, sided=1, beta=.1,
  lambdaC=log(2) / 6, hr=.5, hr0=1, etaC=0, etaE=0,
  gamma=1, ratio=1, R=18, S=NULL, T=24, minfup=NULL)
{  # set up parameters
  zalpha <- -qnorm(alpha/sided)
  zbeta <- -qnorm(beta)
  if (is.null(minfup)) minfup <- max(0,T-sum(R))
  if (length(R)==1) {R <- T-minfup
  }else if (sum(R) != T-minfup)
  { cR<-cumsum(R)
    nR<-length(R)
    if (cR[length(cR)] < T - minfup) {cR[length(cR)]<-T-minfup
    }else
    { cR[cR>T-minfup]<-T-minfup
      cR <- unique(cR)
    }
    if (length(cR)>1) {R <- cR-c(0,cR[1:(length(cR)-1)])
    }else R <- cR
    if (nR != length(R))
    { if (is.vector(gamma)) {gamma <- gamma[1:length(R)]
      }else gamma<-gamma[1:length(R),]
    }
  }
	ngamma <- length(R)
	if (is.null(S)) {nlambda <- 1
	}else nlambda <- length(S) + 1
	Qe <- ratio / (1 + ratio)
	Qc <- 1 - Qe

	# compute H0 failure rates as average of control, experimental
  if (length(ratio)==1){
     lambdaC0 <- (1 + hr * ratio) / (1 + hr0 * ratio) * lambdaC
     gammaC <- gamma*Qc
     gammaE <- gamma*Qe
  }else{
    lambdaC0 <- lambdaC %*% diag((1 + hr * ratio) / (1 + hr0 * ratio))
    gammaC <- gamma%*%diag(Qc)
    gammaE <- gamma%*%diag(Qe)
  }
	# do computations
	eDC0 <- sum(eEvents(lambda=lambdaC0, eta=etaC, gamma=gammaC,
                       R=R, S=S, T=T, minfup=minfup)$d)
	eDE0 <- sum(eEvents(lambda=lambdaC0 * hr0, eta=etaE, gamma=gammaE,
                       R=R, S=S, T=T, minfup=minfup)$d)
	eDC <- eEvents(lambda=lambdaC, eta=etaC, gamma=gammaC,
                  R=R, S=S, T=T, minfup=minfup)
	eDE <- eEvents(lambda=lambdaC * hr, eta=etaE, gamma=gammaE, 
                  R=R, S=S, T=T, minfup=minfup)
  
	n <- ((zalpha * sqrt(1 / eDC0 + 1 / eDE0) +
   zbeta * sqrt(1 / sum(eDC$d) + 1 / sum(eDE$d))
   ) / log(hr / hr0))^2	
	mx <- sum(eDC$n + eDE$n)
	rval <- list(alpha=alpha, sided=sided, beta=beta, power=1-beta,
    lambdaC=lambdaC, etaC=etaC, etaE=etaE, gamma=n * gamma, 
    ratio=ratio, R=R, S=S, T=T, minfup=minfup,
    hr=hr, hr0=hr0, n=n * mx, d=n * sum(eDC$d + eDE$d),
    eDC=eDC$d*n, eDE=eDE$d*n, eDC0=eDC0*n, eDE0=eDE0*n,
    eNC=eDC$n*n, eNE=eDE$n*n, variable="Accrual rate")
  class(rval) <- "nSurv"
  return(rval)
}
print.nSurv<-function(x,digits=4,...){
  if (class(x) != "nSurv") 
		stop("Primary argument must have class nSurv")
  x$digits<-digits
  x$sided <- 1
  cat("Fixed design, two-arm trial with time-to-event\n")
  cat("outcome (Lachin and Foulkes, 1986).\n")
  cat("Solving for: ",x$variable,"\n")
  cat("Hazard ratio                  H1/H0=", 
      round(x$hr,digits),
      "/", round(x$hr0,digits),"\n",sep="")
	cat("Study duration:                   T=", 
      round(x$T,digits), "\n", sep="")
	cat("Accrual duration:                   ", 
      round(x$T-x$minfup,digits),"\n",sep="") 
	cat("Min. end-of-study follow-up: minfup=", 
      round(x$minfup,digits), "\n", sep="")
  cat("Expected events (total, H1):        ", 
      round(x$d,digits), "\n",sep="")
  cat("Expected sample size (total):       ", 
      round(x$n,digits), "\n", sep="")
  enrollper <- periods(x$S, x$T, x$minfup, x$digits)
	cat("Accrual rates:\n")
	print(round(x$gamma,digits))
	cat("Control event rates (H1):\n")
	print(round(x$lambda,digits))
  if (max(abs(x$etaC-x$etaE))==0)
	{  cat("Censoring rates:\n")
	   print(round(x$etaC,digits))
	}
  else
  {  cat("Control censoring rates:\n")
     print(round(x$etaC,digits))
     cat("Experimental censoring rates:\n")
     print(round(x$etaE,digits))
  }
  cat("Power:                 100*(1-beta)=", 
      round((1-x$beta)*100,digits), "%\n",sep="")
  cat("Type I error (", x$sided, 
      "-sided):   100*alpha=", 
      100*x$alpha, "%\n", sep="")
	if (min(x$ratio==1)==1) 
    cat("Equal randomization:          ratio=1\n")
	else cat("Randomization (Exp/Control):  ratio=", 
           x$ratio, "\n")
}
###################################################
### code chunk number 19: KTZ
###################################################
KTZ <- function(x=NULL, minfup=NULL, n1Target=NULL, 
                lambdaC=log(2) / 6, etaC=0, etaE=0,
                gamma=1, ratio=1, R=18, S=NULL, beta=.1, 
                alpha=.025, sided=1, hr0=1, hr=.5, simple=TRUE)
{ zalpha<- -qnorm(alpha/sided)
  Qc <- 1/(1+ratio)
  Qe <- 1 - Qc
  # set minimum follow-up to x if that is missing and x is given
  if (!is.null(x) && is.null(minfup))
  {   minfup <- x
      if (sum(R)==Inf) 
        stop("If minimum follow-up is sought, enrollment duration must be finite")
      T <- sum(R)+minfup
      variable <- "Follow-up duration"
  }
  else if (!is.null(x)&&!is.null(minfup))
  {   # otherwise, if x is given, set it to accrual duration
      T <- x+minfup
      R[length(R)]<-Inf
      variable <- "Accrual duration"
  }
  else
  {  # otherwise, set follow-up time to accrual plus follow-up
     T <- sum(R) + minfup
     variable <- "Power"
  }
  # compute H0 failure rates as average of control, experimental
  if (length(ratio)==1){
     lambdaC0 <- (1 + hr * ratio) / (1 + hr0 * ratio) * lambdaC
     gammaC <- gamma*Qc
     gammaE <- gamma*Qe
  }else{
    lambdaC0 <- lambdaC %*% diag((1 + hr * ratio) / (1 + hr0 * ratio))
    gammaC <- gamma%*%diag(Qc)
    gammaE <- gamma%*%diag(Qe)
  }

  # do computations
	eDC <- eEvents(lambda=lambdaC, eta=etaC, gamma=gammaC,
                  R=R, S=S, T=T, minfup=minfup)
	eDE <- eEvents(lambda=lambdaC * hr, eta=etaE, gamma=gammaE, 
                  R=R, S=S, T=T, minfup=minfup)
  # if this is all that is needed, return difference 
  # from targeted number of events 
  if (simple && !is.null(n1Target))
    return(sum(eDC$d+eDE$d)-n1Target)
  eDC0 <- eEvents(lambda=lambdaC0, eta=etaC, gamma=gammaC,
                       R=R, S=S, T=T, minfup=minfup)
	eDE0 <- eEvents(lambda=lambdaC0 * hr0, eta=etaE, gamma=gammaE,
                       R=R, S=S, T=T, minfup=minfup)
  # compute Z-value related to power from power equation
  zb <- (log(hr0 / hr) - 
        zalpha * sqrt(1 / sum(eDC0$d) + 1 / sum(eDE0$d)))/
		    sqrt(1 / sum(eDC$d) + 1 / sum(eDE$d))
  # if that is all that is needed, return difference from
  # targeted value
  if (simple) 
  { if (!is.null(beta)) return(zb + qnorm(beta))
    else return(pnorm(-zb))
  }
  # compute power
  power <- pnorm(zb)
  beta <- 1-power
  # set accrual period durations
  if (sum(R) != T-minfup)
  {  if (length(R)==1) R <- T-minfup
     else
	   {	nR <- length(R)
        cR <- cumsum(R)
		    cR[cR>T-minfup] <- T - minfup
		    cR <- unique(cR)
        cR[length(R)] <- T - minfup
		    if (length(cR)==1) R <- cR
		    else R <- cR - c(0,cR[1:(length(cR)-1)])
        if (length(R) != nR)
		    {  gamma <- matrix(gamma[1:length(R),], nrow=length(R))
           gdim <- dim(gamma)
		    }
	   }
  }
  rval <- list(alpha=alpha, sided=sided, beta=beta, power=power,
           lambdaC=lambdaC, etaC=etaC, etaE=etaE,
           gamma=gamma, ratio=ratio, R=R, S=S, T=T, 
           minfup=minfup, hr=hr, hr0=hr0, n=sum(eDC$n + eDE$n), 
           d=sum(eDC$d + eDE$d), tol=NULL, eDC=eDC$d, eDE=eDE$d,
           eDC0=eDC0$d, eDE0=eDE0$d, eNC=eDC$n, eNE=eDE$n,
           variable=variable)
  class(rval)<-"nSurv"
  return(rval)
}
###################################################
### code chunk number 21: KT
###################################################
KT <- function(alpha=.025, sided=1, beta=.1, 
  lambdaC=log(2) / 6, hr=.5, hr0=1, etaC=0, etaE=0,
  gamma=1, ratio=1, R=18, S=NULL, minfup=NULL,
  n1Target=NULL, tol = .Machine$double.eps^0.25)
{  # set up parameters
	ngamma <- length(R)
	if (is.null(S)) {nlambda <- 1
	}else nlambda <- length(S) + 1
	Qe <- ratio / (1 + ratio)
	Qc <- 1 - Qe
	if (!is.matrix(lambdaC)) lambdaC <- matrix(lambdaC)
	ldim <- dim(lambdaC)
	nstrata <- ldim[2]
	nlambda <- ldim[1]
	etaC <- matrix(etaC,nrow=nlambda,ncol=nstrata)
	etaE <- matrix(etaE,nrow=nlambda,ncol=nstrata) 
	if (!is.matrix(gamma)) gamma <- matrix(gamma) 
	gdim <- dim(gamma)
	eCdim <- dim(etaC)
	eEdim <- dim(etaE)

	# search for trial duration needed to achieve desired power
	if (is.null(minfup))
  {  if (sum(R)==Inf){ 
       stop("Enrollment duration must be specified as finite")}
     left <- KTZ(.01, lambdaC=lambdaC, n1Target=n1Target,
                  etaC=etaC, etaE=etaE, gamma=gamma, ratio=ratio,
                  R=R, S=S, beta=beta, alpha=alpha, sided=sided,
                  hr0=hr0, hr=hr)
     right <- KTZ(1000, lambdaC=lambdaC, n1Target=n1Target,
                  etaC=etaC, etaE=etaE, gamma=gamma, ratio=ratio,
                  R=R, S=S, beta=beta, alpha=alpha, sided=sided,
                  hr0=hr0, hr=hr)
     if (left>0) stop("Enrollment duration over-powers trial")
     if (right<0) stop("Enrollment duration insufficient to power trial")
     y <- uniroot(f=KTZ,interval=c(.01,10000), lambdaC=lambdaC,
                  etaC=etaC, etaE=etaE, gamma=gamma, ratio=ratio,
                  R=R, S=S, beta=beta, alpha=alpha, sided=sided,
                  hr0=hr0, hr=hr, tol=tol, n1Target=n1Target)
     minfup <- y$root
     xx<-KTZ(x=y$root,lambdaC=lambdaC,
      etaC=etaC, etaE=etaE, gamma=gamma, ratio=ratio,
      R=R, S=S, minfup=NULL, beta=beta, alpha=alpha, 
      sided=sided, hr0=hr0, hr=hr, simple=F)
     xx$tol <- tol
     return(xx)
  }else 
  {  y <- uniroot(f=KTZ, interval=minfup+c(.01,10000), lambdaC=lambdaC, 
           n1Target=n1Target,
           etaC=etaC, etaE=etaE, gamma=gamma, ratio=ratio, 
           R=R, S=S, minfup=minfup, beta=beta,
           alpha=alpha, sided=sided, hr0=hr0, hr=hr, tol=tol)
     xx <- KTZ(x=y$root,lambdaC=lambdaC,
        etaC=etaC, etaE=etaE, gamma=gamma, ratio=ratio,
        R=R, S=S, minfup=minfup, beta=beta, alpha=alpha, 
        sided=sided, hr0=hr0, hr=hr, simple=F)
     xx$tol<-tol
     return(xx)
  }
}
###################################################
### code chunk number 25: nSurv
###################################################
nSurv <- function(lambdaC=log(2)/6, hr=.6, hr0=1, eta = 0, etaE=NULL, 
  gamma=1, R=12, S=NULL, T=NULL,  minfup = NULL, ratio = 1,
  alpha = 0.025, beta = 0.10,  sided = 1, tol = .Machine$double.eps^0.25)
{ if (is.null(etaE)) etaE<-eta
# set up rates as matrices with row and column names
# default is 1 stratum if lambdaC not input as matrix
  if (is.vector(lambdaC)) lambdaC <- matrix(lambdaC)
  ldim <- dim(lambdaC)
  nstrata <- ldim[2]
	nlambda <- ldim[1]
	rownames(lambdaC) <- paste("Period", 1:nlambda)
	colnames(lambdaC) <- paste("Stratum", 1:nstrata)
	etaC <- matrix(eta,nrow=nlambda,ncol=nstrata)
	etaE <- matrix(etaE,nrow=nlambda,ncol=nstrata) 
	if (!is.matrix(gamma)) gamma <- matrix(gamma) 
	gdim <- dim(gamma)
	eCdim <- dim(etaC)
	eEdim <- dim(etaE)

  if (is.null(minfup) || is.null(T))
    xx<-KT(lambdaC=lambdaC, hr=hr, hr0=hr0, etaC=etaC, etaE=etaE, 
  gamma=gamma, R=R, S=S,  minfup = minfup, ratio = ratio,
  alpha=alpha, sided=sided, beta = beta, tol = tol)
  else if (is.null(beta))
    xx<-KTZ(lambdaC=lambdaC, hr=hr, hr0=hr0, etaC=etaC, etaE=etaE, 
      gamma=gamma, R=R, S=S,  minfup = minfup, ratio = ratio,
      alpha=alpha, sided=sided, beta = beta, simple=F)
  else
    xx<-LFPWE(lambdaC=lambdaC, hr=hr, hr0=hr0, etaC=etaC, etaE=etaE, 
  gamma=gamma, R=R, S=S, T=T,  minfup = minfup, ratio = ratio,
  alpha=alpha, sided=sided, beta = beta)
  
  nameR<-nameperiod(cumsum(xx$R))
  stratnames <- paste("Stratum",1:ncol(xx$lambdaC))
  if (is.null(xx$S)) nameS<-"0-Inf"
  else nameS <- nameperiod(cumsum(c(xx$S,Inf)))
  rownames(xx$lambdaC)<-nameS
  colnames(xx$lambdaC)<-stratnames
  rownames(xx$etaC)<-nameS
  colnames(xx$etaC)<-stratnames
  rownames(xx$etaE)<-nameS
  colnames(xx$etaE)<-stratnames
  rownames(xx$gamma)<-nameR
  colnames(xx$gamma)<-stratnames
  return(xx)
}
###################################################
### code chunk number 33: gsnSurv
###################################################
gsnSurv <- function(x,nEvents)
{  if (x$variable=="Accrual rate")
   {  Ifct <- nEvents/x$d
      rval <- list(lambdaC=x$lambdaC, etaC=x$etaC, etaE=x$etaE,
               gamma=x$gamma*Ifct, ratio=x$ratio, R=x$R, S=x$S, T=x$T, 
               minfup=x$minfup, hr=x$hr, hr0=x$hr0, n=x$n*Ifct, d=nEvents,
               eDC=x$eDC*Ifct,eDE=x$eDE*Ifct,eDC0=x$eDC0*Ifct,
               eDE0=x$eDE0*Ifct,eNC=x$eNC*Ifct,eNE=x$eNE*Ifct,
               variable=x$variable)
   }
   else if (x$variable=="Accrual duration")
   {  y<-KT(n1Target=nEvents,minfup=x$minfup,lambdaC=x$lambdaC,etaC=x$etaC,
         etaE=x$etaE,R=x$R,S=x$S,hr=x$hr,hr0=x$hr0,gamma=x$gamma,
         ratio=x$ratio,tol=x$tol)
      rval <- list(lambdaC=x$lambdaC, etaC=x$etaC, etaE=x$etaE,
               gamma=x$gamma, ratio=x$ratio, R=y$R, S=x$S, T=y$T, 
               minfup=y$minfup, hr=x$hr, hr0=x$hr0, n=y$n, d=nEvents,
               eDC=y$eDC,eDE=y$eDE,eDC0=y$eDC0,
               eDE0=y$eDE0,eNC=y$eNC,eNE=y$eNE,tol=x$tol,
               variable=x$variable)
   }
   else
   {  y<-KT(n1Target=nEvents,minfup=NULL,lambdaC=x$lambdaC,etaC=x$etaC,
         etaE=x$etaE,R=x$R,S=x$S,hr=x$hr,hr0=x$hr0,gamma=x$gamma,
         ratio=x$ratio,tol=x$tol)
      rval <- list(lambdaC=x$lambdaC, etaC=x$etaC, etaE=x$etaE,
               gamma=x$gamma, ratio=x$ratio, R=x$R, S=x$S, T=y$T, 
               minfup=y$minfup, hr=x$hr, hr0=x$hr0, n=y$n, d=nEvents,
               eDC=y$eDC,eDE=y$eDE,eDC0=y$eDC0,
               eDE0=y$eDE0,eNC=y$eNC,eNE=y$eNE,tol=x$tol,
               variable=x$variable)
   }
   class(rval) <- "gsSize"
   return(rval)
}
###################################################
### code chunk number 35: tEventsIA
###################################################
tEventsIA<-function(x, timing=.25, tol = .Machine$double.eps^0.25)
{   T <- x$T[length(x$T)]
    z <- uniroot(f=nEventsIA, interval=c(0.0001,T-.0001), x=x,
          target=timing, tol=tol,simple=TRUE)
    return(nEventsIA(tIA=z$root,x=x,simple=FALSE))
}
nEventsIA <- function(tIA=5, x=NULL, target=0, simple=TRUE)
{  Qe <- x$ratio/(1+x$ratio)
  eDC <- eEvents(lambda=x$lambdaC, eta=x$etaC,
    gamma=x$gamma*(1-Qe), R=x$R, S=x$S, T=tIA, 
    Tfinal=x$T[length(x$T)], minfup=x$minfup)
  eDE <- eEvents(lambda=x$lambdaC * x$hr, eta=x$etaC,
    gamma=x$gamma*Qe, R=x$R, S=x$S, T=tIA, 
    Tfinal=x$T[length(x$T)], minfup=x$minfup)
  if (simple) 
  {   if (class(x)[1] == "gsSize") d<-x$d
#OLD      else d <- sum(x$eDC[length(x$eDC)]+x$eDE[length(x$eDE)])
      else if(!is.matrix(x$eDC)) d <- sum(x$eDC[length(x$eDC)]+x$eDE[length(x$eDE)])
      else d <- sum(x$eDC[nrow(x$eDC),]+x$eDE[nrow(x$eDE),])
      return(sum(eDC$d+eDE$d)-target*d)
  }
  else return(list(T=tIA,eDC=eDC$d,eDE=eDE$d,eNC=eDC$n,eNE=eDE$n))
}
###################################################
### code chunk number 36: gsSurv
###################################################
gsSurv<-function(k=3, test.type=4, alpha=0.025, sided=1,  
  beta=0.1, astar=0, timing=1, sfu=sfHSD, sfupar=-4,
  sfl=sfHSD, sflpar=-2, r=18,
  lambdaC=log(2)/6, hr=.6, hr0=1, eta=0, etaE=NULL,
  gamma=1, R=12, S=NULL, T=NULL, minfup=NULL, ratio=1,
  tol = .Machine$double.eps^0.25)
{ x<-nSurv(lambdaC=lambdaC, hr=hr, hr0=hr0, eta = eta, etaE=etaE, 
  gamma=gamma, R=R, S=S, T=T,  minfup = minfup, ratio = ratio,
  alpha = alpha, beta = beta,  sided = sided, tol = tol)  
  y<-gsDesign(k=k,test.type=test.type,alpha=alpha/sided,
      beta=beta, astar=astar, n.fix=x$d, timing=timing,
      sfu=sfu, sfupar=sfupar, sfl=sfl, sflpar=sflpar, tol=tol,
              delta1=log(hr), delta0=log(hr0))
  z<-gsnSurv(x,y$n.I[k])
  eDC <- NULL
  eDE <- NULL
  eNC <- NULL
  eNE <- NULL
  T <- NULL
  for(i in 1:(k-1)){
    xx <- tEventsIA(z,y$timing[i],tol)
    T <- c(T,xx$T)
    eDC <- rbind(eDC,xx$eDC)
    eDE <- rbind(eDE,xx$eDE)
    eNC <- rbind(eNC,xx$eNC)
    eNE <- rbind(eNE,xx$eNE)
  }
  y$T <- c(T,z$T)
  y$eDC <- rbind(eDC,z$eDC)
  y$eDE <- rbind(eDE,z$eDE)
  y$eNC <- rbind(eNC,z$eNC)
  y$eNE <- rbind(eNE,z$eNE)
  y$hr=hr; y$hr0=hr0; y$R=z$R; y$S=z$S; y$minfup=z$minfup; 
  y$gamma=z$gamma; y$ratio=ratio; y$lambdaC=z$lambdaC;
  y$etaC=z$etaC; y$etaE=z$etaE; y$variable=x$variable; y$tol=tol
  class(y) <- c("gsSurv","gsDesign")
    
  nameR<-nameperiod(cumsum(y$R))
  stratnames <- paste("Stratum",1:ncol(y$lambdaC))
  if (is.null(y$S)) nameS<-"0-Inf"
  else nameS <- nameperiod(cumsum(c(y$S,Inf)))
  rownames(y$lambdaC)<-nameS
  colnames(y$lambdaC)<-stratnames
  rownames(y$etaC)<-nameS
  colnames(y$etaC)<-stratnames
  rownames(y$etaE)<-nameS
  colnames(y$etaE)<-stratnames
  rownames(y$gamma)<-nameR
  colnames(y$gamma)<-stratnames
  return(y)
}
print.gsSurv<-function(x,digits=2,...){
  cat("Time to event group sequential design with HR=",x$hr,"\n")
  if (x$hr0 != 1) cat("Non-inferiority design with null HR=",x$hr0,"\n")
  if (min(x$ratio==1)==1) 
    cat("Equal randomization:          ratio=1\n")
  else {cat("Randomization (Exp/Control):  ratio=", 
            x$ratio, "\n")
        if (length(x$ratio)>1) cat("(randomization ratios shown by strata)\n")
  }
  print.gsDesign(x)
  if(x$test.type != 1){
    y<-cbind(x$T,(x$eNC+x$eNE)%*%array(1,ncol(x$eNE)),
            (x$eDC+x$eDE)%*%array(1,ncol(x$eNE)),
            round(zn2hr(x$lower$bound,x$n.I,x$ratio,hr0=x$hr0,hr1=x$hr),3),
            round(zn2hr(x$upper$bound,x$n.I,x$ratio,hr0=x$hr0,hr1=x$hr),3))
    colnames(y)<-c("T","n","Events","HR futility","HR efficacy")
  }else{  
    y<-cbind(x$T,(x$eNC+x$eNE)%*%array(1,ncol(x$eNE)),
                   (x$eDC+x$eDE)%*%array(1,ncol(x$eNE)),
                   round(zn2hr(x$upper$bound,x$n.I,x$ratio,hr0=x$hr0,hr1=x$hr),3))
    colnames(y)<-c("T","n","Events","HR efficacy")
  }
  rnames<-paste("IA",1:(x$k))
  rnames[length(rnames)]<-"Final"
  rownames(y)<-rnames
  print(y)
  cat("Accrual rates:\n")
  print(round(x$gamma,digits))
  cat("Control event rates (H1):\n")
  print(round(x$lambda,digits))
  if (max(abs(x$etaC-x$etaE))==0)
  {  cat("Censoring rates:\n")
     print(round(x$etaC,digits))
  }
  else
  {  cat("Control censoring rates:\n")
     print(round(x$etaC,digits))
     cat("Experimental censoring rates:\n")
     print(round(x$etaE,digits))
  }
}
xtable.gsSurv <- function(x, caption=NULL, label=NULL, align=NULL, digits=NULL,
                          display=NULL, auto=FALSE, footnote=NULL, fnwid="9cm", timename="months",...){
  k <- x$k
  stat <- c("Z-value","HR","p (1-sided)", paste("P\\{Cross\\} if HR=",x$hr0,sep=""),
            paste("P\\{Cross\\} if HR=",x$hr,sep=""))
  st <- stat
  for (i in 2:k) stat <- c(stat,st)
  an <- array(" ",5*k)
  tim <- an
  enrol <- an
  fut <- an
  eff <- an
  an[5*(0:(k-1))+1]<-c(paste("IA ",as.character(1:(k-1)),": ",
                             as.character(round(100*x$timing[1:(k-1)],1)), "\\%",sep=""), "Final analysis")
  an[5*(1:(k-1))+1] <- paste("\\hline",an[5*(1:(k-1))+1])
  an[5*(0:(k-1))+2]<- paste("N:",ceiling(rowSums(x$eNC))+ceiling(rowSums(x$eNE)))
  an[5*(0:(k-1))+3]<- paste("Events:",ceiling(rowSums(x$eDC+x$eDE)))
  an[5*(0:(k-1))+4]<- paste(round(x$T,1),timename,sep=" ")
  if (x$test.type != 1) fut[5*(0:(k-1))+1]<- as.character(round(x$lower$bound,2))
  eff[5*(0:(k-1))+1]<- as.character(round(x$upper$bound,2)) 
  if (x$test.type != 1) fut[5*(0:(k-1))+2]<- as.character(round(gsHR(z=x$lower$bound,i=1:k,x,ratio=x$ratio)*x$hr0,2))
  eff[5*(0:(k-1))+2]<- as.character(round(gsHR(z=x$upper$bound,i=1:k,x,ratio=x$ratio)*x$hr0,2)) 
  asp <- as.character(round(pnorm(-x$upper$bound),4))
  asp[asp=="0"]<-"$< 0.0001$"
  eff[5*(0:(k-1))+3] <- asp
  asp <- as.character(round(cumsum(x$upper$prob[,1]),4))
  asp[asp=="0"]<-"$< 0.0001$"
  eff[5*(0:(k-1))+4] <- asp
  asp <- as.character(round(cumsum(x$upper$prob[,2]),4))
  asp[asp=="0"]<-"$< 0.0001$"
  eff[5*(0:(k-1))+5] <- asp
  if (x$test.type != 1) {
    bsp <- as.character(round(pnorm(-x$lower$bound),4))
    bsp[bsp=="0"]<-" $< 0.0001$"
    fut[5*(0:(k-1))+3] <- bsp
    bsp <- as.character(round(cumsum(x$lower$prob[,1]),4))
    bsp[bsp=="0"]<-"$< 0.0001$"
    fut[5*(0:(k-1))+4] <- bsp
    bsp <- as.character(round(cumsum(x$lower$prob[,2]),4))
    bsp[bsp=="0"]<-"$< 0.0001$"
    fut[5*(0:(k-1))+5] <- bsp
  }
  neff <- length(eff)
  if (!is.null(footnote)) eff[neff] <- 
    paste(eff[neff],"\\\\ \\hline \\multicolumn{4}{p{",fnwid,"}}{\\footnotesize",footnote,"}")
  if (x$test.type != 1){ 
    xxtab <- data.frame(cbind(an,stat,fut,eff))
    colnames(xxtab) <- c("Analysis","Value","Futility","Efficacy")
  }else{
    xxtab <- data.frame(cbind(an,stat,eff))
    colnames(xxtab) <- c("Analysis","Value","Efficacy")
  }
  return(xtable(xxtab, caption=caption, label=label, align=align, digits=digits,
                display=display,auto=auto,...))
}

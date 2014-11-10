##################################################################################
#  S3 methods for the gsDesign package
#
#  Exported Functions:
#                   
#    summary.gsDesign
#    print.gsDesign
#    print.gsProbability
#    print.nSurvival
#    print.gsBoundSummary
#    gsBoundSummary
#    xprint
#    summary.spendfn
#
#  Hidden Functions:
#
#    gsLegendText
#    sfprint
#
#  Author(s): Keaven Anderson, PhD.
# 
#  Reviewer(s): REvolution Computing 19DEC2008 v.2.0 - William Constantine, Kellie Wills 
#
#  R Version: 2.7.2
#
#  Rewrite of gsBoundSummary and addition of print.gsBoundSummary, xprint
##################################################################################

###
# Exported Functions
###

"print.gsProbability" <- function(x,...)
{    
    ntxt <- "N "
    nval <- ceiling(x$n.I)
    nspace <- log10(x$n.I[x$k])
    for (i in 1:nspace)
    {
        cat(" ")
    }
    
    cat("            ")
    if (min(x$lower$bound) < 0)
    {
        cat(" ")
    }
    if (max(class(x) == "gsBinomialExact")==1)
    {   cat("Bounds")
        y <- cbind(1:x$k, nval, x$lower$bound, round(x$upper$bound, 2))
        colnames(y) <- c("Analysis", "  N", "  a", "  b")
    }
    else
    {   cat("Lower bounds   Upper bounds")
        y <- cbind(1:x$k, nval, round(x$lower$bound, 2), round(pnorm(x$lower$bound), 4), 
                   round(x$upper$bound, 2), round(pnorm(-x$upper$bound), 4))
        colnames(y) <- c("Analysis", ntxt, "Z  ", "Nominal p", "Z  ", "Nominal p")
    }
    rownames(y) <- array(" ", x$k)
    cat("\n")
    print(y)
    cat("\nBoundary crossing probabilities and expected sample size assume\n")
    cat("any cross stops the trial\n\n")
    j <- length(x$theta)
    sump <- 1:j
    for (m in 1:j)
    {
        sump[m] <- sum(x$upper$prob[, m])
    }
    y <- round(cbind(x$theta, t(x$upper$prob), sump, x$en), 4)
    y[, x$k+3] <- round(y[, x$k+3], 1)
    rownames(y) <- array(" ", j)
    colnames(y) <- c("Theta", 1:x$k, "Total", "E{N}")
    cat("Upper boundary (power or Type I Error)\n")
    cat("          Analysis\n")
    print(y)
    
    for (m in 1:j) 
    {
        sump[m] <- sum(x$lower$prob[, m])
    }
    
    y <- round(cbind(x$theta, t(x$lower$prob), sump), 4)
    rownames(y) <- array(" ", j)
    colnames(y) <- c("Theta", 1:x$k, "Total")
    cat("\nLower boundary (futility or Type II Error)\n")
    cat("          Analysis\n")
    print(y)
  invisible(x)
}
"summary.gsDesign" <- function(object, information=FALSE, timeunit="months",...){
  out <- NULL
  if (object$test.type == 1){
    out<- paste(out,"One-sided group sequential design with ",sep="")
  }else if (object$test.type == 2){
    out <- paste(out, "Symmetric two-sided group sequential design with ",sep="")
  }else{
    out <- paste(out, "Asymmetric two-sided group sequential design with ",sep="")
    if(object$test.type %in% c(2,3,5)) out <- paste(out, "binding futility bound, ",sep="")
    else out <- paste(out, "non-binding futility bound, ",sep="")
  }
  out <- paste(out, object$k," analyses, ",sep="")
  if (object$nFixSurv > 0)
  {   out <- paste(out, "time-to-event outcome with sample size ", ceiling(object$nSurv),
              " and ", ceiling(object$n.I[object$k]), " events required, ", sep="")
  }else if ("gsSurv" %in% class(object)){
      out <- paste(out, "time-to-event outcome with sample size ", 
                   ifelse(object$ratio==1,2*ceiling(rowSums(object$eNE))[object$k],
                                          (ceiling(rowSums(object$eNE))+ceiling(rowSums(object$eNC)))[object$k]),
                   " and ", ceiling(object$n.I[object$k]), " events required, ", sep="")
  }else if(information){out <- paste(out," total information ",round(object$n.I[object$k],2),", ",sep="")
  }else out <- paste(out, "sample size ", ceiling(object$n.I[object$k]), ", ",sep="")
  out <- paste(out, 100 * (1 - object$beta), " percent power, ", 100 * object$alpha, " percent (1-sided) Type I error",sep="")
  if("gsSurv" %in% class(object)){
    out <- paste(out," to detect a hazard ratio of ",round(object$hr,2),sep="")
    if(object$hr0 != 1) out <- paste(out," with a null hypothesis hazard ratio of ",round(object$hr0,2),sep="")
    out <- paste(out,". Enrollment and total study durations are assumed to be ",round(sum(object$R),1),
          " and ",round(max(object$T),1)," ",timeunit,", respectively",sep="")
  }
  if(object$test.type==2){out=paste(out,". Bounds derived using a ",sep="")
  }else out <- paste(out,". Efficacy bounds derived using a",sep="")
  out <- paste(out," ",summary(object$upper),".",sep="")
  if (object$test.type>2) out <- paste(out," Futility bounds derived using a ",summary(object$lower),".",sep="")
  return(out)
}
"print.gsDesign" <- function(x, ...)
{    
    if (x$nFixSurv > 0)
    {    cat("Group sequential design sample size for time-to-event outcome\n", 
         "with sample size ", x$nSurv, ". The analysis plan below shows events\n",
         "at each analysis.\n", sep="")
    }
    
    if (x$test.type == 1) 
    {
        cat("One-sided")
    }
    else if (x$test.type == 2)
    {
        cat("Symmetric two-sided")
    }
    else 
    {
        cat("Asymmetric two-sided")
    }
    
    cat(" group sequential design with\n")
    cat(100 * (1 - x$beta), "% power and", 100 * x$alpha, "% Type I Error.\n")
    if (x$test.type > 1)
    {    
        if (x$test.type==4 || x$test.type==6)
        {
            cat("Upper bound spending computations assume\ntrial continues if lower bound is crossed.\n\n")            
        }
        else
        {
            cat("Spending computations assume trial stops\nif a bound is crossed.\n\n")
        }
    }
    if (x$n.fix != 1)
    {    
        ntxt <- "N "
        nval <- ceiling(x$n.I)
        nspace <- log10(x$n.I[x$k])
        for(i in 1:nspace)
        {
            cat(" ")
        }
        cat("            ")
    }
    else
    {    
        ntxt <- "Ratio*"
        nval <- round(x$n.I, 3)
        cat("           Sample\n")
        cat("            Size ")
    }
    if (x$test.type > 2) 
    {    
        if (min(x$lower$bound) < 0)
        {
            cat(" ")
        }
        cat("  ----Lower bounds----  ----Upper bounds-----")
        y <- cbind(1:x$k, nval, round(x$lower$bound, 2), round(pnorm(x$lower$bound), 4), 
                round(x$lower$spend, 4), round(x$upper$bound, 2), round(pnorm(-x$upper$bound), 4), 
                round(x$upper$spend, 4))
        colnames(y) <- c("Analysis", ntxt, "Z  ", "Nominal p", "Spend+", "Z  ", "Nominal p", "Spend++")
    }
    else
    {    y <- cbind(1:x$k, nval, round(x$upper$bound, 2), round(pnorm(-x$upper$bound), 4), 
                round(x$upper$spend, 4))
        colnames(y) <- c("Analysis", ntxt, "Z  ", "Nominal p", "Spend")
    }
    rownames(y) <- array(" ", x$k)
    cat("\n")
    print(y)
    cat("     Total")
    if (x$n.fix != 1)
    {    
        for (i in 1:nspace)
        {
            cat(" ")
        }
    }
    else 
    {
        cat("     ")
    }
    cat("                  ")
    
    if (x$test.type>2)
    {    
        if (min(x$lower$bound) < 0)
        {
            cat(" ")
        }
        cat(format(round(sum(x$lower$spend), 4), nsmall=4), "                ")
    }
    
    cat(format(round(sum(x$upper$spend), 4), nsmall=4), "\n")
    
    if (x$test.type > 4)
    {
        cat("+ lower bound spending (under H0):\n ")
    }
    else if (x$test.type > 2)
    {
        cat("+ lower bound beta spending (under H1):\n ")
    }
    
    if (x$test.type>2) 
    {
        cat(summary(x$lower),".",sep="")
    }
    
    cat("\n++ alpha spending:\n ")
    cat(summary(x$upper),".\n",sep="") 
    
    if (x$n.fix==1)
    {
        cat("* Sample size ratio compared to fixed design with no interim\n")
    }
    
    cat("\nBoundary crossing probabilities and expected sample size\nassume any cross stops the trial\n\n")
    j <- length(x$theta)
    sump <- 1:j
    
    for (m in 1:j)
    {
        sump[m] <- sum(x$upper$prob[, m])
    }
    
    y <- round(cbind(x$theta, t(x$upper$prob), sump, x$en), 4)
    if (x$n.fix != 1)
    {
        y[, x$k+3] <- round(y[, x$k+3], 1)
    }
    rownames(y) <- array(" ", j)
    colnames(y) <- c("Theta", 1:x$k, "Total", "E{N}")
    cat("Upper boundary (power or Type I Error)\n")
    cat("          Analysis\n")
    print(y)
    if (x$test.type>1)
    {    
        for (m in 1:j) 
        {
            sump[m] <- sum(x$lower$prob[, m])
        }
        y <- round(cbind(x$theta, t(x$lower$prob), sump), 4)
        rownames(y) <- array(" ", j)
        colnames(y) <- c("Theta", 1:x$k, "Total")
        cat("\nLower boundary (futility or Type II Error)\n")
        cat("          Analysis\n")
        print(y)
    }
  invisible(x)
}
print.nSurvival <- function(x,...){
	if (class(x) != "nSurvival") stop("print.nSurvival: primary argument must have class nSurvival")
   cat("Fixed design, two-arm trial with time-to-event\n")
	cat("outcome (Lachin and Foulkes, 1986).\n")
	cat("Study duration (fixed):          Ts=", x$Ts, "\n", sep="")
	cat("Accrual duration (fixed):        Tr=", x$Tr, "\n", sep="")
	if (x$entry=="unif") cat('Uniform accrual:              entry="unif"\n')
	else {
		cat('Exponential accrual:          entry="expo"\n') 
		cat("Accrual shape parameter:      gamma=", round(x$gamma,3), "\n",sep="")
	}
	cat("Control median:      log(2)/lambda1=", round(log(2) / x$lambda1,1), "\n", sep="")
	cat("Experimental median: log(2)/lambda2=", round(log(2) / x$lambda2,1), "\n", sep="")
	if (x$eta == 0){
		cat("Censoring only at study end (eta=0)\n")
	}else{
		cat("Censoring median:        log(2)/eta=", round(log(2) / x$eta, 1), "\n", sep="")
	}
	cat("Control failure rate:       lambda1=", round(x$lambda1,3), "\n", sep="") 
	cat("Experimental failure rate:  lambda2=", round(x$lambda2,3), "\n", sep="")
	cat("Censoring rate:                 eta=", round(x$eta,3),"\n", sep="")
	cat("Power:                 100*(1-beta)=", (1-x$beta)*100, "%\n",sep="")
   cat("Type I error (", x$sided, "-sided):   100*alpha=", 100*x$alpha, "%\n", sep="")
	if (x$ratio==1) cat("Equal randomization:          ratio=1\n")
	else cat("Randomization (Exp/Control):  ratio=", x$ratio, "\n", sep="")
	if (x$type=="rr"){
		cat("Sample size based on hazard ratio=", round(x$lambda2/x$lambda1,3), ' (type="rr")\n', sep="") 
  	}else{
		cat('Sample size based on risk difference=', round(x$lambda1 - x$lambda2,3), ' (type="rd")\n', sep="")
		if (x$approx) cat("Sample size based on H1 variance only:  approx=TRUE\n")
		else cat("Sample size based on H0 and H1 variance: approx=FALSE\n")
	}
   cat("Sample size (computed):           n=", 2*ceiling(x$n/2), "\n", sep="")
   cat("Events required (computed): nEvents=", ceiling(x$nEvents), "\n",sep="")
	invisible(x)
}
gsBoundSummary <- function(x, deltaname=NULL, logdelta=FALSE, Nname=NULL, digits=4, ddigits=2, tdigits=0, timename="Month", 
                           prior=normalGrid(mu=x$delta/2, sigma=10/sqrt(x$n.fix)), 
                           POS=FALSE, ratio=NULL,exclude=c("B-value","Spending","CP","CP H1","PP"), r=18,...){
  k <- x$k
  if (is.null(Nname)){
    if(x$n.fix==1){
      Nname <- "N/Fixed design N"
    }else Nname="N"
  }
  # delta values corresponding to x$theta
  delta <- x$delta0 + (x$delta1-x$delta0)*x$theta/x$delta
  if (logdelta || "gsSurv" %in% class(x)) delta <- exp(delta)
  # ratio is only used for RR and HR calculations at boundaries
  if("gsSurv" %in% class(x)){
    ratio <- x$ratio
  }else if (is.null(ratio)) ratio <- 1
  # delta values at bounds
  # note that RR and HR are treated specially
  if (x$test.type > 1){
    if (x$nFixSurv > 0 || "gsSurv" %in% class(x) ||Nname=="HR"){
      deltafutility <- gsHR(x=x,i=1:x$k,z=x$lower$bound[1:x$k],ratio=ratio)
    }else if (tolower(Nname) =="rr"){
      deltafutility <- gsRR(x=x,i=1:x$k,z=x$lower$bound[1:x$k],ratio=ratio)
    }else{
      deltafutility <- gsDelta(x=x,i=1:x$k,z=x$lower$bound[1:x$k])
      if (logdelta==TRUE || "gsSurv" %in% class(x)) deltafutility <- exp(deltafutility)
    }
  }
  if (x$nFixSurv > 0 || "gsSurv" %in% class(x) ||Nname=="HR"){
    deltaefficacy <- gsHR(x=x,i=1:x$k,z=x$upper$bound[1:x$k],ratio=ratio)
  }else if (tolower(Nname) =="rr"){
    deltaefficacy <- gsRR(x=x,i=1:x$k,z=x$upper$bound[1:x$k],ratio=ratio)
  }else{
    deltaefficacy <- gsDelta(x=x,i=1:x$k,z=x$upper$bound[1:x$k])
    if (logdelta==TRUE || "gsSurv" %in% class(x)) deltaefficacy <- exp(deltaefficacy)
  }
  if(is.null(deltaname)){
    if ("gsSurv" %in% class(x) || x$nFixSurv>0){deltaname="HR"}else{deltaname="delta"}
  }
  # create delta names for boundary corssing probabilities
  deltanames <- paste("P(Cross) if ",deltaname,"=",round(delta,ddigits),sep="")
  pframe <- NULL
  for(i in 1:length(x$theta)) pframe <- rbind(pframe, data.frame("Value"=deltanames[i],"Efficacy"=cumsum(x$upper$prob[,i]),i=1:x$k))
  if(x$test.type>1){
    pframe2 <- NULL
    for(i in 1:length(x$theta)) pframe2 <- rbind(pframe2, data.frame("Futility"=cumsum(x$lower$prob[,i])))
    pframe <- data.frame(cbind("Value"=pframe[,1],pframe2,pframe[,-1]))
  }
  # conditional power at bound, theta=hat(theta)
  cp <- data.frame(gsBoundCP(x, r=r))
  # conditional power at bound, theta=theta[1]
  cp1<- data.frame(gsBoundCP(x, theta=x$delta, r=r))
  if (x$test.type>1){
    colnames(cp) <- c("Futility","Efficacy")
    colnames(cp1)<- c("Futility","Efficacy")
  }else{
    colnames(cp) <- "Efficacy"
    colnames(cp1)<- "Efficacy"
  }
  cp <- data.frame(cp,"Value"="CP",i=1:(x$k-1))
  cp1 <- data.frame(cp1,"Value"="CP H1",i=1:(x$k-1))
  if ("PP" %in% exclude){
    pp<-NULL
  }else{
    # predictive probability
    Efficacy <- as.vector(1:(x$k-1))
    for(i in 1:(x$k-1)) Efficacy[i] <- gsPP(x=x,i=i, zi=x$upper$bound[i], theta=prior$z, wgts=prior$wgts, r=r, total=TRUE)
    if (x$test.type>1){
      Futility <- Efficacy
      for(i in 1:(x$k-1)) Futility[i] <- gsPP(x=x,i=i, zi=x$lower$bound[i], theta=prior$z, wgts=prior$wgts, r=r, total=TRUE)
    }else Futility<- NULL
    pp <- data.frame(cbind(Efficacy,Futility,i=1:(x$k-1)))
    pp$Value="PP"
  }
  # start a frame for other statistics
  # z at bounds
  statframe <- data.frame("Value"="Z","Efficacy"=x$upper$bound,i=1:x$k)
  if (x$test.type>1) statframe<-data.frame(cbind(statframe,"Futility"=x$lower$bound))
  # add nominal p-values at each bound
  tem <- data.frame("Value"="p (1-sided)","Efficacy"=pnorm(x$upper$bound,lower.tail=FALSE),i=1:x$k)
  if(x$test.type==2)tem <- data.frame(cbind(tem,"Futility"=pnorm(x$lower$bound,lower.tail=TRUE)))
  if(x$test.type>2)tem <- data.frame(cbind(tem,"Futility"=pnorm(x$lower$bound,lower.tail=FALSE)))
  statframe <- rbind(statframe,tem)                 
  # delta values at bounds                 
  tem <- data.frame("Value"=paste(deltaname,"at bound"),"Efficacy"=deltaefficacy,i=1:x$k)
  if(x$test.type>1) tem$Futility <- deltafutility
  statframe <- rbind(statframe,tem)                 
  
  # spending
  tem <- data.frame("Value"="Spending",i=1:x$k,"Efficacy"=x$upper$spend)
  if (x$test.type>1) tem$Futility=x$lower$spend
  statframe<-rbind(statframe,tem)
  # B-values
  tem <- data.frame("Value"="B-value",i=1:x$k,"Efficacy"=gsBValue(x=x,z=x$upper$bound,i=1:x$k))
  if (x$test.type>1) tem$Futility<-gsBValue(x=x,i=1:x$k,z=x$lower$bound)
  statframe<-rbind(statframe,tem)
  # put it all together
  statframe <- rbind(statframe,cp,cp1,pp,pframe)
  # exclude rows not wanted                 
  statframe <- statframe[!(statframe$Value %in% exclude),]
  # sort by analysis
  statframe <- statframe[order(statframe$i),]
  # add analysis and timing
  statframe$Analysis <- ""
  aname <- paste("IA ",1:x$k,": ",round(100*x$timing,0),"%",sep="")
  aname[x$k]<-"Final"
  statframe[statframe$Value==statframe$Value[1],]$Analysis <- aname
  # sample size, events or information at analyses
  if (!("gsSurv" %in% class(x))){
    if(x$n.fix > 1) N <- ceiling(x$n.I) else N<-round(x$n.I,2)
    if (Nname == "Information") N <- round(x$n.I,2)
    nstat <- 2
  }else{
    nstat <- 4
    statframe[statframe$Value==statframe$Value[3],]$Analysis <- paste("Events:",ceiling(rowSums(x$eDC+x$eDE)))
    if (x$ratio==1) N <- 2*ceiling(rowSums(x$eNE)) else N <- ceiling(rowSums(x$eNE))+ceiling(rowSums(x$eNC))
    Time <- round(x$T,tdigits)
    statframe[statframe$Value==statframe$Value[4],]$Analysis <- paste(timename,": ",as.character(Time),sep="")
  }
  statframe[statframe$Value==statframe$Value[2],]$Analysis <- paste(Nname, ": ",N,sep="")
  # add POS and predicitive POS, if requested
  if (POS){
    ppos <- array("",x$k)
    for(i in 1:(x$k-1)) ppos[i] <- paste("Post IA POS: ",as.character(round(100*gsCPOS(i=i, x=x, theta=prior$z, wgts=prior$wgts),1)),"%",sep="")
    statframe[statframe$Value==statframe$Value[nstat+1],]$Analysis <-ppos 
    statframe[nstat+2,]$Analysis <- ppos[1]
    statframe[nstat+1,]$Analysis <- paste("Trial POS: ",as.character(round(100*gsPOS(x=x,theta=prior$z,wgts=prior$wgts),1)),"%",sep="")
  }
  # add futility column to data frame
  scol <- c(1,2,if(x$test.type>1){4}else{NULL})
  rval<-statframe[c(ncol(statframe),scol)]
  rval$Efficacy <- round(rval$Efficacy,digits)
  if(x$test.type>1) rval$Futility <- round(rval$Futility,digits)
  class(rval)<-c("gsBoundSummary","data.frame")
  return(rval)
}
xprint <- function(x, include.rownames=FALSE, hline.after=c(-1,which(x$Value==x[1,]$Value)-1,nrow(x)),...){
  print.xtable(x, hline.after=hline.after, include.rownames=include.rownames,...)
}
print.gsBoundSummary <- function(x,row.names=FALSE,digits=4,...){
  print.data.frame(x,row.names=row.names,digits=digits,...)
}

###
# Hidden Functions
###

"gsLegendText" <- function(test.type)
{
    switch(as.character(test.type), 
            "1" = c(expression(paste("Reject ", H[0])), "Continue"),
            "2" = c(expression(paste("Reject ", H[0])), "Continue", expression(paste("Reject ", H[0]))),
            c(expression(paste("Reject ", H[0])), "Continue", expression(paste("Reject ", H[1]))))            
}
"sfprint" <- function(x)
{   
    # print spending function information    
    if (x$name == "OF")
    {
        cat("O'Brien-Fleming boundary")
    }
    else if (x$name == "Pocock")
    {
        cat("Pocock boundary")
    }
    else if (x$name == "WT")
    {
        cat("Wang-Tsiatis boundary with Delta =", x$param)
    }
    else if (x$name == "Truncated")
    {   cat(x$param$name," spending function compressed to ",x$param$trange[1],", ",x$param$trange[2],sep="")
        if (!is.null(x$param$parname))
        {
            cat(" with", x$param$parname, "=", x$param$param)
        }
    }
    else if (x$name == "Trimmed")
    {   cat(x$param$name," spending function trimmed at ",x$param$trange[1],", ",x$param$trange[2],sep="")
        if (!is.null(x$param$parname))
        {
          cat(" with", x$param$parname, "=", x$param$param)
        }
    }
    else 
    {   
        cat(x$name, "spending function")
        if (!is.null(x$parname) && !is.null(x$param))
        {
            cat(" with", x$parname, "=", x$param)
        }
    }
    cat("\n")
}
"summary.spendfn" <- function(object,...)
{   
  # print spending function information    
  if (object$name == "OF")
  {
    s <- "O'Brien-Fleming boundary"
  }
  else if (object$name == "Pocock")
  {
    s <- "Pocock boundary"
  }
  else if (object$name == "WT")
  {
    s <- paste("Wang-Tsiatis boundary with Delta =", object$param)
  }
  else if (object$name == "Truncated")
  {   s <- paste(object$param$name," spending function compressed to ",object$param$trange[1],", ",object$param$trange[2],sep="")
      if (!is.null(object$param$parname))
      {
        s <- paste(s," with", paste(object$param$parname,collapse=" "), "=", paste(object$param$param,collapse=" "))
      }
  }
  else if (object$name == "Trimmed")
  {   s <- paste(object$param$name," spending function trimmed at ",object$param$trange[1],", ",object$param$trange[2],sep="")
      if (!is.null(object$param$parname))
      {
        s <- paste(s," with", paste(object$param$parname, collapse=" "), "=", paste(object$param$param,collapse=" "))
      }
  }
  else if (object$name == "Gapped")
  {   s <- paste(object$param$name," spending function no spending in ",object$param$trange[1],", ",object$param$trange[2],sep="")
      if (!is.null(object$param$parname))
      {
        s <- paste(s," with", paste(object$param$parname, collapse=" "), "=", paste(object$param$param,collapse=" "))
      }
  }  else 
  {   
    s<- paste(object$name, "spending function")
    if (!is.null(object$parname) && !is.null(object$param))
    {
      s<- paste(s,"with", paste(object$parname,collapse=" "), "=", paste(object$param,collapse=" "))
    }
  }
  return(s)
}
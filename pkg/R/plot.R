plot.gsDesign<-function(x,plottype=1,...)
{	if (plottype==1 || plottype=="Z" || plottype=="z") x<-plotgsZ(x,...)
	else if (plottype==2 || plottype=="Power" || plottype=="power" || plottype=="POWER") x<-plotgsPower(x,...)
	else if (plottype==3 || plottype=="xbar" || plottype=="thetahat"||plottype=="theta") x<-plotreleffect(x,...)
	else if (plottype==4 || plottype=="CP") x<-plotgsCP(x,...)
	else if (plottype==5 || plottype=="sf") x<-sfplot(x,...)
	else if (plottype==6 || max(plottype==c("ASN","asn","E{N}","N","n"))) x<-plotASN(x,...)
	else if (plottype==7 || max(plottype==c("B","B-val","B-value"))) x<-plotBval(x,...)
	invisible(x)
}
plot.gsProbability<-function(x,plottype=2,...)
{	if (plottype==1 || plottype=="Z" || plottype=="z") x<-plotgsZ(x,...)
	else if (plottype==2 || plottype=="Power" || plottype=="power" || plottype=="POWER") x<-plotgsPower(x,...)
	else if (plottype==3 || plottype=="xbar" || plottype=="thetahat"||plottype=="theta") x<-plotreleffect(x,...)
	else if (plottype==4 || plottype=="CP") x<-plotgsCP(x,...)
	else if (plottype==6 || max(plottype==c("ASN","asn","E{N}","N","n"))) x<-plotASN(x,...)
	else if (plottype==7 || max(plottype==c("B","B-val","B-value"))) x<-plotBval(x,...)
	invisible(x)
}
plotgsZ<-function(x,main="Default",ylab="Default",xlab="Default",
          lty=1,col=1,pch=22,textcex=1,legtext="Default",...)
{	if (class(x)=="gsProbability") test.type<-3
	else test.type<-x$test.type
	if (is.character(ylab)==TRUE && ylab=="Default") ylab <- "Normal critical value"
	if (is.character(xlab)==TRUE && xlab=="Default")
	{	if (x$n.I[x$k]<3) xlab<-"Sample size relative to fixed design"
		else xlab <- "N"
	}
	if (is.character(main)==TRUE && main=="Default") main <- "Group sequential stopping boundaries"
	if (is.character(legtext)==TRUE && legtext=="Default")
	{	if (test.type>2)
			legtext<-c(expression(paste("Reject ",H[0])),"Continue",expression(paste("Reject ",H[1])))
		else if (test.type==2)
			legtext<-c(expression(paste("Reject ",H[0])),"Continue",expression(paste("Reject ",H[0])))
		else if (test.type==1)
			legtext<-c(expression(paste("Reject ",H[0])),"Continue")
	}
	ymax<-ceiling(4*max(x$upper$bound))/4
	if (test.type==1) ymin<-floor(4*min(x$upper$bound))/4
	else ymin <- floor(4*min(x$lower$bound))/4
	if (ymin==ymax) ymin<-ymin-.25
	ymid<-(x$upper$bound[2]+x$lower$bound[2])/2
	if (test.type==1)
	{	plot(x$n.I, x$upper$bound, xlab=xlab, ylab=ylab, main = main,
     			ylim=c(ymin, ymax), type="l",...)
		points(x$n.I, x$upper$bound,...)
		ymid<-ymin
	}
	else
	{	matplot(x$n.I, cbind(x$lower$bound,x$upper$bound), xlab=xlab, ylab=ylab, main = main,
     			lty=lty,col=col,ylim=c(ymin, ymax), type="l",...)
		matpoints(x$n.I, cbind(x$lower$bound,x$upper$bound),pch=pch,col=col,...)
		text(x$n.I[2],ymin,legtext[3],cex=textcex)
	}
	text(x$n.I[2],ymid,legtext[2],cex=textcex)
	text(x$n.I[2],ymax,legtext[1],cex=textcex)
	invisible(x)
}
plotBval<-function(x,main="Default",ylab="Default",xlab="Default",
          lty=1,col=1,pch=22,textcex=1,legtext="Default",...)
{	if (class(x)=="gsProbability") test.type<-3
	else test.type<-x$test.type
	if (is.character(ylab)==TRUE && ylab=="Default") ylab <- "B-value"
	if (is.character(xlab)==TRUE && xlab=="Default")
	{	if (x$n.I[x$k]<3) xlab<-"Sample size relative to fixed design"
		else xlab <- "N"
	}
	if (is.character(main)==TRUE && main=="Default") main <- "B-values at stopping boundaries"
	if (is.character(legtext)==TRUE && legtext=="Default")
	{	if (test.type>2)
			legtext<-c(expression(paste("Reject ",H[0])),"Continue",expression(paste("Reject ",H[1])))
		else if (test.type==2)
			legtext<-c(expression(paste("Reject ",H[0])),"Continue",expression(paste("Reject ",H[0])))
		else if (test.type==1)
			legtext<-c(expression(paste("Reject ",H[0])),"Continue")
	}
	sqrtt<-sqrt(x$n.I/x$n.I[x$k])
	ymax<-ceiling(4*max(sqrtt*x$upper$bound))/4
	if (test.type==1) ymin<-0
	else ymin <- min(0,floor(4*min(sqrtt*x$lower$bound))/4)
	if (ymin==ymax) ymin<-ymin-.25
	ymid<-sqrtt[2]*(x$upper$bound[2]+x$lower$bound[2])/2
	if (test.type==1)
	{	plot(x$n.I, sqrtt*x$upper$bound, xlab=xlab, ylab=ylab, main = main,
     			ylim=c(ymin, ymax), xlim=c(0,x$n.I[x$k]),type="l",...)
		points(x$n.I, sqrtt*x$upper$bound,...)
		ymid<-ymin
	}
	else
	{	matplot(x$n.I, cbind(sqrtt*x$lower$bound,sqrtt*x$upper$bound), xlab=xlab, ylab=ylab, main = main,
     			lty=lty,col=col,ylim=c(ymin, ymax), xlim=c(0,x$n.I[x$k]),type="l",...)
		matpoints(x$n.I, cbind(sqrtt*x$lower$bound,sqrtt*x$upper$bound),pch=pch,col=col,...)
		text(x$n.I[2],ymin,legtext[3],cex=textcex)
	}
	text(x$n.I[2],ymid,legtext[2],cex=textcex)
	text(x$n.I[2],ymax,legtext[1],cex=textcex)
	invisible(x)
}
plotreleffect<-function(x,main="Default",ylab="Default",xlab="Default",
          lty=1,col=1,pch=22,textcex=1,legtext="Default",ses=TRUE,...)
{	if (class(x)=="gsDesign") test.type<-x$test.type
	else test.type="3"
	if (ses && class(x)=="gsDesign") psi<-1/x$delta
	else psi<-1
	if (is.character(ylab)==TRUE && ylab=="Default") 
	{	if (ses && class(x)=="gsDesign") ylab <- expression(paste("Observed effect (",hat(theta)/delta,")"))
		else ylab <- expression(paste("Observed effect (",hat(theta),")"))
	}
	if (is.character(xlab)==TRUE && xlab=="Default")
	{	if (x$n.I[x$k]<3) xlab<-"Sample size relative to fixed design"
		else xlab <- "N"
	}
	if (is.character(main)==TRUE && main=="Default") main <- "Observed treatment effect at stopping boundaries"
	if (is.character(legtext)==TRUE && legtext=="Default")
	{	if (test.type>2)
			legtext<-c(expression(paste("Reject ",H[0])),"Continue",expression(paste("Reject ",H[1])))
		else if (test.type==2)
			legtext<-c(expression(paste("Reject ",H[0])),"Continue",expression(paste("Reject ",H[0])))
		else if (test.type==1)
			legtext<-c(expression(paste("Reject ",H[0])),"Continue")
	}
	thathi<-x$upper$bound/sqrt(x$n.I)*psi
	ymax<-ceiling(4*max(thathi))/4
	if (test.type==1) 
	{	ymid<-floor(4*min(thathi))/4
		ymin<-ymid
	}
	else 
	{	thatlow<-x$lower$bound/sqrt(x$n.I)*psi
		ymin <- floor(4*min(thatlow))/4
		ymid <- (thathi[2]+thatlow[2])/2
		if (ymin==ymax) ymid<-ymid-.25
	}
	if (test.type==1)
	{	plot(x$n.I, thathi, xlab=xlab, ylab=ylab, main = main,
     			ylim=c(ymin, ymax), type="l",...)
		points(x$n.I, thathi,...)
	}
	else
	{	matplot(x$n.I, cbind(thatlow,thathi), xlab=xlab, ylab=ylab, main = main,
     			lty=lty,col=col,ylim=c(ymin, ymax), type="l",...)
		matpoints(x$n.I, cbind(thatlow,thathi),pch=pch,col=col,...)
		text(x$n.I[2],ymin,legtext[3],cex=textcex)
	}
	text(x$n.I[2],ymid,legtext[2],cex=textcex)
	text(x$n.I[2],ymax,legtext[1],cex=textcex)
	invisible(list(n.I=x$n.I,lower=thatlow,upper=thathi))
}
plotgsCP<-function(x,theta="thetahat",main="Default",ylab="Default",xlab="Default",
          lty=1,col=1,pch=22,textcex=1,legtext="Default",...)
{	if (class(x)=="gsProbability") test.type<-3
	else test.type<-x$test.type
	if (ylab=="Default")
	{	if (theta=="thetahat") ylab <- expression(paste("Conditional power at"," ",theta,"=",hat(theta)))
		else ylab <- expression(paste("Conditional power at"," ",theta,"=",delta))
	}
	if (x$n.I[x$k]<3) xlab<-"Sample size relative to fixed design"
	else xlab <- "N"
	if (main=="Default") main <- "Conditional power at interim stopping boundaries"
	if (legtext=="Default")
	{	if (test.type>2)
			legtext<-c(expression(paste("Reject ",H[0])),"Continue",expression(paste("Reject ",H[1])))
		else if (test.type==2)
			legtext<-c(expression(paste("Reject ",H[0])),"Continue",expression(paste("Reject ",H[0])))
		else if (test.type==1)
			legtext<-c(expression(paste("Reject ",H[0])),"Continue")
	}
	y<-gsBoundCP(x,theta=theta)
	ymax<-1.05
	ymin<- -0.05
	if (x$k>3) xtext<-x$n.I[2]
	else if (x$k==3) xtext<-(x$n.I[2]+x$n.I[1])/2
	else xtext<-x$n.I[1]
	if (test.type>1) ymid<-(y[2,2]+y[2,1])/2
	if (test.type==1)
	{	plot(x$n.I[1:(x$k-1)],y, xlab=xlab, ylab=ylab, main = main,
     			ylim=c(ymin, ymax), type="l",...)
		points(x$n.I[1:(x$k-1)], y,...)
		ymid<-ymin
	}
	else
	{	matplot(x$n.I[1:(x$k-1)], y, xlab=xlab, ylab=ylab, main = main,
     			lty=lty,col=col,ylim=c(ymin, ymax), type="l",...)
		matpoints(x$n.I[1:(x$k-1)], y,pch=pch,col=col,...)
		text(xtext,ymin,legtext[3],cex=textcex)
	}
	text(xtext,ymid,legtext[2],cex=textcex)
	text(xtext,1.03,legtext[1],cex=textcex)
	invisible(x)
}
sfplot<-function(x,xlab="Default",ylab="Default",ylab2="Default",oma=c(2,2,2,2),
	 legend="Default",mai=c(.85,.75,.5,.5),lty=1:2,xmax=1,...)
{	t<-0:40/40*xmax
	if (is.character(ylab )==TRUE && ylab=="Default")  ylab<-expression(paste(alpha,"-spending"))
	if (is.character(ylab2)==TRUE && ylab2=="Default") ylab2<-expression(paste(beta,"-spending"))
	if (is.character(xlab )==TRUE && xlab=="Default") 
	{	if (max(x$n.I)>3) xlab<-"N"
		else xlab<-"Proportion of total sample size"
	}
	legtext<-legend
	if (is.character(legend)==TRUE && legend=="Default") 
	{	legend<-c(expression(paste(alpha,"-spending")),
				expression(paste(beta,"-spending")))
		if (x$test.type>4) legend<-c("Upper bound","Lower bound")
	} 
	if (x$test.type>2) par(mai=mai,oma=oma) 
	plot(t,x$upper$sf(x$alpha,t,x$upper$param)$spend,type="l",ylab=ylab,xlab=xlab,...)
	if (x$test.type>2)
	{	if (is.character(legtext)==TRUE && legtext!="") 
			legend(x=c(.0,.43),y=x$alpha*c(.85,1),lty=lty,legend=legend)
		par(new=TRUE)
		plot(t,x$lower$sf(x$beta,t,x$lower$param)$spend,ylim=c(0,x$beta),type="l",ylab="",main="",yaxt="n",xlab=xlab,lty=2)
		axis(4)
		mtext(text=ylab2, side = 4,outer=TRUE)
}	}
plotASN<-function(x,xlab="Default",ylab="Default",main="Default",theta="Default",xval="Default",type="l",...)
{	if (class(x)=="gsDesign" && x$n.fix==1) 
	{	if (is.character(ylab) && ylab=="Default") ylab <- "E{N} relative to fixed design"
		if (is.character(main) && main=="Default") main <- "Expected sample size relative to fixed design"
	}
	if (is.character(ylab) && ylab=="Default") ylab <- "E{N} relative to fixed design"
	if (is.character(main) && main=="Default") main <- "Expected sample size by treatment difference"

	if (is.character(theta) && theta=="Default")
	{	if (class(x)=="gsDesign") theta<-seq(0,2,.05)*x$delta
		else theta<-x$theta
	}
	if (is.character(xval) && xval=="Default")
	{	if (class(x)=="gsDesign" && is.character(xlab) && xlab=="Default")
		{	xval<-theta/x$delta
			if (is.character(xlab) && xlab=="Default") xlab<-expression(theta/delta)
		}
		else
		{	xval<-theta
			if (is.character(xlab) && xlab=="Default") xlab<-expression(theta)
	}	}
	if (is.character(xlab) && xlab=="Default") xlab<-""
	if (class(x)=="gsDesign") x<-gsProbability(d=x,theta=theta)
	else x<-gsProbability(k=x$k,a=x$lower$bound,b=x$upper$bound,n.I=x$n.I,theta=theta)
	plot(xval,x$en,type=type,ylab=ylab,xlab=xlab,main=main,...)
	invisible(x)
}
plotgsPower<-function(x,main="Default",ylab="Default",xlab="Default",title="Boundary",
		legtext=c("Upper","Lower"),lty=c(1,2),col=c(1,2),lwd=1,theta="Default",xval="Default",...)
{	if (is.character(ylab)==TRUE && ylab=="Default") ylab <- "Boundary Crossing Probalities"
	if (is.character(main)==TRUE && main=="Default") main <- "Group sequential power plot"
	if (is.character(theta) && theta=="Default")
	{	if (class(x)=="gsDesign") theta<-seq(0,2,.05)*x$delta
		else theta<-x$theta
	}
	if (is.character(xval) && xval=="Default")
	{	if (class(x)=="gsDesign" && is.character(xlab) && xlab=="Default")
		{	xval<-theta/x$delta
			if (is.character(xlab) && xlab=="Default") xlab<-expression(theta/delta)
		}
		else
		{	xval<-theta
			if (is.character(xlab) && xlab=="Default") xlab<-expression(theta)
	}	}
	if (is.character(xlab) && xlab=="Default") xlab<-""
	if (class(x)=="gsDesign") x<-gsProbability(d=x,theta=theta)
	else x<-gsProbability(k=x$k,a=x$lower$bound,b=x$upper$bound,n.I=x$n.I,theta=theta)
	if (length(col)>1) col2<-col[2]
	else col2<-col
	if (length(lwd)>1) lwd2<-lwd[2]
	else lwd2<-lwd
	if (length(lty)>1) lty2<-lty[2]
	else lty2<-lty
	if (class(x)=="gsDesign" && x$test.type<=2) ylim=c(0,1)
	else ylim=c(0,1.25)
	plot(xval, x$upper$prob[1,], xlab=xlab, main=main, ylab=ylab,
		ylim=ylim, type="l", col=col[1], lty=lty[1], lwd=lwd[1], yaxt = "n")
	if (class(x)=="gsDesign"&& x$test.type <= 2)
	{	axis(2,seq(0,1,0.1))
		axis(4,seq(0,1,0.1))
	}
	else
	{	axis(4, seq(0,1, by =0.1))
		axis(2,seq(0,1,.1),labels=1-seq(0,1,.1),col.axis=col2,col=col2)
	}
	if (x$k==1) return(invisible(x))
	if ((class(x)=="gsDesign" && x$test.type>2)||class(x)!="gsDesign")
	{	lines(xval,1-x$lower$prob[1,],lty=lty2, col=col2, lwd=lwd2)
		plo<-x$lower$prob[1,]
		for (i in 2:x$k)
		{	plo <- plo+x$lower$prob[i,]
			lines(xval,1-plo,lty=lty2, col=col2, lwd=lwd2)
		}
		temp <-  legend("topleft", legend = c(" ", " "), col=col,
				text.width = strwidth("Lower"), lwd=lwd,
				lty = lty, xjust = 1, yjust = 1,
				title = title)
		text(temp$rect$left + temp$rect$w, temp$text$y,
				legtext, col=col, pos=2)
	}
	phi<-x$upper$prob[1,]
	for (i in 2:x$k)
	{	phi <- phi+x$upper$prob[i,]
		lines(xval, phi, col=col[1], lwd=lwd[1], lty=lty[1])
	}
	invisible(x)
}


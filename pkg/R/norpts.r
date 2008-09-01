# produce grid points and weights for numerical integration of normal density
norpts<-function(r=18,bounds=c(0,0),mu=0,sigma=1)
{	errcode<-0
	errmsg<-"No errors detected"
	storage.mode(r)<-"integer"
	if (r<1 || r>80) return(list(z=NULL,wgts=NULL,errcode=1,errmsg="r must be from 1 to 80"))
	z<-as.double(c(1:(12*r-3)))
	w<-z
	if (length(bounds) != 2 || !is.numeric(bounds))
	   return(list(z=NULL,wgts=NULL,errcode=2,errmsg="bounds variable in norpts must be numeric and have length 2"))
	if (bounds[1]==0. && bounds[2]==0.)
	{	bounds[1]<- mu-6*sigma
		bounds[2]<- mu+6*sigma
	}
	else if (bounds[2]<=bounds[1])
		return(list(z=NULL,wgts=NULL,errcode=errcode,errmsg=errmsg))
	b<-as.double((bounds-mu)/sigma)
	xx<-.C("stdnorpts",r,b,z,w)
      len<-sum(xx[[3]]<=b[2])
	z<-xx[[3]][1:len]*sigma+mu
	w<-xx[[4]][1:len]*sigma*dnorm(z,mean=mu,sd=sigma)
	list(z=z,wgts=w,errcode=errcode,errmsg=errmsg)
}

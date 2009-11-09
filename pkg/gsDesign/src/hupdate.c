#include <stdio.h>
#include <math.h>
void hupdate(double theta, double *wgt,
             int m1, double Ikm1,double *zkm1,double *hkm1,
             int m2, double Ik,  double *zk,  double *hk
            )
{   double deltak,x,rtIk,rtIkm1,rtdeltak;
    int i,ii;
    deltak=Ik-Ikm1; /* incremental information */
    rtdeltak=sqrt(deltak);
    rtIk=sqrt(Ik);
    rtIkm1=sqrt(Ikm1);
    for(i=0;i<=m2;i++)
    {   hk[i]=0.;
    /*if(i==0) printf("z        h        zadj      h*f:\n");*/
        for(ii=0;ii<=m1;ii++)
        {   x=(zk[i]*rtIk-zkm1[ii]*rtIkm1-theta*deltak)/rtdeltak;
            hk[i]+=hkm1[ii]*exp(-x*x/2)/2.506628275*rtIk/rtdeltak;
	    /*    if (i==0) printf("%lf %lf %lf %lf\n",zkm1[ii],hkm1[ii],x,
		  hkm1[ii]*exp(-x*x/2)/2.506628275);*/
        }
        hk[i]*=wgt[i];
	/*if(i==0) printf("z        w         h:\n");
	  printf("%lf %lf %lf\n",zk[i],wgt[i],hk[i]);*/
}   }

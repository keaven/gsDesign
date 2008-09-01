#define DEBUG 0
#define EXTREMEZ 2000
#include "R.h"
#include "Rmath.h"
/* Group sequential probability computation per Jennison & Turnbull
   Computes upper bound to have input crossing probabilities given fixed input lower bound.
   xnanal- # of possible analyses in the group-sequential designs
           (interims + final)
	xtheta- drift parameter
   I     - statistical information available at each analysis
   a     - lower cutoff points for z statistic at each analysis (input)
   b     - upper cutoff points for z statistic at each analysis (output)
   problo- output vector with probability of rejecting (Z<aj) at
           jth interim analysis, j=1...nanal
   probhi- input vector with probability of rejecting (Z>bj) at
           jth interim analysis, j=1...nanal
	tol   - relative change between iterations required to stop for 'convergence'
	xr    - controls # of grid points for numerical integration per Jennison & Turnbull
	        they recommend r=17 (r=18 is default - a little more accuracy)
	retval- error flag returned; 0 if convergence; 1 indicates error
	printerr- 1 if error messages to be printed - other values suppress printing
*/
void gsbound1(int *xnanal,double *xtheta,double *I,double *a,double *b,double *problo,
             double *probhi,double *xtol,int *xr,int *retval,int *printerr)
{   int i,ii,j,m1,m2,r,nanal;
    double plo=0.,phi,dphi,btem=0.,btem2,rtdeltak,rtIk,rtIkm1,xlo,xhi,theta,mu,tol,bdelta;
/* note: should allocat zwk & wwk dynamically...*/
    double zwk[1000],wwk[1000],hwk[1000],zwk2[1000],wwk2[1000],hwk2[1000],
           *z1,*z2,*w1,*w2,*h,*h2,*tem;
    void h1(double,int,double *,double,double *, double *);
    void hupdate(double,double *,int,double,double *, double *,
                                 int,double,double *, double *);
    int gridpts(int,double,double,double,double *, double *);
    r=xr[0]; nanal= xnanal[0]; theta= xtheta[0]; tol=xtol[0]; 
    if (nanal < 1 || r<1 || r>83) 
	 {	   retval[0]=1;
 	 		if (*printerr)
			{	Rprintf("gsbound1 error: illegal argument");
				if (nanal<1) Rprintf("; nanal=%d--must be > 0",nanal);
				if (r<1 || r> 83) Rprintf("; r=%d--must be >0 and <84",r);
				Rprintf("\n");
			}
	 		return;
	 }
    rtIk=sqrt(I[0]);
	 mu=rtIk*theta;							/* mean of normalized statistic at 1st interim */
	 problo[0]=pnorm(mu-a[0],0.,1.,0,0);			/* probability of crossing lower bound at 1st interim */
    b[0]=qnorm(probhi[0],mu,1,0,0);			/* upper bound at 1st interim */
	 if (nanal==1) {retval[0]=0; return;}
/* set up work vectors */
    z1=zwk; w1=wwk; h=hwk;
    z2=zwk2; w2=wwk2; h2=hwk2;
	 if (DEBUG) Rprintf("r=%d mu=%lf a[0]=%lf b[0]=%lf\n",r,mu,a[0],b[0]);
    m1=gridpts(r,mu,a[0],b[0],z1,w1);
    h1(theta,m1,w1,I[0],z1,h); 
    /* use Newton-Raphson to find subsequent interim analysis cutpoints */
	 retval[0]=0;
    for(i=1;i<nanal;i++)
    {   rtIkm1=rtIk; rtIk=sqrt(I[i]); mu=rtIk*theta; rtdeltak=sqrt(I[i]-I[i-1]);
		  btem2=qnorm(probhi[i],mu,1.,0,0); bdelta=1.; j=0;
        while((bdelta>tol) && j++ < 20)
		  {   phi=0.; dphi=0.; plo=0.;
            btem=btem2;
				if (DEBUG) Rprintf("i=%d m1=%d\n",i,m1);
	/* compute probability of crossing boundaries & their derivatives */
            for(ii=0;ii<=m1;ii++)
            {   xhi=(z1[ii]*rtIkm1-btem*rtIk+theta*(I[i]-I[i-1]))/rtdeltak;
                phi += pnorm(xhi,0.,1.,1,0)*h[ii];
					 xlo=(z1[ii]*rtIkm1-a[i]*rtIk+theta*(I[i]-I[i-1]))/rtdeltak;
					 plo += pnorm(xlo,0.,1.,0,0)*h[ii];
                dphi-=h[ii]*exp(-xhi*xhi/2)/2.506628275*rtIk/rtdeltak;
					 if (DEBUG) Rprintf("m1=%d ii=%d xhi=%lf phi=%lf xlo=%lf plo=%lf dphi=%lf\n",m1,ii,xhi,phi,xlo,plo,dphi);
            }
            /* use 1st order Taylor's series to update boundaries */
            /* maximum allowed change is 1 */
            /* maximum value allowed is EXTREMEZ */
            if (DEBUG)
                Rprintf("i=%2d j=%2d plo=%lf btem=%lf phi=%lf dphi=%lf\n",i,j,plo,btem,phi,dphi);
            bdelta=probhi[i]-phi;
            if (bdelta<dphi) btem2=btem+1.;
            else if (bdelta > -dphi) btem2=btem-1.;
            else btem2=btem+(probhi[i]-phi)/dphi;
            if (btem2>EXTREMEZ) btem2=EXTREMEZ;
            else if (btem2< -EXTREMEZ) btem2= -EXTREMEZ;
            bdelta=btem2-btem; if (bdelta<0) bdelta= -bdelta;
        }
        b[i]=btem;
	problo[i]=plo;
		/* if convergence did not occur, set flag for return value */
        if (bdelta > tol)
		  {   if (*printerr) printf("gsbound1 error: No convergence for boundary for interim %d; I=%7.0lf; last 2 upper boundary values: %lf %lf\n",
					i+1,I[i],btem,btem2);
				retval[0]=1;
		  }
        if (i<nanal-1)
        {   m2=gridpts(r,mu,a[i],b[i],z2,w2);
            hupdate(theta,w2,m1,I[i-1],z1,h,m2,I[i],z2,h2);
            m1=m2;
            tem=z1; z1=z2; z2=tem;
            tem=w1; w1=w2; w2=tem;
            tem=h;  h=h2;  h2=tem;
    }   }
	 return;
}


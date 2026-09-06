#ifndef GSDESIGN_H
#define GSDESIGN_H

/* 1 / sqrt(2 * pi): shared scale factor for standard normal density. */
static const double gs_inv_sqrt_2pi = 0.3989422804014327;

/* Quadrature methods for the recursive integration (see gsquad.c). */
#define GS_QUAD_JT 0 /* Jennison & Turnbull grid with Simpson's rule */
#define GS_QUAD_GL 1 /* Gauss-Legendre on the continuation region */

/* Standard normal lower/upper tail probability used in the boundary search
   and the crossing probabilities. R's pnorm() is the reference; erfc() from
   the C library is a faster alternative with equivalent accuracy on
   platforms with a high quality libm (opt in with -DGS_USE_ERFC). */
#ifdef GS_USE_ERFC
#include <math.h>
#define GS_PNORM_LOWER(x) (0.5 * erfc(-(x) * M_SQRT1_2))
#define GS_PNORM_UPPER(x) (0.5 * erfc((x) * M_SQRT1_2))
#else
#define GS_PNORM_LOWER(x) pnorm((x), 0., 1., 1, 0)
#define GS_PNORM_UPPER(x) pnorm((x), 0., 1., 0, 0)
#endif

void gsbound(int *xnanal, double *I, double *a, double *b, double *problo,
             double *probhi, double *xtol, int *xr, int *retval, int *printerr,
             int *method);
void gsbound1(int *xnanal, double *xtheta, double *I, double *a, double *b,
              double *problo, double *probhi, double *xtol, int *xr,
              int *retval, int *printerr, int *method);
void probrej(int *xnanal, int *ntheta, double *xtheta, double *I, double *a,
             double *b, double *xproblo, double *xprobhi, int *xr,
             int *method);
void gsdensity(double *den, int *xnanal, int *ntheta, double *xtheta, double *I,
               double *a, double *b, double *xz, int *zlen, int *xr,
               int *method);
void stdnorpts(int *r, double *bounds, double *z, double *w);
int gridpts(int r, double mu, double a, double b, double *z, double *w);
int gsgrid(int method, int r, double mu, double a, double b, double sig,
           double *z, double *w);
double gs_kernel_width(const double *I, int i, int nanal);
void h1(double theta, int m, double *wgt, double I, double *z, double *h);
void hupdate(double theta, double *wgt, int m1, double Ikm1, double *zkm1,
             double *hkm1, int m2, double Ik, double *zk, double *hk);
double probneg(double theta, int m, double ak, double *z, double *h,
               double Ikm1, double Ik);
double probpos(double theta, int m, double bk, double *z, double *h,
               double Ikm1, double Ik);

#endif

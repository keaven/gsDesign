#ifndef GSDESIGN_H
#define GSDESIGN_H

/* 1 / sqrt(2 * pi): shared scale factor for standard normal density. */
static const double gs_inv_sqrt_2pi = 0.3989422804014327;

void gsbound(int *xnanal, double *I, double *a, double *b, double *problo,
             double *probhi, double *xtol, int *xr, int *retval, int *printerr);
void gsbound1(int *xnanal, double *xtheta, double *I, double *a, double *b,
              double *problo, double *probhi, double *xtol, int *xr,
              int *retval, int *printerr);
void probrej(int *xnanal, int *ntheta, double *xtheta, double *I, double *a,
             double *b, double *xproblo, double *xprobhi, int *xr);
void gsdensity(double *den, int *xnanal, int *ntheta, double *xtheta, double *I,
               double *a, double *b, double *xz, int *zlen, int *xr);
void stdnorpts(int *r, double *bounds, double *z, double *w);

#endif

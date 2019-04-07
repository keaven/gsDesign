#include "R.h"
#include "Rmath.h"
#include "Rinternals.h"
#include "R_ext/Rdynload.h"
#include "gsDesign.h"

/* This file is to register all .C entry points in gsDesign: 
gsbound; gsbound1; probrej; gsdensity; stdnorpts */

/*
void gsbound(int *xnanal,double *I,double *a,double *b,double *problo,double *probhi,
             double *xtol,int *xr,int *retval,int *printerr) */

static R_NativePrimitiveArgType gsbound_t[] = {
  INTSXP, REALSXP, REALSXP, REALSXP, REALSXP, REALSXP, REALSXP, INTSXP, INTSXP, INTSXP
};

/*
void gsbound1(int *xnanal,double *xtheta,double *I,double *a,double *b,double *problo,
              double *probhi,double *xtol,int *xr,int *retval,int *printerr) */

static R_NativePrimitiveArgType gsbound1_t[] = {
  INTSXP, REALSXP, REALSXP, REALSXP, REALSXP, REALSXP, REALSXP, REALSXP, INTSXP, INTSXP, INTSXP
};

/*
void probrej(int *xnanal,int *ntheta,double *xtheta,double *I,double *a,double *b,
             double *xproblo,double *xprobhi,int *xr) */

static R_NativePrimitiveArgType probrej_t[] = {
  INTSXP, INTSXP, REALSXP, REALSXP, REALSXP, REALSXP, REALSXP, REALSXP, INTSXP
};

/*
void gsdensity(double *den, int *xnanal, int *ntheta, double *xtheta,
               double *I, double *a, double *b, double *xz,
               int *zlen, int *xr) */

static R_NativePrimitiveArgType gsdensity_t[] = {
  REALSXP, INTSXP, INTSXP, REALSXP, REALSXP, REALSXP, REALSXP, REALSXP, INTSXP, INTSXP
};

/*
void stdnorpts(int *r,double *bounds,double *z,double *w) */

static R_NativePrimitiveArgType stdnorpts_t[] = {
  INTSXP, REALSXP, REALSXP, REALSXP
};

/* define array of all C entry points */
static const R_CMethodDef CEntries[] = {
  {"gsbound", (DL_FUNC) &gsbound, 10, gsbound_t},
  {"gsbound1", (DL_FUNC) &gsbound1, 11, gsbound1_t},
  {"probrej", (DL_FUNC) &probrej, 9, probrej_t},
  {"gsdensity", (DL_FUNC) &gsdensity, 10, gsdensity_t},
  {"stdnorpts", (DL_FUNC) &stdnorpts, 4, stdnorpts_t},
  {NULL, NULL, 0, NULL}
};

/* now register in the init function */
void R_init_gsDesign(DllInfo *dll)
{
  R_registerRoutines(dll, CEntries, NULL, NULL, NULL);

  /* the DLL is to be searched for entry points specified by character strings as well */
  R_useDynamicSymbols(dll, TRUE);

  /* allow .C calls by character strings: */
  R_forceSymbols(dll, FALSE);
}
/**
 * @file
 * @brief Register native routines for the gsDesign package.
 */

#include "R.h"
#include "R_ext/Rdynload.h"
#include "Rinternals.h"
#include "Rmath.h"
#include "gsDesign.h"

/* Argument types for `.C("gsbound")`. */
static R_NativePrimitiveArgType gsbound_t[] = {
    INTSXP,  REALSXP, REALSXP, REALSXP, REALSXP,
    REALSXP, REALSXP, INTSXP,  INTSXP,  INTSXP};

/* Argument types for `.C("gsbound1")`. */
static R_NativePrimitiveArgType gsbound1_t[] = {
    INTSXP,  REALSXP, REALSXP, REALSXP, REALSXP, REALSXP,
    REALSXP, REALSXP, INTSXP,  INTSXP,  INTSXP};

/* Argument types for `.C("probrej")`. */
static R_NativePrimitiveArgType probrej_t[] = {INTSXP,  INTSXP,  REALSXP,
                                               REALSXP, REALSXP, REALSXP,
                                               REALSXP, REALSXP, INTSXP};

/* Argument types for `.C("gsdensity")`. */
static R_NativePrimitiveArgType gsdensity_t[] = {
    REALSXP, INTSXP,  INTSXP,  REALSXP, REALSXP,
    REALSXP, REALSXP, REALSXP, INTSXP,  INTSXP};

/* Argument types for `.C("stdnorpts")`. */
static R_NativePrimitiveArgType stdnorpts_t[] = {INTSXP, REALSXP, REALSXP,
                                                 REALSXP};

/* define array of all C entry points */
static const R_CMethodDef CEntries[] = {
    {"gsbound", (DL_FUNC)&gsbound, 10, gsbound_t},
    {"gsbound1", (DL_FUNC)&gsbound1, 11, gsbound1_t},
    {"probrej", (DL_FUNC)&probrej, 9, probrej_t},
    {"gsdensity", (DL_FUNC)&gsdensity, 10, gsdensity_t},
    {"stdnorpts", (DL_FUNC)&stdnorpts, 4, stdnorpts_t},
    {NULL, NULL, 0, NULL}};

/**
 * @brief Register native routines with R.
 *
 * Called by R when the package shared library is loaded.
 *
 * @param[in] dll R DLL information structure.
 * @return Nothing.
 */
void R_init_gsDesign(DllInfo *dll) {
  R_registerRoutines(dll, CEntries, NULL, NULL, NULL);

  /* the DLL is to be searched for entry points specified by character strings
   * as well */
  R_useDynamicSymbols(dll, TRUE);

  /* allow .C calls by character strings: */
  R_forceSymbols(dll, FALSE);
}

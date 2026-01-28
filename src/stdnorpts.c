#include "gsDesign.h"

void stdnorpts(int *r, double *bounds, double *z, double *w) {
  int gridpts(int, double, double, double, double *, double *);
  gridpts(r[0], 0., bounds[0], bounds[1], z, w);
}

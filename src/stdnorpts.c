/**
 * @file stdnorpts.c
 * @brief A short description of the file.
 * @author Keaven Anderson <keaven_anderson@merck.com>
 */

#include "gsDesign.h"

/**
 * @brief A short description of the function.
 *
 * Optional full description of the function,
 * where blank lines start new paragraphs.
 *
 * @param r TBA
 * @param bounds TBA
 * @param z TBA
 * @param w TBA
 *
 * @return Void.
 */
void stdnorpts(int *r, double *bounds, double *z, double *w)
{
	int gridpts(int, double, double, double, double *, double *);
	gridpts(r[0], 0., bounds[0], bounds[1], z, w);
}

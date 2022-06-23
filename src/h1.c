/**
 * @file h1.c
 * @brief A short description of the file.
 * @author Keaven Anderson <keaven_anderson@merck.com>
 */

#include <stdio.h>
#include <math.h>

/**
 * @brief A short description of the function.
 *
 * Optional full description of the function,
 * where blank lines start new paragraphs.
 *
 * @param theta TBA
 * @param m TBA
 * @param wgt TBA
 * @param I TBA
 * @param z TBA
 * @param h TBA
 *
 * @return Void.
 */
void h1(double theta, int m, double *wgt, double I, double *z, double *h)
{
    int i;
    double x, mu;
    mu = theta * sqrt(I);
    for (i = 0; i <= m; i++)
    {
        x = z[i] - mu;
        h[i] = wgt[i] * exp(-x * x / 2) / 2.506628275;
    }
}

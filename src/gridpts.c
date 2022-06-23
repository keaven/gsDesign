/**
 * @file gridpts.c
 * @brief A short description of the file.
 * @author Keaven Anderson <keaven_anderson@merck.com>
 */

#include <math.h>

/**
 * @brief A short description of the function.
 *
 * Optional full description of the function,
 * where blank lines start new paragraphs.
 *
 * @param r TBA
 * @param mu TBA
 * @param z TBA
 *
 * @return Void.
 */
void gridpts1(int r, double mu, double *z)
{
   int i, r5, r6;
   double rdbl, r2dbl;
   rdbl = r;
   r2dbl = 2 * r;
   for (i = 1; i < r; i++)
      z[i - 1] = mu - 3 - 4 * log(rdbl / i);
   r5 = 5 * r;
   r6 = 6 * r;
   for (i = r; i <= r5; i++)
      z[i - 1] = mu - 3 * (1. - (i - rdbl) / r2dbl);
   for (i = r5 + 1; i < r6; i++)
      z[i - 1] = mu + 3. + 4. * log(rdbl / (r6 - i));
}

/**
 * @brief A short description of the function.
 *
 * Optional full description of the function,
 * where blank lines start new paragraphs.
 *
 * @param r TBA
 * @param mu TBA
 * @param a TBA
 * @param b TBA
 * @param z TBA
 * @param w TBA
 *
 * @return Grid points per Jennison & Turnbull, p. 349.
 * Returned value is # of grid points.
 *
 * @see Jennison C and Turnbull BW (2000),
 * _Group Sequential Methods with Applications to Clinical Trials_.
 * Boca Raton: Chapman and Hall.
 */
int gridpts(int r, double mu, double a, double b, double *z, double *w)
{
   int i, r5, r6, j = 0, done = 0;
   double rdbl, r2dbl, ztem;
   rdbl = r;
   r2dbl = 2 * r;
   r6 = 6 * r;
   r5 = 5 * r;
   w[0] = 0.;
   ztem = mu - 3 - 4 * log(rdbl);
   if (ztem <= a)
      z[0] = a;
   else if (ztem >= b)
   {
      z[0] = b;
      w[0] = 0.;
      done = 1;
   }
   else
      z[0] = ztem;
   for (i = 2; i < r6 && done == 0; i++)
   {
      if (i < r)
         ztem = mu - 3. - 4. * log(rdbl / i);
      else if (i <= r5)
         ztem = mu + 3. * (-1 + (i - r) / r2dbl);
      else
         ztem = mu + 3. + 4. * log(rdbl / (r6 - i));
      if (ztem > a)
      {
         j += 2;
         z[j] = ztem;
         if (ztem >= b)
         {
            z[j] = b;
            done = 1;
         }
         z[j - 1] = (z[j] + z[j - 2]) / 2.;
      }
   }
   if (j > 0)
   {
      w[0] = (z[2] - z[0]) / 6.;
      w[j] = (z[j] - z[j - 2]) / 6.;
      w[j - 1] = 2. * (z[j] - z[j - 2]) / 3.;
   }
   for (i = 1; i < j - 1; i += 2)
   {
      w[i] = 2. * (z[i + 1] - z[i - 1]) / 3.;
      w[i + 1] = (z[i + 3] - z[i - 1]) / 6.;
   }
   return (j);
}

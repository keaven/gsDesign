/**
 * @file probpos.c
 * @brief A short description of the file.
 * @author Keaven Anderson <keaven_anderson@merck.com>
 */

#include "R.h"
#include "Rmath.h"

/**
 * @brief A short description of the function.
 *
 * Optional full description of the function,
 * where blank lines start new paragraphs.
 *
 * @param theta TBA
 * @param m TBA
 * @param ak TBA
 * @param z TBA
 * @param h TBA
 * @param Ikm1 TBA
 * @param Ik TBA
 *
 * @return TBA
 */
double probneg(double theta, int m, double ak, double *z, double *h, double Ikm1, double Ik)
{
    int i;
    double x, prob, rtIk, rtIkm1, mu, rtdeltak;
    mu = theta * (Ik - Ikm1);
    rtdeltak = sqrt(Ik - Ikm1);
    rtIk = sqrt(Ik);
    rtIkm1 = sqrt(Ikm1);
    prob = 0.;
    for (i = 0; i <= m; i++)
    {
        x = (z[i] * rtIkm1 + mu - ak * rtIk) / rtdeltak;
        prob += pnorm(x, 0., 1., 0, 0) * h[i];
    }
    return (prob);
}

/**
 * @brief A short description of the function.
 *
 * Optional full description of the function,
 * where blank lines start new paragraphs.
 *
 * @param theta TBA
 * @param m TBA
 * @param bk TBA
 * @param z TBA
 * @param h TBA
 * @param Ikm1 TBA
 * @param Ik TBA
 *
 * @return TBA
 */
double probpos(double theta, int m, double bk, double *z, double *h, double Ikm1, double Ik)
{
    int i;
    double x, prob, rtIk, rtIkm1, mu, rtdeltak;
    mu = theta * (Ik - Ikm1);
    rtdeltak = sqrt(Ik - Ikm1);
    rtIk = sqrt(Ik);
    rtIkm1 = sqrt(Ikm1);
    prob = 0.;
    for (i = 0; i <= m; i++)
    {
        x = (z[i] * rtIkm1 + mu - bk * rtIk) / rtdeltak;
        prob += pnorm(x, 0., 1., 1, 0) * h[i];
    }
    return (prob);
}

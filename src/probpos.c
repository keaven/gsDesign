#include "R.h"
#include "Rmath.h"

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

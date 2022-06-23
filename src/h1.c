#include <stdio.h>
#include <math.h>

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

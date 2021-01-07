# Test: checking for test.type=1, n.fix=1 

    One-sided group sequential design with
    90 % power and 2.5 % Type I Error.
               Sample
                Size 
      Analysis Ratio*  Z   Nominal p  Spend
             1  0.205 3.25    0.0006 0.0006
             2  0.409 2.99    0.0014 0.0013
             3  0.614 2.69    0.0036 0.0028
             4  0.819 2.37    0.0088 0.0063
             5  1.023 2.03    0.0214 0.0140
         Total                       0.0250 
    
    ++ alpha spending:
     Hwang-Shih-DeCani spending function with gamma = -4.
    * Sample size ratio compared to fixed design with no interim
    
    Boundary crossing probabilities and expected sample size
    assume any cross stops the trial
    
    Upper boundary (power or Type I Error)
              Analysis
       Theta      1      2      3      4      5 Total   E{N}
      0.0000 0.0006 0.0013 0.0028 0.0063 0.0140 0.025 1.0197
      3.2415 0.0370 0.1512 0.2647 0.2699 0.1771 0.900 0.7366

# Test: checking for nFixSurv >1 

    Group sequential design sample size for time-to-event outcome
    with sample size 22. The analysis plan below shows events
    at each analysis.
    Symmetric two-sided group sequential design with
    90 % power and 2.5 % Type I Error.
    Spending computations assume trial stops
    if a bound is crossed.
    
               Sample
                Size 
      Analysis Ratio*  Z   Nominal p  Spend
             1  0.205 3.25    0.0006 0.0006
             2  0.409 2.99    0.0014 0.0013
             3  0.614 2.69    0.0036 0.0028
             4  0.819 2.37    0.0088 0.0063
             5  1.023 2.03    0.0214 0.0140
         Total                       0.0250 
    
    ++ alpha spending:
     Hwang-Shih-DeCani spending function with gamma = -4.
    * Sample size ratio compared to fixed design with no interim
    
    Boundary crossing probabilities and expected sample size
    assume any cross stops the trial
    
    Upper boundary (power or Type I Error)
              Analysis
       Theta      1      2      3      4      5 Total   E{N}
      0.0000 0.0006 0.0013 0.0028 0.0063 0.0140 0.025 1.0160
      3.2415 0.0370 0.1512 0.2647 0.2699 0.1771 0.900 0.7366
    
    Lower boundary (futility or Type II Error)
              Analysis
       Theta     1      2      3      4     5 Total
      0.0000 6e-04 0.0013 0.0028 0.0063 0.014 0.025
      3.2415 0e+00 0.0000 0.0000 0.0000 0.000 0.000

# Test: checking for test.type=2,n.fix=1 

    Symmetric two-sided group sequential design with
    90 % power and 2.5 % Type I Error.
    Spending computations assume trial stops
    if a bound is crossed.
    
               Sample
                Size 
      Analysis Ratio*  Z   Nominal p  Spend
             1  0.205 3.25    0.0006 0.0006
             2  0.409 2.99    0.0014 0.0013
             3  0.614 2.69    0.0036 0.0028
             4  0.819 2.37    0.0088 0.0063
             5  1.023 2.03    0.0214 0.0140
         Total                       0.0250 
    
    ++ alpha spending:
     Hwang-Shih-DeCani spending function with gamma = -4.
    * Sample size ratio compared to fixed design with no interim
    
    Boundary crossing probabilities and expected sample size
    assume any cross stops the trial
    
    Upper boundary (power or Type I Error)
              Analysis
       Theta      1      2      3      4      5 Total   E{N}
      0.0000 0.0006 0.0013 0.0028 0.0063 0.0140 0.025 1.0160
      3.2415 0.0370 0.1512 0.2647 0.2699 0.1771 0.900 0.7366
    
    Lower boundary (futility or Type II Error)
              Analysis
       Theta     1      2      3      4     5 Total
      0.0000 6e-04 0.0013 0.0028 0.0063 0.014 0.025
      3.2415 0e+00 0.0000 0.0000 0.0000 0.000 0.000

# Test: checking for test.type=3,n.fix=1 

    Asymmetric two-sided group sequential design with
    90 % power and 2.5 % Type I Error.
    Spending computations assume trial stops
    if a bound is crossed.
    
               Sample
                Size    ----Lower bounds----  ----Upper bounds-----
      Analysis Ratio*   Z   Nominal p Spend+  Z   Nominal p Spend++
             1  0.214 -0.92    0.1777 0.0077 3.25    0.0006  0.0006
             2  0.428 -0.07    0.4727 0.0115 2.99    0.0014  0.0013
             3  0.641  0.66    0.7440 0.0171 2.69    0.0036  0.0028
             4  0.855  1.32    0.9058 0.0256 2.37    0.0089  0.0063
             5  1.069  1.97    0.9755 0.0381 1.97    0.0245  0.0140
         Total                        0.1000                 0.0250 
    + lower bound beta spending (under H1):
     Hwang-Shih-DeCani spending function with gamma = -2.
    ++ alpha spending:
     Hwang-Shih-DeCani spending function with gamma = -4.
    * Sample size ratio compared to fixed design with no interim
    
    Boundary crossing probabilities and expected sample size
    assume any cross stops the trial
    
    Upper boundary (power or Type I Error)
              Analysis
       Theta      1      2      3      4      5 Total   E{N}
      0.0000 0.0006 0.0013 0.0028 0.0063 0.0140 0.025 0.5636
      3.2415 0.0397 0.1610 0.2743 0.2677 0.1573 0.900 0.7306
    
    Lower boundary (futility or Type II Error)
              Analysis
       Theta      1      2      3      4      5 Total
      0.0000 0.1777 0.3135 0.2708 0.1527 0.0602 0.975
      3.2415 0.0077 0.0115 0.0171 0.0256 0.0381 0.100

# Test: checking for test.type=4,n.fix=1 

    Asymmetric two-sided group sequential design with
    90 % power and 2.5 % Type I Error.
    Upper bound spending computations assume
    trial continues if lower bound is crossed.
    
                     ----Lower bounds----  ----Upper bounds-----
      Analysis  N    Z   Nominal p Spend+  Z   Nominal p Spend++
             1 177 -0.90    0.1836 0.0077 3.25    0.0006  0.0006
             2 353 -0.04    0.4853 0.0115 2.99    0.0014  0.0013
             3 529  0.69    0.7563 0.0171 2.69    0.0036  0.0028
             4 705  1.36    0.9131 0.0256 2.37    0.0088  0.0063
             5 882  2.03    0.9786 0.0381 2.03    0.0214  0.0140
         Total                     0.1000                 0.0250 
    + lower bound beta spending (under H1):
     Hwang-Shih-DeCani spending function with gamma = -2.
    ++ alpha spending:
     Hwang-Shih-DeCani spending function with gamma = -4.
    
    Boundary crossing probabilities and expected sample size
    assume any cross stops the trial
    
    Upper boundary (power or Type I Error)
              Analysis
       Theta      1      2      3      4      5  Total  E{N}
      0.0000 0.0006 0.0013 0.0028 0.0062 0.0117 0.0226 458.0
      0.1146 0.0417 0.1679 0.2806 0.2654 0.1444 0.9000 595.2
    
    Lower boundary (futility or Type II Error)
              Analysis
       Theta      1      2      3      4      5  Total
      0.0000 0.1836 0.3201 0.2700 0.1477 0.0559 0.9774
      0.1146 0.0077 0.0115 0.0171 0.0256 0.0381 0.1000

# Test: checking for test.type=5,n.fix=1 

    Asymmetric two-sided group sequential design with
    90 % power and 2.5 % Type I Error.
    Spending computations assume trial stops
    if a bound is crossed.
    
               Sample
                Size    ----Lower bounds----  ----Upper bounds-----
      Analysis Ratio*   Z   Nominal p Spend+  Z   Nominal p Spend++
             1  0.205 -1.44    0.0751 0.0751 3.25    0.0006  0.0006
             2  0.410 -0.98    0.1627 0.1120 2.99    0.0014  0.0013
             3  0.615 -0.47    0.3207 0.1670 2.69    0.0036  0.0028
             4  0.821  0.21    0.5833 0.2492 2.37    0.0088  0.0063
             5  1.026  2.02    0.9785 0.3717 2.02    0.0215  0.0140
         Total                        0.9750                 0.0250 
    + lower bound spending (under H0):
     Hwang-Shih-DeCani spending function with gamma = -2.
    ++ alpha spending:
     Hwang-Shih-DeCani spending function with gamma = -4.
    * Sample size ratio compared to fixed design with no interim
    
    Boundary crossing probabilities and expected sample size
    assume any cross stops the trial
    
    Upper boundary (power or Type I Error)
              Analysis
       Theta      1      2      3      4      5 Total   E{N}
      0.0000 0.0006 0.0013 0.0028 0.0063 0.0140 0.025 0.7719
      3.2415 0.0372 0.1517 0.2652 0.2698 0.1761 0.900 0.7349
    
    Lower boundary (futility or Type II Error)
              Analysis
       Theta      1      2      3      4      5 Total
      0.0000 0.0751 0.1120 0.1670 0.2492 0.3717 0.975
      3.2415 0.0018 0.0009 0.0009 0.0023 0.0942 0.100

# Test: checking for test.type=6,n.fix=1

    Asymmetric two-sided group sequential design with
    90 % power and 2.5 % Type I Error.
    Upper bound spending computations assume
    trial continues if lower bound is crossed.
    
               Sample
                Size    ----Lower bounds----  ----Upper bounds-----
      Analysis Ratio*   Z   Nominal p Spend+  Z   Nominal p Spend++
             1  0.205 -1.44    0.0751 0.0751 3.25    0.0006  0.0006
             2  0.411 -0.98    0.1627 0.1120 2.99    0.0014  0.0013
             3  0.616 -0.47    0.3207 0.1671 2.69    0.0036  0.0028
             4  0.821  0.21    0.5834 0.2492 2.37    0.0088  0.0063
             5  1.027  2.03    0.9786 0.3718 2.03    0.0214  0.0140
         Total                        0.9751                 0.0250 
    + lower bound spending (under H0):
     Hwang-Shih-DeCani spending function with gamma = -2.
    ++ alpha spending:
     Hwang-Shih-DeCani spending function with gamma = -4.
    * Sample size ratio compared to fixed design with no interim
    
    Boundary crossing probabilities and expected sample size
    assume any cross stops the trial
    
    Upper boundary (power or Type I Error)
              Analysis
       Theta      1      2      3      4      5  Total   E{N}
      0.0000 0.0006 0.0013 0.0028 0.0063 0.0140 0.0249 0.7726
      3.2415 0.0372 0.1519 0.2654 0.2697 0.1757 0.9000 0.7353
    
    Lower boundary (futility or Type II Error)
              Analysis
       Theta      1      2      3      4      5  Total
      0.0000 0.0751 0.1120 0.1671 0.2492 0.3718 0.9751
      3.2415 0.0018 0.0009 0.0009 0.0023 0.0942 0.1000

# Test: checking for n.fix > 1

    One-sided group sequential design with
    90 % power and 2.5 % Type I Error.
                 
      Analysis N   Z   Nominal p  Spend
             1  3 3.25    0.0006 0.0006
             2  5 2.99    0.0014 0.0013
             3  8 2.69    0.0036 0.0028
             4 10 2.37    0.0088 0.0063
             5 13 2.03    0.0214 0.0140
         Total                   0.0250 
    
    ++ alpha spending:
     Hwang-Shih-DeCani spending function with gamma = -4.
    
    Boundary crossing probabilities and expected sample size
    assume any cross stops the trial
    
    Upper boundary (power or Type I Error)
              Analysis
       Theta      1      2      3      4      5 Total E{N}
      0.0000 0.0006 0.0013 0.0028 0.0063 0.0140 0.025 12.2
      0.9357 0.0370 0.1512 0.2647 0.2699 0.1771 0.900  8.8

# Test: checking with alpha, beta, n.I set

    Symmetric two-sided group sequential design with
    98.5 % power and 5 % Type I Error.
    Spending computations assume trial stops
    if a bound is crossed.
    
               Sample
                Size 
      Analysis Ratio*  Z   Nominal p  Spend
             1    300 2.77    0.0028 0.0028
             2    600 2.23    0.0127 0.0114
             3    860 1.68    0.0462 0.0357
         Total                       0.0500 
    
    ++ alpha spending:
     Hwang-Shih-DeCani spending function with gamma = -4.
    * Sample size ratio compared to fixed design with no interim
    
    Boundary crossing probabilities and expected sample size
    assume any cross stops the trial
    
    Upper boundary (power or Type I Error)
              Analysis
       Theta      1      2      3 Total     E{N}
      0.0000 0.0028 0.0114 0.0357  0.05 850.8823
      3.8149 1.0000 0.0000 0.0000  1.00 300.0000
    
    Lower boundary (futility or Type II Error)
              Analysis
       Theta      1      2      3 Total
      0.0000 0.0028 0.0114 0.0357  0.05
      3.8149 0.0000 0.0000 0.0000  0.00


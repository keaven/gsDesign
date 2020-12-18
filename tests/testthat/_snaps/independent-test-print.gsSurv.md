# Test: checking hazard ratio hr0 = 1

    Time to event group sequential design with HR= 0.5 
    Equal randomization:          ratio=1
    Asymmetric two-sided group sequential design with
    90 % power and 2.5 % Type I Error.
    Upper bound spending computations assume
    trial continues if lower bound is crossed.
    
                    ----Lower bounds----  ----Upper bounds-----
      Analysis N    Z   Nominal p Spend+  Z   Nominal p Spend++
             1 31 -0.24    0.4056 0.0148 3.01    0.0013  0.0013
             2 62  0.94    0.8267 0.0289 2.55    0.0054  0.0049
             3 93  2.00    0.9772 0.0563 2.00    0.0228  0.0188
         Total                    0.1000                 0.0250 
    + lower bound beta spending (under H1):
     Hwang-Shih-DeCani spending function with gamma = -2.
    ++ alpha spending:
     Hwang-Shih-DeCani spending function with gamma = -4.
    
    Boundary crossing probabilities and expected sample size
    assume any cross stops the trial
    
    Upper boundary (power or Type I Error)
              Analysis
       Theta      1      2      3  Total E{N}
      0.0000 0.0013 0.0049 0.0171 0.0233 54.2
      0.3481 0.1412 0.4403 0.3185 0.9000 68.6
    
    Lower boundary (futility or Type II Error)
              Analysis
       Theta      1      2      3  Total
      0.0000 0.4056 0.4290 0.1420 0.9767
      0.3481 0.0148 0.0289 0.0563 0.1000
                  T         n   Events HR futility HR efficacy
    IA 1   43.16196  43.16196 30.92271       1.090       0.339
    IA 2   74.71327  74.71327 61.84542       0.787       0.523
    Final 105.74376 105.24376 92.76813       0.660       0.660
    Accrual rates:
             Stratum 1
    0-105.24         1
    Control event rates (H1):
          Stratum 1
    0-Inf      0.12
    Censoring rates:
          Stratum 1
    0-Inf         0

# Test: checking hazard ratio hr0 != 1

    Time to event group sequential design with HR= 0.5 
    Non-inferiority design with null HR= 1.5 
    Equal randomization:          ratio=1
    Asymmetric two-sided group sequential design with
    90 % power and 2.5 % Type I Error.
    Upper bound spending computations assume
    trial continues if lower bound is crossed.
    
                    ----Lower bounds----  ----Upper bounds-----
      Analysis N    Z   Nominal p Spend+  Z   Nominal p Spend++
             1 13 -0.24    0.4056 0.0148 3.01    0.0013  0.0013
             2 25  0.94    0.8267 0.0289 2.55    0.0054  0.0049
             3 38  2.00    0.9772 0.0563 2.00    0.0228  0.0188
         Total                    0.1000                 0.0250 
    + lower bound beta spending (under H1):
     Hwang-Shih-DeCani spending function with gamma = -2.
    ++ alpha spending:
     Hwang-Shih-DeCani spending function with gamma = -4.
    
    Boundary crossing probabilities and expected sample size
    assume any cross stops the trial
    
    Upper boundary (power or Type I Error)
              Analysis
       Theta      1      2      3  Total E{N}
      0.0000 0.0013 0.0049 0.0171 0.0233 21.7
      0.5506 0.1412 0.4403 0.3185 0.9000 27.4
    
    Lower boundary (futility or Type II Error)
              Analysis
       Theta      1      2      3  Total
      0.0000 0.4056 0.4290 0.1420 0.9767
      0.5506 0.0148 0.0289 0.0563 0.1000
                 T        n   Events HR futility HR efficacy
    IA 1  22.69529 22.69529 12.35898       1.718       0.271
    IA 2  36.59355 36.59355 24.71799       1.027       0.539
    Final 49.56349 49.06349 37.07699       0.778       0.778
    Accrual rates:
            Stratum 1
    0-49.06         1
    Control event rates (H1):
          Stratum 1
    0-Inf      0.12
    Censoring rates:
          Stratum 1
    0-Inf         0

# Test: checking test.type > 1

    Time to event group sequential design with HR= 0.5 
    Equal randomization:          ratio=1
    Asymmetric two-sided group sequential design with
    90 % power and 2.5 % Type I Error.
    Spending computations assume trial stops
    if a bound is crossed.
    
                    ----Lower bounds----  ----Upper bounds-----
      Analysis  N   Z   Nominal p Spend+  Z   Nominal p Spend++
             1  27 0.16    0.5618 0.0500 3.16    0.0008  0.0008
             2  54 0.76    0.7769 0.0207 2.82    0.0024  0.0022
             3  80 1.34    0.9092 0.0159 2.42    0.0078  0.0059
             4 107 1.86    0.9685 0.0134 1.86    0.0315  0.0161
         Total                    0.1000                 0.0250 
    + lower bound beta spending (under H1):
     Kim-DeMets (power) spending function with rho = 0.5.
    ++ alpha spending:
     Hwang-Shih-DeCani spending function with gamma = -4.
    
    Boundary crossing probabilities and expected sample size
    assume any cross stops the trial
    
    Upper boundary (power or Type I Error)
              Analysis
       Theta      1      2      3      4  Total E{N}
      0.0000 0.0008 0.0022 0.0059 0.0160 0.0249 44.8
      0.3489 0.0877 0.3127 0.3489 0.1507 0.9000 68.0
    
    Lower boundary (futility or Type II Error)
              Analysis
       Theta      1      2      3      4  Total
      0.0000 0.5618 0.2498 0.1184 0.0451 0.9751
      0.3489 0.0500 0.0207 0.0159 0.0134 0.1000
                 T        n    Events HR futility HR efficacy
    IA 1  12.24228  75.4103  26.62788       0.942       0.294
    IA 2  18.97078 116.8567  53.25573       0.812       0.462
    IA 3  25.02728 147.8358  79.88362       0.742       0.582
    Final 36.00000 147.8358 106.51151       0.697       0.697
    Accrual rates:
         Stratum 1
    0-24      6.16
    Control event rates (H1):
          Stratum 1
    0-Inf      0.12
    Censoring rates:
          Stratum 1
    0-Inf      0.02

# Test: checking test.type = 1

    Time to event group sequential design with HR= 0.5 
    Equal randomization:          ratio=1
    One-sided group sequential design with
    90 % power and 2.5 % Type I Error.
                 
      Analysis N   Z   Nominal p  Spend
             1 23 3.16    0.0008 0.0008
             2 45 2.82    0.0024 0.0022
             3 67 2.44    0.0074 0.0059
             4 89 2.01    0.0220 0.0161
         Total                   0.0250 
    
    ++ alpha spending:
     Hwang-Shih-DeCani spending function with gamma = -4.
    
    Boundary crossing probabilities and expected sample size
    assume any cross stops the trial
    
    Upper boundary (power or Type I Error)
              Analysis
       Theta      1      2      3      4 Total E{N}
      0.0000 0.0008 0.0022 0.0059 0.0161 0.025 87.8
      0.3489 0.0644 0.2507 0.3480 0.2369 0.900 65.1
                 T         n   Events HR efficacy
    IA 1  12.24228  62.33412 22.01059       0.261
    IA 2  18.97078  96.59366 44.02116       0.428
    IA 3  25.02728 122.20099 66.03177       0.549
    Final 36.00000 122.20099 88.04237       0.651
    Accrual rates:
         Stratum 1
    0-24      5.09
    Control event rates (H1):
          Stratum 1
    0-Inf      0.12
    Censoring rates:
          Stratum 1
    0-Inf      0.02

# Test: checking ratio = 0.6

    Time to event group sequential design with HR= 0.5 
    Randomization (Exp/Control):  ratio= 0.6 
    Asymmetric two-sided group sequential design with
    90 % power and 2.5 % Type I Error.
    Spending computations assume trial stops
    if a bound is crossed.
    
                    ----Lower bounds----  ----Upper bounds-----
      Analysis  N   Z   Nominal p Spend+  Z   Nominal p Spend++
             1  30 0.16    0.5618 0.0500 3.16    0.0008  0.0008
             2  59 0.76    0.7769 0.0207 2.82    0.0024  0.0022
             3  88 1.34    0.9092 0.0159 2.42    0.0078  0.0059
             4 117 1.86    0.9685 0.0134 1.86    0.0315  0.0161
         Total                    0.1000                 0.0250 
    + lower bound beta spending (under H1):
     Kim-DeMets (power) spending function with rho = 0.5.
    ++ alpha spending:
     Hwang-Shih-DeCani spending function with gamma = -4.
    
    Boundary crossing probabilities and expected sample size
    assume any cross stops the trial
    
    Upper boundary (power or Type I Error)
              Analysis
       Theta      1      2      3      4  Total E{N}
      0.0000 0.0008 0.0022 0.0059 0.0160 0.0249 49.3
      0.3329 0.0877 0.3127 0.3489 0.1507 0.9000 74.7
    
    Lower boundary (futility or Type II Error)
              Analysis
       Theta      1      2      3      4  Total
      0.0000 0.5618 0.2498 0.1184 0.0451 0.9751
      0.3329 0.0500 0.0207 0.0159 0.0134 0.1000
                 T         n    Events HR futility HR efficacy
    IA 1  12.04139  78.84331  29.24741       0.942       0.300
    IA 2  18.73390 122.66381  58.49480       0.814       0.467
    IA 3  24.77333 157.14461  87.74211       0.745       0.586
    Final 36.00000 157.14461 116.98964       0.701       0.701
    Accrual rates:
         Stratum 1
    0-24      6.55
    Control event rates (H1):
          Stratum 1
    0-Inf      0.12
    Censoring rates:
          Stratum 1
    0-Inf      0.02


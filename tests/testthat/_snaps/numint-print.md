# printing designs with zero-spend analyses is stable

    Code
      print(x)
    Output
      One-sided group sequential design with
      90 % power and 2.5 % Type I Error.
                 Sample
                  Size
        Analysis Ratio*  Z   Nominal p  Spend
               1  0.251   NA        NA     NA
               2  0.502 3.33    0.0004 0.0004
               3  0.753 2.64    0.0042 0.0039
               4  1.004 1.97    0.0243 0.0207
           Total                       0.0250
      ++ alpha spending:
       Hwang-Shih-DeCani spending function compressed to 0.4, 1  with gamma = -4.
      * Sample size ratio compared to fixed design with no interim
      Boundary crossing probabilities and expected sample size
      assume any cross stops the trial
      Upper boundary (power or Type I Error)
                Analysis
         Theta 1      2      3      4 Total   E{N}
        0.0000 0 0.0004 0.0039 0.0207 0.025 1.0025
        3.2415 0 0.1518 0.4205 0.3277 0.900 0.8220

---

    Code
      print(gsBoundSummary(x))
    Output
                     Analysis               Value Efficacy
                    IA 1: 25%                   Z       NA
       N/Fixed design N: 0.25         p (1-sided)       NA
                                  ~delta at bound       NA
                              P(Cross) if delta=0       NA
                              P(Cross) if delta=1       NA
                    IA 2: 50%                   Z   3.3250
        N/Fixed design N: 0.5         p (1-sided)   0.0004
                                  ~delta at bound   1.4480
                              P(Cross) if delta=0   0.0004
                              P(Cross) if delta=1   0.1518
                    IA 3: 75%                   Z   2.6353
       N/Fixed design N: 0.75         p (1-sided)   0.0042
                                  ~delta at bound   0.9370
                              P(Cross) if delta=0   0.0043
                              P(Cross) if delta=1   0.5723
                        Final                   Z   1.9719
          N/Fixed design N: 1         p (1-sided)   0.0243
                                  ~delta at bound   0.6072
                              P(Cross) if delta=0   0.0250
                              P(Cross) if delta=1   0.9000

---

    Code
      print(y)
    Output
      Asymmetric two-sided group sequential design with
      90 % power and 2.5 % Type I Error.
      Upper bound spending computations assume
      trial continues if lower bound is crossed.
                 Sample
                  Size    ----Lower bounds----  ----Upper bounds-----
        Analysis Ratio*   Z   Nominal p Spend+  Z   Nominal p Spend++
               1  0.345 -0.27    0.3936 0.0148   NA        NA      NA
               2  0.690    NA        NA     NA 2.50    0.0062  0.0062
               3  1.036  1.99    0.9770 0.0852 1.99    0.0230  0.0188
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
         Theta 1      2      3  Total   E{N}
        0.0000 0 0.0062 0.0182 0.0244 0.7617
        3.2415 0 0.5773 0.3227 0.9000 0.8261
      Lower boundary (futility or Type II Error)
                Analysis
         Theta      1 2      3  Total
        0.0000 0.3936 0 0.5820 0.9756
        3.2415 0.0148 0 0.0852 0.1000

---

    Code
      print(gsBoundSummary(y))
    Output
                     Analysis               Value Efficacy Futility
                    IA 1: 33%                   Z       NA  -0.2700
       N/Fixed design N: 0.35         p (1-sided)       NA   0.6064
                                  ~delta at bound       NA  -0.1418
                              P(Cross) if delta=0       NA   0.3936
                              P(Cross) if delta=1       NA   0.0148
                    IA 2: 67%                   Z   2.4979       NA
       N/Fixed design N: 0.69         p (1-sided)   0.0062       NA
                                  ~delta at bound   0.9274       NA
                              P(Cross) if delta=0   0.0062       NA
                              P(Cross) if delta=1   0.5773       NA
                        Final                   Z   1.9947   1.9947
       N/Fixed design N: 1.04         p (1-sided)   0.0230   0.0230
                                  ~delta at bound   0.6047   0.6047
                              P(Cross) if delta=0   0.0244   0.9756
                              P(Cross) if delta=1   0.9000   0.1000

---

    Code
      print(gsProbability(d = y, theta = c(0, y$delta, 2 * y$delta)))
    Output
      Asymmetric two-sided group sequential design with
      90 % power and 2.5 % Type I Error.
      Upper bound spending computations assume
      trial continues if lower bound is crossed.
                 Sample
                  Size    ----Lower bounds----  ----Upper bounds-----
        Analysis Ratio*   Z   Nominal p Spend+  Z   Nominal p Spend++
               1  0.345 -0.27    0.3936 0.0148   NA        NA      NA
               2  0.690    NA        NA     NA 2.50    0.0062  0.0062
               3  1.036  1.99    0.9770 0.0852 1.99    0.0230  0.0188
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
         Theta 1      2      3  Total   E{N}
        0.0000 0 0.0062 0.0182 0.0244 0.7617
        3.2415 0 0.5773 0.3227 0.9000 0.8261
        6.4830 0 0.9981 0.0019 1.0000 0.6911
      Lower boundary (futility or Type II Error)
                Analysis
         Theta      1 2      3  Total
        0.0000 0.3936 0 0.5820 0.9756
        3.2415 0.0148 0 0.0852 0.1000
        6.4830 0.0000 0 0.0000 0.0000

# printing low-level boundary objects with zero spending is stable

    Code
      print(gsBound(I = c(1, 2, 3), trueneg = c(0.01, 0, 0.02), falsepos = c(0.001, 0,
        0.024)))
    Output
      $k
      [1] 3
      $theta
      [1] 0
      $I
      [1] 1 2 3
      $a
      [1] -2.326348      -Inf -1.997042
      $b
      [1] 3.090232      Inf 1.968809
      $rates
      $rates$falsepos
      [1] 0.001 0.000 0.024
      $rates$trueneg
      [1] 0.01 0.00 0.02
      $tol
      [1] 1e-06
      $r
      [1] 18
      $error
      [1] 0

---

    Code
      print(gsBound1(theta = 0, I = c(1, 2, 3), a = rep(-20, 3), probhi = c(0.001, 0,
        0.024)))
    Output
      $k
      [1] 3
      $theta
      [1] 0
      $I
      [1] 1 2 3
      $a
      [1] -20 -20 -20
      $b
      [1] 3.090232      Inf 1.968811
      $problo
      [1] 2.753624e-89 1.675994e-89 6.643696e-92
      $probhi
      [1] 0.001 0.000 0.024
      $tol
      [1] 1e-06
      $r
      [1] 18
      $error
      [1] 0

# Test: checking hazard ratio hr0 = 1

    Group sequential design (method=LachinFoulkes; k=3 analyses; Two-sided asymmetric with non-binding futility)
    N=187.2 subjects | D=93.5 events | T=18.5 study duration | accrual=18.0 Accrual duration | minfup=0.5 minimum follow-up | ratio=1 randomization ratio (experimental/control)
    
    Spending functions:
      Efficacy bounds derived using a Hwang-Shih-DeCani spending function with gamma = -4.
      Futility bounds derived using a Hwang-Shih-DeCani spending function with gamma = -2.
    
    Analysis summary:
    Method: LachinFoulkes 
       Analysis              Value Efficacy Futility
      IA 1: 33%                  Z   3.0107  -0.2388
         N: 100        p (1-sided)   0.0013   0.5944
     Events: 32       ~HR at bound   0.3401   1.0893
      Month: 10   P(Cross) if HR=1   0.0013   0.4056
                P(Cross) if HR=0.5   0.1412   0.0148
      IA 2: 67%                  Z   2.5465   0.9410
         N: 150        p (1-sided)   0.0054   0.1733
     Events: 63       ~HR at bound   0.5246   0.7879
      Month: 14   P(Cross) if HR=1   0.0062   0.8347
                P(Cross) if HR=0.5   0.5815   0.0437
          Final                  Z   1.9992   1.9992
         N: 188        p (1-sided)   0.0228   0.0228
     Events: 94       ~HR at bound   0.6613   0.6613
      Month: 18   P(Cross) if HR=1   0.0233   0.9767
                P(Cross) if HR=0.5   0.9000   0.1000
    
    Key inputs (names preserved):
                                   desc    item  value input
                        Accrual rate(s)   gamma 10.401     1
               Accrual rate duration(s)       R     18    18
                 Control hazard rate(s) lambdaC  0.116 0.116
                Control dropout rate(s)     eta      0     0
           Experimental dropout rate(s)    etaE      0  etaE
     Event and dropout rate duration(s)       S   NULL     S

# Test: checking hazard ratio hr0 != 1

    Group sequential design (method=LachinFoulkes; k=3 analyses; Two-sided asymmetric with non-binding futility)
    N=75.7 subjects | D=37.8 events | T=18.5 study duration | accrual=18.0 Accrual duration | minfup=0.5 minimum follow-up | ratio=1 randomization ratio (experimental/control)
    
    Spending functions:
      Efficacy bounds derived using a Hwang-Shih-DeCani spending function with gamma = -4.
      Futility bounds derived using a Hwang-Shih-DeCani spending function with gamma = -2.
    
    Analysis summary:
    Method: LachinFoulkes 
       Analysis              Value Efficacy Futility
      IA 1: 33%                  Z   3.0107  -0.2388
          N: 42        p (1-sided)   0.0013   0.5944
     Events: 13       ~HR at bound   0.2750   1.7160
      Month: 10 P(Cross) if HR=1.5   0.0013   0.4056
                P(Cross) if HR=0.5   0.1412   0.0148
      IA 2: 67%                  Z   2.5465   0.9410
          N: 62        p (1-sided)   0.0054   0.1733
     Events: 26       ~HR at bound   0.5438   1.0310
      Month: 14 P(Cross) if HR=1.5   0.0062   0.8347
                P(Cross) if HR=0.5   0.5815   0.0437
          Final                  Z   1.9992   1.9992
          N: 76        p (1-sided)   0.0228   0.0228
     Events: 38       ~HR at bound   0.7827   0.7827
      Month: 18 P(Cross) if HR=1.5   0.0233   0.9767
                P(Cross) if HR=0.5   0.9000   0.1000
    
    Key inputs (names preserved):
                                   desc    item value input
                        Accrual rate(s)   gamma 4.204     1
               Accrual rate duration(s)       R    18    18
                 Control hazard rate(s) lambdaC 0.116 0.116
                Control dropout rate(s)     eta     0     0
           Experimental dropout rate(s)    etaE     0  etaE
     Event and dropout rate duration(s)       S  NULL     S

# Test: checking test.type > 1

    Group sequential design (method=LachinFoulkes; k=4 analyses; Two-sided asymmetric with binding futility)
    N=147.8 subjects | D=106.5 events | T=36.0 study duration | accrual=24.0 Accrual duration | minfup=12.0 minimum follow-up | ratio=1 randomization ratio (experimental/control)
    
    Spending functions:
      Efficacy bounds derived using a Hwang-Shih-DeCani spending function with gamma = -4.
      Futility bounds derived using a Kim-DeMets (power) spending function with rho = 0.
    
    Analysis summary:
    Method: LachinFoulkes 
        Analysis              Value Efficacy Futility
       IA 1: 25%                  Z   3.1554   0.1555
           N: 76        p (1-sided)   0.0008   0.4382
      Events: 27       ~HR at bound   0.2944   0.9415
       Month: 12   P(Cross) if HR=1   0.0008   0.5618
                 P(Cross) if HR=0.5   0.0877   0.0500
       IA 2: 50%                  Z   2.8175   0.7616
          N: 118        p (1-sided)   0.0024   0.2231
      Events: 54       ~HR at bound   0.4620   0.8116
       Month: 19   P(Cross) if HR=1   0.0030   0.8116
                 P(Cross) if HR=0.5   0.4004   0.0707
       IA 3: 75%                  Z   2.4200   1.3357
          N: 148        p (1-sided)   0.0078   0.0908
      Events: 80       ~HR at bound   0.5819   0.7416
       Month: 25   P(Cross) if HR=1   0.0089   0.9300
                 P(Cross) if HR=0.5   0.7493   0.0866
           Final                  Z   1.8598   1.8598
          N: 148        p (1-sided)   0.0315   0.0315
     Events: 107       ~HR at bound   0.6974   0.6974
       Month: 36   P(Cross) if HR=1   0.0249   0.9751
                 P(Cross) if HR=0.5   0.9000   0.1000
    
    Key inputs (names preserved):
                                   desc    item value input
                        Accrual rate(s)   gamma  6.16     1
               Accrual rate duration(s)       R    24    12
                 Control hazard rate(s) lambdaC 0.116 0.116
                Control dropout rate(s)     eta 0.017 0.017
           Experimental dropout rate(s)    etaE 0.017  etaE
     Event and dropout rate duration(s)       S  NULL     S

# Test: checking test.type = 1

    Group sequential design (method=LachinFoulkes; k=4 analyses; One-sided (efficacy only))
    N=122.2 subjects | D=88.0 events | T=36.0 study duration | accrual=24.0 Accrual duration | minfup=12.0 minimum follow-up | ratio=1 randomization ratio (experimental/control)
    
    Spending functions:
      Efficacy bounds derived using a Hwang-Shih-DeCani spending function with gamma = -4.
    
    Analysis summary:
    Method: LachinFoulkes 
       Analysis              Value Efficacy
      IA 1: 25%                  Z   3.1554
          N: 64        p (1-sided)   0.0008
     Events: 23       ~HR at bound   0.2605
      Month: 12   P(Cross) if HR=1   0.0008
                P(Cross) if HR=0.5   0.0644
      IA 2: 50%                  Z   2.8183
          N: 98        p (1-sided)   0.0024
     Events: 45       ~HR at bound   0.4276
      Month: 19   P(Cross) if HR=1   0.0030
                P(Cross) if HR=0.5   0.3151
      IA 3: 75%                  Z   2.4390
         N: 124        p (1-sided)   0.0074
     Events: 67       ~HR at bound   0.5486
      Month: 25   P(Cross) if HR=1   0.0089
                P(Cross) if HR=0.5   0.6631
          Final                  Z   2.0136
         N: 124        p (1-sided)   0.0220
     Events: 89       ~HR at bound   0.6510
      Month: 36   P(Cross) if HR=1   0.0250
                P(Cross) if HR=0.5   0.9000
    
    Key inputs (names preserved):
                                   desc    item value input
                        Accrual rate(s)   gamma 5.092     1
               Accrual rate duration(s)       R    24    12
                 Control hazard rate(s) lambdaC 0.116 0.116
                Control dropout rate(s)     eta 0.017 0.017
           Experimental dropout rate(s)    etaE 0.017  etaE
     Event and dropout rate duration(s)       S  NULL     S

# Test: checking ratio = 0.6

    Group sequential design (method=LachinFoulkes; k=4 analyses; Two-sided asymmetric with binding futility)
    N=157.1 subjects | D=117.0 events | T=36.0 study duration | accrual=24.0 Accrual duration | minfup=12.0 minimum follow-up | ratio=0.6 randomization ratio (experimental/control)
    
    Spending functions:
      Efficacy bounds derived using a Hwang-Shih-DeCani spending function with gamma = -4.
      Futility bounds derived using a Kim-DeMets (power) spending function with rho = 0.
    
    Analysis summary:
    Method: LachinFoulkes 
        Analysis              Value Efficacy Futility
       IA 1: 25%                  Z   3.1554   0.1555
           N: 80        p (1-sided)   0.0008   0.4382
      Events: 30       ~HR at bound   0.2996   0.9424
       Month: 12   P(Cross) if HR=1   0.0008   0.5618
                 P(Cross) if HR=0.5   0.0877   0.0500
       IA 2: 50%                  Z   2.8175   0.7616
          N: 123        p (1-sided)   0.0024   0.2231
      Events: 59       ~HR at bound   0.4672   0.8141
       Month: 19   P(Cross) if HR=1   0.0030   0.8116
                 P(Cross) if HR=0.5   0.4004   0.0707
       IA 3: 75%                  Z   2.4200   1.3357
          N: 158        p (1-sided)   0.0078   0.0908
      Events: 88       ~HR at bound   0.5865   0.7449
       Month: 25   P(Cross) if HR=1   0.0089   0.9300
                 P(Cross) if HR=0.5   0.7493   0.0866
           Final                  Z   1.8598   1.8598
          N: 158        p (1-sided)   0.0315   0.0315
     Events: 117       ~HR at bound   0.7011   0.7011
       Month: 36   P(Cross) if HR=1   0.0249   0.9751
                 P(Cross) if HR=0.5   0.9000   0.1000
    
    Key inputs (names preserved):
                                   desc    item value input
                        Accrual rate(s)   gamma 6.548     1
               Accrual rate duration(s)       R    24    12
                 Control hazard rate(s) lambdaC 0.116 0.116
                Control dropout rate(s)     eta 0.017 0.017
           Experimental dropout rate(s)    etaE 0.017  etaE
     Event and dropout rate duration(s)       S  NULL     S


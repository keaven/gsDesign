# Test: checking for Censoring Rates

    nSurv fixed-design summary (method=LachinFoulkes; target=Accrual duration)
    HR=0.600 vs HR0=1.000 | alpha=0.025 (sided=1) | power=90.0%
    N=172.0 subjects | D=160.7 events | T=172.2 study duration | accrual=172.0 Accrual duration | minfup=0.2 minimum follow-up | ratio=1 randomization ratio (experimental/control)
    
    Key inputs (names preserved):
                                   desc    item   value input
                        Accrual rate(s)   gamma       1     1
               Accrual rate duration(s)       R 171.997    12
                 Control hazard rate(s) lambdaC   0.116 0.116
                Control dropout rate(s)     eta       0     0
           Experimental dropout rate(s)    etaE       0     0
     Event and dropout rate duration(s)       S    NULL     S

# Test: checking for Control Censoring Rates

    nSurv fixed-design summary (method=LachinFoulkes; target=Accrual duration)
    HR=0.600 vs HR0=1.000 | alpha=0.025 (sided=1) | power=90.0%
    N=362.6 subjects | D=223.3 events | T=362.8 study duration | accrual=362.6 Accrual duration | minfup=0.2 minimum follow-up | ratio=1 randomization ratio (experimental/control)
    
    Key inputs (names preserved):
                                   desc    item   value input
                        Accrual rate(s)   gamma       1     1
               Accrual rate duration(s)       R 362.589    12
                 Control hazard rate(s) lambdaC   0.116 0.116
                Control dropout rate(s)     eta       0     0
           Experimental dropout rate(s)    etaE     0.2   0.2
     Event and dropout rate duration(s)       S    NULL     S

# Test: checking for ratio != 1

    nSurv fixed-design summary (method=LachinFoulkes; target=Accrual duration)
    HR=0.600 vs HR0=1.000 | alpha=0.025 (sided=1) | power=90.0%
    N=385.6 subjects | D=253.2 events | T=385.8 study duration | accrual=385.6 Accrual duration | minfup=0.2 minimum follow-up | ratio=0.8 randomization ratio (experimental/control)
    
    Key inputs (names preserved):
                                   desc    item   value input
                        Accrual rate(s)   gamma       1     1
               Accrual rate duration(s)       R 385.563    12
                 Control hazard rate(s) lambdaC   0.116 0.116
                Control dropout rate(s)     eta       0     0
           Experimental dropout rate(s)    etaE     0.2   0.2
     Event and dropout rate duration(s)       S    NULL     S


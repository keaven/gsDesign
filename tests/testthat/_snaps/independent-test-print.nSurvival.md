# Test: checking entry set to "unif"

    Fixed design, two-arm trial with time-to-event
    outcome (Lachin and Foulkes, 1986).
    Study duration (fixed):          Ts=2
    Accrual duration (fixed):        Tr=0.5
    Uniform accrual:              entry="unif"
    Control median:      log(2)/lambda1=3.5
    Experimental median: log(2)/lambda2=6.9
    Censoring median:        log(2)/eta=6.9
    Control failure rate:       lambda1=0.2
    Experimental failure rate:  lambda2=0.1
    Censoring rate:                 eta=0.1
    Power:                 100*(1-beta)=90%
    Type I error (1-sided):   100*alpha=2.5%
    Equal randomization:          ratio=1
    Sample size based on hazard ratio=0.5 (type="rr")
    Sample size (computed):           n=430
    Events required (computed): nEvents=91

# Test: checking entry set to "expo"

    Fixed design, two-arm trial with time-to-event
    outcome (Lachin and Foulkes, 1986).
    Study duration (fixed):          Ts=2
    Accrual duration (fixed):        Tr=0.5
    Exponential accrual:          entry="expo"
    Accrual shape parameter:      gamma=1
    Control median:      log(2)/lambda1=3.5
    Experimental median: log(2)/lambda2=6.9
    Censoring median:        log(2)/eta=6.9
    Control failure rate:       lambda1=0.2
    Experimental failure rate:  lambda2=0.1
    Censoring rate:                 eta=0.1
    Power:                 100*(1-beta)=90%
    Type I error (1-sided):   100*alpha=2.5%
    Equal randomization:          ratio=1
    Sample size based on hazard ratio=0.5 (type="rr")
    Sample size (computed):           n=426
    Events required (computed): nEvents=91

# Test: checking entry - "expo", eta = 0 and ratio set

    Fixed design, two-arm trial with time-to-event
    outcome (Lachin and Foulkes, 1986).
    Study duration (fixed):          Ts=2
    Accrual duration (fixed):        Tr=0.5
    Exponential accrual:          entry="expo"
    Accrual shape parameter:      gamma=1
    Control median:      log(2)/lambda1=3.5
    Experimental median: log(2)/lambda2=6.9
    Censoring only at study end (eta=0)
    Control failure rate:       lambda1=0.2
    Experimental failure rate:  lambda2=0.1
    Censoring rate:                 eta=0
    Power:                 100*(1-beta)=90%
    Type I error (1-sided):   100*alpha=2.5%
    Randomization (Exp/Control):  ratio=1.25
    Sample size based on hazard ratio=0.5 (type="rr")
    Sample size (computed):           n=400
    Events required (computed): nEvents=89

# Test: checking entry set to "expo",eta = 0,ratio != 1

    Fixed design, two-arm trial with time-to-event
    outcome (Lachin and Foulkes, 1986).
    Study duration (fixed):          Ts=2
    Accrual duration (fixed):        Tr=0.5
    Exponential accrual:          entry="expo"
    Accrual shape parameter:      gamma=1
    Control median:      log(2)/lambda1=3.5
    Experimental median: log(2)/lambda2=6.9
    Censoring only at study end (eta=0)
    Control failure rate:       lambda1=0.2
    Experimental failure rate:  lambda2=0.1
    Censoring rate:                 eta=0
    Power:                 100*(1-beta)=90%
    Type I error (1-sided):   100*alpha=2.5%
    Randomization (Exp/Control):  ratio=0.8
    Sample size based on hazard ratio=0.5 (type="rr")
    Sample size (computed):           n=396
    Events required (computed): nEvents=94

# Test: checking type of sample size calculation: risk ratio (type = rr) with approximate computation

    Fixed design, two-arm trial with time-to-event
    outcome (Lachin and Foulkes, 1986).
    Study duration (fixed):          Ts=2
    Accrual duration (fixed):        Tr=0.5
    Uniform accrual:              entry="unif"
    Control median:      log(2)/lambda1=3.5
    Experimental median: log(2)/lambda2=6.9
    Censoring median:        log(2)/eta=0.1
    Control failure rate:       lambda1=0.2
    Experimental failure rate:  lambda2=0.1
    Censoring rate:                 eta=6.9
    Power:                 100*(1-beta)=90%
    Type I error (1-sided):   100*alpha=2.5%
    Equal randomization:          ratio=1
    Sample size based on hazard ratio=0.5 (type="rr")
    Sample size (computed):           n=4308
    Events required (computed): nEvents=92

# Test: checking type of sample size calculation: risk difference (type = rd) with approximate computation

    Fixed design, two-arm trial with time-to-event
    outcome (Lachin and Foulkes, 1986).
    Study duration (fixed):          Ts=2
    Accrual duration (fixed):        Tr=0.5
    Uniform accrual:              entry="unif"
    Control median:      log(2)/lambda1=3.5
    Experimental median: log(2)/lambda2=6.9
    Censoring only at study end (eta=0)
    Control failure rate:       lambda1=0.2
    Experimental failure rate:  lambda2=0.1
    Censoring rate:                 eta=0
    Power:                 100*(1-beta)=90%
    Type I error (1-sided):   100*alpha=2.5%
    Equal randomization:          ratio=1
    Sample size based on risk difference=0.1 (type="rd")
    Sample size based on H1 variance only:  approx=TRUE
    Sample size (computed):           n=416
    Events required (computed): nEvents=95

# Test: checking type of sample size calculation: risk difference (type = rd) with approx set to FALSE

    Fixed design, two-arm trial with time-to-event
    outcome (Lachin and Foulkes, 1986).
    Study duration (fixed):          Ts=2
    Accrual duration (fixed):        Tr=0.5
    Uniform accrual:              entry="unif"
    Control median:      log(2)/lambda1=3.5
    Experimental median: log(2)/lambda2=6.9
    Censoring only at study end (eta=0)
    Control failure rate:       lambda1=0.2
    Experimental failure rate:  lambda2=0.1
    Censoring rate:                 eta=0
    Power:                 100*(1-beta)=90%
    Type I error (1-sided):   100*alpha=2.5%
    Equal randomization:          ratio=1
    Sample size based on risk difference=0.1 (type="rd")
    Sample size based on H0 and H1 variance: approx=FALSE
    Sample size (computed):           n=414
    Events required (computed): nEvents=94


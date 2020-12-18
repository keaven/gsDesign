proc seqdesign;
   ErrorSpend: design nstages=1 method=errfuncobf
               ;
   samplesize model(ceiladjdesign=include)=twosamplesurvival
                   ( nullhazard=0.03466 hazard=0.01733
                     accrual=uniform foltime=12 totalTIME= 36
                     );
run;
proc seqdesign;
   ErrorSpend: design nstages=1 method=errfuncobf
               ;
   samplesize model(ceiladjdesign=include)=twosamplesurvival
                   ( nullhazard=0.03466 hazard=0.01733
                     accrual=uniform accrate=6 folTIME= 12
                     );
run;

proc seqdesign;
   ErrorSpend: design nstages=4 method=errfuncobf
               ;
   samplesize model(ceiladjdesign=include)=twosamplesurvival
                   ( nullhazard=0.03466 hazard=0.01733
                     accrual=uniform acctime=10 folTIME= 10
                     );
run;

proc seqdesign;
   ErrorSpend: design nstages=4 method=errfuncobf
               ;
   samplesize model(ceiladjdesign=include)=twosamplesurvival
                   ( nullhazard=0.034657359 hazard=0.01732868
                     accrual=uniform acctime=25 accrate= 6
                     );
run;

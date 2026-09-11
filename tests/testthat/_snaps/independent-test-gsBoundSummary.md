# Test gsBoundSummary for gsDesign Object

                   Analysis               Value Efficacy
                  IA 1: 20%                   Z   3.2527
      N/Fixed design N: 0.2         p (1-sided)   0.0006
                                ~delta at bound   2.2179
                            P(Cross) if delta=0   0.0006
                            P(Cross) if delta=1   0.0370
                  IA 2: 40%                   Z   2.9860
     N/Fixed design N: 0.41         p (1-sided)   0.0014
                                ~delta at bound   1.4398
                            P(Cross) if delta=0   0.0018
                            P(Cross) if delta=1   0.1883
                  IA 3: 60%                   Z   2.6917
     N/Fixed design N: 0.61         p (1-sided)   0.0036
                                ~delta at bound   1.0597
                            P(Cross) if delta=0   0.0047
                            P(Cross) if delta=1   0.4530
                  IA 4: 80%                   Z   2.3737
     N/Fixed design N: 0.82         p (1-sided)   0.0088
                                ~delta at bound   0.8093
                            P(Cross) if delta=0   0.0110
                            P(Cross) if delta=1   0.7229
                      Final                   Z   2.0253
     N/Fixed design N: 1.02         p (1-sided)   0.0214
                                ~delta at bound   0.6176
                            P(Cross) if delta=0   0.0250
                            P(Cross) if delta=1   0.9000

# Test gsBoundSummary for gsDesign Object with Nname set

             Analysis               Value Efficacy
            IA 1: 20%                   Z   3.2527
      samplesize: 0.2         p (1-sided)   0.0006
                          ~delta at bound   2.2179
                      P(Cross) if delta=0   0.0006
                      P(Cross) if delta=1   0.0370
            IA 2: 40%                   Z   2.9860
     samplesize: 0.41         p (1-sided)   0.0014
                          ~delta at bound   1.4398
                      P(Cross) if delta=0   0.0018
                      P(Cross) if delta=1   0.1883
            IA 3: 60%                   Z   2.6917
     samplesize: 0.61         p (1-sided)   0.0036
                          ~delta at bound   1.0597
                      P(Cross) if delta=0   0.0047
                      P(Cross) if delta=1   0.4530
            IA 4: 80%                   Z   2.3737
     samplesize: 0.82         p (1-sided)   0.0088
                          ~delta at bound   0.8093
                      P(Cross) if delta=0   0.0110
                      P(Cross) if delta=1   0.7229
                Final                   Z   2.0253
     samplesize: 1.02         p (1-sided)   0.0214
                          ~delta at bound   0.6176
                      P(Cross) if delta=0   0.0250
                      P(Cross) if delta=1   0.9000

# Test gsBoundSummary for gsSurv Object

       Analysis              Value Efficacy Futility
      IA 1: 33%                  Z   3.0107  -0.2388
         N: 460        p (1-sided)   0.0013   0.5944
     Events: 33       ~HR at bound   0.3457   1.0879
       Month: 1   P(Cross) if HR=1   0.0013   0.4056
                P(Cross) if HR=0.5   0.1412   0.0148
      IA 2: 67%                  Z   2.5465   0.9410
         N: 460        p (1-sided)   0.0054   0.1733
     Events: 65       ~HR at bound   0.5298   0.7907
       Month: 1   P(Cross) if HR=1   0.0062   0.8347
                P(Cross) if HR=0.5   0.5815   0.0437
          Final                  Z   1.9992   1.9992
         N: 460        p (1-sided)   0.0228   0.0228
     Events: 97       ~HR at bound   0.6655   0.6655
       Month: 2   P(Cross) if HR=1   0.0233   0.9767
                P(Cross) if HR=0.5   0.9000   0.1000

# Test gsBoundSummary for gsDesign Object, test.type > 1

                   Analysis            Value Efficacy Futility
                  IA 1: 20%                Z   3.2527  -0.9016
     N/Fixed design N: 0.22      p (1-sided)   0.0006   0.8164
                                ~HR at bound   0.0000  46.6290
                            P(Cross) if HR=0   0.0006   0.1836
                            P(Cross) if HR=1   0.0417   0.0077
                  IA 2: 40%                Z   2.9860  -0.0367
     N/Fixed design N: 0.44      p (1-sided)   0.0014   0.5147
                                ~HR at bound   0.0001   1.1171
                            P(Cross) if HR=0   0.0018   0.5037
                            P(Cross) if HR=1   0.2096   0.0192
                  IA 3: 60%                Z   2.6917   0.6945
     N/Fixed design N: 0.66      p (1-sided)   0.0036   0.2437
                                ~HR at bound   0.0013   0.1811
                            P(Cross) if HR=0   0.0047   0.7737
                            P(Cross) if HR=1   0.4902   0.0363
                  IA 4: 80%                Z   2.3737   1.3603
     N/Fixed design N: 0.88      p (1-sided)   0.0088   0.0869
                                ~HR at bound   0.0064   0.0551
                            P(Cross) if HR=0   0.0109   0.9215
                            P(Cross) if HR=1   0.7556   0.0619
                      Final                Z   2.0253   2.0253
      N/Fixed design N: 1.1      p (1-sided)   0.0214   0.0214
                                ~HR at bound   0.0211   0.0211
                            P(Cross) if HR=0   0.0226   0.9774
                            P(Cross) if HR=1   0.9000   0.1000

# Test gsBoundSummary for gsDesign Object, when nFixSurv is set

                   Analysis            Value Efficacy Futility
                  IA 1: 20%                Z   3.2527  -0.9016
     N/Fixed design N: 0.22      p (1-sided)   0.0006   0.8164
                                ~RR at bound   0.0000  95.5538
                            P(Cross) if RR=0   0.0006   0.1836
                            P(Cross) if RR=1   0.0417   0.0077
                  IA 2: 40%                Z   2.9860  -0.0367
     N/Fixed design N: 0.44      p (1-sided)   0.0014   0.5147
                                ~RR at bound   0.0000   1.1404
                            P(Cross) if RR=0   0.0018   0.5037
                            P(Cross) if RR=1   0.2096   0.0192
                  IA 3: 60%                Z   2.6917   0.6945
     N/Fixed design N: 0.66      p (1-sided)   0.0036   0.2437
                                ~RR at bound   0.0004   0.1316
                            P(Cross) if RR=0   0.0047   0.7737
                            P(Cross) if RR=1   0.4902   0.0363
                  IA 4: 80%                Z   2.3737   1.3603
     N/Fixed design N: 0.88      p (1-sided)   0.0088   0.0869
                                ~RR at bound   0.0025   0.0321
                            P(Cross) if RR=0   0.0109   0.9215
                            P(Cross) if RR=1   0.7556   0.0619
                      Final                Z   2.0253   2.0253
      N/Fixed design N: 1.1      p (1-sided)   0.0214   0.0214
                                ~RR at bound   0.0102   0.0102
                            P(Cross) if RR=0   0.0226   0.9774
                            P(Cross) if RR=1   0.9000   0.1000

# Test with Probability Of Success(POS) set to TRUE

                Analysis                 Value Efficacy Futility
               IA 1: 33%                     Z   3.0107  -0.2387
      Information: 41.64           p (1-sided)   0.0013   0.5943
        Trial POS: 48.6%       ~delta at bound   0.4666  -0.0370
        Post IA POS: 56%   P(Cross) if delta=0   0.0013   0.4057
                         P(Cross) if delta=0.3   0.1412   0.0148
               IA 2: 67%                     Z   2.5465   0.9411
      Information: 83.27           p (1-sided)   0.0054   0.1733
      Post IA POS: 56.1%       ~delta at bound   0.2791   0.1031
                           P(Cross) if delta=0   0.0062   0.8347
                         P(Cross) if delta=0.3   0.5815   0.0437
                   Final                     Z   1.9992   1.9992
     Information: 124.91           p (1-sided)   0.0228   0.0228
                               ~delta at bound   0.1789   0.1789
                           P(Cross) if delta=0   0.0233   0.9767
                         P(Cross) if delta=0.3   0.9000   0.1000

# Test gsBoundSummary with "Spending" in exclude"

      Analysis                   Value Efficacy Futility
     IA 1: 50%                       Z   2.7500   0.4122
        N: 168             p (1-sided)   0.0030   0.3401
                       ~delta at bound  -0.8143  -0.1221
                               B-value   1.9445   0.2915
                                    CP   0.9965   0.0240
                                 CP H1   0.9890   0.4805
                                    PP   0.9710   0.0816
                   P(Cross) if delta=0   0.0030   0.6599
               P(Cross) if delta=-0.69   0.3412   0.0269
         Final                       Z   1.9811   1.9811
        N: 336             p (1-sided)   0.0238   0.0238
                       ~delta at bound  -0.4148  -0.4148
                               B-value   1.9811   1.9811
                   P(Cross) if delta=0   0.0239   0.9761
               P(Cross) if delta=-0.69   0.9000   0.1000


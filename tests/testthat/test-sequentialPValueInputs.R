# Tests for sequentialPvalue routine
# check that inappropriate inputs produce error
testthat::test_that("inappropriate input not flagged with error",{
                    x <- gsDesign()
                    expect_error(sequentialPValue(gsD=5)) # input not group sequential design
                    expect_error(sequentialPValue(gsD=x,n.I=1:5,Z=1:5)) # too many large values in n.I compared to max(gsD$n.I)
                    expect_error(sequentialPValue(gsD=x,n.I=3:1,Z=3:1)) # n.I not in order
                    expect_error(sequentialPValue(gsD=gsDesign(test.type=2))) # bad test.type
                    expect_error(sequentialPValue(gsD=gsDesign(test.type=3))) # bad test.type
                    expect_error(sequentialPValue(gsD=gsDesign(test.type=5))) # bad test.type
                    expect_error(sequentialPValue(gsD=x,n.I="bad")) # non-numeric n.I
                    expect_error(sequentialPValue(gsD=x,n.I=c(.1,.1),Z=c(.4,1.5))) # non-increasing n.I
                    expect_error(sequentialPValue(gsD=x,n.I=1,Z="bad")) # non-numeric Z
                    expect_error(sequentialPValue(gsD=x,n.I=1,Z=2,usTime="bad")) # non-numeric usTime
                    expect_error(sequentialPValue(gsD=x,n.I=1,Z=2,interval=c(0,.999))) # bad interval
                    expect_error(sequentialPValue(gsD=x,n.I=1,Z=2,interval=c(0.01,1))) # bad interval
                    expect_error(sequentialPValue(gsD=x,n.I=1,Z=2,interval=c(0,.5,.999))) # bad interval
                    expect_error(sequentialPValue(gsD=x,n.I=(1:3)/3,Z=3:1,usTime=1:3)) #bad usTime
                    
                  })

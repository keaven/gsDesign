# CP Calculations done using East 6.5 
# source file : test/benchmarks/gsqplot.cywx
# The tolerance in these tests is higher (1e-4) than what is used in other
# comparisons because the CP computations in the different softwares are
# expected to be slightly different.
#-------------------------------------------------------------------------------

testthat::test_that(desc = "Output Validation,
                    source: CP Calculations done using East 6.5 - gsqplot.cywx ",
  code = {
    x <- gsDesign(k = 2, test.type = 1, alpha = 0.025,beta = 0.1,
                  delta1 = 0.3, sfu = sfLDOF)

    res_CP <- gsCPz(z = x$upper$bound[1], i = 1, x = x)

    expect_lte(abs(res_CP - 0.999147769623912), 1e-4)

})

testthat::test_that(desc = "Output Validation, 
                    source: CP Calculations done using East 6.5 - gsqplot.cywx  ",
  code = {
    x <- gsDesign(k = 3, test.type = 1, alpha = 0.025,beta = 0.1, 
                  delta1 = 0.3, sfu = sfLDOF)

    res_CP <- gsCPz(z = x$upper$bound[1:2], i = 1:2, x = x)
    
    expect_lte(abs(res_CP[1] - 0.999999983702667), 1e-4)
    expect_lte(abs(res_CP[2] - 0.969550518393642), 1e-4)
})
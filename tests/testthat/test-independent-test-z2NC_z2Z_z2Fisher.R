
source('../gsDesign_independent_code.R')


# combination test (built-in options are: z2Z, z2NC, z2Fisher):
# that represent the inverse normal combination test (Lehmacher and Wassmer, 1999),
# the sufficient statistic for the complete data, and Fisher's combination test.

# z2NC function extracts timing/information fraction from the base case design
# object x

# For comparing floating-point numbers, an exact match cannot be expected.
# For such test cases,the tolerance is set to 1e-6 (= 0.000001), a sufficiently 
# low value.

#-------------------------------------------------------------------------------
# Test z2Z function
#-------------------------------------------------------------------------------



test_that(
  desc = "Test : output validation z2
                    source : independent R Program gsDesign_independent_code.R",
  code = {
    x <- gsDesign(
      k = 2, test.type = 1, n.fix = 800, timing = c(0.5, 1),
      delta1 = 0.114605, delta0 = 0
    )
    n20 <- 500
    z10 <- 1.25
    
    z2Zx <- z2Z(z1 = 1.25, x = x, n2 = n20)
    val_z <- validate_z2z(x, z10, n20)
    expect_equal(z2Zx[1], val_z)
  }
)


#-------------------------------------------------------------------------------
# Test z2NC function
#-------------------------------------------------------------------------------

testthat::test_that(
  desc = "Test : output validation z2NC
          source : independent R Program-gsDesign_independent_code.R",
  code = {
    x <- gsDesign(
      k = 2, test.type = 1, n.fix = 800, timing = c(0.5, 1),
      delta = 0.114605
    )
    info.frac <- c(0.5, 1)
    z10 <- 1.25
    z2Zx <- z2NC(z1 = 1.25, x = x)
    val_zzze <- validate_z2NC(x, z10, info.frac)
    expect_equal(z2Zx[1], val_zzze)
  }
)

#-------------------------------------------------------------------------------
# Test z2Fisher function
#-------------------------------------------------------------------------------


testthat::test_that(
  desc = "Test : output Validation z2Fisher
          source : independent R Program-gsDesign_independent_code.R", code = {
            x <- gsDesign(
              k = 2, test.type = 1, n.fix = 3200, timing = c(0.25, 1),
              delta = 0.114605
            )
            z1 <- 1.25
            xz <- z2Fisher(z1 = 1.25, x = x)
            val_xze <- validate_z2Fisher(x, z1)
            
            expect_equal(xz[1], val_xze, 1e-6)
          }
)
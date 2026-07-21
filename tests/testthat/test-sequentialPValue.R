testthat::test_that("sequential p-value not computed correctly",{
  x <- gsDesign(n.fix=100,k=4,timing=c(.4,.7,.85))
  interval <- c(.001,.999)
  # Check numbers correctly generated when end of interval is appropriate at IA
  seqp <- sequentialPValue(gsD=gsDesign(n.fix=100,k=4,timing=c(.4,.7,.85)),Z=5,n.I=44,interval=c(.001,.999))
  expect_equal(seqp,.001)
  seqp <-sequentialPValue(gsD=x,Z=.1,n.I=44,interval=interval)
  expect_equal(seqp,interval[2])
  seqp <- sequentialPValue(gsD=x,Z=c(0,5),n.I=c(44,75),interval=interval)
  expect_equal(seqp,interval[1])
  seqp <- sequentialPValue(gsD=x,Z=c(.1,.1),n.I=c(44,75),interval=c(.001,.999))
  expect_equal(seqp,interval[2])
  # check that bounds for sequential p-value are just reached at interim
  n.I <- ceiling(x$n.I+5)
  Z <- rep(1,4)
  seqp <- sequentialPValue(gsD=x,Z=Z,n.I=n.I)
  expect_equal(min(gsDesign(alpha=seqp,k=x$k,maxn.IPlan=max(x$n.I),n.I=n.I,
                        sfu=x$upper$sf,sfupar=x$upper$param,test.type=1)$upper$bound-Z),
               0)
  # check that bounds for sequential p-value are just reached at final
  Z <- c(rep(0,3),2.3)
  seqp <- sequentialPValue(gsD=x,Z=Z,n.I=n.I)
  expect_equal(min(gsDesign(alpha=seqp,k=x$k,maxn.IPlan=max(x$n.I),n.I=n.I,
                            sfu=x$upper$sf,sfupar=x$upper$param,test.type=1)$upper$bound-Z),
               0,tolerance=.00001)
})
testthat::test_that("default n.I not used",{
  x <- gsDesign()
  # check that default n.I used when missing
  seqp1 <- sequentialPValue(gsD=x,Z=c(.1,.1,1.5),n.I=x$n.I,interval=c(.001,.999))
  seqp <- sequentialPValue(gsD=x,Z=c(.1,.1,1.5),interval=c(.001,.999))
  expect_equal(seqp,seqp1)
})

testthat::test_that("sequential p-value supports non-binding harm bounds", {
  x8 <- gsDesign(k = 3, test.type = 8, alpha = 0.025, beta = 0.1, n.fix = 300)
  x1 <- gsDesign(
    k = x8$k,
    test.type = 1,
    alpha = x8$alpha,
    beta = x8$beta,
    n.I = x8$n.I,
    maxn.IPlan = max(x8$n.I),
    sfu = x8$upper$sf,
    sfupar = x8$upper$param
  )
  Z <- c(0.1, 1, 2.2)

  expect_equal(x8$upper$bound, x1$upper$bound)
  expect_equal(
    sequentialPValue(gsD = x8, n.I = x8$n.I, Z = Z),
    sequentialPValue(gsD = x1, n.I = x1$n.I, Z = Z)
  )

  x7 <- gsDesign(k = 3, test.type = 7, alpha = 0.025, beta = 0.1, n.fix = 300)
  expect_error(
    sequentialPValue(gsD = x7, n.I = x7$n.I, Z = Z),
    "no binding lower or harm bound allowed"
  )
})

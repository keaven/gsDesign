
# --------------------------------------------
# ###Test  gsBinomialExact function
# For comparing floating-point numbers, an exact match cannot be expected. 
# For such test cases, the tolerance is set to 1e-6 (= 0.000001), 
# a sufficiently low value
#----------------------------------------------

### Test gsBinomialExact.k - Checking Variable Type, Out-of-Range, Order-of-List
testthat::test_that("Test gsBinomialExact.k - Checking Variable Type, Out-of-Range, 
                    Order-of-List", code = {
  testthat::expect_error(gsBinomialExact(
    k = "a", theta = c(0.1, 0.2), n.I = c(50, 100),
    a = c(3, 7), b = c(20, 30)
  ),
  info = "Checking for incorrect variable type"
  )

  testthat::expect_error(gsBinomialExact(
    k = 2.5, theta = c(0.1, 0.2), n.I = c(50, 100),
    a = c(3, 7), b = c(20, 30)
  ),
  info = "Checking for incorrect variable type"
  )

  testthat::expect_error(gsBinomialExact(
    k = c(1, 2), theta = c(0.1, 0.2), n.I = c(50, 100),
    a = c(3, 7), b = c(20, 30)
  ),
  info = "Checking for incorrect variable type"
  )

  testthat::expect_error(gsBinomialExact(
    k = 1, theta = c(0.1, 0.2), n.I = c(50, 100),
    a = c(3, 7), b = c(20, 30)
  ),
  info = "Checking for out-of-range variable value"
  )
})

### Test gsBinomialExact.theta - Checking Variable Type, Out-of-Range, Order-of-List
testthat::test_that("Test gsBinomialExact.theta - Checking Variable Type, Out-of-Range, 
                    Order-of-List", code = {
  testthat::expect_error(gsBinomialExact(
    k = 2, theta = "a", n.I = c(50, 100),
    a = c(3, 7), b = c(20, 30)
  ),
  info = "Checking for incorrect variable type"
  )

  testthat::expect_error(gsBinomialExact(
    k = 2, theta = c("a", "b"), n.I = c(50, 100),
    a = c(3, 7), b = c(20, 30)
  ),
  info = "Checking for incorrect variable type"
  )

  testthat::expect_error(gsBinomialExact(
    k = 2, theta = c(5, 0.2), n.I = c(50, 100),
    a = c(3, 7), b = c(20, 30)
  ),
  info = "Checking for out-of-range variable value"
  )
})

### Test gsBinomialExact.n.I - Checking Variable Type, Out-of-Range, Order-of-List
testthat::test_that("Test gsBinomialExact.n.I - Checking Variable Type, Out-of-Range, 
                    Order-of-List", code = {
  testthat::expect_error(gsBinomialExact(
    k = 2, theta = c(0.1, 0.2), n.I = "a",
    a = c(3, 7), b = c(20, 30)
  ),
  info = "Checking for incorrect variable type"
  )


  testthat::expect_error(gsBinomialExact(
    k = 2, theta = c(0.1, 0.2), n.I = c(-5, 100),
    a = c(3, 7), b = c(20, 30)
  ),
  info = "Checking for out-of-range variable value"
  )
})


### Test gsBinomialExact.a - Checking Variable Type, Out-of-Range, Order-of-List
testthat::test_that("Test gsBinomialExact.a - Checking Variable Type, Out-of-Range, 
                    Order-of-List", code = {
  testthat::expect_error(gsBinomialExact(
    k = 2, theta = c(0.1, 0.2), n.I = c(50, 100),
    a = "a", b = c(20, 30)
  ),
  info = "Checking for incorrect variable type"
  )

  testthat::expect_error(gsBinomialExact(
    k = 2, theta = c(0.1, 0.2), n.I = c(50, 100),
    a = .5, b = c(20, 30)
  ),
  info = "Checking for incorrect variable type"
  )

  testthat::expect_error(gsBinomialExact(
    k = 2, theta = c(0.1, 0.2), n.I = c(50, 100),
    a = c(.3, 7), b = c(20, 30)
  ),
  info = "Checking for incorrect variable type"
  )

  testthat::expect_error(gsBinomialExact(
    k = 2, theta = c(0.1, 0.2), n.I = c(50, 100),
    a = c("a", "b"), b = c(20, 30)
  ),
  info = "Checking for incorrect variable type"
  )

  testthat::expect_error(gsBinomialExact(
    k = 2, theta = c(0.1, 0.2), n.I = c(50, 100),
    a = c(3, -7), b = c(20, 30)
  ),
  info = "Checking for out-of-range variable value"
  )

  testthat::expect_error(gsBinomialExact(
    k = 2, theta = c(0.1, 0.2), n.I = c(50, 100, 75),
    a = c(3, -7), b = c(20, 30)
  ),
  info = "Checking for out-of-range variable value"
  )
})

### Test gsBinomialExact.b - Checking Variable Type, Out-of-Range, Order-of-List
testthat::test_that("Test gsBinomialExact.b - Checking Variable Type, Out-of-Range, 
                    Order-of-List", code = {
  testthat::expect_error(gsBinomialExact(
    k = 2, theta = c(0.1, 0.2), n.I = c(50, 100),
    a = c(3, 7), b = "a"
  ),
  info = "Checking for incorrect variable type"
  )

  testthat::expect_error(gsBinomialExact(
    k = 2, theta = c(0.1, 0.2), n.I = c(50, 100),
    a = c(3, 7), b = .5
  ),
  info = "Checking for incorrect variable type"
  )

  testthat::expect_error(gsBinomialExact(
    k = 2, theta = c(0.1, 0.2), n.I = c(50, 100),
    a = c(3, 7), b = c("a", "b")
  ),
  info = "Checking for incorrect variable type"
  )

  testthat::expect_error(gsBinomialExact(
    k = 2, theta = c(0.1, 0.2), n.I = c(50, 100),
    a = c(3, 7), b = c(0, 30)
  ),
  info = "Checking for out-of-range variable value"
  )

  testthat::expect_error(gsBinomialExact(
    k = 2, theta = c(0.1, 0.2), n.I = c(50, 100),
    a = c(3, 7), b = c(-5, 30)
  ),
  info = "Checking for order of the list"
  )

  testthat::expect_error(gsBinomialExact(
    k = 2, theta = c(0.1, 0.2), n.I = c(50, 100),
    a = c(3, 7), b = c(35, 30)
  ),
  info = "Checking for out-of-order variable value - b must contain a non-decreasing sequence of integers"
  )
})


### Test gsBinomialExact for lengths of n.I, a, and b  equal k on input
testthat::test_that("Test gsBinomialExact for lengths of n.I, a, and b  equal k on input", code = {
  testthat::expect_error(gsBinomialExact(
    k = 3, theta = c(.1, .2), n.I = c(50, 100),
    a = c(13, 15, 18), b = c(2, 9, 17)
  ),
  info = "Checking lengths of n.I, a, and b  equal k on input"
  )
})


### Test gsBinomialExact for a-vector less than n.I
testthat::test_that("Test gsBinomialExact for a-vector less than n.I", code = {
  testthat::expect_error(gsBinomialExact(
    k = 2, theta = c(.1, .2), n.I = c(50, 100),
    a = c(55, 100), b = c(2, 17)
  ),
  info = "Checking lengths of a-vector less than n.I"
  )
})


### Test gsBinomialExact for n.I and vector-b for increasing order
testthat::test_that("Test gsBinomialExact for n.I and vector-b for increasing order", code = {
  testthat::expect_error(gsBinomialExact(
    k = 2, theta = c(.1, .2), n.I = c(50, 100),
    a = c(25, 100), b = c(45, 105)
  ),
  info = "Checking n.I and vector-b for increasing order"
  )
})


### Test gsBinomialExact for properly increasing n.I
testthat::test_that("Test gsBinomialExact for properly increasing n.I", code = {
  testthat::expect_error(gsBinomialExact(
    k = 2, theta = c(.1, .2), n.I = c(50, 50),
    a = c(3, 7), b = c(20, 30)
  ),
  info = "Checking properly increasing n.I"
  )
})

### Test gsBinomialExact for b greater than a
testthat::test_that("Test gsBinomialExact for b greater than a", code = {
  testthat::expect_error(gsBinomialExact(
    k = 2, theta = c(.1, .2), n.I = c(50, 100),
    a = c(25, 50), b = c(15, 40)
  ),
  info = "Checking for b greater than a"
  )
})

### Test gsBinomialExact for a being a non-decreasing sequence of non-negative integers
testthat::test_that("Test gsBinomialExact for a being a non-decreasing sequence of non-negative integers", code = {
  testthat::expect_error(gsBinomialExact(
    k = 2, theta = c(.1, .2), n.I = c(50, 100),
    a = c(25, 20), b = c(30, 40)
  ),
  info = "Checking a for being a non-decreasing sequence of non-negative integers"
  )
})

### Test gsBinomialExact for n.I - b being a non-decreasing sequence
testthat::test_that("Test gsBinomialExact for n.I - b being a non-decreasing sequence", code = {
  testthat::expect_error(gsBinomialExact(
    k = 2, theta = c(.1, .2), n.I = c(50, 100),
    a = c(3, 7), b = c(25, 100)
  ),
  info = "Checking for n.I - b being a non-decreasing sequence"
  )
})


# Test gsBinomial Exact for upper efficacy boundary crossing probabilities: Benchmark values have been obtained from East 6.5
testthat::test_that(
  desc = "Test gsBinomial Exact for  upper efficacy boundary  crossing probabilities :
  Benchmark values have been obtained from East 6.5 : BinomialExact-01.html",
  code = {
    x <- gsBinomialExact(
      k = 2, theta = c(.1, .2), n.I = c(50, 100),
      a = c(-1, -1), b = c(13, 17)
    )
    testthat::expect_lte(
      object = abs(x$upper$prob["Analysis  1", "0.1"] - 0.00100462),
      expected = 1e-6
    )

    testthat::expect_lte(
      object = abs(x$upper$prob["Analysis  1", "0.2"] - 0.1860570),
      expected = 1e-6
    )

    testthat::expect_lte(
      object = abs(x$upper$prob["Analysis  2", "0.1"] - 0.01979986),
      expected = 1e-6
    )

    testthat::expect_lte(
      object = abs(x$upper$prob["Analysis  2", "0.2"] - 0.6221024),
      expected = 1e-6
    )

    testthat::expect_lte(
      object = abs(x$en[1] - 99.94977),
      expected = 1e-6
    )

    testthat::expect_lte(
      object = abs(x$en[2] - 90.69715),
      expected = 1e-6
    )
  }
)


# Test gsBinomial Exact for lower futility boundary crossing probabilities : Benchmark values have been obtained from East 6.5
testthat::test_that(
  desc = "Test gsBinomial Exact for lower futility boundary crossing probabilities : 
  Benchmark values have been obtained from East 6.5 : BinomialExact-02.html",
  code = {
    x <- gsBinomialExact(
      k = 2, theta = c(.1, .2), n.I = c(50, 100),
      a = c(2, 11), b = c(45, 95)
    )
    testthat::expect_lte(
      object = abs(x$lower$prob["Analysis  1", "0.1"] - 0.1117288),
      expected = 1e-6
    )

    testthat::expect_lte(
      object = abs(x$lower$prob["Analysis  1", "0.2"] - 0.001285415),
      expected = 1e-6
    )

    testthat::expect_lte(
      object = abs(x$lower$prob["Analysis  2", "0.1"] - 0.5935013),
      expected = 1e-6
    )

    testthat::expect_lte(
      object = abs(x$lower$prob["Analysis  2", "0.2"] - 0.011975732),
      expected = 1e-6
    )

    testthat::expect_lte(
      object = abs(x$en[1] - 94.41356218),
      expected = 1e-6
    )

    testthat::expect_lte(
      object = abs(x$en[2] - 99.93572925),
      expected = 1e-6
    )
  }
)


# Test gsBinomial Exact for lower futility & upper efficacy boundary crossing
# probabilities : Benchmark values have been obtained from East 6.5
testthat::test_that(
  desc = "Test gsBinomial Exact for lower futility & upper efficacy boundary crossing 
  probabilities : Benchmark values have been obtained from East 6.5 :BinomialExact-03.html",
  code = {
    x <- gsBinomialExact(
      k = 3, theta = c(.1, .2), n.I = c(36, 71, 107),
      a = c(2, 9, 17), b = c(13, 15, 18)
    )

    testthat::expect_lte(
      object = (abs(x$lower$prob["Analysis  1", "0.1"] - 0.28786288)),
      expected = 1e-6
    )

    testthat::expect_lte(
      object = (abs(x$lower$prob["Analysis  1", "0.2"] - 0.0160231)),
      expected = 1e-6
    )

    testthat::expect_lte(
      object = (abs(x$lower$prob["Analysis  2", "0.1"] - 0.54717197)),
      expected = 1e-6
    )

    testthat::expect_lte(
      object = (abs(x$lower$prob["Analysis  2", "0.2"] - 0.06625957)),
      expected = 1e-6
    )

    testthat::expect_lte(
      object = (abs(x$lower$prob["Analysis  3", "0.1"] - 0.14615089)),
      expected = 1e-6
    )

    testthat::expect_lte(
      object = (abs(x$lower$prob["Analysis  3", "0.2"] - 0.10815084)),
      expected = 1e-6
    )

    testthat::expect_lte(
      object = (abs(x$upper$prob["Analysis  1", "0.1"] - 0.00002493)),
      expected = 1e-6
    )

    testthat::expect_lte(
      object = (abs(x$upper$prob["Analysis  1", "0.2"] - 0.01821676)),
      expected = 1e-6
    )

    testthat::expect_lte(
      object = (abs(x$upper$prob["Analysis  2", "0.1"] - 0.00397141)),
      expected = 1e-6
    )

    testthat::expect_lte(
      object = (abs(x$upper$prob["Analysis  2", "0.2"] - 0.43444804)),
      expected = 1e-6
    )

    testthat::expect_lte(
      object = (abs(x$upper$prob["Analysis  3", "0.1"] - 0.01481792)),
      expected = 1e-6
    )

    testthat::expect_lte(
      object = (abs(x$upper$prob["Analysis  3", "0.2"] - 0.35690169)),
      expected = 1e-6
    )


    testthat::expect_lte(
      object = (abs(x$en[1] - 66.71880358)),
      expected = 1e-6
    )

    testthat::expect_lte(
      object = (abs(x$en[2] - 86.54349597)),
      expected = 1e-6
    )
  }
)

### Test binomialPP by comparing with gsBinomialExact
testthat::test_that("Testing binomialPP by comparing with gsBinomialExact", {
  a <- 0.2
  b <- 0.8
  theta <- c(0.2, 0.4)
  p1 <- 0.4
  PP <- c(0.025, 0.95)
  nIA <- c(50, 100)
  upper <- nIA + 1
  lower <- rep(-1, length(nIA))
  j <- 1
  for (i in nIA) {
    q <- 0:i
    post <- stats::pbeta(p1, a + q, b + i - q, lower.tail = F)
    upper[j] <- sum(post < PP[2])
    lower[j] <- sum(post <= PP[1])
    j <- j + 1
  }

  ns <- binomialPP(a = a, b = b, theta = theta, p1 = p1, PP = PP, nIA = nIA)

  nz <- gsBinomialExact(k = 2, theta = theta, a = lower, b = upper, n.I = nIA)

  testthat::expect_equal(ns$lower$bound, nz$lower$bound, info = "Checking lower bound")
  testthat::expect_equal(ns$lower$prob, nz$lower$prob, info = "Checking lower probability")
  testthat::expect_equal(ns$upper$bound, nz$upper$bound, info = "Checking upper bound")
  testthat::expect_equal(ns$upper$prob, nz$upper$prob, info = "Checking upper probability")
})

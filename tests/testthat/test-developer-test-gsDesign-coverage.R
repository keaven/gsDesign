test_that("gsDesign handles spending function inputs and test types", {
  expect_error(
    gsDesign(k = 3, test.type = 1, sfu = "BAD"),
    "Character specification of upper spending"
  )

  x <- gsDesign(k = 3, test.type = 1, sfu = "OF")
  expect_s3_class(x, "gsDesign")
  expect_null(x$upper$param)
  expect_null(x$lower)

  x <- gsDesign(k = 3, test.type = 2, sfu = "Pocock")
  expect_s3_class(x, "gsDesign")
  expect_identical(x$lower$sf, x$upper$sf)

  x <- gsDesign(
    k = 3, test.type = 3,
    sfu = sfHSD, sfupar = -4,
    sfl = sfHSD, sflpar = -2,
    lsTime = c(0.3, 0.6, 1)
  )
  expect_s3_class(x, "gsDesign")
  expect_equal(length(x$lower$spend), 3)

  x <- gsDesign(
    k = 3, test.type = 5, astar = 0,
    sfu = sfHSD, sfupar = -4,
    sfl = sfHSD, sflpar = -2
  )
  expect_s3_class(x, "gsDesign")
  expect_equal(x$astar, 1 - x$alpha)

  x <- gsDesign(
    k = 3, test.type = 6,
    sfu = sfHSD, sfupar = -4,
    sfl = sfHSD, sflpar = -2,
    usTime = c(0.3, 0.7)
  )
  expect_s3_class(x, "gsDesign")
  expect_equal(x$upper$sTime, c(0.3, 0.7, 1))
})

test_that("gsDesign validates spending times", {
  expect_error(
    gsDesign(k = 3, test.type = 4, usTime = c(0.3, 0.2)),
    "input upper spending time"
  )
  expect_error(
    gsDesign(k = 3, test.type = 4, lsTime = c(0.3, 0.2)),
    "input lower spending time"
  )
})

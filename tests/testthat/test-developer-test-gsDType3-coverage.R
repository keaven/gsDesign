test_that("gsDType3a and gsDType3b execute for test.type = 3", {
  x <- gsDesign(
    k = 3, test.type = 3, alpha = 0.025, beta = 0.1,
    n.I = c(100, 200, 300), n.fix = 300,
    sfu = sfHSD, sfupar = -4,
    sfl = sfHSD, sflpar = -2
  )

  x3b <- gsDesign:::gsDType3b(x)
  expect_true(all(c("upper", "lower") %in% names(x3b)))
  expect_equal(length(x3b$upper$bound), x3b$k)
  expect_equal(dim(x3b$upper$prob), c(x3b$k, length(x3b$theta)))

  x3a <- gsDesign:::gsDType3a(x)
  expect_true(all(c("upper", "lower", "n.I") %in% names(x3a)))
  expect_equal(length(x3a$upper$bound), x3a$k)
})

test_that("gsDType3a returns immediately for test.type = 4", {
  x <- gsDesign(
    k = 3, test.type = 3, alpha = 0.025, beta = 0.1,
    n.I = c(100, 200, 300), n.fix = 300,
    sfu = sfHSD, sfupar = -4,
    sfl = sfHSD, sflpar = -2
  )
  x$test.type <- 4
  out <- gsDesign:::gsDType3a(x)
  expect_s3_class(out, "gsDesign")
  expect_equal(out$test.type, 4)
})

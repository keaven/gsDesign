test_that("gsUtilities checks validate inputs and ranges", {
  expect_silent(checkLengths(1:2, 3:4, 5:6))
  expect_error(checkLengths(1, 2, 3, 4:5), "lengths of inputs are not all equal")
  expect_silent(checkLengths(1, 2, 3, 4:5, allowSingle = TRUE))

  expect_silent(checkRange(c(0.2, 0.8), interval = c(0, 1)))
  expect_error(checkRange(c(-0.1, 0.5), interval = c(0, 1)), "not on interval")
  expect_error(checkRange(c(0.2, 0.3), interval = c(0, 1, 2)), "Interval input must contain two elements")
  expect_error(checkRange(0, interval = c(0, 1), inclusion = c(FALSE, TRUE)), "not on interval")

  expect_silent(checkScalar(3L, "integer"))
  expect_error(checkScalar(3.2, "integer"), "must be scalar of class")
  expect_error(checkScalar(c(1, 2), "numeric"), "must be scalar of class")
  expect_silent(checkScalar(0.5, "numeric", interval = c(0, 1)))

  expect_silent(checkVector(1:3, "numeric", length = 3))
  expect_error(checkVector(matrix(1:4, 2, 2), "numeric"), "must be vector")
  expect_error(checkVector(1:3, "numeric", length = 2), "varstr")

  expect_silent(checkMatrix(matrix(1:4, 2, 2), "numeric", nrows = 2, ncols = 2))
  expect_error(checkMatrix(list(1, 2), "numeric"), "must be matrix")
})

test_that("gsUtilities helper predicates behave as expected", {
  expect_true(isInteger(1))
  expect_true(isInteger(1:3))
  expect_false(isInteger(1.2))
  expect_false(isInteger("a"))

  tmp <- tempfile("gsdesign-md5-")
  dir.create(tmp)
  expect_true(is.na(checkMD5(dir = tmp)))
})

test_that("checkMD5 compares files against MD5 entries", {
  tmp <- tempfile("gsdesign-md5-")
  dir.create(tmp)
  file_path <- file.path(tmp, "foo.txt")
  writeLines("abc", file_path)
  hash <- as.character(tools::md5sum(file_path))
  writeLines(paste(hash, file_path), file.path(tmp, "MD5"))
  expect_false(checkMD5(dir = tmp))

  writeLines(paste(hash, file.path(tmp, "missing.txt")), file.path(tmp, "MD5"))
  expect_false(checkMD5(dir = tmp))

  writeLines(paste("00000000000000000000000000000000", file_path), file.path(tmp, "MD5"))
  expect_false(checkMD5(dir = tmp))
})

testthat::context("get color")

testthat::test_that("test.getColor", {
  testthat::expect_equal(gsDesign:::getColor("black"), "black")
  testthat::expect_equal(gsDesign:::getColor("red"), "red")
  testthat::expect_equal(gsDesign:::getColor(1), "black")
  testthat::expect_equal(gsDesign:::getColor(2), "red")
  testthat::expect_equal(gsDesign:::getColor(c(1, 1)), c("black", "black"))
  testthat::expect_equal(gsDesign:::getColor(c("red", "black")), c("red", "black"))
  testthat::expect_equal(gsDesign:::getColor(1:8), palette()[1:8])
  testthat::expect_equal(gsDesign:::getColor(c(1, "red", 4)), c("black", "red", "blue"))
  testthat::expect_equal(gsDesign:::getColor(c("40", 5, "blue")), c("gray", "cyan", "blue"))
})

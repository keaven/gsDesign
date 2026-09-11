test_that("gsBoundCP returns NA at absent harm bounds", {
  for (test_type in c(7, 8)) {
    for (zero_spend in c(FALSE, TRUE)) {
      args <- list(
        k = 3, test.type = test_type, astar = 0.025,
        testUpper = c(FALSE, TRUE, TRUE),
        testLower = c(TRUE, TRUE, FALSE)
      )
      if (zero_spend) {
        args$sfharm <- sfPoints
        args$sfharmparam <- c(0, 0.5, 1)
      } else {
        args$testHarm <- c(FALSE, TRUE, TRUE)
      }
      x <- do.call(gsDesign, args)
      expect_identical(x$harm$bound[1], -Inf)

      for (theta in list("thetahat", 0, x$delta)) {
        cp <- gsBoundCP(x, theta = theta)
        expect_identical(unname(cp[1, "CPharm"]), NA_real_)
        expect_true(is.finite(cp[2, "CPharm"]))
        effect <- if (is.character(theta)) x$harm$bound[2] / sqrt(x$n.I[2]) else theta
        expected <- sum(gsCP(x, theta = effect, i = 2, zi = x$harm$bound[2])$upper$prob)
        expect_equal(unname(cp[2, "CPharm"]), expected)
      }
    }
  }
})

test_that("gsBoundSummary includes conditional power for selective harm designs", {
  for (test_type in c(7, 8)) {
    x <- gsDesign(
      k = 3, test.type = test_type, astar = 0.025,
      testUpper = c(FALSE, TRUE, TRUE),
      testLower = c(TRUE, TRUE, FALSE),
      testHarm = c(FALSE, TRUE, TRUE)
    )
    summary <- gsBoundSummary(x, exclude = NULL)
    expect_s3_class(summary, "gsBoundSummary")
    for (label in c("CP", "CP H1")) {
      theta <- if (label == "CP") "thetahat" else x$delta
      cp <- gsBoundCP(x, theta = theta)
      rows <- summary$Value == label
      expect_equal(sum(rows), x$k - 1)
      expect_equal(summary$Harm[rows], round(cp[, "CPharm"], 4))
      expect_equal(summary$Futility[rows], round(cp[, "CPlo"], 4))
      expect_equal(summary$Efficacy[rows], round(cp[, "CPhi"], 4))
    }
    expect_true(is.na(summary$Harm[summary$Value == "CP"][1]))
    expect_true(is.finite(summary$Harm[summary$Value == "CP"][2]))
  }
})

test_that("gsBoundSummary only calculates requested conditional power", {
  original <- gsBoundCP
  calls <- list()
  local_mocked_bindings(
    gsBoundCP = function(x, theta = "thetahat", r = 18) {
      calls[[length(calls) + 1L]] <<- theta
      original(x, theta = theta, r = r)
    },
    .package = "gsDesign"
  )

  for (test_type in c(1, 4, 7, 8)) {
    x <- gsDesign(k = 3, test.type = test_type, astar = 0.025)
    calls <- list()
    default <- gsBoundSummary(x)
    expect_length(calls, 0)
    expect_false(any(default$Value %in% c("CP", "CP H1")))

    calls <- list()
    cp_only <- gsBoundSummary(x, exclude = c("CP H1", "PP"))
    expect_identical(calls, list("thetahat"))
    expect_true("CP" %in% cp_only$Value)
    expect_false("CP H1" %in% cp_only$Value)

    calls <- list()
    h1_only <- gsBoundSummary(x, exclude = c("CP", "PP"))
    expect_identical(calls, list(x$delta))
    expect_true("CP H1" %in% h1_only$Value)
    expect_false("CP" %in% h1_only$Value)

    calls <- list()
    both <- gsBoundSummary(x, exclude = "PP")
    expect_identical(calls, list("thetahat", x$delta))
    columns <- c("Value", "Efficacy", if (test_type > 1) "Futility", if (test_type > 6) "Harm")
    expect_equal(
      unname(as.matrix(both[both$Value == "CP", columns])),
      unname(as.matrix(cp_only[cp_only$Value == "CP", columns]))
    )
    expect_equal(
      unname(as.matrix(both[both$Value == "CP H1", columns])),
      unname(as.matrix(h1_only[h1_only$Value == "CP H1", columns]))
    )
  }
})

test_that("gsBoundSummary does not calculate conditional power for fixed designs", {
  local_mocked_bindings(
    gsBoundCP = function(...) stop("No future analysis for conditional power"),
    .package = "gsDesign"
  )
  summary <- gsBoundSummary(gsSurv(k = 1), exclude = NULL)
  expect_s3_class(summary, "gsBoundSummary")
  expect_false(any(summary$Value %in% c("CP", "CP H1")))
})

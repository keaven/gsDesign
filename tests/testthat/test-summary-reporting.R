test_that("survival methods belong in overall summaries only", {
  methods <- c(LachinFoulkes = "Lachin-Foulkes", Schoenfeld = "Schoenfeld",
               Freedman = "Freedman", BernsteinLagakos = "Bernstein-Lagakos")
  for (method in names(methods)) {
    for (make in list(
      function() gsSurv(method = method),
      function() gsSurv(k = 1, test.type = 1, method = method),
      function() gsSurvCalendar(method = method)
    )) {
      x <- make()
      expect_match(summary(x), paste0("sample size/power method: ", methods[[method]]), fixed = TRUE)
      out <- gsBoundSummary(x)
      expect_false(any(grepl("Method:|method:", capture.output(print(out)))))
      old <- x
      old$method <- NULL
      expect_false(grepl("method:", summary(old), fixed = TRUE))
      expect_equal(out[, -1], gsBoundSummary(old)[, -1], ignore_attr = TRUE)
    }
  }
  x <- gsDesign()
  text <- summary(x)
  x$method <- "Schoenfeld"
  expect_identical(summary(x), text)
})

summary_blocks <- function(x) {
  starts <- which(grepl("^(IA [0-9]+:|Final$)", x$Analysis))
  split(x, findInterval(seq_len(nrow(x)), starts))
}

test_that("POS annotations are kept within each analysis regardless of exclusions", {
  x <- gsSurv()
  all <- gsBoundSummary(x, exclude = NULL)
  all_blocks <- summary_blocks(all)
  defaults <- c("B-value", "Spending", "CP", "CP H1", "PP")
  for (pos in c(FALSE, TRUE)) {
    for (excluded in list(NULL, defaults, c(defaults, "p (1-sided)"), unique(all$Value))) {
      out <- gsBoundSummary(x, POS = pos, exclude = excluded)
      blocks <- summary_blocks(out)
      expect_length(blocks, x$k)
      for (i in seq_len(x$k)) {
        b <- blocks[[i]]
        nnotes <- 4L + as.integer(pos && i == 1L) + as.integer(pos && i < x$k)
        original <- all_blocks[[i]]
        original <- original[!original$Value %in% excluded, , drop = FALSE]
        expect_equal(nrow(b), max(nnotes, nrow(original)))
        expect_match(b$Analysis[2], "N:", fixed = TRUE)
        expect_match(b$Analysis[3], "Events:", fixed = TRUE)
        expect_match(b$Analysis[4], "Month:", fixed = TRUE)
        expect_equal(sum(grepl("Trial POS:", b$Analysis, fixed = TRUE)), as.integer(pos && i == 1L))
        expect_equal(sum(grepl("Post IA POS:", b$Analysis, fixed = TRUE)), as.integer(pos && i < x$k))
        expect_equal(lapply(b[b$Value != "", -1], identity), lapply(original[, -1], identity))
        expect_true(all(is.na(as.matrix(b[b$Value == "", -(1:2), drop = FALSE]))))
      }
      expect_false(any(grepl("NA", capture.output(print(out)), fixed = TRUE)))
    }
  }
})

test_that("alternate alpha columns align despite POS padding", {
  x <- gsSurv()
  out <- gsBoundSummary(x, POS = TRUE, alpha = c(.025, .01))
  ref <- gsBoundSummary(x, POS = FALSE, alpha = c(.025, .01))
  expect_equal(lapply(out[out$Value != "", -1], identity), lapply(ref[ref$Value != "", -1], identity))
  expect_true(all(is.na(out[out$Value == "", 3:ncol(out)])))
})

test_that("fixed designs and rendered tables retain annotations", {
  for (x in list(gsSurv(), gsSurv(k = 1, test.type = 1))) {
    out <- gsBoundSummary(x, POS = TRUE,
      exclude = c("Z", "B-value", "Spending", "CP", "CP H1", "PP", "p (1-sided)"))
    expect_length(summary_blocks(out), x$k)
    html <- capture.output(print(xtable::xtable(out), type = "html", include.rownames = FALSE))
    expect_true(any(grepl("Trial POS:", html, fixed = TRUE)))
    expect_false(any(grepl("LachinFoulkes", html, fixed = TRUE)))
    if (requireNamespace("r2rtf", quietly = TRUE)) {
      path <- tempfile(fileext = ".rtf")
      expect_no_error(as_rtf(out, file = path))
      rtf <- readLines(path, warn = FALSE)
      expect_true(any(grepl("Trial POS:", rtf, fixed = TRUE)))
      expect_false(any(grepl("LachinFoulkes", rtf, fixed = TRUE)))
    }
  }
})

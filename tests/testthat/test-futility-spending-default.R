test_that("two-target survival PP inherits logistic spending and summarizes targets", {
  x <- gsSurv(timing = c(.4, .8), sfu = sfLDOF,
              sfl = sfLogistic, sflpar = c(0, 1),
              lambdaC = log(2) / 12, T = 36, minfup = 12, hr = .7)
  target <- c(.15, .2)
  fit <- gsPPFutilitySpending(x, target_pp = target, i = seq_along(target))
  explicit <- gsPPFutilitySpending(x, target_pp = target, sfl = sfLogistic)
  expect_s3_class(fit, "gsSurv")
  expect_identical(fit$lower$sf, sfLogistic)
  expect_equal(fit$lower$param, explicit$lower$param)
  expect_equal(fit$ppFutilitySpending$achieved_pp, target, tolerance = 1e-4)
  prior <- fit$ppFutilitySpending$prior
  achieved <- vapply(1:2, function(i) gsPP(fit, i = i,
    zi = fit$lower$bound[i], theta = prior$z, wgts = prior$wgts), numeric(1))
  expect_equal(achieved, target, tolerance = 1e-4)
  tab <- gsBoundSummary(fit, exclude = c("B-value", "CP H1"), digits = 6)
  expect_equal(tab$Futility[tab$Value == "PP"][1:2], target, tolerance = 1e-4)
})

test_that("conditional calibrators inherit two-parameter spending for every design class", {
  for (kind in c("statistical", "events", "calendar", "power")) {
    x <- switch(kind,
      statistical = gsDesign(sfl = sfLogistic, sflpar = c(0, 1)),
      events = gsSurv(sfl = sfLogistic, sflpar = c(0, 1)),
      calendar = gsSurvCalendar(sfl = sfLogistic, sflpar = c(0, 1)),
      power = gsSurvPower(gsSurv(sfl = sfLogistic, sflpar = c(0, 1))))
    prior <- list(z = c(0, x$delta), wgts = c(.2, .8))
    pp <- vapply(1:2, function(i) gsPP(x, i = i, zi = x$lower$bound[i],
      theta = prior$z, wgts = prior$wgts), numeric(1))
    cpos <- vapply(1:2, function(i) gsCPOS(i, x, prior$z, prior$wgts), numeric(1))
    for (mode in c("pp", "cpos", "ca", "fixed_cpos")) {
      fun <- switch(mode, pp = gsPPFutilitySpending, cpos = gsCPOSFutilitySpending,
                    ca = gsCAFutilitySpending, fixed_cpos = gsCPOSFutilitySpending)
      args <- list(x, if (mode == "pp") pp else cpos, prior = prior)
      if (mode == "fixed_cpos") args$mode <- "fixed_information"
      fit <- do.call(fun, args)
      explicit <- do.call(fun, c(args, list(sfl = "sfLogistic")))
      expect_identical(fit$lower$sf, sfLogistic)
      expect_equal(fit$lower$param, explicit$lower$param)
      expect_equal(fit$n.I, explicit$n.I)
      if (kind != "statistical") expect_s3_class(fit, "gsSurv")
      if (kind == "power") expect_s3_class(fit, "gsSurvPower")
      achieved <- vapply(1:2, function(i) {
        if (mode == "pp") gsPP(fit, i = i, zi = fit$lower$bound[i],
          theta = prior$z, wgts = prior$wgts)
        else gsCPOS(i, fit, prior$z, prior$wgts)
      }, numeric(1))
      expect_equal(achieved, if (mode == "pp") pp else cpos, tolerance = 1e-4)
      if (mode %in% c("ca", "fixed_cpos")) expect_identical(fit$n.I, x$n.I)
    }
  }
})

test_that("one-parameter inheritance and explicit overrides work across probability calibrators", {
  for (family in list(sfPower, sfHSD)) {
    x <- gsSurv(sfl = sfPower, sflpar = 2)
    reference <- if (identical(family, sfPower)) x else gsSurv(sfl = sfHSD, sflpar = 2)
    prior <- list(z = c(0, x$delta), wgts = c(.2, .8))
    pp <- gsPP(reference, i = 1, zi = reference$lower$bound[1],
               theta = prior$z, wgts = prior$wgts)
    cpos <- gsCPOS(1, reference, prior$z, prior$wgts)
    pos <- gsPOS(reference, prior$z, prior$wgts)
    for (kind in c("pp", "cpos", "ca", "pos")) {
      fun <- switch(kind, pp = gsPPFutilitySpending, cpos = gsCPOSFutilitySpending,
                    ca = gsCAFutilitySpending, pos = gsPOSFutilitySpending)
      args <- list(x, switch(kind, pp = pp, cpos = cpos, ca = cpos, pos = pos),
                   prior = prior)
      if (identical(family, sfHSD)) args$sfl <- "sfHSD"
      fit <- do.call(fun, args)
      expect_identical(fit$lower$sf, family)
      achieved <- switch(kind,
        pp = gsPP(fit, i = 1, zi = fit$lower$bound[1], theta = prior$z, wgts = prior$wgts),
        cpos = gsCPOS(1, fit, prior$z, prior$wgts),
        ca = gsCPOS(1, fit, prior$z, prior$wgts),
        pos = gsPOS(fit, prior$z, prior$wgts))
      expect_equal(achieved, args[[2]], tolerance = 1e-4)
      expect_error(do.call(fun, list(NULL, .3, prior = prior)),
                   class = paste0("gs", toupper(kind), "FutilitySpending_input_error"))
    }
  }
})

test_that("POS rejects an inherited two-parameter family and permits an override", {
  x <- gsSurv(sfl = sfLogistic, sflpar = c(0, 1))
  prior <- list(z = c(0, x$delta), wgts = c(.2, .8))
  expect_error(gsPOSFutilitySpending(x, .5, prior = prior),
    "sfLogistic has 2 free parameters", class = "gsPOSFutilitySpending_input_error")
  target <- gsPOS(gsSurv(sfl = sfHSD, sflpar = 1), prior$z, prior$wgts)
  fit <- gsPOSFutilitySpending(x, target, prior = prior, sfl = sfHSD)
  expect_identical(fit$lower$sf, sfHSD)
  expect_equal(gsPOS(fit, prior$z, prior$wgts), target, tolerance = 1e-4)
})

utils::globalVariables(
  unique(
    c(
      # From `as_gt.gsBinomialExactTable()`
      c("Lower", "Upper", "en", "theta"),
      # From `binomialPowerTable()`
      c("pE")
    )
  )
)

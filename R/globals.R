utils::globalVariables(
  unique(
    c(
      # From `as_gt.gsBinomialExactTable()`
      c("Lower", "Upper", "en"),
      # From `binomialPowerTable()`
      c("pE")
    )
  )
)

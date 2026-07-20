utils::globalVariables(
  unique(
    c(
      # From `lt.gsBinomialExactTable()`
      c("Lower", "Upper", "en", "theta"),
      # From `binomialPowerTable()`
      c("pE")
    )
  )
)

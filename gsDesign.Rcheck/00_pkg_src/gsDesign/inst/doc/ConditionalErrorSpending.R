## ----include=FALSE------------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  dev = "svg",
  fig.ext = "svg",
  fig.width = 7,
  fig.asp = 1,
  fig.align = "center",
  out.width = "65%"
)

## ----message=FALSE, warning=FALSE---------------------------------------------
library(gsDesign)
library(tibble)
library(dplyr)
library(gt)

## -----------------------------------------------------------------------------
pts <- seq(0, 1.2, 0.01)
pal <- palette()

## -----------------------------------------------------------------------------
plot(
  pts,
  sfXG1(0.025, pts, 0.5)$spend,
  type = "l", col = pal[1],
  xlab = "t", ylab = "Spending", main = "Xi-Gallo, Method 1"
)
lines(pts, sfXG1(0.025, pts, 0.6)$spend, col = pal[2])
lines(pts, sfXG1(0.025, pts, 0.75)$spend, col = pal[3])
lines(pts, sfXG1(0.025, pts, 0.9)$spend, col = pal[4])
legend(
  "topleft",
  legend = c("gamma=0.5", "gamma=0.6", "gamma=0.75", "gamma=0.9"),
  col = pal[1:4],
  lty = 1
)

## -----------------------------------------------------------------------------
plot(
  pts,
  sfXG2(0.025, pts, 0.14)$spend,
  type = "l", col = pal[1],
  xlab = "t", ylab = "Spending", main = "Xi-Gallo, Method 2"
)
lines(pts, sfXG2(0.025, pts, 0.25)$spend, col = pal[2])
lines(pts, sfXG2(0.025, pts, 0.5)$spend, col = pal[3])
lines(pts, sfXG2(0.025, pts, 0.75)$spend, col = pal[4])
lines(pts, sfXG2(0.025, pts, 0.9)$spend, col = pal[5])
legend(
  "topleft",
  legend = c("gamma=0.14", "gamma=0.25", "gamma=0.5", "gamma=0.75", "gamma=0.9"),
  col = pal[1:5],
  lty = 1
)

## -----------------------------------------------------------------------------
plot(
  pts,
  sfXG3(0.025, pts, 0.013)$spend,
  type = "l", col = pal[1],
  xlab = "t", ylab = "Spending", main = "Xi-Gallo, Method 3"
)
lines(pts, sfXG3(0.025, pts, 0.02)$spend, col = pal[2])
lines(pts, sfXG3(0.025, pts, 0.05)$spend, col = pal[3])
lines(pts, sfXG3(0.025, pts, 0.1)$spend, col = pal[4])
lines(pts, sfXG3(0.025, pts, 0.25)$spend, col = pal[5])
lines(pts, sfXG3(0.025, pts, 0.5)$spend, col = pal[6])
lines(pts, sfXG3(0.025, pts, 0.75)$spend, col = pal[7])
lines(pts, sfXG3(0.025, pts, 0.9)$spend, col = pal[8])
legend(
  "bottomright",
  legend = c(
    "gamma=0.013", "gamma=0.02", "gamma=0.05", "gamma=0.1",
    "gamma=0.25", "gamma=0.5", "gamma=0.75", "gamma=0.9"
  ),
  col = pal[1:8],
  lty = 1
)

## -----------------------------------------------------------------------------
# Custom function to transpose while preserving names
# From https://stackoverflow.com/questions/42790219/how-do-i-transpose-a-tibble-in-r
transpose_df <- function(df) {
  t_df <- data.table::transpose(df)
  colnames(t_df) <- rownames(df)
  rownames(t_df) <- colnames(df)
  tibble::as_tibble(tibble::rownames_to_column(.data = t_df))
}

## -----------------------------------------------------------------------------
ce <- function(x) {
  k <- x$k
  ce <- c(gsCPz(z = x$upper$bound[1:(k - 1)], i = 1:(k - 1), x = x, theta = 0), NA)
  t <- x$timing
  ce_simple <- c(pnorm((last(x$upper$bound) - x$upper$bound[1:(k - 1)] * sqrt(t[1:(k - 1)])) / sqrt(1 - t[1:(k - 1)]),
    lower.tail = FALSE
  ), NA)
  Analysis <- 1:k
  y <- tibble(
    # Analysis = Analysis,
    Z = x$upper$bound,
    "CE simple" = ce_simple,
    CE = ce
  )
  return(y)
}

## -----------------------------------------------------------------------------
xOF <- gsDesign(k = 4, test.type = 1, sfu = "OF")
xLDOF <- gsDesign(k = 4, test.type = 1, sfu = sfLDOF)
xExp <- gsDesign(k = 4, test.type = 1, sfu = sfExponential, sfupar = 0.76)
x1.8 <- gsDesign(k = 4, test.type = 1, sfu = sfXG1, sfupar = 0.8)
x1.7 <- gsDesign(k = 4, test.type = 1, sfu = sfXG1, sfupar = 0.7)
x1.6 <- gsDesign(k = 4, test.type = 1, sfu = sfXG1, sfupar = 0.6)
x1.5 <- gsDesign(k = 4, test.type = 1, sfu = sfXG1, sfupar = 0.5)
xx <- rbind(
  transpose_df(ce(xOF)) |> mutate(gamma = "O'Brien-Fleming"),
  transpose_df(ce(xExp)) |> mutate(gamma = "Exponential, nu=0.76 to Approximate O'Brien-Fleming"),
  transpose_df(ce(xLDOF)) |> mutate(gamma = "Lan-DeMets to Approximate O'Brien-Fleming"),
  transpose_df(ce(x1.5)) |> mutate(gamma = "gamma = 0.5"),
  transpose_df(ce(x1.6)) |> mutate(gamma = "gamma = 0.6"),
  transpose_df(ce(x1.7)) |> mutate(gamma = "gamma = 0.7"),
  transpose_df(ce(x1.8)) |> mutate(gamma = "gamma = 0.8")
)
xx |>
  gt(groupname_col = "gamma") |>
  tab_spanner(label = "Analysis", columns = 2:5) |>
  fmt_number(columns = 2:5, decimals = 3) |>
  tab_options(data_row.padding = px(1)) |>
  tab_header(
    title = "Xi-Gallo, Method 1 Spending Function",
    subtitle = "Conditional Error Spending Functions"
  ) |>
  tab_footnote(
    footnote = "Conditional Error not accounting for future interim bounds.",
    locations = cells_stub(rows = seq(2, 20, 3))
  ) |>
  tab_footnote(
    footnote = "CE = Conditional Error accounting for all analyses.",
    locations = cells_stub(rows = seq(3, 21, 3))
  )

## -----------------------------------------------------------------------------
x1.8 <- gsDesign(k = 4, test.type = 1, sfu = sfXG2, sfupar = 0.8)
x1.7 <- gsDesign(k = 4, test.type = 1, sfu = sfXG2, sfupar = 0.7)
x1.6 <- gsDesign(k = 4, test.type = 1, sfu = sfXG2, sfupar = 0.6)
x1.5 <- gsDesign(k = 4, test.type = 1, sfu = sfXG2, sfupar = 0.5)
x1.4 <- gsDesign(k = 4, test.type = 1, sfu = sfXG2, sfupar = 0.4)
x1.3 <- gsDesign(k = 4, test.type = 1, sfu = sfXG2, sfupar = 0.3)
x1.2 <- gsDesign(k = 4, test.type = 1, sfu = sfXG2, sfupar = 0.2)
xx <- rbind(
  transpose_df(ce(x1.2)) |> mutate(gamma = "gamma = 0.2"),
  transpose_df(ce(x1.3)) |> mutate(gamma = "gamma = 0.3"),
  transpose_df(ce(x1.4)) |> mutate(gamma = "gamma = 0.4"),
  transpose_df(ce(x1.5)) |> mutate(gamma = "gamma = 0.5"),
  transpose_df(ce(x1.6)) |> mutate(gamma = "gamma = 0.6"),
  transpose_df(ce(x1.7)) |> mutate(gamma = "gamma = 0.7"),
  transpose_df(ce(x1.8)) |> mutate(gamma = "gamma = 0.8")
)
xx |>
  gt(groupname_col = "gamma") |>
  tab_spanner(label = "Analysis", columns = 2:5) |>
  fmt_number(columns = 2:5, decimals = 3) |>
  tab_options(data_row.padding = px(1)) |>
  tab_footnote(
    footnote = "Conditional Error not accounting for future interim bounds.",
    locations = cells_stub(rows = seq(2, 20, 3))
  ) |>
  tab_footnote(
    footnote = "CE = Conditional Error accounting for all analyses.",
    locations = cells_stub(rows = seq(3, 21, 3))
  ) |>
  tab_header(
    title = "Xi-Gallo, Method 2 Spending Function",
    subtitle = "Conditional Error Spending Functions"
  )

## -----------------------------------------------------------------------------
xPocock <- gsDesign(k = 4, test.type = 1, sfu = "Pocock")
xLDPocock <- gsDesign(k = 4, test.type = 1, sfu = sfLDPocock)
xHSD1 <- gsDesign(k = 4, test.type = 1, sfu = sfHSD, sfupar = 1)
x3.025 <- gsDesign(k = 4, test.type = 1, sfu = sfXG3, sfupar = 0.025)
x3.05 <- gsDesign(k = 4, test.type = 1, sfu = sfXG3, sfupar = 0.05)
xx <- rbind(
  transpose_df(ce(xPocock)) |> mutate(gamma = "Pocock"),
  transpose_df(ce(xLDPocock)) |> mutate(gamma = "Lan-DeMets to Approximate Pocock"),
  transpose_df(ce(xHSD1)) |> mutate(gamma = "Hwang-Shih-DeCani, gamma = 1"),
  transpose_df(ce(x3.025)) |> mutate(gamma = "gamma = 0.025"),
  transpose_df(ce(x3.05)) |> mutate(gamma = "gamma = 0.05 ")
)
xx |>
  gt(groupname_col = "gamma") |>
  tab_spanner(label = "Analysis", columns = 2:5) |>
  fmt_number(columns = 2:5, decimals = 3) |>
  tab_options(data_row.padding = px(1)) |>
  tab_footnote(
    footnote = "Conditional Error not accounting for future interim bounds.",
    locations = cells_stub(rows = seq(2, 11, 3))
  ) |>
  tab_footnote(
    footnote = "CE = Conditional Error accounting for all analyses.",
    locations = cells_stub(rows = seq(3, 12, 3))
  ) |>
  tab_header(
    title = "Xi-Gallo, Method 3 Spending Function",
    subtitle = "Conditional Error Spending Functions"
  )


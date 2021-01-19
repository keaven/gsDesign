## ---- include = FALSE-----------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----setup, echo=FALSE, message=FALSE, warning=FALSE----
library(gsDesign)
library(dplyr)
library(gridExtra)

## ---- message=FALSE, fig.width=7.5, fig.height=4--------
hGraph()

## ---- fig.width=7.5, fig.height=4.5---------------------
hGraph(nHypotheses = 3,
       nameHypotheses = c("HA\n First", "HC\n Second", "HB\n Third"),
       alphaHypotheses = c(.2, .3, .5),
       wchar = 'w' # character before weights
)

## ---- message=FALSE, fig.width=8, fig.height=4----------
grid.arrange(
  # left graph in figure
  hGraph(nHypotheses = 3,
         size = 5, # decrease hypothesis text size from default 6
         halfWid = 1.25, # increase ellipse width from default 0.5
         trhw = 0.25, # increase transition box sizes from default 0.075
         radianStart = pi/2, # first hypothesis top middle
         offset = pi/20, # decrease offset between transition lines
         arrowsize = .03 # increase from default 0.02
  ),
  # right graph in figure
  hGraph(nHypotheses = 3,
       x = c(-1, 1, -1), # custom placement using x and y
       y = c(1, 1, -1),
       halfWid = 0.7, # increase ellipse width from default 0.5
       boxtextsize = 3, # decrease box text size from default 4
       trprop = .15 # slide transition boxes closer to initiating hypothesis
  ),
  nrow = 1
)

## ----fig.width=7.5,fig.height=4-------------------------
grid.arrange(
  # left graph in figure
  hGraph(fill=c(1,1,2,2),
         alphaHypotheses = c(.2,.2,.2,.4) * .025),
  # right graph in figure
  hGraph(fill=c(1,1,2,2),
         palette = c("pink", "lightblue"),
         alphaHypotheses = c(.2,.2,.2,.4) * .025),
  nrow = 1
)

## ----fig.width=7.5,fig.height=4-------------------------
hGraph(nHypotheses = 3,
       fill = c(1,1,2),
       palette = c("yellow", "lightblue"),
       legend.name = "Color scheme",
       labels = c("Primary", "Secondary"),
       legend.position = c(.75,.25)
)

## ----fig.width=7.5,fig.height=4-------------------------
hGraph(nHypotheses = 3, 
       m = matrix(c(0, 1, 0, 
                    .2, 0, .8,
                    .3, .7, 0),
                  nrow=3, byrow=TRUE),
)


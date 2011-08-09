## Copyright (C) 2009 Merck Research Laboratories and REvolution Computing, Inc.
##
##	This file is part of gsDesignExplorer.
##
##  gsDesignExplorer is free software: you can redistribute it and/or modify
##  it under the terms of the GNU General Public License as published by
##  the Free Software Foundation, either version 3 of the License, or
##  (at your option) any later version.

##  gsDesignExplorer is distributed in the hope that it will be useful,
##  but WITHOUT ANY WARRANTY; without even the implied warranty of
##  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
##  GNU General Public License for more details.

##  You should have received a copy of the GNU General Public License
##  along with gsDesignExplorer.  If not, see <http://www.gnu.org/licenses/>.
##################################################################################
#  gsDesignGUI Functions
#
#  Exported Functions:
#
#  Hidden Functions
#    QtDesignToRList
#    gsDesignToQt
#    gsDesignPrint
#    gsDesignPlot
#    runDesign
#    launchGSDesignGUI
#    exportDesign
#    exportDesignToRScript
#    parseMathText
#
#  Author(s): William Constantine, REvolution Computing
#             Lee Edlefsen, REvolution Computing
#
#  Reviewer(s):
#
#  Version: 1.0-0
#
##################################################################################

###
# PRIMARY FUNCTIONS
###

"runDesign" <- function(designListRaw, plotPath=file.path(tempdir(), "gsDesignPlot.png"), plotBackground="white")
{
   # create design script
   design <- exportDesignToRScript(designListRaw, file=NULL, append=FALSE, writeHeader=FALSE, gsDesignGUIVersion=NULL, writePlot=FALSE)

   # evaluate the design
   eval(parse(text=design$designScript))

   # store design object
   gsDesignObject <- get(design$designName)

   # define local functions
   nextEven <- function(x) ceiling(x/2) * 2

   # form output to send back to Qt
   #
   # text : print of current design (string scalar)
   # plot : path to plot file (string scalar)
   # fixedSampleSize : fixed sample size (integer scalar)
   # fixedEvents : fixed number of events (integer scalar)
   # analysisMaxnIPlan : planned final sample size, used in analysis mode only (integer scalar)
   # analysisNI : sample size required at each analysis to achieve desired timing and beta for the output value of delta (numeric vector, length=k)
   list(
     text=gsDesignPrint(gsDesignObject),
     plot=gsDesignPlot(gsDesignObject, design$designList, plotPath=plotPath, plotBackground=plotBackground),
     fixedSampleSize=as.integer(nextEven(fixedDesign$sampleSize)),
     fixedEvents=as.integer(ceiling(fixedDesign$events)),
     analysisMaxnIPlan=if (gsDesignObject$n.fix != 1) ceiling(gsDesignObject$n.I[gsDesignObject$k]) else gsDesignObject$n.I[gsDesignObject$k],
     analysisNI=gsDesignObject$n.I
   )
}

"gsDesignPrint" <- function(gsDesignObject)
{
  paste(capture.output(print(gsDesignObject)), collapse="\n")
}

"gsDesignPlot" <- function(gsDesignObject, designList, plotPath=file.path(tempdir(), "gsDesignPlot.png"), plotBackground="white", createRScript=FALSE)
{

  ###
  # Qt->R map
  ###

  isAnalysisMode <- designList$dnModeCombo == "Analysis"

  ## plot type
  supportedTypes <- c("Boundaries", "Power", "Treatment Effect", "Conditional Power", "Spending Function","Expected Sample Size","B-Values")
  plottype <- match(designList$opTypeCombo, supportedTypes)
  plotName <- supportedTypes[plottype]

  # if treatment effect has been chosen and the endpoint is survival, remap the plottype to 8
  if (designList$sampleSizeTab == "Time to Event" && plotName == "Treatment Effect")
  {
     plottype <- 8
  }

  # main
  main <- designList$opTitleLine

  # abscissa label
  xlab <- designList$opXLabelLine

  # ordinate label
  ylab <- designList$opYLabelLeftLine

  # line and point properties
  col <- c(designList$opLine1ColorCombo, designList$opLine2ColorCombo)
  lty <- c(designList$opLine1TypeCombo, designList$opLine2TypeCombo)
  lwd <- c(designList$opLine1WidthSpin, designList$opLine2WidthSpin)
  dgt <- c(designList$opLine1SymDigitsSpin, designList$opLine2SymDigitsSpin)

  # map basic or ggplot2 style
  base <- !(length(grep("high quality", tolower(designList$opPlotRenderCombo))) > 0)

  # parse from the file name the format of the exported plot
  exportFormat <- strsplit(basename(plotPath), "[.]")[[1]]
  exportFormat <- tolower(exportFormat[length(exportFormat)])
  exportFormat <- match.arg(exportFormat, c("bmp","png","pdf","jpg","jpeg","tiff"))

  "labelStr" <- function(x)
  {
    if (length(x) == 1)
    {
      gsub("^\\[1\\] ", "", capture.output(print(x)))
    }
    else
    {
      paste("c(", paste(unlist(lapply(x, labelStr)), collapse=", "), ")", sep="")
    }
  }

  "argStr" <- function(x, collapse=",\n  ")
  {
     paste(paste(deparse(substitute(x)), "=", labelStr(x), collapse="", sep=""), collapse, sep="")
  }

  # define script gsDesign object name
  gsDesignObjectScriptName <- if (isAnalysisMode) paste(designList$dnNameCombo, ".analysis", sep="") else designList$dnNameCombo

  "plotStr" <- paste(
    "# ", plotName, " Plot\n",
    "plot(",
     gsDesignObjectScriptName, ",\n  ",
     argStr(plottype),
     argStr(base),
     if (nchar(main)) argStr(main),
     if (nchar(xlab)) argStr(xlab),
     if (nchar(ylab)) argStr(ylab),
     argStr(col),
     argStr(lwd),
     argStr(lty),
     argStr(dgt, collapse=""),
     ")", sep="")

  if (createRScript)
  {
    return(plotStr)
  }

  if (!base)
  {
    "plotStr" <- paste("print(", plotStr, ")", sep="")
  }

  # export graph to file
  # bg choices typically are "white" or "transparent"
  switch(exportFormat,
    "png" = png(file=plotPath, bg=plotBackground),
    "bmp" = bmp(file=plotPath, bg=plotBackground),
    "pdf" = pdf(file=plotPath, bg=plotBackground),
    "jpg" = jpeg(file=plotPath, bg=plotBackground),
    "jpeg" = jpeg(file=plotPath, bg=plotBackground),
    "tiff" = tiff(file=plotPath, bg=plotBackground),
    png(file=plotPath, bg="transparent")
  )

  # issue plot commands
  eval(parse(text=gsub(paste("plot\\(", gsDesignObjectScriptName, sep=""), "plot(gsDesignObject", plotStr)))

  dev.off()

  plotPath
}

"exportDesign" <- function(designListRaw, file=NULL, append=FALSE, writeHeader=FALSE, gsDesignGUIVersion=NULL, writePlot=TRUE)
{
  # parse from the file name the format of the exported plot
  exportFormat <- strsplit(basename(file), "[.]")[[1]]
  exportFormat <- tolower(exportFormat[length(exportFormat)])
  exportFormat <- match.arg(exportFormat, c("r","tex","rtf","rnw"))

  # export design to file
  switch(exportFormat,
    "r" = exportDesignToRScript(designListRaw, file=file, append=append, writeHeader=writeHeader, gsDesignGUIVersion=gsDesignGUIVersion, writePlot=writePlot),
    "tex" = stop("LaTeX export currently not supported"),
    "rtf" = stop("Rich Text Format export currently not supported"),
    "rnw" = stop("Sweave export currently not supported"),
     exportDesignToRScript(designListRaw, file=file, append=append, writeHeader=writeHeader, gsDesignGUIVersion=gsDesignGUIVersion)
  )
}

"exportDesignToRScript" <- function(designListRaw, file=NULL, append=FALSE, writeHeader=FALSE, gsDesignGUIVersion=NULL, writePlot=TRUE)
{
   # define local functions
   "ifelse1" <- function (test, x, y, ...)
   {
     if (test)
         x
     else if (missing(..1))
         y
     else ifelse1(y, ...)
   }

   # define local functions
   catString <- function(oldstr, var, value) c(oldstr, paste(var, "<-", value))
   formCatVector <- function(...) paste("c(", paste(..., sep=", "), ")", sep="")

   # convert raw design list (names = keys, values = flattened strings from the Qt QMap)
   # to a named list of R objects (values = strings, vectors, matrices, etc.)
   designList <- QtDesignToRList(designListRaw)

   # initialize variables
   if (writeHeader)
   {
     designScript <- paste("# This R script was created via an export of a group sequential design\n",
       "# developed in gsDesign Explorer",
       if (!is.null(gsDesignGUIVersion)) paste(" version ",  gsDesignGUIVersion, sep="") else "",
       " on ", date(), sep="")
   }
   else
   {
     designScript <- ""
   }

   ###
   # Qt -> R mapping
   ###

   designScript <- c(designScript, paste("\n###\n# Design : ", designList$dnNameCombo, "\n# Description : ",
     designList$dnDescCombo, "\n###\n"))

   # number of intervals
   designScript <- catString(designScript, "k", designList$eptIntervalsSpin + 1)

   # test type
   isTwoSidedWithFutility <- designList$sflTestCombo == "2-sided with futility"
   isBetaSpending <- designList$sflLBSCombo == "Beta-spending"
   isHypothesisSpending <- designList$sflLBSCombo == "H0 spending"
   isBinding <- designList$sflLBTCombo == "Binding"
   isNonBinding <- designList$sflLBTCombo == "Non-binding"

   test.type <- which(c(
     designList$sflTestCombo == "1-sided",
     designList$sflTestCombo == "2-sided symmetric",
     isTwoSidedWithFutility && isBetaSpending && isBinding,
     isTwoSidedWithFutility && isBetaSpending && isNonBinding,
     isTwoSidedWithFutility && isHypothesisSpending && isBinding,
     isTwoSidedWithFutility && isHypothesisSpending && isNonBinding))[1]

   designScript <- catString(designScript, "test.type", test.type)

   # Type I Error
   alpha <- designList$eptErrorDSpin / 100.0
   designScript <- catString(designScript, "alpha", alpha)

   # Type II Error
   beta <- 1.0 - designList$eptPowerDSpin / 100.0
   designScript <- catString(designScript, "beta", beta)

   # sample size for fixed design with no interim
   isSurvival <- designList$sampleSizeTab == "Time to Event"
   isBinomial <- designList$sampleSizeTab == "Binomial"
   isUserInput <- designList$sampleSizeTab == "User Input"
   isAnalysisMode <- designList$dnModeCombo == "Analysis"

   if (isBinomial)
   {
     designScript <- catString(designScript, "p1", designList$ssBinControlDSpin)
     designScript <- catString(designScript, "p2", designList$ssBinExpDSpin)
     designScript <- catString(designScript, "delta0", designList$ssBinDeltaDSpin)
     designScript <- catString(designScript, "delta1", "p1 - p2")
   }

   if (isSurvival)
   {
      designScript <- catString(designScript, paste(designList$dnNameCombo, "Survival", sep=""),
        paste("nSurvival(",
            "lambda1=", designList$ssTECtrlDSpin,
            ", lambda2=", designList$ssTEExpDSpin,
            ", eta=", designList$ssTEDropoutDSpin,
            ", Ts=", designList$ssTEAccrualDSpin + designList$ssTEFollowDSpin,
            ", Tr=", designList$ssTEAccrualDSpin,
            ", ratio=", designList$ssTERatioDSpin,
            ", alpha=", alpha,
            ", beta=", beta,
            ", sided=1",
            ", type=\"", ifelse(designList$ssTEHypCombo == "Risk Ratio", "rr", "rd"), "\"",
            ", entry=\"", ifelse(designList$ssTEAccrualCombo == "Uniform", "unif", "expo"), "\"",
            ", gamma=", designList$ssTEGammaDSpin, ")", sep=""))
       designScript <- catString(designScript, "n.fix", paste(designList$dnNameCombo, "Survival$nEvents", sep=""))
   }
   else
   {
      designScript <- catString(designScript, "n.fix",
       switch(designList$sampleSizeTab,
       "User Input" =  designList$ssUserFixedSpin,
       "Binomial" = paste("nBinomial(",
                        "p1=p1, p2=p2",
                        ", alpha=", alpha,
                        ", beta=", beta,
                        ", delta0=delta0",
                        ", ratio=", designList$ssBinRatioDSpin, ")", sep="")))
   }

   # relative timing of interim analyses
   timing <- designList$eptTimingTable
   designScript <- catString(designScript, "timing", paste("c(", paste(timing, collapse=", "), ")", sep=""))

   # upper spending function
   designScript <- catString(designScript, "sfu",
     switch(designList$sfuParamToolBox,
            "ParameterFree" = switch(designList$sfu0PCombo,
                                "Pocock" = "sfLDPocock",
                                "sfLDOF"),
            "OneParameter" = switch(designList$sfu1PCombo,
                                "Power" = "sfPower",
                                "Exponential" = "sfExponential",
                                "sfHSD"),
            "TwoParameter" = switch(designList$sfu2PFunCombo,
                                "Logistic" = "sfLogistic",
                                "Normal" = "sfNormal",
                                "Cauchy" = "sfCauchy",
                                "Extreme Value" = "sfExtremeValue",
                                "Extreme Value (2)" = "sfExtremeValue2",
                                "Beta Distribution" = "sfBetaDist"),
            "ThreeParameter" = "sfTDist",
            "PiecewiseLinear" = "sfLinear",
            "sfHSD"))

   designScript <- catString(designScript, "sfupar",
     switch(designList$sfuParamToolBox,
            "ParameterFree" = -8,
            "OneParameter" = designList$sfu1PDSpin,
            "TwoParameter" = ifelse1(designList$sfu2PTab == "Points",
                                formCatVector(designList$sfu2PPt1XDSpin, designList$sfu2PPt2XDSpin, designList$sfu2PPt1YDSpin, designList$sfu2PPt2YDSpin),
                                formCatVector(designList$sfu2PLMIntDSpin, designList$sfu2PLMSlpDSpin)),
            "ThreeParameter" = ifelse1(designList$sfu3PTab == "Points",
                                formCatVector(designList$sfu3PPt1XDSpin, designList$sfu3PPt2XDSpin, designList$sfu3PPt1YDSpin, designList$sfu3PPt2YDSpin, designList$sfu3PPtsDfDSpin),
                                formCatVector(designList$sfu3PLMIntDSpin, designList$sfu3PLMSlpDSpin, designList$sfu3PLMDfDSpin)),
            "PiecewiseLinear" = formCatVector(designList$sfuPieceTableX[1], designList$sfuPieceTableX[2], designList$sfuPieceTableY[1], designList$sfuPieceTableY[2]),
            -8))

   # lower spending function
   designScript <- catString(designScript, "sfl",
     switch(designList$sflParamToolBox,
            "ParameterFree" = switch(designList$sfl0PCombo,
                                "Pocock" = "sfLDPocock",
                                "sfLDOF"),
            "OneParameter" = switch(designList$sfl1PCombo,
                                "Power" = "sfPower",
                                "Exponential" = "sfExponential",
                                "sfHSD"),
            "TwoParameter" = switch(designList$sfl2PFunCombo,
                                "Logistic" = "sfLogistic",
                                "Normal" = "sfNormal",
                                "Cauchy" = "sfCauchy",
                                "Extreme Value" = "sfExtremeValue",
                                "Extreme Value (2)" = "sfExtremeValue2",
                                "Beta Distribution" = "sfBetaDist"),
            "ThreeParameter" = "sfTDist",
            "PiecewiseLinear" = "sfLinear",
            "sfHSD"))

   designScript <- catString(designScript, "sflpar",
     switch(designList$sflParamToolBox,
            "ParameterFree" = -8,
            "OneParameter" = designList$sfl1PDSpin,
            "TwoParameter" = ifelse1(designList$sfl2PTab == "Points",
                                formCatVector(designList$sfl2PPt1XDSpin, designList$sfl2PPt2XDSpin, designList$sfl2PPt1YDSpin, designList$sfl2PPt2YDSpin),
                                formCatVector(designList$sfl2PLMIntDSpin, designList$sfl2PLMSlpDSpin)),
            "ThreeParameter" = ifelse1(designList$sfl3PTab == "Points",
                                formCatVector(designList$sfl3PPt1XDSpin, designList$sfl3PPt2XDSpin, designList$sfl3PPt1YDSpin, designList$sfl3PPt2YDSpin, designList$sfl3PPtsDfDSpin),
                                formCatVector(designList$sfl3PLMIntDSpin, designList$sfl3PLMSlpDSpin, designList$sfl3PLMDfDSpin)),
            "PiecewiseLinear" = formCatVector(designList$sflPieceTableX[1], designList$sflPieceTableX[2], designList$sflPieceTableY[1], designList$sflPieceTableY[2]),
            -8))

   # set sample size endpoint type
   if (isSurvival)
   {
     designScript <- catString(designScript, "endpoint", "\"tte\"")
   }

   if (isBinomial)
   {
     designScript <- catString(designScript, "endpoint", "\"binomial\"")
   }

   if (isUserInput)
   {
     designScript <- catString(designScript, "endpoint", "\"user\"")
   }

   # calculate the design
   if (isSurvival)
   {
      designScript <- catString(designScript, designList$dnNameCombo,
        paste("gsDesign(k=k, test.type=test.type, alpha=alpha, beta=beta, n.fix=n.fix, timing=timing, sfu=sfu, sfupar=sfupar, sfl=sfl, sflpar=sflpar, ",
        "endpoint=endpoint, ",
        "nFixSurv=",
          paste(designList$dnNameCombo, "Survival$n", sep=""), ")", sep=""))
   }
   else if (isBinomial)
   {
      designScript <- catString(designScript, designList$dnNameCombo,
        paste("gsDesign(k=k, test.type=test.type, alpha=alpha, beta=beta, n.fix=n.fix, timing=timing, sfu=sfu, sfupar=sfupar, sfl=sfl, sflpar=sflpar, ",
        "endpoint=endpoint, delta0=delta0, delta1=delta1)", sep=""))
   }
   else
   {
      designScript <- catString(designScript, designList$dnNameCombo,
        paste("gsDesign(k=k, test.type=test.type, alpha=alpha, beta=beta, n.fix=n.fix, timing=timing, sfu=sfu, sfupar=sfupar, sfl=sfl, sflpar=sflpar",
        ", endpoint=endpoint",
        ")", sep=""))
   }

   # add fixed design information
   if (isSurvival)
   {
     designScript <- catString(designScript, "fixedDesign",
       paste("list(events = ", paste(designList$dnNameCombo, "Survival$nEvents", sep=""),
                   ", sampleSize = ", paste(designList$dnNameCombo, "Survival$n", sep=""), ")", sep=""))
   }

   if (isBinomial)
   {
     designScript <- catString(designScript, "fixedDesign", "list(events = 0, sampleSize = n.fix)")
   }

   if (isUserInput)
   {
     designScript <- catString(designScript, "fixedDesign", paste("list(events = ", designList$ssUserFixedSpin, ", sampleSize = 0)", sep=""))
   }

   if (isAnalysisMode)
   {
      designScript <- c(designScript, "\n# Analysis")
      designScript <- catString(designScript, "maxn.IPlan", paste(designList$dnNameCombo, "$n.I[", designList$dnNameCombo, "$k]", sep=""))

      designScript <- catString(designScript, paste(designList$dnNameCombo, "analysis", sep="."),
        paste("gsDesign(k=", designList$anlMaxSampleSizeSpin,
        ", test.type=test.type, alpha=alpha, beta=beta, sfu=sfu, sfupar=sfupar, sfl=sfl, sflpar=sflpar, ",
           paste("delta=", designList$dnNameCombo, "$delta, ", sep=""),
           "maxn.IPlan=maxn.IPlan, ",
           paste("n.I=c(", paste(designList$anlSampleSizeTable[1:designList$anlMaxSampleSizeSpin], collapse=", "), ")", sep=""),
           ")", sep=""))
   }

   # write the current design to file
   if (!is.null(file))
   {
     if (append && (!file.exists(file) || (file.access(file, mode=2) != 0)))
     {
        stop("Append mode: file ", file, " does not exist or is not writable")
     }

     write(designScript, file=file, append=append, sep="\n") #, ncol=3)

     if (writePlot)
     {
        plotStr <- paste("\n", gsDesignPlot(NULL, designList, createRScript=TRUE), sep="")
        write(plotStr, file=file, append=TRUE, sep="\n")
     }

   }

   # return name of design to display in text/plot outputs
   designName <- if (isAnalysisMode) paste(designList$dnNameCombo, "analysis", sep=".") else designList$dnNameCombo

   list(designList=designList, designScript=designScript, designName=designName)
}

###
# CONVERSION FUNCTIONS
###

"QtDesignToRList" <- function(designListRaw)
{
  # converts a raw design list (names = keys, values = flattened strings from a Qt QMap)
  # to a named list of R objects containing unflattened data converted to the corresponding data type
  # (e.g., strings, vectors, matrices, etc.)

  designDF <- t(data.frame(designListRaw))
  factors <- rep("NA", nrow(designDF))
  nms <- row.names(designDF)
  factors[grep("Tab[.](string|index)", nms)] <- "QTabWidget"
  factors[grep("Table[XY]*[.](nrow|ncol|data)", nms)] <- "QTableWidget"
  factors[grep("Spin$", nms)] <- "QSpinBox"
  factors[grep("DSpin$", nms)] <- "QDoubleSpinBox"
  factors[grep("Combo[.](index|string)", nms)] <- "QComboBox"
  factors[grep("ToolBox[.](index|string)", nms)] <- "QToolBox"
  factors[grep("Radio$", nms)] <- "QRadioButton"
  factors[grep("Line$", nms)] <- "QLineEdit"

  objectNames <- gsub("[.].*$","", row.names(designDF))

  z <- data.frame(designDF, factors, objectNames, stringsAsFactors=FALSE)
  names(z) <- c("Value", "Class", "objectName")

  # group data by objectName
  z <- split(z, z$objectName)

  lapply(z, function(designDF)
  {
     xclass <- as.vector(designDF$Class[1])
     objectName <- as.vector(designDF$objectName[1])

     if (xclass == "QTableWidget")
     {
       designDF.nrow <- as.integer(designDF[paste(objectName, "nrow", sep="."), "Value"])
       designDF.ncol <- as.integer(designDF[paste(objectName, "ncol", sep="."), "Value"])
       designDF.data <- as.numeric(strsplit(designDF[paste(objectName, "data", sep="."), "Value"], ",")[[1]])

       return(if (designDF.nrow == 1 || designDF.ncol == 1) designDF.data else matrix(designDF.data, nrow=designDF.nrow, ncol=designDF.ncol, byrow=FALSE))
     }

     if (xclass == "QDoubleSpinBox")
     {
       return(as.numeric(designDF$Value[1]))
     }

     if (xclass == "QSpinBox")
     {
       return(as.integer(designDF$Value[1]))
     }

     if (xclass == "QComboBox")
     {
       return(designDF[paste(objectName, "string", sep="."),]$Value)
     }

     if (xclass == "QRadioButton")
     {
       return(designDF$Value[1] == "1")
     }

     if (xclass == "QLineEdit")
     {
       return(parseMathText(designDF$Value[1]))
     }

     if (xclass == "QTabWidget")
     {
       return(designDF[paste(objectName, "string", sep="."), ]$Value)
     }

     if (xclass == "QToolBox")
     {
       return(gsub("[0-9]$", "", designDF[paste(objectName, "string", sep="."), ]$Value))
     }

  })
}

"parseMathText" <- function(x)
{
  # Converts mt() entries in a string to expression entries.
  #
  # > x <- "mt(Lambda), the lazy dog (mt(hat(theta)/delta)) is basking in the mt(widetilde(xy)) sun mt(32*degree)"
  # > parseMathText(x)
  # expression(paste(Lambda, ", the lazy dog (", hat(theta)/delta, ") is basking in the ", widetilde(xy), " sun ", 32 * degree, sep = ""))
  # > plot(1:5, xlab=parseMathText(x))

  if (!is.character(x) || length(x) > 1)
  {
    stop("Input must be a single character string")
  }

  # if there are no math tokens in the string
  # then return the original string
  token <- "mt\\("

  if (!length(grep(token, x)))
  {
    return(x)
  }

  # prepend and append blank math text calls to input string to
  # force deterministic end conditions
  x <- paste("mt()", x, "mt()", sep="")

  # define local functions
  "rightParenReplace" <- function(x)
  {
    # Finds the matching right parenthesis to a previous 'mt(' split.
    # Once found, that ")" character is replaced by the proper text
    # needed to form the end of the current expression.
    # This function also will catch syntax errors in that, if the user
    # is missing a closing right parenthesis, an error will be thrown.
    #
    # Input:
    #   x : a character string previously split using the token "mt\\("
    #
    # Output:
    #   A character string with replaced tokens for the matching right brace

    # intialize variables
    # i : looping index from 1 .. nchar(x)
    # count : a counter.
    # index : to contain the index of the matching right parenthesis once found in the current string
    i <- count <- 1
    index <- NULL

    # break string into a vector of single characters
    z <- strsplit(x, "")[[1]]

    # search through the character vector from left to right.
    # if a "(" is encountered, increment count by 1.
    # if a ")" is encountered, decrement count by 1.
    # if the count is 0, it means we have isolated the matching parenthesis. store the index and break.
    while (i <= length(z))
    {
      count <- count + switch(z[i], "(" = 1, ")" = -1, 0)

      if (count == 0)
      {
        index <- i
        break
      }

      i <- i + 1
    }

    # ensure that we found a matching right parenthesis
    if (is.null(index))
    {
       stop("Syntax error: missing matching right parenthesis")
    }

    # replace the matching right parenthesis with the proper text needed to form the overall expression
    z[index] <- if (index > 1) ", \"" else "\""

    # collapse the vector of strings back into a single character of strings and return
    paste(z, collapse="")
  }

  # split the original string into a vector of strings split by the starting token
  mt <- unlist(lapply(strsplit(x,token)[[1]], function(x) if (nchar(x)) x))
  y <- unlist(lapply(mt, rightParenReplace))
  empty <- grep("^\\)$", y)
  if (length(empty)) y <- y[-empty]

  # form overall expression as a string
  z <- paste("expression(paste(", gsub(", \"$", "", paste(y, collapse="\", ", sep="")), "))", sep="", collapse="")
  z <- gsub("\"\",","", z)
  z <- gsub(", \"\")", ")", z)

  # return the evaluated string, resulting in an expression
  eval(parse(text=z))
}

###
# OPEN PDF MANUAL
###

"openGSDesignGUIManual" <- function()
{
  # returns an invisible error string containing path to the file.
  # if there is a problem, RShowDoc() throws an error
  RShowDoc("gsDesignExplorer", package="gsDesignExplorer", type="pdf")
}


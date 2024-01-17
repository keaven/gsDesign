#' @title Create multiplicity graphs using ggplot2
#'
#' @description \code{hGraph()} plots a multiplicity graph defined by user inputs.
#' The graph can also be used with the **gMCPLite** package to evaluate a set of nominal p-values for the tests of the hypotheses in the graph
#' @param nHypotheses number of hypotheses in graph
#' @param nameHypotheses hypothesis names
#' @param alphaHypotheses alpha-levels or weights for ellipses
#' @param m square transition matrix of dimension `nHypotheses`
#' @param fill grouping variable for hypotheses
#' @param palette colors for groups
#' @param labels text labels for groups
#' @param legend.name text for legend header
#' @param legend.position text string or x,y coordinates for legend
#' @param halfWid half width of ellipses
#' @param halfHgt half height of ellipses
#' @param trhw transition box width
#' @param trhh transition box height
#' @param trprop proportion of transition arrow length where transition box is placed
#' @param digits number of digits to show for alphaHypotheses
#' @param trdigits digits displayed for transition weights
#' @param size text size in ellipses
#' @param boxtextsize transition text size
#' @param arrowsize size of arrowhead for transition arrows
#' @param radianStart radians from origin for first ellipse; nodes spaced equally in clockwise order with centers on an ellipse by default
#' @param offset rotational offset in radians for transition weight arrows
#' @param xradius horizontal ellipse diameter on which ellipses are drawn
#' @param yradius vertical ellipse diameter on which ellipses are drawn
#' @param x x coordinates for hypothesis ellipses if elliptical arrangement is not wanted
#' @param y y coordinates for hypothesis ellipses if elliptical arrangement is not wanted
#' @param wchar character for alphaHypotheses in ellipses
#' @return A `ggplot` object with a multi-layer multiplicity graph
#' @examples
#' # 'gsDesign::hGraph' is deprecated.
#' # See the examples in 'gMCPLite::hGraph' instead.
#' @details
#' See vignette **Multiplicity graphs formatting using ggplot2** for explanation of formatting.
#' @importFrom grDevices gray.colors
#' @importFrom ggplot2 aes ggplot guide_legend stat_ellipse theme theme_void geom_text geom_segment geom_rect scale_fill_manual
#' @importFrom grid unit
#' @importFrom magrittr "%>%"
#' @importFrom dplyr mutate n filter left_join select
#' @importFrom tidyr pivot_longer
#' @importFrom "grDevices" "palette"
#' @rdname hGraph
#' @export
hGraph <- function(
  nHypotheses = 4, 
  nameHypotheses = paste("H", (1:nHypotheses), sep = ""), 
  alphaHypotheses = 0.025/nHypotheses,
  m = matrix(array(1/(nHypotheses - 1), nHypotheses^2), 
             nrow = nHypotheses) - diag(1/(nHypotheses - 1), nHypotheses),
  fill = 1,
  palette = grDevices::gray.colors(length(unique(fill)), start = .5, end = .8),
  labels = LETTERS[1:length(unique(fill))], 
  legend.name = " ", 
  legend.position = "none", 
  halfWid = 0.5,
  halfHgt = 0.5, 
  trhw = 0.1, 
  trhh = 0.075, 
  trprop = 1/3,
  digits = 5, 
  trdigits = 2, 
  size = 6, 
  boxtextsize = 4,
  arrowsize = 0.02, 
  radianStart = if((nHypotheses)%%2 != 0) {
    pi * (1/2 + 1/nHypotheses) } else {    
      pi * (1 + 2/nHypotheses)/2 }, 
  offset = pi/4/nHypotheses, 
  xradius = 2,
  yradius = xradius, 
  x = NULL, 
  y = NULL, 
  # following is temporary fix from intended {'\u03b1'} for Windows
  wchar = if(as.character(Sys.info()[1])=="Windows"){'w'}else{'w'}
){
  .Deprecated("gMCPLite::hGraph", old = "gsDesign::hGraph")
  #####################################################################
  # Begin: Internal functions
  #####################################################################
  ellipseCenters <- function(alphaHypotheses=NULL, digits=5, txt = letters[1:3], fill=1, 
                             xradius = 2, yradius = 2, radianStart = NULL, 
                             x=NULL, y=NULL, wchar='x'){
    ntxt <- length(txt)
    if (!is.null(x) && !is.null(y)){
      if (length(x)!=ntxt) stop("length of x must match # hypotheses")
      if (length(y)!=ntxt) stop("length of y must match # hypotheses")
    }else{
      if (is.null(radianStart)) radianStart <- if((ntxt)%%2!=0){pi*(1/2+1/ntxt)}else{
        pi * (1 + 2 / ntxt) / 2}
      if (!is.numeric(radianStart)) stop("radianStart must be numeric")
      if (length(radianStart) != 1) stop("radianStart should be a single numeric value")
      # compute middle of each rectangle
      radian <- (radianStart - (0:(ntxt-1))/ntxt*2*pi) %% (2*pi)
      x <- xradius * cos(radian)
      y <- yradius * sin(radian)
    }
    # create data frame with middle (x and y) of ellipses, txt, fill
    return(data.frame(x,y,
                      txt=paste(txt,'\n',wchar,'=',round(alphaHypotheses,digits),sep=""),
                      fill=as.factor(fill))
    )
  }
  
  
  makeEllipseData <- function(x=NULL,xradius=.5,yradius=.5){
    # hack to get ellipses around x,y with radii xradius and yradius
    w <- xradius/3.1
    h <- yradius/3.1
    x$n <- 1:nrow(x)
    ellipses <- rbind(x %>% dplyr::mutate(y=y+h),
                      x %>% dplyr::mutate(y=y-h),
                      x %>% dplyr::mutate(x=x+w),
                      x %>% dplyr::mutate(x=x-w)
    )
    ellipses$txt=""
    return(ellipses)
  }
  
  makeTransitionSegments <- function(x=NULL, m=NULL, xradius=NULL, yradius=NULL, offset=NULL, 
                                     trdigits=NULL, trprop=NULL, trhw=NULL, trhh=NULL){
    from <- to <- w <- y <- xend <- yend <- xb <- yb <- xbmin <- xbmax <- ybmin <- ybmax <- txt <- NULL
    # Create dataset records from transition matrix
    md <- data.frame(m) 
    names(md) <- 1:nrow(m) 
    md <- md %>% 
      dplyr::mutate(from=1:dplyr::n()) %>% 
      # put transition weight in w
      tidyr::pivot_longer(-from, names_to="to", values_to="w") %>% 
      dplyr::mutate(to=as.integer(to)) %>% 
      dplyr::filter(w > 0) 
    
    # Get ellipse center centers for transitions
    y <- x %>% dplyr::select(x, y) %>% dplyr::mutate(from = 1:dplyr::n())
    return(
      md %>% dplyr::left_join(y, by = "from") %>%
        dplyr::left_join(y %>% dplyr::transmute(to = from, xend = x, yend = y), by = "to") %>%
        # Use ellipse centers, radii and offset to create points for line segments.
        dplyr::mutate(theta=atan2((yend - y) * xradius, (xend - x) * yradius),
                      x1 = x, x1end = xend, y1 = y, y1end = yend,
                      x = x1 + xradius * cos(theta + offset),
                      y = y1 + yradius * sin(theta + offset),
                      xend = x1end + xradius * cos(theta + pi - offset),
                      yend = y1end + yradius * sin(theta + pi - offset),
                      xb = x + (xend - x) * trprop,
                      yb = y + (yend - y) * trprop,
                      xbmin = xb - trhw, 
                      xbmax = xb + trhw, 
                      ybmin = yb - trhh, 
                      ybmax = yb + trhh,
                      txt = as.character(round(w,trdigits))
        ) %>%
        dplyr::select(c(from, to, w, x, y, xend, yend, xb, yb, xbmin, xbmax, ybmin, ybmax, txt))
    )
  }
  
  
  checkHGArgs <- function(nHypotheses =NULL, nameHypotheses =NULL, alphaHypotheses = NULL, m = NULL, fill = NULL, 
                          palette = NULL, labels = NULL, legend = NULL, legend.name = NULL, legend.Position = NULL, 
                          halfwid = NULL, halfhgt = NULL, trhw = NULL, trhh = NULL, trprop = NULL, digits = NULL, 
                          trdigits = NULL, size = NULL, boxtextsize = NULL, arrowsize = NULL, radianStart = NULL, 
                          offset = NULL, xradius = NULL, yradius = NULL, x = NULL, y = NULL, wchar='w')
  { if (!is.character(nameHypotheses)) stop("Hypotheses should be in a vector of character strings")
    ntxt <- length(nameHypotheses)
    if(!(is.numeric(xradius) & length(xradius) == 1 & xradius > 0)) stop("hGraph: xradius must be positive, > 0 and length 1")
    if(!(is.numeric(yradius) & length(yradius) == 1 & yradius > 0)) stop("hGraph: yradius must be positive, > 0 and length 1")
    # length of fill should be same as ntxt
    if(length(fill) != 1 & length(fill) != ntxt) stop("fill must have length 1 or number of hypotheses")
  }
  # Following is to eliminate R CMD check error related to defining variables
  #from <- halfhgt <- halfwid <- n <- palette <- theta <- to <- txt <- w <- x1 <- x1end <- xb <-
  #xbmax <- xbmin <- xend <- y1 <- y1end <- yb <- ybmax <- ybmin <- yend <- NULL
  #####################################################################
  # End: Internal functions
  #####################################################################
  
  # Check inputs
  checkHGArgs(nHypotheses, nameHypotheses, alphaHypotheses, m, fill, 
              palette, labels, legend, legend.name, legend.position, halfwid, halfhgt, 
              trhw, trhh, trprop, digits, trdigits, size, boxtextsize,
              arrowsize, radianStart, offset, xradius, yradius, x, y, wchar)
  # Set up hypothesis data
  hData <- ellipseCenters(alphaHypotheses,
                          digits,
                          nameHypotheses,
                          fill = fill, 
                          xradius = xradius,
                          yradius = yradius,
                          radianStart = radianStart,
                          x = x,
                          y = y,
                          wchar = wchar)
  # Set up ellipse data
  ellipseData <- hData %>% makeEllipseData(xradius = halfWid, yradius = halfHgt)
  # Set up transition data
  transitionSegments <- hData %>% 
    makeTransitionSegments(m, xradius = halfWid, yradius = halfHgt, offset = offset,
                           trprop = trprop, trdigits = trdigits, trhw = trhw, trhh = trhh)
  # Layer the plot
  ggplot()+
    # plot ellipses
    stat_ellipse(data=ellipseData,
                 aes(x=x, y=y, group=n, fill=as.factor(fill)), 
                 geom="polygon") +
    theme_void() +
    #following should be needed
    #   scale_alpha(guide="none") + 
    scale_fill_manual(values=palette,
                      labels=labels,
                      guide=guide_legend(legend.name)) +
    theme(legend.position = legend.position) +
    # Add text
    geom_text(data=hData,aes(x=x,y=y,label=txt),size=size) + 
    # Add transition arrows
    geom_segment(data = transitionSegments,
                 aes(x=x, y=y, xend=xend, yend=yend),
                 arrow = grid::arrow(length = grid::unit(arrowsize, "npc"))) +
    # Add transition boxes
    geom_rect(data = transitionSegments, 
              aes(xmin = xbmin, xmax = xbmax, ymin = ybmin, ymax = ybmax),
              fill="white",color="black") +
    # Add transition text
    geom_text(data = transitionSegments, aes(x = xb, y = yb, label=txt), size = boxtextsize)
} 

utils::globalVariables(c("from","halfhgt","halfwid","n","palette","theta","to","txt","w","x1","x1end","xb",
                         "xbmax","xbmin","xend","y1","y1end","yb","ybmax","ybmin","yend"))


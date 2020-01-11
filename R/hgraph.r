#' @title Create multiplicity graph using ggplot2
#' @description \code{hGraph()} plots a multiplicity graph defined by user inputs.
#' The graph can also be used with the gMCP package to evaluate a set of nominal p-values for the tests of the hypotheses in the graph;
#' this should be further described in a vignette.
#' @param nHypotheses number of hypotheses in graph
#' @param nameHypotheses hypothesis names
#' @param alphaHypotheses alpha-levels or weights for ellipses
#' @param m square transition matrix of dimension nHypotheses
#' @param fill grouping variable for hypotheses (must be a factor)
#' @param palette color palette for groups
#' @param labels text labels for groups
#' @param legend logical indicator of whether or not legend is desired
#' @param legendName text for legend header
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
#' @param textcol text color for hypotheses
#' @param radianStart radians from origin for first ellipse; nodes spaced equally in clockwise order
#' @param offset rotational offset in radians for transition weight arrows
#' @param radius horizontal ellipse diameter on which ellipses are drawn
#' @param radius2 vertical ellipse diameter on which ellipses are drawn
#' @param x x coordinates for hypothesis ellipses if elliptical arrangement is not wanted
#' @param y y coordinates for hypothesis ellipses if elliptical arrangement is not wanted
#' @param wchar character for alphaHypotheses in ellipses
#' @return A `ggplot` object with a multiplicity graph
#' @examples
#' # Defaults: note clockwise ordering
#' hGraph(5)
#' # Add colors (default is 3 gray shades)
#' hGraph(3,fill=as.factor(1:3))
#' # Colorblind palette
#' cbPalette <- c("#999999", "#E69F00", "#56B4E9", "#009E73",
#'                "#F0E442", "#0072B2", "#D55E00", "#CC79A7")
#' hGraph(6,fill=as.factor(1:6),palette=cbPalette)
#' # Use a hue palette
#' hGraph(4,fill=factor(1:4),palette=scales::hue_pal(l=75)(4))
#' # different alpha allocation, hypothesis names and transitions
#' alphaHypotheses <- c(.005,.007,.013)
#' nameHypotheses <- c("ORR","PFS","OS")
#' m <- matrix(c(0,1,0,
#'               0,0,1,
#'               1,0,0),nrow=3,byrow=TRUE)
#' hGraph(3,alphaHypotheses=alphaHypotheses,nameHypotheses=nameHypotheses,m=m)
#' # Custom position of ellipses, change text and ellipse size, multi-line text
#' hGraph(3,x=sqrt(0:2),y=c(1,3,1.5),size=6,halfWid=.25,halfHgt=.25,
#' nameHypotheses=c("H1:\n Long name","H2:\n Longer name","H3:\n Longest name"))
#' @rdname hGraph
#' @details
#' Details to be added here.
#' @import dplyr
#' @importFrom reshape2 melt
#' @importFrom grDevices gray.colors
#' @import scales
#' @import ggplot2
#' @export
hGraph <- function(nHypotheses = 4,
                   nameHypotheses = paste('H',(1:nHypotheses),sep=''),
                   alphaHypotheses = .025 / nHypotheses,
                   m = matrix(array(1/(nHypotheses-1),nHypotheses^2),nrow=nHypotheses) -
                       diag(1/(nHypotheses-1),nHypotheses),
                   fill = factor(array(1,nHypotheses)),
                   palette=grDevices::gray.colors(length(unique(fill)),alpha=.5),
                   labels=LETTERS[1:length(unique(fill))],
                   legend = FALSE,
                   legendName=" ",
                   legend.position = 'bottom',
                   halfWid = .5,
                   halfHgt = .5,
                   trhw = .1,
                   trhh = .075,
                   trprop = 1/3,
                   digits = 4,
                   trdigits = 2,
                   size = 6,
                   boxtextsize = 4,
                   arrowsize = 0.02,
                   textcol = "black",
                   radianStart = if((nHypotheses)%%2!=0){pi*(1/2+1/nHypotheses)}else{
                     pi * (1 + 2 / nHypotheses) / 2},
                   offset = pi / 4 / nHypotheses,
                   radius = 2,
                   radius2 = radius,
                   x = NULL,
                   y = NULL,
                   wchar=if(as.character(Sys.info()[1])=="Windows"){'\u03b1'}else{'w'}
){
# internal function intermediate calculations
radians <- function(x,y,xend,yend,halfWid,halfHgt){
    theta <- sign(yend-y)*(abs(xend - x)<.0001) * pi / 2
    indx <- (xend-x>0.00001)
    theta[indx] <- atan((yend[indx]-y[indx])*halfWid/(xend[indx]-x[indx])/halfHgt)
    indx <- ((xend - x)< -0.00001 & (yend-y)>.00001)
    theta[indx] <- pi/2 + atan(-(xend[indx]-x[indx])*halfHgt/(yend[indx]-y[indx])/halfWid)
    indx <- ((xend - x) < -.00001 & (yend - y) < -.00001)
    theta[indx] <- atan((yend[indx]-y[indx]) / halfHgt / (xend[indx] - x[indx]) * halfWid) + pi
    indx <- ((xend -x) < -.00001 & abs(yend - y) < .00001)
    theta[indx] <- pi
    return(theta)
}
  # compute middle of each rectangle
  radian <- (radianStart - (0:(nHypotheses-1))/nHypotheses*2*pi) %% (2*pi)
  # create data frame with middle (x and y), left and right (l, r: x-coordinates),
  # top and bottom (t, b: y-coordinates)
  rr <- data.frame(x=radius*cos(radian),y=radius2*sin(radian),
                   txt=paste(nameHypotheses,'\n',wchar,'=',round(alphaHypotheses,digits),sep=""))
  if (!is.null(x)){
    if (length(x)==nHypotheses){ rr$x <- x
    }else stop("length of x must match # hypotheses")
  }
  if (!is.null(y)){
    if (length(y)==nHypotheses){ rr$y<- y
    }else stop("length of y must match # hypotheses")
  }
  # hack to get ellipses around x,y with radii halfWid and halfHgt
  w <- halfWid/3.1
  h <- halfHgt/3.1
  rr$n <- 1:nHypotheses
  ellipses <- rbind(data.frame(x=rr$x,y=rr$y+h,n=rr$n,fill=fill),
                    data.frame(x=rr$x,y=rr$y-h,n=rr$n,fill=fill),
                    data.frame(x=rr$x+w,y=rr$y,n=rr$n,fill=fill),
                    data.frame(x=rr$x-w,y=rr$y,n=rr$n,fill=fill))
  ellipses$txt=""

  # create data frame for connecting hypotheses with transition proportions
  gr <- filter(reshape2::melt(m),value>0)
  if (nrow(gr)>0){
    rra <- select(rr,x,y)
    rra$Var1 <- 1:dim(rra)[1]
    rrb <- rra
    names(rrb) <- c("xend","yend","Var2")
    transitions <- left_join(gr,rra,by="Var1") %>% left_join(rrb,by="Var2")
    transitions$theta <- with(transitions, radians(x,y,xend,yend,halfWid,halfHgt))
    transitions$x <- transitions$x+halfWid*cos(transitions$theta+offset)
    transitions$xend <- transitions$xend+halfWid*cos(transitions$theta+pi-offset)
    transitions$y <- transitions$y+halfHgt*sin(transitions$theta+offset)
    transitions$yend <- transitions$yend+halfHgt*sin(transitions$theta+pi-offset)
    transitions$txt=""
  # now make a data frame for placement of transition weights
    transitionText <- transitions
    transitionText$x <- (1-trprop)*transitions$x+trprop*transitions$xend
    transitionText$y <- (1-trprop)*transitions$y+trprop*transitions$yend
    transitionText$txt <- as.character(round(transitions$value,trdigits))
    transitionText$xmin <- transitionText$x+trhw
    transitionText$ymin <- transitionText$y+trhh
    transitionText$xmax <- transitionText$x-trhw
    transitionText$ymax <- transitionText$y-trhh
  }
  # return plot
  if(length(textcol)==1) textcol<-array(textcol,nHypotheses)
  x<-ggplot()+
    stat_ellipse(data=ellipses,aes(x=x,y=y,group=factor(n),fill=fill),
                 geom="polygon")+
    geom_text(data=rr,aes(x=x,y=y,label=txt),size=size)
  if (nrow(gr)>0){ x <- x+
    geom_segment(data=transitions,
                 aes(x=x,y=y,xend=xend,yend=yend),
                 arrow = grid::arrow(length = grid::unit(arrowsize, "npc")))+
    geom_rect(data=transitionText,aes(xmin=xmin,xmax=xmax,ymin=ymin,ymax=ymax),
              fill="white",color="black")+
    geom_text(data=transitionText,aes(x=x,y=y,label=txt),size=boxtextsize)
  }
  if (legend){
    x<-x+theme_void()+
         scale_fill_manual(values=palette,labels=labels,guide_legend(legendName))+scale_alpha(guide="none") + theme(legend.position = legend.position)
  }else{
    x<-x+theme(rect = element_blank(),line = element_blank(),text = element_blank(),legend.position  = "none")+
      scale_fill_manual(values=palette)
  }
  return(x)
}

##' drawing phylogenetic tree from phylo object
##'
##' 
##' @title ggtree
##' @param tr phylo object
##' @param showDistance add distance legend, logical
##' @param layout one of phylogram, dendrogram, cladogram, fan, radial and unrooted
##' @param ... additional parameter
##' @return tree
##' @importFrom ggplot2 ggplot
##' @importFrom ggplot2 xlab
##' @importFrom ggplot2 ylab
##' @importFrom ggplot2 annotate
##' @importFrom ggplot2 scale_x_reverse
##' @importFrom ggplot2 coord_flip
##' @importFrom ggplot2 coord_polar
##' @export
##' @author Yu Guangchuang
##' @examples
##' require(ape)
##' tr <- rtree(10)
##' ggtree(tr)
ggtree <- function(tr, showDistance=FALSE, layout="phylogram", ...) {
    d <- x <- y <- NULL
    if (layout == "fan") {
        layout <- "phylogram"
        type <- "fan"
    } else if (layout == "radial") {
        layout <- "cladogram"
        type <- "radial"
    } else if (layout == "dendrogram") {
        layout <- "phylogram"
        type <- "dendrogram"
    } else {
        type <- "none"
    }
    p <- ggplot(tr, aes(x, y), layout=layout, ...) + geom_tree(layout, ...) + xlab("") + ylab("") + theme_tree2()

    if (type == "dendrogram") {
        p <- p + scale_x_reverse() + coord_flip()
    } else if (type == "fan" || type == "radial") {
        p <- p + coord_polar(theta = "y")
    } 
    
    if (showDistance == FALSE) {
        p <- p + theme_tree()
    }
    return(p)
}

##' add tree layer
##'
##' 
##' @title geom_tree
##' @param layout one of phylogram, cladogram
##' @param ... additional parameter
##' @return tree layer
##' @importFrom ggplot2 geom_segment
##' @importFrom ggplot2 aes
##' @export
##' @author Yu Guangchuang
##' @examples
##' require(ape)
##' tr <- rtree(10)
##' require(ggplot2)
##' ggplot(tr) + geom_tree()
geom_tree <- function(layout="phylogram", ...) {
    x <- y <- parent <- NULL
    if (layout == "phylogram") {
        geom_segment(aes(x=c(x[parent], x[parent]),
                         xend=c(x, x[parent]),
                         y=c(y, y[parent]),
                         yend=c(y, y)),...)
    } else if (layout == "cladogram" || layout == "unrooted") {
        geom_segment(aes(x=x[parent],
                         xend=x,
                         y=y[parent],
                         yend=y))
    } 
}

##' add tip label layer
##'
##' 
##' @title geom_tiplab 
##' @param align align tip lab or not, logical
##' @param hjust horizontal adjustment
##' @param ... additional parameter
##' @return tip label layer
##' @importFrom ggplot2 geom_text
##' @export
##' @author Yu Guangchuang
##' @examples
##' require(ape)
##' tr <- rtree(10)
##' ggtree(tr) + geom_tiplab()
geom_tiplab <- function(align=FALSE, hjust=-.25, ...) {
    x <- y <- label <- isTip <- NULL
    if (align == TRUE) {
        geom_text(aes(x=max(x), label=label), subset=.(isTip), hjust=hjust, ...)
    } else {
        geom_text(aes(label=label), subset=.(isTip), hjust=hjust, ...)
    }
}



##' add horizontal align lines
##'
##' 
##' @title geom_aline
##' @param linetype line type
##' @param ... additional parameter
##' @return aline layer
##' @export
##' @author Yu Guangchuang
##' @examples
##' require(ape)
##' tr <- rtree(10)
##' ggtree(tr) + geom_tiplab(align=TRUE) + geom_aline()
geom_aline <- function(linetype="dashed", ...) {
    x <- y <- isTip <- NULL
    geom_segment(aes(x=ifelse(x==max(x), x, x*1.02),
                     xend=max(x), yend=y),
                 subset=.(isTip), linetype=linetype, ...)
}

##' add points layer of tips 
##'
##' 
##' @title geom_tippoint 
##' @param ... additional parameter
##' @return tip point layer
##' @importFrom ggplot2 geom_point
##' @export
##' @author Yu Guangchuang
##' @examples
##' require(ape)
##' tr <- rtree(10)
##' ggtree(tr) + geom_tippoint()
geom_tippoint <- function(...) {
    isTip <- NULL
    geom_point(subset=.(isTip), ...)
}


##' tree theme
##'
##' 
##' @title theme_tree
##' @param bgcolor background color
##' @param fgcolor foreground color
##' @importFrom ggplot2 theme_bw
##' @importFrom ggplot2 theme
##' @importFrom ggplot2 element_blank
##' @importFrom ggplot2 %+replace%
##' @export
##' @return updated ggplot object with new theme
##' @author Yu Guangchuang
##' @examples
##' require(ape)
##' tr <- rtree(10)
##' ggtree(tr) + theme_tree()
theme_tree <- function(bgcolor="white", fgcolor="black") {
    theme_tree2() %+replace%
    theme(panel.background=element_rect(fill=bgcolor, colour=bgcolor),
          axis.line.x = element_line(color=bgcolor),
          axis.text.x = element_blank(),
          axis.ticks.x = element_blank()
          )
}

##' tree2 theme
##'
##' 
##' @title theme_tree2
##' @param bgcolor background color
##' @param fgcolor foreground color
##' @importFrom ggplot2 theme_bw
##' @importFrom ggplot2 theme
##' @importFrom ggplot2 element_blank
##' @importFrom ggplot2 element_line
##' @importFrom ggplot2 %+replace%
##' @importFrom ggplot2 element_rect
##' @export
##' @return updated ggplot object with new theme
##' @author Yu Guangchuang
##' @examples
##' require(ape)
##' tr <- rtree(10)
##' ggtree(tr) + theme_tree2()
theme_tree2 <- function(bgcolor="white", fgcolor="black") {
    theme_bw() %+replace%
    theme(legend.position="none",
          panel.grid.minor=element_blank(),
          panel.grid.major=element_blank(),
          panel.background=element_rect(fill=bgcolor, colour=bgcolor),
          panel.border=element_blank(),
          axis.line=element_line(color=fgcolor),
          axis.line.y=element_line(color=bgcolor),
          axis.ticks.y=element_blank(),
          axis.text.y=element_blank()
          )
}


% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/draw_cluster_structure.R
\name{draw_cluster_structure}
\alias{draw_cluster_structure}
\title{Draw Cluster Structure}
\usage{
draw_cluster_structure(n, labels = NULL, resp = NULL, output = "tree")
}
\arguments{
\item{n}{same from cluster_gen}

\item{labels}{corresponds to cluster_labels from cluster_gen}

\item{resp}{corresponds to resp_labels from cluster_gen}

\item{output}{"tree" draws a tree-like structure on the console, "text" prints the structure as a character vector}
}
\value{
Prints structure to console.
}
\description{
This function creates a visual representation of the hierarchical structure
}
\note{
This function is useful for checking how a `list()` object looks as a hierarchical structure, usually to be used as the  `n` and/or `N` arguments of the `cluster_gen` function.
}
\examples{
n <- c(2, 4, 3)
draw_cluster_structure(n)
draw_cluster_structure(n, output="text")
}

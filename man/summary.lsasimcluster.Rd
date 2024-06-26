% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/summary.R
\name{summary.lsasimcluster}
\alias{summary.lsasimcluster}
\title{Summarizes clusters}
\usage{
\method{summary}{lsasimcluster}(
  object,
  digits = 4,
  print = "partial",
  print_hetcor = TRUE,
  force_matrix = FALSE,
  ...
)
}
\arguments{
\item{object}{output of `cluster_gen`}

\item{digits}{loosely controls the number of digits (significant or not) in the output (for `print = TRUE`)}

\item{print}{"all" will pretty-print a summary of statistics, "partial" will only print cluster-level summaries; "none" outputs statistics as a list}

\item{print_hetcor}{if `TRUE` (default), prints the heterogeneous correlation matrix}

\item{force_matrix}{if `TRUE`, prints the heterogeneous correlation matrix even if warnings are generated}

\item{...}{additional arguments (unused; added for compatibility with generic)}
}
\value{
list of summaries
}
\description{
Takes the output of `cluster_gen` and creates summary statistics of the questionnaire variables
}
\note{
Setting `print="none"` allows for saving the results as an R object (list). Otherwise, the results will be simply printed and not saveable.

Changing `digits` may yield unexpected results for the estimates of continuous variables, given how most of them are printed using the number of significant digits (for more information, see `help("summary")`).

Please note that datasets containing large values for the coefficient of variation (sigma / mu) should yield imprecise results.
}
\examples{
n <- c(3, 30)
cls <- cluster_gen(n, n_X = 3, n_W = 5)
summary(cls)
summary(cls, print="none") # allows saving results
}
\seealso{
anova.lsasimcluster
}

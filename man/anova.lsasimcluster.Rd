% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/anova.R
\name{anova.lsasimcluster}
\alias{anova.lsasimcluster}
\title{Generate an ANOVA table for LSASIM clusters}
\usage{
\method{anova}{lsasimcluster}(object, print = TRUE, calc.se = TRUE, ...)
}
\arguments{
\item{object}{list output of `cluster_gen`}

\item{print}{if `TRUE`, output will be a list containing estimators; if `FALSE` (default), output are formatted tables of this information}

\item{calc.se}{if `TRUE`, will try to calculate the standard error of the intraclass correlation}

\item{...}{additional objects of the same type (see `help("anova")` for details)}
}
\value{
Printed ANOVA table or list of parameters
}
\description{
Prints Analysis of Variance table for `cluster_gen` output.
}
\note{
If the rhos for different levels are varied in scale, the generated rho will be less accurate.
}
\references{
Snijders, T. A. B., & Bosker, R. J. (1999). Multilevel Analysis. Sage Publications.
}

#' @title lsasim: A package for simulating large scale assessment data
#' @description lsasim simulates data that mimics large-scale assessments (LSAs), including background questionnaire data and cognitive item responses that adhere to a multiple-matrix sampled design
#'
#' @description Functions to Facilitate the Simulation of Large Scale Assessment Data
#'
#' @section Core functions:
#' \itemize{
#'   \item \code{block_design} Assignment of test items to blocks.
#'   \item \code{booklet_design} Assignment of item blocks to test booklets.
#'   \item \code{booklet_sample} Assignment of test booklets to test takers.
#'   \item \code{item_gen} Generation of random correlation matrix.
#'   \item \code{proportion_gen} Generation of random cumulative proportions.
#'   \item \code{questionnaire_gen} Generation of ordinal and continuous variables.
#'   \item \code{response_gen} Generation of item response data using a rotated block design.
#'   \item \code{cluster_gen} Generation of background questionnaires from a cluster sampling scheme.
#' }
#'
#' @section Useful ancillary functions:
#' \itemize{
#'   \item \code{irt_gen} Generate item responses from an IRT model.  Used by
#'   \code{response_gen}.
#'   \item \code{beta_gen} Calculates analytical and numeric regression
#'   coefficients for the background questionnaire responses as functions of the
#'   latent variable. Used by \code{questionnaire_gen}
#' }
#'
#' @note This package contains vignettes. If you are installing lsasim from GitHub, remember to use `build_vignettes=TRUE` in your `remotes::install_github()` call. Afterwards, you can browse the vignettes by issuing `browseVignettes("lsasim")` in your R terminal.
#'
#' @importFrom stats cov2cor qnorm reshape rnorm runif
#'
#' @docType package
#' @name lsasim
#'
"_PACKAGE"

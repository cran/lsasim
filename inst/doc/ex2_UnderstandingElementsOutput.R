## ----setup, include = FALSE, warning = FALSE--------------------------------------------
library(knitr)
options(width = 90, tidy = TRUE, warning = FALSE, message = FALSE)
opts_chunk$set(comment = "", warning = FALSE, message = FALSE,
               echo = TRUE, tidy = TRUE)

## ----load-------------------------------------------------------------------------------
library(lsasim)

## ----packageVersion---------------------------------------------------------------------
packageVersion("lsasim")

## ----equation, eval=FALSE---------------------------------------------------------------
#  questionnaire_gen(n_obs, cat_prop = NULL, n_vars = NULL, n_X = NULL, n_W = NULL,
#                    cor_matrix = NULL, cov_matrix = NULL,
#                    c_mean = NULL, c_sd = NULL,
#                    theta = FALSE, family = NULL,
#                    full_output = FALSE, verbose = TRUE)

## ---- include = FALSE-------------------------------------------------------------------
set.seed(1234)
(props <- list(1, c(.25, 1), c(.2, .8, 1)))
(yw_cov <- matrix(c(1, .5, .5, .5, 1, .8, .5, .8, 1), nrow = 3))
bg <- questionnaire_gen(n_obs = 10, cat_prop = props, cov_matrix = yw_cov, theta = TRUE,
                  family = "gaussian", full_output = TRUE)
names(bg)

## ---- eval=FALSE------------------------------------------------------------------------
#  ?questionnaire_gen

## ----ex 1a------------------------------------------------------------------------------
set.seed(1234)
(props <- list(1, c(.25, 1), c(.2, .8, 1)))
(yw_cov <- matrix(c(1, .5, .5, .5, 1, .8, .5, .8, 1), nrow = 3))

## ---------------------------------------------------------------------------------------
questionnaire_gen(n_obs = 10, cat_prop = props, cov_matrix = yw_cov, theta = TRUE,
                  family = "gaussian", full_output = TRUE)


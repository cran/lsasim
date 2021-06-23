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

## ----ex 1a------------------------------------------------------------------------------
set.seed(4388)
bg <- questionnaire_gen(n_obs = 100, family = "gaussian")
str(bg)

## ----ex 1b------------------------------------------------------------------------------
set.seed(4388)
bg <- questionnaire_gen(n_obs = 100, theta = TRUE, family = "gaussian")
str(bg)

## ----ex 2a------------------------------------------------------------------------------
set.seed(4388)
bg <- questionnaire_gen(n_obs = 100, n_vars = 4, family = "gaussian")
str(bg)

## ----ex 2b------------------------------------------------------------------------------
set.seed(4388)
bg <- questionnaire_gen(n_obs = 100, n_vars = 4, theta = TRUE, family = "gaussian")
str(bg)

## ----ex 3a------------------------------------------------------------------------------
set.seed(4388)
bg <- questionnaire_gen(n_obs = 100, n_X = 3, n_W = 0, theta = TRUE, family = "gaussian")
str(bg)

## ----ex 3b------------------------------------------------------------------------------
set.seed(4388)
bg <- questionnaire_gen(n_obs = 100, n_X = 3, theta = TRUE, family = "gaussian")
str(bg)

## ----ex 3c------------------------------------------------------------------------------
set.seed(4388)
bg <- questionnaire_gen(n_obs = 100, cat_prop = list(1, 1, 1, 1), theta = TRUE, family = "gaussian")
str(bg)

## ----ex 4a------------------------------------------------------------------------------
set.seed(4388)
bg <- questionnaire_gen(n_obs = 100, n_X = 0, n_W = 2, family = "gaussian")
str(bg)

## ----ex 4b------------------------------------------------------------------------------
set.seed(4388)
bg <- questionnaire_gen(n_obs = 100, n_X = 0, n_W = list(2, 4, 4, 4), family = "gaussian")
str(bg)

## ----ex 5a------------------------------------------------------------------------------
set.seed(4388)
bg <- questionnaire_gen(n_obs = 100, n_X = 2, n_W = list(2, 2), theta = TRUE,
                        c_mean = c(500, 0, 0), c_sd = c(100, 1, 1), family = "gaussian")
str(bg)

## ----ex 5b------------------------------------------------------------------------------
set.seed(4388)
props <- list(1, c(.25, 1), c(.2, .8, 1))
yw_cov <- matrix(c(1, .5, .5, .5, 1, .8, .5, .8, 1), nrow = 3)
bg <- questionnaire_gen(n_obs = 100, cat_prop = props, cov_matrix = yw_cov,
                        c_mean = 2,
                        family = "gaussian")
str(bg)


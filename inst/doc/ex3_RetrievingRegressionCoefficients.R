## ----setup, include = FALSE, warning = FALSE--------------------------------------------
library(knitr)
options(width = 90, tidy = TRUE, warning = FALSE, message = FALSE)
opts_chunk$set(comment = "", warning = FALSE, message = FALSE,
               echo = TRUE, tidy = TRUE)

## ----load-------------------------------------------------------------------------------
library(lsasim)

## ----packageVersion---------------------------------------------------------------------
packageVersion("lsasim")

## ---------------------------------------------------------------------------------------
set.seed(1234)
bg <- questionnaire_gen(n_obs = 1000, n_X = 2, n_W = list(2, 3), theta = TRUE,
                        family = "gaussian", full_output = TRUE)

## ---------------------------------------------------------------------------------------
str(bg$bg)

## ---------------------------------------------------------------------------------------
bg$linear_regression

## ---------------------------------------------------------------------------------------
beta_gen(bg)

## ---------------------------------------------------------------------------------------
beta_gen(bg, MC = TRUE, MC_replications = 100, rename_to_q = TRUE)

## ---------------------------------------------------------------------------------------
beta_gen(bg, MC = TRUE, MC_replications = 100, rename_to_q = TRUE)


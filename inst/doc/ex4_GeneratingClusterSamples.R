## ----setup, include = FALSE, warning = FALSE--------------------------------------------
library(knitr)
library(formatR)
options(width = 90, tidy = TRUE, warning = FALSE, message = FALSE)
opts_chunk$set(
  comment = "", warning = FALSE, message = FALSE,
  echo = TRUE, tidy = TRUE
)

## ----load-------------------------------------------------------------------------------
library(lsasim)

## ----packageVersion---------------------------------------------------------------------
packageVersion("lsasim")

## ----equation, eval=FALSE---------------------------------------------------------------
#  cluster_gen(n,
#    N = 1, cluster_labels = NULL, resp_labels = NULL,
#    cat_prop = NULL, n_X = NULL, n_W = NULL, c_mean = NULL,
#    sigma = NULL, cor_matrix = NULL, separate_questionnaires = TRUE,
#    collapse = "none", sum_pop = sapply(N, sum), calc_weights = TRUE,
#    sampling_method = "mixed", rho = NULL, theta = FALSE,
#    verbose = TRUE, print_pop_structure = verbose
#  )

## ----ex 1-------------------------------------------------------------------------------
set.seed(4388)
cg <- cluster_gen(c(n = 3, N = 5))

## ----ex 1_str---------------------------------------------------------------------------
cg$n[[1]]
cg$n[[2]]
cg$n[[3]]

## ----ex 2-------------------------------------------------------------------------------
set.seed(4388)
n <- list(3, c(20, 15, 25))
N <- list(5, c(200, 500, 400, 100, 100))
cg <- cluster_gen(n, N, n_X = 5, n_W = 2)

## ----ex 2_str---------------------------------------------------------------------------
str(cg$school[[1]])
str(cg$school[[2]])
str(cg$school[[3]])

## ----ex 3-------------------------------------------------------------------------------
set.seed(4388)
cg <- cluster_gen(c(5, 1000), rho = .9, n_X = 2, n_W = 0, c_mean = 10)
sapply(1:5, function(s) mean(cg$school[[s]]$q1)) # means per school != 10
mean(sapply(1:5, function(s) mean(cg$school[[s]]$q1))) # closer to c_mean

## ----ex 3_str---------------------------------------------------------------------------
str(cg)

## ----ex 4-------------------------------------------------------------------------------
x <- cluster_gen(c(5, 1000), rho = .5, n_X = 2, n_W = 0, c_mean = 1:5)


## ----ex 4_str---------------------------------------------------------------------------
anova(x)

## ----ex 5-------------------------------------------------------------------------------
set.seed(4388)
n <- c(cnt = 1, sch = 2, stu = 5)
cg <- cluster_gen(n = n)

## ----ex 5_str---------------------------------------------------------------------------
cg

## ----ex 6, warning = TRUE---------------------------------------------------------------
set.seed(4388)
n <- c(cnt = 1, sch = 2, stu = 5)
cg <- cluster_gen(n = n, n_X = 10, c_mean = c(0.3, 0.4, 0.5, 0.6, 0.7))


## ----ex 6_str---------------------------------------------------------------------------
cg

## ----ex 7-------------------------------------------------------------------------------
set.seed(4388)
n <- c(school = 3, class = 2, student = 5)
cg <- cluster_gen(n, n_X = c(1, 2), sigma = list(.1, c(1, 2)))

## ----ex 7_summary, warning = TRUE-------------------------------------------------------
summary(cg)

## ----ex 8-------------------------------------------------------------------------------
set.seed(4388)
n <- c(school = 3, class = 2, student = 5)
cg <- cluster_gen(n, n_X = c(1, 2), n_W = c(0, 1), c_mean = list(.1, c(0.55, 0.32)))

## ----ex 8_summary-----------------------------------------------------------------------
cg


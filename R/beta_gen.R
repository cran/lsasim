#' Generate regression coefficients
#'
#' @description Uses the output from questionnaire_gen to generate linear
#'   regression coefficients.
#'
#' @param data output from the \code{questionnaire_gen} function with
#'   \code{full_output = TRUE} and \code{theta = TRUE}
#' @param MC if \code{TRUE}, performs Monte Carlo simulation to estimate
#'   regression coefficients
#' @param MC_replications for \code{MC = TRUE}, this represents the number of
#'   Monte Carlo subsamples calculated
#' @param CI confidence interval for Monte Carlo simulations
#' @param output_cov if \code{TRUE}, will also output the covariance matrix of
#'   YXW
#' @param rename_to_q if \code{TRUE}, renames the variables from "x" and "w" to
#'   "q"
#' @param verbose if `FALSE`, output messages will be suppressed (useful for simulations). Defaults to `TRUE`
#' @importFrom stats lm model.matrix quantile cov pnorm setNames
#' @details This function was primarily conceived as a sub-function of
#'   \code{questionnaire_gen}, when \code{family = "gaussian"}, \code{theta =
#'   TRUE}, and \code{full_output = TRUE}. However, it can also be directly
#'   called by the user so they can perform further analysis.
#'
#'   This function primarily calculates the true regression coefficients
#'   (\eqn{\beta}) for the linear influence of the background questionnaire
#'   variables in \eqn{\theta}. From a statistical perspective, this
#'   relationship can be modeled as follows, where \eqn{E(\theta | \boldsymbol{X}, \boldsymbol{W})}{E(\theta | X, W)} is the expectation of \eqn{\theta} given \eqn{\boldsymbol{X} = \{X_1, \ldots, X_P\}}{X = {X_1, ..., X_P}} and \eqn{\boldsymbol{W} = \{W_1, \ldots, W_Q\}}{W = {W_1, ..., W_Q}}:
#'
#'   \deqn{E(\theta | \boldsymbol{X}, \boldsymbol{W}) = \beta_0 + \sum_{p = 1}^P \beta_p X_p + \sum_{q = 1}^Q \beta_{P + q} W_q}{E(theta | X, W) = b_0 + \sum_{p = 1}^P b_p X_p + \sum_{q = 1}^Q b_{P + q} W_q}
#'
#'   The regression coefficients are calculated using the true covariance matrix
#'   either provided by the user upon calling of \code{questionnaire_gen} or
#'   randomly generated by that function if none was provided. In any case, that
#'   matrix is not sample-dependent, though it should be similar to the one
#'   observed in the generated data (especially for larger samples). One
#'   convenient way to check for this similarity is by running the function with
#'   \code{MC = TRUE}, which will generate a numeric estimate; the
#'   \code{MC_replications} argument can be then increased to improve the
#'   estimates at a often-noticeable cost in processing time. If \code{MC =
#'   FALSE}, the \code{MC_replications} will have no effect on the results. In
#'   any case, each subsample will always have the same size as the original
#'   sample.
#'
#'   If the background questionnaire contains categorical variables (\eqn{W}),
#'   the original covariance matrix cannot be used because it contains the
#'   covariances involving \eqn{Z ~ N(0, 1)}, which is the random variable that
#'   gets categorized into \eqn{W}. The case where \eqn{W} is always binomial is
#'   trivial, but if at least one \eqn{W} has more than two categories, the
#'   structure of the covariance matrix changes drastically. In this case, this
#'   function recalculates all covariances between \eqn{\theta}, \eqn{X} and
#'   each category of \eqn{W} using some auxiliary internal functions which rely
#'   on the appropriate distribution (either multivariate normal or truncated
#'   normal). To avoid multicollinearity, the first categories of each \eqn{W}
#'   are dropped before the regression coefficients are calculated.
#'
#' @return By default, this function will output a vector of the regression
#'   coefficients, including intercept. If \code{MC == TRUE}, the output will
#'   instead be a matrix comparing the true regression coefficients obtained
#'   from the covariance matrix with expected values obtained from a Monte Carlo
#'   simulation, complete with 99\% confidence interval.
#'
#'   If \code{output_cov = TRUE}, the output will be a list with two elements:
#'   the first one, \code{betas}, will contain the same output described in the
#'   previous paragraph. The second one, called \code{vcov_YXW}, contains
#'   the covariance matrix of the regression coefficients.
#' @note The equation in this page is best formatted in PDF. We recommend issuing `help("beta_gen", help_type = "PDF")` in your terminal and opening the `beta_gen.pdf` file generated in your working directly. You may also set `help_type = "HTML"`, but the equations will have degraded formatting.
#' @seealso questionnaire_gen
#' @export
#' @examples
#'
#' data <- questionnaire_gen(100, family="gaussian", theta = TRUE,
#'                            full_output = TRUE, n_X = 2, n_W = list(2, 2, 4))
#' beta_gen(data, MC = TRUE)
#'
beta_gen <- function(data, MC = FALSE, MC_replications = 100,
                     CI = c(0.005, 0.995), output_cov = FALSE,
                     rename_to_q = FALSE, verbose = TRUE) {

  # Basic validation checks -----------------------------------------------
  if (!data$theta) stop("Data must include theta")
  if (!is(data, "list")) {
    stop("Generate data with questionnaire_gen(full_output = TRUE)")
  }
  if (!MC & MC_replications != 100) {
    if (verbose) message("Changing the number of Monte Carlo replications has no effect unless MC = TRUE")
  }

  # Basic data subsetting -------------------------------------------------
  YXW <- data$bg[-1]  # remove "subject"
  XW <- YXW[-1]  # remove "theta" (and "subject", from before)

  # Identifying and labeling elements -------------------------------------
  names_X <- names_W <- names_Z <- NULL
  if (data$n_X > 0) names_X <- paste0("x", 1:data$n_X)
  if (data$n_W > 0) {
    names_W <- paste0("w", 1:data$n_W)
    names_Z <- paste0("z", 1:data$n_W)
  }
  names_YX <- c("theta", names_X)
  names_YXZ <- c(names_YX, names_Z)
  dimnames(data$cov_matrix) <- list(names_YXZ, names_YXZ)
  data$cat_prop_W <- data$cat_prop[lapply(data$cat_prop, length) > 1]
  names(data$cat_prop_W_p) <- names(data$cat_prop_W) <- names_W
  names(data$c_sd) <- names(data$c_mean) <- c("theta", names_X)


  # Defining parameters for Y, X, Z and W ---------------------------------
  if (is.null(data$c_mean)) {
    Y_mu <- 0
    XW_mu <- rep(0, length(XW))
  } else {
    Y_mu <- data$c_mean[1]
    X_mu <- data$c_mean[-1]
    W_mu <- data$cat_prop_W_p
    W_cat_names <- names(unlist(W_mu))
    W_cat_names_minus_1st <- W_cat_names[!grepl("1$", W_cat_names)]
    W_mu_minus_1st <- unlist(sapply(W_mu, function(w) w[-1, drop = FALSE]))
    names(W_mu_minus_1st) <- W_cat_names_minus_1st
    XW_mu <- unlist(c(X_mu, W_mu))
    XW_mu_minus_1st <- unlist(c(X_mu, W_mu_minus_1st))
  }

  Y_var <- data$c_sd["theta"] ^ 2
  X_var <- data$c_sd[substring(names(data$c_sd), 1, 1) == "x"] ^ 2
  Y_sd <- sqrt(Y_var)
  X_sd <- sqrt(X_var)

  if (data$n_W > 0) {
    W_var <- lapply(W_mu, function(p) p * (1 - p))
    Z_mu <- 0
    Z_sd <- 1
    cov_YZ <- data$cov_matrix["theta", names_Z, drop = FALSE]
  }
  cov_XZ <- data$cov_matrix[names_X, names_Z, drop = FALSE]

  # Calculating elements for YXW covariance matrix (provided was XYZ) -----
  cov_YW <- cov_XW <- vcov_W <- NULL
  if (data$n_W > 0) {
    q_Z <- lapply(data$cat_prop_W, function(w) qnorm(c(0, w), Z_mu, Z_sd))

    exp_YW <- exp_AB(names_W, Z_mu, W_mu, cov_YZ, q_Z, Y_mu, Z_sd)
    cov_YW <- cov_AB(names_W, exp_YW, Y_mu, W_mu)

    cov_XW <- exp_XW <- list()
    for (x in names_X) {
      exp_XW[[x]] <- exp_AB(names_W, Z_mu, W_mu, cov_XZ[x, ], q_Z,
                            X_mu[[x]], Z_sd)
      cov_XW[[x]] <- cov_AB(names_W, exp_XW[[x]], X_mu[[x]], W_mu)
    }

    # Covariance matrix of the categories of Z
    vcov_W <- lapply(names_W, function(w) create_vcov_w(W_mu[[w]], W_var[[w]]))
    names(vcov_W) <- names_W
  }

  # Final assembly of YXW covariance matrix -------------------------------
  vcov_order <- length(data$c_mean) + length(W_cat_names_minus_1st)
  vcov_YXW <- matrix(nrow = vcov_order, ncol = vcov_order)
  names_YXW_extended <- c("theta", names_X, W_cat_names_minus_1st)
  dimnames(vcov_YXW) <- list(names_YXW_extended, names_YXW_extended)

  # Everything that doesn't involve W
  vcov_YXW[names_YX, names_YX] <- data$cov_matrix[names_YX, names_YX]

  # Cov(Y, W)
  vcov_YXW["theta", W_cat_names_minus_1st] <- unlist(cov_YW)
  vcov_YXW[W_cat_names_minus_1st, "theta"] <- unlist(cov_YW)

  # Cov(X, W)
  for (x in names_X) {
    vcov_YXW[x, W_cat_names_minus_1st] <- unlist(cov_XW[[x]])
    vcov_YXW[W_cat_names_minus_1st, x] <- unlist(cov_XW[[x]])
  }

  # Cov(W, W)
  # Covariances between categories within the same W
  for (w in names_W) {
    w_cols <- vector()
    ref_names <- colnames(vcov_YXW)
    for (c in seq_along(ref_names)) {
      if (w %in% substr(ref_names[c], 1, nchar(ref_names[c]) - 1))
        w_cols <- c(w_cols, c)
    }
    vcov_YXW[w_cols, w_cols] <- vcov_W[[w]]
  }
  # Covariances between categories from different Ws
  for (catA in W_cat_names_minus_1st) {
    for (catB in W_cat_names_minus_1st) {
      muA <- W_mu_minus_1st[catA]
      muB <- W_mu_minus_1st[catB]
      wA <- gsub("\\d$", "", catA)
      wB <- gsub("\\d$", "", catB)
      zA <- gsub("w", "z", wA)
      zB <- gsub("w", "z", wB)
      cond1 <- match(catA, W_cat_names_minus_1st) <
        match(catB, W_cat_names_minus_1st)
      cond2 <- zA != zB
      if (cond1 & cond2) {
        numA <- as.numeric(substring(catA, nchar(catA)))
        numB <- as.numeric(substring(catB, nchar(catB)))
        cov_zA_zB <- data$cov_matrix[c(zA, zB), c(zA, zB)]
        lo_lim <- c(q_Z[[wA]][numA], q_Z[[wB]][numB])
        up_lim <- c(q_Z[[wA]][numA + 1], q_Z[[wB]][numB + 1])
        covAB <- calc_p_mvn_trunc(lo_lim, up_lim, cov_zA_zB) * muB - muA * muB
        vcov_YXW[catA, catB] <- vcov_YXW[catB, catA] <-  covAB
      }
    }
  }

  # Calculating regression parameters -----------------------------------
  beta_hat <- solve(vcov_YXW[-1, -1], vcov_YXW[1, -1])

  intercept <- Y_mu - crossprod(beta_hat, XW_mu_minus_1st)
  output <- setNames(as.vector(c(intercept, beta_hat)), colnames(vcov_YXW))
  if (MC) {
    if (verbose) message("Generating Monte Carlo coefficient estimates. Please wait...")
    boot_data <- list()
    for (r in seq(MC_replications)) {
      unique_lvl <- TRUE
      while (unique_lvl) {
        boot_obs <- sample(rownames(data$bg), replace = TRUE)
        boot_data[[r]] <- YXW[boot_obs, ]
        unique_lvl <- any(sapply(boot_data[[r]], function(x) all(duplicated(x)[-1L])))
      }
    }
    boot_coef <- sapply(boot_data, function(x) lm(theta ~ ., x)$coefficients)
    boot_avg_coef <- apply(boot_coef, 1, mean)
    boot_CI <- apply(boot_coef, 1, function(x) quantile(x, CI))

    # Checking if cov_matrix estimates is contained in MC confidence interval
    cov_in_CI <- output > boot_CI[1, ] & output < boot_CI[2, ]

    output <- t(rbind(cov_matrix = output, MC = boot_avg_coef, boot_CI,
                    cov_in_CI = as.logical(cov_in_CI)))
  }
  if (output_cov) output <- list(betas = output, vcov_YXW = vcov_YXW)
  if (rename_to_q) {
    X_numbers <- W_numbers <- W_numbers_expanded_cats <- NULL
    if (data$n_X > 0) X_numbers <- 1:data$n_X
    if (data$n_W > 0) {
      W_numbers <- 1:data$n_W + length(X_numbers)
      W_categories <- sapply(data$cat_prop_W, length)
      W_categories_expanded <- lapply(W_categories, function(x) 2:max(x))
      W_numbers_expanded <- rep(W_numbers,
                                sapply(data$cat_prop_W, function(x) length(x) - 1))
      W_numbers_expanded_cats <- paste0(W_numbers_expanded, ".",
                                        unlist(W_categories_expanded))
    }
    new_variable_numbers <- c(X_numbers, W_numbers_expanded_cats)
    new_variable_names <- c("theta", paste0("q", new_variable_numbers))
    if (output_cov) {
      if (MC) {
        rownames(output$betas) <- new_variable_names
      } else {
        names(output$betas) <- new_variable_names
      }
      dimnames(output$vcov_YXW) <- list(new_variable_names, new_variable_names)
    } else {
      if (MC) {
        rownames(output) <- new_variable_names
      } else {
        names(output) <- new_variable_names
      }
    }
  }
  return(output)
}

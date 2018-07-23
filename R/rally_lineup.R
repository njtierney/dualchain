# functions
#' @export
add_evil <- function(data){
  dplyr::mutate(data, alignment = "evil")
}

#' @export
add_good <- function(data){
  dplyr::mutate(data, alignment = "good")
}

#' @export
gelman_diag_df <- function(data){
  coda::gelman.diag(data)$psrf %>%
    as.data.frame() %>%
    tibble::rownames_to_column() %>%
    janitor::clean_names() %>%
    dplyr::rename(upper_ci = upper_c_i) %>%
    tibble::as_tibble()
}

#' @export
least_converged_param <- function(data){
  gelman_diag_df(data) %>%
    dplyr::filter(point_est == max(point_est)) %>%
    dplyr::pull(rowname)
}


# -------- combine mcmc good and evil ------------------------------------------

#' @export
prepare_lineup <- function(good_data, evil_data){

  which_param_worst <- least_converged_param(evil_data)

  # cut down the samples
  good_samples <- ggmcmc::ggs(good_data) %>%
    dplyr::filter(Chain == 1, Parameter == "lambda[1]")

  # cut down the samples
  evil_samples <- ggmcmc::ggs(evil_data) %>%
    dplyr::filter(Chain == 1, Parameter == which_param_worst)

  # how many rows?
  row_size <- dplyr::n_distinct(good_samples$Iteration)
  # how many groups?
  group_size <- row_size / 10

  # generate a grouping id that counts from 1 to 10, randomly
  group_id <- sample(rep(1:10, each = group_size), row_size)

  evil_lineup <- evil_samples %>%
    dplyr::mutate(group = group_id) %>%
    add_evil() %>%
    dplyr::group_by(group) %>%
    dplyr::mutate(Iteration = 1:n()) %>%
    dplyr::ungroup()

  group_id <- sample(rep(1:10, each = group_size),row_size)

  good_lineup <- evil_samples %>%
    dplyr::mutate(group = group_id) %>%
    add_good() %>%
    dplyr::group_by(group) %>%
    dplyr::mutate(Iteration = 1:n()) %>%
    dplyr::ungroup()

  lineup_good_evil <- dplyr::bind_rows(good_lineup, evil_lineup)

  # return other diagnostic info

  evil_gr_diag <- gelman_diag_df(evil_data)
  good_gr_diag <- gelman_diag_df(good_data)

  list(lineup_good_evil = lineup_good_evil,
       evil_gr_diag = evil_gr_diag,
       good_gr_diag = good_gr_diag,
       group_size = group_size)

}

#' @export
finalise_lineup <- function(prepared_lineup_data){

  # Generate a vector of the groups
  group_ids <- 1:10

  # Identify the IDs for the good and evil groups
  good_group_id <- sample(group_ids,1)

  evil_group_id <- group_ids[-good_group_id]

  mcmc_lineup_data <- prepared_lineup_data %>%
    dplyr::filter(alignment == "good",
           group %in% good_group_id) %>%
    dplyr::bind_rows({
      prepared_lineup_data %>%
        dplyr::filter(alignment == "evil",
               group %in% evil_group_id)})

  list(mcmc_lineup_data = mcmc_lineup_data,
       good_group_id = good_group_id,
       evil_group_id = evil_group_id)

}

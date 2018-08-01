#' @export
prepare_raw_lineup <- function(good_mcmc_list,
                               evil_mcmc_list,
                               n_chain = 1){

  # shave parameters down ---------------------------------------------------
  which_param_worst <- least_converged_param(evil_mcmc_list)

  # convert to nice data frames with one parameter
  good_mcmc_list <- ggmcmc::ggs(good_mcmc_list) %>%
    dplyr::filter(Parameter == "lambda[1]") %>%
    add_good()

  # convert to nice data frames with one parameter
  evil_mcmc_list <- ggmcmc::ggs(evil_mcmc_list) %>%
    dplyr::filter(Parameter == which_param_worst) %>%
    add_evil()

  if (n_chain == 1) {
    good_mcmc_list <- dplyr::filter(good_mcmc_list, Chain == 1)
    evil_mcmc_list <- dplyr::filter(evil_mcmc_list, Chain == 1)
  }

  if (n_chain == 2) {
    good_mcmc_list <- dplyr::filter(good_mcmc_list, Chain == 1 | Chain == 2)
    evil_mcmc_list <- dplyr::filter(evil_mcmc_list, Chain == 1 | Chain == 2)
  }

  evil_lineup <- repartition_iterations(evil_mcmc_list)
  good_lineup <- repartition_iterations(good_mcmc_list)

  suppressWarnings({
  raw_lineup <- dplyr::bind_rows(good_lineup, evil_lineup)
  })

  raw_lineup

}

#'@export
add_groups_and_facets <- function(raw_lineup){
  # choose partition groups ---------------------------------------------------
  # Identify the IDs for the good and evil groups
  group_ids <- 1:10
  good_group_position_chain <- sample(1:10, size = 1)
  evil_group_position_chain <- group_ids[-good_group_position_chain]

  # choose the groups
  mcmc_lineup_data <- raw_lineup %>%
    dplyr::filter(alignment == "good",
                  chain_group %in% good_group_position_chain) %>%
    dplyr::bind_rows({
      raw_lineup %>%
        dplyr::filter(alignment == "evil",
                      chain_group %in% evil_group_position_chain)})

  # add the facet groups ------------------------------------------------------
  facet_ids <- sample(x = 1:10,
                      size = 10,
                      replace = FALSE)

  mcmc_lineup_data <- mcmc_lineup_data %>%
    dplyr::group_by(chain_group) %>%
    tidyr::nest() %>%
    dplyr::mutate(facet = facet_ids) %>%
    tidyr::unnest()

  mcmc_lineup_data

}

#' @export
experiment_factory <- function(good_mcmc,
                               bad_mcmc,
                               n_chain = 1,
                               plot_type = "trace"){

  generate_experiment <- function(good_mcmc,
                                  bad_mcmc,
                                  n_chain = 1,
                                  plot_type = "trace"){

    raw_data <- prepare_raw_lineup(good_mcmc_list = good_mcmc,
                                   evil_mcmc_list = bad_mcmc,
                                   n_chain = 1)

    data_lineup <- add_groups_and_facets(raw_data)

    lineup_solution <- retrieve_lineup_solution(data_lineup)

    plot <- mcmc_diagnostic_plot(data_lineup, plot_type = "trace")

    return(
      list(solution = lineup_solution,
           plot = plot)
    )
  }

}


# # code to generate the experimental design
# # library(tidyverse)
#
# # smart-ish example
# df <- data.frame(position_facet = 1:10) %>%
#   tidyr::expand(position_facet,
#                 position_chain = 1:10,
#                 plot_type = c("trace", "density", "autocorrelation"),
#                 n_chain = c(1, 2)) %>%
#   # would be good to parameterise glue to use all available columns
#   # somehow.
#   dplyr::mutate(path = glue::glue("experiment_figures/position_facet-\\
#                                   {position_facet}-position_chain-\\
#                                   {position_chain}-plot_type-\\
#                                   {plot_type}-n_chain-{n_chain}.svg"),
#                 hash = purrr::map_chr(path,digest::digest)) %>%
#   dplyr::mutate(experiment = rep(1:100, each = 6))
# #
# df

#' @importFrom magrittr %>%
NULL

# repartition the iterations -------------------------------------------------
# create a new Iteration group that is the sliced up pieces
repartition_iterations <- function(mcmc_df){

  # how many rows?
  row_size <- dplyr::n_distinct(mcmc_df$Iteration)
  # how many groups?
  # group_size <- row_size / 10
  chain_slice_size <- row_size / 10

  # generate a grouping id that counts from 1 to 10, to identify each group
  chain_group <- rep(1:10, each = chain_slice_size)

  mcmc_df %>%
    dplyr::mutate(chain_group = chain_group) %>%
    dplyr::group_by(chain_group) %>%
    dplyr::mutate(Iteration = 1:n()) %>%
    dplyr::ungroup()
}

retrieve_lineup_solution <- function(mcmc_lineup_data){
  mcmc_lineup_data %>%
    dplyr::select(chain_group,
                  facet,
                  alignment) %>%
    dplyr::distinct()
}

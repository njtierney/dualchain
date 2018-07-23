#' @export
gg_lineup_density <- function(data){

  lineup_info <- finalise_lineup(data)

  mcmc_lineup_data <- lineup_info$mcmc_lineup_data

  plot <-
  ggplot2::ggplot(mcmc_lineup_data,
                  ggplot2::aes(x = value)) +
    ggplot2::geom_density(fill = "black",
                          colour = "black") +
    ggplot2::facet_wrap(~group,
                        ncol = 2,
                        scales = "free_x")

  return(invisible(list(good_group_id = lineup_info$good_group_id,
                        evil_group_id = lineup_info$evil_group_id,
                        plot = plot)))
}

#' @export
gg_lineup_density_reveal <- function(data){

  lineup_info <- finalise_lineup(data)

  mcmc_lineup_data <- lineup_info$mcmc_lineup_data

  plot <-
  ggplot2::ggplot(mcmc_lineup_data,
                  ggplot2::aes(x = value)) +
    ggplot2::geom_density(ggplot2::aes(fill = alignment,
                                       colour = alignment)) +
    ggplot2::facet_wrap(~group,
                        ncol = 2,
                        scales = "free_x")

  return(invisible(list(good_group_id = lineup_info$good_group_id,
                        evil_group_id = lineup_info$evil_group_id,
                        plot = plot)))
}

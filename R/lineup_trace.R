#' @export
gg_lineup_trace <- function(data){

  lineup_info <- finalise_lineup(data)

  mcmc_lineup_data <- lineup_info$mcmc_lineup_data

  plot <-
  ggplot2::ggplot(mcmc_lineup_data,
                  ggplot2::aes(x = Iteration,
             y = value)) +
    ggplot2::geom_line() +
    ggplot2::facet_wrap(~group,
               ncol = 2,
               scales = "free_y")

  return(invisible(list(good_group_id = lineup_info$good_group_id,
                        evil_group_id = lineup_info$evil_group_id,
                        lineup_data = lineup_info,
                        plot = plot)))
}

#' @export
gg_lineup_trace_reveal <- function(data){

  lineup_info <- finalise_lineup(data)

  mcmc_lineup_data <- lineup_info$mcmc_lineup_data

  plot <-
  ggplot2::ggplot(mcmc_lineup_data,
                  ggplot2::aes(x = Iteration,
             y = value,
             colour = alignment)) +
    ggplot2::geom_line() +
    ggplot2::facet_wrap(~group,
               ncol = 2,
               scales = "free_y")

  return(invisible(list(good_group_id = lineup_info$good_group_id,
                        evil_group_id = lineup_info$evil_group_id,
                        plot = plot)))
}

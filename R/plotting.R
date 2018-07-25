gg_mcmc_trace <- function(data){

  mcmc_lineup_data <- data$mcmc_lineup_data

  plot <- ggplot2::ggplot(mcmc_lineup_data,
                          ggplot2::aes(x = Iteration,
                                       y = value)) +
    ggplot2::geom_line() +
    ggplot2::facet_wrap( ~ group,
                         ncol = 2,
                         scales = "free_y")

  return(invisible(list(good_group_id = data$good_group_id,
                        evil_group_id = data$evil_group_id,
                        plot = plot)))

}

gg_mcmc_density <- function(data){

  mcmc_lineup_data <- data$mcmc_lineup_data

  plot <- ggplot2::ggplot(mcmc_lineup_data,
                          ggplot2::aes(x = value)) +
    ggplot2::geom_density(fill = "black",
                          colour = "black") +
    ggplot2::facet_wrap(~ group,
                        ncol = 2,
                        scales = "free_x")

  return(invisible(list(good_group_id = data$good_group_id,
                        evil_group_id = data$evil_group_id,
                        plot = plot)))

}

gg_mcmc_autocor <- function(data){

  mcmc_lineup_data <- data$mcmc_lineup_data

  num_lag <- 50

  plot <- mcmc_lineup_data %>%
    dplyr::group_by(group) %>%
    dplyr::do(ggmcmc::ac(.$value, num_lag)) %>%
    ggplot2::ggplot(ggplot2::aes(x = Lag,
                                 y = Autocorrelation)) +
    ggplot2::geom_bar(stat = "identity",
                      position = "identity") +
    ggplot2::ylim(-1, 1) +
    ggplot2::facet_wrap(~group)

  return(invisible(list(good_group_id = data$good_group_id,
                        evil_group_id = data$evil_group_id,
                        plot = plot)))
}



#' @export
mcmc_diagnostic_plot <- function(data,
                                 plot_type = "trace"){
  stopifnot(plot_type == "trace" |
              plot_type == "density" | plot_type == "autcorrelation")
  if (plot_type == "trace") {
    mcmc_diagnostic_plot <- gg_mcmc_trace(data)
  }
  if (plot_type == "density") {
    mcmc_diagnostic_plot <- gg_mcmc_density(data)
  }
  if (plot_type == "autocorrelation") {
    mcmc_diagnostic_plot <- gg_mcmc_autocor(data)
  }
  return(mcmc_diagnostic_plot)
}

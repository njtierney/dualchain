gg_mcmc_trace <- function(data){

  plot <- ggplot2::ggplot(data,
                          ggplot2::aes(x = Iteration,
                                       y = value)) +
    ggplot2::geom_line() +
    ggplot2::facet_wrap( ~ facet,
                         ncol = 2,
                         scales = "free_y")

  return(invisible(plot))

}

gg_mcmc_density <- function(data){

  plot <- ggplot2::ggplot(data,
                          ggplot2::aes(x = value)) +
    ggplot2::geom_density(fill = "black",
                          colour = "black") +
    ggplot2::facet_wrap(~ facet,
                        ncol = 2,
                        scales = "free_x")

  return(invisible(plot))

}

gg_mcmc_autocor <- function(data){

  num_lag <- 50

  plot <- data %>%
    dplyr::group_by(facet) %>%
    dplyr::do(ggmcmc::ac(.$value, num_lag)) %>%
    ggplot2::ggplot(ggplot2::aes(x = Lag,
                                 y = Autocorrelation)) +
    ggplot2::geom_bar(stat = "identity",
                      position = "identity") +
    ggplot2::ylim(-1, 1) +
    ggplot2::facet_wrap(~facet)

  return(invisible(plot))
}



#' @export
mcmc_diagnostic_plot <- function(data,
                                 plot_type = "trace"){
  stopifnot(plot_type == "trace" |
              plot_type == "density" | plot_type == "autcor")
  if (plot_type == "trace") {
    mcmc_diagnostic_plot <- gg_mcmc_trace(data)
  }
  if (plot_type == "density") {
    mcmc_diagnostic_plot <- gg_mcmc_density(data)
  }
  if (plot_type == "autocor") {
    mcmc_diagnostic_plot <- gg_mcmc_autocor(data)
  }
  return(mcmc_diagnostic_plot)
}

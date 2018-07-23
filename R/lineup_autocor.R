gg_lineup_autocorrelation <- function(data){
  
  lineup_info <- finalise_lineup(data)
  
  mcmc_lineup_data <- lineup_info$mcmc_lineup_data
  
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
  
  return(invisible(list(good_group_id = lineup_info$good_group_id,
                        evil_group_id = lineup_info$evil_group_id,
                        plot = plot,
                        lineup_data = lineup_info)))
}

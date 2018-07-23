
# re-create the visualisation for the evil and the good traceplots

recreate_lineup_data <- function(data, real_id){
  
  group_ids <- 1:10
  good_group_id <- real_id
  evil_group_id <- group_ids[-good_group_id]
  
  # mcmc_lineup_data <- data %>%
  mcmc_lineup_data <- data %>%
  dplyr::filter(alignment == "good",
                group %in% good_group_id) %>%
  dplyr::bind_rows({
    data %>%
      dplyr::filter(alignment == "evil",
                    group %in% evil_group_id)})
  
  mcmc_lineup_data

}

recreate_lineup_trace <- function(data, reveal = FALSE){
  
  if (reveal == FALSE) {
    ggplot2::ggplot(data,
                    ggplot2::aes(x = Iteration,
                                 y = value)) +
    ggplot2::geom_line() +
    ggplot2::facet_wrap(~group,
                        ncol = 2,
                        scales = "free_y")
  } else if (reveal == TRUE){
    ggplot2::ggplot(data,
                    ggplot2::aes(x = Iteration,
                                 y = value,
                                 colour = alignment)) +
      ggplot2::geom_line() +
      ggplot2::facet_wrap(~group,
                          ncol = 2,
                          scales = "free_y")
  }
}

recreate_lineup_density <- function(data, reveal = FALSE){
  
  if(reveal == FALSE){
      ggplot2::ggplot(mcmc_lineup_data,
                      ggplot2::aes(x = value)) +
      ggplot2::geom_density(fill = "black",
                            colour = "black") +
      ggplot2::facet_wrap(~group,
                          ncol = 2,
                          scales = "free_x")
  } else if (reveal == TRUE){
      ggplot2::ggplot(mcmc_lineup_data,
                      ggplot2::aes(x = value,
                                   colour = alignment,
                                   fill = alignment)) +
      ggplot2::geom_density() +
      ggplot2::facet_wrap(~group,
                          ncol = 2,
                          scales = "free_x")
  }
}



# example usage

# dat_one_sample <- read_csv("shiny/responses/1510612844_2266d58e93ee580d39b9e87692392083.csv")
# 
# pre_lineup<- readr::read_rds(here("shiny/www/data/pre_lineup_60_plus_10.rds"))
# 
# recreate_lineup_data(data = pre_lineup$lineup_good_evil,
#                      real_id = dat_one_sample$trace_real) %>%
#   recreate_lineup_trace()
# 
# recreate_lineup_data(data = pre_lineup$lineup_good_evil,
#                      real_id = dat_one_sample$trace_real) %>%
#   recreate_lineup_trace(reveal = TRUE)
#   
# recreate_lineup_data(data = pre_lineup$lineup_good_evil,
#                      real_id = dat_one_sample$trace_real) %>%
#   recreate_lineup_density()
# 
# recreate_lineup_data(data = pre_lineup$lineup_good_evil,
#                      real_id = dat_one_sample$trace_real) %>%
#   recreate_lineup_density(reveal = TRUE)
#   

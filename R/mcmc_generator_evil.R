mcmc_generator_evil <- function(max_mixtures,
                                burn_in,
                                samples,
                                extra_sample){
  
  eyes <- list(y = c(529.0, 530.0, 532.0, 533.1, 533.4, 533.6, 533.7, 534.1,
                     534.8, 535.3, 535.4, 535.9, 536.1, 536.3, 536.4, 536.6,
                     537.0, 537.4, 537.5, 538.3, 538.5, 538.6, 539.4, 539.6,
                     540.4, 540.8, 542.0, 542.8, 543.0, 543.5, 543.8, 543.9,
                     545.3, 546.2, 548.8, 548.7, 548.9, 549.0, 549.4, 549.9,
                     550.6, 551.2, 551.4, 551.5, 551.6, 552.8, 552.9,553.2),
               N = 48,
               T = c(1, NA, NA, NA, NA, NA, NA, NA, NA, NA,
                     NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,
                     NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,
                     NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,
                     NA, NA, NA, NA, NA, NA, NA, NA))
  
  # eyes$maxT <- 5
  eyes$maxT <- max_mixtures
  eyes$alpha <- rep(1, eyes$maxT)
  eyes$T[eyes$N] <- eyes$maxT
  
  model <- "
  model
  {
  for( i in 1 : N ) {
  y[i] ~ dnorm(mu[i], tau)
  mu[i] <- lambda[T[i]]
  T[i] ~ dcat(P[])
  }
  P[1:maxT] ~ ddirch(alpha[])
  
  lambda[1] ~ dnorm(0.0, 1.0E-6)
  
  for (j in 2:maxT){
  lambda[j] <- lambda[j-1] + 0*theta[j-1]
  theta[j-1] ~ dnorm(0.0, 1.0E-6)I(0.0, )
  }
  
  tau ~ dgamma(0.001, 0.001) sigma <- 1 / sqrt(tau)
  }
  "
  
  model_eyes <- rjags::jags.model(file = textConnection(model),
                                  data = eyes,
                                  n.chains = 3)
  
  burn_eyes <- rjags::jags.samples(model = model_eyes,
                                   variable.names = "lambda",
                                   n.iter = burn_in)
  
  sample_eyes <- rjags::coda.samples(model_eyes,
                                     "lambda",
                                     n.iter = samples)
  extra_eyes <- rjags::coda.samples(model_eyes,
                                    "lambda",
                                    n.iter = extra_sample)
  
  list(max_mixtures = max_mixtures,
       sample_eyes = sample_eyes,
       extra_eyes = extra_eyes)
}

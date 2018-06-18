#input golf putting data from Gelman 19.4.2 & 21.7.5

Distance <- 2:20
mi <- c(1443, 694, 455, 353, 272, 256, 240, 217, 200, 237, 202, 192, 174, 167, 201, 194, 191, 147, 152)
yi <- c(1346, 577, 337, 208, 149, 136, 111, 69, 67, 75, 52, 46, 54, 28, 27, 31, 33, 20, 24)
pi = yi/mi
ind = numeric(length(Distance))
ind[pi>=.5] = 1

#functions to go between log odds and probabilities
logit <- function(p) log(p/(1-p))
invlogit <- function(x) 1/(1+exp(-x))

#basic plots of prob(success) vs distance and log odds p(success)
plot(Distance, logit(yi/mi))
plot(Distance, yi/mi)

library(rstan)
library(bayesplot)
library(ggplot2)

options(mc.cores = parallel::detectCores())
rstan_options(auto_write = TRUE)

#put data into a list for stan
data.in <- list(x=Distance, y=ind, n=length(ind), scale_a = 10, scale_b = 2.5, use_y_rep = T, use_log_lik = T)

###run first model: 
###nonlinear model w/ binomial likelihood

fm1 <- stan(
  file = "golf.stan",     # Stan program
  data = data.in,    # named list of data
  chains = 4,             # number of Markov chains
  warmup = 1000,          # number of warmup iterations per chain
  iter = 2000,            # total number of iterations per chain
  cores = 2,              # number of cores (using 2 just for the vignette)
  refresh = 1000          # show progress every 'refresh' iterations
  )

#save predictions from model & compare density of true probs to predicted
#to assess fit
print(fm1, pars=c("a","b"), digits=4)
fm1_info = extract(fm1)
yrep = as.matrix(fm1_info[[4]])
y = pi
ppc_dens_overlay(y, yrep[1:200,])


###fit second model:
###gaussian process with binomial likelihood

data.in2 = list(x = Distance, y = ind, n = length(ind), use_y_rep = T)

fm2 <- stan(
  file = "golf2.stan",     # Stan program
  data = data.in2,    # named list of data
  chains = 4,             # number of Markov chains
  warmup = 1000,          # number of warmup iterations per chain
  iter = 2000,            # total number of iterations per chain
  cores = 2,              # number of cores (using 2 just for the vignette)
  refresh = 1000          # show progress every 'refresh' iterations
)

#get predictions, plot predicted & actual densities to assess fit
print(fm2, pars=c("a","b"), digits=4)
fm2_info = extract(fm2)
yrep2 = as.matrix(fm2_info[[5]])
y = pi
ppc_dens_overlay(y, yrep2[1:200,])

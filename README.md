# bayesian-models
simple bayesian nonlinear models for golf data from gelman.
data consists of distance, successes and trials for 19 distances from a hole in a game of golf.
(probability of success at each distance is calculated p = y/m & turned into an indicator (1 if p>=.5, 0 if p<.5)

Model 1 (Gelman 19.4.2)
nonlinear with binomial likelihood to predict success from distance


Model 2 (Gelman 21.7.5)
gaussian process with binomial likelihood to predict success from distance

# files

golf.R: contains code to access data, import appropriate libraries, and run Stan models. also graphs densities of posterior predictions against the actual probabilties of success

golf.stan: stan file containing variables, prior distributions, transformations, model, posterior simulations & posterior likelihoods for Model 1.

golf2.stan: stan file containing variables, prior distributions, transformations, model, posterior simulations & posterior likelihoods for Model 2.

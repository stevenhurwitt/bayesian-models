data{
  int n;
  vector[n] x;
  int y[n];
  int use_y_rep;
  int use_log_lik;
  real scale_a;
  real scale_b;
}

parameters{
  real<lower=0> a;
  real b;
}

transformed parameters{
  real eta[n];
  for (i in 1:n){
    eta[i] = (b*x[i]) + a;
  }
    
}

model {
  // priors
  a ~ normal(0., scale_a);
  b ~ normal(0., scale_b);
  // likelihood
y ~ bernoulli_logit(eta);
}
generated quantities {
  // simulate data from the posterior
  vector[n * use_y_rep] y_rep;
  // log-likelihood posterior
  vector[n * use_log_lik] log_lik;
  
  for (i in 1:num_elements(y_rep)) {
    y_rep[i] = inv_logit(eta[i]);
  }
  
  for (i in 1:num_elements(log_lik)) {
    log_lik[i] = bernoulli_logit_lpmf(y[i] | eta[i]);
  }
}

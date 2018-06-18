data {
  int<lower=1> n;
  real x[n];
  int<lower=0, upper=1> y[n];
  int use_y_rep;
}
transformed data {
  real delta = 1e-9;
}
parameters {
  real<lower=0> rho;
  real<lower=0> alpha;
  real a;
  vector[n] eta;
}
model {
  vector[n] f;
  {
    matrix[n, n] L_K;
    matrix[n, n] K = cov_exp_quad(x, alpha, rho);
  
    // diagonal elements
    for (i in 1:n)
      K[i, i] = K[i, i] + delta;
    
    L_K = cholesky_decompose(K);
    f = L_K * eta;
  }
  
  rho ~ inv_gamma(5, 5);
  alpha ~ normal(0, 1);
  a ~ normal(0, 1);
  eta ~ normal(0, 1);

  y ~ bernoulli_logit(a + f);
}
generated quantities {
  // simulate data from the posterior
  vector[n * use_y_rep] y_rep;
  vector[n * use_y_rep] raw;

  for (i in 1:num_elements(y_rep)) {
    y_rep[i] = inv_logit(y[i]);
    raw[i] = y[i];
  }
  
  
}

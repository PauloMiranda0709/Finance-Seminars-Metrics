% get TV arrays
% do this for d=1

targetvariance2 = 1.4*rv5;

targetvariance1 = returns.^2;

h = 21;

targetvar2h = zeros(6062-h, 1);
for i = 1:6062-h
    targetvar2h(i) = sum(targetvariance2(i+1:i+h));
end

targetvar1h = zeros(6062-h, 1);
for i = 1:6062-h
    targetvar1h(i) = sum(targetvariance1(i+1:i+h));
end

sigmasquaredh = sigmasquared(2:6062-h+1);
%instead of sigmasquared(1, 6062-h)

averagesigmasquared = omega_hat/(1- beta_hat - alpha_hat_1/2 - alpha_hat_2/2);

pvol = h*(mu_hat^2+averagesigmasquared) + (1-(alpha_hat_1/2+alpha_hat_2/2+beta_hat)^h)/(1-alpha_hat_1/2-alpha_hat_2/2-beta_hat)*(sigmasquaredh-averagesigmasquared);

% Fit a linear regression model
mdl1 = fitlm(pvol, targetvar1h);

mdl2 = fitlm(pvol, targetvar2h);


% Display the regression model summary
disp(mdl1);

disp(mdl2);

% Get the estimated coefficients
coeffs = mdl1.Coefficients.Estimate;

% Get the covariance matrix of the estimated coefficients
cov_b = mdl1.CoefficientCovariance;

% Test for Intercept (alpha)
alpha = coeffs(1);
alpha_var = cov_b(1, 1);
W_alpha = (alpha - 0)^2 / alpha_var;

% Test for Slope (beta)
beta = coeffs(2);
beta_var = cov_b(2, 2);
W_beta = (beta - 1)^2 / beta_var;

% Degrees of freedom
df = 1;

% Compute p-values
p_alpha = 1 - chi2cdf(W_alpha, df);
p_beta = 1 - chi2cdf(W_beta, df);

% Display results
fprintf('Wald Test for Intercept (alpha):\n');
fprintf('Wald Statistic: %.4f\n', W_alpha);
fprintf('p-value: %.4f\n\n', p_alpha);

fprintf('Wald Test for Slope (beta):\n');
fprintf('Wald Statistic: %.4f\n', W_beta);
fprintf('p-value: %.4f\n', p_beta);
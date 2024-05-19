h = 1;
pvol = zeros(6062-h, 1);

lambdas = log(sigmas);


targetvariance2 = 1.4*rv5;

targetvariance1 = returns.^2;

targetvar2h = zeros(6062-h, 1);
for i = 1:6062-h
    targetvar2h(i) = sum(targetvariance2(i+1:i+h));
end

targetvar1h = zeros(6062-h, 1);
for i = 1:6062-h
    targetvar1h(i) = sum(targetvariance1(i+1:i+h));
end

for t=1:6062-h
    sum_pvol = 0;
    for d = 1:h
        sum_pvol = sum_pvol + exp(2*lambda_hat+2*phi_hat^(d-1)*(lambdas(t+1,1)-lambda_hat)+2*(kappa_hat^2+kappa_tilde_hat^2)*(1-phi_hat^(2*(d-1)))/(1-phi_hat^2));
    end
    pvol(t,1) = h*mu_hat^2 + sum_pvol;
end

% Fit a linear regression model
mdl1 = fitlm(pvol, targetvar1h);

mdl2 = fitlm(pvol, targetvar2h);

% Display the regression model summary
disp(mdl1);

disp(mdl2);

% Get the estimated coefficients
coeffs_1 = mdl1.Coefficients.Estimate;

% Get the covariance matrix of the estimated coefficients
cov_b_1 = mdl1.CoefficientCovariance;

% Test for Intercept (alpha)
alpha_1 = coeffs_1(1);
alpha_var_1 = cov_b_1(1, 1);
W_alpha_1 = (alpha_1 - 0)^2 / alpha_var_1;

% Test for Slope (beta)
beta_1 = coeffs_1(2);
beta_var_1 = cov_b_1(2, 2);
W_beta_1 = (beta_1 - 1)^2 / beta_var_1;

% Degrees of freedom
df = 1;

% Compute p-values
p_alpha_1 = 1 - chi2cdf(W_alpha_1, df);
p_beta_1 = 1 - chi2cdf(W_beta_1, df);

% Display results
fprintf('Wald Test for Intercept (alpha):\n');
fprintf('Wald Statistic: %.4f\n', W_alpha_1);
fprintf('p-value: %.4f\n\n', p_alpha_1);

fprintf('Wald Test for Slope (beta):\n');
fprintf('Wald Statistic: %.4f\n', W_beta_1);
fprintf('p-value: %.4f\n', p_beta_1);
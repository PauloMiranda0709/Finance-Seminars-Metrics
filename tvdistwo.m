h = 21;
pvol = zeros(6062-h, 1);

targetvariance = 1.4*rv5;
lambdas = log(sigmas);

targetvarh = zeros(6062-h, 1);
for i = 1:6062-h
    targetvarh(i) = sum(targetvariance(i:i+h));
end

for t=1:6062-h
    sum_pvol = 0;
    for d = 1:h
        sum_pvol = sum_pvol + exp(2*lambda_hat+2*phi_hat^(d-1)*(lambdas(t+1,1)-lambda_hat)+2*(kappa_hat^2+kappa_tilde_hat^2)*(1-phi_hat^(2*(d-1)))/(1-phi_hat^2));
    end
    pvol(t,1) = h*mu_hat^2 + sum_pvol;
end

% Fit a linear regression model
mdl = fitlm(pvol, targetvarh);

% Display the regression model summary
disp(mdl);

% Extract statistics
rsquared = mdl.Rsquared.Ordinary;  % R-squared value
pValues = mdl.Coefficients.pValue;  % P-values for the coefficients

fprintf('R-squared: %.2f\n', rsquared);

% Plotting the data and regression line with confidence intervals
plot(mdl);  % This automatically plots data, regression line, and confidence intervals
xlabel('sigmasquared');
ylabel('squaredretsdaily');
title('Linear Regression with fitlm');
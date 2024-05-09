% get TV arrays
% do this for d=1

targetvariance = 1.4*rv5;


h = 1;

targetvarh = zeros(6062-h, 1);
for i = 1:6062-h
    targetvarh(i) = sum(targetvariance(i:i+h));
end



sigmasquaredh = sigmasquared(1:6062-h);

averagesigmasquared = omega_hat/(1- beta_hat - alpha_hat_1/2 - alpha_hat_2/2);

pvol = h*(mu_hat^2+averagesigmasquared) + (1-(alpha_hat_1/2+alpha_hat_2/2+beta_hat)^h)/(1-alpha_hat_1/2-alpha_hat_2/2-beta_hat)*(sigmasquaredh-averagesigmasquared);

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
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

% Extract statistics


% Plotting the data and regression line with confidence intervals
plot(mdl);  % This automatically plots data, regression line, and confidence intervals
xlabel('sigmasquared');
ylabel('squaredretsdaily');
title('Linear Regression with fitlm');
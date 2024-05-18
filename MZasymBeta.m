h = 21;
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

% Plotting the data and regression line with confidence intervals
plot(mdl1);  % This automatically plots data, regression line, and confidence intervals
xlabel('sigmasquared');
ylabel('squaredretsdaily');
title('Linear Regression with fitlm');
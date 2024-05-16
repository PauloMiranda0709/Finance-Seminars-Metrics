%% Out of sample predictions
clear
close all
% import data and get it into correct format
load('data')
dates_str = cellstr(num2str(dates));
dates     = datetime(dates_str, 'InputFormat', 'yyyyMMdd');
split = 0.8;
split_date = round(size(rv5,1)*split);
split_date = int64(split_date);

train_rv5 = rv5(1:split_date);
train_rvc = returns(1:split_date);
test_rv5 = rv5(split_date:end);
test_rvc = returns (split_date:end);

format short
clear  NegativeLogLikelihood_GARCH
%% asymmetric GARCH
% startingvalues = [mu,sigma2,alpha1,aplha2,beta,nu]
startingvalues=[mean(returns);var(returns)/20;0.10;0.10;0.88;6];
[mu_hat_GARCH, omega_hat, alpha_hat_1, alpha_hat_2, beta_hat, nu_hat_GARCH, sigmasquared, epsilon_GARCH, NIC_GARCH, NegativeLogLikelihood1_GARCH] = doAsymGARCH(startingvalues,train_rvc);

%% asymmetric Beta_t_EGARCH
% startingvalues = [mu,lambda,phi,kappa,kappa_tilde, nu]
startingvalues=[mean(returns);log(var(returns));0.40;0.88;0.88;6]; 
[mu_hat_EGARCH,lambda_hat,phi_hat,kappa_hat,kappa_tilde_hat,nu_hat_EGARCH,sigmas,u,v,lambdas,NegativeLogLikelihood1_EGARCH,epsilon_EGARCH, NIC_EGARCH,AIC,BIC] = doAsymBetatEGARCH(startingvalues,train_rvc);

%% Predictions
d = 5;

% GARCH
[Pvol_GARCH] = predictGARCH(sigmasquared,mu_hat_GARCH,omega_hat,alpha_hat_1,alpha_hat_2,beta_hat,d);
% Pvol_t
Pvol_GARCH_t = Pvol_GARCH(end);

% EGARCH
[Pvol_EGARCH] = predictEGARCH(sigmas,mu_hat_EGARCH,lambda_hat,phi_hat,kappa_hat,kappa_tilde_hat,d);
Pvol_EGARCH_t = Pvol_EGARCH(end);

%% Actual volatilities
% using rvc
rvc1 = test_rvc(1);
rvc5 = sum(test_rvc(1:5));
rvc21 = sum(test_rvc(1:21));

% using rv5
rv5_1 = 1.4 * test_rv5(1);
rv5_5 = 1.4 * sum(test_rv5(1:5));
rv5_21 = 1.4 * sum(test_rv5(1:21));
%% Benchmarks
% VIX
Pvol_VIX = d/250*vix.^2;
Pvol_VIX_t = Pvol_VIX(split_date+1);
% HAR-RV
[Pvol_HAR_RV_ctcr, Pvol_HAR_RV_rv5] = doHARRV(train_rvc, test_rvc, train_rv5, test_rv5,rv5, d);
Pvol_HAR_RV_rv5_t = Pvol_HAR_RV_rv5(1);
%% Plots

% Plot the predicted volatility for GARCH
figure
plot(Pvol_GARCH);

% Add labels to the plot
xlabel('Index');
ylabel('Value');
title('Plot of GARCH predictions');


% Plot the predicted volatility for Beta-t-EGARCH
figure
plot(Pvol_EGARCH);

% Add labels to the plot
xlabel('Index');
ylabel('Value');
title('Plot of Beta-t-EGARCH predictions');

% Plot the predicted volatility for VIX
figure
plot(Pvol_VIX);

% Add labels to the plot
xlabel('Index');
ylabel('Value');
title('Plot of VIX predictions');

% Plot the predicted volatility for HAR-RV
figure
plot(Pvol_HAR_RV_rv5);

% Add labels to the plot
xlabel('Index');
ylabel('Value');
title('Plot of HAR-RV predictions');
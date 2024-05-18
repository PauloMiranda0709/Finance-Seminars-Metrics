%% Rolling window
function [Pvol_GARCH, Pvol_EGARCH, Pvol_VIX, Pvol_HARRV] = doRollingWindow(train_data, test_data, vix, split_date, category, d)
%% asymmetric GARCH
% startingvalues = [mu,sigma2,alpha1,aplha2,beta,nu]
startingvalues=[mean(train_data);var(train_data)/20;0.10;0.10;0.88;6];
[mu_hat_GARCH, omega_hat, alpha_hat_1, alpha_hat_2, beta_hat, ~, sigmasquared, ~, ~, ~] = doAsymGARCH(startingvalues,train_data);

%% asymmetric Beta_t_EGARCH
% startingvalues = [mu,lambda,phi,kappa,kappa_tilde, nu]
startingvalues=[mean(train_data);log(var(train_data));0.40;0.88;0.88;6]; 
[mu_hat_EGARCH,lambda_hat,phi_hat,kappa_hat,kappa_tilde_hat,~,sigmas,~,~,~,~,~, ~,~,~] = doAsymBetatEGARCH(startingvalues,train_data);

%% Predictions

% GARCH
[Pvol_GARCH] = predictGARCH(sigmasquared,mu_hat_GARCH,omega_hat,alpha_hat_1,alpha_hat_2,beta_hat,d);

% EGARCH
[Pvol_EGARCH] = predictEGARCH(sigmas,mu_hat_EGARCH,lambda_hat,phi_hat,kappa_hat,kappa_tilde_hat,d);
%% Benchmarks
% VIX
Pvol_VIX = d/250*vix(split_date)^2;
% HAR-RV
[Pvol_HARRV] = doHARRV(train_data, test_data,category, d);
end

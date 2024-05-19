function [mu_hat, lambda_hat, phi_hat, kappa_hat, kappa_tilde_hat, eta1_hat, eta2_hat, nu1_hat, nu2_hat, alpha_hat, epsilon_GARCH, NegativeLogLikelihood1, NIC_GARCH, AIC, BIC] = doAsymBetaGenTEGARCH(returns)
%Beta-t-EGARCH symmetric
%% Clear all data 
clear
close all
%% Estimate Beta-Gen-t-EGARCH model
format short
clear  NegativeLogLikelihood_GenBetaTEGARCH
%% Set starting values for the optimisation and check value of the objective

% Starting values
% startingvalues = [mu,lambda,phi,kappa, kappa_tilde, eta1, eta2, nu1, nu2, alpha]
startingvalues=[mean(returns); log(var(returns)); 0.40; 0.88; 1; 1; 1; 1; 1; 0.5]; 

% Get the negative log likelihood at the starting values (the optimiser
% should beat this!) 
NegativeLogLikelihood_GenBetaTEGARCH(startingvalues, returns)

%% Clear any pre-existing options
clearvars options

% Load some options (no need to change this)
options  =  optimset('fmincon');
options  =  optimset(options , 'TolFun'      , 1e-6);
options  =  optimset(options , 'TolX'        , 1e-6);
options  =  optimset(options , 'Display'     , 'on');
options  =  optimset(options , 'Diagnostics' , 'on');
options  =  optimset(options , 'LargeScale'  , 'off');
options  =  optimset(options , 'MaxFunEvals' , 10^6) ;
options  =  optimset(options , 'MaxIter'     , 10^6) ;

%% Parameter lower bound and upper bound
% parameter = [mu, lambda, phi, kappa, kappa_tilde, eta1, eta2, nu1, nu2, alpha]
lowerbound = [-inf,-inf,-1,-inf, -inf, 0, 0, 0, 0, 0]; % mu, lambda can be anything,  should be positve, we want nu>2
upperbound = [inf, inf, 1, inf, inf, inf, inf, inf, inf, 1]; % upper bound for nu is 40, which is high enough to resemble a normal distribution

%% Do the actual optimisation (this should be very fast, less than a second)
tic
[ML_parameters, NegativeLogLikelihood1] = fmincon('NegativeLogLikelihood_GenBetaTEGARCH', startingvalues ,[],[],[],[],lowerbound,upperbound,[],options,returns)
toc

%% Save the parameters and compute GARCH filter at these parameters

mu_hat           = ML_parameters(1);
lambda_hat       = ML_parameters(2);
phi_hat          = ML_parameters(3);
kappa_hat        = ML_parameters(4);
kappa_tilde_hat  = ML_parameters(5);
eta1_hat         = ML_parameters(6);
eta2_hat         = ML_parameters(7);
nu1_hat          = ML_parameters(8);
nu2_hat          = ML_parameters(9);
alpha_hat        = ML_parameters(10);
[sigmas, u, v]   = Filter_GenBetaTEGARCH(mu_hat, lambda_hat, phi_hat, kappa_hat, kappa_tilde_hat, eta1_hat, eta2_hat, nu1_hat, nu2_hat, alpha_hat, returns);

%% Compute news impact function for GARCH
epsilon_GARCH   = (returns - mu_hat) ./ sigmas;
NIC_GARCH       = kappa_hat*2*u+2*kappa_tilde_hat*v;
%% Check that the implied shocks have approximately the desired characteristics (mean zero, variance one)
disp([mean(epsilon_GARCH);var(epsilon_GARCH)])
% should be roughly [0;1]

%%Calculate AIC and BIC
[AIC, BIC] = informationCriterions(size(ML_parameters,1), size(returns,1), NegativeLogLikelihood1);
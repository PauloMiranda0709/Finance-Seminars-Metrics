function [mu_hat, omega_hat, alpha_hat_1, alpha_hat_2, beta_hat, nu_hat, sigmasquared, epsilon_GARCH, NIC_GARCH, NegativeLogLikelihood1] = doAsymGARCH(startingvalues, returns)

format short
clear  NegativeLogLikelihood_GARCH
NegativeLogLikelihood_GARCH(startingvalues,returns)

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
% parameter = [mu,omega,alpha,beta,nu]
lowerbound = [-inf,0,0,0,0,2]; % mu can be anything, omega, alpha, beta should be positve, we want nu>2
upperbound = [inf,inf,inf,inf,inf,40]; % upper bound for nu is 40, which is high enough to resemble a normal distribution

%% Do the actual optimisation (this should be very fast, less than a second)
tic
[ML_parameters,NegativeLogLikelihood1]=fmincon('NegativeLogLikelihood_GARCH', startingvalues ,[],[],[],[],lowerbound,upperbound,[],options,returns);
toc

%% Save the parameters and compute GARCH filter at these parameters

mu_hat           = ML_parameters(1);
omega_hat        = ML_parameters(2);
alpha_hat_1      = ML_parameters(3);
alpha_hat_2      = ML_parameters(4);
beta_hat         = ML_parameters(5);
nu_hat           = ML_parameters(6);
[sigmasquared]   = Filter_GARCH(mu_hat,omega_hat,alpha_hat_1,alpha_hat_2,beta_hat,returns);
%% Compute news impact function for GARCH
epsilon_GARCH   = ( returns - mu_hat ) ./ sqrt(sigmasquared);
% Define the condition (for example, elements greater than 3)
condition = epsilon_GARCH > 0;

% Create the indicator function
indicator_function = condition;

NIC_GARCH       = alpha_hat_1 * (epsilon_GARCH.^2 .* (1-indicator_function)-(1/2)) + alpha_hat_2 * (epsilon_GARCH.^2 .* (1-indicator_function)-(1/2));
end
function [mu_hat,lambda_hat,phi_hat,kappa_hat,kappa_tilde_hat,nu_hat,sigmas,u,v,lambdas,NegativeLogLikelihood1,epsilon_EGARCH, NIC_EGARCH,AIC,BIC] = doAsymBetatEGARCH(startingvalues, returns)

format short
clear  NegativeLogLikelihood_GARCH
NegativeLogLikelihood_BetaGARCH(startingvalues,returns)

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
% parameter = [mu,lambda,phi,kappa,kappa_tilde,nu]
lowerbound = [-inf,-inf,-1,-inf,-inf,2]; % mu, lambda can be anything,  should be positve, we want nu>2
upperbound = [inf,inf,1,inf,inf,40]; % upper bound for nu is 40, which is high enough to resemble a normal distribution

%% Do the actual optimisation (this should be very fast, less than a second)
tic
[ML_parameters,NegativeLogLikelihood1]=fmincon('NegativeLogLikelihood_BetaGARCH', startingvalues ,[],[],[],[],lowerbound,upperbound,[],options,returns);
toc

%% Save the parameters and compute GARCH filter at these parameters

mu_hat           = ML_parameters(1);
lambda_hat       = ML_parameters(2);
phi_hat          = ML_parameters(3);
kappa_hat        = ML_parameters(4);
kappa_tilde_hat  = ML_parameters(5);
nu_hat           = ML_parameters(6);
[sigmas, u, v, lambdas]   = Filter_BetaGARCH(mu_hat,lambda_hat,phi_hat,kappa_hat,kappa_tilde_hat, nu_hat,returns);
%% Compute news impact function for GARCH
epsilon_EGARCH   = ( returns - mu_hat ) ./ sigmas;
NIC_EGARCH       = kappa_hat*2*u+2*kappa_tilde_hat*v;
%% AIC & BIC
[AIC, BIC] = informationCriterions(size(ML_parameters,1), size(returns,1), NegativeLogLikelihood1);
end
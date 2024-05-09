%Negative log likelihood
function [negativeLL]=NegativeLogLikelihood_BetaGARCH(parameter_vector,returns)
 % Extract the stuff we need from the input arguments
    mu          = parameter_vector(1,1);
    lambda      = parameter_vector(2,1);
    phi         = parameter_vector(3,1);
    kappa       = parameter_vector(4,1);
    kappa_tilde = parameter_vector(5,1);
    nu          = parameter_vector(6,1);
    %T          = size(returns,1);

    % Run the GARCH filter
    [ sigmas ] = Filter_BetaGARCH(mu,lambda,phi,kappa,kappa_tilde,nu,returns);

    % Collect the log likelihoods of each observation 
    epsilon = (returns-mu)./sigmas;
    LL      = - log(sigmas)  + log(studentpdf(epsilon,nu) ); 
    % see equation (4.2) in case study

    % Put a negative sign in front and sum over all obserations
    negativeLL = - sum( LL )  ;

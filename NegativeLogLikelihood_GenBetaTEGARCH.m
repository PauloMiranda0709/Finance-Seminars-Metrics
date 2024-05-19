%Negative log likelihood
function [negativeLL]=NegativeLogLikelihood_GenBetaTEGARCH(parameter_vector,returns)
 % Extract the stuff we need from the input arguments
    mu          = parameter_vector(1,1);
    lambda      = parameter_vector(2,1);
    phi         = parameter_vector(3,1);
    kappa       = parameter_vector(4,1);
    kappa_tilde = parameter_vector(5,1);
    eta1        = parameter_vector(6,1);
    eta2        = parameter_vector(7,1);
    nu1         = parameter_vector(8,1);
    nu2         = parameter_vector(9,1);
    alpha       = parameter_vector(10,1);
    %T          = size(returns,1);

    % Run the GARCH filter
    [ sigmas ] = Filter_GenBetaTEGARCH(mu , lambda, phi, kappa, kappa_tilde, eta1, eta2, nu1, nu2, alpha, returns);

    % Collect the log likelihoods of each observation 
    LL      = log(generalizedtpdf(returns, sigmas, mu, eta1, eta2, nu1, nu2, alpha)); 
    % see equation (4.2) in case study

    % Put a negative sign in front and sum over all obserations
    negativeLL = - sum( LL );

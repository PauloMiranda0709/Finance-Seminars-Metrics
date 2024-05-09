function [negativeLL]=NegativeLogLikelihood_GARCH(parameter_vector,returns)
if size(parameter_vector,1) == 5 
    % Extract the stuff we need from the input arguments
    mu        = parameter_vector(1,1);
    omega     = parameter_vector(2,1);
    alpha     = parameter_vector(3,1);
    beta      = parameter_vector(4,1);
    nu        = parameter_vector(5,1);
    %T        = size(returns,1);

    % Run the GARCH filter
    [ sigmasquared ] = Filter_GARCH(mu,omega,alpha,beta,returns);

    % Collect the log likelihoods of each observation 
    epsilon = (returns-mu)./sqrt(sigmasquared);
    LL      = - log(sqrt(sigmasquared))  + log(studentpdf( epsilon,nu) ); 
    % see equation (4.2) in case study

    % Put a negative sign in front and sum over all obserations
    negativeLL = - sum( LL )  ;
elseif size(parameter_vector,1) == 6 
    % Extract the stuff we need from the input arguments
    mu        = parameter_vector(1,1);
    omega     = parameter_vector(2,1);
    alpha1    = parameter_vector(3,1);
    alpha2    = parameter_vector(4,1);
    beta      = parameter_vector(5,1);
    nu        = parameter_vector(6,1);
    %T         = size(returns,1);

    % Run the GARCH filter
    [ sigmasquared ] = Filter_GARCH(mu,omega,alpha1,alpha2,beta,returns);

    % Collect the log likelihoods of each observation 
    epsilon = (returns-mu)./sqrt(sigmasquared);
    LL      = - log(sqrt(sigmasquared))  + log(studentpdf(epsilon,nu) ); 
    % see equation (4.2) in case study

    % Put a negative sign in front and sum over all obserations
    negativeLL = - sum( LL )  ;

% Close the function
end
end


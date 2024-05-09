function [sigmas, u, v] = Filter_BetaGARCH(mu,lambda,phi,kappa,kappa_tilde, nu,returns)
    % Extract the sample size (make sure returns are a column vector)
    T = size(returns,1);
    % Prefill the variable that we are going to track
    sigmas = zeros(T,1);
    u = zeros(T,1);
    v = zeros(T,1);
    epsilon = zeros(T,1);
    % Define sigmabarsquared 
    averagesigma = exp(lambda);
    % Run the GARCH filter
    for t=1:T
        if t==1
            % Initialise at the unconditional mean of sigmasquared
            sigmas(t,1) = averagesigma;
        else
            epsilon(t-1,1) = (returns(t-1,1)-mu)/sigmas(t-1,1);
            u(t-1,1) = sqrt(nu+3)/sqrt(2*nu)*(((nu+1)/(nu-2+epsilon(t-1,1)^2)*epsilon(t-1,1)^2)-1);
            v(t-1,1) = sqrt((nu-2)*(nu+3)/(nu*(nu+1)))*(nu+1)/(nu-2+epsilon(t-1,1)^2)*epsilon(t-1,1);
            lambda_t = lambda*(1-phi)+phi*log(sigmas(t-1,1))+kappa*u(t-1,1)+kappa_tilde*v(t-1,1);
            sigmas(t,1) = exp(lambda_t);
        end
    end
end    


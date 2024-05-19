function [sigmas, u, v] = Filter_GenBetaTEGARCH(mu, lambda, phi, kappa, kappa_tilde, eta1, eta2, nu1, nu2, alpha, returns)
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
            if returns(t-1, 1) <= mu
                b_t = (((abs(returns(t-1, 1) - mu)/(2 * alpha * sigmas(t-1, 1)))^nu1)/eta1) / (1 + ((abs(returns(t-1, 1) - mu)/(2 * alpha * sigmas(t-1, 1)))^nu1)/eta1);
                u(t-1,1) = (eta1 + 1) * b_t - 1;
                v(t-1, 1) = sign(epsilon(t-1, 1) * sigmas(t-1, 1)) * (1 - b_t) * abs(epsilon(t-1, 1)^(nu1-1) * (eta1 + 1) / (eta1 * exp(lambda)));
                %v(t-1, 1) = sign(mu - returns(t-1, 1)) * (u(t-1, 1) + 1);
            else
                b_t = (((abs(returns(t-1, 1) - mu)/(2 * (1 - alpha) * sigmas(t-1, 1)))^nu2)/eta2) / (1 + ((abs(returns(t-1, 1) - mu)/(2 * (1 - alpha) * sigmas(t-1, 1)))^nu2)/eta2);
                u(t-1,1) = (eta2 + 1) * b_t - 1;
                v(t-1, 1) = sign(epsilon(t-1, 1) * sigmas(t-1, 1)) * (1 - b_t) * abs(epsilon(t-1, 1)^(nu2-1) * (eta2 + 1) / (eta2 * exp(lambda)));
                %v(t-1, 1) = sign(mu - returns(t-1, 1)) * (u(t-1, 1) + 1);
            end
            lambda_t = lambda * (1-phi)+phi * log(sigmas(t-1,1)) + kappa * u(t-1,1) + kappa_tilde * v(t-1, 1);
            sigmas(t,1) = exp(lambda_t);
        end
    end
end    


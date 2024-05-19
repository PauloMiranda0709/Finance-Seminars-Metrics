function [output] = generalizedtpdf(y, sigmas, mu, eta1, eta2, nu1, nu2, alpha)
T = size(sigmas, 1);

output = zeros(T, 1);
K_1 = nu1 / (2 * (eta1)^(1/nu1) * beta(1/nu1, eta1/nu1));
K_2 = nu2 / (2 * (eta2)^(1/nu2) * beta(1/nu2, eta2/nu2));
K_12 = 1 / ((alpha / K_1) + ((1 - alpha)/K_2));

for t=1:T
    if y(t, 1) <= mu
        output(t, 1) = K_12 * (1 + abs((y(t, 1) - mu)/(2 * alpha * sigmas(t, 1)))^nu1 / eta1)^(-(eta1 + 1)/nu1) / sigmas(t, 1);
    else 
        output(t, 1) = K_12 * (1 + abs((y(t, 1) - mu)/(2 * (1 - alpha) * sigmas(t, 1)))^nu2 / eta2)^(-(eta2 + 1) / nu2) / sigmas(t, 1);
    end
end








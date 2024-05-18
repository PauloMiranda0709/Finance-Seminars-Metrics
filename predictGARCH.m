function [PVol] = predictGARCH(sigmasquared, mu_hat, omega_hat, alpha_hat_1, alpha_hat_2, beta_hat, h)

%sigmasquaredh = sigmasquared(2:size(sigmasquared,1)+1-h);
sigmasquaredh = sigmasquared(end);
averagesigmasquared = omega_hat/(1- beta_hat - alpha_hat_1/2 - alpha_hat_2/2);

PVol = h*(mu_hat^2+averagesigmasquared) + (1-(alpha_hat_1/2+alpha_hat_2/2+beta_hat)^h)/(1-alpha_hat_1/2-alpha_hat_2/2-beta_hat)*(sigmasquaredh-averagesigmasquared);
end
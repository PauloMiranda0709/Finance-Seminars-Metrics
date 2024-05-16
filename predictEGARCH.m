function [pvol] = predictEGARCH(sigmas,mu_hat, lambda_hat, phi_hat,kappa_hat, kappa_tilde_hat, h)
%pvol = zeros(size(sigmas,1)-h, 1);
lambdas = log(sigmas);

%for t=1:size(sigmas,1)-h
t=size(sigmas,1)-1;
sum_pvol = 0;
for d = 1:h
    sum_pvol = sum_pvol + exp(2*lambda_hat+2*phi_hat^(d-1)*(lambdas(t+1,1)-lambda_hat)+2*(kappa_hat^2+kappa_tilde_hat^2)*(1-phi_hat^(2*(d-1)))/(1-phi_hat^2));
end
pvol = h*mu_hat^2 + sum_pvol;
%end
end
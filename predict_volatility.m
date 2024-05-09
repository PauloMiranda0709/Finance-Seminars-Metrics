%PVOl
function [Pvol] = predict_volatility(days, mu, lambdas, lambda, phi, kappa, kappa_tilde)
T= size(lambdas,1);
Pvol = zeros(T,1);
for t=1:T-1
    Pvol(t,1) = days*mu^2+symsum(exp(2*lambda+2*phi^(d-1)*(lambdas(t+1,1)-lambda)+2*(kappa^2+kappa_tilde^2)*(1-phi^(2*(d-1)))/(1-phi^2)),d,1,days);
end

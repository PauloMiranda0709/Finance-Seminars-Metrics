% AIC & BIC
function [AIC, BIC] = informationCriterions(k,n,negLL)
AIC = 2*k + 2*negLL;
BIC = k*log(n) + 2*negLL;
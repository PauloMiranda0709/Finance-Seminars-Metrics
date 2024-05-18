function [MSE] = doMSE(predicted, actual)

MSE = zeros(length(predicted),1);
for t = 1:length(MSE)
    MSE(t) = 1/length(MSE) * (predicted(t)-actual(t))^2;
end
end

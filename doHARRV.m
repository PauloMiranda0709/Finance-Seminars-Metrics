function [pvol_HARRV1, pvol_HARRV2] = doHARRV(train_returns, test_returns, train_rv5,test_rv5,rv5, h)
%dimensions
n_train = size(train_returns,1);
n_train_h = n_train - h;

%% Target varaices
% target variance 1
tv1 = train_returns;
targetvarh1 = zeros(n_train_h, 1);
for t = 1:n_train_h
    targetvarh1(t) = sum(tv1(t+1:t+h));
end


% target variance 2
tv2 = 1.4 * train_rv5;
targetvarh2 = zeros(n_train_h, 1);
for t = 1:n_train_h
    targetvarh2(t) = sum(tv2(t+1:t+h));
end

%% Parameters
w = 4;
m = 20;
% Initialize the sum vector
sumRV_w = zeros(n_train-h,1);
sumRV_m = zeros(n_train-h,1);
% Loop over each lag and sum up the lagged vectors
for lag = 0:w
    shiftedRV_w = shiftVector(train_rv5(1:n_train_h), lag);
    length(shiftedRV_w)
    % Add the shifted vector to the sum vector
    sumRV_w = sumRV_w + shiftedRV_w;
end
for lag = 0:m
    % Shift all elements down by the current lag
    shiftedRV_m = shiftVector(train_rv5(1:n_train_h), lag); 
    % Add the shifted vector to the sum vector
    sumRV_m = sumRV_m + shiftedRV_m;
end
RV_d = train_rv5(1:end-h);
RV_w = 0.2 * sumRV_w;
RV_m = (1/21) * sumRV_m;

% regression
y1 = targetvarh1;
y2 = targetvarh2;
X_train = [ones(n_train_h,1), RV_d, RV_w, RV_m];
coefficients1 = y1\X_train;
coefficients2 = y2\X_train;

% prediction
%dimensions
n_test = size(test_returns,1);
% Initialize the sum vector
sumRV_test_w = zeros(n_test,1);
sumRV_test_m = zeros(n_test,1);
% Loop over each lag and sum up the lagged vectors
for lag = 0:w
    % Shift all elements down by the current lag
    shiftedRV_test_w = shiftVector(test_rv5, lag);
    zeroIndices = shiftedRV_test_w == 0;
    shiftedRV_test_w(zeroIndices) = rv5(end-zeroIndices);
    % Add the shifted vector to the sum vector
    sumRV_test_w = sumRV_test_w + shiftedRV_test_w;
end
for lag = 0:m
   % Shift all elements down by the current lag
    shiftedRV_test_m = shiftVector(test_rv5, lag);
    zeroIndices = shiftedRV_test_m == 0;
    shiftedRV_test_m(zeroIndices) = rv5(end-zeroIndices);
    % Add the shifted vector to the sum vector
    sumRV_test_m = sumRV_test_m + shiftedRV_test_m;
end
RV_test_d = test_rv5;
RV_test_w = 0.2 * sumRV_test_w;
RV_test_m = (1/21) * sumRV_test_m;
coefficients1
coefficients2
X_test = [ones(size(test_rv5,1),1), RV_test_d, RV_test_w, RV_test_m];
pvol_HARRV1 = X_test * coefficients1';
pvol_HARRV2 = X_test * coefficients2';
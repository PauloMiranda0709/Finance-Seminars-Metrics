function [pvol_HARRV] = doHARRV(train_rv,test_rv, category, h)
%dimensions
n_train = size(train_rv,1);
n_train_h = n_train - h;

%% Target varaices
if category == "rvc"
    % target variance 1
    tv1 = train_rv;
    targetvarh = zeros(n_train_h, 1);
    for t = 1:n_train_h
        targetvarh(t) = sum(tv1(t+1:t+h));
    end
elseif category == "rv5"    
    % target variance 2
    tv2 = 1.4 * train_rv;
    targetvarh = zeros(n_train_h, 1);
    for t = 1:n_train_h
        targetvarh(t) = sum(tv2(t+1:t+h));
    end
end    



%% Parameters
w = 4;
m = 20;
% Initialize the sum vector
sumRV_w = zeros(n_train-h,1);
sumRV_m = zeros(n_train-h,1);
% Loop over each lag and sum up the lagged vectors
for lag = 0:w
    shiftedRV_w = shiftVector(train_rv(1:n_train_h), lag);
    % Add the shifted vector to the sum vector
    sumRV_w = sumRV_w + shiftedRV_w;
end
for lag = 0:m
    % Shift all elements down by the current lag
    shiftedRV_m = shiftVector(train_rv(1:n_train_h), lag); 
    % Add the shifted vector to the sum vector
    sumRV_m = sumRV_m + shiftedRV_m;
end
RV_d = train_rv(1:end-h);
RV_w = 0.2 * sumRV_w;
RV_m = (1/21) * sumRV_m;

% regression
y = targetvarh;
X_train = [ones(n_train_h,1), RV_d, RV_w, RV_m];
coefficients = y\X_train;


% prediction
%dimensions
n_test = size(test_rv,1);
% Initialize the sum vector
sumRV_test_w = zeros(n_test,1);
sumRV_test_m = zeros(n_test,1);
% Loop over each lag and sum up the lagged vectors
for lag = 0:w
    % Shift all elements down by the current lag
    shiftedRV_test_w = shiftVector(test_rv, lag);
    zeroIndices = find(shiftedRV_test_w == 0);
    for idx = 1:length(zeroIndices)
        index = zeroIndices(idx);
        shiftedRV_test_w(index) = train_rv(end+1-index);
    end    
    % Add the shifted vector to the sum vector
    sumRV_test_w = sumRV_test_w + shiftedRV_test_w;
end
for lag = 0:m
   % Shift all elements down by the current lag
    shiftedRV_test_m = shiftVector(test_rv, lag);
    zeroIndices = find(shiftedRV_test_m == 0);
     for idx = 1:length(zeroIndices)
        index = zeroIndices(idx);
        shiftedRV_test_m(index) = train_rv(end+1-index);
     end
    % Add the shifted vector to the sum vector
    sumRV_test_m = sumRV_test_m + shiftedRV_test_m;
end
RV_test_d = test_rv(1);
RV_test_w = 0.2 * sumRV_test_w(1);
RV_test_m = (1/21) * sumRV_test_m(1);
X_test = [ones(size(1,1)), RV_test_d, RV_test_w, RV_test_m];
pvol_HARRV = X_test * coefficients';
end
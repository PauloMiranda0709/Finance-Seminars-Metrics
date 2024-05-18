%% Out of sample predictions
clear
close all
% import data and get it into correct format
load('data')
dates_str = cellstr(num2str(dates));
dates     = datetime(dates_str, 'InputFormat', 'yyyyMMdd');

%start_value = length(rv5)/2;
start_value = length(rv5)-10;
end_value = length(rv5);
splitdates = start_value:end_value;

Pvol_GARCHs_rvc_1 = zeros(length(splitdates),1);
Pvol_GARCHs_rvc_5 = zeros(length(splitdates),1);
Pvol_GARCHs_rvc_21 = zeros(length(splitdates),1);
Pvol_GARCHs_rv5_1 = zeros(length(splitdates),1);
Pvol_GARCHs_rv5_5 = zeros(length(splitdates),1);
Pvol_GARCHs_rv5_21 = zeros(length(splitdates),1);
Pvol_EGARCHs_rvc_1 = zeros(length(splitdates),1);
Pvol_EGARCHs_rvc_5 = zeros(length(splitdates),1);
Pvol_EGARCHs_rvc_21 = zeros(length(splitdates),1);
Pvol_EGARCHs_rv5_1 = zeros(length(splitdates),1);
Pvol_EGARCHs_rv5_5 = zeros(length(splitdates),1);
Pvol_EGARCHs_rv5_21 = zeros(length(splitdates),1);
Pvol_VIXs_rvc_1 = zeros(length(splitdates),1);
Pvol_VIXs_rvc_5 = zeros(length(splitdates),1);
Pvol_VIXs_rvc_21 = zeros(length(splitdates),1);
Pvol_VIXs_rv5_1 = zeros(length(splitdates),1);
Pvol_VIXs_rv5_5 = zeros(length(splitdates),1);
Pvol_VIXs_rv5_21 = zeros(length(splitdates),1);
Pvol_HARRVs_rvc_1 = zeros(length(splitdates),1);
Pvol_HARRVs_rvc_5 = zeros(length(splitdates),1);
Pvol_HARRVs_rvc_21 = zeros(length(splitdates),1);
Pvol_HARRVs_rv5_1 = zeros(length(splitdates),1);
Pvol_HARRVs_rv5_5 = zeros(length(splitdates),1);
Pvol_HARRVs_rv5_21 = zeros(length(splitdates),1);

ds = [1,5,21];
for idx = 1:length(ds)
    d = ds(idx);
    Pvol_GARCHs_rvc = zeros(length(splitdates),1);
    Pvol_EGARCHs_rvc = zeros(length(splitdates),1);
    Pvol_VIXs_rvc = zeros(length(splitdates),1);
    Pvol_HARRVs_rvc = zeros(length(splitdates),1);
    Pvol_GARCHs_rv5 = zeros(length(splitdates),1);
    Pvol_EGARCHs_rv5 = zeros(length(splitdates),1);
    Pvol_VIXs_rv5 = zeros(length(splitdates),1);
    Pvol_HARRVs_rv5 = zeros(length(splitdates),1);
    for t = 1:length(splitdates)
        split_date = splitdates(t);

        train_rv5 = rv5(1:split_date);
        train_rvc = returns(1:split_date);
        test_rv5 = rv5(split_date:end);
        test_rvc = returns (split_date:end);
    
   
        [Pvol_GARCH_rvc,Pvol_EGARCH_rvc,Pvol_VIX_rvc,Pvol_HARRV_rvc] = doRollingWindow(train_rvc,test_rvc, vix, split_date, "rvc", d);
        [Pvol_GARCH_rv5,Pvol_EGARCH_rv5,Pvol_VIX_rv5,Pvol_HARRV_rv5] = doRollingWindow(train_rv5,test_rv5, vix, split_date, "rv5", d);
        

        Pvol_GARCHs_rvc(t) = Pvol_GARCH_rvc;
        Pvol_EGARCHs_rvc(t) = Pvol_EGARCH_rvc;
        Pvol_VIXs_rvc(t) = Pvol_VIX_rvc;
        Pvol_HARRVs_rvc(t) = Pvol_HARRV_rvc;
        Pvol_GARCHs_rv5(t) = Pvol_GARCH_rv5;
        Pvol_EGARCHs_rv5(t) = Pvol_EGARCH_rv5;
        Pvol_VIXs_rvc(t) = Pvol_VIX_rv5;
        Pvol_HARRVs_rv5(t) = Pvol_HARRV_rv5;
        
    end
    if d == 1
        Pvol_GARCHs_rvc_1 = Pvol_GARCHs_rvc;
        Pvol_GARCHs_rv5_1 = Pvol_GARCHs_rv5;
        Pvol_EGARCHs_rvc_1 = Pvol_EGARCHs_rvc;
        Pvol_EGARCHs_rv5_1 = Pvol_EGARCHs_rv5;
        Pvol_VIXs_rvc_1 = Pvol_VIXs_rvc;
        Pvol_VIXs_rv5_1 = Pvol_VIXs_rv5;
        Pvol_HARRVs_rvc_1 = Pvol_HARRVs_rvc;
        Pvol_HARRVs_rv5_1 = Pvol_HARRVs_rv5;
    elseif d == 5
        Pvol_GARCHs_rvc_5 = Pvol_GARCHs_rvc;
        Pvol_GARCHs_rv5_5 = Pvol_GARCHs_rv5;
        Pvol_EGARCHs_rvc_5 = Pvol_EGARCHs_rvc;
        Pvol_EGARCHs_rv5_5 = Pvol_EGARCHs_rv5;
        Pvol_VIXs_rvc_5 = Pvol_VIXs_rvc;
        Pvol_VIXs_rv5_5 = Pvol_VIXs_rv5;
        Pvol_HARRVs_rvc_5 = Pvol_HARRVs_rvc;
        Pvol_HARRVs_rv5_5 = Pvol_HARRVs_rv5;
    elseif d == 21
        Pvol_GARCHs_rvc_21 = Pvol_GARCHs_rvc;
        Pvol_GARCHs_rv5_21 = Pvol_GARCHs_rv5;
        Pvol_EGARCHs_rvc_21 = Pvol_EGARCHs_rvc;
        Pvol_EGARCHs_rv5_21 = Pvol_EGARCHs_rv5;
        Pvol_VIXs_rvc_21 = Pvol_VIXs_rvc;
        Pvol_VIXs_rv5_21 = Pvol_VIXs_rv5;
        Pvol_HARRVs_rvc_21 = Pvol_HARRVs_rvc;
        Pvol_HARRVs_rv5_5 = Pvol_HARRVs_rv5;
    end 
end

Pvol_lists_rvc = [Pvol_GARCHs_rvc_1, Pvol_GARCHs_rvc_5, Pvol_GARCHs_rvc_21, Pvol_EGARCHs_rvc_1, Pvol_EGARCHs_rvc_5, Pvol_EGARCHs_rvc_21, Pvol_VIXs_rvc_1, Pvol_VIXs_rvc_5, Pvol_VIXs_rvc_21, Pvol_HARRVs_rvc_1, Pvol_HARRVs_rvc_5, Pvol_HARRVs_rvc_21];
Pvol_lists_rv5 = [Pvol_GARCHs_rv5_1, Pvol_GARCHs_rv5_5, Pvol_GARCHs_rv5_21, Pvol_EGARCHs_rv5_1, Pvol_EGARCHs_rv5_5, Pvol_EGARCHs_rv5_21, Pvol_VIXs_rv5_1, Pvol_VIXs_rv5_5, Pvol_VIXs_rv5_21, Pvol_HARRVs_rv5_1, Pvol_HARRVs_rv5_5, Pvol_HARRVs_rv5_21];

%% MSE and QLIKE
actual_rvc = returns((end-length(Pvol_lists_rvc)):end);
actual_rv5 = rv5((end-length(Pvol_lists_rv5)):end);
MSEs_rvc = zeros(length(Pvol_lists_rvc),1);
MSEs_rv5 = zeros(length(Pvol_lists_rv5),1);
Qlike_rvc = zeros(length(Pvol_lists_rvc),1);
Qlike_rv5 = zeros(length(Pvol_lists_rv5),1);
for i = 1:length(Pvol_lists_rvc)
    [MSEs_rvc(i)] = doMSE(Pvol_lists_rvc(i), actual_rvc);
    [MSEs_rv5(i)] = doMSE(Pvol_lists_rvc(i), actual_rv5);
    [Qlike_rvc(i)] = doQLIKE(Pvol_lists_rvc(i), actual_rvc);
    [Qlike_rv5(i)] = doQLIKE(Pvol_lists_rv5(i), actual_rv5);
end
MSEs_rvc
    
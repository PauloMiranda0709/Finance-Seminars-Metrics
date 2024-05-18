function [QLIKE] = doQLIKE(predicted, actual)

QLIKE = zeros(length(predicted),1);
for t = 1:length(QLIKE)
    QLIKE(t) = log(actual(t)) + predicted(t)/actual(t);
end
end
function [ sigmasquared ] = Filter_GARCH(varargin) %(mu,omega,alpha1,(alpha2),beta,returns)
if nargin == 5
    % Extract the sample size (make sure returns are a column vector)
    T = size(varargin{5},1);
    % Prefill the variable that we are going to track
    sigmasquared = zeros(T,1);
    % Define sigmabarsquared 
    averagesigmasquared = varargin{2}/(1-varargin{3}-varargin{4});
    % Run the GARCH filter
    for t=1:T
        if t==1
            % Initialise at the unconditional mean of sigmasquared
            sigmasquared(t,1) = averagesigmasquared;      
        else
            sigmasquared(t,1) = varargin{2} + varargin{3} * (varargin{5}(t-1,1)-varargin{1})^2 + varargin{4} * sigmasquared(t-1,1);
        end
    end
elseif nargin == 6
    % Extract the sample size (make sure returns are a column vector)
    T = size(varargin{6},1);
    % Prefill the variable that we are going to track
    sigmasquared = zeros(T,1);
    % Define sigmabarsquared 
    averagesigmasquared = varargin{2}/(1-(varargin{3}/2+varargin{4}/2)-varargin{5});
    % Run the GARCH filter
    for t=1:T
        if t==1
            % Initialise at the unconditional mean of sigmasquared
            sigmasquared(t,1) = averagesigmasquared;      
        else
            % Define the condition (for example, elements greater than 3)
            condition = (varargin{6}(t-1,1)-varargin{1}) > 0;

            % Create the indicator function
            indicator_function = double(condition);

            sigmasquared(t,1) = varargin{2} + (varargin{3}*indicator_function + varargin{4}*(1-indicator_function)) * (varargin{6}(t-1,1)-varargin{1})^2 + varargin{5} * sigmasquared(t-1,1);
        end
    end
end    
% Close the function
end

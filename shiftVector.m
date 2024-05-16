function shiftedVector = shiftVector(originalVector, numZeros)
    % Get the length of the original vector
    len = length(originalVector);
    
    % Initialize the shifted vector with zeros
    shiftedVector = zeros(len, 1);
    
    % Insert zeros at the beginning
    shiftedVector(1:numZeros) = 0;
    
    % Shift the elements down
    shiftedVector(numZeros+1:end) = originalVector(1:len-numZeros);
end
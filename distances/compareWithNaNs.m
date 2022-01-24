function [total,idx] = compareWithNaNs(val,array)
% COMPAREWITHNANS Compare values with NaNs
% 
% This function finds how many times a value is in an array, also allowing
% for NaNs. The problem of comparing two NaNs is that they are not the same
% for matlab. NaN != NaN, which makes no sense in our applications.
% Therefore, compareWithNaNs compares a value with the values in an array,
% treating NaNs as equals.
% 
% 
% 
% Copyright: Miriam Santos, Nov 2018

if isnan(val)
    total = sum(isnan(array));
    idx = find(isnan(array));
else
    total = length(find(array == val));
    idx = find(array == val);
end

end
function dj = hvdm(data,T,xa,xb,variable,isDiscrete,den,nc)
% HVDM Heterogeneous Value Difference Metric
%   da = hvdm(data, xa, xb, variable, isDiscrete) determines the
%   HVDM distance between two patterns xa and xb. This is only for
%   2 patterns, and therefore, it must be called for all features/variables
%   to achieve the complete distance, that is, the sum through all
%   variables, and sqrt, has to be done afterwards.
%
%   INPUT:
%       data = matrix X of data (all patterns, all features)
%       T = coluymn vector of class labels
%       xa = index of point a
%       xb = index of point b
%       variable = index of variable
%       isDiscrete = boolean 1/0 (1 if is nominal, 0 if is linear)
%
%   NOTE: This function is only for values in the training set. Changes are
%   required to measure this distance between points in the test set and
%   points in the training set
%
% References: D. Randall Wilson and Tony R. Martinez, Improved
% Heterogeneous Distance Functions, Journal of Artificial Intelligence
% Research, 1997
%
%
% Author: Miriam Seoane Santos (last-update: March 27, 2018)

val_a = data(xa,variable);
val_b = data(xb,variable);


% If values of xa or xb are unknown, d = 1
if isnan(val_a) || isnan(val_b)
    d = 1;
    % If xa = xb, then d = 0
elseif (val_a == val_b)
    d = 0;
    % If xj is nominal, perform normalized_vdm (call normVDM):
elseif (isDiscrete)
    d = normVDM(data,xa,xb,T,variable,nc);
else
    % If xj is continuous (linear), then perform normalized_diff
    % Check den value: (4*std)
    % Stds are performed ignoring NaNs, but still, std could be 0 (may
    % cause indetermination of Inf):
    
    if (den == 0)
        d = 1;
    else
        num = abs(val_a - val_b);
        
        % According to Szymon Wilk, this restriction could be removed to be
        % faithful to the original JAIR implementation.
        
        % d = min([1 num/den]);
     
        d = num/den;
        
    end
end

% Square of dj (afterwards the sum and sqrt has to be performed)
dj = power(d,2);

end
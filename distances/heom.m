function dj = heom(val_a,val_b,isDiscrete,den)
%HEOM Heterogeneous Euclidean-Overlap Metric.
%   da = HEOM(data, xa, xb, variable, isDiscrete) determines the
%   heom distance between two patterns xa and xb. This is only for
%   2 patterns, and therefore, it must be called for all features/variables
%   to achieve the complete distance, that is, the sum through all
%   variables, and sqrt, has to be done afterwards.
%
%
% References: D. Randall Wilson and Tony R. Martinez, Improved
% Heterogeneous Distance Functions, Journal of Artificial Intelligence
% Research, 1997
%
%
% Author: Miriam Seoane Santos (May, 2018)


% If values of xa or xb are unknown, d = 1
if isnan(val_a) || isnan(val_b)
    d = 1;
    
    % If values xa = xb, then d = 0
elseif (val_a == val_b)
    d = 0;
    
    
    % If var is nominal
elseif (isDiscrete)
    d = 1;
    
else
    % If max - min is 0
    if (den == 0)
        d = 1;
    else
        num = abs(val_a - val_b);
        d = num/den;
    end
end

% Square of dj (afterwards the sum and sqrt has to be performed)
dj = power(d,2);
end



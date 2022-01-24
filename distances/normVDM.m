function dVDM = normVDM(data,xa,xb,T,var,nc)
% normVDM normalized_vdm_a(x,y) for attributes a that are nominal
%
%   INPUT:
%       data = matrix X of data (all patterns, all features)
%       xa = index of point a
%       xb = index of point b
%       T = column vector of class labels
%       var = index of variable
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
% Author: Miriam Seoane Santos (last-update: March 28, 2018)

valueX = data(xa,var);
valueY = data(xb,var);

%--------------------------------------------------------------------------
% NOTE: To compute distances in the whole training set, we will consider
% all the existing points. Changes need to be made to compute the distances
% between points in the test to points in the training set
%--------------------------------------------------------------------------

% Number of instances in the data that have the same value x for
% attribute a
Nax = numel(find(data(:,var) == valueX));

% Number of instances in the data that have the same value y for
% attribute a
Nay = numel(find(data(:,var) == valueY));


sumC = 0;
for c = 1:nc
    % Number of instances in data that have the same value x for attribute a and
    % output class c
    Naxc = numel(find(data(:,var) == valueX & T == c));
    
    % Number of instances in data that have the same value y for attribute a and
    % output class c
    Nayc = numel(find(data(:,var) == valueY & T == c));
    
    sumC = sumC + (abs((Naxc/Nax) - (Nayc/Nay))).^2;
end

dVDM = sqrt(sumC);

end
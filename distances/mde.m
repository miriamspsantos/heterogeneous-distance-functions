function dj = mde(data,xa,xb,variable,isDiscrete,m,sd,px,pyi)
%MDE Mean Euclidean Distance
%   dj = MDE(data,xa,xb,variable,isDiscrete,m,sd,px,pyi) determines the 
%   mde distance between two values val_a and val_b. It considers the
%   definition of MDE for the numeric features by AbdAllah 2016 and our
%   extension for the nominal case.
%
%
%   INPUT:
%       data = matrix X of data (patterns x features)
%       xa = index of point a
%       xb = index of point b
%       variable = idx of feature
%       isDiscrete = whether the feature is discrete (1) or not (0)
%       m = mean of feature
%       sd = standard deviation of feature
%       px = sum of p(x) for feature (if nominal)
%       py = p(y) of all possible values 
%       The latter two are actually structures.
% 
%   OUTPUT:
%       dj = distance between val_a and val_b (already comes squared for
%       aggregation)
% 
% 
% References: 
% L. AbdAllah and I. Shimshoni, K-Means over Incomplete Datasets
% Using Mean Euclidean Distance, MLDM 2016.
% 
% L. AbdAllah and I. Shimshoni, Mean Shift Clustering Algorithm for 
% Data with Missing Values, International Conference on Data Warehousing
% and Knowledge Discovery, 2014.
%
% 
% Author: Miriam Seoane Santos, Nov 2018

val_a = data(xa,variable);
val_b = data(xb,variable);


% Two values are missing
if isnan(val_a) && isnan(val_b)
    if isDiscrete
        d = 1 - px.(strcat('k', num2str(variable)));
    else
        d = 2 * sd^2;
    end
    % Two values are known
elseif ~isnan(val_a) && ~isnan(val_b)
    if isDiscrete
        if (val_a == val_b)
            d = 0;
        else
            d = 1;
        end
    else
        d = (val_a - val_b)^2;
    end
    % One value is missing, either val_a or val_b
else
    array = [val_a val_b];
    val = array(~isnan(array)); % Get the value that is not NaN
    if isDiscrete
        idx = pyi.(strcat('k', num2str(variable)))(:,1) == val;
        py = pyi.(strcat('k', num2str(variable)))(idx,2);
        d = 1 - py;
    else
        d = (val - m)^2 + (sd^2);
    end
end

% Square should only be performed for MDO, for MDE is already squared
% Square of dj (afterwards the sum and sqrt has to be performed)

if isDiscrete % MDO
    dj = power(d,2);
else
    dj = d; % MDE formulation already considers the square
end
    
end
function D = hvdmSpecDist(data,T,featureTypes)
%HVDMSPECDIST HVDM SPECIAL DISTANCE matrix.
%   D = HVDMSPECDIST(data, T, featureTypes) determines the
%   complete HVDM matrix for the patterns in data (all training data).
%   It uses the function def_hvdm to compute the distance for each pair
%   of patterns and for each variable individually, and then
%   merges that information into one single distance matrix D.
%
%
%   INPUT:
%       data = matrix X of data (all patterns, all features)
%       T = column vector of class labels
%       featureTypes = boolean array indicating nominal features (1) or
%       linear features (0)
%
%   NOTE: This function is only for values in the training set. Changes are
%   required to measure this distance between points in the test set and
%   points in the training set
%
%   NOTE: We are assuming only binary contexts (2 classes) for now.
%
% References: D. Randall Wilson and Tony R. Martinez, Improved
% Heterogeneous Distance Functions, Journal of Artificial Intelligence
% Research, 1997
%
%
% Author: Miriam Seoane Santos, Nov 2018


% T must be a column vector. Throw an error and exit if it is not.
if ~iscolumn(T)
    error('ERROR: T must be a column vector!')
end


% Create a matrix of size samples x samples
N = size(data,1); % number of samples
n_vars = size(data,2); % number of variables


% Get std of all variables on data, ignoring NaN values
% If there are NaN values in attribute a, std will return NaN. A
% possible workaround is dismiss those NaN values:
v_std = nanstd(data);
v_den = 4 * v_std;

% Compute all the necessary structure fields for nominal data
% But only if there are any nominal features
if sum(featureTypes ~=0)
    nominalVar = processNom(data, T, featureTypes);
else
    nominalVar = [];
end
    

% Start builing matrix...
D = zeros(N, N);

for i = 1:N-1
    for j = i+1:N
        soma = 0; % sum of dj
        for k = 1:n_vars
            d = def_hvdm(data,i,j,k,featureTypes(k),v_den(k),nominalVar);      
            soma = soma + d;
        end
        D(i,j) = sqrt(soma);
        D(j,i) = sqrt(soma);
    end
end

end





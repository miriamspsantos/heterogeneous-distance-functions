function D = hvdmDist(data,T,featureTypes,type)
%HVDMDIST HVDM distance matrix.
%   D = HVDMDIST(data, T, featureTypes) determines the
%   complete HVDM matrix for the patterns in data (all training data).
%   It uses the function hvdm to compute the distance for each pair
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
%    EXAMPLE:
%
%       clear all; clc;
%       data = [1 2 3 1; NaN 4 3 0];
%       T = [1 0]';
%       featureTypes=[0 0 1 1];
%       D = hvdmDist(data,T,featureTypes)
%
% D =
%
%          0    1.7678
%     1.7678         0
%
%
%
% References: D. Randall Wilson and Tony R. Martinez, Improved
% Heterogeneous Distance Functions, Journal of Artificial Intelligence
% Research, 1997
%
%
% Author: Miriam Seoane Santos (last-update: March 27, 2018)


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


% Number of unique classes in T
classes = unique(T);
nc = numel(classes);


D = zeros(N, N);

for i = 1:N-1
    for j = i+1:N
        soma = 0; % sum of dj
        for k = 1:n_vars
            switch type
                case 'original'
                    d = hvdm(data,T,i,j,k,featureTypes(k),v_den(k),nc);
                case 'redef'
                    d = redef_hvdm(data,T,i,j,k,featureTypes(k),v_den(k),nc);
                    
                    
%                 This code was deprecated, replace by hvdmSpecDist
%                 case 'special'
%                     d = special_hvdm(data,T,i,j,k,featureTypes(k),v_den(k),nc);
%                     
            end
            soma = soma + d;
        end
        D(i,j) = sqrt(soma);
        D(j,i) = sqrt(soma);
    end
end

end





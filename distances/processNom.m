function nominalVar = processNom(X, T, isDiscrete)
% processNom Process Nominal Features in Data
%
% This function results from the need to make normVDMmiss more efficient.
% It takes the entire data matrix (and associated nominal features
% indicator) and computes Nax and Naxc for all its unique values, including
% NaN values. This avoids that the computation is performed every time a
% comparison between xa and xb is needed.
% 
% 
% Matrix stores the following:
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++
%   unique  +   Nax     +   Naxc1   +   Naxc2 
%           +           +           +
%           +           +           +
%           +           +           +
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++
% 
% 
%   INPUT:
%       X = matrix X of data (all patterns, all features)
%       T = column vector of class labels
%       isDiscrete = 1/0 array indicating nominal (1) features
%       Note: We are assuming two classes, 1 and 2
%
%   NOTE: This function is only for values in the training set. Changes are
%   required to measure this distance between points in the test set and
%   points in the training set
%
% EXAMPLE:
%   A = [1 NaN 1; 2 3 2; 1 4 1; 2 NaN 1; 1 1 2];
%   X = A(:,1:2);
%   T = A(:,end);
%   isDiscrete = [1 1];
%   nominalVar = processNom(X, T, isDiscrete);
% 
% 
% References: D. Randall Wilson and Tony R. Martinez, Improved
% Heterogeneous Distance Functions, Journal of Artificial Intelligence
% Research, 1997
%
% 
% Author: Miriam Seoane Santos (November 5, 2018)


nomFeatures = find(isDiscrete);

for k = nomFeatures
    
    vector_K = X(:,k);
    unique_fk = nanUnique(vector_K);
    
    vector_K_C1 = X(find(T == 1),k);
    vector_K_C2 = X(find(T == 2),k);
    

    matrix_fk = [];
    for u = unique_fk'
        % Number of instances that have value u for attribute k
        % compareWithNaNs considers NaNs as being equal
        % because MatLab considers them as different values by default
        Nku = compareWithNaNs(u,vector_K);
        Nku_c1 = compareWithNaNs(u,vector_K_C1);
        Nku_c2 = compareWithNaNs(u,vector_K_C2);
        
        matrix_fk = [matrix_fk; u Nku Nku_c1 Nku_c2];
        
    end
    
nominalVar.(strcat('k',num2str(k))) = matrix_fk;       

        
end
    












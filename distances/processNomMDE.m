function [px, pyi] = processNomMDE(X, isDiscrete)
% PROCESSNOMMDE Process Nominal Features in Data according to MDE-ization
% 
%   INPUT:
%       X = matrix X of data (all patterns, all features)
%       isDiscrete = 1/0 array indicating nominal (1) features
% 
%   OUTPUT:
%       px and py are structures that have as many fields as there are
%       nominal features in the data.
% 
%       px = contains the \sum{x}p(x)^2
%       py = contains the matrix with unique values y in the feature and
%       their frequency p(y). NaNs are not considered.
% 
%    
%   EXAMPLE:
%       X = [1 4 5 6 7; NaN 7 3 2 3]';
%       isDiscrete = [0 1];
%       [px, pyi] = processNomMDE(X, isDiscrete);
% 
%
% 
% Author: Miriam Seoane Santos (November 21, 2018)


% pyi stores the following (for each discrete variable):
% ++++++++++++++++++++++++
%   unique  +   pyi     +
%           +           +
%           +           +
%           +           +
% +++++++++++++++++++++++


% px stores the following (for each discrete variable):
% ++++++++++++++++++++++++
%   unique  +   px      +
%           +           +
%           +           +
%           +           +
% +++++++++++++++++++++++


nomFeatures = find(isDiscrete);


for k = nomFeatures
    
    vector_K = X(:,k);
    
    % Determine how many elements of feature k are not NaN
    N = length(find(~isnan(vector_K)));
    
    % Determine the unique values in K
    unique_fk = unique(vector_K);
    
    
    % Remove NaN values from unique
    % They will not be considered in this implementation
    unique_fk(isnan(unique_fk)) = [];
    
    
    pyi_fk = [];
    for u = unique_fk'
        % Number of instances that have value u for attribute k
        Nku = length(find(vector_K == u));
        pyi_fk = [pyi_fk; u Nku/N];
    end
    pyi.(strcat('k',num2str(k))) = pyi_fk;
end


fNames = fieldnames(pyi);
for p = 1:length(fNames)
    all_pyi = pyi.(fNames{p})(:,end);
    px.(fNames{p}) = sum(all_pyi.^2);
end


end


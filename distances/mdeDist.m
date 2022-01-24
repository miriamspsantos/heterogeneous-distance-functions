function D = mdeDist(data, featureTypes)
%MDEDIST Mean Euclidean Distance matrix
%   D = MDE(data, featureTypes) determines the
%   complete MDE matrix for the patterns in data (all training data).
%   
%   INPUT:
%       data = matrix X of data (all patterns, all features)
%       featureTypes = boolean array indicating nominal features (1) or
%       linear features (0)
%
% 
%   EXAMPLE:
%       data = [3 5 3 NaN NaN 3; 7 3 NaN NaN NaN NaN; 2 2 1 7 30 7;... 
%               4 2 4 4 20 3; 3 2 7 7 12 3];
%       featureTypes = [0 1 0 1 0 1];
%       D = mdeDist(data, featureTypes)
% 
% D =
% 
%          0    1.3991    1.5477    1.2290    1.2417
%     1.3991         0    1.7582    1.3157    1.4263
%     1.5477    1.7582         0    1.4776    1.7325
%     1.2290    1.3157    1.4776         0    1.0503
%     1.2417    1.4263    1.7325    1.0503         0
% 
% 
%   NOTE: This function is only for values in the training set. Changes are
%   required to measure this distance between points in the test set and
%   points in the training set
%
% References: 
% L. AbdAllah and I. Shimshoni, K-Means over Incomplete Datasets
% Using Mean Euclidean Distance, MLDM 2016.
% 
% L. AbdAllah and I. Shimshoni, Mean Shift Clustering Algorithm for 
% Data with Missing Values, International Conference on Data Warehousing
% and Knowledge Discovery, 2014.
%
% Author: Miriam Seoane Santos, Nov 2018


% Create a matrix of size samples x samples
N = size(data,1); % number of samples
n_vars = size(data,2); % number of features


% Normalize continuous features (min-max normalisation)
numFeatures = find(featureTypes == 0);

for f = numFeatures
    data(:,f) = normMinMax(data(:,f));
end

% Get mean and std of all features (although this is only necessary for
% numeric features)
vec_mean = nanmean(data); % NaN values are ignored
vec_std = nanstd(data); % NaN values are ignored


% Compute all the necessary structure fields for nominal data
% But only if there are any nominal features
if sum(featureTypes ~=0)
    % Compute p(yi) and p(x)^2 for discrete features
    [px, pyi] = processNomMDE(data, featureTypes);  
else
    px = [];
    pyi = [];
end

% Start builing matrix...
D = zeros(N, N);

for i = 1:N-1
    for j = i+1:N
        soma = 0; % sum of dj
        for k = 1:n_vars
            d = mde(data,i,j,k,featureTypes(k),vec_mean(k),vec_std(k),px,pyi);
            soma = soma + d;
        end
        D(i,j) = sqrt(soma);
        D(j,i) = sqrt(soma);
    end
end


end















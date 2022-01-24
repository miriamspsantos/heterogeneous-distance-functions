function D = similarityDistance(data, featureTypes)
% SIMILARITYDIST Computes the similarity distance according to Belanche and
% Hernandez
%   D = similarityDist(data, featureTypes) determines the distance matrix D
%   between all patterns in data. This distance is computed using the
%   information in featureTypes
% 
%
%  INPUT:
%       data = matrix of data (N patterns x n_vars)
%       featureTypes = 1/0 array of size n_vars indicating if feature is discrete (1) or not (0)
%       
%  OUTPUT:
%       D = distance matrix for all patterns in data
% 
% References: L. Belanche and J. Hernandez, Similarity networks for
% heterogeneous data, European Symposium on Artificial Neural Networks,
% Computational Intelligence and Machine Learning (ESANN 2012), 2012
% 
% 
% EXAMPLE:
% data = [3 7 NaN 2; 4 5 NaN 3; NaN 2 3 3; 7 4 2 4];
% featureTypes = [1 0 0 1];
% D = similarityDistance(data, featureTypes);
% 
% 
% 
% Copyright: Miriam Seoane Santos (Oct, 2018)


% Set data to a single to save memory
data = single(data);


% Create a matrix of size samples x samples
N = size(data,1); % number of samples
n_vars = size(data,2); % number of variables


% Get the max and min for all features
% max and min functions just ignore NaN values
v_max = max(data);
v_min = min(data);
v_den = v_max - v_min;


D = zeros(N,N);

% Create a multidimensional array that contains D(xa,xb,k)
% Each page of the multidimensional array will be the matrix D computed
% alone concerning one feature
for nk = 1:n_vars
    Dk(:,:,nk) = D;
end

% Set Dk to single to save memory
Dk = single(Dk);


% Clear variables we do not need
clearvars D


for i = 1:N-1
    for j = i+1:N
        for k = 1:n_vars
            val_a = data(i,k);
            val_b = data(j,k);
            
            % Let is assume Pj as the fraction of xa points in k
            % Pj is the fraction of examples in k that take value xa for
            % variable k. If Pj is used is because xa and xb are equal so
            % it does not matter which one we choose to compute
            Pj = sum(val_a == data(:,k))/N;
            
            sj = similarity(val_a, val_b, featureTypes(k), v_den(k), Pj);
            
            % Make sj a single to save memory
            Dk(i,j,k) = single(sj);
        end
    end
end


% Now that Dk is complete, we need to determine sk
% sk is the mean similarity between all examples according to k
% I only assume the upper diagonal
tUp = triu(true(N),1);
for nk = 1:n_vars
    aux_D = Dk(:,:,nk);
    sk = nanmean(aux_D(tUp));
    if sk ~= 0
        aux_D = aux_D/sk;
    end
    aux_D = aux_D./(aux_D+1);
    aux_D(isnan(aux_D)) = 1/2;
    S(:,:,nk) = aux_D;
end

clearvars Dk aux_D

% We have been computing similarities, we now need distances
% distance = 1 - similarity
S = 1 - S; % this is also a multidimensional matrix

% Get lower matrix to be 0 again
tLow = tril(true(N));
for nk = 1:n_vars
    aux_dk = S(:,:,nk);
    aux_dk(tLow) = 0;
    S(:,:,nk) = aux_dk;
end

% Square the individual distances dk
S = power(S,2);

D = sum(S,3);

clearvars S

D = sqrt(D);

D = D'+ D;

end

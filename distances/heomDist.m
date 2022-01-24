function D = heomDist(data, featureTypes,type)
%HEOMDIST HEOM distance matrix.
%   Dtotal = HEOMDIST(data, featureTypes) determines the
%   complete HEOM matrix for the patterns in data (all training data).
%   It uses the function heom to compute the distance for each pair
%   of patterns and for each variable individually, and the
%   merges that information into one single distance matrix D.
%
%
% Author: Miriam Seoane Santos (last-update: May, 2018)


% Create a matrix of size samples x samples
N = size(data,1); % number of samples
n_vars = size(data,2); % number of variables

% Get the max and min for all features
% max and min functions just ignore NaN values
v_max = max(data);
v_min = min(data);
v_den = v_max - v_min;


D = zeros(N, N);

for i = 1:N-1
    for j = i+1:N
        soma = 0;
        for k = 1:n_vars
            val_a = data(i,k);
            val_b = data(j,k);
            switch type
                case 'original'
                    d = heom(val_a,val_b,featureTypes(k),v_den(k));
                case 'redef'
                    d = redef_heom(val_a,val_b,featureTypes(k),v_den(k));
            end 
            soma = soma + d;
        end
        D(i,j) = sqrt(soma);
        D(j,i) = sqrt(soma);
    end
end


end
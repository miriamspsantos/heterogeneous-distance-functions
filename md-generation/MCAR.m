function dataMiss = MCAR(X, percentage)
% MCAR Introduces MCAR mechanism in the data in X
%
%   INPUT:
%       X = dataset (samples x features)
%       percentage = percentage of desired missing rate. In this case,
%       the percentage is considered as numberOfMissings/NumberOfElements xij.
%       There is not a guarantee that all features have the same percentage
%       of missing data, so several runs should be performed.
%
%       Missing values are generated regardless of the class they belong
%       to.
%
%
%   NOTE: This implementation considers that the provided dataset X is
%   complete. It does not handle pre-existing missing values in X.
%
%
%   OUTPUT:
%       dataMiss = data with missing data (X with some elements to NaN)
%
%
% Copyright: Miriam Santos 2018


% Determine the number of elements to create has NaN
noMissings = round(percentage*numel(X)/100);

if noMissings >= numel(X)
    error('ERROR: The desired missing rate will delete the entire data! Try a lower rate!...');
else
    
    P = randperm(numel(X),noMissings);
    X(P) = NaN;
    dataMiss = X;
end

end

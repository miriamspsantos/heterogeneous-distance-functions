function numVar = categorize(nomVar, Labels)
% categorize(nomVar, Labels) transforms categorical data from arff files
% into numeric values. 
% E.g:
% V1 = {A32, A102, A78, A88}
% V1 = {1, 2, 3, 4}
% 
% For ordinal data coded as categorical, the ranks are automatically made,
% as long as they are ORDERED IN THE ORIGINAL ARFF FILE:
% V1 = {low, moderate, high} will be {1, 2, 3}
% V1 = {moderate, high, low} will be {1, 2, 3} too, that's why it must be
% ordered
% 
% 
% Posterior changes to these categories (e.g codification into 0/1 vectors
% for each nominal category -- binary matrix -- must be performed afterwards)
% 
%   INPUT:
%       nomVar = nominal variable directly from arff read
%       Labels = from nomspec, the nominal specification that we need for
%       the conversion
% 
%   OUTPUT:
%       numVar = nominal variable coded as numeric
% 
% 
% Copyright: Miriam Santos, 2017


numVar = zeros(size(nomVar));
% numVar = NaN(size(nomVar));

for j=1:length(Labels)
    numVar(nomVar == Labels{j}) = j;
end

    



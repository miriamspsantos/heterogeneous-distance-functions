function sj = similarity(val_a, val_b, isDiscrete, den, Pj)
% SIMILARITY Similarity between 2 values of a feature
%   sj = similarity(val_a, val_b, isDiscrete, den, Pj) determines the
%   individual sijk similarity between two patters i,j and for feature k.
%   This function is used later by SIMILARITYDIST, where the final distance
%   between patterns i and j is computed. Note that this function computes
%   similarities, not distances, the final distance is done afterwards.
%
%  INPUT:
%       val_a = value of xa (in a given feature)
%       val_b = value of xb (in a given feature)
%       isDiscrete = 1/0 value indicating if feature is discrete (1) or not (0)
%       den = denominator (used for continuous features)
%       Pj = fraction (used for nominal/discrete features)
%   den and Pj may not be used but the code is simplified if they are
%   always given
% 
%  OUTPUT:
%       sj = individual similarity between values val_a and val_b in
%       feature k
% 
% 
% References: L. Belanche and J. Hernandez, Similarity networks for
% heterogeneous data, European Symposium on Artificial Neural Networks,
% Computational Intelligence and Machine Learning (ESANN 2012), 2012
% 
% 
% Copyright: Miriam Seoane Santos (Oct, 2018)


% If values xa or xb are unknown, sj = 1/2 
% (this is done later in similarityDist, so for now we need to set it to
% NaN to ease the computation later)
if isnan(val_a) || isnan(val_b)
    sj = NaN;
    
% If the feature is continuous    
elseif ~isDiscrete
    % If values are the same
    if (val_a == val_b)
        sj = 1;
    else 
        if (den == 0)
            sj = 0;
        else
            num = abs(val_a - val_b);
            sj = 1 - num/den;
        end
    end
else
    if (val_a == val_b)
        sj = 1 - Pj;
    else
        sj = 0;
    end
end


end

    
    
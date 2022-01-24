function norm_feature = normMinMax(vector_K)

% Only for one feature


% NaNs are ignored
max_K = max(vector_K);
min_K = min(vector_K);


if (max_K-min_K) == 0
    norm_feature = 0;
else
    % NaNs stay as NaN
    norm_feature = (vector_K-min_K)/(max_K-min_K);
end


end

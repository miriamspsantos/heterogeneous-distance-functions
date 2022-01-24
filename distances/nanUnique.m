function y = nanUnique(x)
% NANUNIQUE Unique function, treating NaN as equals
% 
% Since matlab treats two NaNs as distinct values, then the unique outuputs
% as many NaNs as there are in data. This function takes care of that,
% treating NaNs as equals (no repeated NaNs will appear). 
% 
% 
% 
% Copyright: Miriam Santos, Nov 2018
  y = unique(x);
  y(isnan(y(1:end-1))) = [];
end
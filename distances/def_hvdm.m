function dj = def_hvdm(data,xa,xb,variable,isDiscrete,den,nominalVar)

val_a = data(xa,variable);
val_b = data(xb,variable);

% If xa = xb, then d = 0
% If they are both NaNs, consider that they are equal
if isequaln(val_a, val_b)
    d = 0;
    
elseif isDiscrete
    % Perform normVDM
    matrix = nominalVar.(strcat('k', num2str(variable)));
    d = spec_VDM(val_a,val_b,matrix); 
  
    % Is continuous and might be NaN
else
    if isnan(val_a) || isnan(val_b)
        d = 1; % If the feature is continuous, mantain d = 1
    else
        % If xj is continuous (linear), then perform normalized_diff
        % Check den value: (4*std)
        % Stds are performed ignoring NaNs, but still, std could be 0 (may
        % cause indetermination of Inf):
        if (den == 0)
            d = 1;
        else
            num = abs(val_a - val_b);
            d = num/den;     
        end
    end
end
% Square of dj (afterwards the sum and sqrt has to be performed)
dj = power(d,2);


end
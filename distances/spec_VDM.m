function dVDM = spec_VDM(valueX,valueY,matrix)

% Matrix stores the following:
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++
%   unique  +   Nax     +   Naxc1   +   Naxc2 
%           +           +           +
%           +           +           +
%           +           +           +
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++

[~,idx_valueX] = compareWithNaNs(valueX, matrix(:,1));
[~,idx_valueY] = compareWithNaNs(valueY, matrix(:,1));


% Find Nax and Nay
Nax = matrix(idx_valueX,2);
Nay = matrix(idx_valueY,2);

% For class = 1
Naxc1 = matrix(idx_valueX,3);
Nayc1 = matrix(idx_valueY,3);

% For class = 2
Naxc2 = matrix(idx_valueX,4);
Nayc2 = matrix(idx_valueY,4);

dVDM = sqrt((abs((Naxc1/Nax) - (Nayc1/Nay)).^2) + (abs((Naxc2/Nax) - (Nayc2/Nay)).^2));
       
end
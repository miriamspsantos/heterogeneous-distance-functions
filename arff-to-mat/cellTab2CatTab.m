function [ newData ] = cellTab2CatTab( dataTab )
% Author: Jastin Pompeu Soares
% Last review Date: 2017-04-12
% This function converts CELL on tables to categorical information
%   'dataTab' is a table with TEXT as a CELL format
%   'newData' is a copied table with categorica columns
%   [ newData ] = cellTab2CatTab( dataTab )

newData=dataTab;
for i=1:size(dataTab,2)
    if iscell(dataTab.(i))
        newData.(i)=categorical(dataTab.(i));
    end
end

end


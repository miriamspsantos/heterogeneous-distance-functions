function [A, Labels] = convTab2double(Tab, nomspec, varNames)
% convTab2double(Tab, nomspec, varNames) converts a Table to a double array
% The Categorical Values will by converted to numerical
% It will return a double array (A) with all data converted and the labels
% from each categorical attribute
% 
% 
% Author: Jastin Pompeu Soares, 2016-11
% Updated: Jastin, 2017-04-12
% Last Review: Miriam Santos 11-10-2017
 

A=zeros(size(Tab));
% Labels={};
% fieldNames = fieldnames(nomspec);

for i=1:size(Tab,2)
    aux=Tab{:,i};
    if(iscategorical(aux))
        %convert categorical in numerical
        Label = nomspec.(varNames{i});
        Labels{1,i} = Label;
        A(:,i) = categorize(aux, Label);
    else
        A(:,i)=aux;
        Labels{1,i} = [];
    end
end
end


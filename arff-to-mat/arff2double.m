function [dataOut,DataTab,DataStruct] = arff2double(filename)
% arff2double(filename) reads an arff file and converts it to a .mat
% structure.
%
%   INPUT:
%       'filename' is a string with the name or filepath (must have ".arff")
%
%   OUTPUT:
%   'dataOut' is a struct with the following fields:
%           .A = all features in double
%           .CatLogical = logical vector that identify categorical columns
%           .Labels = original labels of each categorical column
%           .varNames = feature names
%           .relname = dataset name (original return from the arff_read() )
%           .nomspec = categorical uniques from each feature (original return from the arff_read() )
%           .featureTypes = feature types, according to the 0-6 codes specified
%                     in arff_read (only for the features, not the class)
%           .ftypes = feature types, according to the 0-6 codes specified
%                     in arff_read (all the features, plus the class)
%           .isNominal = 0/1 array for nominal features
%           .isBinary = 0/1 array for binary features
%           .isNumeric = 0/1 array for numeric features
%           .isOrdinal = 0/1 array for ordinal features
%           .isQuant = 0/1 array for quantitative data
%           .isQual = 0/1 array for qualitative data
%           .isNomBin = 0/1 array for nominal and binary data (since binary is considered nominal)
%           .name = dataset name (same as relname)
%           .X = data from all features
%           .Y = class target values
% 
%   'DataTab' is a Table with the data read from the arff
%   'DataStruct' is a Struct with the data read from the arff (original return from the arff_read())
%
%
%   EXAMPLE:
%       filename = 'german-read.arff'
%       [dataOut,DataTab,DataStruct] = arff2double(filename)
%
%
% Author: Jastin Pompeu Soares (2017-04-20)
% Last Review: Miriam Santos (2017-10-11)


% Read the arff
[DataStruct,relname,nomspec,ftypes]=arff_read(filename);

% Convert to table
DataTab=struct2table(DataStruct);

% Save the variable names
varNames=DataTab.Properties.VariableNames;

% Convert all cell to categorical
DataTab=cellTab2CatTab(DataTab);

% Convert all categorical to integer
[A,Labels] = convTab2double(DataTab, nomspec, varNames);

% Create structure
% dataOut
dataOut.A=A;
dataOut.Labels=Labels;
dataOut.varNames=varNames;
dataOut.relname=relname;
dataOut.nomspec=nomspec;
dataOut.ftypes=ftypes;
dataOut.featureTypes = ftypes(1:end-1);

featureTypes = ftypes(1:end-1);

% Get proper codification of type of variable (ftypes)
isNominal = zeros(size(featureTypes));
isBinary = zeros(size(featureTypes));
isNumeric = zeros(size(featureTypes));
%     isString = zeros(size(ftype));
%     isDate = zeros(size(ftype));
isOrdinal = zeros(size(featureTypes));
V = zeros(size(ftypes));


isNominal(featureTypes == 1) = 1;
V(ftypes == 1) = 1;

isBinary(featureTypes == 5) = 1;
V(ftypes == 5) = 1;

isNumeric(featureTypes == 0) = 1;
isOrdinal(featureTypes == 4) = 1;

isOrdinal(featureTypes == 6) = 1;
V(ftypes == 6) = 1;


% Binary data can be considered nominal: add an option for that
isNomBin = zeros(size(featureTypes));
isNomBin(isNominal == 1) = 1;
isNomBin(isBinary == 1) = 1;


% Create isQual and isQuant for Qualitative and Quantitative data
isQual = zeros(size(featureTypes));
% isQuant = zeros(size(ftypes));


% Quantitative Data = Only Numeric Data
isQuant = isNumeric;

% Qualitative Data = Ordinal + Binary + Nominal Data
isQual(isNominal == 1) = 1;
isQual(isBinary == 1) = 1;
isQual(isOrdinal == 1) = 1;


dataOut.isNominal = isNominal;
dataOut.isBinary = isBinary;
dataOut.isNumeric = isNumeric;
dataOut.isOrdinal = isOrdinal;
dataOut.isQuant = isQuant;
dataOut.isQual = isQual;
dataOut.isNomBin = isNomBin;


% Important to write back to arff (double2arff)
dataOut.CatLogical=V;

% If in categorical variables there are NaNs, replace by 'NaN'
for i=1:length(dataOut.CatLogical)
    if dataOut.CatLogical(i)
        aux = find(dataOut.A(:,i) == 0);
        dataOut.A(aux,i)= NaN;
    end
end


% Create three more fields for information
dataOut.name = relname;
dataOut.X = dataOut.A(:,1:end-1);
dataOut.Y =  dataOut.A(:,end);


end


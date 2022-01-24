addpath('arff-to-mat');
addpath('distances');
addpath('data');
addpath('md-generation');

data = arff2double('thoracic.arff');
X = data.X;
T = data.Y;
feature_types = data.isNomBin;

% Insert MVs in X
p = 20; % percentage of missing data
X = MCAR(X, p);

DIST = 'HEOM-original';

switch DIST
    case 'HVDM-original'
        D = hvdmDist(X, T, feature_types, 'original');
    case 'HEOM-original'
        D = heomDist(X, feature_types, 'original');
    case 'HVDM-redef'
        D = hvdmDist(X, T, feature_types, 'redef');
    case 'HEOM-redef'
        D = heomDist(X, feature_types, 'redef');
    case 'HVDM-special'
        D = hvdmSpecDist(X, T, feature_types);
    case 'SIMDIST'
        D = similarityDistance(X, feature_types);
    case 'MDE'
        D = mdeDist(X, feature_types);
end


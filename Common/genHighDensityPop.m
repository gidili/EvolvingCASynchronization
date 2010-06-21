function [ Population ] = genHighDensityPop(GenomeLength, FitnessFcn, options)
%generateHighDensityPopulation generates initial population of rules
%   This function generates popSize rules of size chromSize. The rules are
%   generated with uniform distribution of densitites of 1s, spanning from
%   very low to very high as this facilitates evolution.

%constants
chromSize = GenomeLength;
popSize = 100;

% thresholds go from 0 (all 0) to 1 (all 1) - need to play with params
thresholdVector = linspace(0.1,0.9,popSize);
% vectors are per row
Population = bsxfun(@lt,rand(popSize, chromSize),thresholdVector');

end


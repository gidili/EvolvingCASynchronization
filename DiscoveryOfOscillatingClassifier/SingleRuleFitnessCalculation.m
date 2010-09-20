% clear memory so that we can compare timespans
clear

tic

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%CONSTANTS DECLARATION
% # of runs for average
runs = 1;
%CONSTANTS DECLARATION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% assign rule
%GKL --> [1 1 1 1 1 0 1 0 1 1 1 1 1 1 1 1 1 1 1 1 1 0 1 0 0 0 0 0 0 0 0 0 1 1 1 1 1 0 1 0 1 1 1 1 1 1 1 1 1 1 1 1 1 0 1 0 0 0 0 0 0 0 0 0 1 1 1 1 1 0 1 0 0 0 0 0 0 0 0 0 1 1 1 1 1 0 1 0 0 0 0 0 0 0 0 0 1 1 1 1 1 0 1 0 0 0 0 0 0 0 0 0 1 1 1 1 1 0 1 0 0 0 0 0 0 0 0 0];
rule = [0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 1 0 0 0 0 1 0 0 0 0 0 0 1 1 1 1 0 0 0 0 0 0 0 0 0 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 0 0 0 1];

fitSum = 0;
i = 0;
while(i<runs)
    fitness = majorityClassificationFitness(rule, 1);
    disp(['fitness ' num2str(i) ' --> ' num2str(fitness)])
    %increase counters
    fitSum = fitSum + fitness;
    i = i+1;
end

disp(['avg fitness --> ' num2str(fitSum/runs)])

toc
function [ fitness ] = majorityClassificationFitness( rule , varargin )
%CALCULATEFITNESS
% this function calculates performance fitness of given rule - returns a
% scalar calculated as successfulRuns/TotalRuns. Takes a 128 bits vector
% representing a CA rule for a neighborhood of radius 3.
% Note: A lot of (if not all) the costants declared here could be passed down as
% parameters - but since this is going to be used as the fitness function
% in a Genetic Algorithm very specific to the problem at hand to be called
% from the matlab Genetic Algorithm toolkit, it is more practical to pass
% down as input param only the transformation rule.

output = 0;

% only want 1 optional input at most to control output
numvarargs = length(varargin);
if (numvarargs > 1)
    error('calculateFitness: takes at most 1 optional input');
elseif (numvarargs == 1)
    output = cell2mat(varargin(1));
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%CONSTANTS DECLARATION
% the size of our array of cells
latticeSize=149;
% neighborhood radius
radius = 3;
% rule size
ruleSize= radius*2 +1;
% number of time steps
max=320;
% number of initial configurations
ICsNo = 100;
%CONSTANTS DECLARATION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% check if rule size is as espected
if(length(rule) ~= 2^ruleSize)
    error('calculateFitness: rule is not 128 bits!') ;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%RULESET AND TRANSFORMATIONS
% the ruleset data object
ruleSet = CARuleset;
% patterns
ruleSet.patterns = flipud(combn([0 1],ruleSize));

% assign resulting transformations
ruleSet.transformations = rule;
%RULESET AND TRANSFORMATIONS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% generate initial configurations
ICs = generateBinaryInitialConfigurations(ICsNo, latticeSize);

% declare correct final state convergence counter
correctlySynced = 0;
% declare totat timesteps counter for average
totalsteps = 0;

% outer loop - tests the rule over all the initial configurations
icIterator=1;
while(icIterator <= ICsNo)
    % declare main operationl vector (a) and new vector buffer (newa)
    a=zeros(1,latticeSize);
    newa=zeros(1,latticeSize);
    
    % assign current initial configuration
    a = ICs(icIterator, :);
    
    % calculate if more 0 or 1 to have a check for final state
    sumInitialState = sum(a);
    
    % output
    if(output)
        disp(['iteration: ' num2str(icIterator)])
        if(sumInitialState > latticeSize/2)
            disp(['should converge to black - sum = ' num2str(sumInitialState)])
        else
            disp(['should converge to white - sum = ' num2str(sumInitialState)])
        end
    end
    
    % assign initial configuration to the grid
    GRID(1,:)=a;
    % in theory no need to initialize the grid except 1st row (saves cpu time)
    for i=2:max,
      GRID(i,:)=zeros(1,latticeSize);
    end
    
    % this is the inner loop (where the CA processing happens)
    g=1;
    while (g<max),
        
        %run the chosen rule foreach cell for a given time step g
        %boundary cells are being ignored in this example
        for i=1:latticeSize,
            % retrieve pattern in the local 'hood
            localPattern = circularSubarray(a, i-radius, i+radius);
            % find the transformation rule for the given local pattern
            for c=1:2^ruleSize,
                if(isequal(ruleSet.patterns(c, :), localPattern))
                    newa(i) = ruleSet.transformations(c);
                    break
                end
            end
        end
        
        % assign new states
        g=g+1;
        a=newa;
        GRID(g,:)=a;
        
        % check if correctly synced or stable configuration and break if so
        sumCurrentState = sum(newa);
        stableConfig = isequal(GRID(g,:), GRID(g-1,:));
        if(stableConfig && sumCurrentState == 149 && sumInitialState > latticeSize/2)
            % increment correctly synced and totalsteps counter
            correctlySynced = correctlySynced +1;
            totalsteps = totalsteps + g;
            
            % some output
            if(output)
                disp(['correctly synced to all black (1) in ' num2str(g) ' time steps'])
            end
            break;
        elseif(stableConfig && sumCurrentState == 0 && sumInitialState < latticeSize/2)
            % increment correctly synced and totalsteps counter
            correctlySynced = correctlySynced +1;
            totalsteps = totalsteps + g;
            
            % some output
            if(output)
                disp(['correctly synced to all white (0) in ' num2str(g) ' time steps'])
            end
            break;
        elseif(stableConfig)
            % wrong stable config reached do nothing in this case -
            % just increase totalSteps counter and break
            totalsteps = totalsteps + g;
            % some output
            if(output)
                disp(['wrong stable config reached in ' num2str(g) ' time steps'])
            end
            break;
        end
        
        % INNER LOOP PREDICTIVE CUT_OFF - START
		%check proportional fitness and if not good enough stop after 1/2 t steps. 
		%by good enough we mean at least 5% convergence in the correct direction.
		if(g > max/2 && ( ...
		  (sumInitialState > latticeSize/2 && sumCurrentState < (latticeSize/2 + latticeSize/2*5/100)) ... 
		  ||(sumInitialState < latticeSize/2 && sumCurrentState > (latticeSize/2 - latticeSize/2*5/100)) ...
		  ))
		  
		  % assume it would not converge, update total no. of steps
		  totalsteps = totalsteps + max; 
		  % some output 
		  if(output)
		  	disp(['Interrupted because not promising after ' num2str(g) ' time steps'])
		  end
		  
		  break;
		end
		% INNER LOOP PREDICTIVE CUT_OFF - END
        
        %if last iteration update totalsteps
        if(g == max)
            totalsteps = totalsteps + max;
            % some output
            if(output)
                disp(['Reached maximum time steps: ' num2str(g)])
            end
        end
        
    end
    
    if(output)
        disp(['iteration complete: ' num2str(icIterator)])
    end
    
    icIterator = icIterator +1;
end

fitness = - correctlySynced / ICsNo;
avgtimesteps = totalsteps / ICsNo;

%save to file if specified by input param:
if(1)
    fid = fopen(['majorityClassification_Log_' datestr(datevec(now), 12) '.txt'],'a');
    %1 fitness
    fprintf(fid, '%f#', fitness);
    %2 rule
    fprintf(fid, '%d ', rule); fprintf(fid, '#');
    % average timesteps
    fprintf(fid, '%f#', avgtimesteps);
    % timestamp
    fprintf(fid, datestr(datevec(now), 0));
    fprintf(fid, '\n');
    fclose(fid);
end

end
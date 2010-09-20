% the size of our array of cells
latticeSize=149;
% number of time steps
max=320;

a=zeros(1,149);
newa=zeros(1,149);

% the ruleset data object
ruleSet = CARuleset;

% patterns                
ruleSet.patterns = [1, 1, 1;
                    1, 1, 0;
                    1, 0, 1;
                    1, 0, 0;
                    0, 1, 1;
                    0, 1, 0;
                    0, 0, 1;
                    0, 0, 0;]
                
% transformation rules for each pattern 
% this is wolfram rule 90 --> http://mathworld.wolfram.com/Rule90.html
ruleSet.transformations = [0 1 0 1 1 0 1 0];

% this is wolfram rule 110 --> http://mathworld.wolfram.com/Rule110.html
%ruleSet.transformations = [0 1 1 0 1 1 1 0];

% randomize initial configuration
a = randint(149, 1, [0 1]);

% switch on single cells
%a(35) = 1;
%a(75) = 1;
%a(100) = 1;

% assign initial configuration to the grid
GRID(1,:)=a;

% initialize the grid
for i=2:max,
    GRID(i,:)=zeros(1,149);
end

%spit out first frame
spy(GRID)
M(1) = getframe;

% main loop
g=1;
while (g<max), 
    
  %run the chosen rule foreach cell for a given time step g
  %boundary cells are being ignored in this example
  for i=2:149-1,   
    % retrieve pattern in the local 'hood  
    localPattern = [a(i-1), a(i), a(i+1)];
    % find the transformation rule for the given local pattern
    for c=1:8,
        if(isequal(ruleSet.patterns(c, :, :), localPattern))
            newa(i) = ruleSet.transformations(c);
            break
        end
    end
  end
  
  % assign new states
  g=g+1;
  a=newa;
  GRID(g,:)=a;
  
  %push a snapshot to a frame
  spy(GRID)
  M(g) = getframe;
end

%last frame - final state of the matrix
spy(GRID)
M(max) = getframe;

%playback
movie(M,0)
classdef CARuleset
    %Rule - a rule for 1D cellular automata
    %Members: pattern - final state
    
    properties
        patterns
        transformations
    end
    
    methods
        function obj=CARule(patterns, transStates)
            obj.patterns = patterns;
            obj.transformations = transStates;
        end
    end
    
end


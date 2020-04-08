classdef ExperimentAggregate < handle
    % EXPERIMENTAGGREGATE functions for aggregating variables in different sessions
    
	% Copyright 2020 Richard J. Cui. Created: Wed 04/08/2020  7:08:17.484 AM
    % $Revision: 0.1 $  $Date: Wed 04/08/2020  7:08:17.484 AM $
    %
    % Multimodel Neuroimaging Lab (Dr. Dora Hermes)
    % Mayo Clinic St. Mary Campus
    % Rochester, MN 55905, USA
    %
    % Email: richard.cui@utoronto.ca (permanent), Cui.Jie@mayo.edu (official)
    
    % basic functions
    % ---------------
    methods( Static, Sealed )
        
        [mn, se] = Copy( curr_exp, sessionlist, S )
        [mn, se] = Add( curr_exp, sessionlist, S )
        [mn, se] = Average(curr_exp, sessionlist, S)
        [mn, se] = Concatenate( curr_exp, sessionlist, S )
        
    end
    
    methods(Access=private, Static, Sealed )
        list = get_variable_list( curr_exp, type, agg_only_these_vars, filters_to_use )
        
    end
    
end

% [EOF]


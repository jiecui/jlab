classdef Aggregate < handle
    % AGGREGATE functions for aggregating variables in different sessions
    
    % Revised by Richard J. Cui.
    % $Revision: 0.1 $  $Date: Fri 11/07/2014 11:09:04.541 PM $
    %
    % Barrow Neurological Institute
    % 350 W Thomas Road
    % Phoenix AZ 85013, USA
    %
    % Email: jie@neurocorrleate.com
    
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


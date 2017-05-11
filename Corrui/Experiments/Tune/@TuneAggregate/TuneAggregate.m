classdef TuneAggregate < EyeMovementAggregate
	% Class TUNEAGGREGATE manages functions to aggregate data in the
	%       analysis of orientaiton tuning curve

	% Copyright 2012 Richard J. Cui. Created: Thu 09/27/2012 10:30:18.851 AM
	% $Revision: 0.1 $  $Date: Thu 09/27/2012 10:30:18.851 AM $
    %
    % Visual Neuroscience Lab (Dr. Martinez-Conde)
    % Barrow Neurological Institute
    % 350 W Thomas Road
    % Phoenix AZ 85013, USA
    %
    % Email: jie@neurocorrleate.com

    properties 
 
    end % properties
 
    methods
        function this = TuneAggregate()
            
        end
    end % methods
    
    methods (Static)
        [mn se] = AggOrtTuneData( curr_exp, sessionlist, S)
    end % static methods
    
end % classdef

% [EOF]

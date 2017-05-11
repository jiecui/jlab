classdef MscLedAggregate < EyeMovementAggregate
	% Class MSCLEDAGGREGATE (summary)

	% Copyright 2012 Richard J. Cui. Created: Tue 09/03/2013 12:42:11.898 PM
	% $Revision: 0.1 $  $Date: Tue 09/03/2013 12:42:11.898 PM $
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
        function this = MscLedAggregate()
            
        end
    end % methods
    
    methods (Static)
        [mn, se] = AggMSTrigMldResp( curr_exp, sessionlist, S)
        [mn, se] = AggSaccadeProps(curr_exp, sessionlist, S)
    end % static methods
    
end % classdef

% [EOF]

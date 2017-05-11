classdef BlankCtrlAggregate < EyeMovementAggregate
	% Class BLANKCTRLAGGREGATE (summary)

	% Copyright 2012 Richard J. Cui. Created: Mon 08/13/2012  6:09:17.172 PM
	% $Revision: 0.1 $  $Date: Mon 08/13/2012  6:09:17.172 PM $
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
        function this = BlankCtrlAggregate()
            
        end
    end % methods
    
    methods (Static)
        [mn, se] = AggSaccadeProps(curr_exp, sessionlist, S)
        [mn, se] = AggMSTrigBctResp( curr_exp, sessionlist, S)
    end % static methods
    
end % classdef

% [EOF]

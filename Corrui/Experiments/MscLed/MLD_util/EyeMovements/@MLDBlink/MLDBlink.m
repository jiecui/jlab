classdef MLDBlink < EyeBlink
	% Class MLDBLINK offers basic operations for the saccade data collected in MLD experiments

	% Copyright 2013 Richard J. Cui. Created: Mon 05/06/2013 11:40:33.064 AM
	% $Revision: 0.1 $  $Date: Mon 05/06/2013 11:40:33.064 AM $
    %
    % Barrow Neurological Institute
    % 350 W Thomas Road
    % Phoenix AZ 85013, USA
    %
    % Email: jie@neurocorrleate.com

    properties 
        db                  % database
        sname               % session name
    end % properties
 
    % the constructor
    methods 
        function this = MLDBlink(curr_exp, sname)
            % Inputs:
            %   sname   - session / block name
            this.db = curr_exp.db;
            this.sname = sname;
            this.import_basic_blink_vars;
        end
    end % methods
    
    % other methods
    methods

    end % methods
    
    methods ( Static )
        blink_props_enum = getEnum()    
        blink_props = getprops( blinkYesNo, samplerate, isInTrialSequence, isInTrialCond, em_events, enum_event )
        bp_size = blink_props_size()
    end % static methods
end % classdef

% [EOF]

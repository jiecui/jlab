classdef BCTSacc < EyeSacc
	% Class BCTSACC offers basic operations for the saccade data collected in BCT experiments

	% Copyright 2013 Richard J. Cui. Created: Mon 05/06/2013 11:40:33.064 AM
	% $Revision: 0.1 $  $Date: Mon 05/06/2013 11:40:33.064 AM $
    %
    % Visual Neuroscience Lab (Dr. Martinez-Conde)
    % Barrow Neurological Institute
    % 350 W Thomas Road
    % Phoenix AZ 85013, USA
    %
    % Email: jie@neurocorrleate.com

    properties 
        sname
        db
    end % properties
 
    % the constructor
    methods 
        function this = BCTSacc(curr_exp, sname)
            % Inputs:
            %   sname   - session / block name
            this.db = curr_exp.db;
            this.sname = sname;
            
        end
    end % methods
    
    % other methods
    methods

    end % methods
    
    methods ( Static )
        sacc_props_enum = getEnum()    
        saccade_props = getprops( eyedat, sac , samplerate, isInTrialSequence, isInTrialCond, sc_events, enum_event )
        sp_size = sacc_props_size()
    end % static methods
end % classdef

% [EOF]

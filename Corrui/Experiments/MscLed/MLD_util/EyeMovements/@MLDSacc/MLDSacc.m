classdef MLDSacc < EyeSacc
	% Class MLDSACC offers basic operations for the saccade data collected in MLD experiments

	% Copyright 2014 Richard J. Cui. Created: Tue 07/01/2014 10:11:07.088 PM
	% $Revision: 0.1 $  $Date:Tue 07/01/2014 10:11:07.088 PM $
    %
    % Barrow Neurological Institute
    % 350 W Thomas Road
    % Phoenix AZ 85013, USA
    %
    % Email: jie@neurocorrleate.com

    properties 
        db          % database
        sname       % session name
    end % properties
 
    % the constructor
    methods 
        function this = MLDSacc(curr_exp, sname)
            % Inputs:
            %   sname   - session / block name
            this.db = curr_exp.db;
            this.sname = sname;
            this.read_basic_eyesacc_vars;
          
        end
    end % methods
    
    % other methods
    methods

    end % methods
    
    methods ( Static )
        sacc_props_enum = getEnum()    
        saccade_props = getprops( eyedat, sac , samplerate, isInTrialSequence, isInTrialCond, sc_events, enum_event )
        sp_size = saccade_props_size()
    end % static methods
end % classdef

% [EOF]

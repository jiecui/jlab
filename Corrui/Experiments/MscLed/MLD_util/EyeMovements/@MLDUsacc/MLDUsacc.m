classdef MLDUsacc < EyeUsacc
	% Class MLDUSACC offers basic operations for the microsaccade data collected in MLD experiments

	% Copyright 2013-2014 Richard J. Cui. Created: Mon 05/06/2013 11:40:33.064 AM
	% $Revision: 0.1 $  $Date: Wed 07/02/2014  8:31:35.508 AM $
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
        function this = MLDUsacc(curr_exp, sname)
            % Inputs:
            %   sname   - session / block name
            this.sname = sname;
            this.db = curr_exp.db;
            this.read_basic_eyeusacc_vars;
        end
    end % methods
    
    % other methods
    methods

    end % methods
    
    methods ( Static )
        usacc_props_enum = getEnum()    
        usacc_props = getprops( eyedat, usac , samplerate, isInTrialSequence, isInTrialCond, em_events, enum_event )
        up_size = usacc_props_size()     % overwrite
    end % static methods
end % classdef

% [EOF]

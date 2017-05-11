classdef MLDFixation < EyeFixation
	% Class MLDFIXATION offers basic operations for the fixation data collected in MLD experiments

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
        db                      % database
        sname                   % session name
    end % properties
 
    % the constructor
    methods 
        function this = MLDFixation(curr_exp, sname)
            % Inputs:
            %   sname   - session / block name
            this.db = curr_exp.db;
            this.sname = sname;
            this.import_basic_fixation_vars;
        end
    end % methods
    
    % other methods
    methods

    end % methods
    
    methods ( Static )
        fixation_props_enum = getEnum()    
        fixation_props = getprops( blinkYesNo, saccadeYesNo, isInTrial, isInTrialSequence, isInTrialCond, samplerate, usacc_props, enum_usacc_props )
        fp_size = fixation_props_size()
    end % static methods
end % classdef

% [EOF]

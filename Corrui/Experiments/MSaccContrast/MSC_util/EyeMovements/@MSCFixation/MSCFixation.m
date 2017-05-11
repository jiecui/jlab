classdef MSCFixation < EyeFixation
	% Class MSCFIXATION offers basic operations for the fixation data collected in AEC experiments

	% Copyright 2014-2016 Richard J. Cui. Created: Mon 05/06/2013 11:40:33.064 AM
	% $Revision: 0.3 $  $Date: Fri 08/05/2016  3:02:53.645 PM $
    %
    % 3236 E Chandler Blvd Unit 2036
    % Phoenix, AZ 85048, USA
    %
    % Email: richard.jie.cui@gmail.com

    properties 
        db                      % database
        sname                   % session name
    end % properties
 
    % the constructor
    methods 
        function this = MSCFixation(curr_exp, sname)
            % Inputs:
            %   sname   - session / block name
            this.db = curr_exp.db;
            this.sname = sname;
            this.import_basic_fixation_vars;
        end
    end % methods
    
    % other methods
    methods
        fixation_props = getprops( this, general_fixation_props, isInTrialNumber, isInTrialCond, isInCycle, isInTrialStage )
    end % methods
    
    methods ( Static )
        [props_enum, props_size] = getEnum()
    end % static methods
    
end % classdef

% [EOF]
